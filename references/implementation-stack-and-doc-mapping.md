# Reference: Implementation stack & design-doc → code mapping

The Build skills produce **code** for the project's eventual implementation repo(s). This reference is stack-agnostic: it states **how each design-doc artifact maps to code**, so the design docs stay the spec source and the traceability graph survives into the codebase. The stack itself is something the project fills in once, below.

## Stack (fill in your stack)

Record the project's stack here once, then the Build skills inherit it. Update this one file if the stack changes.

| Layer | Your choice | Notes |
|---|---|---|
| Backend (Platform unit + plugins) | `<language / runtime>` | Hosts the service contracts (DI) and plugin lifecycle. |
| Database | `<database>` | Plus a flexible JSON overflow field for hybrid records; a migration runner. |
| Message / event bus | `<queue / event bus>` | Durable async between units. |
| API + MCP surface | `<HTTP API + MCP>` | Client-agnostic; MCP↔API parity per the Directories. |
| Web client | `<web framework>` | The portal; consumes the API/MCP surface and renders the Platform design system. |
| Desktop client (optional) | `<optional desktop shell>` | Additive client that reuses the web portal; no backend rearchitecture. |
| Secret store | The platform secret store | External-service credentials never plaintext. |

A **connector** plugin may use a different language/runtime to bridge an external product — its `Technical Design` external-integrations section governs.

## The doc → code mapping (the contract)

Code implements the design docs; it does not reinvent them. For a task, load **only** the artifacts it touches (exploit promote-to-folder: the small index, then the one part):

| Design artifact | What the code must do |
|---|---|
| **`task-NNNNN` `#### Acceptance`** | The definition of done. Every criterion becomes a test or a checked behavior. |
| **FR-### + its acceptance** | The behavior to implement; cite the FR in the test name and the commit. |
| **NFR-### (non-functional requirement)** | The quality target to hold (performance, reliability, security budget); assert or measure it where it applies. |
| **Technical Design component** (CMP-### with its handle, e.g. `CMP-001 (catalog.store)`) | The module to build; its **Public interface** = the service interface/contract signature. |
| **Interface Directory entry** (MCP/API/event/hook) | The exact wire contract — names, inputs/outputs, errors, idempotency; the **example** is a test fixture. MCP↔API parity must hold. |
| **Data Dictionary table** | The migration + the row type; the SSOT for columns/keys. No schema invented in code. |
| **Resources & Grants action** | The permission gate enforced at the boundary (matches "Requires action"), using the none/viewer/editor/admin ladder. |
| **Config Dictionary key** | The config read; default/range honored; resolution user → global → default. |
| **Log Dictionary source** | The structured log site; per-component level; registration-driven. |
| **UI Design Requirements + Mockups** | The web-client page; text authoritative over mockups; all states incl. permission-denied. |

For example, a task on the neutral `catalog` app might touch `FR-001`, `NFR-001`, `CMP-001 (catalog.store)`, the `catalog_item` table, and the `catalog.item.create` event raised by the `catalog.create_item` action behind the `catalog.api.create_item` endpoint, with the `catalog/ui/catalog-view` page on the front end. Each maps to exactly one code artifact via the table above.

## Token discipline (carry into every Build skill)

- **Load the small index, open only the one part.** Use the Technical Design `README` catalog + the specific Directory entries for the task — never whole subsystems.
- **Navigate by stable ID** (FR-###, NFR-###, CMP-###), not by grepping whole files.
- **The Directories are machine-readable** — read the interface entry, not the source, to learn a contract.
- **Reference-don't-duplicate** carries into code: one canonical implementation per contract.

## Traceability into code

Keep the graph alive past the design layer: commit messages cite `task-NNNNN`; tests name their `FR-###`; a module header notes the `CMP-###` it implements; a PR description lists the FRs/NFRs/acceptance it satisfies. This is what lets a reviewer (human or LLM) trace a line of code back to the capability it serves.
