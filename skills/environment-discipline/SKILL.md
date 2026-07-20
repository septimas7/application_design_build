---
name: environment-discipline
description: Use when starting work in any workspace, when a failure's root cause turns out to be environmental rather than product, or when more than ~10 minutes go to tooling/infrastructure instead of the task - maintains a durable ENVIRONMENT.md gotcha ledger per repo, sets workspace hygiene rules (clean clones, no cloud-synced git, bounded build caches, self-cleaning test residue), and promotes recurring gotchas into structural fixes.
---

# Environment Discipline

The task is the product; the environment is overhead. Every minute spent rediscovering an environment fact — a queue-name limit, a test-executor default, a dirty shared checkout — was already paid for by a past session. This skill makes environment knowledge **durable**: learned once, written down, re-read on every resume, and eventually promoted into a fix so it never needs remembering at all.

## When to use

- Starting a session in any workspace (the resume protocol below).
- A debugging pass concludes the root cause was **environmental**, not product or test logic.
- Rework or lost time >~10 minutes caused by tooling, infrastructure, or workspace state.
- Standing up a new worktree/clone/CI lane.

## The ledger: `ENVIRONMENT.md`

Every implementation repo carries an append-friendly `ENVIRONMENT.md` (a section in the rules file is fine while it's small). One compact entry per fact:

- **Fact** — the constraint, stated so a stranger can act on it (e.g. "PGMQ derives queue names capped at 47 chars — keep test subscriber ids short").
- **Symptom** — how it presents when violated, so a search from the error message finds it.
- **Rule** — what to do instead.

Recurring categories: infrastructure limits (name/size/count caps) · runtime defaults that differ between test and production (executor flavor, locale-dependent ordering) · toolchain quirks (linkers, per-worktree `node_modules`/`dist`) · workspace hazards (synced folders, shared checkouts) · external-service behavior (which CI/API errors are retry-worthy noise vs real).

## The hooks — when an entry MUST be written

1. **Root-cause hook.** `debugging-and-error-recovery` classifies a failure as environmental → append the entry before moving on.
2. **Rework hook.** Any rework or >10 minutes lost to the environment — *including time lost rediscovering a fact a past session already hit*. The second discovery of the same fact is a process failure; the entry is the fix.
3. **Workaround hook.** You worked around an environmental obstacle (dirty checkout, missing build artifact, flaky endpoint). The workaround goes in the ledger so the next session applies it in one step instead of re-deriving it.

## Resume protocol

On session start or after a context compaction: **re-read the rules file (AGENTS/CLAUDE.md) and `ENVIRONMENT.md` before the first command.** They are the memory that survives the window. Then read the active task's `## Current State`. Standing instructions live in those files — never re-derive or re-acknowledge them from conversation history.

## Promotion — a ledger entry is a debt, not a home

An entry hit **twice** gets promoted out of prose into mechanism, in order of preference:

1. **Fix the environment** — make the harness/tooling not have the problem (e.g. panic-safe test-DB cleanup guards instead of manual sweeps).
2. **Add a guard** — a CI check, lint rule, or harness assertion that fails fast with the rule in its message.
3. **Encode as a standing rule** in the rules file (the weakest form — still relies on being read).

The ledger should shrink as the environment hardens.

## Workspace hygiene rules (standing)

- **Never operate git inside a cloud-synced folder** (OneDrive/Dropbox/iCloud). Synced `.git` metadata times out mid-commit, syncs HEAD state across machines, and churns line endings. Work in a clean local clone; the synced copy is a read mirror for humans.
- **One shared build cache** per machine; incremental artifacts off for one-shot verification runs; measure (`du`) before cleaning; package-scoped clean over nuking the cache.
- **Test residue is a leak**: isolated test databases/files/temp dirs get panic-safe cleanup guards in the harness, not periodic manual sweeps.
- **CI from the first push**: open the draft PR when the branch is created, so CI history exists the moment you need it.
- **Fresh worktrees are not free**: they lack generated artifacts (`node_modules`, `dist`, warm caches) — provision them as a setup step, not as a surprise mid-verification.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "I'll remember this quirk." | The next session won't. The compaction won't. Write the entry. |
| "It's a one-off flake." | The second hit costs the same as the first. Ledger it on the first. |
| "The workaround is quick." | Quick × every future session = expensive. Ledger it; promote on the second hit. |
| "Fixing the harness is out of scope." | Two hits makes the promotion in scope. A recurring gotcha is a standing tax on every task. |
| "I'll note it in the task log." | Task logs are per-task history; the ledger is cross-task memory. Put it where the next session actually reads. |

## Red flags

The same environmental fact diagnosed twice in one project · a resume that runs commands before re-reading the rules file + ledger · a workaround applied silently for the third time · git operations inside a synced folder · test databases accumulating across runs · an environment fact living only in a compaction summary.

## Verification

- [ ] Every environmental root cause from this session has a ledger entry (fact / symptom / rule).
- [ ] The session began with the resume protocol (rules file + ledger + Current State).
- [ ] Any second-hit entry was promoted (environment fixed, guard added, or rule encoded).
- [ ] No git operations ran in a cloud-synced working tree.
- [ ] Test residue is cleaned by harness guards, not deferred to a future sweep.
