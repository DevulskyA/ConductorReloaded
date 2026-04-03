## UI: SYMMETRY + CONTROLS + FRONTEND

Operational definition of "new UI": new reusable component, new control pattern, new screen/route, or flow that changes what the user does.
New UI requires anchors (file + symbol) and 2–3 equivalent references in the codebase; without evidence → `⛔ HALT`.

### Shape patterns
- Enum 2–5: segmented/pill/radio-group
- Enum >5: dropdown/select
- Binary toggle: switch/checkbox
- Destructive: button + confirmation
- **UI-SEL-01:** FORBIDDEN to implement exclusive selection (enum) as "multiple action buttons" WITHOUT selection semantics.
- **UI-THEME-01:** FORBIDDEN to create a toggle outside of a proven theme pattern without `AUTH:EXPAND` and explicit side Effects defined.

### Evidence-bound UI library usage (primitives discipline)
- If an active UI library/design system is EVIDENCED: MUST use its primitives (button/dialog/dropdown).
- Re-implementing primitives is forbidden unless library lacks it AND `AUTH:EXPAND` is provided.

### Accessibility baseline (default)
- Default target: WCAG 2.2 AA.
- Minimum checks: keyboard navigation, visible focus, correct ARIA roles/labels, contrast compliance (AA).

### Design System Quantificado (INV-DESIGN-01)
- **Colors:** Max 5 total (1 Primary, 2-3 Neutrals, 1-2 Accents).
- **Typography:** Max 2 font families.
- **Spacing:** Use consistent scale (4px grid: 4, 8, 12, 16, 24, 32...).
- **Override Rule:** If you change background color, **MUST** change text color for contrast.
- **FORBIDDEN:** Plain red/blue/green. Mixing margin+gap on same element.

### Intentional minimalism & Performance constraints
- Avoid layout thrash (forced reflow/repaint loops). Prefer transform/opacity for animations.
- Each UI element must have a declared purpose. Elements without purpose are removed.

---

## ASYNC / STREAMING / UX (LEVEL 1 — anti-freeze/duplication)
For any async operation affecting data/UX MUST include:
- loading feedback when applicable
- block reentrancy (disable/dedupe/throttle)
- idempotent writes
- observable failures (visible error; no silent failures)
Without evidence of existing pattern (anchors in UI/store) → `⛔ HALT: ASYNC PATTERN NOT PROVEN`.
