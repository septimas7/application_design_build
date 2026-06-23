---
name: technical-design
description: Use to author or extend a unit's Technical Design.md - the how. Produces the component model, C4 diagrams, and contract surface (service interfaces) per the Technical Design Convention, referencing the Dictionaries/Directories as SSOT and running doubt-driven-review and source-grounding on decisions that constrain the future.
---

# Technical Design

Author the **how** of a unit: its internal components and the contract surfaces that implement its FRs. SSOT: the project's **Technical Design Convention**. It explains the *how* and **links out** for the *what* (Functional Design), the *data* (Data Dictionary), and the *exposed surface* (Directories) — it never duplicates them.

Target file: `<unit>/Technical Design.md` (promotes to `Technical Design/README.md` + `Components/<component>.md`).

## When to use

- After the unit's Functional Design has FRs to implement.
- Adding/altering a component or the contract surface.

## File anatomy (Technical Design Convention §3)

1. **Architectural summary** — the unit in a paragraph + a **C4 Context/Container** diagram; where it sits in the capability stack.
2. **Component model** — the internal components, each one responsibility + a defined interface; a **C4 Component** diagram.
3. **Contract surface** — **service interfaces** it provides/consumes (in-process DI, with signatures); **events** emitted/subscribed and **user-exits/hooks** registered/implemented (*referenced* from the unit's Events / User Exits Directories — canonical there).
4. **Data architecture** — schema ownership + storage approach, **referencing** the Data Dictionary. No table definitions here.
5. **Key flows** — sequence/data-flow (Mermaid), **including how an external agent consumes the unit**.
6. **Sidecars / external integrations.**
7. **Cross-cutting** — RBAC actions/areas registered (→ Resources & Grants Dictionary), failure modes, concurrency, observability/jobs, security & privacy.
8. **Dependencies & load order** — required platform services; topological position; **no cycles**.
9. **Extensibility / agent integration.**
10. **Risks, trade-offs, alternatives considered.**
11. **Open questions** · 12. **Revision history.**

## Component entry schema

Use the schema in `references/doc-anatomy-cheatsheets.md`: **Responsibility / Public interface / Depends on / Owns data / Emits-hooks / Notes**. Components are `CMP-###` with a handle in parens (e.g. `CMP-001 (catalog.store)`). One clear responsibility per component (design for isolation). If a component's design grows large, **promote-to-folder** (split unit = the component).

## Diagrams

**C4** levels (Context → Container → Component) as **Mermaid** in column-0 fences. These design-time diagrams feed the same C4 model the runtime documentation generator produces — keep them faithful.

## Reference, don't duplicate

Data → Data Dictionary. Interfaces → Directories (the Directories are SSOT for the interface surface; keep the component model in sync with them). Behavior → Functional Design. The **internal** in-process contract (service interfaces) is documented **here**; the **external/consumable** contract lives in the Directories.

## Gates to call (mandatory on constraining decisions)

- **`doubt-driven-review`** — run on **every design decision that constrains the future** (a storage choice, a contract boundary, a concurrency model). Capture the survived rationale + the alternative considered in §10 and in the driving task's `#### Notes`.
- **`source-grounding`** — ground framework/tech choices (the database engine's capabilities, a library's guarantees, an external product's API) in official docs before committing them.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "I'll define the table here too, it's convenient." | Data Dictionary is SSOT. Reference it. |
| "This component does a few related things." | One responsibility per component. Split. |
| "The decision is obviously correct." | If it constrains the future, run doubt-driven-review and record the alternative. |
| "I'll trust my memory of the API." | Ground it with source-grounding; APIs drift. |
| "Skip the C4 diagram for now." | The diagram feeds the runtime model. Author it. |
| "Document events fully here." | Events are canonical in the Events Directory. Reference + summarize. |

## Red flags

A component with multiple responsibilities · table/interface definitions duplicated from the Dictionaries/Directories · a dependency cycle in load order · a constraining decision with no rationale/alternative · missing C4 diagrams · contract surface out of sync with the Directories.

## Verification

- [ ] Anatomy matches Technical Design Convention §3.
- [ ] Each component has one responsibility + a defined interface; links to its FRs, owned tables, and exposed entries.
- [ ] Data/interfaces/behavior referenced, not duplicated.
- [ ] Dependencies acyclic; load order stated.
- [ ] Constraining decisions ran doubt-driven-review; rationale + alternative recorded.
- [ ] Tech choices ran source-grounding where feasibility is non-obvious.
- [ ] C4/Mermaid at column 0; markdown-discipline check passes.
- [ ] Frontmatter + revision-history row → driving task.
