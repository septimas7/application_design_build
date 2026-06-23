---
doc_type: documentation-system-guide
unit: system
title: Documentation System Guide
status: active
version: r1
owner: {{OWNER}}
created: {{DATE}}
last_updated: {{TIMESTAMP}}
related:
  - "README.md"
tags:
  - {{project-slug}}
  - convention
  - documentation-system
---

# Documentation System Guide

This is the master guide for the {{PROJECT_NAME}} design documentation. It defines **how the whole document set is organized, created, and maintained** so that any contributor — human or LLM — can navigate it, add to it, and keep it consistent over time. Every other convention guide in `Conventions/` specializes the rules laid out here.

Read this first. Then read the specific convention for whatever document you are about to create or edit.

---

## 1. Purpose

{{PROJECT_NAME}} is built incrementally and contributed to by both people and LLM agents. That only works if the documentation is **predictable** (same shape everywhere), **modular** (each piece is small and self-contained), and **self-describing** (the docs themselves explain how to extend the system). This guide is the contract that makes those three properties hold.

It covers: the documentation model (Dictionaries vs Directories, units, folder layout), the document set, the shared frontmatter schema, versioning, ID conventions, cross-linking, the single-source-of-truth rule, the promote-to-folder rule, the relationship to `tasks.md`, how to add a new Application, and the markdown/diagram discipline.

## 2. What {{PROJECT_NAME}} is (so the docs make sense)

> **Fill this in for your project.** One or two paragraphs describing what {{PROJECT_NAME}} is and the product principles that shape the docs — enough that a reader understands why the documentation is structured this way. The full vision lives in `Platform/Functional Design.md`; this section borrows just enough of it to orient a newcomer.

One principle this documentation model assumes regardless of product:

- **Capability is exposed for others to consume.** Every unit publishes an interface surface (MCP tools, API, web hooks, events, user exits) that other applications and external agents consume. The **Directories** document that surface, and they are the source a runtime documentation generator reads to produce the live, machine-readable reference.

## 3. The documentation model

### 3.1 Two kinds of catalog: Dictionaries vs Directories

The structured reference docs split into two families:

- **Dictionaries — definitional catalogs** (*what exists*): the **Data Dictionary** (table schemas), the **Resources & Grants Dictionary** (RBAC **functional areas**, **access levels**, **actions**, and **roles**), the **Config Dictionary** (configurable settings — global + per-user), and the **Log Dictionary** (per-component log sources).
- **Directories — interaction surfaces** (*how to interact*): the **MCP Tools**, **API**, **Web Hooks**, **Events**, and **User Exits** directories — the interfaces other apps, agents, and external automation consume.

Dictionaries are governed by the **Dictionary Convention**; Directories by the **Interface Directory Convention**.

### 3.2 Units: Platform and Applications

The system is documented as a set of **units**. Each unit is either:

- **Platform** — the cross-cutting foundation (identity/RBAC, event bus, job runtime, the shared UI shell + design system). Treated as "plugin zero."
- An **Application** — one feature plugin (e.g. catalog, search, …), one folder each. Each Application declares a **`type`** — `native` (built on the foundation), `connector` (bridges an external product via its API), or `hybrid` (native + syncs an external product). The type doesn't change the unit shape (see the Functional Design Convention).

Every unit owns the **same document shape**, so the structure is recursive and predictable:

- a **Functional** doc (`Functional Design.md` for Platform, `Functional Spec.md` for an Application),
- a **Technical Design**,
- a **`Directories/`** set (the nine canonical interface + definition catalogs),
- a **`UI/`** folder with one subfolder per page,
- its own **`tasks.md`** (Applications only; Platform uses the root `tasks.md`).

### 3.3 Folder structure

```
{{PROJECT_NAME}}/
├── README.md                         ← navigation index
├── tasks.md                          ← program + platform build log
├── Conventions/                      ← these guides
│   ├── Documentation System Guide.md
│   ├── Functional Design Convention.md
│   ├── Technical Design Convention.md
│   ├── Dictionary Convention.md
│   ├── Interface Directory Convention.md
│   ├── UI Design Convention.md
│   └── Task Log Convention.md
├── Platform/
│   ├── Functional Design.md
│   ├── Technical Design.md
│   ├── Directories/
│   │   ├── Data Dictionary.md
│   │   ├── Resources & Grants Dictionary.md
│   │   ├── Config Dictionary.md
│   │   ├── Log Dictionary.md
│   │   ├── MCP Tools Directory.md
│   │   ├── API Directory.md
│   │   ├── Web Hooks Directory.md
│   │   ├── Events Directory.md
│   │   └── User Exits Directory.md
│   └── UI/
│       └── <page>/
│           ├── UI Design Requirements.md
│           └── Mockups/
└── Applications/
    └── <app>/                        ← same shape as Platform, plus its own tasks.md
        ├── Functional Spec.md
        ├── Technical Design.md
        ├── tasks.md
        ├── Directories/              ← same nine files as Platform
        └── UI/<page>/{UI Design Requirements.md, Mockups/}
```

There is **no hand-maintained global aggregator**. Each unit's `Directories/` is canonical and self-standing; the live cross-unit view is generated by a runtime documentation generator (see §9).

## 4. The document set

| Document | File(s) | Governing convention | Canonical SSOT for |
|---|---|---|---|
| Functional | `Functional Design.md` / `Functional Spec.md` | Functional Design Convention | the *what* — FRs, capabilities, behavior |
| Technical Design | `Technical Design.md` | Technical Design Convention | the *how* — NFRs, components (CMP), contract surface |
| Data Dictionary | `Directories/Data Dictionary.md` | Dictionary Convention | table schemas |
| Resources & Grants Dictionary | `Directories/Resources & Grants Dictionary.md` | Dictionary Convention | permissions, resources, roles |
| Config Dictionary | `Directories/Config Dictionary.md` | Dictionary Convention | configurable settings (global + per-user) |
| Log Dictionary | `Directories/Log Dictionary.md` | Dictionary Convention | per-component log sources |
| MCP Tools Directory | `Directories/MCP Tools Directory.md` | Interface Directory Convention | agent-facing tools |
| API Directory | `Directories/API Directory.md` | Interface Directory Convention | HTTP endpoints |
| Web Hooks Directory | `Directories/Web Hooks Directory.md` | Interface Directory Convention | external webhook delivery |
| Events Directory | `Directories/Events Directory.md` | Interface Directory Convention | event-bus events |
| User Exits Directory | `Directories/User Exits Directory.md` | Interface Directory Convention | hooks / user-exits |
| UI Design Requirements | `UI/<page>/UI Design Requirements.md` | UI Design Convention | a page's layout, components, states |
| Task Log | `tasks.md` (root + per-app) | Task Log Convention | the build log |

## 5. Shared frontmatter schema

Every document starts with a YAML frontmatter block. The shared fields below apply to all docs; individual conventions add a few type-specific fields (e.g., `interface_kind`, `route`).

| Field | Values | Notes |
|---|---|---|
| `doc_type` | `documentation-system-guide` · `convention` · `functional-design` · `technical-design` · `dictionary` · `directory` · `ui-design` · `task-log` | What kind of doc this is. |
| `unit` | `system` · `platform` · `application:<id>` | Which unit it belongs to. `system` = repo-wide (README, Conventions). |
| `type` | `native` · `connector` · `hybrid` | Application units only — native (foundation), connector (external product), or hybrid. |
| `title` | free text | Human title. |
| `status` | `draft` · `active` · `superseded` · `deprecated` | Lifecycle of the document. |
| `version` | `rN` | Current revision number (see §6). |
| `owner` | name | Accountable owner. |
| `created` | ISO-8601 date | Set once. |
| `last_updated` | ISO-8601 with offset | Bump on every write. |
| `related` | list of relative paths | Key cross-links. |
| `tags` | list | `{{project-slug}}` plus area tags. |

## 6. Versioning & change tracking

Three mechanisms, deliberately lightweight:

1. **`version` + `last_updated` frontmatter** — the current revision and when it last changed.
2. **A `## Revision History` section** at the bottom of every doc — a compact table, newest at the bottom:

   `| rN | YYYY-MM-DD | one-line summary of what changed | task-##### |`

3. **`tasks.md` holds the *why*.** The revision-history line records *what* changed in one line and points to the task that drove it; the rationale, alternatives, and detail live in the relevant `tasks.md`. Do not duplicate that narrative into the doc.

Rules: never rewrite history; append a new `rN` row. Bump `version` and `last_updated` together. When a doc is retired, set `status: superseded` (or `deprecated`) and link its replacement — never delete.

## 7. ID conventions

Stable IDs let any doc reference any thing precisely. IDs are **unit-scoped** (the unit gives the namespace) and **never reused**.

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

## 8. Cross-linking

- **Between documents:** use **relative markdown links**, e.g. `[Technical Design](../Technical%20Design.md)`. Encode spaces as `%20` so links render on GitHub as well as in Obsidian. Relative links are preferred over `[[wikilinks]]` because filenames repeat across units (every unit has a `Technical Design.md`), which makes bare wikilinks ambiguous.
- **To a specific entry** (an FR, an NFR, a component, a tool, a table): reference it by its **stable ID** (§7), and link to the containing document. A runtime documentation generator resolves IDs to live anchors; in the source docs the ID + a link to the file is enough.
- **The reference graph to maintain:** an FR/NFR links to the component (`CMP-###`) that satisfies it and the interface entries that expose it; a component links to its FRs/NFRs, the tables it owns, and the interface entries it serves; every interface/UI entry names the **action** it requires (an ID from the Resources & Grants Dictionary — which implies that action's functional area and minimum access level); a task's yaml `references` map cites all of the above by ID. Keeping this graph intact is what makes the docs traceable from capability → implementation → exposure.

## 9. Single source of truth & aggregation

- Each fact has **exactly one canonical home**, in the owning unit: a table is defined in that unit's Data Dictionary, a tool in its MCP Tools Directory, a permission in its Resources & Grants Dictionary, and so on.
- Other docs **reference, never duplicate.** The Technical Design explains *how* components use a table; it points at the Data Dictionary for the schema. A UI component points at the API/MCP entry it calls.
- There is **no hand-maintained global roll-up.** When you need a system-wide view ("every MCP tool", "all grants"), that is **generated by a runtime documentation generator** from the canonical per-unit files. Design-time navigation across units is via the README and this guide.

## 10. Promote-to-folder rule

A document is **single-file by default**. When it grows, promote it to a **folder of the same name whose `README.md` is the overview/index**, with the parts in subfolders. The index always carries the summary plus a table of contents linking to the parts, so a reader (or an LLM) loads the small index to navigate, then opens only the one part it needs.

- **When to promote (threshold-based):** roughly >300–400 lines, or more than ~5–6 independently-maintainable parts.
- **Split unit per doc type:** Technical Design → per **component** (`Components/<component>.md`); Data Dictionary → per **table-group**; an interface Directory → per **resource/tool group**; Functional → per **capability-group** (rare). UI is already split per **page**.
- **Form:** `Name.md` (single) ↔ `Name/README.md` + parts (promoted). A "document" is always either `Foo.md` or `Foo/README.md`.

Do not promote pre-emptively (YAGNI). Promote when a file actually gets unwieldy.

## 11. Relationship to `tasks.md`

- The **root `tasks.md`** is the program + Platform build log. Each **Application has its own `tasks.md`**.
- Task logs follow the **Task Log Convention**.
- The design docs describe the *intended* system; the task logs record the *work* to build it and the *why* behind changes. Revision-history rows in any doc point to the task that drove the change.

## 12. Adding a new Application

1. Create `Applications/<app>/` and copy the **unit shape**: `Functional Spec.md`, `Technical Design.md`, `tasks.md`, `Directories/` (the nine files), and a `UI/` folder.
2. Fill `Functional Spec.md` first (the *what*), then `Technical Design.md` (the *how*), then design the **UI pages** (each page surfaces the data, actions, and interfaces the unit needs), then **populate the `Directories/`** to formalize those surfaced entities as canonical entries. UI precedes the Directories because walking the screens is the most reliable way to discover the real entity surface.
3. Register the app's frontmatter `unit: application:<app>` across its docs.
4. Each new table/component/tool/endpoint/event/hook/permission gets a stable ID (§7) and a canonical entry in the relevant file.
5. Open tasks in the app's `tasks.md`; record cross-cutting/program work in the root `tasks.md`.

A runtime documentation generator picks the new unit up automatically from its canonical files — no central index to edit.

## 13. Markdown & diagram discipline

These docs render in both Obsidian and GitHub. A few constructs silently break Obsidian rendering — sometimes for the rest of the file:

- **Never indent a fenced code block inside a list item.** It flips code-fence parity for everything after it. Use inline code on the bullet, or a left-margin (column-0) fence outside the list.
- **Never leave bare `<...>` angle brackets in prose** — Obsidian deletes them as empty HTML tags. Wrap placeholders in backticks: `` `<unit>` ``.
- **Keep code fences balanced** (an even number of triple-backtick lines), put a blank line before lists/headings/fences, and prefer triple-backtick fences over tilde fences.
- **Diagrams are Mermaid**, in column-0 fenced blocks (a triple-backtick line followed by `mermaid`). Use **C4** levels (Context → Container → Component) in Technical Design and **ER** diagrams in Data Dictionaries. Both render on GitHub and in Obsidian, and feed the same C4 model a runtime generator produces.

Quick pre-save check: triple-backtick fence count is even; zero indented fences; zero bare `<tag>`s outside code.

## 14. Conventions index

- [Functional Design Convention](Functional%20Design%20Convention.md)
- [Technical Design Convention](Technical%20Design%20Convention.md)
- [Dictionary Convention](Dictionary%20Convention.md)
- [Interface Directory Convention](Interface%20Directory%20Convention.md)
- [UI Design Convention](UI%20Design%20Convention.md)
- [Task Log Convention](Task%20Log%20Convention.md)

## 15. Revision History

| Rev | Date | Summary | Task |
|---|---|---|---|
| r1 | {{DATE}} | Initial convention. | — |
