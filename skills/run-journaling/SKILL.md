---
name: run-journaling
description: Use during any long-running autonomous execution, at each checkpoint push, and at run end - captures the agent's narrated chat history as an append-only run-journal artifact (one file per run, per agent, per machine, kept in the design repo) and defines the process-audit loop that mines journals into environment-ledger entries, rules-file additions, and skill/convention hardening. The continuous-self-improvement feedback loop.
---

# Run Journaling

A long autonomous run produces two outputs: the code, and the **process record** — the narrated history of what the agent did, what it hit, what it decided, and what it cost. The code gets reviewed; the process record normally evaporates with the context window. This skill retains it as an **append-only artifact**, then closes the loop: journals get audited, audits harden the skills, conventions, rules files, and environment ledger — so the next run starts smarter than the last one ended.

## When to use

- Any run expected to span multiple checkpoints, compactions, or hours.
- At every checkpoint push (the append moment).
- At run end (the closing entry).
- When enough journals have accumulated for a process audit.

## The artifact

- **One file per run**: `Journals/YYYY-MM-DD-<agent>-<machine>-<slug>.md`, in the **design repo** (the durable, cross-machine program record — same home as the task logs). One file per run means concurrent agents on different machines never write the same file: no merge conflicts by construction.
- **Frontmatter**: agent, machine (the task logs' `machine:` identifier), start/end timestamps, branches touched, tasks worked.
- **Body**: the narrated progress log — the status updates the agent already produces between actions ("what I found, what I'm doing next, why"), in order, **unedited**. The narration IS the journal; capture it, don't rewrite it into something tidier.
- **Append-only.** Never clean up, summarize-in-place, or retro-edit a journal. Corrections are later entries. The friction, dead ends, re-orientation loops, and rework are not embarrassments to remove — they are precisely the data the audit mines.

## Capture mechanics

- **At each checkpoint push**: append the narration since the last checkpoint. It's a copy from the session, not new writing.
- **Before a context compaction** (when the harness allows): append first — the pre-compaction narration is exactly the part that otherwise evaporates.
- **At run end**: final append plus a five-line closing summary — what shipped, what's blocked, what surprised, what was learned, what the next run should know first.
- **If mid-run writes aren't possible** in a given harness: export the narrated session history at run end from the harness's own transcript store. The narrated view is sufficient; full tool I/O is optional extra.

## The audit loop — the point of it all

Journals exist to be mined, not stored. On a cadence (after each long run, or when a few accumulate), a **process audit** reads the new journals and asks four questions, each with a mandatory landing place:

| Question | Finding lands in |
|---|---|
| What was rediscovered that a past session already learned? | `ENVIRONMENT.md` ledger (`environment-discipline`) — and promotion if it's a second hit |
| What standing instruction was re-litigated after a compaction? | The rules file (`context-engineering`) |
| What deliberation repeated across the run with the same outcome? | A codified protocol in the relevant skill |
| What failure class recurred? | A convention change, a CI/harness guard, or a banned-pattern tripwire |

**Every audit finding lands somewhere durable** — a skill, a convention, the ledger, or the rules file. An audit that produces only observations changed nothing; the loop only improves the system when it closes.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "The git history is the record." | Commits record *what* changed; the journal records *why*, what it cost, and what went wrong on the way. The audit needs the second one. |
| "I'll tidy the journal before saving." | Append-only, unedited. A cleaned journal is a press release; the audit needs the flight recorder. |
| "Journaling slows the run down." | It's a copy-paste per checkpoint. The alternative is the next run re-learning everything this one learned — at full price. |
| "The audit can wait indefinitely." | Unaudited journals are dead weight. Schedule the audit; land the findings. |
| "One big shared journal file is simpler." | Two agents, one file, guaranteed conflicts. One file per run, per agent, per machine. |

## Red flags

A long run with no journal file · a journal edited after the fact · narration lost to a compaction that a checkpoint append would have saved · journals accumulating with no audit scheduled · audit findings that landed nowhere durable · two agents writing the same journal file.

## Verification

- [ ] The run has a journal file (right name, frontmatter complete) in the design repo.
- [ ] Appends happened at every checkpoint push and at run end (closing summary present).
- [ ] The journal is unedited narration, in order — no retro-cleanup.
- [ ] A process audit is scheduled (or ran), and each of its findings landed in a skill, convention, ledger, or rules file.
