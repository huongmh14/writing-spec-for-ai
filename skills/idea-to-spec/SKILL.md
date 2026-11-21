---
name: idea-to-spec
description: Use when the user brings a raw idea and asks for feasibility, scale, maintainability analysis or a first spec.
license: MIT
trigger_phrases:
  - "I have an idea"
  - "analyze this project"
  - "write a spec for this idea"
  - "evaluate whether this project is feasible"
  - "from idea to spec"
do_not_use:
  - "When a clear spec already exists"
  - "When only fixing a bug"
  - "When the task is small and needs no analysis"
  - "When the project already has a complete AGENTS.md"
---

# Idea to Spec - From Idea to Spec

**Goal:** The user only provides an idea → the AI does full analysis → writes the spec → reviews code after implementation.

**When to use:**
- User has a new idea and doesn't know if it's feasible
- User wants a feasibility assessment before investing
- User needs a spec from a raw idea
- User wants the AI to analyze scale and maintainability

**When NOT to use:**
- A clear spec already exists → use `writing-spec-simple` or `writing-spec-for-ai`
- Only fixing a bug → use `systematic-debugging`
- Small task needing no analysis → code directly

---

## Required procedure

Before analysis, MUST read [the procedure](references/procedure.md). It covers information gathering, feasibility, scale, maintainability, spec drafting and feedback.


## Checks (5 Yes/No criteria)

Before claiming "spec complete", must check:

- [ ] **Check 1:** Is there a clear feasibility analysis?
- [ ] **Check 2:** Is there a concrete scale prediction?
- [ ] **Check 3:** Is there a maintainability assessment?
- [ ] **Check 4:** Is there a spec with REQ + AC?
- [ ] **Check 5:** Has the user approved?

**If any check = No → not complete, keep improving.**

---

## Guard (Safety Rails)

### [x] Allowed to Do Autonomously
- Analyze the idea
- Write the spec
- Assess feasibility, scale, maintainability
- Review code after implementation
- Ask clarifying questions

### (warning) Ask First
- Large scope changes
- Adding new dependencies
- Major architecture changes
- Committing code before spec approval

### (blocked) Never
- Fabricate feasibility analysis
- Promise unrealistic scale
- Ignore risks
- Code before spec approval
- Commit secrets, tokens

---

## Resources

- `references/feasibility-framework.md` - Feasibility assessment framework
- `references/scale-prediction.md` - How to predict scale
- `references/maintainability-checklist.md` - Maintainability checklist

---

## Scripts

- `scripts/analyze-idea.sh` - Automated idea analysis script

---


## When NOT to Use

- A clear spec already exists → use writing-spec-simple or writing-spec-for-ai
- Only fixing a bug → use systematic-debugging
- Small task needing no analysis → code directly
- Project already has a complete AGENTS.md → idea-to-spec not needed
