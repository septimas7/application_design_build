---
name: doubt-driven-review
description: Use as a gate on any non-trivial decision that constrains the future - a contract boundary, storage choice, concurrency model, or contentious FR scope. Runs an adversarial CLAIM→EXTRACT→DOUBT→RECONCILE pass; routes the rationale + rejected alternative into the task Notes and doc revision history.
---

# Doubt-Driven Review

A named **adversarial pass** on a design decision, before it hardens into a doc. Confident-sounding decisions are where the worst mistakes hide. Called from `functional-design` and `technical-design` (and `planning-and-tasking` for sequencing calls). This is a gate, not a standalone phase.

## When to use

- A decision **constrains the future**: a contract/interface boundary, a storage or schema-evolution choice, a concurrency/consistency model, a native-vs-connector call, a load-order dependency.
- An FR's scope or acceptance is contentious.

**Skip** for reversible, low-stakes choices (YAGNI — don't ceremony-tax trivial decisions).

## The loop: CLAIM → EXTRACT → DOUBT → RECONCILE

### CLAIM

State the decision as a single explicit claim. ("`catalog_item` stores rows as real database columns + a `fields` overflow column.")

### EXTRACT

Surface the **assumptions** the claim rests on — about the data, the load, the external product, the platform's guarantees, the future. Make each one a checkable statement.

### DOUBT

Attack each assumption as a skeptic would. For each: what would have to be true for this to be wrong? What does the failure look like? Is there evidence (→ call `source-grounding` when the answer depends on an external product/standard's real behavior)? Name the **strongest alternative** and why it might be better.

### RECONCILE

Decide. Either the claim **survives** (record *why*, and the alternative you rejected and *why*), or it's **revised/replaced**. The output is a decision plus its rationale and the road not taken.

## Verifying a fold that changes a contract — look downstream, not just the diff

When you review or verify a design fold that changes a **catalogued contract** (result/wire shape, event name/payload, action, persisted field, endpoint/tool signature), the dangerous failure is a **stale doc that is absent from the changeset** — a Directory or TD that still projects the old shape. It cannot show up in a changed-files review. So the review must explicitly ask: *"For every contract this fold changes, does every Directory/TD that catalogs or projects it — including docs NOT in this fold, and consuming apps' Directories — agree with the new shape? Name any left stale."* Verifying only the changeset's internal consistency misses this every time (the recurring `source_ref` / event-name / persisted-field-vs-API-omission class). Scope the doubt to the contract's whole projection surface, not the diff.

## Where the output goes

- The **rationale + alternative considered** → the driving task's `#### Notes` as a **Decision Record** (**Decision: / Alternatives considered: / Consequence:** lines). The RECONCILE output maps 1:1 onto these three lines.
- A one-line **revision-history row** in the affected doc → points back to that task.
- Technical Design §10 (Risks/trade-offs/alternatives) gets the durable summary.

Do **not** write the deliberation narrative into the design doc itself — the doc states the resulting design; the *why* lives in `tasks.md`.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "I'm confident, no need to doubt it." | Confidence is exactly the trigger. Run the loop. |
| "I can't think of an alternative." | Then you haven't extracted the assumptions. Try harder before committing. |
| "The rationale is obvious." | Obvious-now is forgotten-later. Record it in the task. |
| "Doubt every decision." | No — only the ones that constrain the future. Keep it proportionate. |

## Red flags

A constraining decision shipped with no recorded alternative · assumptions never made explicit · "we'll know if it's wrong later" with no failure mode named · deliberation narrative dumped into the design doc instead of `tasks.md`.

## Verification

- [ ] The decision is stated as one explicit claim.
- [ ] Its assumptions were extracted and individually doubted.
- [ ] The strongest alternative was named and weighed (with source-grounding where feasibility was in question).
- [ ] Outcome (survived/revised) + rationale + rejected alternative recorded in the task `#### Notes`.
- [ ] Revision-history row added to the affected doc → task.
