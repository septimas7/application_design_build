---
doc_type: task-log
unit: platform
title: {{PROJECT_NAME}} — Platform & Program Task Log
status: active
owner: {{OWNER}}
created: {{DATE}}
last_updated: {{TIMESTAMP}}
machines:
  - {{HOSTNAME}}
related:
  - "README.md"
  - "Conventions/Task Log Convention.md"
tags:
  - {{project-slug}}
  - task-log
  - platform
---

# Task Log: {{PROJECT_NAME}} — Platform & Program

## Project Summary

{{2-5 sentence overview of the project: what it is, who it serves, the build approach. Rewrite when scope materially changes.}}

## Current State

- **{{DATE}} — Project initialized:** Documentation system scaffolded (README + Conventions + Platform skeleton). **Next:** author the Platform Functional Design (the product spec), then Technical Design → UI → Directories, then the first Application.

## Open Questions

- {{unresolved decisions awaiting the owner}}

## Tasks

### task-00001: Author the Platform Functional Design

```yaml
status: planned
priority: P0
created: {{TIMESTAMP}}
closed:
estimated: 3d
agent: unassigned
machine:
depends_on: []
blocks: []
references:           # fill in as FRs/components/UI are authored (omit keys that don't apply)
  implements: []
  ui: []
artifacts:
  - "Platform/Functional Design.md"
tags: ["#area/platform", "#functional-design"]
```

#### Objective
Write the Platform Functional Design — the product spec: vision, the Platform's functional capabilities, the plugin/application set, and the functional requirements.

#### Context
Use the `functional-design` skill. Follows the Functional Design Convention.

#### Subtasks
- [ ] Overview + capabilities exposed & consumed.
- [ ] Actors / personas (incl. external agents / LLM harnesses).
- [ ] Functional Requirements (FR-###) with testable acceptance.

#### Acceptance
- [ ] The doc follows the Functional Design Convention §3 anatomy.
- [ ] Every FR has a testable `Acceptance` list.
- [ ] The capabilities-exposed/consumed framing is present.

#### Notes
Acceptance per the Functional Design Convention. Add a **Decision Record** here for any decision that constrains the future.

#### Result
_Not started._

## Example

### task-00000: (reference) Add a worker-pool size config key to the job runtime

```yaml
status: completed
priority: P2
created: 2026-06-20T09:00:00-04:00
closed: 2026-06-20T15:30:00-04:00
estimated: 4h
agent: claude-code
machine: {{HOSTNAME}}
depends_on: []
blocks: []
references:
  implements: [NFR-003]
  components: [CMP-009]
  actions: [platform.config.edit]
artifacts:
  - "Platform/Directories/Config Dictionary.md"
  - "Platform/Technical Design.md"
tags: ["#area/platform", "#config"]
```

#### Objective
Expose the per-queue worker-pool maximum as a configurable setting so operators can cap concurrency without a rebuild.

#### Context
Reference example for the task schema — do not edit or delete. Shows the yaml `references` map, the `#### Acceptance` section, and an optional Decision Record.

#### Subtasks
- [x] Add the config key to the Config Dictionary (scope: global; default 8).
- [x] Document the job-runtime component reading it (Technical Design).
- [x] Gate edits behind `platform.config.edit`.

#### Acceptance
- [x] The key is catalogued with a default + range.
- [x] Edits are gated by `platform.config.edit`.
- [x] The job-runtime component documents reading it at pool-resize time.

#### Notes
- **Decision:** Make the worker ceiling a global config key (not per-user).
- **Alternatives considered:** Per-user override — rejected: concurrency is an operator/instance concern, not a user preference. Hardcoded constant — rejected: requires a rebuild to tune.
- **Consequence:** No per-user tuning; if multi-tenant isolation is ever needed, an `instance` scope tier would be added.

#### Result
Added `platform.config.max_workers_per_queue` (global, default 8, range 1–64) to the Config Dictionary; the job-runtime component now documents reading it at pool-resize time. Edits gated by `platform.config.edit`.
