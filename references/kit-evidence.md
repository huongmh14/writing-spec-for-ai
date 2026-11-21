# Kit Evidence — how to judge this spec kit later

Without records, nobody can tell whether the kit helps. Rule: every bug, revert, hotfix, failed gate, and every milestone report adds **one record** tagged with a kit signal. No tag, no closing the batch.

| Signal | Meaning | What to do |
|---|---|---|
| `kit-missed` | A doc/rule was absent or wrong and caused (or let through) the problem | Fix the kit; cite the file |
| `kit-ignored` | The rule existed; the agent or human skipped it | Make it a mechanical check (lint/test/hook) |
| `kit-caught` | A gate, rule, or check prevented the problem | Keep; this is the evidence of value |
| `not-kit` | Unrelated to the docs (env, data, model quality) | None |

Record in `docs/conflicts-and-bugs.md` (bugs, reverts, hotfixes) with the extra field `Kit signal`, plus: track used (`fast-track` / `simple` / `full`) and the kit version (tag or commit of this repo). Milestone reports add one row to `docs/measure.md`.

Review every 10 records or monthly: count per signal across projects with `scripts/audit-project.ps1 <project>`.

- `kit-missed` + `kit-ignored` > `kit-caught` → trim or fix the kit before adding anything.
- Many `kit-ignored` for one rule → turn it into a check or delete the rule.
- Many `not-kit` → the kit is not the bottleneck; stop adding docs.
- Never score the kit from a model's own praise; use these counts and `docs/measure.md` numbers only.
