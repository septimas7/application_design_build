# Reference: Frontmatter schema (output contract)

Every document a skill produces **must** open with this YAML block. This is a thin pointer to the SSOT — the **project's `Conventions/Documentation System Guide.md` §5** — copied here so a skill is loadable without the full repo. If the two ever disagree, the Convention wins.

## Shared fields (all docs)

| Field | Values | Notes |
|---|---|---|
| `doc_type` | `documentation-system-guide` · `convention` · `functional-design` · `technical-design` · `dictionary` · `directory` · `ui-design` · `task-log` | What kind of doc this is. |
| `unit` | `system` · `platform` · `application:<id>` | Which unit it belongs to. `system` = repo-wide. |
| `type` | `native` · `connector` · `hybrid` | **Application units only.** |
| `title` | free text | Human title. |
| `status` | `draft` · `active` · `superseded` · `deprecated` | Document lifecycle. |
| `version` | `rN` | Current revision number. |
| `owner` | name | Accountable owner. |
| `created` | ISO-8601 date | Set once. |
| `last_updated` | ISO-8601 with offset | Bump on every write. |
| `related` | list of relative paths | Key cross-links. |
| `tags` | list | The project slug plus area tags. |

## Type-specific additions

| doc_type | Extra frontmatter |
|---|---|
| `functional-design` | `depends_on` (units/capabilities this builds on); Application: `type` |
| `technical-design` | `depends_on` (platform services / units consumed; no cycles) |
| `directory` | `interface_kind` (`mcp` \| `api` \| `webhook` \| `event` \| `user-exit`), base path/namespace |
| `ui-design` | `page` (id/name), `route` (nav path), `related` FRs |
| `task-log` | `machines` (hostnames touched) |

## Rule

- `created` is set once and never changes; `last_updated` and `version` bump **together** on every write.
- When retiring a doc, set `status: superseded`/`deprecated` and link the replacement — never delete.
