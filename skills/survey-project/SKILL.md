---
name: survey-project
description: Use at Steps 1–2 or when the user separately asks to "survey the project", "audit docs", "survey the repo". Only collects evidence of the repo's current state (stack, commands, CI, risk areas, quality floor) and scores Profile S/M/L + PK-* packs; does not open sub-skills for steps 3–8.
---

# Survey project — project survey (Steps 1–2 of writing-spec-for-ai)

Input: the project repo (and external source docs if any: PRD, docx, tickets).
Output: a current-state table **where every row has an evidence path** + greenfield/brownfield conclusion + Profile (`S/M/L`), level (`0/1/2` — Level 0 mandatory, Levels 1–2 added on signal; see [glossary](../../references/glossary.md)) and proposed Pack (`PK-*`) list. This result feeds directly into sections 1–2 of `propose-doc-design`.

Read-only — modify no project files. Large repo (`> 50` files or can't be read in ~10 min) → delegate to the read-only subagent [`spec-surveyor`](../../agents/spec-surveyor.md), receiving back only the conclusion table with `path:line` pointers to keep the main session's context clean.

## 1. Collect — every item needs a path evidence

| Item | How to check | Evidence to record |
|---|---|---|
| **Existing Knowledge Graph** *(if any)* | Check `.ua/knowledge-graph.json`, `.understand-anything/knowledge-graph.json`, or `graphify-out/` | Quickly get architecture layers, entry points, import map, and central modules (god nodes) without re-reading all source |
| Stack + major version | Read `package.json` / `pyproject.toml` / `go.mod` / `Cargo.toml` / `*.csproj`, `.nvmrc`, lockfile | "NestJS 12, Prisma 7, PostgreSQL 15" — with file path |
| Dev/build/test/lint commands | Read `scripts` in manifest, CI workflow, Makefile, README | Real commands + **command to run exactly 1 test** (find it yourself; if none, record "none" — this is a level-0 gap) |
| Existing AI docs | `ls` the matrix locations (principles §5): `AGENTS.md`, `CLAUDE.md`, `CONSTRAINTS.md`, `.github/copilot-instructions.md`, `.cursor/rules/`, `.agents/` | Which files exist, whether placed where tools read them, where content conflicts/duplicates |
| Orphan / forgotten files | `git check-ignore <file>` for every docs file; grep whether any file links to it; compare edit date with `git log -5` | List of ignored or unreferenced files |
| External source docs | Ask user / find `*.docx`, `docs/prd`, tickets | Path, version, date |
| Enforcement & **Quality floor** (**no silent lowering**, `C23`) | Read CI, `eslint`/`biome`/`ruff` config, hooks (husky/pre-commit), quickly count `@ts-ignore`/`eslint-disable`/`.skip` flags and current coverage | What machines already block, today's baseline numbers for `CONSTRAINTS.md` |
| **CI matches stack** (**stack change is a change**, `C20`) | Compare CI commands/paths with manifest and real files (`git ls-files`) | CI building nonexistent files, running old stack, or not running tests (build only) |
| **Multiple "sources of truth"** (**source-of-truth order**, `C01`) | grep `Single Source of Truth`, `nguồn sự thật`, `SSOT` in docs; compare the same truth (key format, env, dir tree) across files | Pairs of files competing or describing differently |
| **Secrets & config** (`C16`) | Env sample filename (`.env.example`?); is `.env` ignored; `git ls-files .claude .cursor .vscode .zcode` | Agent personal files committed (allow-lists, machine paths, passwords) |
| **Ops commands** (**verify ops command effects**, `C19`) | Safely try (`migrate`, `sync`, `seed`) on local env or read the command's code | Commands that do nothing yet exit 0 |
| Actual git conventions | `git log --oneline -30` | Real commit format, real branch names (match or drift from written rules) |
| Risk areas & **Pack-enable signals** | Match signals in repo first (HTTP API → `PK-API`, Auth/Token/Webhook → `PK-AUTH`, Docker/Release → `PK-RELEASE`, DB/Migration → `PK-DB`, Logging/Metrics → `PK-OBS`, Frontend UI/E2E → `PK-FE`, Worker/Cron/Queue → `PK-JOB`, AI Agent/MCP → `PK-AGENT`); **only open files inside [`packs/`](../../packs/) of Packs with real signals** (never open all 8 files) | List of risky dirs/files + which Packs have enable signals plus their extra survey questions at the end of each enabled `packs/PK-*.md` |
| External infrastructure | CI config (runner, quota), registry, secrets used in workflows, GitHub team/org | Conditions that could block ACs: Free plan, quota exhausted, team doesn't exist |
| Brownfield? | Has running code + tests + no spec? | "Brownfield — needs As-built spec (describes existing code)" or "Greenfield" |

## 2. Score Profile, proposed level & Packs (per `profiles.md` & `base-kit.md`)

- **Profile (`S` / `M` / `L`):** compare with [`profiles.md`](../../profiles.md): S < ~30 files, M ~30–200, L > 200; file count is only a hint — signals (people count, CI, risk areas, spec count) decide finally. Do not bulk-load `references/base-kit.md` into context (`C17`).
- **Level 0 (0.1–0.16):** always complete all of the following after survey.
- **Levels 1–2:** list each component with the **signal seen in the repo** (e.g. `CONSTRAINTS.md`, `DESIGN-xx`, `adr/`, `upgrade/`, `verify-<app>` skill).
- **Domain packs (`PK-*`):** only enable packs with real repo signals; read each enabled pack's *"Additional survey items"* section to collect all `{…}` parameters.

## 3. Common traps

- Reading only README then asserting commands work — must cross-check manifest/CI.
- Forgetting external infrastructure → ACs hang at deployment.
- Concluding "missing docs" while docs files are `.gitignore`d.
- Not distinguishing "no spec yet" (greenfield) from "code exists without spec" (brownfield → As-built, every REQ needs evidence).
- Project just changed stack: README updated but CI, WORKFLOW, CONVENTIONS still on old stack.

## Check before done

- [ ] Every conclusion row has an evidence path.
- [ ] Includes the run-1-test command (or explicitly "none").
- [ ] Has greenfield/brownfield conclusion, Profile (`S/M/L`), and Pack list (`PK-*`) with signals.
- [ ] Each level 1–2 component has a signal; new repos record "no signal yet".
