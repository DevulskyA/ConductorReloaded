# Plano de Correcao Geral (2026-02-08)

## Premissas (decisao arquitetural)
1. Persistencia principal: **Supabase Postgres**.
2. Integracao do app: **backend-only** (Fastify) falando com Supabase via `service_role`.
3. Frontend fala **apenas com o backend** (nao usa `/rest/v1/*` direto no browser).
4. Operacoes criticas compostas devem ser **atomicas no banco** (RPC/transaction), com idempotencia.

Isso reduz superficie publica e elimina estados parciais em operacoes como transferencia de estoque.

## Diagnostico do problema (o que causou os bugs)
- Houve drift externo: parte do backend ficou com rotas montadas mas ainda dependentes de `db` (Drizzle) mesmo com `DATA_SOURCE_MODE=api`.
- Em `DATA_SOURCE_MODE=api`, `db` vira um Proxy que falha por design, gerando `500`/crash em rotas nao migradas.
- Multi-tenant: quando auth e bypassado no dev, o `tenantId` cai em fallback (UUID default) se o cliente nao envia `x-tenant-id`.
- UI consumia endpoints que estavam incompletos (ex.: `GET /products/:id`) e/ou recebia payloads com formato/tempo incorreto (assets/history com `createdAt` nao numerico).

## Objetivo de sucesso (definition of done)
- `DATA_SOURCE_MODE=api` executa **todas as telas principais** sem `500` e com dados consistentes.
- Transferencia e movimentacoes atualizam saldo de forma correta e previsivel (sem duplicar linhas por posicao no resumo por deposito).
- Todas as rotas usadas pelo frontend sao tenant-scoped.
- Build + testes passam (backend + frontend), e docs/contratos refletem o comportamento atual.

## Fase 0: Seguranca e Configuracao (P0)
1. Rotacionar qualquer chave exposta (service_role/secret).
2. Garantir que secrets ficam apenas em `backend/.env` (gitignored) e nunca no frontend.
3. Confirmar modo atual:
   - `DATA_SOURCE_MODE=api`
   - `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY` presentes
   - `DEFAULT_TENANT_ID` (UUID real do tenant que voce quer visualizar no dev, se estiver sem auth/JWT)

## Fase 1: Paridade API Mode para UI (P0)
Checklist de rotas usadas pela UI:
- Produtos: `GET /products`, `GET /products/:id`, `POST/PUT/DELETE /products`.
- Estoque: `GET/POST /inventory/movements` + reconcile.
- Depositos: `GET/POST /inventory/warehouses`.
- Transferencias: `GET/POST /transfers` (API mode via RPC atomica).
- Enderecamento: `GET/POST /inventory/locations/zones|positions`.
- Ativos: `GET/POST /assets`, `POST /assets/:id/transition`, `GET /assets/:id/history`.
- Compras: `GET/POST /purchases/suppliers`, `GET/POST /purchases/orders`.
- Busca: `GET /search?q=...`.
- Usuarios: `GET /auth/users` (para atribuicao em ativos).

Status (ate 2026-02-08):
- Migrado/funcional em API mode: Produtos, Movements, Warehouses, Transfers (RPC), Locations, Assets, Search, Purchases, Auth lookups.

## Fase 2: Integridade de Dados e Invariantes (P0/P1)
1. Estoque nao-negativo:
   - Corrigir quaisquer registros legados com `stock_balances.quantity < 0`.
   - Validar constraints/indexes (ex.: unique null-position por (tenant,product,warehouse)).
2. Multi-tenant (evitar drift de tenant):
   - Bloquear auto-criacao silenciosa de tenants via rotas de dominio.
   - Exigir tenant existente (ou permitir apenas em bootstrap dev/test via `ALLOW_TENANT_AUTO_CREATE=true`).
   - Meta: se `x-tenant-id` estiver errado, falhar com 400 em vez de "criar um tenant vazio" e aparentar perda de dados.
3. Auditoria:
   - Padronizar `audit_logs` para eventos criticos (produto criado/alterado, transferencias, compras).
4. Idempotencia:
   - Garantir header `Idempotency-Key` em todas as mutacoes que podem ser re-tentadas (movements, transfers, compras).

## Fase 3: Observabilidade e Depuracao (P1)
1. Padronizar erros HTTP (400/401/403/409/422/500) com mensagens consistentes para UI.
2. Logs com `reqId` + `tenantId` sempre presentes.
3. Criar smoke tests de fluxo (E2E minimo via `app.inject`) para:
   - Criar deposito + produto + entrada
   - Transferir
   - Validar saldo em `GET /products`

## Fase 4: Decisao sobre Browser Direto x Backend-only (P1)
Se o objetivo for **browser direto no Supabase**:
- Implementar Supabase Auth no frontend.
- Escrever policies RLS multi-tenant (testadas) por tabela.
- Reavaliar exposicao de RPCs (EXECUTE apenas para roles corretas, sem `service_role` no cliente).

Se mantiver **backend-only** (recomendado no curto prazo):
- Manter RLS habilitado sem policies (nega por padrao) e usar apenas `service_role` no servidor.
- Garantir que toda query do backend inclui `tenant_id=eq.<tenantId>` e validacoes cross-tenant.

## Fase 5: UX (P2)
1. Resumo de estoque por deposito quando houver muitos locais:
   - Mostrar top N + "ver mais" (ou tooltip/expansao).
2. Otimizar carregamento:
   - Evitar N+1 no backend (joins/queries compostas ou endpoints agregados).
3. Melhorar reconciliacao pos-mutation:
   - Apos mutacoes, forcar refetch/invalidate para sincronizar com o banco real.
