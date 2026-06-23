---
doc_type: convention
unit: system
title: Dictionary Convention
status: active
version: r1
owner: {{OWNER}}
created: {{DATE}}
last_updated: {{TIMESTAMP}}
related:
  - "Documentation System Guide.md"
tags:
  - {{project-slug}}
  - convention
  - dictionary
  - rbac
---

# Dictionary Convention

Governs the four **Dictionaries** (definitional catalogs — *what exists*) in every unit's `Directories/` folder:

- **`Data Dictionary.md`** — the unit's table schemas.
- **`Resources & Grants Dictionary.md`** — the unit's RBAC **functional areas**, **actions**, and **roles** (and, in the Platform unit, the global **access-level ladder**).
- **`Config Dictionary.md`** — the unit's configurable settings (global + per-user).
- **`Log Dictionary.md`** — the unit's **log sources** (per-component loggers, default levels).

Each is the canonical SSOT for its unit. Other docs reference them, never duplicate. Read the [Documentation System Guide](Documentation%20System%20Guide.md) first.

Frontmatter: `doc_type: dictionary`, the `unit`, and (Data Dictionary) the DB schema/namespace name.

---

# Part A — Data Dictionary

## A.1 File anatomy

1. **Overview** — the unit's data model in brief; namespace; storage approach (hand-DDL vs **engine-generated hybrid** = real columns + a `fields jsonb` overflow); an **ER overview** (Mermaid).
2. **Table-groups** — related tables grouped; this is the **split unit** when promoted.
3. **Tables** — one entry per table (see A.2).
4. **Enumerations / custom types**.
5. **Relationships** — the FK graph / ER diagram.
6. **Open questions** · **Revision history**.

## A.2 Table entry schema

```
### catalog_item — Catalog item definitions

- **Purpose:** One row per catalog item.
- **Lifecycle:** hand-ddl        (hand-ddl | engine-generated)
- **Owned by:** CMP-001 (catalog.store)
```

| column | type | nullable | default | key | description |
|---|---|---|---|---|---|
| id | uuid | no | gen_random_uuid() | PK | — |
| group_id | uuid | no | — | FK → catalog_item_group(id) | owning group |
| name | text | no | — | UQ | item name |
| created_at | timestamptz | no | now() | — | — |

- **jsonb keys** (when a `fields jsonb` column exists): a separate sub-table — `key` · `type` · `description` — documenting the conventional keys, since jsonb is loose but should still be described.
- **Indexes:** list each (name, columns, type).
- **Constraints:** checks / uniques.
- **Relationships:** inbound/outbound FKs.
- **Serves:** FR-001 (→ Functional) · exposed via `catalog.api.create_item` (→ Directories).

## A.3 Naming conventions

- Tables: snake_case, **unit-prefixed** (`catalog_*`). Engine-generated tables follow the engine's naming scheme (documented in the unit's Technical Design).
- Columns: snake_case. Standard columns where applicable: `id`, `created_at`, `updated_at`, `owner_user_id`.
- The hybrid model: structured/queried/related fields are **real columns**; idiosyncratic per-row fields live in **`fields jsonb`**.

## A.4 ER diagrams

Author as **Mermaid `erDiagram`** blocks (column 0). Keep them in sync with the table entries.

## A.5 Promote-to-folder

Split unit = **table-group**: `Data Dictionary/README.md` (overview, ER, group catalog) + `Data Dictionary/<table-group>.md`.

---

# Part B — Resources & Grants Dictionary

## B.1 The RBAC model

Grants are composed from three dimensions, so admins assign *functionality per area at an access level* instead of enumerating every resource:

- **Functional Area (category)** — a named bundle of related functionality + a data domain (e.g. `catalog.area.items`). The ergonomic grant target.
- **Access Level** — a global ladder applied to a grant (§B.2). Selects the data-access tier and which of the area's actions are unlocked.
- **Action** — an atomic button/API interaction (e.g. `catalog.item.create`), tagged to a functional area with a **minimum access level**.

A **grant** = `(subject: user or role) × (functional area) × (access level) [× data scope]`, expanding to *every action in the area whose min level ≤ the granted level, plus that level of data access over the area's data domain*. **Roles** bundle several `(area × level)` grants across units.

## B.2 Access-level ladder (Platform-defined, global)

Defined once in **`Platform/Directories/Resources & Grants Dictionary.md`** and referenced by every unit:

| Level | Rank | Data access | Action access |
|---|---|---|---|
| `none` | 0 | none | none |
| `viewer` | 1 | read | read-only actions |
| `editor` | 2 | read / write | create + update actions |
| `admin` | 3 | read / write / manage | all actions, incl. configure + manage grants within the area |

Data **scope** (which data, orthogonal to level): `owner` · `shared` · `all`, or a record-set / path-glob.

## B.3 File anatomy

1. **Overview** — the unit's RBAC surface in brief.
2. **Access-level ladder** — *Platform only* (the table above); other units link to it.
3. **Functional areas** — one entry per area (see B.4).
4. **Actions** — one entry per action.
5. **Roles** — *Platform only* for cross-unit roles; a unit may define unit-local roles.
6. **Open questions** · **Revision history**.

## B.4 Entry schemas

```
### catalog.area.items — Items

- **Description:** Creating, editing, and managing catalog items and their data.
- **Data domain:** catalog_item, catalog_item_group (→ Data Dictionary)
- **Actions:** catalog.item.create, catalog.item.update, catalog.item.delete
- **Supported levels:** viewer, editor, admin
```

```
### catalog.item.create — Create item

- **Functional area:** catalog.area.items
- **Min access level:** editor
- **Description:** Create a new catalog item in an item group.
- **Gates:** catalog.create_item (MCP) · catalog.api.create_item (API) · catalog/ui/catalog-view "New item"
- **Owning component:** CMP-001 (catalog.store)
```

```
### role.admin — Administrator        (Platform)

- **Grants:** all areas @ admin
- **Description:** Full platform administration.
```

## B.5 Naming conventions

- Functional area: `<unit>.area.<name>`. Action: `<unit>.<resource>.<action>`. Role: `role.<name>`.
- Access levels are the four global tokens only (`none`/`viewer`/`editor`/`admin`) — never invent unit-local levels.

---

# Part C — Config Dictionary

## C.1 The config model

Configurability is first-class: behavior changes via **settings**, not code edits. The Platform unit provides a config store + a searchable Settings surface; each unit **registers its config keys** and reads them through the config service. The Config Dictionary is the canonical catalog of a unit's settings.

Each setting has a shipped **default** and resolves across two override scopes:

- **global** — the operator/admin sets it instance-wide (applies to all users).
- **user** — a user overrides it for themselves, where the setting allows.

**Resolution: user → global → default** (most specific wins). A setting declares whether it is `global`, `global, user-overridable`, or `user`. (If {{PROJECT_NAME}} ever runs as multiple instances, an `instance` tier slots between global and user — deferred for now.)

## C.2 File anatomy

1. **Overview** — the unit's configurable surface in brief.
2. **Settings** — one entry per config key (see C.3), optionally grouped.
3. **Open questions** · **Revision history**.

## C.3 Config entry schema

```
### catalog.config.max_items — Max items per group

- **Scope:** global, user-overridable
- **Type:** integer · **Default:** 64 · **Range:** 1-512
- **Controls:** hard cap on items when creating/altering a catalog item group.
- **Requires action:** global -> platform.config.edit (admin); user override -> catalog.area.items @ editor
- **UI:** catalog/ui/settings
- **Owning component:** CMP-001 (catalog.store) · **Status:** active · since r1
```

- **Scope:** `global` | `global, user-overridable` | `user`.
- **Type:** string | integer | boolean | enum | json (give allowed values / range).
- **Requires action:** the action gating a change at each scope (-> Resources & Grants Dictionary).
- **Searchable + additive:** every key is catalogued here (discoverable in docs + the generated reference) and surfaced in the runtime Settings search; a plugin adds a setting by adding an entry + registering the key — no hardcoded options.

## C.4 Naming conventions

- Config key: `<unit>.config.<key>` (snake_case key). Never reuse/rename — supersede.

## C.5 Promote-to-folder

Split unit = a settings group: `Config Dictionary/README.md` + `Config Dictionary/<group>.md`.

---

# Part D — Log Dictionary

## D.1 The logging model

Logging is **registration-driven** (see the Platform unit's app-log component): each component/plugin registers a **log source**, and the Platform unit aggregates them into one viewable, queryable, per-source-level-configurable surface. The Log Dictionary is the canonical catalog of a unit's log sources.

## D.2 File anatomy

1. **Overview** — the unit's logging surface in brief.
2. **Log sources** — one entry per source.
3. **Open questions** · **Revision history**.

## D.3 Log-source entry schema

```
### catalog.store — Catalog store logs

- **Source id:** catalog.store (CMP-001)       (typically the Technical Design component id)
- **Default level:** info        (trace | debug | info | warn | error)
- **Level config:** catalog.config.log_level.store  (-> Config Dictionary; live-adjustable)
- **Emits fields:** item_id, operation, duration_ms
- **Notable entries:** item created/updated/deleted; persistence errors
- **Retention:** default
```

- **Source id:** `<unit>.<component>` — usually the owning component's id.
- **Default level:** the shipped level; changeable live via the source's config key.
- **Emits fields:** the structured fields entries from this source commonly carry (so an LLM querying logs knows what to filter on).

## D.4 Naming conventions

- Log source: `<unit>.<component>`. Its level is the config key `<unit>.config.log_level.<component>` (registration-driven, per the Config Dictionary).

## D.5 Promote-to-folder

Split unit = a source group: `Log Dictionary/README.md` + `Log Dictionary/<group>.md`.

---

## 3. Authoring & maintenance (all Dictionaries)

- Canonical here — define each table / area / action / role / config key / log source exactly once, in the owning unit (the access-level ladder + cross-unit roles live in the Platform unit).
- Keep in lockstep with migrations (Data) and the RBAC engine registration (Resources & Grants).
- Never renumber/rename an ID in place — supersede + add a new one. Bump `version` + `last_updated`; add a Revision-history row → task.

## 4. Cross-linking

Tables link to the component that owns them, the FRs they serve, and the interface entries that expose them. Actions link to the interface/UI entries they gate and their owning component. Every interface/UI entry, conversely, names the **action** it requires.

## 5. Markdown discipline

Per the [Documentation System Guide](Documentation%20System%20Guide.md#13-markdown--diagram-discipline). Note the table-entry example uses a real left-margin table (not an indented fence).

## Revision History

| Rev | Date | Summary | Task |
|---|---|---|---|
| r1 | {{DATE}} | Initial convention. | — |
