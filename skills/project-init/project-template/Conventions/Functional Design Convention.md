---
doc_type: convention
unit: system
title: Functional Design Convention
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
  - functional-design
---

# Functional Design Convention

Governs the Functional document of every unit: `Platform/Functional Design.md` and each `Applications/<app>/Functional Spec.md`. It describes **what** a unit does — its capabilities, behaviors, and functional requirements — and never **how** it does it (that is the Technical Design).

Read the [Documentation System Guide](Documentation%20System%20Guide.md) first for the shared conventions (frontmatter, IDs, versioning, cross-linking, markdown discipline).

## 1. Purpose & scope

The Functional document is the authoritative statement of a unit's intended behavior. Platform's `Functional Design.md` covers the Platform unit, the cross-cutting product, and the shared-capability vision; an Application's `Functional Spec.md` covers that one application's features.

Functional, not technical: describe observable behavior, capabilities, and rules. No schemas, no component diagrams, no service-contract definitions — those live in the Technical Design, Dictionaries, and Directories, and are linked from here.

This document covers **functional** requirements, which are numbered `FR-###`. *Non-functional* requirements are numbered `NFR-###` and live in the Technical Design.

## 2. Location & frontmatter

- **Path:** `Platform/Functional Design.md` · `Applications/<app>/Functional Spec.md`.
- **Frontmatter:** the shared schema, with `doc_type: functional-design`, the unit's `unit` value, a `depends_on` list of the other units/capabilities this one builds on (its place in the dependency layering), and — for an Application — a **`type`** (see §2.1).

### 2.1 Application types

An Application declares a `type` in its frontmatter:

- **`native`** — built entirely on {{PROJECT_NAME}}'s platform capabilities; {{PROJECT_NAME}} owns the data.
- **`connector`** — bridges an external self-hosted product by talking to its API and mapping its capabilities into {{PROJECT_NAME}}'s interface surface. The data stays in the external product; {{PROJECT_NAME}} holds the connection config + any sync/cache state.
- **`hybrid`** — native, but can also import/sync from an external product.

The `type` does not change the document shape — every Application has the same Functional / Technical / Directories / UI / tasks set. A **connector**'s Technical Design uses its *external integrations* section to document the external product, the API surface it maps, auth, and the sync/caching strategy; its **Config Dictionary** holds the connection (URL + **credentials via the Platform unit secret store, never plaintext**); and its *Capabilities — exposed & consumed* lists what it surfaces from (and requires of) the external product. Platform is always implicitly `native`.

## 3. File anatomy

In order:

1. **Overview** — what this unit is and why it exists, in a few sentences.
2. **Capabilities — exposed & consumed** — what capabilities this unit *offers* other applications/consumers, and what it *depends on*. The exposed list points into the unit's Directories (the concrete interface surface). This section is the heart of the shared-capability framing.
3. **Actors / personas** — who and what uses the unit: humans (portal/Obsidian), internal plugins, and **external agents / LLM harnesses** as first-class consumers.
4. **Functional Requirements** — the `FR-###` entries (see §4). The core of the document.
5. **Key flows** — notable user/agent journeys, as prose or numbered steps. Optional.
6. **Rules & states** — functional-level business rules and state machines (e.g., lifecycle of an entity), described behaviorally.
7. **Non-goals / out of scope** — what this unit deliberately does not do.
8. **Open questions** — unresolved functional decisions.
9. **Revision history** — the shared `rN` table.

## 4. Functional Requirement (FR) entry schema

Each FR is an H3 followed by a compact field list. IDs are unit-scoped and never renumbered or reused (cross-referenced from other units as `unit:FR-###`).

```
### FR-001 — Create a catalog item

- **Priority:** P0
- **Status:** planned        (planned | in-progress | done | superseded | cancelled)
- **Depends on:** —
- **Description:** A user (or plugin) can create a catalog item with the
  declared fields, which is persisted and addressable by a stable ID.
- **Acceptance:**
  - [ ] An item created via the API appears as a real row in catalog_item.
  - [ ] The created item is retrievable by its ID.
- **Exposed via:** `catalog.create_item` (MCP), `catalog.api.create_item` (API)
- **Implemented by:** CMP-001 (catalog.store)
- **UI:** `catalog/ui/catalog-view`
- **Requires action:** `catalog.item.create`
```

Field rules: every FR has a **testable acceptance** list; `Exposed via` / `Implemented by` / `UI` / `Requires action` are the cross-links that keep the traceability graph intact (omit a line if not applicable). The `Implemented by` line references the implementing component by its primary ID `CMP-###`, with a descriptive handle in parentheses (e.g. `CMP-001 (catalog.store)`). Keep each FR to **one capability** — split rather than bundle.

## 5. Authoring rules

- Functional, not technical. If you are naming a table, a service interface, or an endpoint shape, it belongs in another doc — link to it instead.
- One capability per FR; testable acceptance on every FR.
- YAGNI — do not specify behavior the unit does not need yet; record "maybe later" ideas under Open questions or Non-goals.
- Write for a reader who has not seen the code: define terms, state assumptions.

## 6. Maintenance

- Append new FRs at the end of the Functional Requirements section; never renumber.
- Supersede or cancel in place (`Status:` + a one-line note); never delete an FR.
- The *why* behind a change lives in `tasks.md`; the FR records the resulting behavior. Bump `version`, `last_updated`, and add a Revision-history row pointing to the driving task.

## 7. Cross-linking

Each FR links to: the **component** that implements it (Technical Design, by `CMP-###`), the **interface entry/entries** that expose it (Directories), the **UI page** that surfaces it, the **action** it requires (Resources & Grants Dictionary), and the **task** that builds it. Use stable IDs (and relative links where a file pointer helps).

## 8. Template

```
---
doc_type: functional-design
unit: application:<app>
type: native            # native | connector | hybrid
title: <App> — Functional Spec
status: draft
version: r1
owner: {{OWNER}}
created: <date>
last_updated: <timestamp>
related: ["../../Platform/Functional Design.md"]
tags: [{{project-slug}}, functional-design, <app>]
depends_on: [platform]
---

# <App> — Functional Spec

## 1. Overview
## 2. Capabilities — exposed & consumed
## 3. Actors / personas
## 4. Functional Requirements
### FR-001 — <title>
...
## 5. Key flows
## 6. Rules & states
## 7. Non-goals
## 8. Open questions
## 9. Revision History
| Rev | Date | Summary | Task |
|---|---|---|---|
| r1 | <date> | Initial spec. | task-001 |
```

## 9. Markdown discipline

Follow the markdown rules in the [Documentation System Guide](Documentation%20System%20Guide.md#13-markdown--diagram-discipline): no fenced blocks indented inside list items, wrap bare `<...>` in backticks, balanced fences, Mermaid at column 0.

## Revision History

| Rev | Date | Summary | Task |
|---|---|---|---|
| r1 | {{DATE}} | Initial convention. | — |
