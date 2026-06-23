---
name: interview-requirements
description: Use before authoring a Functional Design or Spec, when requirements are unclear or assumptions are unverified. Drives a structured interview to high confidence and produces a pre-Functional brief (actors, capabilities exposed/consumed, candidate FRs, open questions) that feeds the functional-design skill.
---

# Interview Requirements

Drive out the real requirements **before** writing FRs. The most expensive rework comes from authoring a Functional Design on top of a wrong assumption. This skill replaces the brainstorm-straight-to-FRs jump with a confidence gate.

Output is a **pre-Functional brief**, not the spec itself — it hands off to `functional-design`. SSOT for the destination shape: **Functional Design Convention**.

## When to use

- Starting a new unit (Platform capability or Application) or a material new capability.
- Requirements are vague, conflicting, or assumed.
- You're about to write FRs and can't yet state testable acceptance for them.

**Skip** when the capability is already specified to FR level, or it's a small change to an existing, well-understood FR.

## Process

### 1. State your assumptions first

Before asking anything, write down what you're currently assuming about: the capability, who uses it, what it exposes/consumes, where it sits in the **accretion stack**, and its `type` (native/connector/hybrid) if it's an Application. This makes silent assumptions visible.

### 2. Interview to confidence

Ask targeted questions until you're ~95% confident you could write testable FRs. Cover, at minimum:

- **Purpose** — what problem, for whom, why now.
- **Actors / personas** — humans (web client / desktop client), internal applications, and **external agents / LLM harnesses** as first-class consumers.
- **Capabilities exposed** — what other apps/agents/harnesses will consume from this unit.
- **Capabilities consumed** — what it depends on (its `depends_on` / place in the stack).
- **Boundaries** — what it must always do, what needs approval, what it must never do; explicit **non-goals**.
- **Rules & states** — lifecycle of the unit's key entities, business rules.
- **`type`** (Applications) — native, connector (which external product? auth? sync?), or hybrid.

Ask one cluster at a time. When the user's answer contradicts an earlier one, surface it and reconcile — don't average.

### 3. Confidence check

Explicitly rate confidence. If below ~95% on any FR-shaped area, keep asking. Name what's still uncertain.

### 4. Emit the pre-Functional brief

A short structured note (lands in the unit's `tasks.md` Context or a scratch section):

- **Assumptions (confirmed/corrected)**
- **Actors / personas**
- **Capabilities — exposed & consumed**
- **Candidate FRs** — one capability each, with a draft testable acceptance.
- **Boundaries & non-goals**
- **Open questions** — anything still unresolved → seed `## Open Questions` in `tasks.md`.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "I get the gist, I'll start writing FRs." | The gist hides the wrong assumption. Interview first. |
| "Asking lots of questions is annoying." | Cheaper than rewriting a Functional Design. Cluster them and ask. |
| "They didn't mention external agents, so ignore them." | External agents / LLM harnesses are first-class consumers. Ask explicitly. |
| "I'll figure out the type later." | `type` changes the connector specifics. Settle it now. |

## Red flags

Writing an FR you can't state acceptance for · no non-goals captured · external-agent persona never considered · contradictions between answers left unreconciled · confidence never explicitly checked.

## Verification

- [ ] Assumptions written and confirmed/corrected.
- [ ] Actors include internal applications **and** external agents / LLM harnesses where relevant.
- [ ] Each candidate FR is one capability with a draft testable acceptance.
- [ ] Boundaries + non-goals captured; open questions routed to `tasks.md`.
- [ ] Confidence explicitly ≥ ~95%, or the gaps are named.
