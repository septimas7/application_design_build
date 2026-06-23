---
name: source-grounding
description: Use as a gate when a decision depends on what a framework, library, database, standard, or external product actually supports (especially connectors). Grounds the claim in official docs via a documentation MCP before it's asserted in a Technical Design, and cites the source in the doc and task Notes.
---

# Source Grounding

Ground framework/tech/external-product claims in **official documentation** before they harden into a design. Memory and training data drift; connector behavior especially must be verified, not assumed. A gate called from `technical-design` (and `functional-design` for connector feasibility).

## When to use

- A decision rests on a framework/library/DB **capability or guarantee** (e.g. "the event bus gives at-least-once with visibility timeouts", "the database supports the column type we need").
- A **connector** depends on an external product's **API surface, auth model, or limits**.
- A version migration or a standard's exact semantics matters.

**Skip** for general programming knowledge that isn't version- or product-specific.

## Process

### 1. Name the claim and the source of truth

State what you're about to assert and *whose docs* settle it (the library's official docs, the external product's API reference, the standard).

### 2. Fetch authoritative docs

Use a **documentation MCP** (`query-docs` / `resolve-library-id` — a context7-style server, if connected) for libraries/frameworks. For an external product's API, fetch its official API reference. Prefer official sources over blog posts.

### 3. Verify and capture

Confirm the claim against the docs. Capture: the **verified fact**, the **source** (library + version, or the API doc URL/section), and any **caveat** (version constraints, rate limits, auth scopes).

### 4. Cite

- The **Technical Design** records the grounded fact and cites the source inline.
- For a connector, the verified **API surface / auth / limits** feed its Technical Design *external integrations* section and its **Config Dictionary** (connection + credentials via the Platform secret store).
- The driving task's `#### Notes` records what was checked and where.

If the docs **contradict** the intended design, stop and feed it back into `doubt-driven-review` — the decision needs reconsidering.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "I know this API." | APIs and versions drift. Verify against current docs. |
| "A blog post says it works." | Prefer official docs. Blogs go stale and omit caveats. |
| "Close enough on the version." | Version-specific behavior is exactly what bites. Pin it. |
| "The connector probably supports it." | Probably isn't a spec. Check the product's API reference. |

## Red flags

A capability/guarantee asserted with no cited source · a connector spec'd against an assumed (unverified) API · a version-specific claim with no version · official docs contradicting the design but the design unchanged.

## Verification

- [ ] The claim is grounded in an official source (library+version or API reference URL/section).
- [ ] Caveats (versions, limits, auth scopes) captured.
- [ ] The fact + source cited in the Technical Design (and Config Dictionary for connectors).
- [ ] The task `#### Notes` records what was checked.
- [ ] Any contradiction routed back into doubt-driven-review.
