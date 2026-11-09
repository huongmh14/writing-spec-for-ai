---
name: cheat-sheet
description: Use when the user explicitly asks for a skill lookup, usage conditions, or examples.
license: MIT
trigger_phrases:
  - "when to use a skill", "skill lookup", "when to use"
do_not_use:
  - "When you need auto-guidance", "When the skill is already decided"
---

# Cheat Sheet - When to Use Which Skill

## Quick Lookup

**Ctrl+F your situation keyword:**
- bug, error, fail  systematic-debugging
- new here, don't understand, explore  explore
- review, PR, branch  code-review
- plan, requirements, spec  writing-plans
- refactor, restructure  safe-refactor
- test-first, TDD  tdd
- new project, AGENTS.md  writing-spec-simple or writing-spec-for-ai
- verify, check, done  verification-before-completion

---

For detailed usage conditions and examples, read [skill details](references/skill-details.md) for the skill being looked up.


## When NOT to Use (cheat-sheet)

- When you need auto-guidance  use `auto-guide` instead of cheat-sheet
- When the skill is already decided  open that skill directly
- When you need implementation details  cheat-sheet is only a lookup table

---

## Quick Decision Tree

```
Your situation?
 First time in project?
   explore  (if no docs) writing-spec-simple or writing-spec-for-ai
 Have a bug?
   systematic-debugging  fix  verification-before-completion
 Need to implement a feature?
   Small task?  code  verification-before-completion
   Large task?  writing-plans  execute  verification-before-completion
 Need a review?
   code-review
 Need a refactor?
   safe-refactor
 Need tests?
   Test-first?  tdd
   E2E?  playwright
 Need research?
   research / code-research / feature-research
 Need UI/UX?
   impeccable / ui-ux-pro-max
```

---

**Remember:** If you don't know which skill fits, tell the AI:
```
"I'm <situation>, which skill should I use?"
```

The AI will auto-propose via `auto-guide`.
