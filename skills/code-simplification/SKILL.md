---
name: code-simplification
description: Use to reduce complexity in a change without altering behavior - applying Chesterton's Fence before removing anything, carrying reference-don't-duplicate into code, and keeping the implementation aligned with one canonical contract. Quality only, never a behavior change.
---

# Code Simplification

Make the code simpler and clearer **without changing what it does**. Reduce complexity, but respect **Chesterton's Fence**: understand why something is there before removing it.

## When to use

- After Green in TDD (the refactor step), or after a change works but reads poorly.
- A code-review (`code-review-and-quality`) flagged needless complexity.

**Not** a behavior change — if behavior must change, that's a task, not a simplification.

## Principles

1. **Chesterton's Fence.** Before deleting code/a branch/an abstraction, find out why it exists. Logs, the owning component's design, the driving task. If you can't explain why it's there, don't remove it yet.
2. **Reference-don't-duplicate, in code.** Two copies of a contract/logic — collapse to one canonical implementation behind the service interface. Mirrors the docs' SSOT rule.
3. **Match the docs' vocabulary.** Names should track the FR/component/entry IDs — a reader maps code-to-docs without translation.
4. **Delete dead code.** Unreferenced paths, stale flags, commented-out blocks — remove (deprecate-don't-delete applies to *published contracts*, not internal dead code).
5. **Lower the complexity, not the clarity.** Fewer branches, shallower nesting, smaller functions — but never a clever one-liner that hides intent.

## Behavior-preservation is non-negotiable

Tests stay green throughout. If you can't prove behavior is unchanged (tests, types), stop — you're making a change, not a simplification.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "This looks useless, delete it." | Chesterton's Fence — find out why first. |
| "I'll refactor and tweak behavior together." | Separate. Simplify with behavior fixed; change behavior as a task. |
| "Two implementations is fine." | Collapse to one canonical contract. SSOT in code too. |
| "Clever and short is better." | Clear beats clever. Don't hide intent. |

## Red flags

Code removed without understanding why it existed; behavior subtly changed during a "simplification"; duplicated contract logic left in place; names that don't match the docs' IDs; tests not green throughout.

## Verification

- [ ] Behavior provably unchanged (tests green before and after; types hold).
- [ ] Anything removed was understood first (Chesterton's Fence).
- [ ] Duplicated logic collapsed to one canonical implementation.
- [ ] Names align with the docs' IDs; dead code removed.
- [ ] Complexity down without clarity loss.
