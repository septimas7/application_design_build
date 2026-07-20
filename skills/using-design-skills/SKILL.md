---
name: using-design-skills
description: Use when starting any design, planning, or build work - routes the task to the right skill across the Define→Plan→Build→Ship lifecycle and sets the operating principles, doc contracts (frontmatter, ID/cross-link graph, markdown discipline), and design-doc→code mapping every contributor follows.
---

# Using the Design & Build Skills

This is the entry point for design and build work across the whole lifecycle — **Define → Plan → Build → Ship**. Before acting, identify which skill applies, announce it, and follow it. Multiple skills usually apply in sequence.

The project's **`Conventions/`** are the single source of truth for the *design docs*; the **design docs** are then the source of truth for the *code*. These skills operationalize that chain — they never override it. If a skill and a Convention disagree, **the Convention wins**; fix the skill. If code and a Directory entry disagree, **the Directory wins** (change the entry first, then the code).

## Routing map

| The work in front of you | Skill |
|---|---|
| Start a brand-new project (scaffold the doc structure) | `project-init` |
| Requirements unclear; assumptions unverified | `interview-requirements` |
| Rough concept, not yet a concrete unit | `idea-refine` |
| Author/extend a unit's *what* (FRs, capabilities) | `functional-design` |
| Author/extend a unit's *how* (components, contracts) | `technical-design` |
| Review the UI page-by-page; surface the entities it entails; make mockups | `ui-design` |
| Formalize the surfaced data/permission/config/log catalogs + interface surface | `directories-and-dictionaries` |
| Turn firmed-up design into buildable tasks | `planning-and-tasking` |
| A non-trivial design decision needs adversarial testing | `doubt-driven-review` (gate) |
| A tech/framework choice needs grounding | `source-grounding` (gate) |

A typical new unit flows: `interview-requirements` → `idea-refine` → `functional-design` → `technical-design` → `ui-design` → `directories-and-dictionaries`, with `planning-and-tasking` running alongside and the two gates called as needed. UI comes **before** the Directories on purpose: designing each page surfaces the data, actions, and interfaces the unit needs, which `directories-and-dictionaries` then formalizes as canonical entries. A small change touches one skill.

## Build → Ship routing

Once a `task-NNNNN` is planned, implementation runs against the design docs as the spec source. SSOT for the stack + how each doc maps to code: `references/implementation-stack-and-doc-mapping.md`.

| The work in front of you | Skill |
|---|---|
| Build a planned task into code, slice by slice | `incremental-implementation` |
| Write tests that encode the FR/acceptance first | `test-driven-development` |
| Decide what the agent loads; keep the working set small | `context-engineering` |
| Implement a web client / portal page from its UI requirements | `frontend-ui-engineering` |
| Implement an MCP tool / API / event to match its Directory entry | `api-and-interface-design` |
| Verify a portal page at runtime | `browser-testing-with-devtools` |
| A bug, test failure, or unexpected behavior | `debugging-and-error-recovery` |
| Review a change before merge | `code-review-and-quality` |
| Reduce complexity without changing behavior | `code-simplification` |
| A change touches auth/RBAC/secrets/boundaries | `security-and-hardening` |
| A path is measurably slow | `performance-optimization` |
| Commit, branch, or version an interface | `git-workflow-and-versioning` |
| Set up or change the pipeline / quality gates | `ci-cd-and-automation` |
| Retire or migrate an interface, schema, or data | `deprecation-and-migration` |
| Add logging / metrics / tracing | `observability-and-instrumentation` |
| Workspace/tooling friction; an environmental root cause; a new worktree or long autonomous run | `environment-discipline` |
| Release a capability | `shipping-and-launch` |

A typical task flows: `incremental-implementation` (calling `test-driven-development`, `api-and-interface-design`, `frontend-ui-engineering` as needed) → `code-review-and-quality` → `git-workflow-and-versioning` → `shipping-and-launch`, with `debugging-and-error-recovery`, `code-simplification`, `security-and-hardening`, and `performance-optimization` as called for. The operating principles and the "verify with evidence" rule below apply identically to build work.

## Operating principles (non-negotiable)

1. **Surface assumptions.** Before authoring, state what you're assuming about scope, technology, and constraints. The most common failure is running with a wrong assumption unchecked. List them; get them confirmed or corrected.
2. **Manage confusion actively.** When the Conventions, the docs, or the user's intent are inconsistent, **stop and clarify** — never paper over it with a guess.
3. **Push back when warranted.** Raise technical concerns directly, with concrete impact (which FR/component/decision, and what breaks). No vague hedging, no performative agreement.
4. **Enforce simplicity.** Question every new abstraction, doc, and ID. YAGNI: do not specify behavior, promote a file, or mint an ID the unit does not need yet. Record "maybe later" under Open Questions / Non-goals.
5. **Hold scope.** Edit only the doc the task is about. No drive-by rewrites of neighbouring docs; if you spot an unrelated problem, note it as an Open Question or a task, don't fix it inline.
6. **Verify before "done."** A doc is complete only when it passes its Convention's anatomy **and** the markdown-discipline checklist **and** its cross-link graph has no dangling references — not when it "looks right."

## The three contracts every doc obeys

Every authoring skill ends by checking these. They are reproduced in `references/` so you don't need the full repo loaded:

- **Frontmatter** → `references/frontmatter-schema.md`
- **IDs + cross-link graph** → `references/stable-id-and-cross-link-graph.md`
- **Markdown & diagram discipline** → `references/markdown-and-diagram-discipline.md`

Build skills add a fourth: the **stack + design-doc→code mapping** → `references/implementation-stack-and-doc-mapping.md` (code conforms to the Directories; the traceability graph survives into git history and tests).

## Red flags — stop and re-route

| Thought | Reality |
|---|---|
| "I'll just start writing the FRs." | Did you run `interview-requirements`? Unverified assumptions cause rework. |
| "I'll put the schema in the Technical Design." | Schemas live in the Data Dictionary. Reference, don't duplicate. |
| "This decision is obviously right." | Non-trivial + constrains the future = run `doubt-driven-review`. |
| "I'll note the rationale in the doc." | The *why* lives in `tasks.md`; the doc gets a revision-history row pointing to the task. |
| "I'll add a global index of all tools." | There is no hand-maintained roll-up. SSOT per unit; the documentation generator aggregates. |
| "Mockup shows X, so X is the spec." | Text is authoritative; mockups illustrate. |
