# Catalog of professional lenses

Use this instead of "you are a senior BA / tech lead...". At the start of each step the AI consults the table, turns on **at most 3** lenses that have a real signal, then writes one line:

`Lens: <name> — because <specific signal: file, keyword, step>`

When the user says "add/remove lens X" the AI does so. Each lens must change the **questions and the output**, not just the tone.

> **Why we do not use job titles (Verified, 2026-10-26):**
> - Zheng et al., Findings EMNLP 2024, <https://arxiv.org/abs/2311.10054>, verbatim: *"adding personas in system prompts does not improve model performance across a range of questions compared to the control setting where no persona is added"*. Same paper: choosing a persona automatically is *"often performing no better than random selection"*.
> - Kim et al. 2024, <https://arxiv.org/abs/2408.08631>, verbatim: *"role-playing prompts sometimes distract LLMs, degrading their reasoning abilities in 7 out of 12 datasets in llama3"*.
> - Anthropic, <https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices#give-claude-a-role>, verbatim: *"Setting a role in the system prompt focuses Claude's behavior and tone"*. According to that document, accuracy comes from examples, not from the role.
>
> Conclusion: quality lives in the checklist below; a one-line role description only steers the tone.

| Lens | Turn on when this signal appears | Mandatory questions | Output | Related skill |
|---|---|---|---|---|
| Business analysis (BA) | Vague requirements, many stakeholders, no AC yet | Who uses it? How is success measured? Which edge cases? What is **not** done? | EARS REQs, Given/When/Then ACs, `[NEEDS CLARIFICATION]` | `write-spec` |
| Architecture / Tech lead | More than 2 PRs, many modules, hard-to-reverse decisions | Where are the module boundaries? How do we roll back? Which task blocks which? | Design doc, task graph | `write-design-doc`, `plan-tasks` |
| Data | Touches schema, migration, backfill, user data | Can it change without downtime? How is old data handled? | Expand–Migrate–Contract sequence | `plan-tasks`, [PK-DB](../packs/PK-DB.md) |
| Security | Login, authorization, personal data, payments, secrets | Per STRIDE: who can spoof, what can leak or be altered? Is an expert needed? | Threat table + mitigations; write "needs expert" if beyond our knowledge | `write-design-doc`, [PK-AUTH](../packs/PK-AUTH.md) |
| Testing (QA) | ACs exist, regressions, fixing a bug | At which layer do we test? What evidence proves it is correct? Are mocks used? | Visible test table, test layer for each AC | `generate-verify-harness` |
| Operations (SRE) | Deploy, workers, cron, infrastructure, queues | How will we know it broke? How do we roll back? | Required logs/metrics, runbook | [PK-OBS](../packs/PK-OBS.md), [PK-RELEASE](../packs/PK-RELEASE.md) |
| Context for AI | Writing `AGENTS.md`, docs for agents, project skills | Which file does a new agent read first? Does it exceed the per-session read budget? Are there two sources of truth? | `AGENTS.md`, docs map, conditional pointers | `propose-doc-design`, [PK-AGENT](../packs/PK-AGENT.md) |
| User experience (UX) | There is a UI or a user interaction flow | Where does the user get stuck? What do the error/empty/loading states look like? Does it meet a11y? | Screen flow, error states | [PK-FE](../packs/PK-FE.md) |
| Challenge | **Always on** at Gate 2 and when comparing options | What can be wrong? Which claim lacks an openable source? Which option is a strawman? | Issue list with severity | `review-docs`, `explore-options` |

Default lenses per step (if no other signal exists):

| Step | Default lens |
|---|---|
| 1–4 (survey, proposal) | Context for AI + BA |
| 5b (spec) | BA + Testing |
| 5c (design) | Architecture + a risk lens that has a signal (Data/Security/Operations) |
| 6 (Gate 2) | Challenge |
| 7.5–8 (plan, code) | Architecture + Testing |

Add a new lens when one kind of signal repeats in 2 or more projects. Fill all 5 columns; without "Mandatory questions" it is only a job title and is not accepted.
