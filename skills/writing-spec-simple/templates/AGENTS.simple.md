# AGENTS.md — <project name>

> Base: writing-spec-for-ai <version, e.g. v1.3.0> · Profile: <S | M | L> · Pack: <PK-… or "none">

<2–4 sentences: what the system does, for whom. Stack: <framework + major version>, <DB>, <FE>. Exact versions: see `package.json`, `.nvmrc`.>

## Commands

```bash
<install>
<dev>
<build>
<test>                       # all tests
<test-one> <path> -t "<name>" # single test — prefer while editing
<lint> && <typecheck> && <format:check>
```

## Source of Truth

| Priority | Doc | Content |
|---|---|---|
| 1 | `docs/decisions.md` | Confirmed decisions |
| 2 | `docs/specs/` | Requirements (REQ) and acceptance criteria (AC) |
| 3 | `CONSTRAINTS.md` *(if any)* | Quality floor and machine-checkable thresholds |
| 4 | `docs/conflicts-and-bugs.md` | Ledger of all bugs, contract conflicts (enum/API/DB/port), and project history lessons |
| 5 | `AGENTS.md` | Working rules |
| 6 | Existing code | Current state, not the standard |

- **When starting any task:** read `docs/specs/README.md`, the related spec, `docs/glossary.md`, `docs/conflicts-and-bugs.md` (if any), and the current execution batch in `docs/progress.md` (per-batch execution authority: only do what that batch records).
- **When finding or fixing any bug/hotfix/revert or contract conflict (enum, schema, port, API, config drift):** must append to `docs/conflicts-and-bugs.md` with commit SHA, root cause, and an automated blocking command before claiming done.
- **When adding/changing env vars:** update both `.env.example` and `docs/reference/config.md`.
- **When adding/changing returned error codes:** update `docs/reference/error-codes.md`.
- **When facts affecting behavior/risk are missing in scope:** state the unknown and how to verify; pause dependent parts, continue independent assigned parts (sources & knowledge limits: never guess facts).
- **When the user gives clear direction:** execute the full scope; don't re-ask granted permission. Current user direction takes priority.
- External skills/guides conflicting with project docs → follow project docs, per the table order above.

**Profile S:** if there is no `docs/` tree, read spec in `docs/spec.md` or README; write the current batch block directly in this file per the progress template fields. Only read files that actually exist; don't create extra docs just to satisfy pointers.

## Boundaries

[x] **Always**
- Write tests with code; test names contain the AC-ID.
- Run the DoD commands before claiming done.
- Mark `ceiling: <load threshold + upgrade path>` when deliberately choosing a simple solution with a known limit (in-memory lock, $O(n^2)$ scan, polling).
- <project-specific good habits, written as affirmations>

(warning) **Ask first if not yet approved in current direction/batch**
- Change data schema, public API, auth/permission mechanism.
- Change security-related defaults.
- Add dependencies (except types approved in plan/decision), upgrade framework major.
- Delete files, data, released migrations.
- Edit CI, rulesets, CODEOWNERS, `CONSTRAINTS.md`, this file.

(blocked) **Never**
- Commit secrets, `.env`, tokens; log tokens, passwords, Authorization headers.
- Commit personal agent files (`.claude/settings.local.json`, command allow-lists, machine paths, passwords in approved commands).
- Add check-silencing flags (`@ts-ignore`, `eslint-disable`, `# noqa`, `istanbul ignore`, `nosemgrep`, `gitleaks:allow`), add `.skip`, or delete assertions/lower thresholds to force green tests (no silent lowering of standards).
- String-concatenate SQL from input.
- Push directly/force-push protected branches, `--no-verify`, self-merge or self-approve PRs.

<Domain-specific deep rules go in `<dir>/AGENTS.md` or glob-scoped rules, not here.>

## One-Task Process

1. **Classify direction before deep reading or editing.** *Clear* (one understanding of the outcome, SPEC/AC or narrow scope identifiable, doesn't touch unapproved (warning) items)  proceed without re-asking. *Vague* (>= 2 interpretations yielding different outcomes, SPEC/AC and narrow scope unidentifiable, or touches unapproved (warning) items)  do targeted lookup to self-resolve; if still vague, return only a **quick lock ≤ 5 lines** (understood outcome · expected SPEC/file area · max 3 points to confirm, each with a proposed option) then stop, no file edits.
   Once clear: identify the spec, REQ/AC (if any; small work without spec gets explicit narrow scope and verification method) plus the user's real execution direction; record one current batch in `docs/progress.md`. `Ready`, plans, and ready task lists do not auto-grant code authority.
2. **Per-batch execution authority** — if the user hasn't stated batch boundaries: **when drafting/updating docs**, do one sub-step per turn then stop for review (5a: foundation cluster `AGENTS.md`/glossary/decisions · 5b: exactly **1 SPEC file** plus `docs/specs/README.md` update · 5c: 1 design file); don't write the whole `docs/` tree in one turn; **when coding**, default to **1 SPEC + 1 small verifiable task/AC**, do  check  report  stop. Explicit requests to do a whole spec/finite batch get exactly the assigned tasks/ACs completed within that scope.
3. Short plan: behavior, file area, tests, stop conditions. ~5 files is the expectation; fixing shared functions and necessary callers within the same behavior is allowed, record the impact.
4. Tests + code only within the permitted batch. Subagents only get work belonging to the batch; don't self-pick the next task/spec. New risks or unapproved behavior  update scope before doing that part.
5. **Independent challenge & self-fix before claiming done:** run the DoD commands, then hand `git diff` + `SPEC-xx` (without self-justification) to one independent review pass — prefer **cross-model** via another model's CLI (`codex exec --sandbox read-only...`, `claude`, `gemini` if available; close `stdin` to avoid hangs) or **clean same-model session** (subagent read-only when no other-model CLI exists) — to catch spec drift, missing edges, wrong mocks, or logic holes; fix real issues before reporting to the user.
6. Mark `[x]` ACs with evidence; update progress and move batch to `Awaiting verification`, report results, then stop at the recorded boundary. Commit/PR when assigned or per repo process.

**Batch report:** (1) observable result · (2) **plain-language technical explanation of what was just done** (what mechanism was used, why chosen, `Input  Processing  Output` flow tied to real project data so readers understand the AI-written code) · (3) **independent challenge report** (state the mode `Cross-model` or `Clean same-model`, list **every** finding under 2 headings: `Self-fixed` and `Not fixed / Needs decision` with reasons — hiding findings is forbidden) · (4) how to demo/verify commands and the test evidence table · (5) unverified items & the boundary stopped at. A new batch needs user direction defining scope; don't self-extend from the old batch's plan or handoff.

## Long Context & Compaction

- **When a batch ends, switching tasks, or the same error fails twice:** overwrite the *New-session handoff* section in `docs/progress.md` (for recurring errors record tried approaches and ruled-out ones), then remind in one line: prefer `/compact` or a new session instead of retrying on stale context.
- **When compacting context:** keep RUN-ID, edited files, verification commands, the latest unclosed error, and pending user questions.
- **After compaction or a new session:** re-read the current batch block in `docs/progress.md` before continuing. Conversation summaries are not source of truth and grant no extra authority: **batch authority and scope** always follow `progress.md`; if **file/test status** in the summary conflicts with `progress.md` (auto-compaction mid-batch), re-verify with `git status`/`git diff` and check commands, update `progress.md`, then continue.

## Definition of Done

- `<lint> && <typecheck> && <test> && <build>` all green (and meets `CONSTRAINTS.md` floor if any).
- Every AC claimed complete has a passing test with evidence; `[~]` means unverified — record reason + how to close.
- Evidence records the command and actual result or a log link; if not run, say not run — never paste expected output as a result. Compare expectations against confirmed examples/contracts (sources & knowledge limits). If the AI wrote both expectation and test, green only proves code matches the AI's expectation — prefer user-provided examples.
- **Print the test evidence table (Visible Test Execution Ledger):** when reporting a finished task or opening a PR, must print `AC-ID | Scenario run | Input fed | Actual Output & side effects | Fidelity (0 Mock or which mocks) | Result` so reviewers see exactly what was tested (never just *"All tests passed"*).
- Spec/decisions/progress updated; only move spec to `Done` when every AC of that spec is `[x]`. While `[~]` remains, keep `In progress` unless the user changes scope via `change-spec`.

## Code Conventions

Match `<path to canonical example file>`. Example:

```<lang>
<5–15 line snippet showing: naming, error handling, standard structure>
```

Error handling:
- On catch, rethrow (keep original error as `cause`) or log with context; never swallow silently.
- Internal error messages (5xx, stack, SQL) never go to client/end users.
- Best-effort work (cache eviction, stats, notifications) may skip on error but must log.

## Git

- Commit: `<type>(<scope>): <description> [SPEC-XXX]`.
- Branch: `<type>/<id>-<description>`, cut from `<integration branch>`; PR into `<integration branch>`.

## Repo Map

```
<1–2 level tree, one role per line>
```

## Base Overrides

<!-- Delete this section if nothing is overridden. Tightening rules: free. Loosening or removing base rules: requires a D-xx. -->

| Base rule | Override | Decision |
|---|---|---|
| `<base rule name, e.g. "Per-batch execution authority" / PK-…-Rnn>` | <loosen / remove: content> | D-xx |
