---
name: writing-spec-simple
description: Use when a project with fewer than 50 files needs lightweight AGENTS.md and feature specs, and lacks valid AI documentation.
license: MIT
trigger_phrases:
  - "write AGENTS.md", "standardize docs", "docs for AI", "new project"
do_not_use:
  - "When project >= 50 files", "When AGENTS.md already exists", "When only fixing a bug"
---

# Writing Spec Simple - Fast Docs Standardization for Small Projects

**Goal:** Create a lightweight doc set (`AGENTS.md`, `docs/decisions.md`, `docs/specs/SPEC-xxx.md`, `docs/conflicts-and-bugs.md`) so AI agents understand the project and code correctly — without the complex 3-gate process.

**When it activates:**
- First time working with a new project or a repo without `AGENTS.md`
- Small project (`< 50` files, 1-2 people) needing docs standardization in 15-30 minutes
- User says: *"write AGENTS.md"*, *"standardize docs for AI"*, *"write a simple spec"*

## When NOT to Use

- Only fixing a single bug or a small change with a known location → use `systematic-debugging` or fix directly
- Project already has a valid `AGENTS.md` and full `docs/specs/`
- Large project (`>= 50` files, team `>= 3` people, or needs parallel sub-agents) → use `writing-spec-for-ai` (Profile M/L)

---

## 1. Detection Rules & Auto-Proposal Template

| Rule | Detection signals | AI action |
|---|---|---|
| **Rule 1: First time in project** | User says *"first time in this project"*, *"look at this repo", no `AGENTS.md` | Propose chain: `explore` → `writing-spec-simple` |
| **Rule 2: Size tiering** | Count code files in repo (skip `node_modules`, `.git`, `dist`, `build`) | `< 50` files → `writing-spec-simple`<br>`>= 50` files → `writing-spec-for-ai` |
| **Rule 3: Direct request** | User says *"write AGENTS.md"*, *"standardize docs"*, *"create spec for new project"* | Run Step 1 of `writing-spec-simple` immediately |

When proposing this workflow, read the [proposal format](references/proposal-template.md).


## 2. Simple 3-Step Process

### Step 1: Project Survey (5-10 min)
The AI quickly scans the directory structure, `package.json` / `pyproject.toml` / `Cargo.toml`, and only asks the user what cannot be read from code:
- What is the project's core goal?
- What are the standard `build`, `test`, `lint`, `dev` commands?
- Are there implicit rules or technical constraints that must be followed?

> **Stop point 1:** Summarize survey results and wait for user confirmation before Step 2.

### Step 2: Propose Docs Structure (3-5 min)
The AI proposes the minimal file list based on real needs:
- `AGENTS.md` *(Required)* — project map, machine commands, source-of-truth order (`C01`), working rules.
- `docs/decisions.md` *(Recommended)* — record confirmed technical decisions (`D-01`, `D-02`).
- `docs/specs/SPEC-001-<feature-name>.md` *(When features exist)* — requirements and acceptance criteria (`AC-1`, `AC-2`).
- `docs/conflicts-and-bugs.md` *(Recommended, `C18`)* — ledger of bugs and contract conflicts so AI doesn't repeat them.
- `docs/glossary.md` & `CONSTRAINTS.md` *(Optional)* — only when the project has domain terms or special infrastructure constraints.

> **Stop point 2:** Wait for user approval of the file list before writing.

### Step 3: Write Each File & Verify (10-20 min)
- Use templates in `templates/` (`AGENTS.simple.md`, `SPEC.simple.md`, `decisions.simple.md`).
- **Execution rule (`C30`):** Write **1 file per turn**, stop for user review, then continue.
- **Every acceptance criterion (`AC`) must be testable (BDD `GIVEN / WHEN / THEN`):**

```markdown
### AC-1: Successful login with valid credentials
- **GIVEN** account `user@example.com` is activated in the system
- **WHEN** `POST /api/login` is sent with correct email and password
- **THEN** returns HTTP `200`, body contains `accessToken` (JWT), and test `test_login_success_AC_1` is recorded
```

- **After writing:** Run the commands in `AGENTS.md` (`C19`) and try one sample request (`C22`) to confirm the docs work.

---

## 3. Core Working Rules With Specs (`base-simple.md`)

See all 19 inherited laws in [`references/base-simple.md`](references/base-simple.md). Top 5 principles:
1. **Source-of-truth order (`C01`):** `docs/decisions.md` > `docs/specs/` > `docs/conflicts-and-bugs.md` > `AGENTS.md` > existing code.
2. **Never guess facts (`C30`):** When the spec is vague or missing facts, the AI must stop and ask, never fabricate requirements.
3. **Visible test evidence (`C13`, `C29`):** Before claiming done, run tests and output an `AC / Input / Output / Mock` table, not just `"All tests passed"`.
4. **Bug & conflict ledger (`C18`):** Every bug, hotfix, or contract drift (enum/API/DB/port) goes into `docs/conflicts-and-bugs.md` with commit SHA and a blocking check.
5. **Doc sync (`C11`):** Changing code behavior requires updating `SPEC-xxx.md` in the same work session.

---

For scaling, lossless upgrade steps and weekly checks, read [scaling and evaluation](references/scaling-and-evaluation.md).


## Skill Directory Structure

- `templates/AGENTS.simple.md` — `AGENTS.md` template inherited from `writing-spec-for-ai`
- `templates/SPEC.simple.md` — Feature spec template with `REQ`, `AC` (`GIVEN/WHEN/THEN`)
- `templates/decisions.simple.md` — Architecture decision log template (`D-xx`)
- `references/base-simple.md` — 19 core laws distilled from `base-kit.md`
- `references/scaling-and-evaluation.md` — Scaling Path, 4 Integration Patterns, Health Check 7 metrics & periodic plan
