# Tooling & Productivity Guide

This guide outlines the development environment, automation workflows, and editor configurations used in the `ControledeEstoques` project. Following these standards ensures consistent code quality and maximizes developer velocity.

## Required Tooling

To contribute effectively to this codebase, you must have the following tools installed:

| Tool | Version | Purpose |
| :--- | :--- | :--- |
| **Node.js** | >= 18.x (LTS recommended) | Core runtime for the frontend application. |
| **npm** or **pnpm** | latest | Package management and script execution. |
| **Git** | latest | Version control and collaboration. |

### Installation Instructions
1. **Node.js**: Download from [nodejs.org](https://nodejs.org/).
2. **Dependencies**: Run `npm install` (or `pnpm install`) in the project root to install all required libraries.

---

## IDE / Editor Setup (Visual Studio Code)

While you can use any editor, **VS Code** is recommended due to the existing workspace configurations.

### Recommended Extensions
- **ESLint**: Integrates linting directly into the editor to catch syntax and style errors.
- **Prettier - Code Formatter**: Automatically formats code on save.
- **Tailwind CSS IntelliSense**: Provides autocomplete and linting for utility classes.
- **ES7+ React/Redux/React-Native snippets**: Speeds up component creation.

### Workspace Settings
Create or update `.vscode/settings.json` in your local environment to enable "Format on Save":

```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit"
  },
  "tailwindCSS.emmetCompletions": true
}
```

---

## Recommended Automation

The project utilizes several automated scripts to maintain code health.

### Linting & Formatting
Before submitting a Pull Request, run the following to ensure compliance with the project's style guide:

```bash
# Run ESLint to find issues
npm run lint

# Automatically fix fixable linting issues
npm run lint:fix

# Format code using Prettier
npm run format
```

### Component Scaffolding
The project uses a structured UI system (Radix-based components). When creating new UI elements:
1. Reference existing patterns in `docs\archive\src\app\components\ui\`.
2. Use the `cn` utility from `docs\archive\src\app\components\ui\utils.ts` for dynamic class merging:

```typescript
import { cn } from "@/components/ui/utils";

export function MyComponent({ className }) {
  return <div className={cn("base-styles", className)} />;
}
```

---

## Productivity Tips

### Terminal Aliases
If you frequently interact with the dev server and linting tools, consider adding these aliases to your `.zshrc` or `.bashrc`:

```bash
alias cde-dev='npm run dev'
alias cde-fix='npm run lint:fix && npm run format'
```

### Common Development Commands
- **Start Development Server**: `npm run dev`
- **Build for Production**: `npm run build`
- **Type Checking**: `npx tsc --noEmit` (Run this frequently to catch TypeScript errors that IDEs might miss).

### Working with UI Components
The repository contains a robust set of UI primitives. Before building a new component from scratch, check `docs\archive\src\app\components\ui\` for reusable patterns such as:
- `Sidebar` / `useSidebar` for navigation.
- `Form` / `FormControl` for validated inputs.
- `Dialog` / `Sheet` for overlays.

By leveraging these pre-built symbols, you maintain visual consistency and reduce the amount of CSS you need to write.
