---
name: review-docs
description: Use at Step 6 (Gate 2) after docs/spec files are written, or when the user says "review docs", "score the checklist", "Gate-2 challenge". Only opens at Step 6 to run spec-challenger in a clean session and present the report; do not open before docs are written.
---

# Review docs — adversarial challenge & self-check before presenting (Gate 2)

Input: list of files just written/edited (`ARTIFACT`) + path to `references/review-checklist.md`, enabled `packs/PK-*.md` files (`CONTRACT` — pass paths for the `spec-challenger` subagent to read in a clean session; the main session does not bulk-load `references/base-kit.md` into context, `C17`).
Output: report to the user containing (1) file list, (2) per-item scoring results, (3) classified challenge findings & every `[ ]` item with fix proposals, (4) remaining open questions. **`[ ]` items must not be hidden** — they are what the approver most needs.

> Root idea (internal reference skill, not evidence): `doubt-driven-development` (Core rule **clean-session challenge**, `C26`), `pstack/interrogate`, `open-code-review-delegate`.

## 1. Adversarial challenge process in clean context (`C26`)

The author always carries confirmation bias. So at Step 6:

1. **Separate `ARTIFACT` and `CONTRACT` (never pass `CLAIM`):**
   - Hand work to the read-only [`spec-challenger`](../../agents/spec-challenger.md) subagent (or run a check fully detached from the writing rationale).
   - Provide only paths of just-written files (`ARTIFACT`) and [`references/review-checklist.md`](../../references/review-checklist.md) + enabled Packs (`CONTRACT`). No *"I wrote this because..."* justifications.
2. **Run independent challenge — clearly distinguish `Cross-Model` vs `Same-Model Clean-Session`:**
   - Same model family writing and re-reading shares blind spots. If the environment has a CLI of a **different model family** than the one writing (e.g. writing with Antigravity/Claude then call `codex exec --sandbox read-only...`, or vice versa; always close `stdin` with `"" |` so the CLI doesn't hang waiting for input), **proactively run the cross-model challenge** passing only `ARTIFACT + CONTRACT`. If no other-family CLI exists, run the [`spec-challenger`](../../agents/spec-challenger.md) subagent in a clean session and honestly record in the report `Same-model clean session (with reason other model unavailable)` — falsely claiming cross-model review is forbidden.
   - **Never silently suppress challenger findings:** the author may not self-label "false alarm" and quietly delete. Every challenger finding must be fully listed in the user report under 2 groups: `Self-fixed (Fixed)` and `Not fixed / Needs user decision (Not Fixed / Needs Decision)` with concrete reasons. Distinguish from `C31`: two AIs praising/agreeing **is not correctness evidence**, but errors pointed out by the second model / clean session are mandatory signals to reconcile publicly.
3. **Reconcile & classify findings (`RECONCILE`):**
   Re-read the actual text against each `spec-challenger` finding and classify by priority:
   - **Type 1 — Real error, fixable now:** fix directly in docs files before presenting to the user (see section 2 table).
   - **Type 2 — Needs decision:** behavior/scope/trade-off → ask the user with examples; missing technical knowledge → AI researches/experiments within granted authority or proposes an expert (**sources & knowledge limits**, `C31`) — don't force the user to confirm unproven claims.
   - **Type 3 — Deliberate trade-off:** record the reason or tag `ceiling:` (**mark simplification ceilings**, `C27`) / `D-xx` so the user sees it.
   - **Type 4 — False alarm from missing context:** if a fresh reader misunderstood due to unclear wording, sharpen the wording so future readers don't misunderstand the same way.

## 2. Score per [references/review-checklist.md](../../references/review-checklist.md) & quick fixes

Run all 6 groups in order; each item needs **evidence in the file** (path + line/section).

| Observable symptom | Fix before presenting |
|---|---|
| Spec has only text and REQ tables, lacks visual direction (**visual direction presentation**, `C28`) | Add Mermaid flow diagram + at least 1 **concrete I/O Snapshot** (ASCII wireframe / CLI / JSON sample) |
| ACs are generic words, missing Transparent Test Matrix (**visible test evidence**, `C29`) | Add Transparent Test Matrix stating `Concrete Input / Output & side effects / Tier & Fidelity (0 Mock or which mocks)` |
| Spec/Design uses advanced technical terms or mechanisms but the **Knowledge & technical decision explanation** was deleted or hidden in comments (`C31`) | Open comments, write the Technical Explanation Card explicitly: *What it is (with example) · Why needed (what breaks without) · How it runs (Input → Processing → Output) · Self-check ≤ 5 min · Source* + add terms to `docs/glossary.md` |
| REQ vague, contains unsourced numbers, or `Verified` label whose pointer lacks a quote | Find requirement/measurement basis; if none → `Unknown` + verification method, don't self-fill thresholds (`C31`) |
| AC ends with "works correctly" / ops command only checks exit 0 | Replace with HTTP code, error code, DB/file-generated data (**verify ops command effects**, `C19`) |
| "Out of scope" empty | Add at least 1 adjacent excluded item (later-phase part, external service, unbuilt screen) |
| `Ready` spec still has `[NEEDS CLARIFICATION]` | Revert to `Draft` or ask the user to resolve before presenting |
| Truth appears in 2 files | Pick 1 real source (spec/contract/`config.md`/`error-codes.md`), the other only gets a context pointer |
| File pointers in `AGENTS.md` are generic filenames | Rewrite as **conditional pointer** (`C24`): *"When touching `<branch X>` → read `<file Y>`"* |
| REQ inherited from `PK-*` still has `{param}` | Find a baselined value; if none → P-xx and keep Draft, don't guess to fit template |
| `Ready`/ready tasks/HANDOFF treated as code authority | Reconcile user commands and current batch; fix stop point (**per-batch execution authority**, `C30`) |
| Spec `Done` while ACs are `[~]` | Return to unfinished status; state who/how to verify, don't count as pass |
| Commands in `AGENTS.md` / `CONSTRAINTS.md` never tried | Try if safe; if unsafe → record "not run + reason" in the report |

## 3. Gate-2 report format

```markdown
## Self-check & challenge results (Gate 2)

Files written/edited: <list>

| Group | Pass | Fail | N/A |
|---|---|---|---|
| 1. AGENTS.md (incl. **no silent lowering** `C23`, `C24`, `C27`) | … | … | |
| 2. Spec & inherited Packs | … | … | |
| 3. Decisions, terms, Capability Map | … | … | |
| 3b. CI, config, CONSTRAINTS, gotchas | … | … | |
| 4–6. Locations, general quality, Levels 1–2 | … | … | |

Challenge mode run: <Cross-model: `<authoring model> → <challenging CLI model>` | Same-model clean session: `spec-challenger` — reason other model unavailable>

Self-fixed after challenge (Fixed):
- <file:line> — <finding> → <how fixed>

Findings kept / need user decision (Not Fixed — hiding findings forbidden):
- <file:line> — <challenger finding> → <reason kept or question for user>

Remaining questions: <list or "None">
```

 Send report, stop, wait for approval (Gate 2). Do not self-advance to Step 7.

## Check before done

- [ ] Ran the adversarial check with detached context (`C26`).
- [ ] Every `[ ]` item appears explicitly in the report.
- [ ] Every conclusion has file-path evidence.
- [ ] No new file forgotten (unreferenced, outside git).
- [ ] Checked `C30–C31`; AI challenge doesn't replace primary sources/tests/experts; a doc-check report doesn't prove the product is correct.
