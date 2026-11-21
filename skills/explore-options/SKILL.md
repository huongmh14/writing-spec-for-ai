---
name: explore-options
description: Use when facing a concrete decision with 2 or more hard-to-reverse options, or when the user says "give me the options" or "compare from several angles". Open only to compare 2-4 options for the user to choose (record a D-xx); never open it automatically for small decisions.
---

# Explore options - multi-lens option exploration

Goal: the user can **choose** between options without understanding every technical detail. The AI widens the choices, verifies them and presents them. **The user chooses**; the AI never decides in their place.

**Do not use when:** the task is small, easily reversible, or a `D-xx` already settles it. In that case follow the `D-xx` or give one short proposal.

> Basis (Verified, 2026-10-26; details and verbatim quotes in [lenses.md](../../references/lenses.md)):
> - Searching from several perspectives makes writing more comprehensive: STORM, Shao et al. 2024, <https://arxiv.org/abs/2402.14207>.
> - Multi-agent debate *"do not reliably outperform ... self-consistency"*: Smit et al. 2023, <https://arxiv.org/abs/2311.17371>. Hence this skill runs **one** challenge round only.
> - Having one model play several personas only works well for strong models around GPT-4 level: Wang et al. 2023, <https://arxiv.org/abs/2307.05300>. Hence this skill prefers clean-context subagents.
> - The decision record follows the MADR template: <https://adr.github.io/madr/>.

## Process - one sub-step per turn, stop and wait for the user at steps 1 and 5

1. **Frame the decision.**
   - Write the decision as one question, e.g. *"Where do we store the login session?"*.
   - List the settled constraints, each with a link to a `D-xx` or `CONSTRAINTS.md`.
   - List the selection criteria (e.g. cost, safety, effort, ease of changing later). The user ranks the criteria.
   - If criteria are missing, ask at most 3 questions only the user can decide (Frontier), each with a pre-guessed answer. Then **stop** and wait.
2. **Pick lenses.**
   - Take 2-3 lenses from [lenses.md](../../references/lenses.md) based on real signals, plus the **Challenge** lens.
   - Write exactly one line: `Lens: ... - because ...`.
3. **Generate independent options.**
   - Produce 2-4 options. Always include a **keep as-is / do the minimum** option as the baseline.
   - If subagents are available: one subagent per lens with a clean context. Pass only the question, constraints, criteria and paths; never the conversation history.
   - If subagents are not available: do it sequentially.
   - Two options must differ in **at least one core trade-off** (e.g. self-hosted vs bought service; synchronous vs asynchronous). If they differ only by name, merge them.
4. **One challenge round.**
   - The Challenge lens attacks each option: where it can be wrong, hidden costs, hard-to-reverse risks.
   - Reopen every cited source. A source that cannot be opened, or a quote that does not match, drops its label to `AI proposed`.
   - No multi-round debate.
5. **Present for choice** using the format below, then **stop** and wait for the user to choose.
6. **Record the decision.**
   - Once the user chooses, write a `D-xx` into `docs/decisions.md` in MADR form: *Options considered*, *Chosen option + reason*, *Consequences*.
   - Rejected options are recorded with the reason for rejection. When writing a design doc, this is its "Rejected options" section.

## Presentation format (step 5)

```markdown
**Decision:** <1 sentence> · **Criteria (ranked by the user):** 1. ... 2. ... 3. ...
**Lens:** <...> - because <signal>

| Option | Criterion 1 | Criterion 2 | Criterion 3 | Hard to reverse? |
|---|---|---|---|---|
| A. Keep as-is / minimum | good / fair / poor + 1 reason | ... | ... | Easy |
| B. ... | ... | ... | ... | ... |

Each option gets a Technical Explanation & Decision Card:
- What it is (plain words + a real example): <no vague jargon>
- Why needed / what happens if wrong: <observable consequence + cost of going back>
- How it runs (Input -> Process -> Output): <2-3 short steps>
- Self-check <= 5 min: <command / link / action the user can do alone>
- Source: <path:line | URL + verbatim quote> · Label: User decided / Verified / AI proposed / Unknown
- Cannot self-check: <part that needs an expert, if any>

**Key difference:** <1-2 sentences: choosing A means accepting X, choosing B means accepting Y>
**AI proposes:** <option> - because <criterion>. **I would change this proposal if:** <specific condition>
```

Rate qualitatively only (good / fair / poor); never give numeric scores or percentages, because numbers create false precision. Security, payment and legal areas are marked "needs expert".

## Failure signs - stop and redo

| Sign | Fix |
|---|---|
| The options are really one (only a name or library differs) | Merge them; find a different core trade-off |
| A strawman option was built just to be rejected | Replace it with an option a real expert would defend |
| A lens only changes tone ("as a senior...") | Use that lens's mandatory questions from `lenses.md` |
| More than 4 options, or the table is too long | Keep at most 4; drop early any option that violates a settled constraint |
| The AI picks and then writes code or docs right away | Stop. Without the user's choice there is no `D-xx` |
| Labeled "Verified" but no source can be opened | Downgrade to `AI proposed` or `Unknown` |

## Checklist

- [ ] A keep-as-is / minimum option exists; 2-4 options, every pair differing in at least one core trade-off.
- [ ] The `Lens: ... - because ...` line is written; the Challenge lens ran exactly one round.
- [ ] Each option has a Decision Card with a Self-check <= 5 min line and a source label.
- [ ] The user chose; the decision is recorded as a `D-xx` in MADR form.
