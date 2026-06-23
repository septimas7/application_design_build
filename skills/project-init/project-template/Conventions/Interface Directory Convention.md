---
doc_type: convention
unit: system
title: Interface Directory Convention
status: active
version: r1
owner: {{OWNER}}
created: {{DATE}}
last_updated: {{TIMESTAMP}}
related:
  - "Documentation System Guide.md"
  - "Dictionary Convention.md"
tags:
  - {{project-slug}}
  - convention
  - directory
  - interfaces
---

# Interface Directory Convention

Governs the five **Directories** (interaction surfaces — *how to interact*) in every unit's `Directories/` folder:

- **`MCP Tools Directory.md`** — agent-facing tools
- **`API Directory.md`** — HTTP endpoints
- **`Web Hooks Directory.md`** — external webhook delivery
- **`Events Directory.md`** — event-bus events
- **`User Exits Directory.md`** — hooks / user-exits

These are a unit's **exposed capability surface** — the interfaces other applications, agents, and external harnesses consume. Each is the canonical SSOT for its kind. Read the [Documentation System Guide](Documentation%20System%20Guide.md) first.

**Boundary:** Directories document the *external/consumable* contract. The Technical Design's contract-surface section documents the *internal in-process* contract (service interfaces / contracts). Events and user-exits are canonical **here**; the Technical Design references them.

Frontmatter: `doc_type: directory`, the `unit`, `interface_kind` (`mcp` | `api` | `webhook` | `event` | `user-exit`), and the base path/namespace.

## 1. Shared file anatomy (all five)

1. **Overview** — what this surface exposes; namespace/base; auth model summary.
2. **Conventions** — IDs, versioning, error model, idempotency for this surface.
3. **Entries** — the catalog (the core; **split unit = resource/tool group**).
4. **Deprecations** — retired/sunset entries.
5. **Open questions** · **Revision history**.

## 2. Entry schemas (per kind)

Every entry, regardless of kind, carries: a stable **ID**, a one-line **summary**, the **action** it requires (→ Resources & Grants Dictionary), the **owning/emitting component** (→ Technical Design), **status** + **`since`**, and **at least one example**. Per-kind specifics:

### 2.1 MCP tool (`interface_kind: mcp`)

```
### catalog.create_item — Create a catalog item

- **Capability:** catalog:FR-001
- **Requires action:** catalog.item.create
- **Input:**  name (string, required), area_id (uuid, required), fields (array, required)
- **Output:** item_id (uuid), created (bool)
- **Side effects:** writes a catalog_item row; not idempotent (use idempotency_key).
- **Owning component:** CMP-001 (catalog.store)
- **API equivalent:** catalog.api.create_item
- **Status:** active · since r1
- **Example:** { "name": "Widget", "area_id": "...", "fields": [...] } -> { "item_id": "...", "created": true }
```

### 2.2 API endpoint (`interface_kind: api`)

```
### catalog.api.create_item — POST /api/v1/catalog/items

- **Capability:** catalog:FR-001
- **Requires action:** catalog.item.create
- **Request body:** { name, area_id, fields[] }
- **Response:** 201 { item_id, created } · errors: 400, 403, 409
- **Auth:** session or bearer; idempotent via Idempotency-Key.
- **Owning component:** CMP-001 (catalog.store)
- **MCP equivalent:** catalog.create_item
- **Status:** active · since r1
- **Example:** curl -X POST .../catalog/items -d '{...}'
```

### 2.3 Web hook (`interface_kind: webhook`)

External delivery of a deliverable event. References the Events Directory for the payload.

```
### catalog.webhook.item_created — Item created (outbound)

- **Event:** catalog.item.created (→ Events Directory)
- **Delivery:** POST to subscriber URL; HMAC-signed; retried with backoff.
- **Requires action:** catalog.area.items @ viewer (to subscribe)
- **Envelope:** { id, type, occurred_at, data: `<event payload>` }
- **Status:** active · since r1
- **Example:** see Events Directory payload for catalog.item.created
```

### 2.4 Event (`interface_kind: event`)

```
### catalog.item.created — Item created

- **Trigger:** an item is inserted into the catalog.
- **Payload:** { item_id, area_id, owner_user_id, occurred_at }
- **Emitting component:** CMP-001 (catalog.store)
- **Subscribers (internal):** search.indexer, embeddings.queue
- **Externally deliverable:** yes (→ Web Hooks Directory)
- **Requires action (to subscribe externally):** catalog.area.items @ viewer
- **Status:** active · since r1
- **Example payload:** { "item_id": "...", "area_id": "...", ... }
```

### 2.5 User exit / hook (`interface_kind: user-exit`)

```
### catalog.before_item_write — Before item write

- **Fires:** before a catalog item is written or updated.
- **Timing:** around        (pre | post | around)
- **Signature:** (change: ItemChange) -> Decision { allow | veto(reason) | modify(change) }
- **Can modify:** yes · **Can veto:** yes
- **Host component:** CMP-001 (catalog.store)
- **Registered implementers:** safety.item-guard
- **Status:** active · since r1
- **Example:** safety.item-guard vetoes a write that violates a required-field rule.
```

## 3. Shared conventions

- **Stable IDs**, namespaced per unit; never reused; **deprecate-don't-delete**.
- **Versioning** via `status` (active | deprecated | removed) + `since`. Breaking changes follow the platform interface-versioning policy (Open Question in the Platform unit docs).
- Every entry **names the action it requires** (an ID from the Resources & Grants Dictionary).
- **At least one example per entry is mandatory** — this is what lets an LLM harness self-serve, and the runtime Docs plugin renders it.
- Schemas as tables and/or JSON-Schema fenced blocks.

## 4. Authoring & maintenance

- Canonical here; one entry per tool/endpoint/event/hook; keep in sync with the implementing component.
- Interface changes update here first; deprecate in place; bump `version` + `last_updated`; add a Revision-history row → task.
- The runtime Docs plugin's **generated LLM tool reference + live global directory** read directly from these files — their rigor is what makes the platform self-describing.
- **Promote-to-folder** split unit = resource/tool group (`<Directory>/README.md` + `<group>.md`).

## 5. Cross-linking

Each entry ↔ its **FR** (capability), **component** (Technical Design), **tables** (Data Dictionary), **action** (Resources & Grants Dictionary), and **sibling-surface equivalent** (MCP↔API; webhook↔event).

## 6. Markdown discipline

Per the [Documentation System Guide](Documentation%20System%20Guide.md#13-markdown--diagram-discipline).

## Revision History

| Rev | Date | Summary | Task |
|---|---|---|---|
| r1 | {{DATE}} | Initial convention. | — |
