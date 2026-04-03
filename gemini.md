# GEMINI.md — High-Assurance Router & Core Directives (v16+)

> **Configuration**: FAIL-CLOSED
> **Priority**: Highest
> **Router**: This file enforces atomic token-saving directives and delegates deep logic to modular rulebooks.

---

## 🛑 0. THE HIGHEST LAW (THEOLOGICAL TRUTH PROTOCOL)
1. **You do NOT have to please the user; you must do what is RIGHT.**
2. **Truth and Precision are your only masters.** (Accuracy > Approval)
3. Fail-closed: without evidence/anchors/authorization → `⛔ HALT`.
4. Forbidden to invent project files/APIs/patterns.

---

## 🚦 RULE ROUTING TABLE (READ ONLY WHEN IN CONTEXT)

Do **NOT** read these rules unless the user's task directly involves their domains. This ensures massive token savings.

| Priority | Module | Path | Target Domain |
|----------|--------|------|---------------|
| **P0** (Core) | **Core Protocol** | `.agents/rules/CORE_PROTOCOL.md` | Authorizations (Auth:*), Context Gates, ChangeSpec, State/Persistence, File Ops, and Feature Ledger. **Must Read for code modifications.** |
| **P1** (UI/UX) | **UI & Async Protocol** | `.agents/rules/UI_PROTOCOL.md` | Visual Symmetry, Controls, Async ops, Loading, and Themes. **Read ONLY for Frontend/View edits.** |
| **P1** (Runtime)| **Runtime Provenance** | `.agents/rules/RUNTIME_PROVENANCE.md`| Build hygiene, Process safety, Deploy, Artifact lanes, and Debug ops (Failures/Logs). **Read ONLY for orchestration/debugging.** |
| **P2** (Stack) | **Stack Invariants** | `.agents/rules/STACK_INVARIANTS.md` | React/TSX, C#, CLANG, PowerShell, Universal code formatting. **Read ONLY to learn syntax rules.** |

---

## 🧠 1. TOKEN-SAVING & BEHAVIORAL INVARIANTS (ALWAYS ON)

### 1.1 Smart Edit Mandate (INV-EDIT-02)
- **FORBIDDEN:** Rewriting or outputting entire files to change a few lines.
- **REQUIRED:** Use surgical diffs or replace chunks.
- **Why:** Reduces token cost drastically and prevents accidental regressions.

### 1.2 "Don't Stop at First Match" (INV-SEARCH-01)
- When search finds multiple files, examine **ALL** of them to ensure correct context.

### 1.3 Pre-Edit Gate (INV-EDIT-01)
Before making changes, ask: (1) Right file? (2) Parent/wrapper handles it? (3) Existing utils? (4) Broader impact? If unclear → Read more files before editing.

### 1.4 Parallel vs Serial Execution (INV-EXEC-01)
- **Parallel:** READ operations (`read_file`, `rg`, `ls`) — run simultaneously.
- **Serial:** WRITE operations (`replace_file`, `run_command`) — one at a time, verify, next.

### 1.5 Communication Standards
- **High-Signal, Low-Noise:** Use Markdown. No narration inside code blocks. Optimize for skimmability. Refrain from user-handling ("I hope this helps").

---
> *Certified Ironclad v19 — Modular Context Protocol.*

---

## 🗺️ UNIVERSAL FILE RESOLUTION INDEX
> **Goal:** Eradicate LLM exploratory queries (`dir`/`ls`/`tree`). Read this index before attempting to discover files. All essential tools are mapped statically here.

### 1. Conductor Native Ecosystem (Core Paths)
- **Constitutição / Spec Reviewer:** `docs/spec-reviewer/system-spec-reviewer-constitution.md`
- **Manual Técnico:** `docs/manual-tecnico.md`
- **Mesa Central (Registry Index):** `conductor/index.md`
- **Workflow & Rules List:** `conductor/workflow.md`, `conductor/product.md`, `conductor/tech-stack.md`
- **Tracking Database:** `conductor/tracks/` e `conductor/tracks.md`

### 2. Antigravity Plugins (Conductor Core Skills)
Path: `.agents/plugins/conductor-reload/skills/`
- **`conductor-setup/SKILL.md`**: Auto-scaffolds the conductor environment
- **`conductor-newTrack/SKILL.md`**: Generates a feature track (Spec & Plan)
- **`conductor-review/SKILL.md`**: Interrogates the spec against the Constitution
- **`conductor-implement/SKILL.md`**: Git-aware execution of the track's plan
- **`conductor-revert/SKILL.md`**: Safe rollback interface
- **`conductor-status/SKILL.md`**: Project situation report

### 3. Workflow Engine
- **Orquestrador Central:** `.agents/workflows/conductor-feature.md` (Powers the NLP Pipeline)

### 4. Advanced Tooling & Governance Directory
- **Rulebooks (`.agents/rules/`):**
  - `CORE_PROTOCOL.md` (Feature Ledger, Permissions, Context Gates)
  - `UI_PROTOCOL.md` (Design schema, shapes, A11y)
  - `RUNTIME_PROVENANCE.md` (Build/deploy hygiene, debugging rules)
  - `STACK_INVARIANTS.md` (Clean code per language)
- **Specialized Agents (`.agents/agents/`):**
  - Architect (`architect-specialist.md`), Backend (`backend-specialist.md`), Frontend (`frontend-specialist.md`), QA (`test-writer.md`), Dev-ops (`devops-specialist.md`), Bug-fixer (`bug-fixer.md`), Code-reviewer (`code-reviewer.md`)
- **Generic Skills (`.agents/skills/`):**
  - `api-design/SKILL.md`, `bug-investigation/SKILL.md`, `code-review/SKILL.md`, `commit-message/SKILL.md`, `documentation/SKILL.md`, `feature-breakdown/SKILL.md`, `pr-review/SKILL.md`, `refactoring/SKILL.md`, `security-audit/SKILL.md`, `test-generation/SKILL.md`

*(Mandate: If the user explicitly requests an agent or skill from the above, you MUST read its file path directly. Do NOT "dir" to find it. Otherwise, rely solely on the main workflow.)*
