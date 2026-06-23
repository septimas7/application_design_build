---
name: project-init
description: Use to initialize a new design-documentation project - scaffold the full structure (README, tasks.md, Conventions, Platform skeleton, Applications) at a target directory from the bundled, parameterized templates. Trigger on "start/initialize/scaffold a new project" with a target path.
---

# Project Init

Scaffold a new design-documentation project at a **target directory** the user points to, by deploying the templates bundled with this skill. Output is the empty-but-complete unit structure, ready for the design skills to fill.

Templates live next to this skill:

- `project-template/Conventions/` — the 7 convention guides (the methodology), parameterized with `{{tokens}}`. **Deployed with token substitution.**
- `project-template/_templates/` — `README.template.md`, `tasks.template.md`, and the `Platform/` + `Applications/_app-template/` skeleton stubs. **Deployed with token substitution.**

The bundled `project-template/` is the only template source — author all project content fresh with the design skills.

## When to use

- "Start / initialize / scaffold a new project," or set up the doc structure at a directory.
- Adding a new **Application** to an existing project (see *Adding an application*).

## Inputs (ask first)

| Token | Meaning | Example |
|---|---|---|
| target directory | absolute path to scaffold into | `C:\...\My Project` |
| `{{PROJECT_NAME}}` | display name | `Acme Platform` |
| `{{project-slug}}` | tag/slug (kebab) | `acme-platform` |
| `{{OWNER}}` | accountable owner | `Alex` |
| `{{ONE_LINE_DESCRIPTION}}` | one-line product description | — |
| `{{DATE}}` | today (ISO date) | `2026-06-23` |
| `{{TIMESTAMP}}` | now (ISO + offset) | `2026-06-23T10:00:00-04:00` |
| `{{HOSTNAME}}` | this machine | — |

## Safety first

- **Confirm the target directory** with the user before writing. If it is **non-empty**, stop and confirm — never overwrite existing files. Default to refusing if a `Conventions/` or `README.md` already exists there (looks already-initialized).

## Process

1. **Gather inputs** and build the token map above.
2. **Create the tree** at the target:
   - `Conventions/`, `Platform/Directories/`, `Platform/UI/`, `Applications/`.
3. **Deploy `Conventions/`** from `project-template/Conventions/` → `<target>/Conventions/`, substituting every `{{token}}` (the guides are parameterized — `{{PROJECT_NAME}}`, `{{project-slug}}`, `{{OWNER}}`, `{{DATE}}`, `{{TIMESTAMP}}`). Do not otherwise alter the methodology text.
4. **Instantiate `README.md`** from `_templates/README.template.md`, substituting every `{{token}}`.
5. **Instantiate `tasks.md`** from `_templates/tasks.template.md`, substituting tokens (keep the `task-00000` Example block — it is the reference schema).
6. **Deploy the Platform skeleton** from `_templates/Platform/` → `<target>/Platform/`, substituting tokens in each file: `Functional Design.md`, `Technical Design.md`, the nine `Directories/*.md`, and `UI/.gitkeep`.
7. **Leave `Applications/` empty** (apps are added on demand, not pre-scaffolded — YAGNI).
8. **Report** the created tree and the next step: run `functional-design` on `Platform/Functional Design.md`, then `technical-design` → `ui-design` → `directories-and-dictionaries`; track work in `tasks.md` via `planning-and-tasking`.

After substitution, **no `{{token}}` should remain** in any deployed file.

## Adding an application

To add an Application later:

1. Copy `_templates/Applications/_app-template/` → `<target>/Applications/<app-slug>/`.
2. Substitute `{{app}}` (the slug) and `{{App}}` (display name) plus the shared tokens in every file.
3. Follow the Documentation System Guide §12 order: Functional Spec → Technical Design → **UI → Directories**, with the app's own `tasks.md`.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "I'll scaffold over the existing folder." | Confirm + never overwrite. Refuse if it looks initialized. |
| "I'll tweak the Conventions while copying." | Substitute `{{tokens}}` only; don't otherwise alter the methodology text. Amend conventions as a separate, deliberate task. |
| "Pre-create all the app folders too." | Apps are added on demand. Scaffold Platform only. |
| "Leave the `{{tokens}}` to fill later." | Substitute all tokens now; none should remain. |
| "Copy product content from somewhere else." | Templates are skeletons, not filled examples. Author fresh with the design skills. |

## Red flags

Writing into a non-empty/initialized directory without confirmation · `{{token}}` left in a deployed file · Conventions edited during deploy · pre-filled product content cloned into the new project · Applications pre-scaffolded.

## Verification

- [ ] Target confirmed; nothing pre-existing was overwritten.
- [ ] Tree created: `README.md`, `tasks.md`, `Conventions/` (7 files), `Platform/{Functional Design.md, Technical Design.md, Directories/ (9), UI/}`, empty `Applications/`.
- [ ] Conventions deployed with all `{{tokens}}` substituted; methodology text otherwise unchanged.
- [ ] All `{{tokens}}` substituted across every deployed file; none remain.
- [ ] Frontmatter + markdown discipline hold in the instantiated `README.md` / `tasks.md`.
- [ ] Next-step guidance reported (start with `functional-design`).
