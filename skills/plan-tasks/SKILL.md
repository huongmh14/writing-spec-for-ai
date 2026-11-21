---
name: plan-tasks
description: Use at Step 7.5 (after Gate 3) or when the user asks to "split a SPEC into a task graph", "split Tracer-Bullet tasks" from an approved SPEC. Only opens at Step 7.5 to build a task graph with Blocked-by relations; do not open without a SPEC or while surveying/writing specs.
---

# Plan tasks — split a Spec into a Task Graph & Tracer Bullets (Step 7.5)

Input: approved `SPEC-<NAME>` (and `DESIGN-<NAME>` if any) + `docs/glossary.md`, `docs/decisions.md`.
Output: plan file `docs/plans/<nn>-<spec-name>-plan.md` per `templates/docs/plans/_plan-template.md` (or export a ticket list for the issue tracker / `.scratch/<slug>/issues/`).

Profile S uses `docs/spec.md`/README and the batch block in `AGENTS.md`; no separate plan/progress needed, still record behavior/AC/verification/stop points.

**Execution authority (**per-batch execution authority**, `C30`):** `Ready` and plans only fix requirements/expected work. The current batch in `docs/progress.md` must record the user's real direction, SPEC/task/AC, file areas, exclusions, and stop points. Default without stated boundaries: **1 SPEC + 1 task**, do → verify → report → stop. Explicit requests for a batch/whole finite spec get exactly that scope recorded and completed; don't re-ask per task. Current user direction takes priority; the AI doesn't self-grant authority when editing the block.

> Root idea (internal reference skill, not evidence): `to-tickets`, `implement-spec`, `planning-and-task-breakdown`, `migration`, `blast-radius`. Borrowed concepts: Tracer Bullet (Hunt & Thomas, *The Pragmatic Programmer*); Expand–Migrate–Contract (Parallel Change — Danilo Sato, martinfowler.com/bliki/ParallelChange.html). Short meanings: [glossary](../../references/glossary.md).

## 1. Vertical slicing principle (Tracer Bullet — thin slice spanning all layers)

Don't split tasks by horizontal layers (*"Task 1: all DB, Task 2: all API, Task 3: all UI"* — only at the last task do you find the assembly is off). Every normal task must be a **Tracer Bullet**:

- **Spans all layers** (schema → logic/API → UI/CLI → acceptance test `AC-ID`) for one narrow behavior that **runs end-to-end**.
- **Fits one clean session:** ~`5` files expected; completable and verifiable in one session. Fixing shared functions/necessary callers within the same behavior is allowed; report impact, don't self-add behavior.
- **Clear the path first (Prefactoring):** *make the change easy, then make the easy change* — if a function/module must be extracted for the main slice to fit, put the prefactoring task first.

## 2. Exception: wide multi-file changes → Expand–Migrate–Contract

When a mechanical change (renaming a column, changing a shared function/type signature in dozens of places) breaks many files at once so vertical slices can't go green:

1. **Task 1 — Expand:** Add the new structure/column/function alongside the old; keep both alive so CI stays green.
2. **Tasks 2..N — Migrate (data/call sites) in batches:** Migrate call sites cluster by directory/module, verify within each batch (each batch 1 task, `Blocked by: Task 1`).
3. **Last task — Contract:** Delete the old structure/column/function once nothing calls it (`Blocked by: all Migrate tasks`).

## 3. Dependency graph (Task Graph) & ready tasks

Tasks aren't a flat list but a **directed graph (DAG)**:

- Each task declares **`Blocked by:`** (list of task IDs that must finish first; write `None` if immediately doable).
- **Ready task:** all tasks in `Blocked by` are complete; this is only a dependency relation, not start authority. Subagents only run the assigned batch's parts, using context pointers (SPEC/AC, base commit, batch link); they don't self-pick the next task/spec. Parallelizing other tasks only when the user explicitly assigned that batch.

## 4. One-task presentation & Test Evidence Table (**visible test evidence**, `C29`)

Each task doesn't just list test commands — it must declare the **planned test matrix before coding** and on completion fill the **test-run evidence table** (`C29`) so developers see what data the AI fed and whether mocks were used:

```markdown
### T-01: <short end-to-end behavior name, glossary terms>
- **Acceptance REQ / AC:** `<NAME>-R01`, `<NAME>-AC01`, `<NAME>-AC02`
- **Blocked by:** `None` (or `T-01, T-02`)
- **Expected file scope (~5 files):** `<paths>`
- **Plan & Transparent Test Evidence (`C29`):**
  | AC-ID | Scenario | Expected input | Expected output & side effects | Tier & fidelity (`0 Mock` / which mocks) | Run status |
  |---|---|---|---|---|---|
  | `<NAME>-AC01` | <main branch> | `<payload/params>` | `<HTTP 200 / DB row / DOM>` | `integration` (`0 Mock`) | `[]` |
- **Verification command:** `<command running the test containing AC-ID>`
- **Stop point:** `<demoable behavior / AC complete; don't auto-advance task>`
- **Status:** `[]`
```

## 5. Present plan and fix the assigned batch

Present the table `ID | Visible behavior | Blocked by | AC-ID | How to demo`. The user picks outcomes/scope; the AI is responsible for checking dependency edges and feasibility via code/tests — don't make the user approve out-of-expertise technical details.

- With clearly assigned scope, record the batch and continue — don't re-ask. Without implementation direction, only hand over the plan; an approved plan doesn't auto-permit running everything.
- When the batch finishes: update to `Awaiting verification`, report **result · demo/evidence · unverified items · stopped point**, then stop. `[~]` unverified is not enough to move the spec to `Done`.
- Changing behavior/spec/security risk or schema outside assigned scope → update scope before doing that part; don't block independently assigned parts.

## Check before done

- [ ] Every `REQ` and `AC` in the spec's scope belongs to at least one task.
- [ ] Each task is a verifiable vertical slice (or a step in an Expand–Migrate–Contract chain).
- [ ] Each task has explicit `Blocked by` and a Verify command tied to `AC-ID`.
- [ ] No dependency cycles in the task graph.
- [ ] Plan links to a current batch in `docs/progress.md`; doesn't self-approve ready batches/tasks or infer authority from old HANDOFFs.
