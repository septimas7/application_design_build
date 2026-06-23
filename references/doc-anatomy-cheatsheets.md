# Reference: Doc-anatomy cheatsheets (entry schemas)

The copy-paste entry schemas the authoring skills emit. SSOT lives in each Convention; reproduced here so a skill is self-sufficient. Fences shown at column 0 (never indented inside a list). Examples use the neutral `catalog` app.

---

## FR entry (Functional Design Convention §4)

```
### FR-001 — Create a catalog item

- **Priority:** P0
- **Status:** planned        (planned | in-progress | done | superseded | cancelled)
- **Depends on:** —
- **Description:** one capability, behaviorally described (no schemas, no implementation detail).
- **Acceptance:**
  - [ ] testable statement
  - [ ] testable statement
- **Exposed via:** `catalog.create_item` (MCP), `catalog.api.create_item` (API)
- **Implemented by:** CMP-001 (catalog.store)
- **UI:** `catalog/ui/catalog-view`
- **Requires action:** `catalog.item.create`
```

One capability per FR; testable acceptance on every FR; omit a cross-link line only if truly N/A.

---

## NFR entry (Technical Design Convention §4)

```
### NFR-001 — Catalog list latency

- **Category:** performance        (performance | security | scalability | reliability | observability | portability)
- **Priority:** P1
- **Requirement:** The catalog list view returns within 200 ms p95 at 10,000 items.
- **Measurement:** load test asserting p95 latency; tracked as a perf budget.
- **Satisfied by:** CMP-001 (catalog.store)
```

Each NFR is measurable (a number or a checkable condition), not a vague aspiration.

---

## Component entry (Technical Design Convention §5)

```
### CMP-001 — catalog.store — Catalog store

- **Responsibility:** single clear responsibility.
- **Public interface:** `CatalogStore` service contract (method list).
- **Depends on:** CMP (platform.db), CMP (platform.migration-runner).
- **Owns data:** `catalog_item`, `catalog_item_def` (→ Data Dictionary).
- **Satisfies:** catalog:FR-001, catalog:NFR-001.
- **Emits / hooks:** emits `catalog.item.created`; honors `catalog.before_item_write`.
- **Notes:** decisions that constrain the future carry a one-line rationale.
```

The `CMP-###` number is the canonical short ID other docs/tasks link to; the handle `<unit>.<component>` is the human name (and the log-source id).

---

## Interface entries (Interface Directory Convention §2)

Every entry carries: stable **ID**, one-line **summary**, **Requires action**, **owning/emitting component**, **status** + **since**, and **≥1 example** (mandatory).

```
### catalog.create_item — Create a catalog item       (MCP)

- **Capability:** catalog:FR-001
- **Requires action:** catalog.item.create
- **Input:** name (string, required), group_id (uuid, required), fields (object, optional)
- **Output:** item_id (uuid), created (bool)
- **Side effects:** inserts a row; not idempotent (use idempotency_key).
- **Owning component:** CMP-001 (catalog.store)
- **API equivalent:** catalog.api.create_item
- **Status:** active · since r1
- **Example:** { "name": "Widget", ... } -> { "item_id": "...", "created": true }
```

(API / Web Hook / Event / User-Exit kinds follow the parallel schemas in the Interface Directory Convention §2.2–2.5.)

---

## UI component entry (UI Design Convention §4)

```
### Item grid

- **Purpose:** what it shows.
- **Data source:** catalog.api.list_items (→ API Directory) over catalog_item (→ Data Dictionary)
- **Actions:** catalog.api.create_item ("New item"), catalog.item.edit (inline edit)
- **Requires action:** catalog.item.create (gates visibility; hidden below editor)
- **States:** empty · loading · error · populated · permission-denied
- **Notes:** anything notable (virtualization, etc.).
```

---

## Task entry (Task Log Convention §3)

````
### task-00001: Stand up the catalog store

```yaml
status: planned          # planned | in_progress | blocked | completed | cancelled
priority: P0             # P0 | P1 | P2 | P3
created: <ISO-8601 offset>
closed:                  # set when done
estimated: 1w
agent: unassigned        # human | <agent id> | unassigned
machine:                 # hostname, set when work starts
depends_on: []
blocks: []
references:             # design entities this task touches, by stable ID (omit keys that don't apply)
  implements: [FR-001, NFR-001]
  components: [CMP-001]
  interfaces: [catalog.create_item, catalog.api.create_item]
  ui: [catalog/ui/catalog-view]
  data: [catalog_item]
  actions: [catalog.item.create]
artifacts: []
tags: ["#area/catalog", "#fr/001"]
```

#### Objective
What to build. REQUIRED.

#### Context
Background a fresh contributor needs; pointers to the spec (FRs, components). Optional.

#### Subtasks
- [ ] concrete, parallelizable checkboxes (each a vertical slice where possible)

#### Acceptance
- [ ] testable, checkable definition-of-done criteria — REQUIRED for build tasks
- [ ] each criterion is observable (a test passes, a doc shows X, an endpoint returns Y)

#### Notes
Decisions, risks, pointers. Optional **Decision Record** (ADR-grade) lines for any decision
that constrains the future — typically the output of a `doubt-driven-review` gate:
- **Decision:** the choice, as one claim.
- **Alternatives considered:** the options weighed + why each was rejected.
- **Consequence:** the trade-off / limitation now accepted.

#### Result
Filled at close — what shipped and where it lives. REQUIRED at close.
````
