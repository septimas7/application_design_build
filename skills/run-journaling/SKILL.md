---
name: run-journaling
description: Use toward the end of any long-running autonomous execution - exports the run's full chat history (every attempt, the tools used, the results, and every user input verbatim) from the harness's stored session transcript into one append-only run-journal artifact per run/agent/machine in the design repo, and defines the process-audit loop that mines journals into environment-ledger entries, rules-file additions, skill/convention hardening, and user-input automation candidates. The continuous-self-improvement feedback loop.
---

# Run Journaling

A long autonomous run produces two outputs: the code, and the **process record** — the narrated history of what the agent did, what it hit, what it decided, and what it cost. The code gets reviewed; the process record normally evaporates with the context window. This skill retains it as an **append-only artifact**, then closes the loop: journals get audited, audits harden the skills, conventions, rules files, and environment ledger — so the next run starts smarter than the last one ended.

## When to use

- Toward the end of any run that spanned multiple checkpoints, compactions, or hours (the export moment).
- When enough journals have accumulated for a process audit.

## The artifact

- **One file per run**: `Journals/YYYY-MM-DD-<agent>-<machine>-<slug>.md`, in the **design repo** (the durable, cross-machine program record — same home as the task logs). One file per run means concurrent agents on different machines never write the same file: no merge conflicts by construction.
- **Frontmatter**: agent, machine (the task logs' `machine:` identifier), start/end timestamps, branches touched, tasks worked.
- **Body**: the run's history in order, **unedited in substance** — per significant step: what was attempted → which tools were used → what the result was (including failures, retries, and dead ends), plus every user input. The record IS the journal; don't rewrite it into something tidier.
- **Append-only once written.** Never clean up, summarize-in-place, or retro-edit a journal. Corrections are later entries. The friction, dead ends, re-orientation loops, and rework are not embarrassments to remove — they are precisely the data the audit mines.

## Capture — one export at run end

No mid-run journaling: continuous appends churn data and interrupt the work. Toward the end of the run, write the whole record **once**, sourced **from the session's stored chat history, not from working memory**:

- **Source honestly.** Context compaction removes earlier conversation from the agent's *working memory*; the harness's session store retains the full transcript. Export/derive the journal from that stored transcript (or the harness's session-history view). If a stretch is genuinely irretrievable, mark it — `[detail unavailable: pre-compaction]` — never reconstruct it from impression; a confabulated early-run record poisons the audit.
- **Per significant step**: what was attempted, which tools were used, what the result was. Failures and dead ends included — they carry more audit value than the successes.
- **Record every user input verbatim**, clearly marked (e.g. a `> USER:` prefix). The decisions, approvals, corrections, and clarifications the human supplied are first-class data: they are the candidates for automating those inputs away in future runs.
- **Close with the five-line summary**: what shipped, what's blocked, what surprised, what was learned, what the next run should know first.
- **Then the "Decisions needed" register**: reproduce **verbatim** every question parked for the human during the run — design blockers recorded, scope calls deferred, approvals pending. A parked decision buried in the log body is a decision the owner never gets to make (audited: a run parked two design blockers correctly, then omitted both from its final handoff; the owner had to excavate the log).

## The audit loop — the point of it all

Journals exist to be mined, not stored. On a cadence (after each long run, or when a few accumulate), a **process audit** reads the new journals and asks four questions, each with a mandatory landing place:

| Question | Finding lands in |
|---|---|
| What was rediscovered that a past session already learned? | `ENVIRONMENT.md` ledger (`environment-discipline`) — and promotion if it's a second hit |
| What standing instruction was re-litigated after a compaction? | The rules file (`context-engineering`) |
| What deliberation repeated across the run with the same outcome? | A codified protocol in the relevant skill |
| What failure class recurred? | A convention change, a CI/harness guard, or a banned-pattern tripwire |
| Which user inputs recur (approvals, decisions, clarifications)? | A standing rule, a config default, or a recorded decision — so the next run doesn't need to ask |

**Every audit finding lands somewhere durable** — a skill, a convention, the ledger, or the rules file. An audit that produces only observations changed nothing; the loop only improves the system when it closes.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "The git history is the record." | Commits record *what* changed; the journal records *why*, what it cost, and what went wrong on the way. The audit needs the second one. |
| "I'll tidy the journal before saving." | Unedited in substance. A cleaned journal is a press release; the audit needs the flight recorder. |
| "I remember the run well enough to write it." | Post-compaction memory is a summary, not a record. Export from the session store; mark real gaps as gaps. |
| "The end-of-run export is a big lift." | It's an export from stored history, not authorship. The alternative is the next run re-learning everything this one learned — at full price. |
| "Skip the user's messages, they're not my work." | User inputs are the automation frontier. Recorded verbatim, they become the standing rules that stop the next run from asking. |
| "The audit can wait indefinitely." | Unaudited journals are dead weight. Schedule the audit; land the findings. |
| "One big shared journal file is simpler." | Two agents, one file, guaranteed conflicts. One file per run, per agent, per machine. |

## Red flags

A long run with no journal file · a journal written from post-compaction memory instead of the stored transcript · an early-run stretch confidently narrated that should be a marked gap · user inputs paraphrased, summarized, or omitted · a journal edited after the fact · journals accumulating with no audit scheduled · audit findings that landed nowhere durable · two agents writing the same journal file.

## Verification

- [ ] The run has a journal file (right name, frontmatter complete) in the design repo.
- [ ] The journal was exported at run end from the stored session history — attempts, tools, results, in order; gaps marked, none papered over.
- [ ] Every user input appears verbatim and marked.
- [ ] The closing five-line summary is present, followed by the "Decisions needed" register (or an explicit "none").
- [ ] A process audit is scheduled (or ran), and each of its findings landed in a skill, convention, ledger, rules file — or an automation of a recurring user input.
