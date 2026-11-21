---
name: fast-track
description: Use when a project is an experiment or research loop (results change the plan daily) and the full 3-gate process would slow it down.
license: MIT
trigger_phrases:
  - "research project docs"
  - "experiment workflow"
  - "no gates"
do_not_use:
  - "Product with stable requirements, a team, or a release contract  use writing-spec-for-ai"
  - "Project < 50 files without experiments  use writing-spec-simple"
---

# Fast Track — Docs for Experiment / Research Projects

Evidence: in a measured research project the user removed subagents and review gates by hand and wrote "measure progress by what was learned, not by number of docs". This skill makes that choice official instead of forcing users to strip the full process.

## When NOT to Use

- Stable requirements, several contributors, external release or acceptance contract  use `writing-spec-for-ai`.
- Fewer than 50 files and no experiments  use `writing-spec-simple`.

## Keep (3 files, nothing else is required)

1. `AGENTS.md` ≤ 60 lines: current goal, run/test commands, data-leak rules, "what counts as a result".
2. `docs/progress.md` ≤ 5 KB: per experiment `hypothesis → run → result (number) → next decision`, plus stop point. Old entries go to `docs/progress-archive/`.
3. `docs/conflicts-and-bugs.md`: each entry has date, root cause, fix, a runnable check, and commit SHA or `no commit: <reason>`.

## Skip

- Gate 1–3, per-spec checkpoints, `spec-challenger`, `doc-tester`.
- `SPEC-xx` files: put an AC in `progress.md` only when the experiment needs a pass/fail line.

## Rules that still apply

- Never fabricate results: a claim carries `Verified` + a command or file pointer, else `Unknown`.
- Do not replace a real run by a mock and report the score as a model result.
- Dated docs are history, not constraints; `AGENTS.md` is the only standing rule set.
- Docs/code line ratio > 2 or two files on one topic (e.g. `X.md` and `X-design.md`)  merge before writing more.

## Graduate to the full process when

A result is promoted to a product, a second contributor joins, or the same rule is broken twice  switch to `writing-spec-for-ai` Profile S/M and keep these 3 files as inputs.
