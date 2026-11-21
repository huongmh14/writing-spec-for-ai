---
name: writing-spec-for-ai
description: Use when starting a project that lacks AI documentation, or when the user requests project specs, AGENTS.md, or standardization of scattered agent docs.
license: MIT
trigger_phrases:
  - "write a spec for the project"
  - "write AGENTS.md"
  - "standardize docs for agents"
  - "start a new project"
do_not_use:
  - "Small projects < 50 files → use writing-spec-simple instead of the full kit"
  - "User only has a vague idea → use idea-to-spec first"
  - "Only fixing a bug or small task → systematic-debugging; experiment/research loop → fast-track; no specs"
---

# Writing Spec For AI

Goal: a doc set that helps every AI agent **follow the rules, prove its own completion, and know when to stop on ambiguity** — and as short as possible.

This skill is a **coordinator**. **Read on demand (context economy, `C17`):** each turn opens **only the one sub-skill of the current step** in [skills/](skills/) and the matching template in [templates/](templates/); **forbidden to pre-read** the next step's sub-skill or **bulk-load** [references/principles.md](references/principles.md), [references/base-kit.md](references/base-kit.md), [references/research-controlled-execution.md](references/research-controlled-execution.md), or the whole `packs/` directory (look up single entries only when stuck: [glossary](references/glossary.md), [examples](references/examples.md)).

## Hard Rules

1. **Default three gates:** proposal (Gate 1) → doc challenge (Gate 2) → doc testing (Gate 3) → code. Only explicit user direction may adjust the process/scope; never turn assumptions into evidence and never re-ask granted permission.
2. **Never fabricate requirements.** Cannot be derived from the repo or the user → `[NEEDS CLARIFICATION: …]` + open question.
3. **One truth, one place.** Elsewhere only point via link/ID; conditional pointers go at the top, e.g. *"When editing API → read …"* (**conditional pointer**, `C24`).
4. **Level 0 always; levels 1-2 and Packs only on signal**, record the signal.
5. **Short without lowering standards:** `AGENTS.md` ~≤ 150 lines (kit convention, not sourced); never disable checkers or lower thresholds to pass (**no silent lowering of standards**, `C23`).
6. **Write so non-experts can approve:** language follows the user; IDs, commands, filenames stay verbatim. **Meaning before code:** first mention of a law in each file uses its short name then the code; files in `templates/` contain no `Cxx` law codes.
7. **Per-batch execution authority (`C30`):** `Ready` and Gate-1 approval are not blanket write permission. **Writing docs (Step 5):** each turn does **one sub-step** then stops for review: 5a foundation cluster, 5b **exactly 1 `SPEC-xx` file** (+ `specs/README.md`), 5c 1 design file. **Writing code (Step 8):** default 1 spec, 1 small verifiable task/AC; record stop point in `docs/progress.md`, report evidence then stop.
8. **Sources, technical explanation, and knowledge limits (`C31`):** the user decides behavior/scope; the AI verifies technical claims via repo, official sources, and experiments. Every key claim carries 1 of 4 labels `User decided / Verified / AI proposed / Unknown`; `Verified` must include an openable pointer (`path:line`, URL + verbatim quote, or command + result). Every advanced concept/mechanism or technical decision the AI introduces must come with a **Technical Explanation & Decision Card** shown explicitly (*What it is + example · Why needed / what breaks without it · How it runs · Self-check ≤ 5 min · Source & limits*) so the user understands the knowledge the AI wrote and verifies via the `Self-check` step; security/payment/legal areas → note "needs expert". Never self-score confidence %, never fabricate NFRs; don't use a second AI's praise/agreement as correctness evidence (`C31`), but **must use a clean session / second model (e.g. `codex` read-only or `spec-challenger`) to cross-check and self-fix before presenting to the user (`C26`)**.
9. **Profile S:** every `docs/specs/` pointer → `docs/spec.md`/README, `docs/progress.md` → batch block inside `AGENTS.md`; glossary/decisions/plan files are read only when present. Apply this mapping in every sub-skill/adapter; don't generate extra files to satisfy pointers.
10. **Lenses instead of personas:** each step starts with `Lens: <≤ 3 items> — because <real signal>` per [references/lenses.md](references/lenses.md); never use "you are a senior…" to replace checklists; users may add/remove. Decisions with ≥ 2 hard-to-reverse options → [skills/explore-options](skills/explore-options/SKILL.md): the user chooses, the AI doesn't self-decide.

Before each gate, MUST read [red flags and mandatory responses](references/anti-rationalization.md).

## Process — each step opens its own sub-skill / subagent

| Step | Work | Sub-skill / Subagent | Gate |
|---|---|---|---|
| 1–2 | Survey project, gather evidence, determine level 0/1/2, Profile & Pack | [skills/survey-project](skills/survey-project/SKILL.md) · subagent [`spec-surveyor`](agents/spec-surveyor.md) | |
| 3 | Propose docs design + Capability Map (no repo files yet) | [skills/propose-doc-design](skills/propose-doc-design/SKILL.md) | **Gate 1 — wait for approval** |
| 4 | Clarify questions only the user can decide (Frontier) via hypothesis + pre-guessed answer (`HYPOTHESIS/GUESS`); answers → `D-xx` or spec | (rules inside `propose-doc-design` §3) | |
| 5a | Write foundation cluster: `AGENTS.md` (+ `CONSTRAINTS.md`), `glossary`, `decisions` | [templates/](templates/) + `principles.md` §4.2 | **Checkpoint 5a — wait for review of this file cluster** |
| 5b | Write `specs/README.md` + **exactly 1 `SPEC-xx` file next in line** (one spec at a time) | [skills/write-spec](skills/write-spec/SKILL.md) | **Checkpoint 5b — wait for review of each spec** |
| 5c | Write **1 design doc** when signaled (design glossary terms: [glossary](references/glossary.md)) | [skills/write-design-doc](skills/write-design-doc/SKILL.md) | **Checkpoint 5c — wait for design review** |
| 6 | Adversarial challenge & checklist scoring | [skills/review-docs](skills/review-docs/SKILL.md) · subagent [`spec-challenger`](agents/spec-challenger.md) | **Gate 2 — wait for approval** |
| 7 | Test docs with 2–3 sample tasks in a clean session | [skills/test-docs](skills/test-docs/SKILL.md) · subagent [`doc-tester`](agents/doc-tester.md) | **Gate 3 — wait for approval before coding** |
| 7.5 | Choose slices, ACs, verification, stop points; separate plan/verify skill only when needed | [skills/plan-tasks](skills/plan-tasks/SKILL.md) · [skills/generate-verify-harness](skills/generate-verify-harness/SKILL.md) | |
| 8 | Code per the doc-defined process; manage spec changes | [skills/change-spec](skills/change-spec/SKILL.md) | |

Cross-step rules:

- Step 4: state hypothesis (`HYPOTHESIS`) + evidence and gaps; max 3 questions about outcomes/trade-offs only the user can decide (**Frontier**), each with a proposal. Deep technical matters can be delegated — the AI researches within the granted scope (`C31`).
- Step 5: copy templates from `templates/`, fill real values, delete inapplicable parts; no placeholders in deliverables; commands in `AGENTS.md` / `CONSTRAINTS.md` must actually run. New specs start `Draft`; brownfield specs start `As-built` with evidence; only the user moves to `Ready`.
- Step 8: discovering docs are wrong/missing while coding → stop, propose doc fix first; a `Done` spec goes through [skills/change-spec](skills/change-spec/SKILL.md).

## After Coding (Maintenance)

- A rule violated ≥ 2 times → move into `CONSTRAINTS.md` / lint / test / hook, error messages cite law ID + fix; trim prose.
- A process repeated ≥ 2 times or needing automated runtime verification → use [skills/generate-verify-harness](skills/generate-verify-harness/SKILL.md) or [templates/project-skill](templates/project-skill/SKILL.md).
- Hard bugs encountered, contract conflicts (enum/API/DB/port), hotfixes or reverts → must record in `docs/conflicts-and-bugs.md` with commit SHA, root cause, machine-blocking check, and last-verified date (**dated bug & conflict ledger**, `C18`); unfixed ones get an issue. Tag every ledger record and milestone report with a kit signal (`references/kit-evidence.md`) so the kit can be judged later.
- Long sessions: before compaction or a new session, write decisions into `decisions.md`, stop point and handoff into `progress.md` (**session memory**, `C17`; single file, no separate `HANDOFF.md`). Context-length measurement is the AI tool's job, not the kit's.
- Finishing P-xx → convert to D-xx or delete. A spec only reaches `Done` when every **must** AC of that spec is `[x]` with evidence, not just the batch's ACs; `[~]` is unverified. Mark each AC `must` or `later`; `later` ACs move to the backlog and do not block `Done` (measured: 100–317 open ACs per project made `Done` unreachable).
