---
name: cheat-sheet
description: When-to-use cheat sheet for each skill with real examples
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

## Core Skills (Frequent Use)

### explore
**When to use:**
- First time in a codebase, don't know which file holds the logic
- Need to understand a feature's flow (e.g. authentication, payment)
- Grep isn't enough, need semantic search

**Examples:**
- "How does authentication work in this project?"
- "Where is this API's entry point?"
- "Where does data flow from API down to the database?"

**Do NOT use when:**
- You know the exact file to read  read it directly
- You just need to grep a function/variable name  use grep

---

### systematic-debugging
**When to use:**
- Test failure
- Production bug
- Unexpected behavior
- Build failure
- Performance problem

**Examples:**
- "Test `test_login` fails, find the bug"
- "This API returns 500, no idea why"
- "Deploy failed, check it for me"

**IMPORTANT:**
- NEVER fix before understanding the root cause
- Always finish Phase 1 (Root Cause Investigation) before proposing a fix

---

### code-review
**When to use:**
- Review a PR/branch before merge
- Review work-in-progress changes
- Review "since X" (commit/branch/tag)

**Examples:**
- "Review the feature-login branch for me"
- "Review changes from commit abc123 to HEAD"
- "Check whether PR #123 matches the spec"

**Output:**
- Standards axis: does it follow the repo's coding standards?
- Spec axis: does it implement the issue/spec correctly?

---

### verification-before-completion
**When to use:**
- About to finish a task, need verification before commit
- User asks "check if it's done"
- Before creating a PR

**Examples:**
- "Verify the code is correct"
- "Check whether all tests pass"
- "Confirm the implementation matches the spec"

**Requirements:**
- Run verification commands
- Show evidence (test output, build status)
- NEVER claim done without verifying

---

## Process Skills (When a Process Is Needed)

### writing-plans
**When to use:**
- Have a spec/requirements to implement
- Large task needing to be split
- Want a clear plan before coding

**Examples:**
- "Write a plan to implement the user-management API"
- "Split tasks for the search and filter feature"
- "Plan the cache-layer implementation"

**Output:**
- Plan file at `docs/superpowers/plans/YYYY-MM-DD-<feature>.md`
- Each task has: Files, Interfaces, Steps with checkboxes
- Review Focus: edge cases to test

**Do NOT use when:**
- Small task (1-2 files, simple logic)  code directly

---

### tdd
**When to use:**
- User asks for "TDD" or "test-first"
- Want tests before code
- Need a test suite for a new feature

**Examples:**
- "TDD the authentication feature"
- "Write tests for the payment API before implementing"
- "Red-green-refactor to fix this bug"

**Flow:**
1. Write failing test (RED)
2. Implement minimal code to pass (GREEN)
3. Refactor (REFACTOR)

---

### writing-spec-simple
**When to use:**
- New project < 50 files
- New user, not used to docs yet
- AI auto-proposes it on first project entry

**Examples:**
- "Write AGENTS.md for this project"
- "Standardize docs for the AI agent"
- "This project has no spec, write one for me"

**Output:**
- Simple `AGENTS.md` with tech stack, commands, conventions
- `glossary.md` if needed
- Simple specs per feature

**Do NOT use when:**
- Project >= 50 files  use writing-spec-for-ai
- A reasonable AGENTS.md already exists

---

### writing-spec-for-ai
**When to use:**
- Large project >= 50 files
- Multiple people/agents working in parallel
- Need formal process with 3 review gates
- User says "write AGENTS.md", "standardize docs for agent"

**Examples:**
- "Write AGENTS.md for this enterprise project"
- "Standardize docs so AI agents work effectively"
- "This project has no spec, write one for me"

**Output:**
- Full `AGENTS.md` with boundaries, DoD, process
- `CONSTRAINTS.md` if needed
- `glossary.md`, `decisions.md`, full `specs/`
- 3 review gates: proposal  challenge  doc test

**Do NOT use when:**
- Small project < 50 files  use writing-spec-simple

---

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
