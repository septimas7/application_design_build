---
name: ui-design
description: Use after Functional + Technical design to review a unit's UI page-by-page, surface the data/actions/interfaces each page entails, and generate mockups (via the frontend-design skill) into per-page Mockups/ folders. Runs before directories-and-dictionaries, which formalizes the surfaced entities.
---

# UI Design

Review a unit's UI **page-by-page** and pin down, for each page, what it shows, how it behaves, and **every entity it entails** — the data it reads/writes, the actions it triggers, and the interfaces it calls. **The split unit is the page**: every page gets its own folder. SSOT: the **UI Design Convention**.

This runs **after `functional-design` + `technical-design`** and **before `directories-and-dictionaries`**. That order is deliberate: walking the UI is the most reliable way to discover the real entity surface, and what this pass surfaces becomes the input the Directories formalize.

Target: `<unit>/UI/<page>/UI Design Requirements.md` + `<unit>/UI/<page>/Mockups/`. **Platform/UI** owns the global shell + cross-cutting pages **and the shared design system**; an Application's UI holds that app's pages and **references** the Platform design system.

## When to use

- A unit has FRs and a component model, and you're reviewing its screens.
- Adding or revising a page.

Work through **all the unit's pages** in this pass — the point is a complete UI review, not one screen in isolation.

## Process

### 1. Enumerate the pages

From the FRs (each FR names a `UI:` page) and the personas, list every page the unit needs. One folder per page.

### 2. Author the requirements (UI Design Convention §3)

Per page, in order:

1. **Overview** — purpose, personas, route.
2. **Layout** — regions/zones + responsive behavior; points to mockups.
3. **Components** — each UI component (schema below).
4. **States** — empty / loading / error / populated / **permission-denied** + key transitions.
5. **Interactions & flows** — what each action does (links to the interface entries it calls).
6. **Mockups** — references to `Mockups/` files, annotated.
7. **Content / copy** — labels, empty-state copy, error messages.
8. **Accessibility** — keyboard / contrast / screen-reader, scaled to the page.
9. **Open questions** · **Revision history.**

### 3. Component entry schema

Use `references/doc-anatomy-cheatsheets.md`. Every component **binds to its data + actions** (so each element traces to an interface) and names the **action** that gates its visibility (show/hide by access level).

### 4. Generate mockups with the `frontend-design` skill

For each page, invoke the **`frontend-design` skill** to produce distinctive, production-grade **interactive HTML/CSS mockups**. Save the output as files into that page's `Mockups/` folder. Then:

- **Name** each file `<page>-<breakpoint>-<state>.<ext>` (e.g. `catalog-view-desktop-populated.html`).
- **Label fidelity:** wireframe → mockup → prototype.
- Cover the key **breakpoints** (desktop/mobile) and **states** (at least empty + populated; error/permission-denied where they matter).
- Have the mockup **consume the Platform design system** (tokens/base components), not invent new styling.
- **Reference + annotate** each file in the requirements (what state/breakpoint it depicts).

**Authority rule:** the requirements **text is authoritative for behavior; mockups illustrate.** When they conflict, the text wins. Re-run `frontend-design` to revise a mockup; never let it become a second source of truth.

### 5. Surface the entities (hand-off to directories-and-dictionaries)

This is the payoff of doing UI before the Directories. From the page's components, interactions, and states, list:

- **Data** the page reads/writes → candidate tables/columns (→ Data Dictionary).
- **Actions** it triggers and gates on → candidate `<unit>.<resource>.<action>` IDs + the functional areas/access levels they imply (→ Resources & Grants Dictionary).
- **Interfaces** it calls → candidate API/MCP entries (→ API / MCP Tools Directories).

For example, page `catalog/ui/catalog-view` reads/writes table `catalog_item`, triggers action `catalog.item.create`, and calls MCP `catalog.create_item` / API `catalog.api.create_item`.

Mint these as **candidate stable IDs** now (per `references/stable-id-and-cross-link-graph.md`) and bind the components to them. They may not exist yet — that's expected; `directories-and-dictionaries` canonicalizes them next. Collect them into an **"Entities surfaced"** note that feeds that skill.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "I'll design the Directories first, then the UI." | UI before Directories — walking the screens surfaces the real entity surface. |
| "I'll hand-draw a wireframe." | Use the `frontend-design` skill for real mockups; save them into `Mockups/`. |
| "The mockup is the spec." | Text is authoritative; mockups illustrate. Specify in prose. |
| "This component is obvious, skip the data binding." | Every component binds to its data + actions, or it isn't traceable. |
| "Only the populated state matters." | empty / loading / error / **permission-denied** are required. |
| "I'll define a new button style here." | Reference the Platform design system; add shared patterns there. |
| "I'll list the entities later." | Surfacing entities is the whole reason UI runs here. Do it now. |

## Red flags

A component with no data/action binding · a hand-drawn mockup instead of a `frontend-design` artifact · a mockup treated as the source of truth · redefined design tokens · missing permission-denied or error states · no "Entities surfaced" hand-off to `directories-and-dictionaries`.

## Verification

- [ ] Every page in the unit reviewed; one folder per page; anatomy matches UI Design Convention §3.
- [ ] Every component binds to data + actions and names its gating action.
- [ ] All states present (incl. permission-denied); transitions noted.
- [ ] Mockups generated via `frontend-design`, saved to `Mockups/`, named/annotated/fidelity-labeled; text kept authoritative.
- [ ] Mockups consume the Platform design system rather than redefining it.
- [ ] **Entities surfaced** (data / actions / interfaces) captured as candidate IDs and handed to `directories-and-dictionaries`.
- [ ] Page cross-links its FRs, the API/MCP entries it calls, tables, components, actions, tasks.
- [ ] Frontmatter incl. `page` + `route`; markdown-discipline check passes; revision-history row → driving task.
