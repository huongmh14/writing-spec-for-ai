---
name: auto-guide
description: Use when the user needs help choosing a workflow and has not named a skill or given clear technical direction.
license: MIT
trigger_phrases:
  - "which skill should I use"
  - "help me pick a skill"
  - "I'm <situation>"
do_not_use:
  - "When the user already named a specific skill"
  - "When the task is simple and needs no routing"
---

# Auto Guide - AI Auto-Routing

**Goal:** The user should NOT need to know which skill fits. The AI detects the situation and proposes a clear skill/option with reasons.

**When it activates:**
- User speaks generically: "fix this bug", "implement this feature", "look at this project"
- User does not mention a specific skill
- AI is unsure what the user wants  auto-guide activates

---

## Before proposing a route

MUST read [routing guidance](references/routing-guidance.md) before proposing: it contains selection rules, response formats, ambiguity handling and the checklist. Inspect at most 2-3 commands; give reasons and concrete next steps.


## Detection Rules — Situation Signals

### Signal 1: Bug / Error / Failure
**Keywords:** bug, error, fail, wrong, crash, 500, 404, broken
** Propose:** `systematic-debugging`

### Signal 2: First time in project / unfamiliar codebase
**Keywords:** new here, first time, don't understand, look at project, understand, explore, codebase
** Propose:** `explore`

### Signal 3: New project / no AI docs yet
**Keywords:** new project, AGENTS.md, docs for AI, standardize docs
**Detection:** Project < 50 files  `writing-spec-simple`, >= 50 files  `writing-spec-for-ai`
** Propose:** `writing-spec-simple` or `writing-spec-for-ai`

### Signal 4: Has requirements/spec to implement
**Keywords:** implement, feature, requirements, spec, design doc, plan
**Detection:** Small task  code directly, Large task  `writing-plans`
** Propose:** `writing-plans` or code directly

### Signal 5: Code review / PR / branch
**Keywords:** review, PR, branch, changes, diff, merge
** Propose:** `code-review`

### Signal 6: Refactor / restructure
**Keywords:** refactor, restructure, cleanup, organize, extract, split
** Propose:** `safe-refactor`

### Signal 7: Test-first / TDD
**Keywords:** TDD, test-first, red-green-refactor
** Propose:** `tdd`

### Signal 8: About to finish / needs verification
**Keywords:** done, complete, verify, check, confirm
** Propose:** `verification-before-completion`

### Signal 9: Demo / Fast / Prototype
**Keywords:** demo, fast, prototype, POC, quick test
** Propose:** `writing-spec-simple` (demo mode)

### Signal 10: New idea
**Keywords:** idea, concept, brainstorm
** Propose:** `idea-to-spec`

---

## Decision Tree

See details in `references/decision-tree.md`

---


## Examples

See details in `references/examples.md`

---


## When NOT to Use

- User explicitly names a specific skill
- User provides clear technical direction
- Simple one-off tasks where auto-detection adds overhead
