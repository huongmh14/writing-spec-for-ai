# Spec-Writing Standards Research

**Research Date:** 2026  
**Purpose:** Gather spec-writing standards from Anthropic, popular GitHub repos, and industry best practices to inform skill collection documentation standards.

---

## 1. Anthropic's Spec/Documentation Standards

### 1.1 Core Principles (from Anthropic's documentation skill)

**Five Fundamental Principles:**
1. **Write for the reader** — Who is reading this and what do they need?
2. **Start with the most useful information** — Don't bury the lede
3. **Show, don't tell** — Code examples, commands, screenshots
4. **Keep it current** — Outdated docs are worse than no docs
5. **Link, don't duplicate** — Reference other docs instead of copying

### 1.2 Document Types Structure

**README:**
- What this is and why it exists
- Quick start (< 5 minutes to first success)
- Configuration and usage
- Contributing guide

**API Documentation:**
- Endpoint reference with request/response examples
- Authentication and error codes
- Rate limits and pagination
- SDK examples

**Runbook:**
- When to use this runbook
- Prerequisites and access needed
- Step-by-step procedure
- Rollback steps
- Escalation path

**Architecture Doc:**
- Context and goals
- High-level design with diagrams
- Key decisions and trade-offs
- Data flow and integration points

**Onboarding Guide:**
- Environment setup
- Key systems and how they connect
- Common tasks with walkthroughs
- Who to ask for what

### 1.3 PRD/Spec Structure (from Anthropic's write-spec skill)

**Required Sections:**
- **Problem Statement**: 2-3 sentences describing user problem, who is affected, impact of not solving it
- **Goals**: 3-5 specific, measurable outcomes tied to user or business metrics
- **Non-Goals**: 3-5 things explicitly out of scope, with brief rationale
- **User Stories**: Standard format ("As a [user type], I want [capability] so that [benefit]"), grouped by persona
- **Requirements**: Categorized as Must-Have (P0), Nice-to-Have (P1), and Future Considerations (P2), each with acceptance criteria
- **Success Metrics**: Leading indicators (change quickly) and lagging indicators (change over time), with specific targets
- **Open Questions**: Unresolved questions tagged with who needs to answer
- **Timeline Considerations**: Hard deadlines, dependencies, and phasing

### 1.4 AI-Native SDLC Approach

**Key Practice:** "Write the spec by interview"
- Claude interviews you about the change until it could write the spec
- Present the whole spec as a plan before writing anything
- Build from that spec in a fresh session
- The product owner "reviews that spec, but doesn't write it"

### 1.5 Skill-Specific Standards

**Progressive Disclosure (3-level system):**
- **Level 1 (YAML frontmatter):** Always loaded - provides enough to know when to use the skill (~100 tokens)
- **Level 2 (SKILL.md body):** Loaded when skill activates - instructions for the task (< 5,000 tokens / 500 lines recommended)
- **Level 3 (Resources):** Loaded on demand - `references/`, `scripts/`, `assets/` (unbounded)

**Skill Structure:**
```
skill-name/
├── SKILL.md                 # Entry point, behavioral rules, routing
├── references/              # Detailed methodology, platform-specific docs
│   ├── topic-a.md
│   └── topic-b.md
├── scripts/                 # Helper scripts
└── assets/                  # Templates, sample inputs
```

**Core Rule:** SKILL.md should control agent behavior, not merely explain a topic. It should:
- Explain what problem the skill solves
- Tell the agent what to do first after trigger
- Tell the agent when to load which `references/`
- Tell the agent when not to use the skill

### 1.6 Documentation Patterns

**Best Practices for Skills:**
- **Keep each skill focused on one job** - Resist bundling multiple behaviors
- **Keep the body concise** - Every sentence should add value
- **Write imperative steps** with explicit inputs and outputs
- **Test before submitting** - Install locally and verify content
- **License your work** - Always set a `license` field (MIT recommended)
- **Write a clear description** - One precise sentence beats a vague paragraph

**Description Writing:**
- Always write in third person (injected into system prompt)
- Be specific and include key terms
- Include both what the skill does and when to use it
- Example: "Reviews git diffs for correctness, style, and potential regressions"

---

## 2. Popular GitHub Repos - Spec-Writing Frameworks

### 2.1 GitHub Spec Kit (github/spec-kit)

**Overview:** Open source toolkit for AI coding agents with structured processes, reusable templates, and documented outcomes.

**Processes:**
- **Spec-Driven Development (SDD):** Build features from specification
- **Bug fixing:** Diagnose and repair broken behavior
- **Idea assessment:** Decide whether an idea deserves investment

**SDD Phases:**
1. **Specify:** High-level description of what you're building and why (user journeys, experiences, success metrics)
2. **Plan:** Technical plan with stack, architecture, constraints, multiple plan variations
3. **Clarify:** Quality gate to validate spec
4. **Implement:** Code generation based on spec
5. **Converge:** Verification and refinement

**Key Insight:** "Specifications don't serve code—code serves specifications. The PRD isn't a guide for implementation; it's the source that generates implementation."

**Spec Template Structure:**
```markdown
# Feature Specification: [FEATURE NAME]
Feature Branch: `[###-feature-name]`
Created: [DATE]
Status: Draft
Input: User description: "$ARGUMENTS"

## User Scenarios & Testing (mandatory)
### User Story 1 - [Brief Title] (Priority: P1)
[Describe this user journey in plain language]
Why this priority: [Explain the value]
Independent Test: [How to test independently]
Acceptance Scenarios:
1. Given [initial state], When [action], Then [expected outcome]

### Edge Cases
- What happens when [boundary condition]?
- How does system handle [error scenario]?

## Requirements (mandatory)
### Functional Requirements
- FR-001: System MUST [specific capability]
- FR-002: System MUST [specific capability]
```

### 2.2 OpenSpec (Fission-AI/OpenSpec) - 73.8K stars

**Core Philosophy:** "A spec says what your system does, in terms anyone could check — not how it's built."

**Good Spec Content:**
- Observable behavior users or downstream systems rely on
- Inputs, outputs, and error conditions
- External constraints (security, privacy, reliability, compatibility)
- Scenarios that can be tested or explicitly validated

**Avoid in Specs:**
- Internal class/function names
- Library or framework choices
- Step-by-step implementation details
- Detailed execution plans (those belong in design.md or tasks.md)

**Requirement Quality:**
- **One statement, one SHALL/MUST** - Split compound requirements
- **Observable** - Someone outside the code should be able to tell whether it holds
- **The right strength** - Use RFC 2119 keywords:
  - `MUST`/`SHALL`: Hard requirement, non-negotiable
  - `SHOULD`: Strong recommendation with room for justified exception
  - `MAY`: Genuinely optional

**Scenario Quality:**
- Concrete GIVEN / WHEN / THEN that could become an automated test
- Exercises its requirement (not just restating it)
- Covers cases that matter, not just happy path
- Names the case in the title ("Scenario: Rejects an expired token")

**Progressive Rigor:**
- Keep specs lightweight by default
- Scale rigor only when risk or coordination complexity demands it
- High-risk changes (cross-team, cross-repo, API-breaking, security-sensitive) get increased detail

**Workflow Artifacts:**
1. `proposal.md` - Why the change is needed
2. `specs/spec.md` - What behavior changes
3. `design.md` - How to build it
4. `tasks.md` - Implementation checklist

### 2.3 IEEE 830 / ISO/IEC/IEEE 29148 SRS Template

**Standard Outline:**
- **1. Introduction:** Purpose; scope; definitions, acronyms and abbreviations; references; overview
- **2. Overall Description:** Product perspective; product functions; user characteristics; constraints; assumptions and dependencies
- **3. Specific Requirements:** External interfaces; functions; performance requirements; logical database requirements; design constraints; software system quality attributes; object-oriented models
- **Appendices and Index:** Supporting material

**Modern Markdown SRS Template (jam01/SRS-Template):**
- Aligned with IEEE 830 and ISO/IEC/IEEE 29148:2011
- Emphasizes verifiable requirements, traceability, quality attributes
- Clear separation of "what" (requirements) from "how" (design)
- Built-in guidance, tips, and checklists for each section
- Traceability-ready requirement ID schema and verification matrix

### 2.4 "Ponital" Note

**Search Results:** No relevant spec-writing framework found for "ponital". The term appears to be:
- A misspelling of "point" in various contexts
- A surname (Ingrid Ponit, HR project coordinator)
- Not related to specification writing standards

**Recommendation:** Ignore this term as it doesn't relate to spec-writing frameworks.

---

## 3. Key Evaluation Criteria

### 3.1 What Makes a Good Spec?

**Structure:**
- Clear separation of "what" (requirements) from "how" (design)
- Progressive disclosure - essential info first, details on demand
- Hierarchical organization - metadata  body  resources
- Standardized sections (problem, goals, requirements, acceptance criteria)

**Clarity:**
- Write in plain English without jargon
- Use active voice and present tense
- One statement, one requirement (split compound requirements)
- Define terms, symbols, and acronyms
- Be concise - avoid unnecessary words

**Testability:**
- Every requirement must be observable and verifiable
- Concrete GIVEN/WHEN/THEN scenarios for each requirement
- Independent test descriptions for each user story
- Cover edge cases, not just happy path
- Negative requirements (what shouldn't happen)

### 3.2 Common Patterns and Templates

**User Story Format:**
```
As a [user type], I want [capability] so that [benefit].
```

**Requirement Format:**
```
FR-001: System MUST [specific capability]
```

**Scenario Format:**
```
Scenario: [Descriptive title]
- GIVEN [initial state]
- WHEN [action]
- THEN [expected outcome]
```

**Priority Levels:**
- P0 / Must-Have: Non-negotiable requirements
- P1 / Nice-to-Have: Strong recommendations
- P2 / Future Considerations: Optional features

### 3.3 Beginner vs Advanced Users

**Beginner-Friendly Approaches:**
- Quick start sections (< 5 minutes to first success)
- Progressive disclosure - basic info first, details available
- Examples before explanations (show, then tell)
- Clear "when to use" and "when NOT to use" guidance
- Common troubleshooting sections

**Advanced User Needs:**
- Comprehensive reference sections
- Edge case documentation
- Performance characteristics
- Integration patterns
- Extension points and customization options

**Progressive Disclosure Pattern:**
- Level 1: Always-loaded metadata (~100 tokens)
- Level 2: Body content when relevant (< 5,000 tokens)
- Level 3: Deep references on demand (unbounded)

### 3.4 Automation vs Manual Control

**AI-Native Approach (Anthropic):**
- Spec drives implementation, not documents it
- Agent interviews human to gather requirements
- Human reviews/approves spec before any code is written
- Spec is a living document - update first, then code

**Manual Control Points:**
- Approval checkpoints at each phase (specify, plan, implement)
- Human review of generated artifacts
- Manual clarification of ambiguous requirements
- Override mechanisms for agent decisions

**Automation Benefits:**
- Consistent structure and formatting
- Automated test generation from scenarios
- Traceability matrices generated automatically
- Quality gate enforcement

### 3.5 Context Length and Documentation Density

**Key Findings from Research:**

**The "Binding Cost" Problem:**
- The cost of a docs file is the amount you must read before you know what to read next
- Total length only matters when you genuinely have to read everything
- Structure can cut context cost by 83% (measured: 6,700 tokens vs 39,500 tokens)

**Recommended Limits:**
- **Hub file (router):** 200 lines max - read at every start
- **Entry block at top of thread file:** 100 lines max - only part read in full
- **SKILL.md body:** < 5,000 tokens / 500 lines recommended
- **Individual reference files:** Split by how they're read, not by size

**Agent Memory Architecture:**
- Documentation functions as external RAM for the model
- A 100k-line codebase needs roughly 25,000 lines of codified context (24% ratio)
- Three-tier architecture: hot (always loaded), warm (on demand), cold (queried via MCP)

**Context Engineering Principles:**
- Load only the snippets that answer the current task
- Write search queries from the task, before writing code
- Pin search to one library/version
- Use snippets, not whole pages
- Models get worse as prompt gets longer ("context rot")

**Answer-First Format:**
- Strip out pleasantries
- Focus on density
- Every line must serve a functional purpose
- If a rule is not explicitly codified, it does not exist to the agent

---

## 4. Relevant Standards for Skill Collections

### 4.1 Core Principles to Apply

**For Skill Metadata (Level 1):**
- Keep under 100 tokens
- Include: name, description (what it does + when to use it)
- Write in third person
- Include trigger phrases users might say

**For Skill Body (Level 2):**
- Keep under 500 lines / 5,000 tokens
- Focus on behavioral rules, not explanations
- Tell agent: what to do first, when to load references, when NOT to use
- Use imperative steps with explicit inputs/outputs
- Include quick start for beginners

**For References (Level 3):**
- Move detailed methodology here
- Platform-specific docs
- Long examples and catalogs
- Deep domain documentation
- One level deep only (no nested references)

### 4.2 Spec Template for Skills

**Recommended Structure:**
```markdown
---
name: skill-name
description: What it does + when to use it (trigger phrases)
license: MIT
---

# Skill Name

## What this skill does
[One-sentence summary]

## When to use this skill
[Specific triggers and contexts]

## Do NOT use for
[Boundaries and non-applicable scenarios]

## How to use this skill (for a coding agent)
[First action after trigger]
[Routing to references]
[Workflow steps]

## Quick workflow
[Step-by-step for common case]

## Minimum self-check
[How to verify it worked]
```

### 4.3 Documentation for Skill Collections

**AGENTS.md (Collection Index):**
- Group skills by capability, not filesystem order
- Answer: "When should an agent use each capability?"
- Document first file to read for each skill
- Include skill loading rules
- Use capability-based organization:
  ```
  ## Code & Repository Work
  - github: interact
  - code-review: review diffs
  
  ## Writing & Content
  - writing-style-skill: draft in user's voice
  - blog-drafter: create blog drafts
  ```

**Catalog Best Practices:**
- Central JSON catalog for titles, summaries, guide routes
- Navigation groups for discoverability
- Canonical SKILL.md files retain portable runtime instructions
- Filesystem validation to prevent silent disappearance
- Generated Markdown keeps lists visible in GitHub

### 4.4 Quality Assurance

**Testing Approach:**
- Install skill locally and read back through CLI
- Run agent against representative inputs
- Verify output matches intent
- Check discovery and trigger behavior
- Test skill descriptions against prompts

**Verification:**
- Passing docs build does not establish skill behavior
- Production verification checks changed pages
- Test missing and removed skills
- Test route failures and stale outputs

---

## 5. Summary of Key Takeaways

### 5.1 Most Important Principles

1. **Progressive Disclosure is Critical**
   - 3-level loading model (metadata  body  resources)
   - Keep hot-loading minimal (~100 tokens for metadata)
   - Move detailed content to on-demand references

2. **Behavior Over Implementation**
   - Specs describe WHAT, not HOW
   - Observable, testable requirements
   - Separate design.md from spec.md

3. **Context Economy**
   - Binding cost = what you must read before knowing what to read next
   - Structure can reduce context by 83%
   - Hub files < 200 lines, entry blocks < 100 lines

4. **Testability First**
   - Every requirement needs GIVEN/WHEN/THEN scenarios
   - Cover edge cases, not just happy path
   - Include negative requirements

5. **Human-in-the-Loop**
   - Agent interviews human to gather requirements
   - Human reviews/approves before code generation
   - Spec is living document - update first, then code

### 5.2 Recommended Standards for Your Skill Collection

**File Structure:**
```
skill-collection/
├── AGENTS.md                    # Capability-based index (< 200 lines)
└── skills/
    └── skill-name/
        ├── SKILL.md             # < 500 lines, behavioral rules
        ├── references/          # Detailed docs on demand
        │   └── topic.md
        ├── scripts/             # Helper scripts
        └── assets/              # Templates, examples
```

**SKILL.md Standards:**
- Frontmatter: name, description (third person, trigger phrases), license
- Body: what it does, when to use, when NOT to use, first action, routing
- Size: < 500 lines / 5,000 tokens
- Style: Imperative, no filler, examples first

**Spec Standards:**
- One statement, one requirement
- Observable and verifiable
- GIVEN/WHEN/THEN scenarios
- RFC 2119 keywords (MUST/SHOULD/MAY)
- Cover edge cases

**Collection Documentation:**
- AGENTS.md groups by capability, not filesystem
- Document first file to read for each skill
- Include skill loading rules
- Central catalog for discoverability

---

## 6. Sources

### Anthropic Sources
- [Anthropic Documentation Skill](https://github.com/anthropics/knowledge-work-plugins/blob/main/engineering/skills/documentation/SKILL.md)
- [Anthropic Write-Spec Skill](https://github.com/anthropics/knowledge-work-plugins/blob/main/product-management/skills/write-spec/SKILL.md)
- [Claude on AWS Workshop - Write the Spec by Interview](https://catalog.workshops.aws/anthropic-on-aws/en-US/ai-dlc/anthropic-sdlc/lab-2/write-the-spec-by-interview/)
- [Doc Co-Authoring Skill](https://www.mintlify.com/anthropics/skills/reference/doc-coauthoring)
- [Conduction Docs - Writing Documentation](https://docs.conduction.nl/claude/writing-docs/)
- [Claude Code Documentation Patterns](https://github.com/anthropics/claude-code/blob/main/plugins/plugin-dev/skills/command-development/references/documentation-patterns.md)
- [Build for Claude - Skills Guide](https://claude.com/docs/build/overview)
- [The Complete Guide to Building Skills for Claude](https://resources.anthropic.com/hubfs/The-Complete-Guide-to-Building-Skill-for-Claude.pdf)
- [Skill Authoring Best Practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)

### GitHub Repos
- [GitHub Spec Kit](https://github.com/github/spec-kit/) - 2,339 commits
- [Spec Kit Template](https://github.com/github/spec-kit/blob/main/templates/spec-template.md)
- [OpenSpec](https://github.com/Fission-AI/OpenSpec/) - 73.8K stars
- [OpenSpec Writing Guide](https://openspec.dev/docs/writing-specs)
- [IEEE SRS Template](https://github.com/rick4470/IEEE-SRS-Tempate)
- [Markdown SRS Template](https://github.com/jam01/SRS-Template) - 478 stars
- [Anthropic Skills](https://github.com/anthropics/skills) - 187.1K stars

### Progressive Disclosure & Context Research
- [Progressive Disclosure in Agent Skills](https://paladini.io/how-to-create-a-skill-tutorial/05-progressive-disclosure/)
- [Structure Patterns Reference](https://github.com/tencentcloudbase/cloudbase-mcp/blob/main/skills/skill-authoring/references/structure-patterns.md)
- [Cloudflare Agent Skills](https://developers.cloudflare.com/agents/concepts/agent-skills/)
- [Anatomy of a Skill](https://vercel.com/academy/agent-friendly-apis/anatomy-of-a-skill)
- [Docs as Agent Memory](https://piotrczerwinski.dev/writing/context-engineering-docs-as-agent-memory)
- [Documentation Layer Study](https://programmingtheloop.com/experiments/documentation-layer-study/)
- [Compact Documentation Benchmark](https://arxiv.org/html/2609.31587)
- [Context Engineering Guide](https://context7.com/guides/context-engineering-for-coding-agents)
- [Agent Memory Architecture](https://dodatathings.dev/blog/documentation-is-agent-memory)

### Testing & Acceptance Criteria
- [Acceptance Criteria Best Practices](https://www.techtarget.com/news/Acceptance-Criteria-What-it-is-and-its-best-practices/857414/)
- [Writing Effective Acceptance Criteria](https://docs.aviator.co/verify/how-to-guides/writing-effective-acceptance-criteria)
- [SRS Testing](https://www.techtarget.com/news/A-well-developed-software-requirements-specification-is-a5000)
- [BDD in Action](https://livebook.manning.com/book/bdd-in-action/chapter-7)
- [Specification-Based Test Techniques](https://www.techtarget.com/news/How-to-make-use-of-specification-based-test-techniques/859518/)

### Skill Collection Documentation
- [Turn Local Skill Library into Agent-Ready Docs](https://dev.to/bengreenberg/turn-a-local-skill-library-into-agent-ready-documentation-10c8)
- [Task-Focused Docs](https://skills.samcarlton.com/research/developer-docs-and-skill-catalog-2026-10-20/)
- [Build Skills](https://learn.chatgpt.com/docs/build-skills.md)
- [Skills.re Best Practices](https://skills.re/docs/best-practices)

### General Documentation Standards
- [Write the Docs - Documentation Principles](https://www.writethedocs.org/guide/writing/docs-principles/)
- [Home Office - Write Effective Documentation](https://engineering.homeoffice.gov.uk/patterns/write-effective-documentation/)
- [Open Specification Writing Guide](https://open-specification.org/writing-guide/)
- [NATSEP Specification Writing Guide](https://dipl.nt.gov.au/__data/assets/pdf_file/0020/234155/specification-writing-guide.pdf)

---

**End of Research Document**
