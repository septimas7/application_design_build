---
name: code-review-and-quality
description: Use to review a change before merge - a five-axis review of a focused diff (~100 lines) that checks correctness, the contract/traceability match against the design docs, tests, security, and clarity. Verifies the code actually implements the FR/component/Directory it claims.
---

# Code Review & Quality

Review a change before it merges. Beyond generic quality, the project-specific job is **verifying the code matches the design docs it claims to implement** — the traceability graph must hold in code, not just on paper. Keep diffs focused (~100 lines); large diffs get split and reviewed in parts.

## When to use

- A task's slices are built and tests pass, before merge/PR.
- Reviewing someone else's (or an agent's) change.

## The five axes

1. **Correctness.** Does it do what the task/FR says? Edge cases, error paths, concurrency. Run the tests; read the diff.
2. **Contract & traceability.** Does the code match its **Directory entry** (I/O, errors, idempotency, MCP/API parity), its **service interface** (Technical Design), its **schema** (Data Dictionary), and its **action gate** (Resources & Grants)? Does every claimed FR/component ID actually appear and behave? For example, does `CMP-001` (`catalog.store`) implement `FR-001` and gate `catalog.item.create` as documented? **No invented contracts.**
3. **Tests.** Do tests encode the **acceptance criteria** (named per FR)? Error + permission-denied cases covered? Pyramid shape sane?
4. **Security.** Boundary validation, the action gate enforced, secrets via the platform secret store (never plaintext), no injection. Escalate to `security-and-hardening` for auth/RBAC-touching changes.
5. **Clarity.** Reads like the surrounding code; names match the docs' IDs; no needless complexity (see `code-simplification`). Comments where the *why* isn't obvious.

## Scope discipline

Review only the change. Note unrelated issues separately; don't expand the diff. A diff that bundles unrelated work gets sent back to be split.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "Tests pass, ship it." | Passing tests do not prove the contract is matched. Check axis 2. |
| "The diff is big but coherent." | More than ~100 lines reviews poorly. Split it. |
| "Looks right." | Run it / read it. Evidence, not impression. |
| "Close enough to the Directory entry." | Divergence from the contract is a blocker. Fix code or the entry. |
| "I'll note these 5 unrelated nits in this PR." | Scope it. File them separately. |

## Red flags

Code that diverges from its Directory/Dictionary contract; a claimed FR not actually implemented; acceptance criteria with no test; action gate or validation missing; secrets in plaintext; a sprawling unfocused diff.

## Verification

- [ ] Correctness checked by running tests + reading the diff.
- [ ] Code matches its Directory entry / interface / schema / action gate; claimed IDs verified.
- [ ] Tests cover the acceptance + error + permission-denied cases.
- [ ] Security axis clear (validation, gating, secret store).
- [ ] Diff is focused; unrelated issues filed separately, not bundled.
