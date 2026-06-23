# Reference: Stable IDs & the cross-link graph

The single thing that makes the docs traceable from **capability → implementation → exposure**. SSOT: **Documentation System Guide §7–§8**. Every authoring skill must mint IDs from this table and keep the graph intact.

## ID forms (unit-scoped, never reused)

| Thing | ID form | Example |
|---|---|---|
| Functional requirement | `FR-###` | `FR-001` |
| Non-functional requirement | `NFR-###` | `NFR-001` |
| Component (Technical Design) | `CMP-###` (+ handle `<unit>.<component>`) | `CMP-012` (`catalog.store`) |
| Table | snake_case, unit-prefixed | `catalog_item` |
| Config key | `<unit>.config.<key>` | `catalog.config.max_items` |
| Log source | `<unit>.<component>` (the component handle) | `catalog.store` |
| Functional area (category) | `<unit>.area.<name>` | `catalog.area.items` |
| Action (button/API permission) | `<unit>.<resource>.<action>` | `catalog.item.create` |
| Access level (global ladder) | `none` / `viewer` / `editor` / `admin` | `editor` |
| Role | `role.<name>` | `role.admin` |
| MCP tool | `<unit>.<tool>` | `catalog.create_item` |
| API endpoint | `<unit>.api.<name>` (+ `METHOD /path`) | `catalog.api.get_item` |
| Web hook / event | `<unit>.<event>` | `catalog.item.created` |
| User exit / hook | `<unit>.<hook>` | `catalog.before_item_write` |
| UI page | `<unit>/ui/<page>` (+ route) | `catalog/ui/catalog-view` |
| Task | `task-#####` (per task log) | `task-00007` |

**Cross-unit reference syntax:** prefix with the unit — `catalog:FR-001`, `catalog:CMP-012`, `platform:role.admin`. Within a unit's own docs the prefix may be omitted.

## The reference graph to maintain

- an **FR / NFR** links to → the **component** (`CMP-###`) that implements/satisfies it, the **interface entries** that expose it, the **UI page** that surfaces it, the **action** it requires, and the **task** that builds it.
- a **component** (`CMP-###`) links to → its **FRs/NFRs**, the **tables** it owns, the **interface entries** it serves.
- every **interface/UI entry** names the **action** it requires (an ID from the Resources & Grants Dictionary — which implies that action's functional area + minimum access level).
- a **task** lists what it touches in its yaml **`references`** map (FRs/NFRs, components, interfaces, UI, data, actions); a doc's **revision-history row** points back to the driving **`task-#####`**.

## Cross-linking mechanics

- **Between documents:** relative markdown links with spaces as `%20`, e.g. `[Technical Design](../Technical%20Design.md)`. Preferred over `[[wikilinks]]` (filenames repeat across units).
- **To a specific entry:** reference by **stable ID** + link to the containing document.

A Define→Plan pass is only complete when this graph has no dangling references.
