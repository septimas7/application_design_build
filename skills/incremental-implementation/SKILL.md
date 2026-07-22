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
2. **Test-first where it fits — invoked per slice, not per run.** Call `test-driven-development` at the start of *each* slice with a definable contract; the test encodes the acceptance criterion. (Audited: a single run-opening invocation decayed within hours — red-first held in only half the slices. The per-slice call is what sustains it.)
3. **Implement to the contract.** The service interface signature comes from the Technical Design; the wire shape from the Directory entry; the schema from the Data Dictionary. Don't invent contracts — implement the ones already specified.
4. **Verify the slice.** Run the slice's tests + a real check (run it; for the web client / portal, call `browser-testing-with-devtools`). Evidence, not vibes. Gate economics: run the **focused** suite per slice; run the **full** gate once per pushed chunk — and once more only if a fix touched shared surface, not after every test-only repair.
5. **Commit the slice.** Atomic commit citing `task-NNNNN` (see `git-workflow-and-versioning`). One slice = one commit.
6. **Repeat** until every `#### Acceptance` checkbox is satisfiable.

## When blocked by a missing contract

A slice needs an interface, hook, or route the design docs don't define? **Never fabricate it, and never fake the integration** (a polling loop standing in for a missing event, a stub host for an unbuilt hook). Record the gap as a design question (the unit's Open Questions + the task's `#### Notes`), leave the affected acceptance box honestly unchecked, and take the next unblocked slice. Blocked-and-recorded is progress; an invented contract is future rework plus a false green.

## Claiming a task that carries review debt

If a prior review deferred items *into* this task ("lands in task-NNNNN"), walk that list as a checklist at claim time: each item is either **built here** or **explicitly re-deferred with a note in the log**. Silence is what turns a deferral into a regression.

## On close (Task Log Convention)

- Check off the `#### Acceptance` items that now pass; check off `#### Subtasks`.
- Set `status: completed`, fill `#### Result` (what shipped + where), bump `last_updated`.
- **Rewrite `## Current State`** so a fresh contributor can resume.
- If a constraining decision was made mid-build, add a **Decision Record** to `#### Notes`.
- **Coherence check before committing the log**: yaml and prose must agree — `status: completed` ⇔ `closed:` date set ⇔ every `#### Acceptance` box checked ⇔ `#### Result` filled (and the converse for `in_progress`). Verify the edit landed on the *intended* task block, not an adjacent one — read the rendered diff. A yaml/prose contradiction is an evidence defect.
- **Hand-edited coordination files corrupt at agent speed — care doesn't scale, lint does.** (Audited: three of four branches in one evening corrupted the shared register — a false milestone completion, a dependency edge on the wrong task, silently closed entries — plus 29 broken revision tables; every one was an adjacent-block or table-structure edit slip.) The durable fix is a mechanical doc-lint gate: yaml⇄prose coherence, table structure (new revision rows go *below* the `|---|` separator), and citation resolution. These lints are a stand-in for a schema — once coordination moves to a structured store whose API validates writes and rejects malformed updates with an error, they retire; until then they are the only validation the file has.

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
