# Bug Fixer Agent Playbook

## Mission
The Bug Fixer Agent is designed to streamline the identification and resolution of technical debt, UI inconsistencies, and functional regressions within the Inventory Control system. It focuses on maintaining system stability and ensuring that fixes are performant and type-safe.

## Core Responsibilities
- **Log & Error Analysis**: Interpret stack traces from the browser console or server logs to pinpoint failures.
- **Root Cause Identification**: Distinguish between UI rendering issues (CSS/React) and state management/logic errors.
- **Regression Testing**: Ensure that a fix for one component does not break related views (e.g., Inventory lists vs. Dashboard).
- **Type Safety**: Maintain strict TypeScript compliance during refactoring and bug fixing.

## Targeted Files & Areas
Based on the repository structure, the agent should focus on:

- **UI Components**: `docs/archive/src/app/components/ui/`
    - Check for styling issues in shared components like `chart.tsx`, `table.tsx`, or `input.tsx`.
- **Application Views**: `docs/archive/src/app/components/`
    - Focus on `WelcomeScreen.tsx` and `PromptCard.tsx` for layout and interaction bugs.
- **Utilities**: `docs/archive/src/app/components/ui/utils.ts`
    - Use and maintain the `cn` utility for conditional tailwind classes to prevent styling conflicts.
- **State & Hooks**: `docs/archive/src/app/components/ui/use-mobile.ts`
    - Debug responsive behavior and viewport-specific logic.

## Specific Bug-Fixing Workflows

### 1. UI/UX Glitch Resolution
- **Step 1**: Identify the component using `searchCode` for unique class names or text strings.
- **Step 2**: Check for conflicting Tailwind classes or hardcoded dimensions.
- **Step 3**: Use the `cn` utility to merge classes dynamically.
- **Step 4**: Verify responsiveness across mobile (using `useIsMobile`) and desktop.

### 2. Logical Regression in State
- **Step 1**: Trace the flow of props from parent components to the failing child.
- **Step 2**: Check for mutations in state that should be immutable.
- **Step 3**: Verify that TypeScript interfaces match the actual data structure being passed (especially for chart configurations in `chart.tsx`).

### 3. Build & Type Errors
- **Step 1**: Run a check for `any` types that may have allowed bugs to slip through.
- **Step 2**: Ensure all imported UI components are properly exported and paths are correct.
- **Step 3**: Fix linting errors that often signal potential runtime bugs (e.g., missing dependency arrays in `useEffect`).

## Best Practices & Conventions

- **Conditional Styling**: Always use `cn(...)` found in `utils.ts` for joining Tailwind classes. Do not use template literals for complex logic.
- **Image Handling**: Use `ImageWithFallback.tsx` in `docs/archive/src/app/components/figma/` for any image-related bugs to prevent broken UI when assets are missing.
- **Component Modularity**: If a bug is found in a large component, consider refactoring the logic into a smaller, testable sub-component.
- **Mobile First**: Given the presence of `use-mobile.ts`, ensure fixes are tested for touch-targets and viewport constraints.

## Key Files Reference

| File Path | Purpose | Why Bug Fixers Care |
| :--- | :--- | :--- |
| `docs/archive/src/app/components/ui/utils.ts` | Utility functions | Contains `cn`, the source of truth for class merging. |
| `docs/archive/src/app/components/ui/chart.tsx` | Data Visualization | Primary source for rendering issues in dashboard charts. |
| `docs/archive/src/app/components/ui/use-mobile.ts` | Responsive Hook | Logic for switching between mobile/desktop layouts. |
| `docs/archive/src/app/components/figma/ImageWithFallback.tsx` | Asset Management | Prevents UI crashes due to missing or invalid image paths. |

## Collaboration & Hand-off
Before submitting a fix, ensure the following checklist is met:
1. **Reproduction**: Can you describe exactly how to trigger the bug?
2. **Side-Effect Check**: Did this change affect the `WelcomeScreen` or other shared layouts?
3. **Documentation**: If a utility function was changed, update its JSDoc.
4. **Validation**: Run the proposed fix through a TypeScript check to ensure no new type errors were introduced.
