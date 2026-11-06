---
name: starter-guide
description: Quick guide for beginners to the skill collection - grouped by level and usage situation. The AI automatically proposes the right skill.
license: MIT
trigger_phrases:
  - "skill guide", "which skill fits", "getting started with skills"
do_not_use:
  - "When you already know the specific skill", "When you need implementation details"
---

# Starter Guide - Quick Guide for Beginners

**For:** People new to using AI agents for coding, or who want a fast overview of how skills combine as a project grows.

**Most important:** You do **NOT** need to memorize skill names. The `auto-guide` skill detects the situation and proposes a fitting skill chain with reasons. You only need to describe your problem.

---

## 1. AI Auto-Routing (`auto-guide`) - You Just Speak

| You say to the AI | AI automatically proposes | Why |
|---|---|---|
| *"Fix this bug"* / *"Test is failing"* | `systematic-debugging`  `verification-before-completion` | Find root cause before fixing, then run tests to confirm |
| *"First time in this project"* (< 50 files) | `explore`  `writing-spec-simple` | Understand codebase architecture + create a light `AGENTS.md` for AI |
| *"First time in a large project"* (>= 50 files) | `explore`  `writing-spec-for-ai` | Survey + full docs standardization per Profile M/L |
| *"Implement feature X"* (multi-step) | `writing-plans`  code  `verification-before-completion` | Split tasks from spec/requirements before coding |
| *"Review this branch / PR"* | `code-review` | Parallel check on 2 axes: **Standards** (code style) and **Spec** (matches requirements) |
| *"Refactor this code"* | `safe-refactor` | Restructure while preserving behavior, with before/after tests |
| *"Write tests first, then code"* | `tdd` | RED  GREEN  REFACTOR flow |
| *"Done, please verify"* | `verification-before-completion` | Run real verification commands before claiming completion |

---

## 2. Three Skill Levels

### Basic (Beginner) - Daily Use
| Skill | When to use | Example phrase |
|---|---|---|
| `explore` | First time viewing code, don't know which file holds the logic | *"How does the login flow work in this repo?"* |
| `systematic-debugging` | Hit a bug, runtime error, or red test | *"Test `test_checkout` fails, find the cause"* |
| `code-review` | Review PR/branch before merge | *"Review branch `feat/login` against the spec"* |
| `verification-before-completion` | Finishing a task, need test/build evidence before commit | *"Check whether all AC criteria pass"* |

### Intermediate - When You Need a Standard Process
| Skill | When to use | Example phrase |
|---|---|---|
| `writing-spec-simple` | New or small project (`< 50` files) without `AGENTS.md` / specs | *"Write AGENTS.md and basic specs for this project"* |
| `writing-plans` | Have spec/requirements, need to split tasks before coding | *"Plan the order-management API implementation"* |
| `tdd` | Want tests before code | *"Use TDD for the shipping-fee feature"* |
| `git-workflow-and-versioning` | Split a messy working tree into atomic commits, resolve conflicts | *"Split current changes into proper commits"* |

### Advanced - When the Project Scales (Team / Production)
| Skill | When to use | Example phrase |
|---|---|---|
| `writing-spec-for-ai` | Medium/large projects (`>= 50` files, team `>= 3`), needs 3 review gates + Packs | *"Standardize the AI docs per Profile M for this system"* |
| `documentation-and-adrs` | Record architecture decisions (ADR) or public API changes | *"Write an ADR for choosing PostgreSQL over MongoDB"* |
| `safe-refactor` | Split large modules/classes without changing behavior | *"Safely extract `PaymentService` from `OrderController`"* |
| `dispatching-parallel-agents` | Run `2+` independent tasks in parallel with no shared state | *"Implement the notification and report modules in parallel"* |
| `incremental-implementation` | Roll out a large architectural change across phases with feature flags | *"Plan the phased auth-system migration"* |
| `security-audit` | Full security audit for APIs, permissions, data | *"Security-audit the payment flow and webhooks"* |

---

## 3. Scaling Path & Skill Combination Patterns

### 3.1 Combining Skills as the Project Grows
```text
Phase 1: < 50 files, 1-2 people
├── auto-guide  explore  writing-spec-simple  writing-plans  code  verification-before-completion
└── Light 3-step process, no formal 3 gates

Phase 2: 50-200 files, 3-5 people
├── auto-guide  writing-spec-for-ai (Profile M)  writing-plans  code  code-review  verification-before-completion
├── Add: documentation-and-adrs (for ADRs) + safe-refactor (for safe refactors)
└── Required: docs/progress.md (session memory C17) + docs/conflicts-and-bugs.md (bug ledger C18)

Phase 3: 200+ files, 5+ people
├── auto-guide  writing-spec-for-ai (Profile L + Packs: PK-API, PK-DB, PK-AUTH, PK-OBS, PK-SEC)
├── Add: using-git-worktrees + dispatching-parallel-agents (isolated parallel work)
├── Add: incremental-implementation (large rollout) + security-audit (security audit)
└── Required: formal 3 review gates (C02) + cross-model review (C26)
```

### 3.2 Four Common Integration Patterns
1. **Sequential Chain:**
   `explore`  `writing-spec-simple`  `writing-plans`  `code`  `verification-before-completion`
2. **Parallel Dispatch:**
   `writing-plans`  `using-git-worktrees`  `dispatching-parallel-agents`  `code-review`  `verification-before-completion`
3. **Feedback & Bug-Ledger Loop:**
   `code/test fails`  `systematic-debugging`  `fix`  log to `docs/conflicts-and-bugs.md` (`C18`)  `verification-before-completion`
4. **Upgrade Path (no data loss):**
   `writing-spec-simple`  keep `AGENTS.md` + `SPEC-*.md`  add `docs/specs/README.md`, `progress.md` (`C17`), `conflicts-and-bugs.md` (`C18`)  enable all 31 laws of `writing-spec-for-ai`.

---

## 4. Five Golden Rules & Quick Spec Evaluation Test

### Five Golden Rules
1. **NEVER** fix a bug before finding the root cause (`systematic-debugging`).
2. **NEVER** guess when requirements are ambiguous — the AI must stop and ask (`C30`).
3. **ALWAYS** run verification commands and show evidence before claiming done (`verification-before-completion`, `C29`).
4. **ALWAYS** record bugs/contract conflicts in `docs/conflicts-and-bugs.md` (`C18`) to avoid repeating them.
5. **ALWAYS** update the Spec when code behavior changes (`C11`).

### Quick 5-Question Test (Are You on the Right Track?)
1. Does the AI stop and ask when the spec is ambiguous instead of making things up?
2. Do the generated code and tests stick to the `AC-x` items in the Spec?
3. Are the Spec and `docs/conflicts-and-bugs.md` updated when code changes?
4. Does the team review Spec / Plan before coding?
5. Is starting a new session / onboarding a new person faster?

> If **`>= 4/5` answers are "Yes"**  the project is on the right track! See the detailed **Monthly Health Check** table in `writing-spec-simple/references/scaling-and-evaluation.md`.

## When NOT to Use

- When you already know the exact skill name and want to open that specific skill directly
- When you need to look up the full list of 50+ skills by keyword  open `cheat-sheet`
