# Scaling and skill combinations

## 3. Scaling Path & Skill Combination Patterns

### 3.1 Combining Skills as the Project Grows
```text
Phase 1: < 50 files, 1-2 people
├── auto-guide  explore  writing-spec-simple  writing-plans  code  verification-before-completion
└── Light 3-step process, no formal 3 gates

Phase 2: 50-200 files, 3-5 people
├── auto-guide  writing-spec-for-ai (Profile M)  writing-plans  code  code-review  verification-before-completion
├── Add: documentation-and-adrs (for ADRs) + safe-refactor (for safe refactors)
└── Required: docs/progress.md (session memory C17) + docs/conflicts-and-bugs.md (bug ledger C18)

Phase 3: 200+ files, 5+ people
├── auto-guide  writing-spec-for-ai (Profile L + Packs: PK-API, PK-DB, PK-AUTH, PK-OBS)
├── Add: using-git-worktrees + dispatching-parallel-agents (isolated parallel work)
├── Add: incremental-implementation (large rollout) + security-audit (security audit)
└── Required: formal 3 review gates (C02) + cross-model review (C26)
```

### 3.2 Four Common Integration Patterns
1. **Sequential Chain:**
   `explore`  `writing-spec-simple`  `writing-plans`  `code`  `verification-before-completion`
2. **Parallel Dispatch:**
   `writing-plans`  `using-git-worktrees`  `dispatching-parallel-agents`  `code-review`  `verification-before-completion`
3. **Feedback & Bug-Ledger Loop:**
   `code/test fails`  `systematic-debugging`  `fix`  log to `docs/conflicts-and-bugs.md` (`C18`)  `verification-before-completion`
4. **Upgrade Path (no data loss):**
   `writing-spec-simple`  keep `AGENTS.md` + `SPEC-*.md`  add `docs/specs/README.md`, `progress.md` (`C17`), `conflicts-and-bugs.md` (`C18`)  enable all 31 laws of `writing-spec-for-ai`.

---
