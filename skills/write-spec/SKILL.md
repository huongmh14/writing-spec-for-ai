---
name: write-spec
description: Use at Step 5b (after Gates 1 and 5a) or when the user asks for one specific SPEC-XXX file (EARS REQs, NFR, Given/When/Then ACs). Only opens at Step 5b; writes exactly 1 SPEC-XXX file per turn then stops — never alongside other step sub-skills.
---

# Write spec — write one build spec (Step 5, spec part)

Input: an approved-proposal area + requirement source (PRD/interview/code) + `docs/glossary.md`, `docs/decisions.md`.
Output: one `docs/specs/<nn>-<area>.md` file per `templates/docs/specs/_template.md`, all placeholders removed.

Only open the `templates/docs/specs/_template.md` template; look up needed sections in [references/examples.md](../../references/examples.md) when an example is needed — **do not bulk-load** [references/principles.md](../../references/principles.md) or `references/base-kit.md` into context (`C17`).

Profile S has no docs tree: use `docs/spec.md` or README plus the batch block in `AGENTS.md`; skip reading nonexistent files. Keep the same source, AC, authority, and stop-point rules; don't generate an extra docs tree.

## 0. Preparation (5 min, not skippable)

1. Read `docs/specs/README.md` — know which specs exist, avoid overlapping areas.
2. Read `docs/glossary.md` — use correct terms; add missing terms to glossary **before** writing the spec.
3. Read `docs/decisions.md` — decisions touching this area get only `D-xx` references in the spec, not copied reasons.
4. Fix IDs: `SPEC-<NAME>` + REQ/AC prefix `<NAME>-Rnn`/`<NAME>-ACnn`. Already used in the approved proposal; don't change IDs after writing.
5. **One sub-step per turn, 5b exactly 1 spec — cross-review & self-fix before presenting** (**per-batch execution authority**, `C30` & **clean-session challenge**, `C26` — Checkpoint 5b): each turn writes **exactly 1 `SPEC-xx` file about to be built** (plus `docs/specs/README.md` and `docs/glossary.md` updates). Before presenting to the user, immediately run one independent challenge pass on the file just written (prefer a second-model CLI like `codex` read-only if available, or the [`spec-challenger`](../../agents/spec-challenger.md) subagent receiving only `ARTIFACT + CONTRACT`), **self-fix all real errors found**, then present the short read + self-fixed error summary and **MUST STOP** for user review. Writing multiple `SPEC-xx` files in one turn is forbidden. `Ready` confirms requirements; code-run authority lives in the execution batch.

## 1. Visualize flow & extract requirements from source (**visual direction presentation**, `C28`)

- **Draw flow & I/O Snapshot before writing REQs (`C28` — spec section 3):** Draw 1 Mermaid diagram (User Journey / State Flow) + 1 **concrete I/O Snapshot** (ASCII screen wireframe, CLI command sample, or real JSON request/response) so developers immediately see the feature's shape instead of reading a dry REQ table.
- **Source is docs/interviews (greenfield, Draft):** underline action verbs → candidate REQs; bad conditions ("must not", "only when", "at most") → Error-pattern REQs; numeric goals → NFR; underivable spots → `[NEEDS CLARIFICATION: …]` inline in the REQ line, never fabricate.
- **Source is code (brownfield, As-built — spec describes existing code):** every externally observable behavior (response, data effect, UI state) gets one REQ with `file:function` or test evidence; suspicious behavior (untested, suspected bug) → goes to **open questions**, never normalized.

## 2. Write REQs — EARS pattern (Alistair Mavin's Always / When / While / If sentence patterns)

Each REQ: 1 sentence, has ID, has level (MUST/SHOULD/MAY), plus phase if not done now (`MUST (P2)`).

| Source hint | Sentence pattern | Real example |
|---|---|---|
| Always-true behavior | `The system MUST <…>` | RBAC-R01: User without ACTIVE has empty effective permissions |
| Event reaction | `When <event>, the system MUST <…>` | RBAC-R21: Narrowing role-template changes apply immediately on sync, bump `permVersion`, write AuditLog |
| State condition | `While <state>, the system MUST <…>` | RBAC-R01 |
| Error branch | `If <bad condition>, then the system MUST <concrete result: HTTP code/error code>` | RBAC-R16: Missing permission → 403 `AUTH_FORBIDDEN` |
| Feature toggle | `When <feature> enabled, the system MUST <…>` | RBAC-R30: ORG_TREE scope when unit has children |

Strict rules:
- **Numbers need basis (**sources & knowledge limits**, `C31`):** thresholds need a requirement source, conditional measurement, or an explicitly-marked-unconfirmed proposal. Never turn example numbers like `p95 < 5 ms`/`10 times/minute` into commitments. Unknown → open question + verification method — don't fill numbers just to fit the template.
- **Each REQ/NFR source column gets exactly 1 of 4 labels** ([glossary](../../references/glossary.md)): `User decided` (date/quote or Clarifications) · `Verified` (exactly 1 openable pointer: `path:line` | URL + verbatim quote + read date | command + real result) · `AI proposed` (1-line reason + consequence if wrong) · `Unknown` (how to verify + who + blocked part). One claim per line, no self-scored %. Code proves current state, not need; official docs prove APIs, not product NFRs.
- **Every advanced concept, mechanism, or technical decision the AI introduces → an explicitly shown Technical Explanation & Decision Card** (template in `templates/docs/specs/_template.md` §9; forbidden to hide in `<!--... -->` comments then lose): *What it is (plain + real example) · Why required here (what breaks if absent) · How it runs in this project (Input → Processing → Output) · Self-check ≤ 5 min (pointing to AC-ID) · Reference source & limits that can't be self-checked*. Explain clearly enough that the user **truly understands the AI-written knowledge**, while verifying via real run results on the Self-check line (no blind prose approval); security/payment/legal/personal-data areas write "needs expert: <role>".
- Error codes, field names, function names written exactly as they will appear in code/contract. No implementation details (that's design), no task splitting (that's plan).
- One REQ = one behavior; a compound REQ with 3 consequences (e.g. R21) only when consequences always occur together and are verified together.

## 3. NFR — all 8 rows, none skipped

Fill the table per template: **values with basis**, `N/A — reason` if truly inapplicable, or `Unknown — P-xx + verification method + blocked AC` in Draft. Unknown doesn't mean N/A; measurements need environment/load/date. Security/a11y can be checkable conditions, not forced into numbers.

| Row | Valuation question | Real example (SPEC-NFR) |
|---|---|---|
| Performance | Where are p95/p99 thresholds, under what conditions (warm cache, record count) | guard p95 < 5 ms (warm cache) |
| Security | What sensitive data, what's forbidden to log, what encryption | redact `Authorization`, `code`, `token` |
| Limits | Rate limit by IP/user, payload size | 10 times/min/user for report runs |
| Availability | What health check, how failover | `/health/ready` checks DB, Redis, SMTP |
| Observability | Required log/metric/audit | Metrics: error rate, queue length |
| i18n | Which languages | vi (default), en |
| a11y | Standard, screen scope | WCAG 2.2 AA for admin screens, or N/A — reason |
| UI states | Are loading/empty/error/forbidden renders mandatory | every table must have empty + error states |

## 4. Edge cases — generated from checklist

For each data REQ, ask per list: empty · exactly 1 · full · over threshold · negative/wrong format · permission expiring mid-operation · two people editing concurrently · soft-deleted data · max language/size · dependent service down (Redis/SMTP). Each edge → one AC, or record in "Out of scope". No edge left without a fate.

## 5. Write ACs & Transparent Test Matrix (**visible test evidence**, `C29` — Given / When / Then)

Formula: **Given** <initial state with concrete data>, **when** <action exactly as user/test calls it>, **then** <observable result: HTTP code, error code, data, DOM state>.

- Each REQ ≥ 1 AC; must have ≥ 1 AC for the area's error branch. Test function names contain `AC-ID` (see `examples.md` §2, §9).
- **Transparent Test Matrix (`C29`, spec section 7)** for user approval before AI runs tests: `AC-ID | Scenario | Concrete input | Observable expectation (Output & DB/DOM side effects) | Tier & fidelity (0 Mock or which mocks)>`.
- AI writing both expectation and test → green only proves code matches the AI's expectation, not that the expectation is right; the user must approve the Expectation column.
- ACs depending on real infrastructure (registry, email) → `[~]` + reason + owner/how to close; not pass and blocks `Done`. Mocks only prove the tested boundary, not the real service.
- ACs for ops commands (`migrate`, `sync`, `seed`, `deploy`) must check **effects** (tables exist, record counts, generated files — **verify ops command effects**, `C19`), not just exit code 0; include an error AC (`exit ≠ 0`).

## 6. Packaging

- **End-to-end check** (section 8): 1–3 commands/scenarios the agent runs itself to confirm the whole spec — pick flows spanning BEDBFE, don't repeat each AC.
- **Open questions** (section 12): gather every remaining `[NEEDS CLARIFICATION]`; write "None" if empty. Conflicts with other specs → record in **both** specs.
- **Clarifications** (section 11): each received answer gets `### Session YYYY-MM-DD — Q: … → A: … (into R0n / D-xx)`.
- Status: `Draft` (greenfield) / `As-built` (brownfield). Only the user moves to `Ready`.
- Unknowns blocking committed REQ/AC must be resolved before `Ready`; another AI agreeing doesn't replace evidence. Unconfirmed branches may split into a Draft child spec so the independent spec can reach Ready; committed parts only split/defer via approved change-spec. Out-of-commitment parts stay in backlog, never self-added to the spec about to be built.

## 7. Gotchas

- Spec copying decision reasons → delete, keep only `D-xx`.
- AC written as "system works correctly" → replace with concrete error codes/data.
- Many specs with 20+ REQs but empty NFR → NFR is the most-skipped section; fill it first if forgetful.
- A Ready spec getting +10 REQs appended → stop, use `change-spec`.
- Terms renamed mid-stream → sync glossary + whole spec in the same edit.

## Check before presenting

- [ ] Has Mermaid flow diagram and **concrete I/O Snapshot** (ASCII wireframe / CLI / JSON sample) per `C28`.
- [ ] Each REQ: 1 sentence, has ID + level, follows 1 EARS pattern, no vague verbs.
- [ ] NFR has all 8 rows; each REQ/NFR has 1 of 4 source labels (`C31`), no fabricated numbers; `N/A` doesn't hide unknowns; every mechanism/technical decision has an explicitly shown **Technical Explanation & Decision Card** (explains essence + why needed + run flow + cheap Self-check line) and passed 1 independent/cross review round (`C26`) before presenting.
- [ ] Each REQ ≥ 1 AC; has error AC; has edge AC; has **Transparent Test Matrix** (`C29`) stating Input, expected Output, and fidelity (`0 Mock` or `which mocks`).
- [ ] "Out of scope" not empty; has end-to-end check; open questions present (or "None").
- [ ] No remaining `[NEEDS CLARIFICATION]` if the user moved to `Ready`; As-built has file/test evidence.
