# Base kit — the 100%-inherited part and the base development direction for every project

> Status: **`v1.3.0` approved 2026-10-20**. Phase 1 finished at `v1.0.0`, phase 2 at `v1.1.0`, inheritance of the Plugin/Skill ecosystem at `v1.2.0`, the Visual Direction & Test Transparency upgrade at `v1.3.0` (see [CHANGELOG.md](../CHANGELOG.md)). Changes not yet released are written below and are **not yet approved**.
> Source: a survey of 9 repos (dashboard, notification-service, khaosatvmu, cdn, BotAutoTask, citad-*, vmu-deploy-tool) — the author's internal repos, which outsiders cannot verify; use them as illustrative anecdotes, not as statistics. Cross-checked against [principles.md](principles.md) and the author's locally installed 7 Plugins / 210 Skills (reference skills — origin of ideas, not evidence).
> This file is the **registry of Core (C-xx) and Pack (PK-…) IDs** + the reasons for inheriting. *How to write* still lives in `principles.md`, `templates/`, `skills/`. Kit terms: [glossary.md](glossary.md).
> Unreleased fix of 2026-10-26: added **per-batch execution authority** (`C30`) and **sources & knowledge limits** (`C31`), fixed `C03/C05/C13`, dropped rule number 32 (see the table in §3); research and the limits of the evidence are in [research-controlled-execution.md](research-controlled-execution.md).
> The numeric thresholds in this file (≤ 1 working day, ≤ ~5 KB, ≤ 90 days, ≤ 60 lines...) are **conventions of the kit**, with no measured source.
> How to apply it for Profile S (no extra docs tree): see [profiles.md](../profiles.md).

## Table of contents

1. Survey of 9 projects
2. The "100% inherited" criterion and the 4 tiers
3. Core tier — inherited verbatim (`C01–C31`)
4. Parameter tier — fixed frame, own values
5. Errors repeated across projects (evidence for Core)
6. Pack tier — conditional inheritance (`PK-*`)
7. Customization model
8. Development roadmap
9. Deliberately not doing
10. Clarifications
11. Open questions

---

## 1. Survey of 9 projects

| Repo | Files (git) | Stack | Docs for AI / spec | CI | Commits | Suggested profile |
|---|---|---|---|---|---|---|
| dashboard | 695 | NestJS + Quasar + Prisma, monorepo | `AGENTS.md`, `CLAUDE.md`, `decisions.md`, specs with IDs | ci, deploy, release, pr-policy, rulesets, commitlint, husky, CODEOWNERS | Conventional + `[SPEC-X]` | L |
| notification-service | 366 | NestJS + Prisma + Redis + RabbitMQ (+ legacy .NET) | `SPECS/WORKFLOW/CONVENTIONS/ARCHITECTURE/PRODUCT.md`, `features/v2/`, `knowledge.md` | (warning) `ci.yml` calls `Notification.slnx`, which is no longer in the repo | Conventional | M |
| khaosatvmu | 617 | .NET (sln) + React/Vite + worker | Only docs explaining the algorithm | deploy | Mixed (`new fix 2509`) | M |
| cdn | 111 | Fastify 5 + Kysely + PG + Redis + RustFS | `SPECS/WORKFLOW/CONVENTIONS/ARCHITECTURE.md`, `features/v1/`, skill, `.devin/TASK.md` | None | Mixed (`fix`, `update ...`) | M |
| BotAutoTask | ~75 | Node ESM + Cloudflare Workers/D1 | `docs/feature/01–08`, research; `AGENTS.md` | Build only on tag | Conventional | M |
| citad-vmu-resources | 68 | Node + ESLint | None | docker-release (tag `release/v*`) | Free-form Vietnamese | M |
| citad-crawler-work-schedule | 15 | Python | README | None | Free-form Vietnamese | S |
| citad-postgresql | 9 | Docker Compose PG | README | None | Free-form | S |
| vmu-deploy-tool | 8 | Shell + crontab | README | None | Free-form | S |

**Conclusions:**

1. **What exists in every repo is only:** README, a sample env file, Docker/Compose, git. So the "100%" part must be usable even by an 8-file repo. Anything that makes a small repo carry the cost of a large repo is not 100%.
2. **Two doc lineages have formed on their own.** The *cdn / notification* lineage consists of `SPECS / WORKFLOW / CONVENTIONS / ARCHITECTURE / features/vN`. The *dashboard* lineage consists of `AGENTS / decisions / specs with IDs`, which is the lineage this skill set follows. The cdn/notification lineage has 4 things the dashboard lineage lacks:
   - AI permissions by spec status;
   - the hotfix exception;
   - the environment-variable table;
   - the "what changes → which file to edit" matrix.
3. **The same error repeats in ≥ 2 repos (§5).** That is the strongest evidence for putting a rule into Core.

## 2. The "100% inherited" criterion and the 4 tiers

A component enters **Core** when it meets all 4 conditions:

1. Independent of the stack (Node, Python, .NET, shell can all use it).
2. Independent of the business domain.
3. Independent of scale (an 8-file repo can use it without it feeling excessive).
4. Has evidence: the error occurred in ≥ 2 projects, or it appears in the standard sources in principles §8 (local skills/plugins are only the origin of an idea and do not count as evidence).

| Tier | Inheritance | What the project may do | Example |
|---|---|---|---|
| **Core** | 100% verbatim | Override only under the §7.3 rule | Source-of-truth order, ID system, AI permissions by status, anti-lowering of standards |
| **Parameter** | 100% frame | Fill in values | Commands, the run-1-test command, integration branch, docs language |
| **Pack** | 100% *when enabled* | Choose packs by signal, fill in parameters | HTTP API, tokens/keys, DB migration, observability, UI/E2E, background jobs, Docker release, AI agent |
| **Project** | 0% | Write new | Business REQs, terms, decisions, architecture |

## 3. Core tier — inherited verbatim (`C01–C31`)

The "WSFA" column says where the rule lives in this skill set. The "Evidence / origin of idea" column: repo names are internal repos (§1); local skill/plugin names (e.g. `constraint-driven-development`, `ponytail`) are reference skills — origin of ideas, not evidence.

| # | Component | Mandatory content | WSFA | Evidence / origin of idea |
|---|---|---|---|---|
| C01 | Source-of-truth order | `decisions.md` > specs > `CONSTRAINTS.md` (if present) > `AGENTS.md` > existing code; outside skills/guidance lose to project docs; when ambiguous, stop | Yes — principles §1 | dashboard; notification claims "Single Source of Truth" in 2 files (§5) |
| C02 | Three approval gates | Proposal → docs → docs test → only then code | Yes — SKILL.md | dashboard |
| C03 | **AI permissions by spec status** | `Ready` means approved requirements; execution authority must be scoped per `C30`. No code while a spec is `Draft`; a deviation from requirements goes through change-spec | `templates/docs/specs/README.md` | notification `WORKFLOW.md` §1–2; the run-control fix |
| C04 | ID system + traceability | `SPEC-X`, `X-Rnn`, `X-ACnn`, `D-xx`, `P-xx`, `CHG-xx`; test names contain the AC-ID; commits `[SPEC-X]`; never renumber | Yes — principles §3 | dashboard; cdn `EC-xx` has no end-to-end ID so tests cannot be traced |
| C05 | AC status | `[ ]` not met; `[x]` has green-test evidence; `[~]` not verified, with a reason + who/how to close, blocks `Done` | Yes | dashboard; separates done from unverified |
| C06 | Mandatory spec sections | Goal, in/out of scope (not empty), EARS REQs, NFR or `N/A — reason`, edge cases, ACs, e2e check, open questions ("None") | Yes — `templates/docs/specs/_template.md` | cdn, notification: specs have no open questions |
| C07 | Decisions are append-only | A status column, the current identifier, P-xx | Yes — `templates/docs/decisions.md` | dashboard |
| C08 | Glossary | Term / definition / do not call it / name in code | Yes | — |
| C09 | Changing a spec that already ran | `CHG-xx` for a spec that is `Done`; for mostly-new parts create a child spec | Yes — `skills/change-spec` | dashboard |
| C10 | **Hotfix exception** | A hotfix may change code first; the spec must be updated within ≤ 1 working day; spec debt is recorded in `progress.md` until closed | v1.0.0 — `templates/docs/specs/README.md` | notification `WORKFLOW.md` §13 |
| C11 | **What changes → which file to edit** | Fixed rows: new feature, behavior change, public contract, schema, config/env, breaking, decision, code template, **stack change** | v1.0.0 — `templates/docs/specs/README.md` | cdn `WORKFLOW` R8, notification §14 |
| C12 | Always/Ask/Never boundaries | (blocked) Never: secrets, `.env`, tokens, credential logs, force push, `--no-verify`, self-merge. (warning) Ask first: schema, contract, auth, security defaults, adding a dependency, deleting data/migrations, editing CI/CODEOWNERS/AGENTS. [x] Always: write tests together with code, run the DoD before reporting done | Yes — `templates/AGENTS.md` | every repo |
| C13 | Definition of Done (DoD) | Green commands + AC evidence + docs updated; only `Done` when every in-effect AC of the spec is `[x]`, not just the batch's ACs. When a `C30` batch is finished, report and stop; `[~]` is not a pass | Yes | — |
| C14 | Commit convention | `type(scope): description [SPEC-X]` | Yes | dashboard, notification, BotAutoTask follow it; cdn, khaosat, citad do not |
| C15 | **Three error-handling rules** | Never swallow errors silently; internal error messages are not returned to outside parties; best-effort work may ignore errors but must log with context | v1.0.0 — `templates/AGENTS.md` | cdn `CONVENTIONS.md` §Error Handling — applicable to any stack |
| C16 | **Secrets & config** | `.env.example` (exactly this name) has every key and no real values; `.env` is ignored; a deny-rule stops the agent from reading `.env`; **the agent's personal-permission files are not committed** | v1.0.0 — `templates/AGENTS.md`, `adapters/claude-settings.json`, `docs/reference/config.md` | khaosat commits `.claude/settings.json` containing the DB password + machine paths; citad-res, deploy-tool use the name `.env-example` |
| C17 | Session memory | `progress.md` is the only place that records the current batch, the new-session handoff and the history (≤ 3 sentences per line, ≤ ~5 KB); no separate `HANDOFF.md`. Overwrite the handoff at event milestones (batch finished, task switched, the same bug fixed twice and still not green, before compaction) including edited files, the check command + open errors, and rejected directions; **after compaction / in a new session, re-read the batch block before continuing** — a conversation summary grants no authority (scope follows `progress.md`; if code/test state drifted because of mid-batch compaction, re-verify with the workspace + check commands and then sync `progress.md`). No token counting or per-turn warnings (the reason `C32` was dropped) | Yes — `templates/AGENTS.md` (Long context & compaction), `templates/docs/progress.md`, the Claude Code adapter (`# Compact instructions` + a `SessionStart`/`compact` hook anchored to `${CLAUDE_PROJECT_DIR}`) | cdn `.devin/TASK.md` (tied to one tool); [context compaction sources](research-token-budget.md) §5 |
| C18 | **Dated gotcha** | `symptom → cause → how to avoid · last checked YYYY-MM-DD`; a code change that touches a gotcha fixes the gotcha in the same PR | v1.0.0 — `templates/project-skill` | the cdn skill says "the API key has no create route" while the code already has one |
| C19 | **Check the effect of operational commands** | Check the *effect* (table exists, file generated), not just the exit code | v1.0.0 — `skills/write-spec` §5 | cdn `migrate` does nothing yet exits 0 |
| C20 | **Changing the stack is a change** | A stack change must edit the AGENTS commands, CI, WORKFLOW/CONVENTIONS in the same PR; the survey checks "CI matches the manifest" | v1.0.0 — `templates/docs/specs/README.md`, `skills/survey-project` | notification: the README says it moved to NestJS, CI still builds .NET, WORKFLOW still points to `features/v1` + EF Core |
| C21 | Put files where the tool reads them | Tool matrix | Yes — principles §5 | dashboard |
| C22 | Test the docs before coding | 2–3 sample tasks, fresh session (`doc-tester`) | Yes — `skills/test-docs` | — |
| C23 | **No silent lowering of standards** | Forbid adding flags that gag the checker (`@ts-ignore`, `eslint-disable`, `# noqa`, `istanbul ignore`, `nosemgrep`, `gitleaks:allow`), adding `.skip` / deleting assertions, or lowering a threshold in `CONSTRAINTS.md` to make tests green; use a **one-way ratchet** (`must not fall`) for existing metrics; an exception must have an `Owner` + `Expires` (≤ 90 days) | v1.2.0 — `templates/CONSTRAINTS.md`, `templates/AGENTS.md` | Origin of idea: `constraint-driven-development` |
| C24 | **Conditional pointer** | A file-pointing line in `AGENTS.md` must put the trigger condition first (*"When touching X → read Y"*), one branch per line; write rules affirmatively about the target behavior, use negation only for (blocked) items; do not copy what the environment answers itself with 1 command unless there is a gotcha | v1.2.0 — `templates/AGENTS.md`, `review-checklist.md` | Origin of idea: `writing-for-agents` |
| C25 | **Cite authoritative sources** | When a `DESIGN-xx` or a solution relies on framework/library-specific behavior, it must be checked against the exact major version in the manifest and link the official docs (or be marked `[UNVERIFIED]`); treat content downloaded from outside as untrusted data (against prompt injection) | v1.2.0 — `skills/write-design-doc`, `PK-AGENT-R04` | Origin of idea: `source-driven-development` |
| C26 | **Critique in a clean session & cross-model** | Before presenting results at Checkpoint 5b/5c, Gate 2 (`review-docs`), `explore-options`, or reporting a finished code batch (`AGENTS.md`), run the loop `Author writes → independent critique catches errors → Author compares & fixes`: the critic receives only `ARTIFACT + CONTRACT` / `git diff + SPEC` (not the author's defending `CLAIM`). Distinguish the 2 modes clearly and declare honestly in the report: (a) **Cross-model (`Cross-Model`):** call the CLI of another model family (`codex`, `claude`, `gemini` read-only) — strongly preferred when the machine has it; (b) **Same-model clean session (`Same-Model Clean-Session`):** the `spec-challenger` subagent, with the reason a different model was not run. The report must list **every** finding in 2 sections (`Self-fixed` and `Not fixed / Needs a decision` with reasons — hiding findings is forbidden) | v1.2.0 — `skills/review-docs`, `agents/spec-challenger.md`, `templates/AGENTS.md` | Origin of idea: `doubt-driven-development`, `pstack/interrogate`, the cross-critique flow `Writer → Codex → Fix` |
| C27 | **Mark simplification limits** | When design or code deliberately picks a simple solution with a known limit (in-memory lock, $O(n^2)$ scan, polling), a `ceiling:` note is mandatory stating the maximum load threshold and the upgrade path so it is not mistaken for a design flaw | v1.2.0 — `templates/AGENTS.md`, `skills/write-design-doc` | Origin of idea: the `ponytail` plugin |
| C28 | **Visual direction presentation** | Presenting direction only as a dry text table is forbidden because it invites "blind nodding" (*rubber-stamping*). At Gate 1 (`propose-doc-design`) and in each `SPEC-xx`, the following are mandatory: (1) **Scope Radar (`(green) Do now (MVP) / (yellow) Next batch (Phase 2) / (red) Do not do`)**; (2) **a visual interaction flow (Mermaid User Journey / State Flow)**; (3) **a concrete I/O snapshot** (ASCII UI wireframe, CLI output, or a sample JSON request/response); (4) **2–3 option cards (Option Card)** when the direction is still open | v1.3.0 — `skills/propose-doc-design`, `skills/write-spec`, `templates/doc-design-proposal.md`, `templates/docs/specs/_template.md` | Origin of idea: `brainstorming`, `idea-refine`, `archify` — fixes AI code that is literally right but misses the user's intent |
| C29 | **Visible test evidence** | Running tests silently as a black box and then only reporting *"All tests passed"* is forbidden. Two transparency layers are mandatory: (1) **Before coding (the `Visible Test Matrix` in the Spec & Plan):** a table stating for each `AC-ID` which `concrete Input` will be injected, which `Output & side effects` are expected, and the `Layer & realism` (**0 mocks** or **which component is mocked**); (2) **After running tests (the test-run ledger in the completion report / PR / `verify-<app>`):** print the actual result table per `AC-ID` with an explicit **mock declaration** | v1.3.0 — `skills/write-spec`, `skills/plan-tasks`, `skills/generate-verify-harness`, `templates/AGENTS.md`, `templates/adapters/pull_request_template.md` | Fixes the blind spot where the developer does not know what the AI tested or whether it mocked all the real logic |
| C30 | **Per-batch execution authority (Docs & Code)** | The user's command grants scope; a spec/plan/Gate 1 only describes. **When writing docs (Step 5):** each turn does only **one sub-step** (5a, 5b or 5c) and then stops for review; 5b does **exactly 1 `SPEC-xx` file** per turn (with an update of `specs/README.md`); dumping the whole `docs/` tree in 1 turn is forbidden. **When writing code (Step 8):** by default 1 spec, 1 small checkable task/AC; record one current RUN in `docs/progress.md`: the real instruction source, task/AC, file area, out of scope, stop point, status, evidence. Never take the next task/spec on your own. **Ambiguous-instruction gate:** before deep reading/editing files, a clear instruction → do it, no re-asking; an ambiguous one (≥ 2 readings with different results, cannot identify the SPEC/AC and a narrow scope, or touches an unapproved Ask-first item) → targeted lookup, and if still ambiguous return a **quick confirmation of ≤ 5 lines** and stop without editing files | Unreleased — `SKILL.md`, `templates/AGENTS.md`, `skills/write-spec`, `skills/write-design-doc`, `skills/plan-tasks`, `templates/docs/progress.md` | [Primary sources & design](research-controlled-execution.md) |
| C31 | **Sources, technical explanation & knowledge limits** | REQs/NFRs and technical claims that affect decisions must have a basis and carry one of 4 labels `User decided / Verified / AI proposed / Unknown` (`Verified` comes with an openable pointer + a verbatim quote). Every concept/mechanism or technical decision the AI introduces must have an explicitly visible **Technical Explanation & Decision Card** (not hidden in comments): *What it is + example · Why needed (what breaks if skipped) · How it runs · Self-check ≤ 5 min · Source & limits*, so the user truly understands the knowledge the AI wrote but accepts it by the real run results at the `Self-check` step. No self-scored %, invented thresholds, or N/A to hide an unknown; a second AI "agreeing along" is not evidence of correctness (but using a second AI / a clean session to catch errors in the opposite direction is mandatory per `C26`) | Unreleased — `skills/write-spec`, `skills/propose-doc-design`, the spec/design/AGENTS templates | [Primary sources & design](research-controlled-execution.md) |
| C32 | — | **Dropped 2026-10-26:** chat-session management belongs to the AI tool, not to the spec; recording session knowledge already exists in `C17`. Do not reuse this number | — | — |

## 4. Parameter tier — fixed frame, own values

| Component | Frame (inherited) | The project fills in |
|---|---|---|
| Commands section in AGENTS.md | install / dev / build / test / **test-one** / lint | Real commands (table below) |
| Docs language | IDs, commands, file names, error codes stay in English | Prose: Vietnamese / English (cdn requires English) |
| Git | The C14 commit form | Integration branch, branch prefix, release tags |
| C11 matrix | The change-type rows | Real file paths |
| Config reference | A `Variable / Required / Default / Description / Sensitive` table | Values (cdn `SPECS.md` is a good model) |
| Error / status code catalog | A `Code / HTTP or exit / Meaning / When` table in one place | The project's codes |
| Code conventions | "Do it like file X" + 1 snippet | A real sample file |
| Repo map | 1–2 levels | The real tree |

Run-1-test command by stack (fill it straight into AGENTS.md):

| Stack | Run-1-test command |
|---|---|
| Node `node:test` | `node --test --test-name-pattern="<AC-ID>" <file>` |
| Vitest / Jest | `npx vitest run <file> -t "<AC-ID>"` / `npx jest <file> -t "<AC-ID>"` |
| Python pytest | `pytest <file> -k "<AC-ID>"` |
| .NET | `dotnet test --filter "FullyQualifiedName~<AC-ID>"` |
| Shell | `shellcheck <file>`; test with `bats <file>` if available |

## 5. Errors repeated across projects (evidence for Core)

The full error table (error / seen in / how to avoid): [principles.md §7.1](principles.md). Mapping to IDs:

- Docs drift from code → C04, C18, C20 · Two "sources of truth" → C01 · CI does not run tests / wrong stack → C13, C20
- Commit convention violated → C14 · Agent allow-list committed, the name `.env-example` → C16 · A status file tied to one tool → C17
- Stale gotcha → C18 · `migrate` is a no-op with exit 0 → C19 · Spec lacks status/open questions → C06 · Build artifact drifts from source → PK-RELEASE-R06
- The agent inserts `@ts-ignore` / `.skip` by itself to get past the CI gate → C23 · A pointer to docs that is vague so the agent does not open it → C24
- The user approves a long-text spec without picturing the product flow → C28 · The AI reports "tests pass" silently while mocking all the real DB/API → C29

## 6. Pack tier — conditional inheritance

Each pack is a library of REQs with stable IDs `PK-<PACK>-Rnn`. A project enables a pack when it sees the signal, then **copies the REQs verbatim and fills in the `{…}` parameters**.

| Pack | Enabling signal | Evidence / origin of idea (internal repos + reference skills) |
|---|---|---|
| [PK-API](../packs/PK-API.md) — HTTP API | Has HTTP endpoints | cdn, notification, dashboard |
| [PK-AUTH](../packs/PK-AUTH.md) — tokens, keys, signatures | Has authentication, API keys, webhooks | cdn, notification, dashboard, BotAutoTask |
| [PK-RELEASE](../packs/PK-RELEASE.md) — Docker, registry, release | Has a released image/binary | cdn, crawler, citad-res, dashboard, BotAutoTask |
| [PK-DB](../packs/PK-DB.md) — schema, migration, queries | Has a self-managed DB, ORM, a `migrations/` folder | cdn, notification, dashboard, khaosat, BotAutoTask + `migration` |
| [PK-OBS](../packs/PK-OBS.md) — logging, metrics, runbook | A long-running service needing structured logs, RED metrics, alerts | cdn, notification, dashboard, BotAutoTask + `observability-and-instrumentation` |
| [PK-FE](../packs/PK-FE.md) — UI, design tokens, a11y, E2E | Has a user interface (Web/Desktop/Dashboard) | dashboard, khaosat + `ui-ux-pro-max`, `playwright`, `impeccable` |
| [PK-JOB](../packs/PK-JOB.md) — background jobs, cron, queue, daemon | Has workers, cron, queues, sync daemons | cdn, notification, crawler, BotAutoTask, deploy-tool + `pstack` |
| [PK-AGENT](../packs/PK-AGENT.md) — AI agent orchestration, sandbox | A system that calls LLM/CLI agents, MCP servers, runs AI-generated commands | BotAutoTask + `pstack`, `superpowers`, `botautotask`, `doubt-driven-development` |
| PK-TENANT — data isolation | Several tenants/customers share the system | cdn, notification, BotAutoTask (planned for a later version) |

### Pack files (`packs/PK-*.md` — 8 packs exist)

Detailed REQs and sample ACs live in separate files under [`packs/`](../packs/):
- [`packs/PK-API.md`](../packs/PK-API.md)
- [`packs/PK-AUTH.md`](../packs/PK-AUTH.md)
- [`packs/PK-RELEASE.md`](../packs/PK-RELEASE.md)
- [`packs/PK-DB.md`](../packs/PK-DB.md)
- [`packs/PK-OBS.md`](../packs/PK-OBS.md)
- [`packs/PK-FE.md`](../packs/PK-FE.md)
- [`packs/PK-JOB.md`](../packs/PK-JOB.md)
- [`packs/PK-AGENT.md`](../packs/PK-AGENT.md)

Pack file format:

```
packs/<pack>.md
  Enabling signal · Origin of idea (internal repos + reference skills) · Parameters {…} with defaults
  REQs (EARS) · Sample Given/When/Then ACs with parameters
  Lines added to AGENTS.md (Always / Ask first / Never)
  Extra survey items for survey-project · Dated gotchas
```

## 7. Customization model

### 7.1 Structure in WrittingSpecForAI

```
templates/      # = the Core tier + the Parameter frame (including templates/CONSTRAINTS.md)
packs/          # = the Pack tier (8 packs: PK-API, PK-AUTH, PK-RELEASE, PK-DB, PK-OBS, PK-FE, PK-JOB, PK-AGENT)
agents/         # = 3 specialized subagents (spec-surveyor, spec-challenger, doc-tester)
profiles.md     # = the S / M / L presets
CHANGELOG.md    # = the base version; records which Core files / pack REQs changed
```

### 7.2 A project declares it uses the base (top of AGENTS.md)

```md
> Base: writing-spec-for-ai v1.3.0 · Profile: M · Pack: PK-API, PK-AUTH, PK-RELEASE
> Base overrides: see the "Overrides" section at the end of the file.
```

A project spec records inherited REQs in a table instead of copying the reasons:

| Project REQ | Inherits | Parameter / override |
|---|---|---|
| MEDIA-R07 | PK-AUTH-R01 | salt = `API_KEY_SALT` |
| MEDIA-R08 | PK-API-R05 | `limit` cap = 100 |

### 7.3 Override rules

| Action on a Core/Pack rule | Condition |
|---|---|
| **Tighten** (add, stricter) | Free; record in AGENTS.md or the spec |
| **Loosen** (fewer conditions) | Needs a `D-xx` recording the reason |
| **Drop** | Needs a `D-xx` + a line in the "Overrides" section of AGENTS.md |

Priority order: `project decisions > project spec > project AGENTS.md (including Overrides) > Pack > Core > global skill`.
This is the **override order between base tiers** (project / Pack / Core / skill), not the **source-of-truth order** (`C01`) used when reading project docs.

### 7.4 Profiles — presets so small repos do not carry the cost of large repos

| Profile | Signal | Minimum files | Example |
|---|---|---|---|
| **S** — scripts, infrastructure | < ~30 files, no public API | `AGENTS.md` (≤ 60 lines) + README + `.env.example`; one `docs/spec.md` file if there is behavior needing acceptance | vmu-deploy-tool, citad-postgresql, crawler |
| **M** — services | Has an API/worker/DB | All of level 0 + packs by signal + `CONSTRAINTS.md` (Level 1, only with a signal) + CI running the DoD | cdn, notification, khaosat, citad-res, BotAutoTask |
| **L** — platforms, monorepos | Many packages, has downstream projects | M + levels 1–2: `CONSTRAINTS.md` mandatory, scope-based rules, upgrade/compatibility, machine enforcement | dashboard |

> Details of profiles S/M/L are in a separate file: [profiles.md](../profiles.md).

### 7.5 Upgrading the base

When the base version is raised, `CHANGELOG.md` lists the changed IDs (C-xx, PK-…-Rnn). A project greps those IDs in its own docs to know where to look again.

## 8. Development roadmap

| Phase | Work | Output | Status |
|---|---|---|---|
| 0 | Survey + proposal | This file | [x] Approved 2026-10-20 |
| 1 | Add the missing Core | `git init` + tag `v1.0.0`, `CHANGELOG.md`; C03, C10, C11, C15, C16, C18, C19, C20 + templates | [x] `v1.0.0` |
| 2 | Packs + profiles | `packs/PK-API.md`, `PK-AUTH.md`, `PK-RELEASE.md`; `profiles.md`; cross-platform OSS packaging | [x] `v1.1.0` |
| 2.5 | Inherit the Plugin & Skill ecosystem | Add Core `C23–C27`; add 5 Packs (`PK-DB`, `PK-OBS`, `PK-FE`, `PK-JOB`, `PK-AGENT`); upgrade 5 sub-skills + add 2 sub-skills (`plan-tasks`, `generate-verify-harness`); add 3 subagents (`spec-surveyor`, `spec-challenger`, `doc-tester`); add `templates/CONSTRAINTS.md` | [x] `v1.2.0` |
| 2.6 | Visual Direction & Test Transparency | Add Core `C28` (Scope Radar (green)/(yellow)/(red) + option cards + ASCII input/output sketches) and `C29` (a test matrix approved before coding + a test-run evidence table with mock declaration) | [x] `v1.3.0` |
| 3 | Trial on BotAutoTask (M, brownfield) | BotAutoTask docs follow the base through all 3 gates | In progress |
| 4 | Upgrade tooling (only once ≥ 2 projects have used it) | A `base-upgrade` sub-skill; a script that checks inherited REQs point to IDs that still exist | Waiting for a signal |

## 9. Deliberately not doing

- **No npm/submodule packaging required at runtime:** copy/install with a version is enough for every stack.
- **No sync script before phase 4:** no second project uses the base yet (YAGNI).
- **No narrow business packs** (notifications, surveys, media): each exists in only one project.
- **No renaming or moving `templates/`:** to avoid breaking links in skills and in projects that already copied them.
- **Do not force an S repo to create `specs/`, `decisions.md`, `glossary.md`, `CONSTRAINTS.md`:** add them only when there is a signal.

## 10. Clarifications

### Session 2026-10-20
- Q: What is the spec status model?  A: keep `Draft → Ready → In progress → Done (+ As-built)`, add a table of AI permissions by status (C03).
- Q: Where do packs live?  A: `packs/` in WrittingSpecForAI, sharing one version.
- Q: What language for Core/Pack?  A: Vietnamese; IDs, commands, file names, error codes in English.
- Q: Inherit from the installed 7 Plugins & 210 Skills?  A: Approved in full (Core `C23–C27`, 5 new Packs `PK-DB/OBS/FE/JOB/AGENT`, 2 new sub-skills `plan-tasks` & `generate-verify-harness`, 3 subagents `spec-surveyor`/`spec-challenger`/`doc-tester`, and `templates/CONSTRAINTS.md`).

## 11. Open questions

None.
