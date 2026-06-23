---
name: browser-testing-with-devtools
description: Use to verify a web client / portal page at runtime in a real browser - checking every documented UI state, interactions, console/network health, and performance - via the Chrome DevTools / Playwright MCP. Evidence that the page behaves as its UI Design Requirements specify.
---

# Browser Testing with DevTools

Verify a portal page **in a real browser**, against its `UI Design Requirements.md`. This produces the runtime evidence that closes a frontend task's acceptance. Uses the browser MCP (Chrome DevTools / Playwright) already available.

## When to use

- After a page is built or changed.
- Reproducing a UI bug (pair with `debugging-and-error-recovery`).
- Profiling a slow page (pair with `performance-optimization`).

## Process

1. **Drive each documented state.** For the page, reach and observe every state in the requirements: empty, loading, error, populated, **permission-denied** (sign in at an access level below the gating action and confirm the component hides/denies).
2. **Exercise interactions.** Each action the components document — confirm it calls the right API/MCP entry (check the **network** panel) and updates the UI as specified.
3. **Check console + network health.** No unexpected console errors; failed requests surface the documented error UI, not a blank/crash.
4. **Accessibility spot-check.** Keyboard path through the primary flow; focus visible; labels present.
5. **Capture evidence.** Screenshots/snapshots per state + breakpoint; note them against the task's `#### Acceptance`.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "It renders, so it works." | Render is not correct. Drive every documented state + interaction. |
| "I'll skip the permission-denied state." | It's a required state. Test it at a lower access level. |
| "Console warnings are fine." | Unexpected errors are a finding. Investigate. |
| "Trust the unit tests." | E2E catches integration/render issues units can't. Verify in-browser. |

## Red flags

A state in the requirements never exercised; an action not verified against its network call; console errors ignored; no captured evidence tied to acceptance; permission-denied untested.

## Verification

- [ ] Every documented state reached and observed (incl. permission-denied).
- [ ] Each interaction hits the correct API/MCP entry (network-verified) and updates the UI as specified.
- [ ] No unexpected console errors; failures show the documented error UI.
- [ ] Keyboard/focus spot-check passes.
- [ ] Evidence captured and tied to the task's `#### Acceptance`.
