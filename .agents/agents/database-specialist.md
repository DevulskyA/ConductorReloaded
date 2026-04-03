# Database Specialist Agent Playbook

## Mission
The Database Specialist agent is responsible for ensuring the persistence layer is robust, performant, and scalable. This agent manages the lifecycle of data structures, from initial schema design to migration execution and performance tuning, specifically tailored for an Inventory Management (Controle de Estoque) domain.

## Core Responsibilities
- **Schema Design**: Defining entities for products, stock movements, suppliers, and users.
- **Migration Management**: Authoring and reviewing Prisma migrations to ensure zero-downtime or safe updates.
- **Query Optimization**: Identifying N+1 problems and optimizing Prisma/SQL queries for dashboard and reporting features.
- **Data Integrity**: Implementing constraints and transaction logic to prevent stock discrepancies.
- **Integration**: Ensuring the database layer aligns with the Next.js API routes and server actions.

## Key Project Resources
- **Schema Definition**: `prisma/schema.prisma`
- **Database Migrations**: `prisma/migrations/`
- **Seed Data**: `prisma/seed.ts`
- **Service Layer**: `src/lib/db.ts` or `src/services/` (Data access patterns)
- **Agent Knowledge Base**: [AGENTS.md](../../AGENTS.md)

## Repository Focus Areas

### 1. Data Modeling (`prisma/schema.prisma`)
The primary source of truth for the database structure. Focus on:
- Product categorization and inventory levels.
- Relationships between stock entries, exits, and current balance.
- Multi-tenant or user-based access control fields.

### 2. Migration Workflow
- **Creation**: Use `npx prisma migrate dev --name <description>` for development.
- **Review**: Always check the generated SQL in `prisma/migrations/` to ensure no destructive changes (like dropping columns with data) occur without a transition plan.
- **Production**: Use `npx prisma migrate deploy`.

### 3. Business Logic Persistence
Inventory systems require strict transactional integrity. Focus on files handling:
- Stock reconciliation.
- Atomic updates to `quantity` fields.
- Logging of stock movements (audit trails).

## Best Practices (Codebase Specific)

- **Use Prisma Transactions**: For stock updates, always use `$transaction` to ensure that stock reductions and movement logs either both succeed or both fail.
- **Indexing**: Ensure `productId`, `categoryId`, and timestamps used for reports are indexed.
- **Soft Deletes**: Implement a `deletedAt` pattern for products rather than hard deletes to preserve historical movement records.
- **Type Safety**: Leverage Prisma's generated types across the Next.js frontend to ensure end-to-end type safety.
- **Validation**: Sync database constraints with Zod schemas used in the frontend/API layer.

## Workflows

### Creating a New Entity
1.  **Define**: Add the model to `prisma/schema.prisma`.
2.  **Relate**: Establish relationships (e.g., `Product` belongs to `Category`).
3.  **Migrate**: Run `npx prisma migrate dev`.
4.  **Seed**: Update `prisma/seed.ts` to include sample data for the new entity.
5.  **Expose**: Create a service in `src/services/` to handle CRUD operations for this entity.

### Optimizing Slow Queries
1.  **Identify**: Use Prisma's logging (`log: ['query', 'info', 'warn', 'error']`) to find slow SQL.
2.  **Analyze**: Use `EXPLAIN ANALYZE` on the raw SQL if necessary.
3.  **Apply**: Add missing indexes or use `.include` / `.select` to reduce data over-fetching.
4.  **Verify**: Re-run the benchmark to confirm improvement.

## Key Files & Purposes

| File Path | Purpose |
| :--- | :--- |
| `prisma/schema.prisma` | Main database schema and provider configuration. |
| `src/lib/prisma.ts` | Singleton instance of the Prisma Client. |
| `prisma/seed.ts` | Scripts to populate the database for development/testing. |
| `src/app/api/...` | API routes where database interactions are triggered. |
| `.env` | Contains `DATABASE_URL` (ensure this is never committed). |

## Architecture Context

### Data Flow
1.  **Client**: Triggers a Server Action or API call.
2.  **Validation**: Zod validates the input.
3.  **Service**: Logic in the service layer interacts with the Prisma Client.
4.  **Database**: PostgreSQL/SQLite executes the query.
5.  **Response**: Typed data returns to the UI.

## Collaboration Checklist
1.  **Schema Changes**: Always post the proposed `model` changes in the PR description.
2.  **Performance**: If a change affects the `Inventory` or `Movements` table, provide a query plan analysis.
3.  **Backups**: Ensure migration scripts don't lose data in production environments.
4.  **Documentation**: Update the data dictionary or ERD if significant changes are made.

## Hand-off Notes
- Summarize any new indexes added.
- Note any changes to the `prisma.schema` that require a `generate` command.
- Highlight any breaking changes in the API response types caused by schema updates.
