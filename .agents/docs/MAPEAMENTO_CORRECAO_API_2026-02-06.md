# Mapeamento Completo para Correcao API-First (2026-02-06)

## 1) Diagnostico objetivo

### 1.1 Estado real do backend hoje
- O backend esta majoritariamente SQL-first (Drizzle + DB relacional), nao API-first.
- `backend/src/server.ts` chama `ensureDatabaseReady()` antes de subir o servidor.
- `backend/src/db/index.ts` resolve `DATA_SOURCE_MODE` (`api` ou `postgres`), mas:
  - em `api`, apenas valida conectividade Supabase REST;
  - o objeto `db` vira um proxy que falha quando qualquer rota tenta usar SQL.
- Como quase todas as rotas/servicos ainda dependem de `db`, `DATA_SOURCE_MODE=api` nao sustenta runtime funcional completo.

### 1.2 Metrica de dependencia SQL (levantamento atual)
- Arquivos com import direto de `db`: **39**
- Arquivos de rota (`*.routes.ts`) no backend: **11**
- Arquivos de rota com dependencia direta de `db`: **7**
- Services (`*.service.ts`) no backend: **8**
- Services com dependencia direta de `db`: **8**

## 2) Cadeia de inicializacao

1. `backend/src/server.ts`
2. `backend/src/db/index.ts::ensureDatabaseReady()`
3. `backend/src/app.ts::buildApp()`
4. Registro de modulos e rotas Fastify

Conclusao: o gargalo atual nao esta em `server.ts`; esta no bootstrap de persistencia e no acoplamento SQL em toda a camada de dominio/rotas.

## 3) Mapa de rotas backend (efetivamente registradas)

Fonte: `backend/src/app.ts` + arquivos de rota.

- `POST /auth/login`
- `POST /auth/refresh`
- `POST /auth/logout`
- `GET /auth/me`
- `GET /auth/users`
- `GET /products`
- `POST /products`
- `PUT /products/:id`
- `DELETE /products/:id`
- `GET /inventory/movements`
- `POST /inventory/movements`
- `POST /inventory/movements/reconcile`
- `GET /inventory/movements/putaway-suggestion`
- `GET /inventory/movements/abc-analysis`
- `GET /inventory/warehouses`
- `POST /inventory/warehouses`
- `GET /inventory/locations/zones`
- `POST /inventory/locations/zones`
- `GET /inventory/locations/positions`
- `POST /inventory/locations/positions`
- `POST /inventory/rma/inspect`
- `GET /inventory/rma/warehouse`
- `GET /transfers`
- `POST /transfers`
- `GET /assets`
- `POST /assets`
- `GET /assets/:id`
- `GET /assets/:id/history`
- `POST /assets/:id/transition`
- `GET /search`
- `GET /webhooks/os`
- `GET /purchases/suppliers`
- `POST /purchases/suppliers`
- `GET /purchases/orders`
- `POST /purchases/orders`
- `GET /events`

Observacao importante:
- `backend/src/modules/assets/terms.routes.ts` **existe**, mas **nao esta registrado** em `backend/src/app.ts`.

## 4) Mapa de consumo frontend (padroes de endpoint)

Principais consumidores:
- `src/src/services/inventoryService.ts`
- `src/src/services/userService.ts`
- `src/src/features/stock-transfers/services/transferService.ts`
- `src/src/features/purchases/services/purchaseService.ts`
- `src/src/features/auth/hooks/useAuth.ts`

Endpoints utilizados pelo frontend:
- `/auth/login`
- `/auth/refresh`
- `/auth/users`
- `/products`
- `/products/${id}`
- `/products?includeInactive=true`
- `/movements`
- `/movements/reconcile`
- `/warehouses`
- `/locations/zones`
- `/locations/positions`
- `/transfers`
- `/assets`
- `/assets/${id}/transition`
- `/assets/${id}/history`
- `/search?q=${encodeURIComponent(query)}`
- `/purchases/suppliers`
- `/purchases/orders`

## 5) Drift de contrato (frontend x backend)

### 5.1 Mismatches confirmados
- Front usa `/movements`; backend expoe `/inventory/movements`.
- Front usa `/warehouses`; backend expoe `/inventory/warehouses`.
- Front usa `/locations/*`; backend expoe `/inventory/locations/*`.

### 5.2 Implicacao
- Mesmo com backend ligado, parte da UI pode falhar por 404/route mismatch.
- Isso independe de Postgres/Supabase; e drift de contrato HTTP.

## 6) Drift arquitetural detectado

Comparacao com `origin/master`:
- `backend/src/db/index.ts` mudou de `drizzle-orm/libsql` + `@libsql/client` para `drizzle-orm/node-postgres` + `pg` (alem do modo `api/postgres`).
- `backend/package.json` trocou comandos de migracao `sqlite` para `pg`.
- `backend/src/infra/supabase.ts` saiu de `@supabase/supabase-js` para cliente REST customizado.
- Ha remocoes no diretorio de migracoes `backend/drizzle/`.

Leitura tecnica:
- O codigo atual esta em estado hibrido/transicional, com contrato API parcial e dominio ainda SQL-coupled.

## 7) Mapa de risco para correcao

### Risco alto
- Migrar tudo para API sem camada de abstracao vai quebrar 8 services e 7 arquivos de rota acoplados em `db`.
- Modo `api` atual passa no bootstrap, mas falha ao executar fluxos que tocam SQL.

### Risco medio
- Endpoint drift frontend/backend gera regressao funcional silenciosa em telas de inventario.

### Risco baixo
- Ajustes de env (`DATA_SOURCE_MODE`, chaves Supabase) sao simples, mas nao resolvem o acoplamento estrutural.

## 8) Plano de correcao (sequencia segura)

### Fase A - Contratos HTTP (primeiro)
1. Definir endpoint canonico (manter `/inventory/*` ou voltar alias curtos).
2. Ajustar frontend OU adicionar aliases temporarios no backend.
3. Cobrir com testes de contrato por rota.

### Fase B - Abstracao de persistencia (obrigatoria)
1. Criar interface de repositorio (ex.: `InventoryRepository`, `ProductsRepository`).
2. Adapter SQL atual vira implementacao `SqlRepository`.
3. Adapter Supabase REST vira `SupabaseApiRepository`.
4. Services passam a depender da interface, nao de `db` diretamente.

### Fase C - API-first real
1. Implementar operacoes prioritarias no adapter REST (products, movements, warehouses, transfers).
2. Habilitar `DATA_SOURCE_MODE=api` sem proxy de erro.
3. Manter `postgres` como fallback ate cobertura total.

### Fase D - Fechamento de gaps funcionais
1. Registrar `termsRoutes` em `backend/src/app.ts` (se aprovado).
2. Alinhar `AssetTermoModal` com endpoints de termo reais.
3. Atualizar docs contratuais (`API_CATALOG.md`, `API_INDEX.md`, `FEATURE_LEDGER.md`) apos cada bloco fechado.

## 9) Arquivos-chave para iniciar a correcao

- Bootstrap/persistencia:
  - `backend/src/db/index.ts`
  - `backend/src/infra/supabase.ts`
- Rotas com SQL direto:
  - `backend/src/modules/inventory/movements.routes.ts`
  - `backend/src/modules/inventory/warehouses.routes.ts`
  - `backend/src/modules/inventory/warehouse-locations.routes.ts`
  - `backend/src/modules/products/products.routes.ts`
  - `backend/src/modules/purchases/purchases.routes.ts`
  - `backend/src/modules/transfers/transfers.routes.ts`
  - `backend/src/modules/webhooks/os.routes.ts`
- Services SQL diretos:
  - `backend/src/core/inventory/stock.service.ts`
  - `backend/src/core/inventory/putaway.service.ts`
  - `backend/src/core/inventory/abc-analysis.service.ts`
  - `backend/src/modules/assets/assets.service.ts`
  - `backend/src/modules/assets/terms.service.ts`
  - `backend/src/modules/inventory/rma.service.ts`
  - `backend/src/modules/search/search.service.ts`
  - `backend/src/modules/transfers/transfer.service.ts`
- Frontend consumidor:
  - `src/src/services/inventoryService.ts`
  - `src/src/features/auth/hooks/useAuth.ts`
  - `src/src/features/stock-transfers/services/transferService.ts`
  - `src/src/features/purchases/services/purchaseService.ts`

## 10) Resultado do mapeamento

Mapeamento concluido para habilitar correcao segura, com:
- topologia,
- pontos de acoplamento SQL,
- drift de contrato HTTP,
- plano em fases para restaurar API-first sem regressao.
