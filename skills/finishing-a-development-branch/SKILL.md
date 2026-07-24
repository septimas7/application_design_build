---
name: finishing-a-development-branch
description: Use when landing a review-ready branch onto trunk - the merge-execution discipline that preserves the atomic task/FR commit history, records the review verdict, and verifies the merge actually reached the trunk. The mechanics `git-workflow-and-versioning` hands off to at "finish when complete".
---

# Finishing a Development Branch

Land a reviewed branch onto trunk without losing history or landing nowhere. `git-workflow-and-versioning` hands off here ("finish per `finishing-a-development-branch` discipline when complete"); `code-review-and-quality` is the gate that must pass first. The danger is not the merge conflict you can see - it is the merge that squashes away the traceability the whole flow exists to preserve, or that silently commits to the wrong ref.

## When to use

- A branch is review-ready (its review chunk closed, or a checkpoint task closed), its findings are all CLOSED or DEFERRED-RECORDED, and gates are green.
- You are the one landing it (an agent authorized to merge, or a human). Per the harness: only merge/push when the user asks.

**Skip** while review is open, a gate is red, or a finding is unresolved - fix first (`code-review-and-quality`, "Verifying a fix pass").

## Sync trunk before you touch it

Land onto the *current* trunk, not a stale local copy: `git checkout <trunk>`, then `git fetch` + `git reset --hard origin/<trunk>` (or `pull --ff-only`). A merge computed against a stale base silently re-introduces reverted work.

## Preserve history - never squash a review merge

- **`--no-ff`, never squash.** The branch's atomic per-slice commits each cite their `task-NNNNN` + FRs (`git-workflow-and-versioning`); squashing destroys exactly the design-to-code traceability the flow exists to keep. Merge with `--no-ff` so the branch's shape and the merge point both survive.
- **`git merge` does not read stdin.** `git merge -F -` fails (`could not read file '-'`). To write a real merge-commit message: `git merge --no-ff --no-commit <branch>`, then `git commit -F <file>` (or a heredoc).
- **The merge commit is a review ledger.** Its message records the review verdict, what was resolved, and what was *deferred* - behind which guard and which blocking task/dependency - so trunk history answers "why did this land, and what is still owed" without reopening the PR.

## Resolve stale-branch conflicts by convention

A long-lived branch collides with churn on shared infra files. Resolve mechanically, not creatively:
- **Manifest / member lists** (workspace members, module indexes): **union** - keep every entry from both sides.
- **Lock / generated files**: keep whole dependency *blocks* from both sides (a naive line-union corrupts a block), then let the tool regenerate on the next build.
- **The shared agent-instructions / environment-ledger file**: take the newer wording; **append**, never overwrite, agent-appended entries.
- Before merging, grep the branch's changed files for conflict markers *already committed* (a botched earlier resolution) - not only the ones this merge raises.

## Verify the merge landed - after committing, not before

The failure mode that hides: a merge computed from a **detached HEAD** (e.g. a review step left the working copy off-branch) commits to nowhere, and the push then reports "Everything up-to-date". So, after the merge commit:
- `git log --oneline -1` - confirm HEAD is on `<trunk>` (not detached) and *is* the new merge commit.
- Confirm the merge commit's parents are both the previous trunk tip **and** the branch tip.
- Push, and confirm it **advances** origin (`<old>..<new>  <trunk> -> <trunk>`), not "up-to-date". A no-op push right after a "successful" merge means the merge landed off-branch - recover before continuing.

## Reviewing on a shared clone (when review ran in the same working copy)

If the branch was reviewed in the *same* clone you now merge from, that review must have used **read-only** git only - `show` / `diff` / `log` / `grep` / `cat-file`. A review `checkout` / `switch` / `reset` detaches or moves the working copy, and the subsequent merge lands off-branch (above). This matters most with concurrent review agents sharing one clone. (Mirrored in `code-review-and-quality`.)

## After it lands

- Retire the branch (delete it / close its PR). One task's work does not keep a live branch after it merges (`git-workflow-and-versioning`: one live branch per task).
- Tick the task's acceptance and rewrite its `## Current State`; if a published contract changed, apply the Directory `status`/`since` bump (`git-workflow-and-versioning`, `deprecation-and-migration`).

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "Squash it into one clean commit." | Squashing destroys the per-slice task/FR traceability. `--no-ff`; keep the slices. |
| "The push said up-to-date, so it already merged." | A no-op push right after a merge means it landed off-branch (detached HEAD). Verify HEAD + parents. |
| "I'll just line-union the lockfile." | A line-union corrupts dependency blocks. Keep whole blocks; regenerate. |
| "No conflicts, so the merge is fine." | No conflict is not the same as landed on trunk. Confirm HEAD is the merge commit and the push advanced origin. |
| "I checked out the branch to review it." | On a shared clone that detaches HEAD and breaks this merge. Review read-only. |

## Red flags

A squashed review merge · a merge-commit message that never says what was deferred · a push reporting "up-to-date" right after a merge · a lockfile resolved by line-union · a review that ran `git checkout` on a shared clone · a branch left live after its task merged.

## Verification

- [ ] Trunk synced to `origin/<trunk>` before the merge.
- [ ] `--no-ff`, not squashed; the branch's atomic task/FR commits survive.
- [ ] Merge-commit message records verdict + what was resolved + what was deferred (guard + blocking task).
- [ ] HEAD is the new merge commit on `<trunk>` (not detached); parents are trunk-tip + branch-tip.
- [ ] Push advanced origin (not "up-to-date").
- [ ] Branch retired; task acceptance ticked + `## Current State` rewritten; Directory version bumped if a contract changed.
