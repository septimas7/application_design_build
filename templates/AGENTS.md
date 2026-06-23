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

## Commit / test conventions

- `<backend test runner>` + `<web client test runner>`; tests encode FR/acceptance and are named for their `FR-###`.
- Atomic commits, one vertical slice each, citing `task-NNNNN` (+ FRs).
- On close: tick the task's `#### Acceptance`, fill `#### Result`, rewrite `## Current State`.
