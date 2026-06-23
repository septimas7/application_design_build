---
name: context-engineering
description: Use when setting up or optimizing what an agent loads to work on the project's code - exploiting the design docs (promote-to-folder indexes, stable IDs, machine-readable Directories) to keep the working set small, plus rules files per repo. The token-efficiency skill.
---

# Context Engineering

Optimize *what information reaches the agent* so it works from the smallest correct context. The project's design docs were built for this — this skill makes the Build agents actually exploit it. SSOT for the mapping: `references/implementation-stack-and-doc-mapping.md`.

## When to use

- Before a build session: deciding what to load.
- Standing up a repo's rules file (CLAUDE.md / AGENTS.md).
- When an agent is over-reading (loading whole subsystems) or under-reading (missing the contract).

## Principles

1. **Load the small index, open only the one part.** The Technical Design `README` is a catalog; open the one `Components/<component>.md` the task names. Same for a promoted Directory (group index -> one group). Never load a whole unit to change one component.
2. **Navigate by stable ID, not by grep.** An FR/component/tool/table ID points at exactly one entry. Resolve the ID; read that entry.
3. **Read the contract, not the source.** The Directories are machine-readable with mandatory examples — to learn an interface, read its entry, not the implementation.
4. **Right-size the task first.** If a task needs more than ~5 files of context, it's too big — send it back to `planning-and-tasking` to slice.
5. **Rules files carry the standing context.** Per repo, a CLAUDE.md states: the stack, where the design docs live, the doc->code mapping, the commit/test conventions, and "load only what the task touches." Keep it short — it's loaded every session.

## What to put in a repo's rules file

- Pointer to the project's design repo + the doc->code mapping.
- The stack + build/test commands (the backend test runner, the web client's test runner).
- Commit convention (cite `task-NNNNN`), branch model (`git-workflow-and-versioning`).
- The token discipline above, as standing instruction.
- Links to the Define->Plan skills (so design changes route correctly).

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "Load the whole unit so I have context." | That's how you blow the window. Load the index + the one part. |
| "Grep the codebase to find the interface." | The Directory entry is the interface. Read it by ID. |
| "Put everything in CLAUDE.md to be safe." | It loads every session. Keep it lean; link out for detail. |
| "This big task is fine, I'll just load a lot." | Big context = big task. Slice it first. |

## Red flags

An agent loading whole subsystems for a one-component change · grepping for contracts the Directories already define · a bloated rules file · a task whose context exceeds ~5 files with no push-back to re-slice.

## Verification

- [ ] The session loaded only the artifacts the task references (index + named parts).
- [ ] Contracts were read from Directory entries by ID, not reverse-engineered from source.
- [ ] The repo has a lean rules file pointing at the design docs + doc->code mapping.
- [ ] Oversized tasks were sent back to be sliced rather than loaded wholesale.
