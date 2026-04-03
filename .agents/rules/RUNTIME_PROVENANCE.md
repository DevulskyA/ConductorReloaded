## CRITICAL RUNTIME & PROVENANCE INVARIANTS

### INV-RUNTIME-01 - Runtime Provenance (ABSOLUTE)
- No execution/deploy/debug conclusion is valid without proof of: (1) absolute executable path, (2) running process identity, (3) side-file set resolved from the same runtime directory.
- **Forbidden:** declaring success based on build output alone if the user executed the binary. IF proof disagrees -> `HALT: RUNTIME PROVENANCE MISMATCH`.

### INV-DEPLOY-02 - Official Lane Separation & Oversized Hygiene
- Official artifacts, check artifacts, and debug artifacts MUST have distinct paths semantics.
- Everything > 100MB or generated ad hoc outside official flow must be discarded/quarantined in `TRASH/`, never committed/tracked.

### INV-FORENSICS-01 - Recurring Failure Reuse
- If a recurring bug exists, MUST start by checking the `ANALISE_FALHAS.md` before concluding anything new.

### INV-CLOSEOUT-01 - No Conclusion Without Real Proof
- Task involving build/deploy/runner is ONLY complete when exact user-facing entrypoint was executed, process path matched, and observed runtime is validated via logs (`HALT: CLOSEOUT WITHOUT RUNTIME PROOF`).

---

## PIPE & OUTPUT VERIFICATION

### INV-BUILD-01 — Zero Warning Policy (Build Hygiene)
- "Done" requires `exit code 0` AND **0 warnings** in project-owned code.
- Ignoring nullability or async warnings = runtime defects in disguise. DO NOT IGNORE.

### INV-VERSIONING-01 — Traceability (ABSOLUTE)
- ALL essential scripts/prompts MUST have a visible Version Header: `[FILE VERSION: vX.Y]`.

### INV-LOCKS-01 — Process Safety & Preconditions
- BEFORE build/git/file ops verify: locked processes (`Axon.exe`, `.git/index.lock`, DLLs). Kill or HALT before proceeding.

### DEBUG PROTOCOL / ERROR LOGGING
- Update `ANALISE_FALHAS.md` on critical failure. Format: Date | Type | Desc | Root Cause | Fix.
- Use Prefix `[AXON]` in debug statements. Remove statements after resolution. Visual debugging (inspect) > assumption.
- Self-Correction Limits: Generic errors = 1 retry. Core/Infra Logic errors = 0 retries (HALT).

---

## ENV & TOOLING 
- **Declare:** Define `OS`, `SHELL`, `RUNTIME` before orchestrating. Modern syntax: `rg` (search), `bat` (view), `rm`, `ni`.
- Never assume ecosystem tools. Read scripts/configs (`package.json`, `Makefile`, etc.) to find the exact command to run.
