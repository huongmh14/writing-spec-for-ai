# Core Laws - Simplified for Small Projects

Inherited from `writing-spec-for-ai/references/base-kit.md`, keeping the 19 most important core laws for small projects (`< 50` files, 1-2 people).

## Inherited Laws (Mandatory)

| ID | Law | Content |
|----|-----|---------|
| C01 | Source-of-truth order | `decisions.md` > `specs/` > `conflicts-and-bugs.md` > `AGENTS.md` > existing code |
| C03 | AI authority by spec status | `Draft`: no code. `Ready`: may code. `Done`: no edits unless spec updated |
| C04 | Simple ID scheme | `SPEC-001`, `AC-1`. Test function name contains `AC-ID`. Commit tagged `[SPEC-001]` |
| C05 | AC status | `[]` not met. `[x]` met with test evidence. `[~]` unverified |
| C11 | What changed, which file | New feature/command  `AGENTS.md`. Behavior change  `SPEC-xxx.md`. Bug/conflict  `conflicts-and-bugs.md` |
| C12 | 3-tier boundaries | [x] Always: run tests, DoD. (warning) Ask: schema change, new dependency. (blocked) Never: leak secrets, force push |
| C13 | Definition of Done (DoD) | Green tests + AC evidence table (`C29`) + docs updated |
| C14 | Commit convention | `type(scope): description [SPEC-001]` |
| C15 | Three error rules | Never swallow errors. Internal errors never go straight to client. Skipped side-task errors must be logged |
| C16 | Secrets & config | `.env.example` has all keys, `.env` in `.gitignore`. Never commit personal agent files |
| C18 | Bug & conflict ledger | Every bug, contract drift (enum/API/DB/port), hotfix/revert goes into `docs/conflicts-and-bugs.md` with SHA and a blocking check |
| C21 | Files in the right place | `AGENTS.md` at repo root. Specs in `docs/specs/`. Decisions in `docs/decisions.md` |
| C22 | Test docs before code | Run 1-2 sample tasks to verify docs before mass coding |
| C23 | No silent lowering of standards | Never add `@ts-ignore`, `eslint-disable`, or delete asserts just to force green tests |
| C24 | Conditional pointers | Write as *"When touching X  read Y"* at the start of a sentence in `AGENTS.md` |
| C25 | Cite official sources | Check official framework/library docs, never guess APIs |
| C29 | Visible test evidence | Output an `AC / Input / Output / Mock` table when reporting passing tests |
| C30 | Execution authority & Ask when vague | Write 1 doc file per turn then stop for approval; ask when requirements are vague, never fabricate |

## Laws Simplified or Enabled at Phase 2/3 (`writing-spec-for-ai`)

| ID | Law | Handling in Simple version (`< 50` files) |
|----|-----|------------------------------------------|
| C02 | Three review gates | Simplified to direct approval after each step (3 steps) |
| C06 | Required spec sections | Advanced sections trimmed in `templates/SPEC.simple.md` |
| C09 | Changing a running spec | Update `SPEC-xxx.md` directly before editing code |
| C10 | Hotfix exception | If fixing urgently, backfill `SPEC-xxx.md` and `conflicts-and-bugs.md` within 1 day |
| C17 | Session memory (`progress.md`) | Optional in Phase 1; required from Phase 2 (`>= 50` files) or long sessions |
| C19 | Verify command effects | Unchanged: every command in `AGENTS.md` must actually run |
| C20 | Stack change is a big change | Unchanged: must be recorded in `docs/decisions.md` (`D-xx`) |
| C26 | Cross-model review | Off in Phase 1; enable when upgrading to `writing-spec-for-ai` (Phase 2/3) |
| C27 | Marking limits | Unchanged: state known limits explicitly |
| C28 | Visual presentation | Encouraged: Markdown tables and short ASCII/Mermaid diagrams |
| C31 | Sources & explanation cards | Simplified: just state assumptions clearly when asking the user |

## Inheritance Source

- Inherited from: `writing-spec-for-ai/references/base-kit.md` (full 31 laws `C01-C31`)
- Scaling & spec evaluation guide: `references/scaling-and-evaluation.md`
