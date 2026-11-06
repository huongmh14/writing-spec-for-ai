# Skill Combination on Project Growth & Spec Effectiveness Evaluation

Reference doc for `writing-spec-simple`, `auto-guide`, and `writing-spec-for-ai`: growth roadmap (Scaling Path), integration patterns, lossless upgrade process (Zero-Loss Upgrade), and spec health metrics (Health Check).

---

## 1. Growth Roadmap (Scaling Path)

As the project grows in file count and team size, the skill system upgrades through 3 phases without rewriting docs from scratch:

```
Phase 1: < 50 files, 1-2 people (Quick start / Prototype / Small project)
├── 1A (Beginner): auto-guide  explore  writing-spec-simple  writing-plans  code  verification-before-completion
├── 1B (Needs strict contracts): writing-spec-for-ai (Profile S) + docs/conflicts-and-bugs.md (C18)
└── Process: Light per-step approval (3 steps), 18 core laws applied (references/base-simple.md)

Phase 2: 50-200 files, 3-5 people (Growth / Small team)
├── Main flow: auto-guide  writing-spec-for-ai (Profile M)  writing-plans  code  code-review  verification-before-completion
├── Add: documentation-and-adrs (records ADRs into docs/decisions.md)
├── Add: safe-refactor (behavior-preserving refactor with protective tests)
└── Required: Session memory docs/progress.md (C17) + Bug & conflict ledger docs/conflicts-and-bugs.md (C18)

Phase 3: 200+ files, 5+ people (Large system / High-scale production)
├── Main flow: auto-guide  writing-spec-for-ai (Profile L + Packs)
├── Enable domain Packs: PK-API, PK-DB, PK-AUTH, PK-OBS, PK-UI, PK-E2E, PK-SEC
├── Add: using-git-worktrees + dispatching-parallel-agents (isolated parallel runs)
├── Add: incremental-implementation (large rollout with feature flag / canary / rollback)
├── Add: security-audit (security audit before release)
└── Required: formal 3 review gates (C02) + cross-model/clean-session review (C26) + technical explanation cards (C31)
```

### Quick Comparison of 3 Phases

| Criteria | Phase 1 (`< 50` files, 1-2 people) | Phase 2 (`50-200` files, 3-5 people) | Phase 3 (`200+` files, 5+ people) |
|---|---|---|---|
| **Spec-writing skill** | `writing-spec-simple` *(or Profile S)* | `writing-spec-for-ai` (**Profile M**) | `writing-spec-for-ai` (**Profile L + Packs**) |
| **Laws applied** | 18 core laws (`base-simple.md`) | Full 31 laws (`base-kit.md`) | 31 laws + per-`PK-*` pack laws |
| **Approval mechanism** | Direct approval after each step (3 steps) | 3 gates + 2-axis `code-review` | 3 gates + cross-model review (`C26`) |
| **Memory & bug ledger** | `AGENTS.md` + `decisions.md` *(encourage `conflicts-and-bugs.md`)* | Required `progress.md` (`C17`) + `conflicts-and-bugs.md` (`C18`) | Required `C17` + `C18` + automated verification (`validate.ps1`) |

---

## 2. Skill Integration Patterns

### Pattern 1: Sequential Chain (Standard flow for new features)

```
explore  writing-spec-simple  writing-plans  code (or tdd)  verification-before-completion
```

- **When to use:** First time in a project or building a feature end-to-end.
- **Handoffs:**
  1. `explore` outputs directory structure + entry points.
  2. `writing-spec-simple` standardizes `AGENTS.md` and `docs/specs/SPEC-xxx.md` (with `REQ-xxx`, `AC-x`).
  3. `writing-plans` splits `SPEC-xxx` into small testable tasks.
  4. `verification-before-completion` runs real build/test commands and outputs the `AC-x` evidence table (`C29`).

### Pattern 2: Parallel Dispatch (Isolated parallel branches)

```
writing-plans  using-git-worktrees  dispatching-parallel-agents  code-review  verification-before-completion
```

- **When to use:** `2+` independent tasks/specs touching no shared files or state.
- **Safety rules:**
  - Each subagent runs on its own git worktree/branch or disjoint file scope, in a clean session (`fork_turns="none"`).
  - Before merge, run `code-review` on both axes: **Standards** (complies with `AGENTS.md`/`CONSTRAINTS.md`) and **Spec** (meets all `AC-x`).

### Pattern 3: Feedback & Bug-Ledger Loop (Anti-recurrence bug loop)

```
code / test fails  systematic-debugging  fix + regression test  log to docs/conflicts-and-bugs.md (C18)  update spec (if AC missing)  verification-before-completion
```

- **When to use:** Whenever tests go red, runtime errors, contract drift (enum/API/DB/port), or revert/hotfix is needed.
- **Hard rules:**
  - **Never guess-fix blindly:** Must pass Phase 1 of `systematic-debugging` to find the root cause.
  - **Never let an error recur twice (`C18`):** Log to `docs/conflicts-and-bugs.md` (symptom, root cause, commit SHA, blast radius, automated blocking check).
  - **Spec sync (`C10`, `C11`):** If the bug came from a missing spec constraint or a hotfix changed behavior, add the `AC` to the spec within 1 workday.

### Pattern 4: Zero-Loss Upgrade Path (`writing-spec-simple`  `writing-spec-for-ai`)

```
writing-spec-simple ──(exceeds 50 files / >= 3 people / needs Packs)──► writing-spec-for-ai (Profile M/L)
```

- **When to upgrade:**
  1. Repo exceeds `50` files or has `3+` members editing concurrently.
  2. Multiple AI agents need to run in parallel (`dispatching-parallel-agents`).
  3. API/DB/Auth contract drift appears, needing `PK-API`, `PK-DB`, `PK-AUTH`.
- **4-step lossless upgrade:**
  1. **Keep 100% of written files:** `AGENTS.md`, `docs/decisions.md`, `docs/glossary.md`, and `docs/specs/SPEC-*.md` stay unchanged because `writing-spec-simple` shares the template structure with `writing-spec-for-ai`.
  2. **Add the 3 coordination files of the full version:**
     - `docs/specs/README.md`: index table and status of all `SPEC-xxx` (`Draft` / `Ready` / `In progress` / `Done`).
     - `docs/progress.md` (`C17`): current session stop point and per-batch execution authority (`C30`).
     - `docs/conflicts-and-bugs.md` (`C18`): bug and contract-conflict ledger.
  3. **Upgrade laws from 18  31 (`base-simple.md`  `base-kit.md`):**
     - Enable 3 review gates (`C02`), running-spec change process (`C09`), 1-day hotfix exception (`C10`), cross-model/clean-session review (`C26`), and technical explanation cards (`C31`).
  4. **Run automated verification:**
     - Run `scripts/validate.ps1` to check all IDs (`SPEC-xxx`, `AC-x`, `D-xx`), line lengths, and cross-links.

---

## 3. Are You on the Right Track & How to Improve Specs

### 3.1 Positive Signals

- [x] **Specs have living, verifiable structure:**
  - `AGENTS.md` has `build` / `test` / `lint` commands that actually run (`C19`).
  - Each spec has an ID (`SPEC-001`), clear requirements, and acceptance criteria (`AC-1`, `AC-2`) in `GIVEN / WHEN / THEN` form linked to test function names (`C04`).
  - Spec status follows the lifecycle (`Draft`  `Ready`  `In progress`  `Done`).
  - Architecture decisions go to `docs/decisions.md` (`D-xx`), historical bugs to `docs/conflicts-and-bugs.md` (`C18`).
- [x] **Disciplined AI, no guessing:**
  - AI reads `AGENTS.md`, `docs/decisions.md`, `docs/specs/` before editing code (`C01`).
  - On vague requirements or missing facts, AI stops to ask or states assumptions for approval (`C30`), never fabricating requirements.
  - When claiming done, AI always outputs the test evidence table (`input / output / mock`, `C29`), not just `"All tests passed"`.
- [x] **Team alignment & low friction:**
  - Specs approved before coding; code reviewed against spec (`code-review` Spec axis).
  - Behavior changes update the spec first (`C09`); urgent hotfixes backfill spec and `conflicts-and-bugs.md` within 1 day (`C10`, `C18`).
- [x] **Quality metrics improving:**
  - Regression and contract-drift bug rates drop noticeably.
  - Onboarding time for new members or new AI sessions drops thanks to `AGENTS.md` + `progress.md`.
  - Code reviews focus on design/architecture instead of catching basic logic drift.

### 3.2 Warning Signals & Fixes

| Symptom group | Concrete signs | Immediate fix |
|---|---|---|
| [] **Empty / stale specs** | Spec has only `[TODO]` placeholders; code changed but spec didn't; AI ignores spec and codes by feel. | Run `scripts/validate.ps1`; apply `C01` (Spec > Code) and `C11` (behavior change requires spec update in same PR). |
| [] **Over-engineered specs** | Specs hundreds of lines of prose, drilling into implementation (HOW instead of WHAT); writing spec takes longer than code. | Trim to observable behavior (`GIVEN/WHEN/THEN`); move repeated rules to linter/tests (`CONSTRAINTS.md`), delete excess prose. |
| [] **Unused specs (dead docs)** | New code has no `[SPEC-xxx]` tag; AI doesn't read spec at task start; PR reviews don't check `AC-x`. | Check conditional pointers in `AGENTS.md` (`C24`: *"When touching X  read Y"*); use `code-review` Spec axis before merge. |
| [] **Heavy process (high friction)** | Small project (`< 50` files) forced through all 3 formal gates + sub-agents, clogging review queues and pushing the team to bypass rules. | Downgrade to **Phase 1 (`writing-spec-simple` or `Profile S`)**; only enable formal 3 gates when the project truly reaches Phase 2/3. |

---

## 4. Periodic Health Check Table

Evaluate **once a month** (or after each release milestone):

| Metric | Good | Warning | Bad | How to Measure in Repo |
|---|---|---|---|---|
| **1. Spec coverage** | `> 80%` features have specs | `50-80%` | `< 50%` | Ratio of new features/PRs with a `SPEC-xxx` file or `AC-x` update. |
| **2. Spec-to-code sync** | `< 5%` drift | `5-20%` drift | `> 20%` drift | Run `scripts/validate.ps1` + check that `[x]` ACs have tests matching current behavior. |
| **3. AI spec adherence** | `> 90%` spec-correct | `70-90%` | `< 70%` | Ratio of AI-coded PRs passing the Spec axis in `code-review` on first try with `C29` evidence. |
| **4. Bug & regression rate** | Down vs last month | Flat | Up | New / recurring bugs logged in `docs/conflicts-and-bugs.md` (`C18`). |
| **5. Onboarding / context time** | Down `> 50%` | Down `20-50%` | No drop | Time (or prompt count) for a new member / new AI session to understand the repo and finish the first task. |
| **6. Team satisfaction** | `> 4/5` | `3-4/5` | `< 3/5` | Quick survey on clarity and usefulness of `AGENTS.md` + `docs/specs/`. |
| **7. Process friction** | Low (`15-30min`/spec) | Medium | High (`> 2h`/spec) | Spec approval wait time; if friction is `High` on a small project  simplify to `writing-spec-simple`. |

---

## 5. Periodic Action Plan

### Weekly (5 minutes)
- [] **Spec sync:** Did this week's features/hotfixes update `AC` status (`[]`  `[x]`) and `docs/conflicts-and-bugs.md`?
- [] **AI discipline:** Does the AI read `AGENTS.md` + `SPEC-xxx` before coding and output the test evidence table (`C29`) before claiming done?
- [] **Unblock early:** Any bugs caused by missing edge cases or vague specs? If so, add a new `AC` immediately.

### Monthly (15 minutes)
- [] **Run Health Check:** Score the 7-metric table in Section 4 and run `scripts/skill-health-check.sh` + `scripts/validate.ps1`.
- [] **Evaluate routing (`auto-guide`):** Does the AI auto-propose the right skill per situation? Any place where the user still has to guess the skill?
- [] **Collect team feedback:** Which parts of `AGENTS.md` or `SPEC` are verbose and unread  cut them or convert to automated checks.

### Quarterly (30 minutes)
- [] **Evaluate scale-up:** Has the project exceeded `50` files or `3+` people? Time to upgrade from `writing-spec-simple` to `writing-spec-for-ai` (Profile M/L) per **Pattern 4**?
- [] **Evaluate domain packs:** Need to enable more specialized packs (`PK-API`, `PK-DB`, `PK-AUTH`, `PK-OBS`, `PK-UI`, `PK-E2E`, `PK-SEC`)?
- [] **Project memory hygiene (`C17`):** Archive old `docs/progress.md` history to `docs/progress-archive/` to keep `progress.md <= 5 KB`.

---

## 6. Quick Test (5 Yes/No Questions in 1 Minute)

Use these 5 **Yes / No** questions to self-check anytime:

1. **On vague requirements or missing facts, does the AI stop to ask (or note assumptions for approval `C30`) instead of guessing/fabricating code?**
   - `Yes`  **Good** (AI respects knowledge boundaries, doesn't fabricate requirements).
   - `No` (AI guesses/fabricates)  **Bad** (Tighten the no-guessing rule in `AGENTS.md`).
2. **Do generated code and tests stick to the acceptance criteria (`AC-x`) in the Spec?**
   - `Yes`  **Good**
   - `No`  **Bad** (Spec isn't being read by AI or `AC` is too vague, missing `GIVEN/WHEN/THEN`).
3. **When code behavior changes or hotfixes happen, are the Spec and `docs/conflicts-and-bugs.md` updated alongside?**
   - `Yes`  **Good**
   - `No`  **Bad** (Spec is rotting into a dead document — violates `C10`/`C11`/`C18`).
4. **Does the team (or you) approve Spec / Plan before letting the AI write code at scale?**
   - `Yes`  **Good**
   - `No`  **Bad** (Skipping approval gates makes fixing wrong code far costlier than fixing spec).
5. **Is starting a new AI session (or adding a new member) faster and less re-explanatory than before?**
   - `Yes`  **Good**
   - `No`  **Bad** (`AGENTS.md` or `docs/progress.md` isn't capturing the core info).

### Quick Test Conclusion:
- **`4-5/5` "Yes":** The Spec & Skills system is working very well — keep the current pace.
- **`3/5` "Yes":** On the right track but fix 1-2 "No" points per the Section 3.2 table.
- **`0-2/5` "Yes":** Stop and adjust — check whether the Spec is over-heavy (downgrade to `writing-spec-simple`) or too thin (add `AGENTS.md` + tested `AC`s).
