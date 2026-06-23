---
name: shipping-and-launch
description: Use when releasing a capability - a pre-launch checklist that confirms acceptance, tests, security, observability, and migrations are in place, then a staged rollout behind flags with a rollback plan, closing the loop in tasks.md.
---

# Shipping & Launch

Release a capability with confidence: confirm it's actually ready, roll it out in stages, and keep a way back. The acceptance criteria the design phase wrote are the launch gate.

## When to use

- A capability (one or more tasks) is built, reviewed, and ready to release.

## Pre-launch checklist

- [ ] **Acceptance met** — every task's `#### Acceptance` is satisfied with evidence.
- [ ] **Tests green** — full pyramid + contract/parity checks pass in CI.
- [ ] **Reviewed** — `code-review-and-quality` done; security axis clear (`security-and-hardening` for auth/RBAC).
- [ ] **Observability in place** — log sources registered, RED metrics + tracing on the new surfaces (`observability-and-instrumentation`), so you can *see* the launch.
- [ ] **Migrations ready** — forward-safe, run via the migration runner, tested on a copy (`deprecation-and-migration`).
- [ ] **Flagged** — behind a feature flag for progressive enable.
- [ ] **Docs current** — Directories/Dictionaries reflect what shipped; revision-history rows point to the tasks.

## Staged rollout

1. **Ship dark** (flag off) → smoke-test in the real environment.
2. **Progressive enable** — internal/owner first, then widen; watch the RED metrics + logs at each step.
3. **Hold the gate** — if error rate/latency breaches budget, stop and roll back.

## Rollback plan (define before you launch)

- **Flag flip** is the first-line revert (instant, no deploy).
- A deploy rollback path exists; migrations are reversible or have a documented recovery.
- Know the signal that triggers rollback (the metric + threshold).

## Close the loop (tasks.md)

- Mark the tasks `completed`, fill `#### Result` (what shipped + where), bump `last_updated`.
- **Rewrite `## Current State`** — what launched, rollout status, what's next.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "Tests pass, just ship it on." | Run the full checklist; roll out staged behind a flag. |
| "We'll add monitoring after launch." | You launch blind without it. Observability before rollout. |
| "Rollback? It'll be fine." | Define the rollback + its trigger *before* launching. |
| "I'll update tasks.md tomorrow." | Close the loop now — Result + Current State. |

## Red flags

Launch with unmet acceptance, no observability on the new surface, no rollback plan/trigger, a full-on enable with no staging, `tasks.md` not closed out.

## Verification

- [ ] Pre-launch checklist fully satisfied with evidence.
- [ ] Rolled out staged behind a flag; metrics/logs watched at each step.
- [ ] Rollback path + trigger defined and tested (flag flip first-line).
- [ ] Tasks closed: `#### Result` filled, `## Current State` rewritten, `last_updated` bumped.
