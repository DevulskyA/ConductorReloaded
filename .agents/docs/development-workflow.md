# Development Workflow

This document outlines the day-to-day engineering processes and standards for the **Controle de Estoques** repository.

---

## Branching & Releases

We follow a **Trunk-Based Development** model to ensure continuous integration and rapid delivery.

### Branching Model
- **Main Branch (`main`)**: The production-ready code. All features are merged here after passing CI and peer review.
- **Feature Branches (`feat/...`, `fix/...`)**: Short-lived branches used for development. 
- **Naming Convention**: 
    - Features: `feat/issue-number-description`
    - Bug fixes: `fix/issue-number-description`
    - Documentation: `docs/description`

### Release Process
- **Tagging**: Releases are tagged using Semantic Versioning (e.g., `v1.0.0`).
- **Cadence**: Deployment occurs automatically to the staging environment upon merging to `main`. Production releases are triggered manually via GitHub Releases.

---

## Local Development

The project is built using React with a focus on modular UI components.

### Setup & Installation
Ensure you have Node.js (v18+) installed.

```bash
# Install dependencies
npm install

# Start the development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run start
```

### Component Development
We use a utility-first CSS approach with Tailwind CSS and Radix UI primitives (via Shadcn UI).
- New components should be placed in `src/components/ui` for primitives or `src/components` for feature-specific logic.
- Always use the `cn` utility for conditional class merging.

```typescript
import { cn } from "@/lib/utils";

export function CustomButton({ className, ...props }) {
  return <button className={cn("base-styles", className)} {...props} />;
}
```

---

## Code Review Expectations

All Pull Requests (PRs) must undergo a peer review before merging.

### Review Checklist
1. **Functionality**: Does the code solve the intended problem?
2. **Type Safety**: Are interfaces and types correctly defined? (Avoid `any`).
3. **Accessibility**: Do UI components follow ARIA patterns? (Use Radix-based components).
4. **Performance**: Are there unnecessary re-renders in heavy components (e.g., `PromptLibrary`)?
5. **Styling**: Does it follow the established design tokens and use `Tailwind CSS`?

### Agent Collaboration
When working with AI agents:
- Ensure generated code adheres to the project's directory structure.
- Reference existing patterns in `src/app/components/ui` to maintain consistency.
- Consult [AGENTS.md](../../AGENTS.md) for specific prompting instructions and context injection.

---

## Onboarding Tasks

New developers should complete the following tasks to get familiar with the codebase:

1. **Environment Setup**: Clone the repo and successfully run `npm run dev`.
2. **Component Audit**: Explore the `src/app/components/ui` directory to understand the available design system primitives.
3. **First Ticket**: Look for issues labeled `good first issue` or `documentation` in the issue tracker.
4. **Style Guide**: Familiarize yourself with the `cn` utility and the use of `Lucide React` icons across the application.

### Key Files for Reference
- `src/app/components/ui/utils.ts`: Contains the `cn` helper.
- `src/app/components/Sidebar.tsx`: Core layout navigation.
- `src/app/App.tsx`: Main application entry point.
