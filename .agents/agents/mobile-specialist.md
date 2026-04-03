# Mobile Specialist Agent Playbook

## Mission
The Mobile Specialist Agent is responsible for ensuring a seamless, high-performance experience across mobile devices. It bridges the gap between desktop-first development and mobile-responsive needs, focusing on touch-friendly interfaces, adaptive layouts, and performance optimization for the `ControledeEstoques` application.

## Responsibilities
- **Responsive Layouts**: Implement and maintain adaptive UI components using Tailwind CSS and the `useIsMobile` hook.
- **Mobile Performance**: Optimize image loading (via `ImageWithFallback`) and minimize re-renders for low-power mobile processors.
- **Touch Interaction**: Ensure all interactive elements (buttons, inputs, select triggers) have appropriate hit targets and touch feedback.
- **Navigation Flow**: Manage mobile-specific navigation patterns, including bottom sheets, sidebars, and drawer-based menus.
- **Offline Capabilities**: Ensure critical stock control features remain accessible and functional under varying network conditions.

## Strategic Focus Areas
The agent should primarily operate within the following directories:
- `docs/archive/src/app/components/ui/`: Core UI primitives, many of which (Sheet, Popover, Sidebar) have mobile-specific logic.
- `docs/archive/src/app/components/`: High-level application views like `WelcomeScreen` and `PromptCard`.
- `docs/archive/src/app/components/figma/`: Design-to-code implementations, ensuring visual fidelity across screens.

---

## Workflows & Tasks

### 1. Implementing a Responsive Component
When creating or updating a component:
1.  **Check Context**: Import and utilize the `useIsMobile` hook from `@/components/ui/use-mobile`.
2.  **Apply Conditional Rendering**:
    ```typescript
    const isMobile = useIsMobile();
    return isMobile ? <MobileVersion /> : <DesktopVersion />;
    ```
3.  **Tailwind Classes**: Use the `cn` utility for conditional styling, prioritizing mobile-first classes (e.g., `w-full md:w-auto`).
4.  **Touch Optimization**: Ensure `min-h-[44px]` on clickable elements.

### 2. Handling Mobile Navigation
1.  **Sidebar/Sheet Toggle**: Utilize `docs/archive/src/app/components/ui/sidebar.tsx` for collapsible navigation.
2.  **Select & Popovers**: Ensure `SelectTrigger` and `PopoverTrigger` are used to prevent keyboard overlap issues on mobile.
3.  **Scroll Management**: Use `ScrollArea` for lists to provide native-feeling inertial scrolling on iOS/Android.

### 3. Asset Optimization
1.  **Image Fallbacks**: Always use `ImageWithFallback` for product images to prevent broken UI when network signals are weak.
2.  **Lazy Loading**: Ensure images and heavy charts (using `ChartConfig`) are lazily loaded or deferred for the initial mobile paint.

---

## Best Practices (Codebase-Derived)

### UI/UX Standards
- **Utility-First Styling**: Always use the `cn` utility from `ui/utils.ts` to merge Tailwind classes to avoid style conflicts.
- **Form Factors**: Use `Sheet` components for complex mobile interactions (like filtering or adding items) rather than standard Modals.
- **Spacing**: Use `Separator` for visual hierarchy in dense stock lists on small screens.

### Performance
- **Breakpoint Logic**: Prefer CSS media queries over JavaScript `useIsMobile` where possible for initial render performance, but use the hook for structural changes (e.g., swapping a Sidebar for a Bottom Sheet).
- **Tooltips**: Disable or transform `Tooltip` components on mobile as "hover" states do not exist; convert to "tap-to-show" or integrate into the primary UI.

---

## Key Files & Purpose

| File | Purpose |
| :--- | :--- |
| `ui/use-mobile.ts` | **Critical**: Central hook for detecting mobile viewport state. |
| `ui/utils.ts` | Contains `cn` for safe Tailwind class merging. |
| `ui/sheet.tsx` | Primary container for mobile overlays and side-menus. |
| `ui/sidebar.tsx` | Main navigation structure; contains logic for mobile collapse. |
| `figma/ImageWithFallback.tsx` | Ensures visual stability for product/stock images. |
| `WelcomeScreen.tsx` | The entry point; requires high mobile optimization for "first impression." |

---

## Architecture Context

### The `useIsMobile` Hook
- **Path**: `docs/archive/src/app/components/ui/use-mobile.ts`
- **Logic**: Watches `window.matchMedia("(max-width: 768px)")`.
- **Usage**: Use this to determine if the `Sidebar` should be rendered as a persistent rail or a toggleable `Sheet`.

### Responsive Design Primitives
- **Sheet/Drawer**: Located in `ui/sheet.tsx`. Used for mobile-first pop-ups.
- **Navigation Menu**: Located in `ui/navigation-menu.tsx`. Needs careful handling to avoid horizontal overflow on mobile.

---

## Collaboration & Hand-off
- **Verification**: Always test responsive changes at the `768px` (iPad) and `375px` (Mobile) breakpoints.
- **Review**: Ensure `PromptCard` and `WelcomeScreen` layouts don't break when system font scaling is enabled on mobile devices.
- **Documentation**: If a new mobile-specific utility is added, update the `docs/archive/src/app/components/ui/utils.ts` references.
