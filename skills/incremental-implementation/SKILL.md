---
name: incremental-implementation
description: Use when implementing a planned task-NNNNN - turning a planned task into working code one thin vertical slice at a time, each slice tested, verified against the task's Acceptance criteria, and committed individually. Reads the design docs as the spec source and updates tasks.md on close.
---

# Incremental Implementation

Turn a planned `task-NNNNN` into working code in **thin vertical slices** — each slice complete (data -> component -> interface -> UI as the task needs), tested, verified, and committed on its own. Never a big-bang drop. SSOT for the spec is the design docs; SSOT for the stack/mapping is `references/implementation-stack-and-doc-mapping.md`.

## When to use

- A task is planned (via `planning-and-tasking`) and ready to build.
- Any non-trivial code change.

**Skip** for a one-line fix with obvious scope (just make it + verify).

## Before writing code — load only what the task touches

Read, in this order, **only the parts the task references** (exploit promote-to-folder):

1. The `task-NNNNN` entry — its `#### Acceptance` (your target) and `#### Subtasks`.
2. The **FR(s)** it implements + their acceptance.
3. The **Technical Design component** (its Public interface = the backend service interface/contract).
4. The **Directory entries / Data Dictionary tables / actions / config** it touches.

Do not load whole subsystems. Navigate by stable ID.

## Process

1. **Pick the next slice.** The smallest vertical path that makes one acceptance criterion (or part of one) true. Order by the dependency map from the plan.
2. **Test-first where it fits** — call `test-driven-development` for logic with a clear contract; the test encodes the acceptance criterion.
3. **Implement to the contract.** The service interface signature comes from the Technical Design; the wire shape from the Directory entry; the schema from the Data Dictionary. Don't invent contracts — implement the ones already specified.
4. **Verify the slice.** Run the slice's tests + a real check (run it; for the web client / portal, call `browser-testing-with-devtools`). Evidence, not vibes.
5. **Commit the slice.** Atomic commit citing `task-NNNNN` (see `git-workflow-and-versioning`). One slice = one commit.
6. **Repeat** until every `#### Acceptance` checkbox is satisfiable.

## On close (Task Log Convention)

- Check off the `#### Acceptance` items that now pass; check off `#### Subtasks`.
- Set `status: completed`, fill `#### Result` (what shipped + where), bump `last_updated`.
- **Rewrite `## Current State`** so a fresh contributor can resume.
- If a constraining decision was made mid-build, add a **Decision Record** to `#### Notes`.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "I'll build it all then test at the end." | Big-bang drops hide bugs and bloat diffs. Slice + test + commit. |
| "I'll define the interface as I code." | The contract is already in the Directory / Technical Design. Implement it. |
| "I'll squash 6 slices into one commit." | One slice = one atomic commit citing the task. |
| "Acceptance is roughly met." | Each criterion is checkable. Check it with evidence. |
| "I'll update tasks.md later." | Resume depends on it. Update Result + Current State now. |

## Red flags

Code that invents a contract the Directories already define · a commit spanning multiple unrelated slices · no test/verification for a slice · acceptance ticked without evidence · `## Current State` left stale.

## Verification

- [ ] Every `#### Acceptance` criterion is satisfied with evidence (test/output).
- [ ] Each slice was committed atomically, citing `task-NNNNN`.
- [ ] Code matches the specified contracts (service interface / Directory entry / schema / action gate) — nothing invented.
- [ ] `#### Result` filled, `status: completed`, `## Current State` rewritten, `last_updated` bumped.
