# Performance Optimizer Agent Playbook

## Mission
The Performance Optimizer agent is dedicated to ensuring the application remains responsive, efficient, and scalable. It focuses on reducing bundle sizes, optimizing React render cycles, improving data fetching patterns, and ensuring the UI remains fluid even with large inventory datasets.

## Core Responsibilities
- **Frontend Optimization**: Minimizing re-renders, optimizing heavy component trees (like Data Tables), and managing client-side state efficiently.
- **Resource Management**: Optimizing asset loading (images, icons) and bundle sizes.
- **Data Flow Efficiency**: Identifying redundant API calls and implementing effective caching strategies.
- **Code Auditing**: Detecting anti-patterns that lead to memory leaks or CPU spikes.

## Key Focus Areas

### 1. UI Component Efficiency (`src/app/components/ui`)
This repository heavily utilizes a UI library (likely Shadcn/UI based on the `cn` utility). Focus on:
- **Re-render Analysis**: Auditing components like `PromptCard` and `WelcomeScreen` for unnecessary updates.
- **Dynamic Imports**: Implementing React `lazy` or Next.js `dynamic` for heavy components (e.g., Charts, Complex Dialogs).
- **Context Usage**: Ensuring `Context.Provider` values are memoized to prevent global re-renders.

### 2. Data Visualization & Lists
With inventory systems, performance often degrades in data-heavy views.
- **Virtualization**: If lists or tables exceed 50-100 items, suggest `react-window` or `tanstack-virtual`.
- **Chart Optimization**: Auditing `ChartConfig` and related components in `docs/archive/src/app/components/ui/chart.tsx` to ensure data points are processed efficiently.

### 3. Styling and Assets
- **Tailwind Efficiency**: Monitoring the usage of the `cn` utility in `utils.ts` to ensure class merging isn't happening in high-frequency loops.
- **Image Optimization**: Enhancing `ImageWithFallback` to utilize Next.js Image optimization features (priority loading, proper sizing).

## Standard Workflows

### Workflow: React Component Optimization
1.  **Identify**: Use React Profiler to find components with high "Commit time" or frequent "Passive effects".
2.  **Analyze**: Check if props are changing unnecessarily (referential identity issues).
3.  **Action**:
    *   Wrap expensive calculations in `useMemo`.
    *   Wrap callbacks passed to children in `useCallback`.
    *   Implement `React.memo` for leaf components.
4.  **Verify**: Re-run profiler and document the "before/after" render counts.

### Workflow: Bundle Size Reduction
1.  **Audit**: Analyze the build output or use `webpack-bundle-analyzer` / `next-bundle-analyzer`.
2.  **Action**:
    *   Identify large third-party libraries.
    *   Check for "barrel file" issues where importing one utility pulls in the whole library.
    *   Suggest tree-shakable alternatives for heavy dependencies.
3.  **Refactor**: Move large UI elements (Modals, Slide-overs) to dynamic imports.

### Workflow: Network & Data Fetching
1.  **Audit**: Monitor the Network tab for waterfall requests or duplicate fetches.
2.  **Action**:
    *   Implement SWR or React Query stale-while-revalidate patterns.
    *   Add `loading="lazy"` to non-critical data fetches.
    *   Debounce search inputs (especially in inventory search fields).

## Best Practices
- **Measure First**: Never optimize based on intuition. Use Chrome DevTools (Performance/Memory tabs) or Lighthouse scores.
- **Avoid Over-Memoization**: Do not `useMemo` every variable; focus on expensive computations or props passed to memoized components.
- **Keep Utils Lean**: Ensure the `cn` utility in `docs/archive/src/app/components/ui/utils.ts` is used correctly to avoid runtime overhead in large lists.
- **Skeleton Screens**: Prefer skeleton loaders over blocking UI renders for better Perceived Performance (LCP/FCP).

## Key Files & Purposes
- `docs/archive/src/app/components/ui/utils.ts`: Contains `cn` for class merging. Vital for style performance.
- `docs/archive/src/app/components/ui/use-mobile.ts`: Hook for responsive logic. Ensure it doesn't trigger excessive re-renders on window resize.
- `docs/archive/src/app/components/figma/ImageWithFallback.tsx`: Critical for asset loading performance and LCP.
- `docs/archive/src/app/components/ui/chart.tsx`: Handles data visualization; primary candidate for optimization during heavy data loads.

## Collaboration Checklist
1.  **Initial Assessment**: Run a Lighthouse report on the affected page.
2.  **Code Review**: Check if the optimization affects readability. If an optimization is complex (e.g., bitwise operations or complex caching), ensure it is well-documented.
3.  **Testing**: Verify that memoization doesn't introduce bugs (e.g., stale closures).
4.  **Hand-off**: Provide a summary of the performance gain (e.g., "Reduced TTI by 200ms").

## Hand-off Notes
- **Metrics Captured**: [List improvement in ms/KB]
- **Trade-offs Made**: (e.g., "Sacrificed minor code brevity for significant render speed in Table components")
- **Future Risks**: Note any areas where future data growth might require further optimization (e.g., "Virtualization will be needed if inventory exceeds 500 items").
