---
name: performance-optimization
description: Use when a path is measurably slow - measure first, then optimize the proven bottleneck. Covers portal Core Web Vitals, database query performance (the typed-columns-vs-JSON-overflow model), and event-bus / queue throughput. Never optimize without a measurement.
---

# Performance Optimization

**Measure first.** Optimize only a bottleneck you've proven with a number. Premature optimization adds complexity and bugs for no gain.

## When to use

- A path is observably slow, or a perf budget (CWV, a latency target) is missed.
- **Not** speculatively. No measurement means no optimization.

## Process

1. **Measure.** Reproduce under realistic load; capture a number (latency, query time, CWV, queue lag). Use the right tool: `browser-testing-with-devtools` for the portal; the database query planner (e.g. `EXPLAIN ANALYZE`) for queries; the app-log/metrics for the backend.
2. **Localize the bottleneck.** Find the dominant cost — usually one query, one render, one N+1, one hot loop. Don't scatter-optimize.
3. **Optimize the proven cost.** Smallest change that moves the number. Re-measure to confirm.
4. **Guard.** Add a budget/assertion or a perf test so the regression can't silently return.

## Common hot spots

- **Portal — Core Web Vitals.** LCP/INP/CLS; bundle size; virtualize big lists (a large data grid should be virtualized); avoid layout thrash.
- **Database queries.** The hybrid model — typed columns + a flexible JSON overflow field: typed columns are index-fast; **the JSON overflow field is not** until promoted. A slow filter on a JSON overflow field is the signal to promote it to a real typed column (a schema decision — a `task` + Decision Record). Use indexes; avoid full scans of the JSON field.
- **Event bus / queue throughput.** Batch consumers; watch queue depth (the worker-pool config key, e.g. `max_workers_per_queue`); don't poll tighter than needed.
- **N+1 across the service registry** — batch/join instead of per-row service calls.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "This looks slow, optimize it." | Measure first. Looks slow is not is slow. |
| "Optimize everything for safety." | Optimize the proven bottleneck only; the rest adds risk. |
| "Filter the JSON overflow field, it's fine." | Unpromoted JSON-field filters don't use indexes. Measure; promote if hot. |
| "No need to re-measure." | Confirm the change moved the number. Else revert it. |

## Red flags

An optimization with no before/after number; scattered micro-tweaks; a JSON-field filter on a hot path with no index/promotion; tighter-than-needed queue polling; no regression guard on a fixed perf bug.

## Verification

- [ ] A measurement established the bottleneck before any change.
- [ ] The fix targeted the dominant cost; re-measured improvement is real.
- [ ] Hot database filters use typed columns/indexes (JSON-overflow fields promoted where hot).
- [ ] A perf budget/test guards against regression.
