# Security Auditor Agent Playbook

## Mission
The Security Auditor agent is dedicated to identifying, mitigating, and preventing security vulnerabilities within the `ControledeEstoques` codebase. It should be engaged during PR reviews, when implementing new API endpoints, when handling sensitive user data, or during scheduled security audits.

## Responsibilities
- **Vulnerability Identification**: Scan for OWASP Top 10 issues (SQL Injection, XSS, CSRF, Broken Access Control).
- **Authorization Logic**: Verify that every API route and server action implements proper role-based access control (RBAC).
- **Data Protection**: Ensure sensitive information (passwords, PII) is encrypted at rest and in transit.
- **Dependency Management**: Audit `package.json` for known vulnerabilities in third-party libraries.
- **Environment Security**: Ensure secrets are never committed and are managed via `.env` templates.

## Targeted Audit Areas

### 1. Authentication & Session Management
- **Focus**: `src/middleware.ts`, `src/app/api/auth/`, and any Auth.js (NextAuth) configurations.
- **Checklist**:
    - Are sessions invalidated correctly on logout?
    - Are cookies configured with `HttpOnly`, `Secure`, and `SameSite=Lax/Strict`?
    - Is CSRF protection active on state-changing requests?

### 2. API Routes & Server Actions
- **Focus**: `src/app/api/`, `src/lib/actions/` (or equivalent server action directories).
- **Checklist**:
    - Does every action validate the user's session?
    - Is input validation performed using a schema builder like `Zod`?
    - Are database queries using parameterized inputs (Prisma/TypeORM) to prevent SQLi?

### 3. Frontend Security
- **Focus**: `src/app/components/`, `src/hooks/`.
- **Checklist**:
    - Use of `dangerouslySetInnerHTML` must be strictly audited or replaced.
    - Check for client-side exposure of sensitive environment variables (those not prefixed with `NEXT_PUBLIC_`).
    - Verify that sensitive data is not stored in `localStorage` or `sessionStorage` without encryption.

### 4. Database & Permissions
- **Focus**: `prisma/schema.prisma` or `src/db/`.
- **Checklist**:
    - Verify Row Level Security (RLS) if using Supabase or similar.
    - Ensure database connection strings are handled as secrets.

## Common Workflows

### Task: Auditing a New API Endpoint
1.  **Locate**: Identify the endpoint file in `src/app/api/.../route.ts`.
2.  **Auth Check**: Verify `getServerSession` or equivalent is called at the start.
3.  **Input Validation**: Confirm `Zod` or similar is used to parse the request body/params.
4.  **Logic Review**: Ensure the logic does not allow an authenticated user to access data belonging to another user (IDOR check).
5.  **Output Sanitization**: Ensure sensitive fields (e.g., `hashedPassword`, `internalNote`) are stripped before returning JSON.

### Task: Dependency Security Update
1.  **Scan**: Run `npm audit` or `yarn audit`.
2.  **Evaluate**: Determine if the vulnerable code path is actually reachable in this application.
3.  **Patch**: Update the version in `package.json` and verify there are no breaking changes in UI components.

## Best Practices (Project-Specific)
- **Schema Validation**: Always use Zod schemas for `Request` bodies.
- **Early Returns**: Use early returns for unauthorized access attempts to minimize execution time and complexity.
- **Centralized Auth**: Prefer using middleware for route-level protection to ensure a "deny-by-default" posture.
- **Lucide Icons**: When using icons for security statuses, stick to the `Lucide` library as per the UI pattern.

## Key Files & Their Security Purpose
- `src/middleware.ts`: Global route protection and redirect logic.
- `.env.example`: Template for required secrets; used to verify no real secrets are committed.
- `package.json`: Source of truth for dependency versions and security scripts.
- `prisma/schema.prisma`: Defines the data model and access relationships.
- `src/components/ui/`: Contains reusable UI components; audit for safe prop handling.

## Architecture Context

### Authentication Flow
The application likely uses Next.js middleware or server-side session checks. The Security Auditor must verify that components in `docs/archive/src/app/components` do not bypass these checks by making direct unauthenticated calls to internal utilities.

### UI Utility: `cn`
- **Location**: `docs/archive/src/app/components/ui/utils.ts`
- **Security Note**: While used for class merging, ensure that dynamic class names derived from user input are sanitized to prevent CSS injection (though low risk).

## Collaboration Checklist
1.  **Review PRs**: Look for any changes to `package.json` or files in `api/` folders.
2.  **Security Labels**: Tag issues with `security` or `vulnerability`.
3.  **Documentation Update**: If a new security pattern is established (e.g., a new hashing utility), update `docs/security.md`.

## Hand-off Notes
- List all identified vulnerabilities with a severity rating (Low/Medium/High/Critical).
- Provide code snippets for suggested fixes.
- Highlight any "Technical Debt" that could lead to security issues in the future.
