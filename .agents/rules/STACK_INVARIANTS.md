## UNIVERSAL ENGINEERING & CODE STYLE
High-Assurance rules applicable to ANY stack (C#/JS/C/etc).

### STYLE STANDARDS
1. **Naming:** Verb-based functions (`getUser`), Noun-based vars (`userData`). No Single Check (`x`,`y`) except Math/Loop indices.
2. **Control Flow:** Prefer early returns (Guard Clauses) over `else` nesting. Fail fast.
3. **Typing:** Explicit Contracts for public APIs. Avoid `any`/unsafe casts.
4. **Comments:** Why > How. No Inline Narration.

### TECHNICAL INVARIANTS
- **Truth Pipeline (SSOT):** Source must be distinct and validated.
- **Lifecycle Gate:** Business logic ONLY executes after explicit `Ready/Init` signal.
- **Atomic Ops:** Deploy/Sync/Backup must be Transactional.
- **Config-Only Externals:** External service URLs must reside in configuration files, never hardcoded.
- **Theme-Bound Visuals & i18n:** Avoid literal magic strings/brushed in business logic.

---

## INV-STACK (CONDITIONAL)

### TSX/React (Frontend)
- Hook usage implies import. Props passed must exist in type.
- NoImplicitAny strict. Unused vars forbidden in merge.
- **Store:** Selectors matches state type. Store shape change = Contract change.
- **i18n:** New keys require dictionary update + type generation.

### C#/.NET
- **Build:** Zero Warnings (`<TreatWarningsAsErrors>true`).
- **Async:** Todo `async` deve ter `await`. Use `Task.FromResult` se síncrono.
- **Nullability:** Contexto `enable` mandatório. `!` permitido apenas com prova de invariante.
- **Style:** File-scoped namespaces; Top-level statements.

### C/Native (CLANG)
- **Memory:** Todo `malloc` tem seu `free` (RAII manual).
- **Safety:** Proibido `strcpy`, `gets`, `sprintf`. Use versões `n` (`strncpy`, `snprintf`).
- **Headers:** `#pragma once` ou Include Guards obrigatórios.

### PowerShell / Shell
- **PowerShell:** Preferir tipagem explícita `[string]$var` e `Strict-Mode` em scripts complexos. Do NOT USE DOS/CMD (use `pwsh`).
- **Batch:** Exclusivo para wrappers legados associados a inicialização.
