# Relatorio de Mudancas (2026-02-07)

## Escopo (o que foi atacado)
- Transferencia de estoque em modo `DATA_SOURCE_MODE=api` estava baseada em varias chamadas CRUD no Supabase (estado parcial/concorrencia).
- No Supabase Studio, varias tabelas apareciam como `UNRESTRICTED` (RLS desligado), o que e risco em ambiente multi-tenant.

## Mudancas no Supabase (banco)
Aplicado no projeto Supabase via Management API (SQL executado no Postgres do Supabase).

### 1) RPC transacional de transferencia
Arquivo (SQL versionado no repo, para reaplicar/inspecionar):
- `backend/scripts/supabase_rpc_transfer_stock.sql`

O que foi criado/ajustado:
- `public.rpc_transfer_stock(...) returns jsonb`
- Lock pessimista (`FOR UPDATE`) nos saldos de origem para impedir saldo negativo sob concorrencia.
- Idempotencia baseada em `idempotency_keys` (chave composta em texto `tenant_id:idempotency_key`) + `pg_advisory_xact_lock(...)`.
- UPSERT do saldo de destino na linha com `position_id is null`.
- Ledger: grava `stock_movements` (OUT e IN) e cria `transfer_requests` + `transfer_items`.

Invariantes adicionadas:
- Unique index para garantir 1 linha "null position" por (tenant, product, warehouse):
  - `stock_balances_uq_null_position` com predicado `where position_id is null`
- Constraint de nao-negatividade (nao validada automaticamente por legado):
  - `stock_balances_quantity_nonneg` com `NOT VALID`

### 2) Hardening de seguranca (RLS e permissoes)
Arquivo (SQL versionado no repo, para reaplicar/inspecionar):
- `backend/scripts/supabase_rls_backend_only.sql`

O que foi feito:
- Habilitado RLS (Row Level Security) nas tabelas do dominio (antes apareciam como `UNRESTRICTED`).
- RPC `rpc_transfer_stock`:
  - Removido `EXECUTE` para `anon` e `authenticated`
  - Mantido `EXECUTE` apenas para `service_role`

Impacto esperado:
- Chaves publishable/anon nao conseguem mais ler/escrever essas tabelas diretamente via `/rest/v1/*` sem policies.
- O backend continua funcionando porque usa `service_role` (bypass RLS).

### SQL aplicado (completo)

<!-- BEGIN:SUPABASE_SQL -->
Abaixo esta o SQL exato aplicado no Supabase (mesmo conteudo dos arquivos do repo).

#### backend/scripts/supabase_rpc_transfer_stock.sql
```sql
-- Supabase (PostgreSQL) migration: transactional stock transfer via RPC
-- Target project: any Supabase Postgres using the standard inventory schema.
--
-- Goals:
-- - Atomic transfer (debit origin + credit destination + ledger + transfer header/items)
-- - Pessimistic locking (FOR UPDATE) to prevent negative balances under concurrency
-- - Idempotency via (tenant_id + idempotency_key) gate using advisory locks
-- - Safe destination upsert for the "null position" balance row
--
-- Notes:
-- - This migration is designed to be applied on Supabase Postgres (not SQLite).
-- - `lock_timeout` is set to avoid hanging requests indefinitely; tune as needed.

-- 1) Invariant: only one "null position" row per (tenant, product, warehouse)
-- This enables safe UPSERT for destination balance without creating duplicates.
create unique index if not exists stock_balances_uq_null_position
on public.stock_balances (tenant_id, product_id, warehouse_id)
where position_id is null;

-- 2) Invariant: forbid negative stock for new/updated rows.
-- NOT VALID avoids failing the migration if legacy rows are already negative.
do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'stock_balances_quantity_nonneg'
  ) then
    alter table public.stock_balances
      add constraint stock_balances_quantity_nonneg check (quantity >= 0) not valid;
  end if;
end $$;

-- 3) RPC: atomic stock transfer
create or replace function public.rpc_transfer_stock(
  p_tenant_id uuid,
  p_user_id uuid,
  p_origin_warehouse_id uuid,
  p_destination_warehouse_id uuid,
  p_reason text,
  p_items jsonb,
  p_idempotency_key uuid
) returns jsonb
language plpgsql
as $$
declare
  v_idem_key text;
  v_cached jsonb;
  v_transfer_id uuid;
  v_now timestamptz := now();
  v_reason text;
  v_item record;
  v_balance record;
  v_available int;
  v_remaining int;
  v_consumed int;
begin
  -- Basic validation
  if p_tenant_id is null then
    raise exception 'p_tenant_id is required' using errcode = '22023';
  end if;

  if p_idempotency_key is null then
    raise exception 'p_idempotency_key is required' using errcode = '22023';
  end if;

  if p_origin_warehouse_id is null or p_destination_warehouse_id is null then
    raise exception 'origin and destination warehouses are required' using errcode = '22023';
  end if;

  if p_origin_warehouse_id = p_destination_warehouse_id then
    raise exception 'origin and destination warehouses must be different' using errcode = '22023';
  end if;

  if p_items is null or jsonb_typeof(p_items) <> 'array' or jsonb_array_length(p_items) = 0 then
    raise exception 'p_items must be a non-empty array' using errcode = '22023';
  end if;

  v_idem_key := p_tenant_id::text || ':' || p_idempotency_key::text;

  -- Avoid unbounded waits under contention (backend maps lock errors to 409).
  perform set_config('lock_timeout', '10s', true);

  -- Idempotency gate: serialize per (tenant,idempotency_key).
  perform pg_advisory_xact_lock(hashtext(v_idem_key)::bigint);

  select response_body::jsonb
    into v_cached
  from public.idempotency_keys
  where key = v_idem_key
  limit 1;

  if v_cached is not null then
    return v_cached;
  end if;

  -- Validate warehouses belong to tenant and are active
  if not exists (
    select 1
    from public.warehouses
    where tenant_id = p_tenant_id
      and active = true
      and id = p_origin_warehouse_id
  ) then
    raise exception 'origin warehouse not found for tenant' using errcode = '22023';
  end if;

  if not exists (
    select 1
    from public.warehouses
    where tenant_id = p_tenant_id
      and active = true
      and id = p_destination_warehouse_id
  ) then
    raise exception 'destination warehouse not found for tenant' using errcode = '22023';
  end if;

  v_transfer_id := gen_random_uuid();
  v_reason :=
    coalesce(nullif(trim(p_reason), ''), 'Transferência Direta')
    || ' #'
    || left(v_transfer_id::text, 8);

  -- Create header first (FK for transfer_items points to transfer_requests).
  -- If any error happens later, the whole transaction is rolled back.
  insert into public.transfer_requests (
    id, tenant_id, origin_warehouse_id, destination_warehouse_id,
    status, reason, created_at, updated_at, created_by
  ) values (
    v_transfer_id, p_tenant_id, p_origin_warehouse_id, p_destination_warehouse_id,
    'APPROVED', coalesce(nullif(trim(p_reason), ''), 'Transferência Direta'),
    v_now, v_now, p_user_id
  );

  -- Process aggregated items in stable order to reduce deadlocks.
  for v_item in
    select
      (item->>'product_id')::uuid as product_id,
      sum((item->>'quantity')::int) as quantity
    from jsonb_array_elements(p_items) as item
    group by 1
    order by 1
  loop
    if v_item.product_id is null then
      raise exception 'invalid product_id in items' using errcode = '22023';
    end if;

    if v_item.quantity is null or v_item.quantity <= 0 then
      raise exception 'invalid quantity for product %', v_item.product_id using errcode = '22023';
    end if;

    -- Ensure product belongs to tenant
    if not exists (
      select 1
      from public.products
      where tenant_id = p_tenant_id
        and id = v_item.product_id
    ) then
      raise exception 'product % not found for tenant', v_item.product_id using errcode = '22023';
    end if;

    -- Lock origin balances for this product+warehouse and compute available.
    v_available := 0;
    for v_balance in
      select id, quantity
      from public.stock_balances
      where tenant_id = p_tenant_id
        and product_id = v_item.product_id
        and warehouse_id = p_origin_warehouse_id
      order by (position_id is null) desc, quantity desc, id
      for update
    loop
      v_available := v_available + v_balance.quantity;
    end loop;

    if v_available < v_item.quantity then
      -- Business error: insufficient stock
      raise exception 'insufficient stock for product %. required=%, available=%',
        v_item.product_id, v_item.quantity, v_available
      using errcode = 'P0001';
    end if;

    -- Consume stock across rows (incl. position balances) until fulfilled.
    v_remaining := v_item.quantity;
    for v_balance in
      select id, quantity
      from public.stock_balances
      where tenant_id = p_tenant_id
        and product_id = v_item.product_id
        and warehouse_id = p_origin_warehouse_id
      order by (position_id is null) desc, quantity desc, id
      for update
    loop
      exit when v_remaining <= 0;

      if v_balance.quantity <= 0 then
        continue;
      end if;

      v_consumed := least(v_balance.quantity, v_remaining);

      update public.stock_balances
      set quantity = quantity - v_consumed,
          last_count = v_now
      where id = v_balance.id;

      v_remaining := v_remaining - v_consumed;
    end loop;

    if v_remaining > 0 then
      raise exception 'insufficient stock while applying transfer for product %', v_item.product_id using errcode = 'P0001';
    end if;

    -- Credit destination into the null position balance (upsert).
    insert into public.stock_balances (tenant_id, product_id, warehouse_id, position_id, quantity, last_count)
    values (p_tenant_id, v_item.product_id, p_destination_warehouse_id, null, v_item.quantity, v_now)
    on conflict (tenant_id, product_id, warehouse_id) where position_id is null
    do update set quantity = public.stock_balances.quantity + excluded.quantity,
                  last_count = excluded.last_count;

    -- Ledger rows (summary per product).
    insert into public.stock_movements (
      id, tenant_id, product_id, warehouse_id, position_id,
      type, quantity, direction,
      reason, reference_id, created_at, created_by
    ) values
      (gen_random_uuid(), p_tenant_id, v_item.product_id, p_origin_warehouse_id, null,
       'OUT', v_item.quantity, -1,
       v_reason, v_transfer_id::text, v_now, p_user_id),
      (gen_random_uuid(), p_tenant_id, v_item.product_id, p_destination_warehouse_id, null,
       'IN', v_item.quantity, 1,
       v_reason, v_transfer_id::text, v_now, p_user_id);

    -- Transfer item row (aggregated per product).
    insert into public.transfer_items (id, transfer_id, product_id, quantity)
    values (gen_random_uuid(), v_transfer_id, v_item.product_id, v_item.quantity);
  end loop;

  v_cached := jsonb_build_object(
    'transfer_id', v_transfer_id,
    'idempotent', false
  );

  insert into public.idempotency_keys (key, response_body, status_code, created_at)
  values (v_idem_key, v_cached::text, 201, v_now)
  on conflict (key) do nothing;

  return v_cached;
end;
$$;

```

#### backend/scripts/supabase_rls_backend_only.sql
```sql
-- Supabase hardening: enable RLS on app tables (backend-only access)
--
-- "UNRESTRICTED" in Supabase Studio indicates RLS is disabled.
-- If a publishable/anon key leaks, those tables may become readable/writable via PostgREST.
--
-- This script enables RLS (no policies) on core app tables so:
-- - anon/authenticated cannot access them directly via Supabase REST API
-- - server-side access via `service_role` continues to work (bypassrls=true)
--
-- IMPORTANT:
-- - This assumes your application uses ONLY the backend server key to talk to Supabase.
-- - If you intend to access these tables directly from the browser, you must add RLS policies instead.

-- Core domain tables
alter table if exists public.tenants enable row level security;
alter table if exists public.users enable row level security;
alter table if exists public.products enable row level security;
alter table if exists public.warehouses enable row level security;
alter table if exists public.warehouse_zones enable row level security;
alter table if exists public.warehouse_positions enable row level security;
alter table if exists public.stock_balances enable row level security;
alter table if exists public.stock_movements enable row level security;
alter table if exists public.transfer_requests enable row level security;
alter table if exists public.transfer_items enable row level security;
alter table if exists public.purchase_orders enable row level security;
alter table if exists public.purchase_items enable row level security;
alter table if exists public.suppliers enable row level security;

-- Assets / responsibility
alter table if exists public.assets enable row level security;
alter table if exists public.asset_history enable row level security;
alter table if exists public.responsibility_terms enable row level security;

-- Service orders (OS)
alter table if exists public.service_orders enable row level security;
alter table if exists public.service_order_items enable row level security;

-- Infra/support
alter table if exists public.audit_logs enable row level security;
alter table if exists public.idempotency_keys enable row level security;

-- Restrict RPC execution to server key only (recommended).
do $$
begin
  if exists (
    select 1
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public'
      and p.proname = 'rpc_transfer_stock'
  ) then
    -- Supabase may auto-grant EXECUTE to anon/authenticated explicitly, so revoke those too.
    revoke execute on function public.rpc_transfer_stock(uuid,uuid,uuid,uuid,text,jsonb,uuid) from public;
    revoke execute on function public.rpc_transfer_stock(uuid,uuid,uuid,uuid,text,jsonb,uuid) from anon;
    revoke execute on function public.rpc_transfer_stock(uuid,uuid,uuid,uuid,text,jsonb,uuid) from authenticated;
    grant execute on function public.rpc_transfer_stock(uuid,uuid,uuid,uuid,text,jsonb,uuid) to service_role;
  end if;
end $$;
```
<!-- END:SUPABASE_SQL -->

## Mudancas no backend (Fastify)

### 1) Transferencias migradas para RPC
Arquivo:
- `backend/src/modules/transfers/transfers.routes.ts`

O que mudou:
- Em modo `api`, o `POST /transfers` agora faz 1 unica chamada:
  - `POST /rest/v1/rpc/rpc_transfer_stock`
- Tratamento de erro mapeado por SQLSTATE (retornado pelo Supabase):
  - `P0001` -> HTTP 422 (saldo insuficiente)
  - `55P03` / `40P01` -> HTTP 409 (lock/deadlock)
  - `22023` / `22P02` -> HTTP 400 (payload/uuid invalido)

### 2) Supabase client do backend agora exige service_role
Arquivo:
- `backend/src/infra/supabase.ts`

O que mudou:
- `DATA_SOURCE_MODE=api` passa a exigir `SUPABASE_SERVICE_ROLE_KEY` (anon/publishable nao e mais suficiente quando RLS esta habilitado).

### 3) Suíte de testes API mode expandida para transferencias (RPC)
Arquivos:
- `backend/src/modules/transfers/transfers.rpc.api.test.ts`
- `backend/vitest.api.config.ts`

Cobertura adicionada:
- Idempotencia via `Idempotency-Key` (nao debita/credita duas vezes).
- Concorrencia (10 requisicoes paralelas com saldo 5 -> 5 sucessos e 5 falhas controladas).
- Tenant leak guard (warehouses de tenants diferentes nao podem ser usados na mesma transferencia).

### 4) Variaveis de ambiente documentadas
Arquivo:
- `backend/.env.example`

O que mudou:
- Exemplo de configuracao para `DATA_SOURCE_MODE=api` e `postgres`.
- Nota explicita: com RLS habilitado, publishable/anon nao funciona para backend-only.

### 5) Fix: Movements (API mode) + compilacao
Arquivos:
- `backend/src/modules/inventory/movements.routes.ts`
- `backend/src/modules/inventory/movements.api.stock-consumption.test.ts`

O que mudou:
- Corrigido erro de compilacao (trecho duplicado no final do arquivo gerava `TS1128`/`TS1005`).
- Em `DATA_SOURCE_MODE=api`, `POST /movements` (OUT sem `positionId`) agora consome o saldo do deposito mesmo quando o estoque esta armazenado em posicoes.
- Timeout do teste de integracao ajustado para evitar flakiness (chamadas ao Supabase podem ultrapassar 5s).

## Docs/artefatos atualizados
- `API_CATALOG.md`: contrato de `POST /transfers` (RPC) e observacoes de `POST /movements` (consumo sem `positionId`) revisados.
- `FEATURE_LEDGER.md`: data de atualizacao.
- `SESSION_MEMENTO.md`: registro da migracao de transferencia via RPC.
- `.context/docs/README.md`: notas de testes e referencias a guias gerados.
- `.context/docs/RELATORIO_MUDANCAS_2026-02-07.md`: passou a incluir o SQL aplicado no Supabase (RPC + RLS) na integra.

## Validacao (o que foi executado)
Backend:
- `cd backend; npm run build`
- `cd backend; npm run test` (suite API-first)

Frontend:
- `cd src; npm run build` (inclui `npm run test`)

Checks manuais/tecnicos:
- Confirmado que RLS ficou habilitado nas tabelas principais.
- Confirmado que `anon`/`authenticated` nao tem `EXECUTE` na `rpc_transfer_stock`.
- `./scripts/MAke_safe.exe` (Backend Types + Frontend Test/Build): APPROVED

## Snapshots (seguranca)
Foram criados commits de snapshot automaticos ao longo do trabalho (ver `git log`), por exemplo:
- `2651628`
- `12efdd8`

## Estado atual do workspace (Git)
Ha mudancas locais ainda nao comitadas (resumo do `git status`).

Arquivos modificados (tracked):
- `.context/docs/RELATORIO_MUDANCAS_2026-02-07.md`
- `API_CATALOG.md`

Arquivos novos (untracked):
- `.context/workflow/update_report_supabase_sql.ps1`

## Observacoes e pendencias
- Foi detectado pelo menos 1 registro com `stock_balances.quantity < 0` no banco. Antes de validar a constraint `stock_balances_quantity_nonneg`, precisa corrigir o legado.
- Se, no futuro, o frontend for acessar Supabase direto, sera necessario criar policies RLS (hoje o modo esta "backend-only").
