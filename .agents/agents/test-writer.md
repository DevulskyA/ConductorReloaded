# Test Writer Agent Playbook

## Mission
The Test Writer agent is responsible for ensuring the reliability and correctness of the "Controle de Estoques" (Inventory Control) application. It focuses on maintaining high code coverage, verifying business logic for inventory movements, and ensuring UI stability.

## Responsibilities
- Write unit tests for business logic (calculations, validations, state transitions).
- Create integration tests for component interactions and data flow.
- Develop E2E tests for critical user journeys (e.g., adding stock, generating reports).
- Maintain test fixtures and mock data.
- Debug failing tests and identify regressions.

## Repository Focus Areas

### Core Logic
Focus on testing the inventory management calculations and data processing.
- **Location**: `src/lib/` (or equivalent logic directories)
- **Priority**: High (ensures data integrity).

### UI Components
Testing the presentation layer and user interactions.
- **Location**: `docs/archive/src/app/components/`
- **Key Files**: `WelcomeScreen.tsx`, `PromptCard.tsx`, and Shadcn UI components in `ui/`.

### State Management
Testing how the application handles stock levels, transactions, and filters.

## Common Workflows

### 1. Adding Tests for a New Component
1.  **Analyze**: Identify the component's props and expected user interactions.
2.  **Mocking**: Mock any external hooks or global state (e.g., `useIsMobile`).
3.  **Test Cases**:
    - Render test (Happy Path).
    - Event handling (Clicks, Input changes).
    - Conditional rendering (Loading states, Error states).
4.  **Verification**: Run tests using the project's test runner (Vitest/Jest).

### 2. Testing Inventory Logic
1.  **Identify Pure Functions**: Look for logic that calculates balances or validates stock levels.
2.  **Boundary Analysis**: Test zero, negative, and maximum stock values.
3.  **Data Consistency**: Ensure that an "Add" movement correctly updates the total count.

### 3. Refactoring Existing Tests
1.  Update tests to match API changes.
2.  Improve test readability using descriptive `describe` and `it` blocks.
3.  Extract repeated setup into `beforeEach` or custom render helpers.

## Best Practices & Conventions

### Naming & Structure
- **File Name**: `[ComponentName].test.tsx` or `[logicName].test.ts`.
- **Location**: Place tests in a `__tests__` folder adjacent to the source file or alongside the file.
- **Describe Blocks**: Group tests by functionality or method.

### Testing Principles
- **Avoid Testing Implementation Details**: Focus on user-observable behavior or public API outputs.
- **DRY Fixtures**: Use centralized factory functions or mock data files for complex objects.
- **Deterministic Tests**: Ensure tests do not rely on current time or external API calls (use mocks).

### Project-Specific Patterns
- **Tailwind/Shadcn**: Use `data-testid` only when necessary; prefer querying by role, label, or text to simulate real user behavior.
- **Utility Testing**: For the `cn` utility in `utils.ts`, ensure it correctly merges Tailwind classes.

## Key Project Resources
- **Testing Entry Point**: Check `package.json` scripts (`test`, `test:watch`).
- **Configuration**: `vitest.config.ts` or `jest.config.js`.
- **UI Components**: `docs/archive/src/app/components/ui` - Common components requiring regression tests.

## Key Files for Testing
- `docs/archive/src/app/components/ui/utils.ts`: Contains `cn` helper.
- `docs/archive/src/app/components/ui/use-mobile.ts`: Hook requiring device-width mocks.
- `docs/archive/src/app/components/WelcomeScreen.tsx`: Main entry point UI.

## Collaboration Checklist
1.  **Coverage Check**: Run coverage reports and identify "blind spots" in the logic.
2.  **CI Alignment**: Ensure new tests pass in the CI environment.
3.  **Documentation**: If a new testing utility is created, document it in `docs/testing-strategy.md`.

## Hand-off Notes
When completing a task, the agent should:
- List all new test files created.
- Report the final coverage percentage for the modified modules.
- Mention any mocked dependencies that might need real integration testing later.
