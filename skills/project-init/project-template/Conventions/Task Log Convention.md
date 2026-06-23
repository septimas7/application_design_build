---
doc_type: convention
unit: system
title: Task Log Convention
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
  - task-log
---

# Task Log Convention

Governs the `tasks.md` build logs. There is one at the **repo root** (`tasks.md` — program + Platform work) and one **per Application** (`Applications/<app>/tasks.md`). A task log is the durable, append-only record of what work is done, in flight, and queued; any contributor (human or LLM) resuming work reads it first, then updates it.

Read the [Documentation System Guide](Documentation%20System%20Guide.md) for the shared conventions it relies on.

## 1. Scope: which log gets the task

- **Root `tasks.md`** — cross-cutting/program work, Platform work, and anything spanning multiple applications.
- **`Applications/<app>/tasks.md`** — work on that one application.

Put a task in the most specific log that fully contains it. Reference work in another log as `<unit>:task-#####` (e.g. `catalog:task-00007`).

## 2. File anatomy

1. **YAML frontmatter** — `doc_type: task-log`, `unit`, `status`, `owner`, `created`, `last_updated`, `machines` (hostnames touched), `tags`.
2. **`# Task Log: <unit>`** title.
3. **`## Project Summary`** — 2–5 sentence overview of the unit. Rewrite when scope materially changes.
4. **`## Current State`** — the "where we left off / what's next" handoff. **Rewrite before ending every session.** The single most important field for resume.
5. **`## Open Questions`** — unresolved decisions awaiting the owner.
6. **`## Tasks`** — the task entries (H3), in **build order**, newest appended at the bottom (above `## Example`).
7. **`## Example`** — one fully-worked reference task. Do not edit or delete.

## 3. Task entry schema

Each task is an H3 `### task-NNNNN: <short imperative title>` followed by a yaml fenced block, then H4 prose sections. Full shape (shown inside a 4-backtick wrapper so the inner yaml fence displays literally):

````
### task-00001: Stand up the catalog store

```yaml
status: planned          # planned | in_progress | blocked | completed | cancelled
priority: P0             # P0 | P1 | P2 | P3
created: 2026-01-01T10:00:00-05:00
closed:                  # set when done
estimated: 1w
agent: unassigned        # human | <agent id> | unassigned
machine:                 # hostname, set when work starts
depends_on: []          # task IDs this depends on
blocks: []              # task IDs this task unblocks
references:             # design entities this task touches, by stable ID (omit any key that doesn't apply)
  implements: [FR-001, NFR-002]                                  # functional / non-functional requirements
  components: [CMP-001]                                          # CMP-### (handle lives in the Technical Design)
  interfaces: [catalog.create_item, catalog.api.create_item, catalog.item.created]
  ui: [catalog/ui/catalog-view]
  data: [catalog_item]
  actions: [catalog.item.create]
artifacts: []
tags: ["#area/catalog", "#fr/001"]
```

#### Objective
What to build. REQUIRED.

#### Context
Background a fresh contributor needs; pointers to the spec. Optional.

#### Subtasks
- [ ] concrete, parallelizable checkboxes (each a vertical slice where possible)

#### Acceptance
- [ ] testable, checkable definition-of-done criteria — REQUIRED for build tasks
- [ ] each criterion observable (a test passes, a doc shows X, an endpoint returns Y)

#### Notes
Decisions, risks, pointers. Optional **Decision Record** for a decision that constrains the
future (often the output of a doubt-driven review):
- **Decision:** the choice, as one claim.
- **Alternatives considered:** the options weighed + why each was rejected.
- **Consequence:** the trade-off / limitation now accepted.

#### Result
Filled at close — what shipped and where it lives. REQUIRED at close.
````

The yaml **`references`** map houses the stable-ID links to the design (FRs/NFRs, components, interfaces, UI pages, tables, actions) — kept in the structured header next to `depends_on`/`blocks` so they are easy to grep and machine-parse; omit any key that does not apply. `#### Acceptance` is its own checkbox list, distinct from `#### Subtasks`: Subtasks are *how you build it*; Acceptance is *how you know it's done*.

## 4. ID conventions

- `task-NNNNN` — zero-padded, **monotonic within each log** (the root log and each app log number independently). Subtasks: `task-NNNNN-a` or inline checkboxes.
- Never reuse or renumber IDs. Cancelled tasks keep their ID with `status: cancelled` + a `#### Notes` reason.
- Cross-log reference: `<unit>:task-NNNNN`.

## 5. Update & handoff rules

- New tasks at the **bottom** of `## Tasks`, above `## Example`. Tasks are laid out in build (dependency) order.
- When updating a field, locate the H3 by id and change only that line — do not rewrite the whole task.
- On close: `status: completed`, set `closed`, fill `#### Result`, bump `last_updated`.
- **Never delete a task** — cancel with `status: cancelled` + a reason.
- Append the current machine hostname to `machines:` the first time you write from a new machine.
- **Before ending a session:** update `in_progress` tasks' Notes, rewrite `## Current State`, bump `last_updated`. A fresh contributor must be able to resume from the file alone.

## 6. Cross-linking

A task's yaml **`references`** map cites the **FRs / NFRs** it implements and the **components (CMP-###) / interface entries / data tables / UI pages / actions** it touches, by stable ID. Doc revision-history rows point back to the `task-#####` that drove the change — the bridge between *what changed* (the docs) and *why* (here).

## 7. Markdown discipline

Per the [Documentation System Guide](Documentation%20System%20Guide.md#13-markdown--diagram-discipline). Especially: never indent the task's yaml/code fences inside a list, keep fences balanced, wrap bare `<...>` in backticks. A one-line check — no indented fences — keeps Obsidian rendering intact.

## Revision History

| Rev | Date | Summary | Task |
|---|---|---|---|
| r1 | {{DATE}} | Initial convention. | — |
