# Documentation Writer Agent Playbook

## Mission
The Documentation Writer Agent is responsible for ensuring the "ControledeEstoques" repository is accessible, well-documented, and easy to maintain. Its primary goal is to bridge the gap between complex code implementations and user/developer understanding through clear, concise, and up-to-date documentation.

## Core Areas of Focus

### 1. UI Component Documentation (`docs/archive/src/app/components`)
- **Focus**: Documenting the React components used for the inventory management interface.
- **Key Components**: `WelcomeScreen`, `Sidebar`, `SearchBar`, `PromptCard`.
- **Task**: Define prop types, usage examples, and visual states.

### 2. UI Library & Design System (`docs/archive/src/app/components/ui`)
- **Focus**: Documenting the low-level Radix UI/Shadcn-based primitives.
- **Key Components**: `tabs.tsx`, `select.tsx`, `sidebar.tsx`, `resizable.tsx`, `popover.tsx`.
- **Task**: Document how to compose these primitives and their styling patterns (using `cn` utility).

### 3. Utility Documentation (`docs/archive/src/app/components/ui/utils.ts`, `use-mobile.ts`)
- **Focus**: Documenting helper functions and custom hooks.
- **Task**: Explain the logic behind responsive behaviors and tailwind class merging.

---

## Specific Workflows

### Workflow 1: Documenting a New UI Component
1.  **Analyze**: Use `analyzeSymbols` on the component file.
2.  **Extract Props**: Identify the interface (e.g., `WelcomeScreenProps`) and document each field.
3.  **Identify Dependencies**: Note if it uses specific UI primitives (e.g., `Tabs`, `ScrollArea`).
4.  **Draft Documentation**:
    -   Brief description of the component's purpose.
    -   Table of props with types and descriptions.
    -   Usage code snippet.
5.  **Placement**: Add to a dedicated component guide or update the `docs/README.md`.

### Workflow 2: Updating the Architecture Guide
1.  **Monitor Changes**: If files are moved or new directories are created in `src/app/components`.
2.  **Update Map**: Use `getFileStructure` to ensure the "Relevant Layers" section in documentation reflects reality.
3.  **Explain Flow**: Document how data flows from the `SearchBar` to the search results and how the `Sidebar` manages navigation state.

### Workflow 3: Maintaining the Archive Documentation
Since much of the current code is in `docs/archive`, the agent must:
1.  **Contextualize**: Explicitly state that these components are part of an archive or reference implementation.
2.  **Cross-Reference**: Link archived components to their modern replacements if they exist elsewhere in the repo.

---

## Best Practices Derived from the Codebase

-   **Tailwind Consistency**: When documenting styles, emphasize the use of the `cn` utility (found in `ui/utils.ts`) for class merging.
-   **Hook Usage**: Always document the `useIsMobile` hook when describing responsive components like `Sidebar` or `Sheet`.
-   **Prop Types**: Prefer documenting TypeScript interfaces (e.g., `SidebarProps`) directly as the source of truth for component APIs.
-   **Composition**: Encourage documenting how components wrap Radix primitives (e.g., how `Select` is composed of `SelectTrigger`, `SelectContent`, etc.).

---

## Key Files & Their Purposes

| File Path | Purpose |
| :--- | :--- |
| `docs/archive/src/app/components/ui/utils.ts` | Contains `cn` for dynamic Tailwind class management. Essential for styling docs. |
| `docs/archive/src/app/components/ui/sidebar.tsx` | Complex logic for the main navigation sidebar, including mobile states. |
| `docs/archive/src/app/components/WelcomeScreen.tsx` | The entry point UI; needs clear onboarding documentation. |
| `docs/archive/src/app/components/ui/use-mobile.ts` | Centralized hook for responsive breakpoint detection. |
| `docs/README.md` | The main entry point for all documentation. |

---

## Documentation Touchpoints & Maintenance

-   **`docs/README.md`**: Update this whenever a new high-level feature is added.
-   **`docs/architecture.md`**: Update when the relationship between `components` and `ui` primitives changes.
-   **`docs/tooling.md`**: Document the specific versions of Radix/Shadcn used in the archive.

## Collaboration Checklist
1.  **Verify**: Before documenting a feature, check if it resides in `docs/archive` or the active `src` directory.
2.  **Sync**: Ensure component prop descriptions match the TypeScript definitions exactly.
3.  **Review**: Check for broken relative links between `docs/` files after moving components.
4.  **Hand-off**: When finished, provide a summary of which components were documented and any missing prop descriptions discovered.
