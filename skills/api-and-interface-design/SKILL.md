---
name: api-and-interface-design
description: Use when implementing an interface in code - an MCP tool, HTTP API endpoint, event, webhook, or user-exit - so the implementation matches its Interface Directory entry exactly. Contract-first, MCP/API parity, error semantics, idempotency, boundary validation, and the action gate.
---

# API & Interface Design

Implement a unit's **exposed surface** so the code is a faithful realization of its **Interface Directory entry** — which is the contract SSOT, not a suggestion. The Directory was authored first (in the Define phase); code conforms to it. SSOT: Interface Directory Convention + `references/implementation-stack-and-doc-mapping.md`.

## When to use

- Implementing an MCP tool, API endpoint, event emission/subscription, webhook delivery, or user-exit.
- Adding a service interface that backs an exposed interface.

## Contract-first — the entry is the spec

For each interface, the Directory entry already fixes: the **ID**, **input/output** shape, **error** cases, **idempotency**, **side effects**, the **required action**, the **owning component**, and an **example**. Implement to that. If reality forces a contract change, **change the Directory entry first** (deprecate-don't-delete), then the code — never let code silently diverge from the catalog.

For example, a `catalog.create_item` MCP tool and its `catalog.api.create_item` (`POST /api/v1/catalog/items`) twin both back the `CMP-001` (`catalog.store`) component, write a `catalog_item` row, run the `catalog.item.create` action, and emit `catalog.item.created`.

## Rules

1. **MCP <-> API parity.** A capability exposed as both must behave identically; the entries name each other as equivalents. Share the underlying service-interface method; the two are thin adapters.
2. **Validate at the boundary.** Reject malformed input with the entry's documented error (e.g. API `400`); never trust the caller.
3. **Enforce the action gate** at the boundary — deny below the required access level with the documented error (e.g. `403`), matching the Resources & Grants action.
4. **Idempotency** as documented (e.g. `Idempotency-Key`); non-idempotent creators say so and honor the key.
5. **Error semantics are part of the contract** — implement every documented error case; the example's failure cases are tests.
6. **Events/webhooks:** emit the documented payload; webhook delivery is HMAC-signed + retried with backoff per the entry; the event is canonical, the webhook references it.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "I'll tweak the response shape, it's cleaner." | The Directory entry is the contract. Change it there first, then code. |
| "MCP and API can differ slightly." | Parity is the rule. Same service method behind both. |
| "Validate later." | Boundary validation is the contract's error semantics. Build it now. |
| "Idempotency is overkill here." | The entry says whether it's required. Honor what's documented. |
| "Skip the 403 path." | The action gate + its error is part of the contract. Implement it. |

## Red flags

Code whose shape diverges from its Directory entry · MCP and API behaving differently · missing boundary validation · the action gate not enforced · documented error cases unimplemented · an emitted event whose payload doesn't match the Events Directory.

## Verification

- [ ] Implementation matches the Directory entry (ID, I/O, errors, idempotency, side effects).
- [ ] MCP<->API parity holds; both delegate to one service-interface method.
- [ ] Boundary validation + the documented error cases implemented and tested.
- [ ] Action gate enforced (denies below required access level) per Resources & Grants.
- [ ] Events/webhooks emit the documented payload; delivery semantics honored.
- [ ] Any forced contract change was made in the Directory first (deprecate-don't-delete).
