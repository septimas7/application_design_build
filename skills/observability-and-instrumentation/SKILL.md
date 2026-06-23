---
name: observability-and-instrumentation
description: Use when adding logging, metrics, or tracing to code - registering log sources in the Log Dictionary, emitting structured per-component logs via the app-log, recording RED metrics, and tracing across the event bus. Make the system debuggable and queryable by design.
---

# Observability & Instrumentation

Instrument so the system can explain itself — to an operator, a debugger, and a tool querying the logs interface. Observability is **registration-driven**: a log source is a catalogued entry, not an ad-hoc print statement.

## When to use

- Adding a component, or a path that needs to be debuggable in production.
- Closing an observability gap found during `debugging-and-error-recovery`.

## Structured logging

1. **Register the source** in the **Log Dictionary** (`<unit>.<component>`), with its levels — registration-driven, per-component levels.
2. **Emit structured logs** via the **app-log** (the Platform unit's diagnostic log) — key/value fields, not string soup. Distinct from the **audit-log** (who changed what state) — use audit for state-change accountability, app-log for diagnostics.
3. **Make it queryable.** App-log is queryable behind a logs-query interface; structure fields so a query can filter by component, level, entity ID.
4. **Never log secrets** (see `security-and-hardening`).

## Metrics (RED) & tracing

- **RED per surface:** Rate, Errors, Duration for API/interface handlers, queue consumers, key service-trait calls.
- **Trace across the event bus.** Propagate a correlation/trace ID through events on the event bus so a flow can be followed component-to-component (OpenTelemetry-style). The **Events Directory** documents the path; the trace makes it observable at runtime.
- Watch the documented operational signals (queue depth vs the configured per-queue worker limit).

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "A quick print is fine." | Register the source + structured fields. Ad-hoc logs aren't queryable. |
| "Log the whole object." | Structured fields, no secrets. Logs are read by queries and tools. |
| "Audit and app-log are the same." | Audit = state-change accountability; app-log = diagnostics. Use the right one. |
| "Tracing later." | Without a correlation ID across the bus, cross-component flows are opaque. |

## Red flags

A component with no registered Log Dictionary source, unstructured/secret-leaking logs, audit vs app-log misused, no RED metrics on a key surface, event flows with no correlation/trace ID.

## Verification

- [ ] Each instrumented component has a Log Dictionary source with per-component levels.
- [ ] Logs are structured, secret-free, and queryable via the logs-query interface.
- [ ] Audit-log used for state changes; app-log for diagnostics.
- [ ] RED metrics on key surfaces; correlation/trace ID propagated across the event bus.
