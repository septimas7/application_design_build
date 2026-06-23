---
name: debugging-and-error-recovery
description: Use on any bug, test failure, or unexpected behavior - a five-step triage (reproduce, localize, reduce, fix, guard) that uses the Log Dictionary / app-log / audit-log to localize and writes a guard test before fixing. Find the root cause, never patch the symptom.
---

# Debugging & Error Recovery

A disciplined triage for any bug, failure, or surprise. **Root cause, not symptom.** The project gives you a strong localization tool — the structured logs — use it.

## When to use

- A test fails, behavior is wrong, or something is unexpected — **before** proposing a fix.

## The five steps

1. **Reproduce.** Get a reliable, minimal repro. Write it as a **failing test** (this becomes the guard). No repro means keep gathering evidence; don't guess-fix.
2. **Localize.** Narrow to the responsible component. Use the **structured logs** — the **Log Dictionary** names per-component sources; the **app-log** (queryable, with per-component levels) and the **audit-log** show what happened. Bisect by component boundary, not by hunch.
3. **Reduce.** Strip the repro to the smallest input/path that still fails. Often this alone reveals the cause.
4. **Fix the root cause.** Change the thing that is actually wrong — not a downstream symptom. If the bug means a contract was wrong, fix the **Directory entry / Data Dictionary** too, not just the code.
5. **Guard.** Keep the reproduction test green as a regression guard. If the class of bug is broad, add a guard at the boundary (validation, an assertion, an invariant).

## Use the system's own observability

- **Logs** localize the failure (Log Dictionary + app-log).
- **Audit log** shows who/what changed state.
- **Events Directory** traces an event's path to its subscribers.
- If the logs *can't* localize it, that's an `observability-and-instrumentation` gap — note it.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "I see the likely fix, just apply it." | Without a repro you're guessing. Reproduce first. |
| "Wrap it in a try/catch and move on." | That hides the symptom. Find the root cause. |
| "No need for a test, it's obvious." | The repro test is the regression guard. Keep it. |
| "Read all the code to find it." | Localize with the logs first; then read the one component. |
| "Just fix the code." | If the contract was wrong, fix the Directory/Dictionary too. |

## Red flags

A fix with no reproduction; a symptom patched (try/catch, retry) with the cause unknown; "fixed" with no guard test; localized by reading everything instead of using the logs; a contract bug fixed only in code.

## Verification

- [ ] A minimal reproduction existed as a failing test before the fix.
- [ ] The responsible component was localized via the logs/audit, not guesswork.
- [ ] The root cause was fixed (incl. the contract doc if the contract was wrong).
- [ ] The reproduction test now passes and stays as a guard.
- [ ] Any observability gap that hindered localization is noted for follow-up.
