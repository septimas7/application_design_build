---
name: git-workflow-and-versioning
description: Use when committing, branching, or versioning code - trunk-based flow with atomic commits that cite task-NNNNN and the FRs they implement, and interface versioning that mirrors the Directories' status/since model. Keeps the design-to-code traceability graph alive in git history.
---

# Git Workflow & Versioning

Atomic, traceable commits on a trunk-based flow. The git history is where the design-to-code traceability survives — **every commit cites its `task-NNNNN`**.

## When to use

- Committing, branching, opening a PR, or versioning an interface.

> Per the harness: branch before committing if on the default branch; only commit/push when the user asks.

## Commit discipline

1. **Atomic commits — one vertical slice each** (from `incremental-implementation`). A commit is a coherent, reviewable, revertible step.
2. **Cite the task + FRs.** Message references `task-NNNNN` and the FR(s) it implements, e.g. `feat(catalog): create_item store (task-00012, catalog:FR-001)`.
3. **No mixed concerns** in one commit (don't bundle a refactor with a feature). Split.
4. **Keep tests green per commit** — each commit builds and passes.

## Branching (trunk-based)

- Short-lived feature branches off trunk; integrate often; avoid long divergence.
- A branch maps to a task (or a small set); name it for the task.
- Finish per `finishing-a-development-branch` discipline when complete.

## Review chunks (long autonomous runs)

- A **review chunk** is a completed unit wave (one plugin/unit's task set) or roughly ~10K changed lines — whichever comes first. At that point, push and hand the branch off for review, then continue on the **next** unit. Work never stops for review; but a defect also never gets ten more hours of work stacked on top of it.
- **Don't cross-merge in-flight feature branches.** If branch B needs branch A's work, A is by definition review-ready — hand it off. Stacking merges of unreviewed branches multiplies conflict resolution and forces re-review of moved code.
- **Open the draft PR at branch creation**, so CI runs from the first push and its history exists when a failure needs triage.

## Interface versioning mirrors the Directories

The Directories already version interfaces with **`status` (active | deprecated | removed) + `since`**. Code/releases follow that:

- A backward-compatible interface addition → minor bump; the Directory entry is `since rN`.
- A breaking change follows the project's **interface-versioning policy** — **deprecate-don't-delete**: mark the entry `deprecated`, keep it working through the window, then `removed`.
- Don't break a published contract without going through the Directory first.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "I'll commit everything at the end." | Atomic, per-slice commits. Big commits don't review or revert. |
| "The message can just say 'fix'." | Cite `task-NNNNN` + FRs. History is traceability. |
| "Bundle the refactor in here." | One concern per commit. Split. |
| "Just remove the old endpoint." | Deprecate-don't-delete; version it via the Directory. |

## Red flags

A commit not citing a task, a commit mixing unrelated concerns, a commit that doesn't build/pass, a breaking interface change with no Directory deprecation, long-lived divergent branches.

## Verification

- [ ] Each commit is atomic, builds, passes tests, and cites `task-NNNNN` (+ FRs).
- [ ] No mixed-concern commits.
- [ ] Branch is short-lived and task-scoped.
- [ ] Interface changes reflect the Directory's `status`/`since`; breaking changes deprecate-don't-delete.
