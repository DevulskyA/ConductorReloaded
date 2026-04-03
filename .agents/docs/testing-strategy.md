# Testing Strategy

This document outlines the testing methodologies, tools, and quality standards for the **Controle de Estoques** repository. Our goal is to ensure reliability, maintainability, and a seamless user experience through a robust multi-layered testing approach.

## Test Types

### Unit Testing
Unit tests focus on individual functions, custom hooks, and utility methods in isolation.
- **Framework:** [Vitest](https://vitest.dev/) or [Jest](https://jestjs.io/) (aligned with Vite/Next.js defaults).
- **Naming Convention:** `[filename].test.ts` or `[filename].spec.ts` (placed alongside the source file or in a `__tests__` directory).
- **Focus:** 
    - Utility functions (e.g., `cn` in `utils.ts`).
    - Logic-heavy components (e.g., calculations within stock management).
    - Data transformation and validation logic.

### Component/Integration Testing
These tests verify that multiple components work together correctly and that the UI responds as expected to user interactions.
- **Framework:** [React Testing Library](https://testing-library.com/docs/react-testing-library/intro/).
- **Focus:**
    - User events (clicking buttons, filling forms like `Input` or `Select`).
    - Sidebar navigation logic (`useSidebar`).
    - Complex UI states like `Carousel`, `Dialog`, or `Tabs`.
    - Context providers (e.g., `TooltipProvider`, `SidebarProvider`).

### End-to-End (E2E) Testing
E2E tests simulate real user journeys from start to finish in a browser environment.
- **Framework:** [Playwright](https://playwright.dev/) or [Cypress](https://www.cypress.io/).
- **Scenarios:**
    - Authenticating and navigating to the Dashboard.
    - Adding, editing, and deleting inventory items.
    - Generating reports or viewing charts (`ChartConfig`).
    - Responsive behavior across mobile and desktop (`useIsMobile`).

---

## Running Tests

Ensure all dependencies are installed before running test commands.

| Command | Action |
| :--- | :--- |
| `npm run test` | Executes all test suites once. |
| `npm run test:watch` | Runs tests in interactive watch mode (ideal for local development). |
| `npm run test:coverage` | Generates a coverage report to identify untested code paths. |
| `npm run lint` | Runs ESLint to check for code quality and style issues. |

---

## Quality Gates

To maintain a high standard of code, all contributions must pass the following checks before being merged into the main branch:

1. **Linting & Formatting:** 
   - Code must pass `npm run lint`.
   - Prettier must be used to ensure consistent formatting.
2. **Coverage Requirements:**
   - **Minimum 80%** total branch coverage is recommended for business logic and utility functions.
   - Critical components (e.g., `Form`, `Sidebar`) should target **90%+** coverage.
3. **CI/CD Integration:**
   - Automated workflows run the full test suite on every Pull Request.
   - Merging is blocked if any test fails or coverage drops below the threshold.

---

## Component Testing Examples

### Testing UI Components
When testing shared UI components from `@/components/ui`, focus on accessibility and state transitions.

```tsx
// Example: Testing the Switch component
import { render, screen, fireEvent } from '@testing-library/react';
import { Switch } from './switch';

test('toggles state on click', () => {
  render(<Switch />);
  const switchElement = screen.getByRole('switch');
  fireEvent.click(switchElement);
  expect(switchElement).toHaveAttribute('aria-checked', 'true');
});
```

### Testing Hooks
For hooks like `useIsMobile`, test against different window inner widths.

```tsx
import { renderHook } from '@testing-library/react';
import { useIsMobile } from './use-mobile';

test('returns true when width < 768px', () => {
  window.innerWidth = 500;
  const { result } = renderHook(() => useIsMobile());
  expect(result.current).toBe(true);
});
```

---

## Troubleshooting

### Flaky Tests
- **Asynchronous UI:** If tests fail intermittently, ensure you are using `findBy*` queries or `waitFor` from React Testing Library to account for animation delays (especially in `Dialog` or `Sheet` components).
- **Global State:** Ensure `SidebarProvider` or other contexts are reset between tests to prevent state leakage.

### Environment Quirks
- **JSDOM Limitations:** Some Radix UI components (used in our `ui/` folder) require `ResizeObserver` or `PointerEvent` mocks. Ensure these are defined in your `setupTests.ts` file.
- **Icon Rendering:** Lucide icons may be mocked to speed up execution and avoid DOM clutter in snapshots.
