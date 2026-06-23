---
name: security-and-hardening
description: Use when a change touches auth, RBAC, secrets, input boundaries, or external integrations - enforcing the three-dimension RBAC model, credentials-via-secret-store, OWASP-style boundary defenses, and the action gates from the Resources & Grants Dictionary. Security is part of the contract.
---

# Security & Hardening

Harden a change against the OWASP-style failure modes, enforcing the security model that the design docs already specify. Security here is not bolted on — it's the **action gates, RBAC, and secret handling the docs mandate**, realized in code.

## When to use

- A change touches authentication, RBAC/authorization, secrets/credentials, input boundaries, or a connector's external integration.
- Reviewing such a change (escalated from `code-review-and-quality`).

## The security model (enforce in code)

1. **Three-dimension RBAC.** Every gated operation checks **functional area × access-level ladder (`none/viewer/editor/admin`) + the action**. The required action comes from the **Resources & Grants Dictionary** (for example, `catalog.item.create`) — deny below the minimum access level, with the documented error.
2. **Action gates at every boundary.** API, MCP, events-subscription, UI visibility — all gate on the same action ID. No ungated mutating path.
3. **Secrets via the platform secret store — never plaintext.** Connector credentials, API keys, tokens: stored/retrieved through the platform secret store, referenced by handle. Never in config files, logs, code, or a Config Dictionary value.
4. **Identity** flows from the Platform unit's identity service; don't reimplement sessions/auth in a plugin.

## OWASP-style boundary defenses

- **Validate + sanitize all input** at the boundary (the Directory's error semantics).
- **Parameterized queries only** — never string-built SQL (esp. against generated DDL).
- **AuthZ on every request**, server-side; never trust the client's claim of access level.
- **No secret leakage** into logs/audit/error messages.
- **Least privilege** for connectors — request only the external scopes needed.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "Gate it at the UI." | UI gating is cosmetic. Enforce server-side on every boundary. |
| "Store the API key in config for now." | Secrets go through the secret store, always. Never plaintext. |
| "I'll validate the obvious fields." | Validate all boundary input per the contract. |
| "Build the SQL string, it's simpler." | Parameterized queries only. No injection surface. |
| "This connector can use broad scopes." | Least privilege. Request only what's needed. |

## Red flags

A mutating path with no action gate; client-trusted authorization; a secret in config/logs/code; string-built SQL; a connector over-scoped; access-level checks that ignore the functional area.

## Verification

- [ ] Every gated op checks functional area × access level + the Resources & Grants action, server-side.
- [ ] No ungated mutating boundary (API/MCP/events/UI consistent).
- [ ] All credentials via the secret store; zero plaintext secrets (incl. logs).
- [ ] Boundary input validated; queries parameterized.
- [ ] Connectors least-privileged; identity via the Platform unit, not reimplemented.
