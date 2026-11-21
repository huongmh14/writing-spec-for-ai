---
name: write-design-doc
description: Use at Step 5c (after a SPEC-XXX exists) when the spec needs > 2 PRs, touches schema/API/security, or when the user says "write a design doc for SPEC-XXX". Only opens at Step 5c to write 1 design file (Deep Modules, Seams, Design It Twice, STRIDE, rollback); do not open at other steps.
---

# Write design doc — design document for one spec (Step 5c)

Role split principle: **spec says what, design says how to assemble**. If the content answers "which requirement?" it belongs to spec; if it answers "which architecture/interface to choose, where to place seams and why?" it belongs to design.

> Root idea (internal reference skills, not evidence): `codebase-design`, `pstack/architect`, `source-driven-development` (**cite official sources**, `C25`), `ponytail` (**mark simplification ceilings**, `C27`), `archify`. Borrowed concepts: Deep Module, Design It Twice (John Ousterhout, *A Philosophy of Software Design*); Seam (Michael Feathers, *Working Effectively with Legacy Code*); STRIDE (Microsoft, Kohnfelder & Garg 1999); Expand–Migrate–Contract (Parallel Change — Danilo Sato, martinfowler.com/bliki/ParallelChange.html). Short meanings: [glossary](../../references/glossary.md).

When to write (signals must be real before opening the file):
- The spec's estimated plan > 2 PRs;
- Touches data schema, public API, or security mechanisms;
- >= 2 significant architecture options under consideration (otherwise design is unnecessary — one line in the spec's "Design notes" suffices).

## Steps

1. **One sub-step per turn, cross-review & stop for review (**per-batch execution authority**, `C30` & `C26` — Checkpoint 5c):** this turn only does step 5c — create `docs/specs/<nn>-<area>-design.md` from `templates/docs/specs/_design-template.md` (Attributes table links back to the spec), no new spec or other steps; run 1 independent challenge pass (second-model CLI read-only or `spec-challenger` receiving only `ARTIFACT + CONTRACT`), self-fix real errors before presenting summary + technical explanation to the user and **MUST STOP** for review before Step 6 (`review-docs`).
2. **Context and constraints**: list only constraints *affecting option choice* (from `decisions.md` D-xx, `CONSTRAINTS.md`, AGENTS.md, infrastructure). Don't re-describe the spec.
3. **Deep Module & Seam design (`Deep Modules & Seams`):**
   - Flow diagrams (Mermaid) for main + error flows (if the user needs an interactive HTML version to review complex designs, additionally use the `archify` skill).
   - Table `Component (Module) | Interface & Seam | Hidden responsibility inside | REQ` — prefer **Deep Modules** (small interface, few functions/params but hiding complex logic inside) over Shallow Modules (bloated interface just passing calls through).
   - Clearly mark **Seams** where acceptance tests sit so behavior can be tested from outside without deep-mocking internals.
   - **Cite official sources (`C25`):** every design pattern tied to a framework/library must be checked against the manifest's major version and link official docs (or tag `[UNVERIFIED]` if unverifiable).
   - **Mark simplification ceilings (`C27`):** if deliberately choosing a simple design with known limits (in-memory queue, single-process lock, polling), record `ceiling: <max load threshold> → <upgrade path beyond threshold>`.
4. **Data model**: entity table + key fields + constraints + lifecycle. Changing existing schema → record the backward-compatible migration path (**Expand–Migrate–Contract**: Expand → Migrate data, verify within this step → Contract; per `PK-DB-R01`).
5. **Contracts**: link machine-readable files (`openapi.yaml#/paths/...`, JSON Schema, test vectors). **Never copy contract content into design** — one truth, one place.
6. **Threat model** (auth/permission/personal-data/payment/agent risk areas): table `Asset | Threat (STRIDE: spoofing, tampering, repudiation, info disclosure, DoS, elevation) | Mitigation | REQ/AC` — every mitigation must trace to REQ/AC; mitigations without REQ get a REQ added to the spec (same PR).
7. **Rejected options (Design It Twice — sketch >= 2 options before choosing)**: for core design areas, mandatory to sketch at least **2 options with different interface shapes**, compare interface depth, change isolation, and ops cost, then record why the other was rejected (generate and present options per [explore-options](../explore-options/SKILL.md); the user chooses). Missing this section = design unfinished. Every significant mechanism or decision (option, schema, library, security mechanism) gets a **Technical Explanation & Decision Card** per `templates/docs/specs/_design-template.md` (*What it is + example · Why required / what breaks if skipped · How it runs · Self-check ≤ 5 min · Source & can't self-check*) so users understand the technical knowledge the AI wrote and verify via the Self-check step.
8. **Risks, migration, rollback**: what breaks during deployment, how to revert, any data loss.
9. **Principle cross-check**: table checking each related AGENTS.md / D-xx / `CONSTRAINTS.md` principle — Pass / Violation + reason.

## Gotchas

- Design bloating into a spec re-description (copying REQs) → delete parts that don't answer "how to assemble".
- Too many assumed seams/adapters when only 1 implementation exists (*one adapter is an assumed seam; two adapters make a real seam*).
- Rejected options being strawmen or one-word "unsuitable" → must be genuinely viable options with enough technical reasoning that successors won't re-propose them.

## Check before presenting

- [ ] Meets the design-writing conditions listed at the top of the skill.
- [ ] Every component maps to REQ; interface **depth** and test **Seam** placement are explicit.
- [ ] Framework/API-dependent decisions have official docs links at the right version (`C25`); deliberate simplifications have `ceiling:` notes (`C27`).
- [ ] Contract is a machine-readable file, design only links.
- [ ] Has >= 1 genuinely weighed rejected option (**Design It Twice**); every significant decision has a Decision Card with a cheap runnable Self-check line.
- [ ] Risk areas: has STRIDE table, mitigations trace to REQ/AC.
- [ ] Has rollback; schema changes have Expand–Migrate–Contract migration path; stops for user review after step 5c (`C30` — Checkpoint 5c).
