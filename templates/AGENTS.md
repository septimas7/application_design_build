# <Repo> — agent instructions

This repo implements the project's design docs. The design docs are the spec source; this code conforms to them. (Codex reads this `AGENTS.md` for project conventions.)

## Use the skills

The **Design & Build Skills** are installed in `~/.codex/skills/`. Start with `using-design-skills` to route work across Define → Plan → Build → Ship. Build work runs against a planned `task-NNNNN`; design changes go back to the design repo.

## Stack

- Backend: `<language/runtime>` (service contracts/DI, plugin lifecycle). Database: `<db>` (+ a flexible JSON overflow field), migration runner.
- Event bus: `<queue>`. Surface: HTTP API + MCP (parity per the Directories).
- Web client: `<framework>`. Desktop client: `<optional>`.
- Secrets via the platform secret store — never plaintext.

## Where the design docs live

- Conventions (SSOT for the docs): `<path to Conventions>`
- Per-unit Functional / Technical / Directories / UI + `tasks.md`: `<path to design docs>`
- Doc → code mapping: the installed `references/implementation-stack-and-doc-mapping.md`.

## Standing rules (context-engineering)

- **Load only what the task touches** — the Technical Design `README` catalog + the one component/Directory entry, not whole subsystems. Navigate by stable ID.
- **Read the contract, not the source** — the Directory entry (with its example) is the interface.
- Implement to the specified contracts (service interface / Directory entry / Data Dictionary schema / action gate). Don't invent contracts; a gap means update the design docs first.

## Operating cadence (autonomous runs)

- **Pushes are checkpoints, not review requests.** Keep working; `main` stays untouched until the owner merges. This is a standing instruction — never re-acknowledge it after a context compaction.
- A **review chunk** = a completed unit wave or ~10K changed lines, whichever comes first: push it, hand it off, continue on the next unit. **A checkpoint-task close is always a review boundary**: push, flag, re-cut a fresh branch named for the next wave, continue there. Don't cross-merge in-flight feature branches. Open the draft PR at branch creation.
- **Certification tasks**: if the gated set is mostly unbuilt, present build-vs-report options + proposed checkpoints to the owner before launching a campaign — scope escalation is the owner's call.
- **Blocked by a missing contract?** Record the design question (Open Questions + task Notes), leave the acceptance box unchecked, take the next unblocked slice. Never fabricate a contract or fake an integration.
- **Gates** (`running-quality-gates`): tee output + exit code to a file and read it on resume — never rerun a gate for a lost exit code; run gates in the background with zero progress narration; scope reruns by change class (docs → doc-lint; test-only → affected suite; full dual-gate at chunk close only); single-flight.
- **A standing instruction given mid-run**: acknowledge once, write it into this file immediately, follow it from there — chat is not durable storage; never re-acknowledge after compaction.
- **After a context compaction**: re-read this file + `ENVIRONMENT.md` + the active task's `## Current State`, verify working-tree state, then continue.

## Environment ledger

`ENVIRONMENT.md` in this repo records environment gotchas (**fact / symptom / rule**), shared by every agent on every machine. Structure: `## Universal` + one `## Machine: <name>` section per machine (same identifiers as the task logs' `machine:` field). Stamp entries `(<agent> @ <machine>, date)`; append at the end of the right section; pull before appending, push promptly. Re-read `## Universal` + your machine's section on every resume. Append whenever a root cause is environmental or >10 minutes go to tooling instead of the task (`environment-discipline`). An entry hit twice gets promoted: fix the environment, or add a CI/harness guard.

## Run journal

Every long run ends by exporting an **append-only journal**: `Journals/YYYY-MM-DD-<agent>-<machine>-<slug>.md` in the design repo (`run-journaling` skill). No mid-run journaling — toward the end of the run, write the whole record once **from the session's stored chat history** (not from working memory; mark any genuinely irretrievable pre-compaction stretch as a gap, never reconstruct it from impression): per significant step, what was attempted, which tools were used, and what the result was — failures and dead ends included — plus **every user input verbatim**, marked (`> USER:`). Close with five lines: shipped / blocked / surprised / learned / what the next run should know — then a **"Decisions needed from you"** list reproducing verbatim every question parked during the run (or "none"). One file per run, so concurrent agents never collide. These journals feed the process audits that harden the skills and this file — the dead ends, rework, and user interventions are the valuable part; never clean them up.

## Commit / test conventions

- `<backend test runner>` + `<web client test runner>`; tests encode FR/acceptance and are named for their `FR-###`.
- Atomic commits, one vertical slice each, citing `task-NNNNN` (+ FRs).
- On close: tick the task's `#### Acceptance`, fill `#### Result`, rewrite `## Current State`.
