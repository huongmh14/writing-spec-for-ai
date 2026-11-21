---
name: propose-doc-design
description: Use at Steps 3–4 (Gate 1) after the Step 1–2 survey table exists, or when the user says "draft the docs design proposal", "Capability Map", "approve Gate 1". Only opens at Steps 3–4 to write the proposal and stop for approval; do not open while surveying or writing specs.
---

# Propose doc design — docs design proposal (Steps 3–4 of writing-spec-for-ai)

Input: `survey-project` results (current-state table + Profile + levels + Packs).
Output: ONE proposal file per `templates/doc-design-proposal.md`, saved in the session's artifact directory (or `docs/proposals/` if the user wants). **No real docs files created in the repo yet.** Only open `templates/doc-design-proposal.md` and the `packs/PK-*.md` files enabled at Steps 1–2; do not pre-read `templates/docs/specs/*` or step 5–8 sub-skills (`C17`).

 Send proposal, stop, wait for approval (Gate 1). If not approved, revise the proposal — never bypass to writing docs.

## 1. Fill the proposal from survey results

- Section 1 (current state): copy the survey table, keep evidence columns verbatim.
- Section 2 (levels, profile, packs): choose **Profile** (`S/M/L` per [`profiles.md`](../../profiles.md)), keep only level 1–2 components with signals (added on signal; Level 0 always required — [glossary](../../references/glossary.md)) (`CONSTRAINTS.md`, `DESIGN-xx`, `verify-<app>`…), choose **Packs** by signal among the 8 packs (`PK-API`, `PK-AUTH`, `PK-RELEASE`, `PK-DB`, `PK-OBS`, `PK-FE`, `PK-JOB`, `PK-AGENT`).
- Section 3 (file tree): every file marked Create / Edit / Move / Delete — if the repo already has docs, prefer edit/move, never create a second copy.
- Section 4 (`AGENTS.md` & `CONSTRAINTS.md` content): pre-write key values — commands, 3 boundary tiers, DoD, conditional context pointers activated at sentence start (**conditional pointer**, `C24`), base/profile/pack declaration line.
- Section 7 (enforcement/hooks/skills): only propose when signaled; note which rules can become `CONSTRAINTS.md` checks.

## 2. Visualize Direction & split Specs by Capability Map (**visual direction presentation**, `C28` — proposal section 5)

Users easily *rubber-stamp* a wall of text then discover the AI misunderstood the product direction. Before listing specs, visualization per `C28` is mandatory (root idea: internal reference skills `brainstorming`, `idea-refine`, `archify`):

1. **Scope Radar — 3-column scope table (`(green) Do now / (yellow) Next batch / (red) Won't do`):** put the 3-column table/block at the top of the direction section so users see MVP boundaries, deferred parts, and fully excluded parts.
2. **Overall interaction flow & visual option cards (while direction is open):**
   - Draw **1 Mermaid diagram** (User Journey / System Flow) showing the main actor's path from input to result.
   - If the problem has `>= 2` viable product/architecture directions, present **2–3 visual option cards (A / B)** each with a concrete **I/O Snapshot sketch** (ASCII UI wireframe, CLI command sample, or JSON payload) + trade-off table so users see and pick a direction before details.
3. **Split independent areas by capability domain:**
   - List domain entities and capabilities (users, orders, roles, warehouse, notifications…); group into independently testable areas answering *"who uses this feature to do what"*.
   - Separate **enabler** specs (`ARCH`, `REPO`, `API`, `NFR`) only when the project is large enough.
4. **Determine one-way dependencies (`Depends on`) & Build Order:**
   - Each table row: `SPEC-<NAME> | Area responsibility | Depends on | Expected status (Draft/As-built) | Requirement source`.
   - Dependency arrows point one way only — **cycles forbidden**. No minimum REQ count: only detail specs about to be built; later areas keep name/goal/dependencies. Approving the Capability Map grants no implementation authority (**per-batch execution authority**, `C30`).
5. **REQs inherited from Packs (`PK-*`):** if the project enables packs (`PK-API`, `PK-AUTH`, `PK-RELEASE`, `PK-DB`, `PK-OBS`, `PK-FE`, `PK-JOB`, `PK-AGENT`), record inherited REQs in a table with concrete `{…}` parameter values (see `base-kit.md` §7.2).

## 3. Clarifying questions per `HYPOTHESIS + Frontier + GUESS` (section 10 — hypothesis with evidence → only ask what the user can decide → with AI proposals attached)

Drawn from every `[NEEDS CLARIFICATION]` found while filling the proposal. Apply interview discipline from `interview-me` and `grilling`:

1. **State hypothesis & basis (`HYPOTHESIS + EVIDENCE` — **sources & knowledge limits**, `C31`):** summarize goal/constraints; tag each claim with 1 of 4 source labels (glossary); cite user words, `path:line`, or official sources, noting gaps. Never self-score confidence %.
2. **Only ask Frontier questions (outcomes/trade-offs only the user can decide):** max 3 questions on behavior/scope/cost the user decides; dependent questions wait for the next turn. Use input→output examples instead of jargon.
3. **Attach proposal (`GUESS`):** state observable outcome, trade-offs, and unproven parts. Agreeing on behavior doesn't confirm every technical claim or grant authority to run the whole roadmap.
4. **Unpack vague keywords & don't accept vague delegation:**
   - If the user answers with generic words (*"needs to be scalable, clean, modern"*), ask for concrete thresholds or *"If you didn't have to justify to anyone, what would you actually need working first?"*.
   - *"Up to you"* can delegate easily-reversible technical details within the granted scope: prefer existing patterns/dependencies and record the basis. For data, permissions, money, or business commitments, state consequences plainly; the AI self-researches/experiments what's allowed. If expertise is still missing, record "needs expert review" and block dependent parts — don't force the user to guess A/B.
5. Confirmed answers → `D-xx` or the spec's "Clarifications". Unproven recommendations → `P-xx`, never self-promoted to truth or approved REQ.

## 4. Doc test plan (section 8) & deliberate exclusions (section 9)

- Pre-select 2–3 sample tasks (Profile S: 2; M/L: 3) to hand to the [`doc-tester`](../../agents/doc-tester.md) subagent at Gate 3: 1 common task, 1 task touching an "Ask first" boundary, 1 deliberately vague task.
- Record clearly what the proposal **skips** and why (section 9) so approvers know it was considered, not forgotten.

## Check before done

- [ ] No docs files in the repo created/edited.
- [ ] Every level 1–2 component and chosen Pack has an accompanying signal.
- [ ] Has **Scope Radar (`(green) Do now / (yellow) Next batch / (red) Won't do`)**, Mermaid flow diagram, and **visual option cards + I/O Snapshots** while direction is open (`C28`).
- [ ] Spec-split table has one-way `Depends on` column (no cycles) + `Build Order` + traceable requirement sources.
- [ ] Has short read: first behavior, acceptance example, out-of-scope, unknowns; only details what's about to be built (`C30`, `C31`).
- [ ] `HYPOTHESIS + EVIDENCE` states sources/gaps clearly, ≤ 3 user-decidable questions; technical parts have verification methods and owners.
