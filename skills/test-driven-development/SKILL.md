---
name: test-driven-development
description: Use when implementing logic with a clear contract - write a failing test first (red), make it pass (green), then refactor. Tests encode the FR and task Acceptance criteria; follow the test pyramid across the backend and the web client.
---

# Test-Driven Development

Red -> Green -> Refactor. Write the test **before** the implementation, so the **FR acceptance criteria and the task `#### Acceptance` become executable**. This is how acceptance stops being prose and becomes a gate.

## When to use

- Implementing logic with a definable contract: a service interface method, an API/MCP handler, a schema operation, a non-trivial web client behavior.
- Fixing a bug — write the failing reproduction test first (see `debugging-and-error-recovery`).

**Skip** for pure config/wiring with no logic, or throwaway spikes (delete the spike, then TDD the real thing).

## The cycle

1. **Red** — write one failing test that encodes the next acceptance criterion. Name it after the FR: `fr001_create_item_makes_a_row`. Run it; watch it fail for the right reason.
2. **Green** — the minimum code to pass. No gold-plating.
3. **Refactor** — clean up with the test green; call `code-simplification` if it grew hairy.

One acceptance criterion at a time; never write code with no failing test demanding it.

## The contract comes from the docs

- The **Directory entry's example** is a ready-made fixture — its input->output is a test case; MCP<->API parity means the same case runs against both surfaces.
- The **service interface signature** (Technical Design) is the unit under test.
- The **action gate** (Resources & Grants) gets a test: denied below the required access level.

## Test pyramid (stack-aware)

| Level | Backend | Web client |
|---|---|---|
| Unit (most) | the backend test runner on pure logic / interface impls | component/hook tests (the web client's test runner) |
| Integration | service interface + the database (test DB) / the event bus | page + mocked API |
| E2E (fewest) | API/MCP black-box against a running backend | `browser-testing-with-devtools` |

Lots of fast unit tests; a few integration tests at the seams (DB, queue, RBAC); minimal E2E for the critical journeys.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "I'll add tests after it works." | After-the-fact tests rubber-stamp the implementation. Red first. |
| "The acceptance is obvious, no test needed." | Then it's a one-line test. Write it. |
| "Test the happy path only." | Test the acceptance, the error semantics (Directory), and the permission-denied case. |
| "E2E everything to be safe." | Slow and brittle. Push logic down to unit tests; keep E2E thin. |

## Red flags

Implementation written with no failing test · a test that never failed (asserts nothing) · acceptance criteria with no corresponding test · only happy-path coverage · error/permission cases from the Directory untested.

## Verification

- [ ] Every FR/task acceptance criterion maps to at least one test, named for its FR.
- [ ] Each test was seen to fail (red) before passing (green).
- [ ] Error semantics + permission-denied (per the Directory + Resources & Grants) are tested.
- [ ] Pyramid shape: unit-heavy, integration at the seams, E2E minimal.
- [ ] Suite green; refactors kept it green.
