---
name: idea-refine
description: Use when a rough concept needs shaping into a concrete unit proposal before committing to a Functional Spec. Applies divergent-then-convergent thinking and lands on which unit it is, its type and place in the accretion stack, and the open questions to resolve.
---

# Idea Refine

Take a rough idea and shape it — through deliberate **divergent then convergent** thinking — into a concrete proposal that fits the project's **unit** model. This sits between a raw thought and `interview-requirements`/`functional-design`: it decides *what unit we're even talking about*.

## When to use

- A capability or product idea is still fuzzy ("we should have something for X").
- Deciding whether something is a new Application, a Platform capability, or part of an existing unit.
- Choosing between framings before committing to a spec.

**Skip** when the unit and its shape are already obvious.

## Process

### 1. Diverge — widen the option space

Generate multiple framings before judging any. For the idea, sketch:

- **Which unit?** A new Application, a Platform (cross-cutting) capability, or an extension of an existing unit.
- **`type` options** (if an Application): native, connector (bridge an existing self-hosted product), or hybrid — and what each would mean.
- **Build-vs-bridge** — is there an external product the project should connect to (connector hub) rather than build?
- **Accretion-stack placement** — what it would depend on and what could depend on it.

Don't converge yet. List the credible alternatives.

### 2. Converge — pick the framing

Choose the framing that best fits the backbone vision (capability accretes in layers; capability is exposed for others to consume). Justify the choice against the alternatives in a sentence each. Prefer the option that **reuses existing units** and minimizes new surface (YAGNI).

### 3. Emit the unit proposal

A short note that seeds the unit and feeds `interview-requirements` / `functional-design`:

- **Unit:** new Application `<name>` / Platform capability / extension of `<unit>`.
- **`type`:** native | connector | hybrid (+ the external product, if any).
- **Place in the accretion stack:** `depends_on` (units/capabilities) and likely consumers.
- **Capabilities (one-liner):** what it will expose and consume, at a glance.
- **Why this framing** (vs the alternatives diverged in step 1).
- **Open questions** → seed `## Open Questions` in the relevant `tasks.md`.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "First idea is good enough." | You haven't seen the alternatives yet. Diverge before converging. |
| "Build it natively, obviously." | The project is a connector hub. Always weigh bridge-vs-build. |
| "It's clearly a new app." | It may extend an existing unit. Check reuse first. |
| "Skip the stack placement." | `depends_on` ordering is what keeps the architecture acyclic. State it. |

## Red flags

Committing to one framing without naming alternatives · ignoring a connector option for something already self-hostable · a new unit that duplicates an existing one · no accretion-stack placement.

## Verification

- [ ] At least two framings were considered before converging.
- [ ] Build-vs-bridge (connector) explicitly weighed.
- [ ] `type` and accretion-stack placement stated.
- [ ] Choice justified against the alternatives; reuse preferred.
- [ ] Open questions routed to `tasks.md`.
