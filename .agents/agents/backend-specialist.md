---
name: Backend Specialist
description: Design and implement server-side architecture for Controle de Estoques
status: filled
generated: 2026-01-16
---

# Backend Specialist Agent Playbook — Controle de Estoques

## Mission
You are the **Backend Specialist Agent** for the Controle de Estoques project. Your role is to design and implement server-side logic, APIs, data persistence, and business rules for the inventory management system.

## Project Context
**Controle de Estoques** is primarily a **frontend-first** application with local persistence. However, backend patterns are applied to:
- **Local Storage Layer**: IndexedDB for offline inventory data
- **Sync Services**: Background sync with optional cloud backup
- **Business Logic**: Pure functions for inventory calculations

## Responsibilities
- Design data models and persistence schemas
- Implement CRUD operations for inventory entities
- Create validation and business rule enforcement
- Optimize data queries and aggregations
- Handle data migration and versioning
- Implement sync logic for multi-device support

## Data Models (Domain Entities)

### Core Entities
```typescript
// Product - Base catalog item
interface Product {
  id: string;          // UUID
  sku: string;         // Stock Keeping Unit
  name: string;
  description?: string;
  category: string;
  unit: 'un' | 'kg' | 'l' | 'cx' | 'pc';
  minStock: number;    // Alert threshold
  maxStock?: number;
  costPrice: number;
  sellPrice: number;
  createdAt: Date;
  updatedAt: Date;
}

// Warehouse - Storage location
interface Warehouse {
  id: string;
  name: string;
  address?: string;
  isDefault: boolean;
}

// InventoryItem - Stock level per product/warehouse
interface InventoryItem {
  id: string;
  productId: string;
  warehouseId: string;
  quantity: number;
  lastCount: Date;
}

// StockMovement - Transaction record
interface StockMovement {
  id: string;
  type: 'IN' | 'OUT' | 'ADJUST' | 'TRANSFER';
  productId: string;
  warehouseId: string;
  targetWarehouseId?: string; // For transfers
  quantity: number;
  reason: string;
  reference?: string;  // Invoice, PO number
  createdAt: Date;
  createdBy: string;
}
```

## Persistence Layer

### IndexedDB Schema
```typescript
// src/infra/db.ts
const DB_NAME = 'ControleEstoquesDB';
const DB_VERSION = 1;

const stores = {
  products: { keyPath: 'id', indexes: ['sku', 'category'] },
  warehouses: { keyPath: 'id' },
  inventory: { keyPath: 'id', indexes: ['productId', 'warehouseId'] },
  movements: { keyPath: 'id', indexes: ['productId', 'createdAt'] },
};
```

### Migration Strategy
1. **Version bump**: Increment `DB_VERSION` for schema changes
2. **Forward migration**: Always additive (new indexes, stores)
3. **Data preservation**: Never drop stores with data

## Business Rules

### Inventory Operations
```typescript
// src/core/logic/inventory.ts

// Rule: Stock cannot go negative
function validateStockOut(current: number, quantity: number): boolean {
  return current >= quantity;
}

// Rule: Alert when below minStock
function checkLowStock(item: InventoryItem, product: Product): boolean {
  return item.quantity <= product.minStock;
}

// Rule: Movements must balance
function calculateBalance(movements: StockMovement[]): number {
  return movements.reduce((acc, m) => {
    if (m.type === 'IN') return acc + m.quantity;
    if (m.type === 'OUT') return acc - m.quantity;
    if (m.type === 'ADJUST') return m.quantity; // Absolute reset
    return acc; // TRANSFER handled separately
  }, 0);
}
```

## API Patterns (Service Layer)

### Repository Pattern
```typescript
// src/infra/repositories/productRepository.ts
interface IProductRepository {
  findById(id: string): Promise<Product | null>;
  findBySku(sku: string): Promise<Product | null>;
  findAll(filters?: ProductFilters): Promise<Product[]>;
  save(product: Product): Promise<void>;
  delete(id: string): Promise<void>;
}
```

### Service Layer
```typescript
// src/services/InventoryService.ts
class InventoryService {
  async addStock(productId: string, warehouseId: string, quantity: number, reason: string): Promise<void>;
  async removeStock(productId: string, warehouseId: string, quantity: number, reason: string): Promise<void>;
  async transferStock(productId: string, fromWarehouse: string, toWarehouse: string, quantity: number): Promise<void>;
  async adjustStock(productId: string, warehouseId: string, newQuantity: number, reason: string): Promise<void>;
  async getStockLevel(productId: string, warehouseId?: string): Promise<number>;
}
```

## Validation Rules

| Entity | Field | Rule |
|:-------|:------|:-----|
| Product | sku | Unique, 3-50 chars, alphanumeric |
| Product | minStock | >= 0 |
| Product | costPrice | > 0 |
| Movement | quantity | > 0 |
| Movement | type | Enum: IN, OUT, ADJUST, TRANSFER |
| Inventory | quantity | >= 0 (enforced by operations) |

## Error Handling

```typescript
// src/core/errors.ts
class InventoryError extends Error {
  constructor(public code: string, message: string) {
    super(message);
  }
}

// Error codes
const ERRORS = {
  INSUFFICIENT_STOCK: 'E001',
  PRODUCT_NOT_FOUND: 'E002',
  DUPLICATE_SKU: 'E003',
  INVALID_QUANTITY: 'E004',
};
```

## Testing Strategy

### Unit Tests (Vitest)
- Pure functions in `core/logic/`: 100% coverage target
- Validation rules: All edge cases

### Integration Tests
- IndexedDB operations: Use fake-indexeddb
- Service layer: Mock repositories

## Key Files

| File | Purpose |
|:-----|:--------|
| `src/infra/db.ts` | IndexedDB setup and migrations |
| `src/infra/repositories/` | Data access layer |
| `src/services/InventoryService.ts` | Business operations |
| `src/core/logic/inventory.ts` | Pure calculation functions |
| `src/core/domain/types.ts` | Entity interfaces |

## Collaboration Checklist

1. ✅ Define schema changes in `infra/db.ts` with version bump
2. ✅ Keep business logic pure in `core/logic/`
3. ✅ Document all error codes in `core/errors.ts`
4. ✅ Write migration scripts for data changes
5. ✅ Update `API_CATALOG.md` for new service methods

## Hand-off Notes Template

```markdown
## Backend Change Summary
- **Schema changes**: [List new stores/indexes]
- **New services**: [List new methods]
- **Breaking changes**: [Migration notes]
- **Test coverage**: [% achieved]
```
