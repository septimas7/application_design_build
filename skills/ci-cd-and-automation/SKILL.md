---
name: ci-cd-and-automation
description: Use when setting up or changing CI/CD - shift-left quality gates that run the test pyramid, contract checks against the Directories, lint, and security checks on every change, plus feature flags for safe rollout. The pipeline enforces the acceptance the design docs specify.
---

# CI/CD & Automation

Automate the quality gates so they run on **every** change, not at the end. **Shift left** — the earlier a problem is caught, the cheaper it is.

## When to use

- Standing up or changing a repo's pipeline.
- Adding a gate (a new check, a contract test, a security scan).

## The pipeline (quality gates, in order)

1. **Build** — backend + web client build. Fail fast.
2. **Test pyramid** — the backend test runner (unit + integration against a test database and the event bus) + web client unit/component tests; a thin E2E lane for critical journeys.
3. **Contract checks** — verify the implementation still matches the **Directory entries** (the entry examples run as fixtures; interface parity asserted across surfaces). A drift from the catalog fails CI.
4. **Lint / format / types** — backend lint + format, the web client's linter + type checks. **Doc-lint covers the coordination files too**: task-log yaml⇄prose coherence (status ⇔ closed date ⇔ acceptance boxes), markdown table structure, and citation resolution (every cited test id resolves to a real `fn`, with a planned-marker exemption). Hand-edited registers corrupt at agent speed; lint is their only schema until a validated store replaces them.
5. **Security** — a dependency audit, secret-scan (no plaintext credentials), basic SAST. Escalate auth/RBAC changes to `security-and-hardening`.
6. **Gate the merge** — all green or no merge.
7. **Pin cross-repo baselines.** When a gate checks out a second repo (design docs, shared fixtures), the branch declares *which ref* it verifies against (its paired branch/SHA) — never implicitly that repo's `main`. Otherwise unrelated drift in the other repo reds your build, burns an investigation cycle, and trains everyone to ignore CI.

## Feature flags for safe rollout

- New capability behind a flag; ship dark, enable progressively.
- Flags are config (→ Config Dictionary, with default/scope); resolution user → global → default.
- Remove the flag once the capability is fully rolled out (it's then dead config → `deprecation-and-migration`).

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "Run the full suite only nightly." | Shift left — gate every change. Nightly catches it too late. |
| "Contract tests are overkill." | Drift from the Directories is exactly what breaks consumers. Assert it. |
| "Skip the security scan this time." | Secret/dep scans are cheap and catch real issues. Keep them. |
| "Ship the feature on, fix forward." | Flag it; roll out progressively; revert is a flag flip. |

## Red flags

Gates that don't run on every change, no contract/parity check against the Directories, secrets able to reach a build artifact, a feature shipped on with no flag/rollback, a merge allowed with a red gate.

## Verification

- [ ] Build + full test pyramid + contract checks + lint/types + security run on every change.
- [ ] Directory-contract drift (including cross-surface interface parity) fails CI.
- [ ] No plaintext secret can enter an artifact.
- [ ] New capability is flag-gated; flags are catalogued config.
- [ ] Merge is blocked unless all gates are green.
