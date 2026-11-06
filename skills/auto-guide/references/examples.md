# Auto Guide - Detailed Examples

Detailed examples of auto-guide response formats.

## Example 1: User says "fix this bug"

```
User: "fix this bug"
AI: "I need to see the error/trace to understand better. Do you have an error message?"

User: [paste error]
AI:
=== Your Situation ===
Detected: test failure - "AssertionError: expected 200 but got 500"
Missing: root cause investigation

=== My Proposal ===
Skill: systematic-debugging

Reasons:
- Signal: test failure  bug
- Root cause unknown  don't fix yet
- VIOLATES rule: never fix before understanding the cause

Expected result:
- Find where the 500 comes from (root cause)
- Fix the right place
- Test to verify the fix

=== Next Steps ===
I will:
1. Read the error message
2. Reproduce the bug
3. Trace the code flow to find root cause
4. Propose a fix
5. Verify with a test

Do you agree?
```

---

## Example 2: User says "implement user authentication"

```
User: "implement user authentication"

AI:
=== Your Situation ===
Detected: feature request - user authentication
Task size: large (multi-component: login, register, session)

=== My Proposal ===
Skill: writing-plans

Reasons:
- Signal: implementing a new feature
- Task size: large  needs splitting
- Needs a clear plan per task

Expected result:
- Plan with tasks: register, login, session, password reset
- Each task has steps + checkboxes
- Easy progress tracking

=== Next Steps ===
I will:
1. Check the current tech stack
2. Split into tasks
3. Write the plan at docs/superpowers/plans/
4. Review the plan with you

Do you agree? Or do you want to code directly because the task is simple?
```

---

## Example 3: User says "first time in this project"

```
User: "first time in this project"

AI:
=== Your Situation ===
Detected: first time in project
Missing: AGENTS.md (AI docs)
Project size: 30 files

=== My Proposal ===
Skill: explore  writing-spec-simple

Reasons:
- Signal: first time  need to understand codebase
- No AGENTS.md  should standardize docs
- Project < 50 files  simple version is enough

Expected result:
- explore: understand architecture, structure
- writing-spec-simple: AGENTS.md with tech stack, commands
- AI has context  works more effectively

=== Next Steps ===
I will:
1. explore the codebase (5-10 min)
2. Propose docs structure (3-5 min)
3. Write AGENTS.md (10-15 min)
4. Review with you

Do you agree? Or just explore without docs?
```

---

## Example 4: User says "quick demo of this project"

```
User: "quick demo of this project"

AI:
=== Your Situation ===
Detected: demo/prototype mode
Need: fast docs, not formal

=== My Proposal ===
Skill: writing-spec-simple (demo mode)

Reasons:
- Signal: demo/fast/prototype
- Need fast docs, no formal process
- Only a simple AGENTS.md

Expected result:
- AGENTS.md with tech stack + commands in 2-3 min
- No specs, glossary, or decisions needed
- Ready to demo immediately

=== Next Steps ===
I will:
1. Ask for tech stack and build/test commands
2. Create AGENTS.demo.md (2-3 min)
3. Review with you

Do you agree?
```
