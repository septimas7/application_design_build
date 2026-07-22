---
name: running-quality-gates
description: Use whenever running local verification gates (full test suites, check scripts, DB gates, NFR benchmarks) during a build session - gate evidence survives compaction (tee output + exit code to a file, read it instead of rerunning), gates run in the background with no progress narration, single-flight locking prevents runner collisions, and a change-class matrix scopes what actually needs to rerun. The gate-economics skill: audited runs lost 15-20% of total effort to avoidable gate work.
---

# Running Quality Gates

Verification gates are the most expensive operations in a build session, and audited long runs lost **15–20% of total effort** to avoidable gate work: full reruns because a compaction ate an exit code, gates babysat with progress narration that itself accelerated compaction, full dual-gates triggered by markdown edits, and stray runners colliding on shared databases. Gate *discipline* is separate from pipeline *setup* (`ci-cd-and-automation`) — this skill is about running them well locally.

## Evidence survives compaction — tee everything

Every gate run writes its output **and its exit code to a file on disk**:

```bash
(./scripts/check-db.sh; echo "EXIT:$?") > /tmp/gates/check-db-$(date +%H%M%S).log 2>&1
```

- On resume after a compaction: **read the newest log file** — never rerun a gate because the exit code "is no longer recoverable from the session." The file is the evidence; the rerun is the waste (audited: three full multi-suite reruns in one session for exactly this).
- Cite the log file (path + EXIT line) as the verification evidence in the task log.

## Background, silent, single-flight

- **Run gates in the background**; poll coarsely (minutes, not seconds). **Zero no-delta narration** — "the gate has reached Views…" posts burn the context window, which accelerates compaction, which destroys gate evidence, which forces reruns: a self-reinforcing loop. Report the final result only.
- **Single-flight**: take a lockfile (or check for running gate processes) before starting a gate; a stray earlier runner colliding on shared databases poisons results and forces a rerun. Kill or wait out prior runners first.
- Do useful non-conflicting work while a long gate runs (task-log prep, next slice's red test) — or nothing. Waiting silently is cheaper than narrating.

## The change-class matrix — scope the rerun to the change

| What changed | What reruns |
|---|---|
| Design docs / task logs only | doc-lint only — **never** a code gate |
| One test file (no product code) | that suite + doc-lint |
| Product code in one crate/module | that crate's suite focused; full gate deferred to chunk close |
| Shared surface (kernel type, wire enum, error variant) | **pre-scan first**: grep every exhaustive match/consumer and fix them ALL, then one full gate — not one gate per discovered consumer |
| Environment repair (deps restored, artifact rebuilt) | re-run only the step that failed — an environment fix does not invalidate already-green code results, and "a clean pass for the record" is aesthetics, not evidence |
| Chunk close (pre-push of a review chunk) | the full gate set, once |

## A green gate must prove it ran something

`cargo test <filter>` (and most runners) **exit 0 when the filter matches zero tests** — a rename silently unwires a suite and the ledger stays green with no measurement behind it. (Audited: this exact mode occurred twice in one evening, independently, in two different evidence scripts.)

- Every gate/evidence script asserts a **nonzero pass count** per run, e.g. `grep -Eq 'test result: ok\. [1-9][0-9]* passed' "$log"` — never just the exit code.
- When a cited test is renamed, grep the repo for the old name: harnesses, evidence scripts, and traceability maps all pin names.

## Benchmarks are gates too

- A reference-profile benchmark result is **reusable within a session** unless the measured path changed — never rerun a multi-minute benchmark for bookkeeping ("this harness is the one that records the number": record the number you already have).
- Percentiles need ≥20 samples, raw samples retained (`test-driven-development`); fixture-scale runs are smoke checks, only reference-profile runs are citable NFR evidence.

## Anti-rationalization

| Excuse | Reality |
|---|---|
| "The compaction lost the exit code, so rerun." | The tee'd log file has it. Read the file. Rerunning a 10-minute gate to relearn `EXIT:0` is the single most expensive no-op available. |
| "I'll narrate gate progress so the user sees momentum." | Progress posts with no delta burn the context that keeps evidence alive. Final result only. |
| "It's cleaner to rerun the full gate for the record." | A green result is a green result. Reruns for aesthetics are pure cost. |
| "The doc edit might affect something." | Markdown cannot fail a compile. Docs → doc-lint. |
| "Fix this consumer, rerun, fix the next…" | Pre-scan all consumers of a shared-surface change first; one rerun, not N. |

## Red flags

A gate script that trusts the runner's exit code without asserting a nonzero pass count · a gate rerun whose only justification is a lost exit code · more than one no-delta gate-progress post · a full code gate triggered by a docs-only diff · the same multi-minute benchmark run twice in one session on an unchanged path · two gate runners alive at once · gate output that exists only in the (compactable) session.

## Verification

- [ ] Every gate run this session tee'd output + exit code to a file; resumes read files instead of rerunning.
- [ ] No no-delta gate narration; gates ran in the background.
- [ ] Every rerun maps to a row of the change-class matrix; shared-surface changes were pre-scanned and batched.
- [ ] Every gate/evidence script asserts a nonzero pass count, not just exit 0.
- [ ] No benchmark was repeated on an unchanged path; measurements are tier-labeled.
- [ ] Task-log evidence cites the gate log files.
