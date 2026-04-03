# Relatorio de Mudancas (2026-02-08)

## Objetivo
Estabilizar o "básico 100% utilizável" (cadastro + movimentações/transferências) em modo `DATA_SOURCE_MODE=api` com Supabase, removendo fontes comuns de erro operacional:
- tenant errado (dados "sumindo" por header não enviado)
- saldo negativo legado quebrando constraints
- ledger vazio com saldo existente (histórico/confiança/reconcile)

## Mudancas no código (repo)

### 1) Tenancy: aceitar UUID determinístico (Postgres) em todo o stack
Problema:
- O tenant padrão do projeto usa o ID determinístico `00000000-0000-0000-0000-000000000001`.
- O frontend e o backend validavam UUID com regex estrita RFC4122 (v1-5 + variant), o que fazia esse tenant ser ignorado e o header `x-tenant-id` não ser enviado/aceito.
- Resultado: a UI podia "cair" em outro tenant (ex.: tenant de teste) e parecer que dados tinham sumido.

Correção:
- Normalizamos a validação para um formato aceito pelo tipo `uuid` do Postgres: `8-4-4-4-12` hex (sem exigir versão/variant).

Arquivos ajustados:
- `backend/src/plugins/context.ts`
- `backend/src/plugins/auth.ts`
- `backend/src/modules/products/products.routes.ts`
- `backend/src/modules/inventory/movements.routes.ts`
- `backend/src/modules/transfers/transfers.routes.ts`
- `backend/src/modules/assets/assets.service.ts`
- `backend/src/modules/purchases/purchases.routes.ts`
- `src/src/services/httpClient.ts`
- `src/src/features/auth/hooks/useAuth.ts`

### 2) Reconcile: proteção contra wipe + bootstrap do ledger + sanitização de negativos
Arquivos:
- `backend/scripts/reconcile_stock.ts`
- `docs/LISTA_MESTRE_TAREFAS.md` (nota de segurança/uso)

O que mudou:
- `--apply` agora recusa automaticamente quando detecta cenário perigoso (`ledger=0` e `balance!=0`) para evitar zerar estoque por engano.
- Novo modo `--bootstrap-ledger`:
  - Insere movimentos `ADJUST` (um por linha de `stock_balances`) quando o ledger está zerado mas há saldo, criando um "baseline" consistente.
  - Idempotente por linha via `reference_id = BOOTSTRAP_BALANCE_<balance_id>`.
- Novo modo `--sanitize-negatives`:
  - Corrige saldos negativos em `stock_balances` redistribuindo o déficit de outras linhas do mesmo produto (preserva total do produto).
  - Requer `--apply` para executar de fato; aborta se não conseguir compensar (a menos que `--force`).

## Mudancas aplicadas no Supabase (dados)

### 1) Sanitização de saldo negativo (tenant principal)
Foi encontrado 1 saldo negativo legado:
- Produto: `Conector Óptico SC/APC Verde`
- Depósito: `Sede Principal (Depósito)`
- Quantidade: `-38`

Para cumprir a invariável `quantity >= 0` e evitar falhas por constraint, foi aplicado o ajuste preservando o total do produto:
- `Sede Principal (Depósito)`: `-38 -> 0`
- `Carro 01 - Técnico João`: `138 -> 100`

Execução:
- `cd backend; npm run reconcile:stock -- --mode api --tenant 00000000-0000-0000-0000-000000000001 --sanitize-negatives --apply`

### 2) Bootstrap do ledger (tenant principal)
Após sanitizar o negativo, havia 25 linhas com `ledger=0` e `balance!=0`.
Para evitar inconsistência (saldo existe sem histórico) e permitir reconcile seguro, foi executado:
- `cd backend; npm run reconcile:stock -- --mode api --tenant 00000000-0000-0000-0000-000000000001 --bootstrap-ledger --apply`

Resultado:
- `reconcile:stock` passou a retornar **0 divergências** para o tenant principal.

## Validacao
- `cd backend; npm run build`
- `cd backend; npm test`
- `cd src; npm run build`
- `cd src; npm test`
- `cd backend; npm run reconcile:stock -- --mode api --tenant 00000000-0000-0000-0000-000000000001` (OK, sem divergências)

