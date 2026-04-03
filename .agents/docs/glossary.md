# Glossary & Domain Concepts

This document defines the technical and domain-specific terminology used throughout the **Controle de Estoques** repository. It serves as a reference for developers to ensure consistent language across the codebase and documentation.

## Type Definitions

| Term | Category | Definition | Source |
| :--- | :--- | :--- | :--- |
| `ChartConfig` | Type | A configuration object defining the mapping, labels, and colors for data visualization components. | [`chart.tsx`](docs/archive/src/app/components/ui/chart.tsx) |
| `ViewMode` | Type | Determines the layout of the Prompt Library (e.g., "grid", "list"). | [`PromptLibrary.tsx`](docs/archive/src/app/components/PromptLibrary.tsx) |
| `CarouselApi` | Type | The instance API provided by the Embla Carousel hook for programmatic control. | [`carousel.tsx`](docs/archive/src/app/components/ui/carousel.tsx) |
| `cn` | Function | A utility for conditionally joining CSS classes using `clsx` and `tailwind-merge`. | [`utils.ts`](docs/archive/src/app/components/ui/utils.ts) |

## Core Terms

### Inventory Management (Estoque)
*   **Prompt Library**: A centralized repository within the application where users can store, search, and manage reusable AI prompts.
*   **Prompt Card**: The visual representation of a single prompt entity, displaying metadata like title, description, and tags.
*   **Sidebar**: The primary navigation component used to switch between different modules of the inventory system.

### UI Infrastructure
*   **Component UI (Shadcn/ui pattern)**: The project follows a pattern of decoupled, accessible UI components (e.g., `Sheet`, `Select`, `Dialog`) built on top of Radix UI primitives.
*   **Slot**: A primitive from `@radix-ui/react-slot` used to merge properties onto its immediate child, often used in buttons and triggers.

## Acronyms & Abbreviations

| Acronym | Full Name | Description |
| :--- | :--- | :--- |
| **OTP** | One-Time Password | Used in `InputOTP` components for secure verification workflows. |
| **A11y** | Accessibility | Refers to the implementation of ARIA labels and keyboard navigation in components. |
| **RTL** | Right-to-Left | Supported in specific UI primitives for localization. |

## Personas / Actors

### Stock Manager (Gestor de Estoque)
*   **Goals**: Maintain accurate records of items, monitor levels, and generate reports.
*   **Workflows**: Uses the `Sidebar` to navigate between product listings and the `Chart` components to visualize stock trends.
*   **Pain Points**: Inconsistent data entry and slow lookup of specific item categories.

### System Administrator
*   **Goals**: Configure application settings, manage user permissions, and maintain the `Prompt Library`.
*   **Workflows**: Utilizes `Form` components and `Select` triggers to modify system-wide configurations.

## Domain Rules & Invariants

1.  **Mobile Responsiveness**: Components must utilize the `useIsMobile` hook to adapt layouts (e.g., changing a `Sidebar` to a `Sheet` on small screens).
2.  **Form Validation**: All user inputs must be wrapped in `FormControl` and `FormItem` to ensure consistent error messaging and validation states.
3.  **Fallback Mechanism**: Images (specifically in Figma-related or product previews) must use `ImageWithFallback` to prevent broken UI when external assets are missing.
4.  **Consistency**: UI elements must use the `cn` utility for class merging to ensure Tailwind CSS utility classes are merged correctly without conflicts.
