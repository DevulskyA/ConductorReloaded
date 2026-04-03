# Project Overview

The **Controle de Estoques** project is a modern inventory management application designed to streamline stock tracking, prompt management, and resource organization. Built with a focus on usability and responsiveness, it provides a robust interface for handling complex data sets through interactive dashboards and libraries.

## Quick Facts

- **Root path**: `C:\Users\devul\Desktop\ControledeEstoques`
- **Primary languages**: TypeScript (React), CSS (Tailwind)
- **Architecture**: Component-driven UI with a centralized utility layer.
- **Repository Size**: 53 `.tsx` files, 32 `.md` documentation files.

## Entry Points

The application is structured as a Vite-powered React application.
- **Main Application**: `docs\archive\src\app\App.tsx` serves as the primary layout and routing hub.
- **Main Library View**: `docs\archive\src\app\components\PromptLibrary.tsx` is the central interface for interacting with the core inventory/prompt data.

## Key Exports

### Core UI Components
- **`WelcomeScreen`**: The landing experience for the application.
- **`PromptCard`**: A standardized display component for inventory items or prompts.
- **`ImageWithFallback`**: A utility component for robust asset rendering.
- **`Sidebar`**: The primary navigation interface using the `useSidebar` hook.

### Utilities & Hooks
- **`cn`**: A utility for merging Tailwind CSS classes conditionally.
- **`useIsMobile`**: A hook for detecting viewport size to adjust layouts dynamically.
- **`ChartConfig`**: Configuration types for data visualization components.

## File Structure & Code Organization

The repository follows a feature-based organization within a React/Vite ecosystem:

- **`docs/`**: Living documentation and project archives.
- **`docs/archive/src/app/components/`**: The main repository for React components.
  - **`ui/`**: Low-level, reusable primitive components (Buttons, Inputs, Modals, etc.) following the Shadcn/UI pattern.
  - **`figma/`**: Specialized components designed to mirror design specifications.
- **`vite.config.ts`**: Configuration for the Vite build tool and development server.
- **`vitest.config.ts`**: Configuration for the Vitest testing suite.
- **`API_CATALOG.md`**: Index of available API endpoints and data structures.
- **`PROJECT_MAP.md`**: A high-level visual or textual map of the codebase architecture.

## Technology Stack Summary

### Core Framework Stack
- **Frontend**: React 18+ with TypeScript for type safety and IDE support.
- **State Management**: React Hooks (useState, useMemo) and Context API for UI state (e.g., Sidebar visibility).
- **Build Tool**: Vite for fast HMR (Hot Module Replacement) and optimized production builds.
- **Testing**: Vitest for unit and component testing.

### UI & Interaction Libraries
- **Styling**: Tailwind CSS for utility-first styling.
- **Components**: Based on Radix UI primitives (via Shadcn/UI) for accessibility (WAI-ARIA compliance).
- **Icons**: Lucide React for consistent iconography.
- **Charts**: Recharts or similar for data visualization (configured via `ChartConfig`).
- **Form Handling**: Integrated with `react-hook-form` and `zod` for validation.

## Development Tools Overview

- **`npm run dev`**: Starts the Vite development server.
- **`npm run build`**: Compiles the application for production.
- **`npm run test`**: Executes the Vitest suite.
- **`docs/`**: Always refer to the internal documentation for specific component implementation details.

## Getting Started Checklist

1. **Environment Setup**: Ensure Node.js (v18+) is installed.
2. **Installation**: Run `npm install` to fetch all dependencies.
3. **Run App**: Launch the dev server with `npm run dev`.
4. **Architecture Review**: Examine `docs\archive\src\app\components\ui\sidebar.tsx` as it is a central dependency for the layout.

## Next Steps

- **Feature Ledger**: Consult `FEATURE_LEDGER.md` for a roadmap of implemented and upcoming capabilities.
- **Component Exploration**: Review the `PromptLibrary` component to understand how data is fetched and displayed.
- **Styling Guidelines**: Follow the Tailwind patterns established in `docs\archive\src\app\components\ui\utils.ts`.
