# Review checklist for the AI doc set

Mark `[x]` / `[ ]` / `N/A`. Every `[ ]` must be listed in the report sent to the user.

## 1. AGENTS.md (Level 0)

- [ ] Context in 2–4 sentences, concrete stack with major version (no patch).
- [ ] The Commands section comes right after the context, with full flags, and **includes a command to run 1 test**.
- [ ] Every command was run (or it is stated that it was not, with the reason).
- [ ] Source-of-truth order table + "when ambiguous, stop, state what is unclear, propose" + "if an outside skill conflicts, follow this file".
- [ ] **Conditional pointer** (`C24`): every line in `AGENTS.md` pointing to another doc puts the trigger condition first (*"When touching X → read Y"*), one branch per line.
- [ ] 3-tier boundary [x] Always / (warning) Ask first / (blocked) Never; includes "never commit secrets".
- [ ] **No silent lowering of standards** (`C23`): the (blocked) section bans adding suppressions (`@ts-ignore`, `eslint-disable`, `# noqa`, `.skip`) or lowering check thresholds just to make tests green.
- [ ] **Mark simplification limits** (`C27`): the [x] section has a convention to attach `ceiling:` when choosing a simple solution with a known limit.
- [ ] **Visible test evidence** (`C29`) in the DoD: the DoD / task process requires printing a **test-run result table** that states Input, actual Output, and **mock declaration** (0 mocks, or which parts are mocked) instead of only reporting "tests green".
- [ ] The DoD is a verifiable command/condition.
- [ ] **Per-batch execution authority** (`C30`): `Ready` grants no coding permission; a batch has a real instruction, spec/task/AC, and a stop point. Default 1 task; a delegated batch is not re-asked; when finished, do not start the next task by yourself.
- [ ] Code conventions have ≥ 1 real example or sample file to imitate.
- [ ] Covers all 6 areas: commands, tests, structure, style, git, boundaries.
- [ ] ≤ ~150 lines; no obvious sentences; no line numbers/patch versions; emphasis (IMPORTANT/caps) on only a few lines.
- [ ] Has 3 error-handling rules (never swallow silently; internal messages never leak outside; best-effort must log).
- [ ] (blocked) has "never commit the agent's personal-permission files"; [x] has "when adding an environment variable, edit `.env.example` + `docs/reference/config.md`".
- [ ] The top of the file declares the base: version, profile, packs; the "Override" section (if any) has a `D-xx` on every loosened/removed line.

## 2. Spec (each spec)

- [ ] Has a goal and in/out scope (out-of-scope is not empty).
- [ ] **Visual direction presentation** (`C28`): has an interaction-flow diagram (Mermaid) and at least 1 concrete input/output sketch (ASCII UI wireframe, CLI sample, or JSON request/response) so the reviewer sees the shape of the feature before reading REQs.
- [ ] Every REQ has an ID, a level, one sentence; EARS form where possible.
- [ ] **Sources & knowledge limits** (`C31`): REQs/NFRs and important claims carry 1 of 4 labels `User decided / Verified / AI proposed / Unknown`, one claim per line; measurements have conditions, N/A only when not applicable, a Draft unknown has a way to verify.
- [ ] Has a short behavior-based reading and examples; does not make the user approve unproven specialist knowledge or self-scored confidence %.
- [ ] Every `Verified` has exactly 1 openable pointer (`path:line`, URL + verbatim quote + read date, or command + real result); a link without a quote does not count as verification.
- [ ] Every specialist concept, mechanism or technical decision the AI introduces has an explicitly visible **Technical Explanation & Decision Card** (not hidden in `<!-- ... -->` comments): explaining *What it is (with an example) · Why it is required (what breaks if skipped) · How it runs (Input → Process → Output) · Self-check in ≤ 5 minutes (command/action + expected result, pointing to the AC-ID) · Source*.
- [ ] Security/payment/legal/personal-data areas the user cannot self-check are marked "needs expert: <role>"; an approval is not treated as certification of correctness.
- [ ] Has edge cases; each edge has an AC or is out of scope.
- [ ] Every REQ has ≥ 1 AC; there is an AC for errors; ACs name a test layer.
- [ ] **Visible Test Matrix:** the AC table states, for each `AC-ID`: `Scenario | Concrete input | Observable expectation (output & side effects) | Layer & realism (0 mocks, or which parts are mocked)`.
- [ ] No unmeasurable adjectives ("fast", "safe", "reasonable").
- [ ] No `[NEEDS CLARIFICATION]` left if the status is `Ready`.
- [ ] Open questions are present (write "None" if empty); conflicts are recorded in both related specs.
- [ ] Does not copy decision reasons; only writes the `D-xx`.
- [ ] Does not describe the implementation except architectural constraints; has no work-breakdown section.
- [ ] Has an end-to-end way to verify.
- [ ] Terms match the glossary.
- [ ] `As-built` spec: every REQ has evidence; `[x]` only when an existing test proves it.
- [ ] ACs for operational commands (migrate, sync, seed, deploy) check the effect, not just the exit code (**check the effect of operational commands**, `C19`).
- [ ] **REQs inherited from a pack (if any):** reference the correct pack ID (`PK-API`, `PK-AUTH`, `PK-RELEASE`, `PK-DB`, `PK-OBS`, `PK-FE`, `PK-JOB`, `PK-AGENT`), and the `{…}` parameters are filled with concrete values, not left blank.

## 3. Decisions, glossary, status

- [ ] `decisions.md` is append-only and has a status column (in effect / superseded by).
- [ ] The P-xx table contains no finished items.
- [ ] `glossary.md` has the main domain terms, a "do not call it" column, and no implementation details.
- [ ] Status files (`progress.md`, plans) carry an update date; the new-session handoff lives inside `progress.md` (no separate `HANDOFF.md`).
- [ ] Only one current execution batch; progress/HANDOFF do not create permission out of unfinished work. `[~]` is not enough to move to `Done`; reports link evidence and never copy expectations into results.
- [ ] progress is separate from the spec catalog; ≤ ~5 KB; ≤ 3 sentences per line.
- [ ] `docs/specs/README.md` has the AI-permission table by status, the hotfix rule, a "type of change → file to edit" table (with a stack-change row), and a **one-way dependency / build-order table between specs (Capability Map)** if there are ≥ 2 specs.
- [ ] A hotfix's spec debt (if any) is in progress and is no more than 1 working day old.
- [ ] Environment variables are described only in `docs/reference/config.md`; they match `.env.example`. Error/status codes live only in `docs/reference/error-codes.md`.

## 3b. CI, config, CONSTRAINTS, gotchas

- [ ] CI runs exactly the DoD commands on the current stack; every path CI references exists (**changing the stack is a change**, `C20`).
- [ ] Only one file is accepted as the source of truth for each topic.
- [ ] The sample env file is named `.env.example`; `.env` is ignored; no agent personal-permission file is in git (**secrets & config**, `C16`).
- [ ] Every gotcha has a last-checked date (**dated gotcha**, `C18`); gotchas that contradict the current code are fixed/deleted.
- [ ] `CONSTRAINTS.md` (if the project enables it): every number in the enforcement table has a real check command in the `Checked by` column; all exceptions have an `Owner` and an `Expires` ≤ 90 days (`C23`).

## 4. Location & adapters

- [ ] Every file is placed where the tool reads it (principles §5).
- [ ] Adapters only point back to `AGENTS.md` + tool-specific parts.
- [ ] Every docs file is pointed to by at least one other file.
- [ ] No knowledge file is excluded by `.gitignore` / `.git/info/exclude`.

## 5. General quality & critique in a clean session (`C24`, `C26`)

- [ ] No fact is written in two places.
- [ ] No fabricated requirements: every REQ traces back to the user's words or repo evidence.
- [ ] No placeholders, no TODO without an issue.
- [ ] Templates copied into the target repo (AGENTS.md, spec, decisions...) contain no Core rule codes `Cxx`; traceability codes (`SPEC-x`, `X-R01`, `D-xx`, `PK-...`) are kept.
- [ ] Kit-internal files: a rule code has its short name on first use (``**short name** (`Cxx`)``); kit terms are explained on first use or link to [glossary.md](glossary.md).
- [ ] Write the affirmative first; prohibitions only for hard boundaries (`C24`).
- [ ] Passed the adversarial critique loop in a clean context / cross-model (`Writer → spec-challenger / codex read-only → fix real errors` per `C26` — receives only `ARTIFACT + CONTRACT`).

## 6. Levels 1–2 (if applicable)

- [ ] Every level 1–2 component has a justifying signal in the proposal.
- [ ] The design has ≥ 1 rejected option with a reason (**Design It Twice**), names the **Seam** and the interface depth (**Deep Module**), risk + rollback, a REQ → component map, and cites official docs by version (**cite authoritative sources**, `C25`).
- [ ] The contract is a machine-readable file; the spec only links.
- [ ] The plan is split into vertical slices with `Blocked by`; ready tasks run in parallel only within the assigned batch (`C30`). A separate plan is optional, but slices/ACs/verification/stop points are always present.
- [ ] Infrastructure-dependent ACs are marked `[~]` with a reason + how to close.
- [ ] Project skills (including `verify-<app>` if any): `name` ≤ 64 characters, a third-person `description` stating what it does + when, body < 500 lines; no duplicate of a global skill.
- [ ] Hooks/settings are reviewed; deny-rules exist for sensitive files.
- [ ] A rule that already has an automated check keeps only one prose line pointing to the check.
- [ ] Docs that steer the agent (AGENTS.md, CONSTRAINTS.md, skills, rules, hooks) sit under CODEOWNERS.
- [ ] **Packs are declared in AGENTS.md (first line):** only packs with an enabling signal, no extras.

## 7. Testing the docs (Step 7 — `doc-tester`)

- [ ] 2–3 sample tasks were assigned (Profile S: 2; M/L: 3) in a fresh session (`doc-tester`, carrying no doc-writing context).
- [ ] Skipped rules, redundant questions, redundant work were recorded — and the matching docs were fixed.
- [ ] Includes the cases: many Ready specs but only 1 task assigned; an expired batch/old HANDOFF; a delegated finite batch; a technical threshold with no source (`C30`, `C31`). Testing the docs does not prove the product's runtime or domain correctness.
