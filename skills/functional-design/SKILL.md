---
name: functional-design
description: Use to author or extend a unit's Functional document (Platform Functional Design.md or an Application Functional Spec.md) - the what. Produces FRs with testable acceptance and the capabilities-exposed/consumed framing per the Functional Design Convention, calling doubt-driven-review and source-grounding as gates.
---

# Functional Design

Author the **what** of a unit: its capabilities, behaviors, and **Functional Requirements** — never the *how* (that's `technical-design`). This applies the "surface assumptions + boundaries" discipline of spec-driven development onto the project's **Functional Design Convention**, which is the SSOT and wins on every conflict.

Target file: `Platform/Functional Design.md` (or `.../README.md` when promoted) · `Applications/<app>/Functional Spec.md`.

## When to use

- Authoring a new unit's Functional doc, or adding/altering an FR.
- After `interview-requirements` (and `idea-refine` for a new unit) — you should have a pre-Functional brief.

## Before you write — surface assumptions & boundaries

State your assumptions explicitly (carry them from the brief). Capture **boundaries** as: what the unit must **always** do, what needs **approval**, what it must **never** do. These seed the FR acceptance and the **Non-goals** section.

## File anatomy (Functional Design Convention §3)

In order:

1. **Overview** — what the unit is and why, in a few sentences.
2. **Capabilities — exposed & consumed** — what it offers others and what it depends on; the exposed list points into the unit's Directories. *The heart of the backbone framing.*
3. **Actors / personas** — humans, internal plugins, and **external agents (LLM harnesses)** as first-class consumers.
4. **Functional Requirements** — the `FR-###` entries (the core).
5. **Key flows** — notable user/agent journeys (optional).
6. **Rules & states** — business rules and entity lifecycles, behaviorally.
7. **Non-goals / out of scope.**
8. **Open questions.**
9. **Revision history** — the shared `rN` table.

## FR entry schema

Use the schema in `references/doc-anatomy-cheatsheets.md`. Rules:

- **One capability per FR** — split rather than bundle.
- **Every FR has a testable `Acceptance` list.**
- The cross-links — **Exposed via** (Directories), **Implemented by** (Technical Design component), **UI** (page), **Requires action** (Resources & Grants Dictionary) — are what keep the traceability graph intact. Omit a line only if genuinely N/A. These may point at IDs that don't exist yet; minting them here drives the later docs.

Example: `FR-001 "Create a catalog item"` is implemented by component `CMP-001 (catalog.store)`, exposed via MCP `catalog.create_item`, surfaced on UI page `catalog/ui/catalog-view`, and requires action `catalog.item.create`.

## Functional, not technical

If you're naming a table, a service interface/contract, or an endpoint shape — it belongs in the Technical Design / Dictionary / Directory. **Link to it; don't write it here.**

## Gates to call

- **`doubt-driven-review`** — run on any FR whose acceptance encodes a non-trivial product decision, or where scope is contentious.
- **`source-grounding`** — if an FR's feasibility depends on what an external product/standard actually supports (especially connectors), ground it before asserting the acceptance.

## Application `type`

If this is an Application, set `type` in frontmatter (native/connector/hybrid). A **connector**'s exposed/consumed list reflects what it surfaces from the external product; its credentials always go via the platform secret store (documented in its Config Dictionary, never here).

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "I'll bundle these two behaviors in one FR." | One capability per FR. Split. |
| "Acceptance is obvious, skip it." | No testable acceptance = not an FR. Write it. |
| "I'll specify the schema here for clarity." | Schemas live in the Data Dictionary. Link out. |
| "Non-goals are obvious." | Unstated scope creeps. Write the non-goals. |
| "The doc explains why we chose this." | The *why* lives in `tasks.md`; the doc gets a revision-history row → task. |

## Red flags

An FR with no acceptance · an FR bundling multiple capabilities · technical detail (schema/interface/endpoint shape) inline · missing the capabilities-exposed/consumed section · no external-agent persona · renumbering or deleting an FR (supersede in place).

## Verification

- [ ] Anatomy matches Functional Design Convention §3.
- [ ] Every FR is one capability with testable acceptance.
- [ ] Cross-links (Exposed via / Implemented by / UI / Requires action) present where applicable.
- [ ] Capabilities exposed & consumed + external-agent persona present.
- [ ] No technical detail that belongs elsewhere.
- [ ] Frontmatter (incl. `type` for Apps) per `references/frontmatter-schema.md`; revision-history row added → driving task.
- [ ] Markdown-discipline check passes.
