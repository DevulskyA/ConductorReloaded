# Architecture Notes

This document describes the architectural design of the **Controle de Estoques** application. It outlines the structural layers, design patterns, and system boundaries used to ensure a maintainable and scalable frontend codebase.

## System Architecture Overview

The application follows a **Modular Frontend Monolith** architecture built with React and Vite. It leverages a component-driven development approach, where the UI is assembled from highly reusable, atomic components (Radix UI/Shadcn) into complex features and layouts.

The system is organized into a clear hierarchy:
1.  **Entry Point**: `App.tsx` serves as the root container.
2.  **Feature Components**: Complex views like `PromptLibrary` and `WelcomeScreen`.
3.  **UI Components**: Atomic, low-level components (buttons, inputs, sidebars) located in the `ui` directory.
4.  **Utilities**: Shared helper functions for styling and logic.

## Architectural Layers

### Utils
Shared utilities and helpers that provide cross-cutting concerns like style merging and data formatting.
- **Directories**: `docs/archive/src/app/components/ui`, `docs/archive/src/app/components`
- **Key exports**:
    - `cn`: A utility using `clsx` and `tailwind-merge` to handle conditional CSS classes and prevent Tailwind conflicts.

### Components
The UI layer is divided into specialized directories based on responsibility.
- **Directories**: 
    - `ui/`: Design system components (Radix-based).
    - `figma/`: Specific components translated or exported from design files.
    - `root/`: Feature-level components like `Sidebar` and `PromptCard`.
- **Key Symbols**: 92 total components including `useSidebar`, `ChartConfig`, and `PromptCard`.

## Detected Design Patterns

### 1. Compound Component Pattern
Many UI components (e.g., `Select`, `Tooltip`, `NavigationMenu`) utilize the compound component pattern. This allows for a declarative API where sub-components share state internally.
*Example: `Tooltip` → `TooltipTrigger` + `TooltipContent`.*

### 2. Context-Based State Management
The architecture relies heavily on React Context for localized state sharing:
- **Sidebar Context**: Managed via `useSidebar` to control navigation state across the layout.
- **Form Context**: Managed via `form.tsx` for deeply nested validation and state tracking.

### 3. Utility-First Styling
The system uses **Tailwind CSS** combined with the `cn` utility to ensure styles are co-located with components while remaining extensible through `className` props.

## Entry Points
- **Primary Entry**: `docs\archive\src\app\App.tsx`
    - Initializes the main layout provider.
    - Orchestrates the `Sidebar` and main content areas.
- **Navigation Root**: `docs\archive\src\app\components\Sidebar.tsx`
    - Acts as the primary navigation hub for the application.

## Public API

The following symbols represent the primary interfaces for building new features within the application:

| Symbol | Type | Location | Description |
| --- | --- | --- | --- |
| `cn` | function | `ui/utils.ts` | Merges Tailwind classes safely. |
| `ChartConfig` | type | `ui/chart.tsx` | Configuration object for data visualizations. |
| `PromptCard` | function | `PromptCard.tsx` | standardized display for data/prompt items. |
| `useIsMobile` | hook | `ui/use-mobile.ts` | Responsive breakpoint detection. |
| `WelcomeScreen` | function | `WelcomeScreen.tsx` | Default landing state for the application. |

## Internal System Boundaries

- **UI vs. Logic**: Logic is increasingly abstracted into hooks (e.g., `useSidebar`, `useCarousel`).
- **Styling Seam**: The `cn` utility acts as the boundary between component definition and external style overrides.
- **Design System**: The `components/ui` folder is treated as a local design system; changes here propagate globally across all feature components.

## External Service Dependencies

- **Radix UI**: Provides the accessible primitives for almost all interactive components (Dropdowns, Tabs, Sheets).
- **Lucide React**: The standard icon library used across the interface.
- **Vite**: The build tool and development server.

## Key Decisions & Trade-offs

1.  **Shadcn/UI Integration**: Components are copied into the source tree rather than used as an NPM package. This allows for deep customization of the design system but increases the maintenance surface area.
2.  **Modular CSS**: By using Tailwind, the project avoids CSS specificity issues and minimizes bundle size by shipping only used utility classes.
3.  **Strict Typing**: Interfaces like `SidebarProps` and `PromptCardProps` are explicitly defined to ensure data consistency between parent and child components.

## Top Directories Snapshot

- `docs/archive/src/app/components/ui`: Contains the atomic UI building blocks (40+ files).
- `docs/archive/src/app/components`: Contains business-specific components and layouts.
- `docs/archive/src/app/components/figma`: Specialized assets or components directly linked to design specifications.

## Related Resources

- [Project Overview](./project-overview.md)
- [Component Index](./API_CATALOG.md)
