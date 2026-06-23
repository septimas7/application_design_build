---
doc_type: convention
unit: system
title: Technical Design Convention
status: active
version: r1
owner: {{OWNER}}
created: {{DATE}}
last_updated: {{TIMESTAMP}}
related:
  - "Documentation System Guide.md"
  - "Functional Design Convention.md"
tags:
  - {{project-slug}}
  - convention
  - technical-design
---

# Technical Design Convention

Governs the `Technical Design.md` of every unit (`Platform/Technical Design.md` and each `Applications/<app>/Technical Design.md`). It describes **how** a unit is built — its **non-functional requirements**, its internal **components**, and the contract surfaces that implement the unit's functional requirements.

Read the [Documentation System Guide](Documentation%20System%20Guide.md) first.

## 1. Purpose & scope

The Technical Design is the authoritative architecture of a unit. Platform's covers the foundational architecture (the service registry, the event bus, the hook/user-exit registry, the RBAC engine, the job runtime, the UI shell). An Application's covers its internal architecture and how it plugs into the Platform contract.

It explains the *how* and links out for the *what* (Functional Design), the *data* (Data Dictionary), and the *exposed surface* (Directories). It does not duplicate those.

Two kinds of numbered, linkable entry live here so other docs (and tasks) can reference them precisely:

- **Non-functional requirements** — `NFR-###` (quality attributes: performance, security, scalability, reliability, observability).
- **Components** — `CMP-###` (each with a descriptive handle `<unit>.<component>`).

## 2. Location & frontmatter

- **Path:** `<unit>/Technical Design.md` (promotes to a folder — see §8).
- **Frontmatter:** shared schema with `doc_type: technical-design`, the `unit`, and `depends_on` listing the Platform services / other units it consumes (its topological position; no cycles).

## 3. File anatomy

1. **Architectural summary** — the unit in a paragraph, plus a **C4 Context/Container** diagram (Mermaid); where it sits in the dependency layering.
2. **Non-functional requirements** — the `NFR-###` entries (see §4): the quality targets that shape the architecture.
3. **Component model** — the internal components (`CMP-###`), each a single responsibility with a defined interface (see §5). A **C4 Component** diagram.
4. **Contract surface** — how the unit participates in the Platform:
   - **Service interfaces / contracts** it provides/consumes (the in-process dependency-injection contract — documented here, with signatures; stack-agnostic).
   - **Events** it emits/subscribes to, and **user-exits/hooks** it registers/implements — *referenced* from the unit's Events and User Exits Directories (canonical there), summarized here for how the components use them.
5. **Data architecture** — schema ownership and storage approach, **referencing** the unit's Data Dictionary as the SSOT. No table definitions here.
6. **Key flows** — sequence/data-flow for notable paths (Mermaid), **including how an external agent (an LLM harness) consumes the unit**.
7. **Sidecars / external integrations** — separate processes, providers, and their health/contract.
8. **Cross-cutting** — RBAC actions/areas the unit registers (→ Resources & Grants Dictionary), failure modes, concurrency, observability/jobs, security & privacy posture.
9. **Dependencies & load order** — required Platform services; topological position; no dependency cycles.
10. **Extensibility / integration** — how other plugins/agents extend or consume the unit, and via which services/events/hooks.
11. **Risks, trade-offs, alternatives considered** — decisions with rationale.
12. **Open questions** · 13. **Revision history**.

## 4. Non-functional requirement (NFR) entry schema

Each NFR is an H3 followed by a field list. IDs are unit-scoped and never renumbered or reused (cross-referenced from other units as `unit:NFR-###`).

```
### NFR-001 — Catalog list latency

- **Category:** performance        (performance | security | scalability | reliability | observability | portability)
- **Priority:** P1
- **Requirement:** The catalog list view returns within 200 ms p95 at 10,000 items.
- **Measurement:** load test asserting p95 latency; tracked as a perf budget.
- **Satisfied by:** CMP-001 (catalog.store)
```

Each NFR is **measurable** (a number or a checkable condition), not a vague aspiration. NFRs are the technical counterpart to the Functional Design's FRs; a task references both in its yaml `references` map.

## 5. Component entry schema

Each component (a C4-Component-level unit) is an H3 carrying its **number `CMP-###`**, its **handle `<unit>.<component>`**, and a short name, followed by a field list:

```
### CMP-001 — catalog.store — Catalog store

- **Responsibility:** Generate and evolve the catalog's tables from its schema metadata.
- **Public interface:** `CatalogStore` service contract (define_table, alter_table, drop_column).
- **Depends on:** CMP (platform.db), CMP (platform.migration-runner).
- **Owns data:** `catalog_item`, `catalog_item_def` (→ Data Dictionary).
- **Satisfies:** catalog:FR-001, catalog:NFR-001.
- **Emits / hooks:** emits `catalog.item.created`; honors `catalog.before_item_write` (→ Directories).
- **Notes:** schema changes are generated, never hand-written; see Risks for the destructive-change policy.
```

The **`CMP-###` number** is the canonical short ID other docs and tasks link to; the **handle `<unit>.<component>`** is the human-readable name (and is reused verbatim as the component's log-source id — see the Dictionary Convention). One clear responsibility per component. If a component's design grows large, the file promotes (§8).

## 6. Diagrams convention

- Use **C4** levels: **Context → Container → Component** (the Code level is the actual source, not documented here).
- Author diagrams as **Mermaid** in column-0 fenced blocks (a triple-backtick line followed by `mermaid`), so they render on GitHub and in Obsidian.
- These design-time diagrams feed the **same C4 model the runtime Docs plugin generates** from the live system — keep them faithful.

## 7. Authoring rules

- Describe the *how*; one responsibility + a defined interface per component (design for isolation).
- **Reference, don't duplicate:** data → Data Dictionary; interfaces → Directories; behavior → Functional Design.
- Every NFR is measurable; every component names what it **satisfies** (FRs/NFRs).
- Every design decision that constrains the future carries a short rationale (and an alternative considered, where relevant).

## 8. Maintenance & promote-to-folder

- Update when the architecture changes; keep the component model consistent with the Directories (Directories are SSOT for the interface surface).
- **Promote-to-folder** (per the Documentation System Guide §10) when the file grows: split unit is the **component**.

```
<unit>/Technical Design/
   README.md            ← architectural summary, C4 diagrams, NFRs, contract-surface overview, component catalog (links)
   Components/
      <component>.md     ← one component's full design
```

- Bump `version` + `last_updated`; add a Revision-history row pointing to the task.

## 9. Cross-linking

Each component (`CMP-###`) links to the **FRs/NFRs** it satisfies, the **Directory entries** it exposes, the **Data Dictionary** tables it owns, and the **tasks** that build it (which reference it back by `CMP-###` in their yaml `references` map).

## 10. Markdown discipline

Per the [Documentation System Guide](Documentation%20System%20Guide.md#13-markdown--diagram-discipline).

## Revision History

| Rev | Date | Summary | Task |
|---|---|---|---|
| r1 | {{DATE}} | Initial convention. | — |
