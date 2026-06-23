---
name: deprecation-and-migration
description: Use when retiring or evolving something - an interface, a schema, a config key, or data. Treats code as a liability, follows deprecate-don't-delete (mirroring the Directories' status/since), and runs data/schema migrations through the migration runner with the destructive-change policy in mind.
---

# Deprecation & Migration

Retiring and evolving things safely. **Code is a liability** — less is better — but you remove published contracts *gradually*, never abruptly. This is the build-time realization of the docs' **deprecate-don't-delete** rule.

## When to use

- Retiring or breaking an interface, schema, config key, or feature.
- Migrating data or evolving a schema.

## Deprecate-don't-delete (published contracts)

1. **Mark deprecated first.** Set the **Directory entry** (or Config/Data Dictionary entry) `status: deprecated` + the replacement link. Code keeps it working.
2. **Announce + provide the path.** Document the replacement and migration steps; emit a deprecation signal (log/event) when the old path is used.
3. **Window, then remove.** After the support window, set `status: removed` and delete the code. Never skip straight to deletion.

Internal dead code (unpublished, unreferenced) is different — just remove it (`code-simplification`).

## Data & schema migrations

- Run through the **migration runner** — never hand-edited DDL in production.
- **Forward migrations are safe by default** (add column/table, backfill). Adding a real column to a populated table preserves existing rows.
- **Destructive changes** (drop/retype a populated column) are higher-risk — gate them: confirmation, backup, a `before_schema_change` user-exit (a schema-guard safety check may veto). Record the decision as a **Decision Record** in the task. A destructive schema change on a populated table is the canonical case to gate.
- Migrations are reversible or have a documented recovery; test on a copy first.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "Just delete the old endpoint." | Deprecate first; window; then remove. Consumers depend on it. |
| "Hand-run this one DDL in prod." | Migration runner only. Reproducible + reversible. |
| "Drop the column, the data's stale." | Destructive change — gate it, back it up, record the decision. |
| "Migration doesn't need testing." | Test on a copy. Data loss is unrecoverable. |

## Red flags

A published contract deleted without a deprecation window, production DDL outside the migration runner, a destructive schema change with no backup/gate/decision-record, an untested migration, a deprecation with no replacement path.

## Verification

- [ ] Retired contracts went deprecated → (window) → removed, reflected in the Directory/Dictionary.
- [ ] A replacement + migration path was documented and signaled.
- [ ] Schema/data changes ran through the migration runner; tested on a copy.
- [ ] Destructive changes were gated, backed up, and have a Decision Record.
