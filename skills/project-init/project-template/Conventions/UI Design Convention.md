---
doc_type: convention
unit: system
title: UI Design Convention
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
  - ui-design
---

# UI Design Convention

Governs each `<unit>/UI/<page>/UI Design Requirements.md` and its `Mockups/` folder. The **split unit is the page** — every UI page gets its own folder. Read the [Documentation System Guide](Documentation%20System%20Guide.md) first.

## 1. Purpose & scope

Defines a single UI **page** (screen/view): its purpose, layout, components, states, interactions, data bindings, and mockups. **Platform/UI** holds the global shell + cross-cutting pages (onboarding, settings, nav) **and the shared design system**; an **Application's UI** holds that app's pages.

## 2. Location & frontmatter

- **Path:** `<unit>/UI/<page>/UI Design Requirements.md` + `<unit>/UI/<page>/Mockups/`.
- **Frontmatter:** shared schema with `doc_type: ui-design`, the `unit`, a `page` id/name, the **`route`** (nav path), and `related` FRs.

## 3. File anatomy

1. **Overview** — purpose, personas, route.
2. **Layout** — regions/zones + responsive behavior; points to mockups.
3. **Components** — each UI component on the page (see §4).
4. **States** — empty / loading / error / populated / **permission-denied** + key transitions.
5. **Interactions & flows** — what each action does (links to the interface entries it calls).
6. **Mockups** — references to `Mockups/` files, annotated (see §5).
7. **Content / copy** — labels, empty-state copy, error messages.
8. **Accessibility** — keyboard / contrast / screen-reader (scaled to the page).
9. **Open questions** · **Revision history**.

## 4. Component entry schema

```
### Item grid

- **Owning component:** CMP-001 (catalog.store)
- **Purpose:** Show the rows of the selected catalog table.
- **Data source:** catalog.api.list_items (→ API Directory) over catalog_item (→ Data Dictionary)
- **Actions:** catalog.api.create_item ("New item"), catalog.item.edit (inline edit)
- **Requires action:** catalog.item.create (to show "New item"); hidden below editor
- **States:** empty (no rows) · loading · error · populated
- **Notes:** virtualized for large tables.
```

Every component **binds to its data + actions** (so each UI element traces to an exposed interface) and names the **action** that gates its visibility (an ID from the Resources & Grants Dictionary — show/hide by access level). The **owning component** is named by its component number `CMP-###` with a descriptive handle, e.g. `CMP-001 (catalog.store)`.

## 5. Mockups convention

- **Formats:** static images (PNG/JPG), **SVG**, or **interactive HTML** mockups; plus inline **Mermaid** wireframes for low fidelity.
- **Naming:** `<page>-<breakpoint>-<state>.<ext>` — e.g. `catalog-view-desktop-populated.png`, `catalog-view-mobile-empty.png`.
- **Fidelity:** label each as wireframe → mockup → prototype.
- **Authority rule:** **text is authoritative for behavior; mockups are illustrative** (mockups *show*, requirements *specify*). When they conflict, the requirements win.
- Each mockup is **referenced + annotated** in the requirements (what state/breakpoint it depicts).

## 6. Design-system reference

**Platform/UI owns the shared design system** (tokens, base components, interaction patterns). App pages **reference** it instead of redefining colors/spacing/components — keeping the platform visually consistent. New shared patterns are added to Platform/UI, not duplicated per app.

## 7. Authoring rules

- Text authoritative; bind every component to its data + actions; gate by action/access level; one page per folder.
- Keep mockups illustrative and current; do not let them become a second source of truth for behavior.

## 8. Maintenance

- Update requirements when the page changes; **re-export + version mockups** (new filename or revision); bump `version` + `last_updated`; add a Revision-history row → task.
- A page whose requirements grow large promotes per the [Documentation System Guide §10](Documentation%20System%20Guide.md#10-promote-to-folder-rule) (sections become parts).

## 9. Cross-linking

Page ↔ the **FRs** it satisfies (Functional), the **API/MCP entries** its components call (Directories), the **Data Dictionary** tables it reads/writes, the owning **component(s)** (Technical Design), the **actions** it gates on, and the **tasks** that build it.

## 10. Markdown discipline

Per the [Documentation System Guide](Documentation%20System%20Guide.md#13-markdown--diagram-discipline).

## Revision History

| Rev | Date | Summary | Task |
|---|---|---|---|
| r1 | {{DATE}} | Initial convention. | — |
