---
name: directories-and-dictionaries
description: Use to author or extend a unit's Directories/ folder - the four Dictionaries (Data, Resources & Grants, Config, Log) and five interface Directories (MCP, API, Web Hooks, Events, User Exits). Canonical SSOT catalogs; every entry needs an action gate and at least one example.
---

# Directories & Dictionaries

Author a unit's `Directories/` — the **canonical catalogs** that are the source of truth for its data, permissions, config, logs, and interface surface. These files are what the runtime documentation generator reads to produce the live, machine-readable platform reference, so their rigor is the whole point. SSOT: the **Dictionary Convention** and the **Interface Directory Convention**.

## The two families

- **Dictionaries — definitional catalogs** (*what exists*): **Data Dictionary** (table schemas), **Resources & Grants Dictionary** (functional areas, access levels, actions, roles), **Config Dictionary** (settings, global + per-user), **Log Dictionary** (per-component log sources).
- **Directories — interaction surfaces** (*how to interact*): **MCP Tools**, **API**, **Web Hooks**, **Events**, **User Exits**.

Each is the canonical SSOT for its kind; other docs **reference, never duplicate**. There is **no hand-maintained global roll-up** — the documentation generator aggregates across units.

## When to use

- Standing up a unit's `Directories/` (copy the nine-file shape).
- Adding a table, permission, config key, log source, tool, endpoint, webhook, event, or user-exit.

**Primary input:** the **"Entities surfaced"** hand-off from `ui-design` (which runs first) — its candidate tables, actions, and interface IDs. This skill **canonicalizes** those candidates into real entries, plus anything the Technical Design owns that the UI didn't surface (internal events, user-exits, infra tables). Where a candidate ID from the UI pass already exists, reconcile rather than duplicate.

## Authoring rules (both families)

1. **One canonical entry per thing**, in the owning unit. A table is defined in *its* Data Dictionary; a tool in *its* MCP Tools Directory; etc.
2. **Mint a stable ID** from `references/stable-id-and-cross-link-graph.md`. Never reuse.
3. **Every interface entry names the action it requires** (an ID from the Resources & Grants Dictionary — which implies its functional area + minimum access level).
4. **At least one example per interface entry is mandatory** — this is what lets an external agent self-serve.
5. **Deprecate, don't delete** — `status` (active | deprecated | removed) + `since`.
6. **Cross-link siblings** — MCP ↔ API equivalents; webhook ↔ event.
7. **Stay in sync with the FS/TD contract.** A Directory entry is the *catalog* of a contract the Functional Spec / Technical Design commits to. When that contract changes (a result/wire shape, an event name/payload, a persisted field, a signature), **the Directory entry changes in the SAME fold** — an FS that now says `{unit,kind,ref}` while the API Directory still returns a scalar, or a Data Dictionary that persists a field the API Directory omits, is a silent build-blocker. When you touch a contract, update its entry across **every** sibling Directory that projects it (Data/API/MCP/Events/Web Hooks) and any consuming app's Directory, not just the one you opened.

For example, table `catalog_item` lives in the Data Dictionary; action `catalog.item.create` (min level `editor`, area `catalog.area.items`) in the Resources & Grants Dictionary; tool `catalog.create_item` cross-links API `catalog.api.create_item`; event `catalog.item.created`; user-exit `catalog.before_item_write`; config key `catalog.config.max_items`.

## Entry schemas

Use `references/doc-anatomy-cheatsheets.md` for the interface entry shape (MCP shown; API / Web Hook / Event / User-Exit follow the parallel schemas in Interface Directory Convention §2.2–2.5). For Dictionaries, follow the Dictionary Convention's per-kind schema (Data = columns/keys/types + an ER diagram; Resources & Grants = the access-level ladder + areas + actions + roles; Config = key/scope/default/range; Log = source/levels).

## The Resources & Grants Dictionary is special

It defines the **global access-level ladder** (`none/viewer/editor/admin`), the unit's **functional areas**, **actions**, and **roles**. Every other entry across all docs that says "Requires action" points here. Author/extend it first so the actions exist to be referenced.

## Promote-to-folder

Split unit = **resource/tool group** (`<Directory>/README.md` + `<group>.md`). Don't promote pre-emptively.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "I'll add the example later." | Examples are mandatory — the documentation generator and external agents depend on them. Add it now. |
| "I'll define this table in the Technical Design." | Data Dictionary is the only canonical home. Define it here. |
| "This tool doesn't need an action gate." | Every interface entry names its required action. No exceptions. |
| "Delete the old endpoint." | Deprecate in place with `status` + `since`. Never delete. |
| "I'll make a master list of all tools." | No hand-maintained roll-up. SSOT per unit. |

## Red flags

An interface entry with no example · an entry with no required action · a table/tool defined in two places · a deleted (not deprecated) entry · an action referenced that doesn't exist in the Resources & Grants Dictionary.

## Verification

- [ ] Each entry has a stable ID, the required-action gate, owning/emitting component, `status` + `since`, and (interfaces) ≥1 example.
- [ ] Referenced actions exist in the Resources & Grants Dictionary.
- [ ] Sibling surfaces cross-linked (MCP↔API, webhook↔event).
- [ ] Nothing duplicated from another doc; deprecate-don't-delete honored.
- [ ] Frontmatter incl. `interface_kind` + base path; markdown-discipline check passes; revision-history row → driving task.
