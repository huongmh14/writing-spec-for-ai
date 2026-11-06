---
name: auto-guide
description: AI automatically detects the situation and proposes the appropriate skill/option for the user — the user never has to guess what to do
license: MIT
trigger_phrases:
  - "which skill should I use"
  - "help me pick a skill"
  - "I'm <situation>"
do_not_use:
  - "When the user already named a specific skill"
  - "When the task is simple and needs no routing"
---

# Auto Guide - AI Auto-Routing

**Goal:** The user should NOT need to know which skill fits. The AI detects the situation and proposes a clear skill/option with reasons.

**When it activates:**
- User speaks generically: "fix this bug", "implement this feature", "look at this project"
- User does not mention a specific skill
- AI is unsure what the user wants  auto-guide activates

---

## Golden Rules

### 1. AI Must Choose — Never Make the User Guess

**WRONG:**
- "Do you want to use explore or writing-plans?"
- "Which skill do you prefer?"

**RIGHT:**
- "I propose `explore` because you don't understand the codebase yet. Then `writing-plans` because the task needs to be split."
- "Based on context, `systematic-debugging` fits because this is a bug and the root cause is unknown."

### 2. Always Give Clear Reasons

Proposal format:
```
Proposal: <skill-name>
Reason: <context analysis + signals>
Expected result: <what will happen>
```

### 3. Multiple Options  Present Clear Choices

Format:
```
Your situation: <context>

Option 1: <skill A>
  When to pick: <condition>
  Reason: <reason>
  Example: <example>

Option 2: <skill B>
  When to pick: <condition>
  Reason: <reason>
  Example: <example>

My recommendation: <recommendation> because <primary reason>
```

### 4. Don't Over-Analyze — Act

- Maximum 2-3 commands to detect context
- Then  propose action immediately
- Don't ask generic questions

---

## Detection Rules — Situation Signals

### Signal 1: Bug / Error / Failure
**Keywords:** bug, error, fail, wrong, crash, 500, 404, broken
** Propose:** `systematic-debugging`

### Signal 2: First time in project / unfamiliar codebase
**Keywords:** new here, first time, don't understand, look at project, understand, explore, codebase
** Propose:** `explore`

### Signal 3: New project / no AI docs yet
**Keywords:** new project, AGENTS.md, docs for AI, standardize docs
**Detection:** Project < 50 files  `writing-spec-simple`, >= 50 files  `writing-spec-for-ai`
** Propose:** `writing-spec-simple` or `writing-spec-for-ai`

### Signal 4: Has requirements/spec to implement
**Keywords:** implement, feature, requirements, spec, design doc, plan
**Detection:** Small task  code directly, Large task  `writing-plans`
** Propose:** `writing-plans` or code directly

### Signal 5: Code review / PR / branch
**Keywords:** review, PR, branch, changes, diff, merge
** Propose:** `code-review`

### Signal 6: Refactor / restructure
**Keywords:** refactor, restructure, cleanup, organize, extract, split
** Propose:** `safe-refactor`

### Signal 7: Test-first / TDD
**Keywords:** TDD, test-first, red-green-refactor
** Propose:** `tdd`

### Signal 8: About to finish / needs verification
**Keywords:** done, complete, verify, check, confirm
** Propose:** `verification-before-completion`

### Signal 9: Demo / Fast / Prototype
**Keywords:** demo, fast, prototype, POC, quick test
** Propose:** `writing-spec-simple` (demo mode)

### Signal 10: New idea
**Keywords:** idea, concept, brainstorm
** Propose:** `idea-to-spec`

---

## Decision Tree

See details in `references/decision-tree.md`

---

## When No Clear Signal

If the user speaks generically and no signal is detected:

**WRONG:**
- "What do you want to do?"
- "Which skill do you prefer?"

**RIGHT:**
```
I'm not sure about your situation. Help me understand:

Are you:
1. Fixing a bug?
2. Implementing a new feature?
3. Reviewing code?
4. Exploring a new project?
5. Writing a plan for a large task?
6. Doing a quick demo?
7. Working on a new idea?

Pick a number or describe briefly.
```

**After the user picks  AI re-runs auto-guide with the matching signal.**

---

## Response Format Template

### Single Proposal (Clear Case)

```
=== Your Situation ===
<Context summary>

=== My Proposal ===
Skill: <skill-name>

Reasons:
- Signal 1: <first signal>
- Signal 2: <second signal>
- Conclusion: <why this skill>

Expected result:
- <what will happen>
- <benefit>

=== Next Steps ===
I will: <action 1>
Then: <action 2>

Do you agree? (yes/no or adjustments)
```

### Multiple Options (When Several Fit)

```
=== Your Situation ===
<Context summary>

=== Options ===

Option 1: <skill A>
  When to pick: <condition>
  Reason: <reason>
  Example: <example>
  Pros: <pros>
  Cons: <cons>

Option 2: <skill B>
  When to pick: <condition>
  Reason: <reason>
  Example: <example>
  Pros: <pros>
  Cons: <cons>

=== My Recommendation ===
I recommend: <recommendation>
Because: <primary reason>

Which option? (1/2 or describe otherwise)
```

---

## Examples

See details in `references/examples.md`

---

## Rules for the AI

### Must Do

1. **Always analyze context before proposing**
   - Check keywords in the user message
   - Check project state (AGENTS.md? file count?)
   - Check git state (uncommitted changes? branch?)

2. **Always give clear reasons**
   - Why this skill?
   - What are the context signals?
   - What is the expected result?

3. **Always have concrete next steps**
   - What will I do?
   - What does the user need to provide?
   - When to stop for review?

4. **If unsure  ask a clarifying question**
   - Maximum 1-2 questions
   - Provide options to pick from
   - Never leave the user guessing

### Must Not Do

1. **No generic questions**
   - "What do you want to do?"
   - "Which skill do you prefer?"
   - "Are you fixing a bug or implementing a feature?"

2. **Never let the user pick the skill**
   - "Do you want explore or writing-plans?"
   - "I propose explore because X, then writing-plans because Y"

3. **Don't over-analyze**
   - Maximum 2-3 commands to detect
   - Then propose action immediately

4. **No jargon**
   - Keep language simple
   - If a term is used  explain it right away

---

## Integration With Other Skills

When auto-guide proposes skill X  skill X must also:
- Keep context from auto-guide
- Never leave the user lost
- Have a clear handoff

Example:
```
auto-guide  "I propose systematic-debugging"
 systematic-debugging: "Per the proposal, I'll start Phase 1: Root Cause Investigation..."
```

---

## Checklist Before Proposing

The AI must check:
- Analyzed context (keywords, project state, git state)
- Detected a clear signal
- Has a reason for the proposal
- Has concrete next steps
- Simple language, no unfamiliar jargon
- User never has to guess

---

**Summary:** The AI must be a navigator, not a tour guide. The user says "take me there" — the AI finds the route without asking "which road do you want?".

## When NOT to Use

- User explicitly names a specific skill
- User provides clear technical direction
- Simple one-off tasks where auto-detection adds overhead
