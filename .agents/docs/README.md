# Controle de Estoques Documentation

Welcome to the documentation for the **Controle de Estoques** repository.

## Quick Start

This is a full-stack inventory system:

- **Frontend**: React + Vite in `src/src/`
- **Backend**: Fastify in `backend/` (current persistence is in migration/hybrid state between SQL and Supabase API mode)

## Repository Structure

```text
ControledeEstoques/
├─ backend/                 # Backend service
│  ├─ src/                  # Server code
│  ├─ scripts/              # Automation (smoke, reconcile, etc.)
│  └─ local.db              # Local database used in dev/tests
├─ src/                     # Frontend app
│  └─ src/                  # Client code
│     ├─ components/        # Shared UI (incl. components/ui)
│     ├─ core/              # Domain types + core logic
│     ├─ features/          # Feature modules
│     ├─ infra/             # HTTP/SSE integrations
│     ├─ store/             # State management
│     └─ use-cases/         # Orchestration/services
├─ docs/                    # Documentation hub (Diátaxis)
├─ CLAUDE_DOCS/             # Analysis bundle (human docs)
├─ .context/                # Deterministic AI context
├─ PROJECT_MAP.md           # Repo navigation map
├─ SESSION_MEMENTO.md       # Last state / tests / next steps
└─ FEATURE_LEDGER.md        # UX/Feature invariants
```

## Key Navigation Docs

- `PROJECT_MAP.md`: structure/gps
- `API_INDEX.md` and `API_CATALOG.md`: symbol index + contracts
- `SESSION_MEMENTO.md`: what changed last + current test status
- `.context/docs/MAPEAMENTO_CORRECAO_API_2026-02-06.md`: full architecture map for API-first correction
- `.context/docs/GUIA_TESTE_BASICO_SISTEMA.md`: passo a passo para teste basico pela interface (usuario final)
- `.context/docs/PLANO_CORRECAO_GERAL_2026-02-08.md`: plano consolidado para estabilizar e evoluir o sistema (API-first)
- `.context/docs/RELATORIO_MUDANCAS_2026-02-08.md`: resumo das correcoes aplicadas (API mode parity)

## Testing Notes

- Backend tests (API-first stable suite): `cd backend; npm run test`
- Backend legacy tests (SQL/SQLite migration backlog): `cd backend; npm run test:legacy`
- Backend smoke: `cd backend; npm run test:smoke`
- Restore catálogo/estoque do `local.db` para Supabase API: `cd backend; npm run restore:local`
- Windows esbuild unblock guide: `docs/how-to/UNBLOCK_ESBUILD_AND_RUN_TESTS.md`
