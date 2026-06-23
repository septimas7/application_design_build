---
name: planning-and-tasking
description: Use when a firmed-up Functional/Technical design needs breaking into small, verifiable task-NNNNN entries in tasks.md. Merges decomposition discipline (dependency mapping, vertical slicing, sizing, checkpoints) with the project's Task Log Convention schema. Produces the build log, not code.
---

# Planning & Tasking

Turn a firmed-up design into **small, verifiable `task-NNNNN` entries** in the right `tasks.md`. Good breakdown is the difference between reliable completion and a tangled mess. The *process* here is decomposition discipline; the *artifact* is the project's **Task Log Convention** exactly — do not invent a new task format.

Read the routing/principles in `using-design-skills` first if you haven't. SSOT for the artifact: the project's **`Conventions/Task Log Convention.md`**.

## When to use

- A Functional/Technical design (or a slice of one) is stable enough to build.
- A large or ambiguous chunk of work needs scoping into implementable units.
- Work needs to be parallelizable across sessions/agents.

**Skip** for a single obvious one-file change with unambiguous scope, or when the design already contains well-defined tasks.

## The process (5 steps)

### 1. Read-only analysis (plan mode)
Read the relevant design docs and any existing code/docs **without writing anything**. Identify the conventions in play, the FRs/components involved, existing utilities to reuse, and the risks. Do not propose new artifacts when an existing one fits.

### 2. Map dependencies
Sketch what depends on what (a quick Mermaid graph or a list). Implementation goes **bottom-up** — foundations first. These dependencies become the `depends_on` / `blocks` fields of the task entries, and they fix the build order.

### 3. Slice vertically
Prefer **thin vertical slices** (a complete capability path: data → component → interface → UI) over horizontal layers. Each slice should be independently testable and map to one or a few FRs. A vertical slice usually becomes one task; its checkboxes become the `#### Subtasks`.

### 4. Structure each task (Task Log Convention §3)
Every task is an H3 + a yaml block + prose sections. Mint the ID from the right log (root vs per-app — see *Which log* below). Required fields:

- the **yaml block**: `status`, `priority`, `created`, `closed`, `estimated`, `agent`, `machine`, `depends_on`, `blocks`, `references`, `artifacts`, `tags`.
- `#### Objective` (required) · `#### Context` (FR/component pointers) · `#### Subtasks` (the vertical-slice checkboxes) · `#### Acceptance` (a **checkbox list of testable definition-of-done criteria** — required for build tasks) · `#### Notes` (decisions, risks, pointers) · `#### Result` (filled at close).

The **`#### Acceptance` section is its own checkbox list**, separate from the work checkboxes in `#### Subtasks`: Subtasks are *how you build it*; Acceptance is *how you know it's done*. Every criterion must be observable (a test passes, a doc shows X, an endpoint returns Y).

List the design entities the task touches in the **`references`** map of the yaml block — `implements` (FRs/NFRs), `components`, `interfaces`, `ui`, `data`, `actions` — by stable ID (`references/stable-id-and-cross-link-graph.md`); omit any key that doesn't apply. Keeping these in the structured header (next to `depends_on`/`blocks`) makes them greppable and machine-parseable. When a task makes a decision that constrains the future (often the output of a `doubt-driven-review` gate), add a **Decision Record** to `#### Notes` — **Decision: / Alternatives considered: / Consequence:** lines.

### 5. Sequence with checkpoints
Order tasks to satisfy dependencies and keep the system buildable at each step. Insert a **verification checkpoint every 2–3 tasks** (a point to confirm the slice works before continuing). Note checkpoints in the sequencing or as `#### Notes`.

## Task sizing

| Size | Meaning | Verdict |
|---|---|---|
| XS | a single function/field | fine |
| S | a small, self-contained change | ideal |
| M | one complete vertical slice | ideal |
| L | multiple slices / subsystems | **split it** |
| XL | too large to reason about | **must split** |

Split indicators: the title contains "and"; it spans multiple independent subsystems; it touches more than ~5 files; it's more than ~a day of work. Agents and humans both perform best on **S/M**.

## Which log gets the task

- **Root `tasks.md`** — cross-cutting/program work, Platform (the Platform unit) work, anything spanning multiple applications.
- **`Applications/<app>/tasks.md`** — work on that one application.

Put the task in the **most specific log that fully contains it**. Reference work in another log as `<unit>:task-NNNNN`. New tasks go at the **bottom** of `## Tasks`, above `## Example`, in build order. IDs are zero-padded, monotonic within each log, never reused.

## Handoff (before ending a session)

This is the single most important rule. Before you stop:

1. Update `in_progress` tasks' `#### Notes`.
2. **Rewrite `## Current State`** — the "where we left off / what's next" handoff. A fresh contributor must resume from the file alone.
3. Bump `last_updated`. Append your hostname to `machines:` the first time you write from a new machine.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "I'll just start building, the plan's in my head." | Unwritten plans produce tangled work. Write the tasks first. |
| "This task is fine without acceptance criteria." | No acceptance = no definition of done. Add it. |
| "It's one big task, splitting is overhead." | L/XL tasks fail. Split into vertical slices. |
| "I'll order them later." | Dependency order **is** the plan. Map it before writing tasks. |
| "I'll write Current State next time." | Next time is a different session with no memory. Write it now. |
| "Horizontal layers are cleaner." | A half-built layer isn't testable. Slice vertically. |

## Red flags

Starting implementation with no written task list · a task with no acceptance criteria · a plan with no verification checkpoints · every task sized L or XL · no dependency ordering · `## Current State` left stale at session end.

## Verification (before this skill is done)

- [ ] Every task validates against Task Log Convention §3 (H3 + yaml + Objective/Subtasks/Notes), with a `#### Acceptance` checkbox section of testable criteria.
- [ ] `depends_on` / `blocks` reflect the dependency map; tasks are in build order.
- [ ] Each task is S/M (no L/XL); file scope is reasonable (~≤5).
- [ ] A checkpoint exists every 2–3 tasks.
- [ ] Tasks cite their FRs and touched components/entries by stable ID.
- [ ] The task landed in the correct (most-specific) log; ID is monotonic and unused.
- [ ] `## Current State` rewritten; `last_updated` bumped; markdown-discipline check passes (`references/markdown-and-diagram-discipline.md`).
