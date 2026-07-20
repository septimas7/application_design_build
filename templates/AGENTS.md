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
- A **review chunk** = a completed unit wave or ~10K changed lines, whichever comes first: push it, hand it off, continue on the next unit. Don't cross-merge in-flight feature branches. Open the draft PR at branch creation.
- **Blocked by a missing contract?** Record the design question (Open Questions + task Notes), leave the acceptance box unchecked, take the next unblocked slice. Never fabricate a contract or fake an integration.
- **After a context compaction**: re-read this file + `ENVIRONMENT.md` + the active task's `## Current State`, then continue.

## Environment ledger

`ENVIRONMENT.md` in this repo records environment gotchas (**fact / symptom / rule**). Re-read it on every resume. Append an entry whenever a root cause is environmental or >10 minutes go to tooling instead of the task (`environment-discipline` skill). An entry hit twice gets promoted: fix the environment, or add a CI/harness guard.

## Commit / test conventions

- `<backend test runner>` + `<web client test runner>`; tests encode FR/acceptance and are named for their `FR-###`.
- Atomic commits, one vertical slice each, citing `task-NNNNN` (+ FRs).
- On close: tick the task's `#### Acceptance`, fill `#### Result`, rewrite `## Current State`.
