## AUTHORIZATION AND SCOPE (LEVEL 1)

Tokens (fail-closed):
- `AUTH:APPLY` → authorized to apply final patch/code (non-destructive).
- `AUTH:EXPAND` → authorized to expand scope/create UI/feature/additional refactors.
- `AUTH:DESTRUCTIVE` → authorized for destructive/irreversible actions (still requires TRASH + confirmation).
- `AUTH:SANCTUARY` → authorized to touch `security/` (still requires two-step).

Rules:
- Without applicable token → `⛔ HALT: NO AUTHORIZATION (AUTH:*)`.
- Without `AUTH:EXPAND` → FORBIDDEN to overreach (cosmetic refactor, new flows/features).
- If deep_analysis, require ChangeSpec before mutating.

---

## CONTEXT GATE (PROJECT DELTA)
- deep_analysis if: >5 files OR >100 net lines OR >3 public symbols.
- If deep_analysis and relevant artifacts/files are missing from context → `⛔ HALT: INSUFFICIENT CONTEXT`.

---

## ANTI-GHOST-API
- Without evidence (type/source/doc from the project) → mark as `API_DESCONHECIDA` and ask for confirmation.
- Forbidden to guess names of functions/hooks/events.

---

## PERSISTENCE / STATE (LEVEL 1 — anti-corruption)
Any change in storage/schema/serialization (IndexedDB/localStorage/cache/JSON) requires evidence of the current format.
Without evidence (schema + read/write points + versioning) → `⛔ HALT: PERSISTENCE WITHOUT EVIDENCE`.
Minimum mandatory contract: `schemaVersion`, Forward migration + safe fallback, Snapshot before bulk writes, Validate before write.

---

## IMPLEMENTATION PROTOCOL (LEVEL 1)

### Patch-first
- Default: minimal PATCH. Forbidden to remove/clean up by assumption.

### ChangeSpec 2.0 (Enhanced - Mandatory for non-trivial / deep_analysis)
MUST include:
1. **Objective:** What and why.
2. **Scope:** Files affected.
3. **DoesNotChange:** Explicitly list what remains untouched.
4. **Risk:** What could go wrong.
5. **Verify:** Command or criterion to confirm success.
6. **Rollback:** Specific undo steps.
Without ChangeSpec when required → `⛔ HALT: CHANGE SPEC MISSING`.

### Invariant: Context Freshness (Anti-Blind Edit)
- **Constraint:** Target file must be read within the last 5 turns. If stale, Read first, then Edit.

### Protocol: Atomic Execution (Micro-Tasks)
- **Rule:** Tasks >1 step require visible checklist (`[ ]`). Exec 1 step -> Verify -> Tick -> Next.

---

## FAILFAST & LEDGER
- **Corrigir 1 classe por vez**: Compile -> Contract -> Lint.
- **Max 2 Tentativas**: Se falhar 2x sem progresso -> **HALT**.
- **Ledger-driven:** Before creating/modifying a feature/UI, reference an entry in `FEATURE_LEDGER.md`. If not -> `⛔ HALT: FEATURE NOT DOCUMENTED`.

---

## FILE OPS & SANCTUARY
- `security/` is IMMUTABLE/READ-ONLY by default. Requires TWO-STEP confirmation to touch.
- **File Ops:** No hard-delete. Removals go to TRASH. Untracked files require explicit list and confirmation before touching. DO NOT USE GREP. Use `rg` (ripgrep).
