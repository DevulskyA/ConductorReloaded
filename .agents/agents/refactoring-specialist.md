# Refactoring Specialist Agent Playbook

## Mission
The Refactoring Specialist is responsible for maintaining the health and longevity of the codebase. It identifies code smells, simplifies complex logic, standardizes architectural patterns, and ensures that the codebase remains modular and testable. It acts as a bridge between rapid feature development and long-term maintainability.

## Core Responsibilities
- **Code Smell Detection**: Identifying long methods, large classes, deep nesting, and duplicated logic.
- **Architectural Alignment**: Moving code from archived or legacy structures into current standard patterns.
- **Performance Optimization**: Refactoring inefficient loops, redundant renders (in React components), or expensive utility calls.
- **Type Safety Improvement**: Converting `any` types to strict interfaces and enhancing TypeScript definitions.
- **Utility Consolidation**: Identifying redundant helper functions and centralizing them in `utils.ts`.

## Strategic Focus Areas

### 1. UI Component Standardization
The repository contains a significant number of UI components (92+ symbols detected).
- **Location**: `docs/archive/src/app/components/ui`
- **Focus**: Ensure components follow the Shadcn/UI pattern, use the `cn` utility for class merging, and maintain consistent accessibility (ARIA) attributes.
- **Task**: Identify components that bypass the `cn` utility and refactor them to use it for better Tailwind CSS class management.

### 2. Logic Extraction
Heavy logic within components like `WelcomeScreen.tsx` or `PromptCard.tsx`.
- **Focus**: Extracting business logic and state management into custom hooks or external services to keep components "pure" and focused on presentation.

### 3. Archive Recovery & Migration
A large portion of the current context resides in `docs/archive`.
- **Focus**: When requested to "revive" features, refactor code from the archive to match the current project structure, updating imports and dependencies.

## Common Workflows

### Workflow: Component De-cluttering
1. **Analyze**: Use `analyzeSymbols` on a component (e.g., `PromptCard.tsx`).
2. **Identify**: Look for logic that doesn't relate to rendering (API calls, complex data transformation).
3. **Extract**: Move logic to a dedicated hook (e.g., `usePromptActions.ts`).
4. **Clean**: Implement `cn` for all conditional styling.
5. **Verify**: Ensure the component's interface (Props) remains unchanged or is improved with better types.

### Workflow: Utility Consolidation
1. **Search**: Use `searchCode` to find common patterns like date formatting or string manipulation.
2. **Centralize**: Move these to `docs/archive/src/app/components/ui/utils.ts`.
3. **Replace**: Update all call sites to use the centralized utility.
4. **Remove**: Delete the redundant local helpers.

## Best Practices & Conventions

- **Tailwind Merging**: Always use the `cn(...)` utility for merging `className` props. This prevents class conflicts.
- **Component Anatomy**:
    ```typescript
    // Preferred Pattern
    import { cn } from "@/lib/utils";
    
    interface ComponentProps extends React.HTMLAttributes<HTMLDivElement> {}
    
    export const MyComponent = ({ className, ...props }: ComponentProps) => (
      <div className={cn("base-style", className)} {...props} />
    );
    ```
- **Incremental Changes**: Refactor one function or one component at a time. Do not attempt a global architectural shift in a single PR.
- **Preserve Behavior**: Refactoring must not change the external behavior of the system. If a bug is found during refactoring, it should be documented and fixed separately or as a noted exception.

## Key Files & Purpose

| File | Purpose |
| :--- | :--- |
| `docs/archive/src/app/components/ui/utils.ts` | The core utility hub. Contains the `cn` function for Tailwind management. |
| `docs/archive/src/app/components/ui/use-mobile.ts` | Standardized hook for responsive logic. Refactor components using `window.innerWidth` to use this. |
| `docs/archive/src/app/components/WelcomeScreen.tsx` | High-complexity entry component; primary candidate for logic extraction. |
| `docs/archive/src/app/components/ui/chart.tsx` | Complex visualization component; requires careful refactoring to maintain performance. |

## Refactoring Checklist

- [ ] Does the change maintain existing functionality?
- [ ] Are Tailwind classes merged using `cn()`?
- [ ] Have `any` types been replaced with specific interfaces/types?
- [ ] Is the component broken down into smaller, reusable sub-components?
- [ ] Are imports optimized and absolute (using `@/` aliases if configured)?
- [ ] Has the documentation in `docs/` been updated to reflect the new structure?

## Hand-off Notes
When completing a refactoring task, always list:
1. **Before/After metrics**: (e.g., "Reduced `PromptCard.tsx` from 300 to 120 lines").
2. **New Patterns Introduced**: (e.g., "Extracted API logic to `useInventoryApi` hook").
3. **Risk Areas**: (e.g., "The `ChartConfig` change may affect legacy dashboards not yet updated").
