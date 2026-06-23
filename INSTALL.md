# Installing the Design & Build Skills

These skills use the cross-agent **`SKILL.md`** standard, so the same `skills/` tree installs on both **Claude Code** and **OpenAI Codex**. A skill is a folder with a `SKILL.md` (which has `name` + `description` frontmatter); the shared `references/` folder ships alongside the skills and is cited by name.

## Where skills live

| Platform | Personal (all projects) | Project-local |
|---|---|---|
| **Claude Code** | `~/.claude/skills/` | `<project>/.claude/skills/` |
| **OpenAI Codex** | `~/.codex/skills/` | `<project>/.codex/skills/` |

Each install copies every `skills/<name>/` folder **plus** the `references/` folder into that target directory, so a skill and the references it cites stay siblings.

## Quick install (scripts)

From this folder:

**Windows (PowerShell):**

```powershell
# Claude Code, personal:
./install.ps1 -Platform claude -Scope personal
# Codex, personal:
./install.ps1 -Platform codex -Scope personal
# Project-local (run from, or pass, the target project):
./install.ps1 -Platform claude -Scope project -ProjectPath "C:\path\to\repo"
```

**macOS / Linux / Git Bash:**

```bash
./install.sh claude personal
./install.sh codex personal
./install.sh claude project /path/to/repo
```

Then **restart the agent session** — both platforms load skills at startup.

## Manual install

Copy the folders yourself:

```bash
# example: Codex personal
mkdir -p ~/.codex/skills
cp -R skills/* ~/.codex/skills/
cp -R references ~/.codex/skills/references
# restart Codex
```

Swap `~/.codex/skills` for `~/.claude/skills` (Claude Code) or a project's `.codex/skills` / `.claude/skills`.

## Claude Code — install as a plugin (optional)

This folder is also a valid Claude Code **plugin** (it has `skills/` at the root and a `.claude-plugin/plugin.json`). To use it as a plugin instead of loose skills, add it through a local marketplace that points at this directory, then enable `design-and-build-skills`. The loose-skills method above is simpler and works identically.

## Verify

Start a session and confirm the router loads:

- Ask the agent to "use the using-design-skills router" — it should describe the Define→Plan→Build→Ship routing.
- Trigger a skill by intent, e.g. "break task-00006 into tasks" → `planning-and-tasking`.

## Rules file for your code repo (recommended)

When you start your project's **implementation** repo, drop a rules file at its root so the agent always knows the stack, where the design docs live, and to load only what a task touches:

- Claude Code → copy [`templates/CLAUDE.md`](templates/CLAUDE.md) to the repo root as `CLAUDE.md`.
- Codex → copy [`templates/AGENTS.md`](templates/AGENTS.md) to the repo root as `AGENTS.md`.

Both are the standing-context companion to the `context-engineering` skill.

## Updating

Re-run the installer; it overwrites the installed copies. The canonical source is this folder — edit here, then reinstall.
