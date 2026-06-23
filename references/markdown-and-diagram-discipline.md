# Reference: Markdown & diagram discipline (pre-save checklist)

The project's docs render in **both Obsidian and GitHub**. A few constructs silently break Obsidian — sometimes for the rest of the file. SSOT: **Documentation System Guide §13**. Every authoring skill ends by running this checklist against what it wrote.

## Hard rules

- **Never indent a fenced code block inside a list item.** It flips code-fence parity for everything after it. Use inline code on the bullet, or a left-margin (column-0) fence *outside* the list.
- **Never leave bare `<...>` angle brackets in prose** — Obsidian deletes them as empty HTML tags. Wrap placeholders in backticks: `` `<unit>` ``.
- **Keep code fences balanced** (an even number of triple-backtick lines). Prefer triple-backtick fences over tilde (`~~~`) fences.
- **Blank line before** every list, heading, and fence.
- **Diagrams are Mermaid**, in **column-0** fenced blocks (a triple-backtick line followed immediately by `mermaid`). Use **C4** levels (Context → Container → Component) in Technical Design and **ER** diagrams in Data Dictionaries.

## Quick pre-save check (run every time)

1. Triple-backtick fence count is **even**.
2. **Zero** indented fences (no code fence preceded by spaces inside a list).
3. **Zero** bare `<tag>`s outside code.
4. Blank line precedes each list/heading/fence.
5. Every Mermaid block starts at column 0.

If any check fails, fix before saving. A skill that writes a doc is not done until this passes.
