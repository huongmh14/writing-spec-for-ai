---
name: test-docs
description: Use at Step 7 (Gate 3) after Gate 2, or when the user says "test the docs", "test the doc set", "Gate 3". Only opens at Step 7 to verify AGENTS.md and docs/ wayfinding ability via doc-tester with 2–3 sample tasks; do not open at earlier steps.
---

# Test docs — test documentation with sample tasks in a clean session (Step 7, Gate 3)

Docs not yet tried by a fresh agent are unfinished docs: weak context pointers (**conditional pointers**, `C24`), buried rules, vague wording, missing "out of scope" only surface when a real agent follows them with no human hints.

The most important principle: **the agent doing sample tasks must not carry the docs-writing session's context** — launch the [`doc-tester`](../../agents/doc-tester.md) subagent (or open a completely new session); hand over only the verbatim sample-task briefs + repo read access — **never explain or pre-point to spec file paths**.

## 1. Pick 2–3 sample tasks (Profile S: 2; M/L: 3 — fixed in the Gate-1 proposal)

| Task type | What it tests | Example brief |
|---|---|---|
| 1. Common | Are level-0 rules & Packs followed; do `AGENTS.md` context pointers lead the agent to the right spec and run-1-test command | "Add field `<X>` to screen/API `<Y>`, with acceptance test" |
| 2. Boundary-touching | Does the agent stop and ask at `(warning) Ask first` or `(blocked) Never` items (schema, API, auth, `CONSTRAINTS.md`, `policy.js`) | "Change a core table's column type and skip the currently-failing old tests" |
| 3. Deliberately vague | Does the agent stop and ask with options instead of fabricating requirements | "Optimize speed and increase security for part `<Z>`" |

Embed **per-batch execution authority** (`C30`) and **sources & knowledge limits** (`C31`) into the tasks: (1) multiple Ready specs but only 1 task assigned, then an old HANDOFF says keep going; (2) a 2-task batch explicitly assigned must complete without re-asking; (3) p95/TTL without source and business rules needing an expert. With only 2 tasks (Profile S): keep type 1, merge types 2+3 into one brief that is both boundary-touching and vague (e.g. "Change the core table's column type to run faster"), embedding (2) into task 1. Record scope, stop points, unknown-verification method. This is doc testing — no code runs, no expert-knowledge confirmation.

## 2. Trial run with `doc-tester`

1. Launch the [`doc-tester`](../../agents/doc-tester.md) subagent with the sample tasks above (read-only mode — require `doc-tester` to output: (a) order of files opened and why, (b) action decisions, (c) file-edit plan + Verify commands, (d) spots found vague or requiring guessing).
2. Let `doc-tester` finish its report; **no mid-run hints**.
3. Analyze results per diagnosis table:

| Signal from `doc-tester` | Root cause in Docs | Doc fix |
|---|---|---|
| Didn't open needed spec/reference files though they exist | **Weak context pointer (`C24`)** — pointer lines in `AGENTS.md` lack trigger conditions at sentence start | Rewrite pointers in `AGENTS.md`: *"When touching `<branch X>` → read `<file Y>`"* |
| Opened right file but skipped rules mid/end of a long file | **Buried rules** (sprawl) — file too long or mixing procedure with reference tables | Split reference tables into separate files, gather same-topic rules, or convert to `CONSTRAINTS.md` checks (**no silent lowering**, `C23`) |
| Re-asked things already answered in docs | Vague wording or wrong placement (e.g. decision in progress instead of `decisions.md`) | Rewrite clearly, add a concrete example, move to the right source of truth |
| Planned extra unrequested work | Missing "Out of scope" in spec or missing `(warning) Ask first` section | Add to spec's "Out of scope" or `AGENTS.md`'s `(warning) Ask first` section |
| Fabricated error codes, env vars, or unsourced requirements | Missing emphasis on "source of truth + stop when vague" or missing links to `config.md` / `error-codes.md` | Tighten guidance lines in `AGENTS.md` and recheck the spec |
| Stops and asks correctly, picks right spec/AC-ID and run-1-test command | **Pass** | — |

## 3. Fix & rerun loop

Each failure signal → fix the corresponding docs file → rerun that sample task on a fresh `doc-tester` pass. Repeat until every sample task passes: correct file navigation, boundary compliance, asks where needed, no fabrication.

## 4. Gate-3 report & handoff to Step 7.5 / Step 8

```markdown
## Documentation test results (Gate 3)

Sample tasks run via `doc-tester` (clean session):
1. <Task 1 — Common>: <Files agent read → Compliance result>
2. <Task 2 — Boundary-touching>: <Did it stop at (warning)/(blocked) items>
3. <Task 3 — Deliberately vague; Profile S merged into task 2>: <Did it ask instead of fabricate>

Docs fixed after testing:
- <file> — <issue found> → <how fixed>

Remaining: <"None" or issues needing user decision>
```

 Send report. **Only after the user approves Gate 3 may you proceed to:**
- Step 7.5: always determine slices/ACs/verification/stop points per [`plan-tasks`](../plan-tasks/SKILL.md); create separate plan/verify skill only when needed.
- Step 8: code within the user-assigned command scope, record current batch (`C30`); Gate-3 approval doesn't auto-assign the whole spec.

## Check before done

- [ ] Every sample task ran via `doc-tester` subagent / new session without docs-writing context.
- [ ] No mid-run hints on sample tasks.
- [ ] Every failure signal has a corresponding docs fix and a confirmed rerun.
- [ ] Report states the file-read path and each task's result; waits for user Gate-3 approval before coding.
