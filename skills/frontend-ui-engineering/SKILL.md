---
name: frontend-ui-engineering
description: Use when implementing a web client / portal page from its UI Design Requirements and mockups - component architecture, consuming the Platform design system, state management, all UI states, accessibility, and binding components to the API/MCP Directory entries.
---

# Frontend UI Engineering

Implement a web client / portal **page** from its `UI Design Requirements.md` + `Mockups/`. The requirements text is authoritative; the mockups (from the `frontend-design` skill) illustrate. Assume a component-based web UI. SSOT: the UI Design Convention + `references/implementation-stack-and-doc-mapping.md`.

## When to use

- Building or revising a web client / portal page that has a UI Design Requirements doc.
- Building shared design-system components in Platform/UI.

## Before coding — load the page spec

The `UI/<page>/UI Design Requirements.md`: its components (each with data source + actions + gating action), its **states** (empty/loading/error/populated/**permission-denied**), interactions, and the annotated mockups. Plus the **API/MCP Directory entries** each component calls.

## Process

1. **Reuse the Platform design system.** Tokens + base components come from Platform/UI — never redefine colors/spacing/components. A genuinely new shared pattern is added *there*, not inlined.
2. **Build the component tree** to match the requirements' components. Each component maps to its documented data source + actions.
3. **Bind to the surface.** Data comes from the **API/MCP Directory** entries (typed to the entry's input/output). No ad-hoc endpoints — if you need one that isn't catalogued, that's a Directories gap -> back to `directories-and-dictionaries`.
4. **Implement every state**, not just populated: empty, loading, error (with the Directory's error semantics), and **permission-denied** (gated by the required action / access level).
5. **Gate visibility by action.** Show/hide per the component's "Requires action" (the user's access level vs the Resources & Grants action).
6. **Accessibility** per the page's a11y section: keyboard, focus, contrast, screen-reader labels, target sizes. Mind Core Web Vitals.
7. **Verify** with `browser-testing-with-devtools` against the documented states.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "I'll define a button style here." | Reference the Platform design system; add shared patterns there. |
| "The mockup shows it, so build exactly that." | Text is authoritative; mockups illustrate. Follow the requirements. |
| "I'll just call a quick custom endpoint." | Interfaces come from the Directories. Missing one = a Directories gap, not an inline hack. |
| "Populated state is enough." | empty / loading / error / **permission-denied** are required. |
| "A11y later." | A11y is in the requirements. Build it in. |

## Red flags

Redefined design tokens · a component calling an endpoint not in the API/MCP Directory · missing permission-denied or error states · visibility not gated by access level · no a11y · mockup treated as the behavioral source of truth.

## Verification

- [ ] Components match the requirements; each binds to its documented data + actions.
- [ ] All states implemented incl. permission-denied; transitions correct.
- [ ] Data/actions go through catalogued API/MCP Directory entries (typed to them).
- [ ] Visibility gated by the required action/access level.
- [ ] Consumes the Platform design system; no redefined tokens.
- [ ] A11y per the page spec; verified at runtime via `browser-testing-with-devtools`.
