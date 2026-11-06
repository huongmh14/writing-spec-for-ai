---
name: idea-to-spec
description: Analyze an idea, assess feasibility, scale, and maintainability, write a spec, and review code after implementation. For users who only bring an idea — the AI does the rest.
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

**Goal:** The user only provides an idea  the AI does full analysis  writes the spec  reviews code after implementation.

**When to use:**
- User has a new idea and doesn't know if it's feasible
- User wants a feasibility assessment before investing
- User needs a spec from a raw idea
- User wants the AI to analyze scale and maintainability

**When NOT to use:**
- A clear spec already exists  use `writing-spec-simple` or `writing-spec-for-ai`
- Only fixing a bug  use `systematic-debugging`
- Small task needing no analysis  code directly

---

## Procedure (Look  Check)

### Step 1: LOOK - Gather Information

**Goal:** Understand the idea and context

- [] Read the user's idea
- [] Ask clarifying questions (max 3):
  - "What problem does this idea solve?"
  - "Who is the target user?"
  - "Any deadline or constraints?"
- [] Check project context (if any):
  - Does AGENTS.md exist?
  - How many files is the project?
  - What is the current tech stack?

**Output:** Clear understanding of the idea + context

---

### Step 2: ANALYZE - Assess Feasibility

**Goal:** Full analysis before writing the spec

#### 2.1 Feasibility Analysis

**Questions to answer:**
- Is this idea technically feasible?
- Are there complex dependencies?
- Does it need third-party services?
- Are there major technical risks?

**Output:** `docs/idea-analysis.md` - Feasibility section

#### 2.2 Scale Prediction

**Questions to answer:**
- If successful, what scale will it reach?
- Estimate users, data, traffic?
- Can the architecture scale?
- Any hidden bottlenecks?

**Output:** `docs/idea-analysis.md` - Scale section

#### 2.3 Maintainability Assessment

**Questions to answer:**
- Is the code easy to maintain?
- What is the technical debt risk?
- What team size is needed?
- Documentation requirements?

**Output:** `docs/idea-analysis.md` - Maintainability section

#### 2.4 Dependencies & Risks

**Questions to answer:**
- What are the external dependencies?
- Which third-party services are needed?
- Business/legal risks?
- Technical risks?

**Output:** `docs/idea-analysis.md` - Dependencies & Risks section

---

### Step 3: WRITE - Write the Spec

**Goal:** Create a spec based on the analysis

#### 3.1 Create Idea Analysis Document

**File:** `docs/idea-analysis.md`

```markdown
# Idea Analysis - [Idea name]

## Feasibility
- **Technical feasibility:** [High/Medium/Low]
- **Dependencies:** [List dependencies]
- **Technical risks:** [List risks]
- **Conclusion:** [Is it feasible?]

## Scale Prediction
- **Estimated users:** [Expected user count]
- **Estimated data:** [Data volume]
- **Estimated traffic:** [Requests/day]
- **Scale architecture:** [Can it scale?]

## Maintainability
- **Maintenance difficulty:** [Easy/Medium/Hard]
- **Technical debt risk:** [Low/Medium/High]
- **Team size needed:** [Number of people]
- **Documentation needs:** [Doc requirements]

## Dependencies & Risks
- **External dependencies:** [List]
- **Third-party services:** [List]
- **Business risks:** [List]
- **Technical risks:** [List]
```

#### 3.2 Create Spec Document

**File:** `docs/specs/SPEC-001-[feature-name].md`

**Pick template by project size:**
- < 50 files  `writing-spec-simple/templates/SPEC.simple.md`
- >= 50 files  `writing-spec-for-ai/templates/docs/specs/_template.md`

**Spec must include:**
- Requirements (REQ) with feasibility notes
- Scale-predicted architecture
- Maintainability guidelines
- Review checklist

---

### Step 4: CHECK - Verify & Review

**Goal:** Ensure the spec is complete and accurate

- [] Does the spec have enough REQ + AC?
- [] Is the feasibility analysis clear?
- [] Is the scale prediction realistic?
- [] Are maintainability guidelines sufficient?
- [] Are dependencies & risks documented?
- [] Has the user approved the spec?

**If the user hasn't approved:**
- Ask clarifying questions
- Update the spec based on feedback
- Repeat Step 3-4 until approved

---

## Checks (5 Yes/No criteria)

Before claiming "spec complete", must check:

- [] **Check 1:** Is there a clear feasibility analysis?
- [] **Check 2:** Is there a concrete scale prediction?
- [] **Check 3:** Is there a maintainability assessment?
- [] **Check 4:** Is there a spec with REQ + AC?
- [] **Check 5:** Has the user approved?

**If any check = No  not complete, keep improving.**

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
- `scripts/generate-spec.sh` - Spec generation script from template

---

## Learn (Continuous Improvement)

**After each user correction or feedback:**

1. Record the lesson in `references/lessons-learned.md`
2. Add a new check to the skill if needed
3. Update the procedure if needed

**Examples:**
- User says "this idea isn't feasible because X"  add to feasibility framework
- User says "scale prediction was wrong because Y"  update scale prediction method

---

## Integration With Other Skills

| Step | Skill | Description |
|------|-------|-------------|
| 1. Analyze idea | `idea-to-spec` | Feasibility, scale, maintainability |
| 2. Write spec | `writing-spec-simple` or `writing-spec-for-ai` | Depends on project size |
| 3. Plan implementation | `writing-plans` | Split tasks |
| 4. Code | `tdd` or direct | Implement |
| 5. Review | `code-review` | Check spec + standards |

---

**Summary:** `idea-to-spec` is the entry skill - the user only brings an idea, the AI does the rest: analyze, write spec, and prepare for implementation.

## When NOT to Use

- A clear spec already exists  use writing-spec-simple or writing-spec-for-ai
- Only fixing a bug  use systematic-debugging
- Small task needing no analysis  code directly
- Project already has a complete AGENTS.md  idea-to-spec not needed
