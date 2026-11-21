---
name: generate-verify-harness
description: Use at Step 7.5-8 or when the user explicitly asks to "create a verify skill" or "create an automatic verification harness for the app". Open only to generate .agents/skills/verify-<app>/SKILL.md (Launch, Doctor, Drive, Evidence, Cleanup); never open it during the spec-writing steps.
---

# Generate verify harness - create a real-world verification skill for the project

Input: the project repo + `AGENTS.md` + `docs/specs/`.
Output:
1. `.agents/skills/verify-<app-name>/SKILL.md` (mirrored to `.claude/skills/` or `.cursor/skills/` if the project uses them).
2. A verification feature map `.agents/skills/verify-<app-name>/features/README.md` with 3-5 main flows.

> Origin of the idea (internal reference skills, not evidence): `pstack/create-verification-skill`, `playwright`; Core rule **Check the effect of operational commands** (`C19` - verify the real effect, not just the exit code).

## 1. Survey the control mechanism from the repo (never ask what the code already answers)

Before writing the skill, read the repo yourself to determine 5 factors:
- **Surface:** Web UI, HTTP API, CLI/TUI, worker/daemon, or desktop/Electron?
- **Launch:** the start command from a clean state (including migration + seed if any), network port, environment variables, and the **real readiness signal** (a specific log line or a health endpoint returning `200`, not merely a process that has started).
- **Drive tool:** prefer a harness already in the repo (Playwright, test runner, CLI script, `curl`); only if none exists choose a standard tool (Playwright/CDP for Web, an isolated PTY/subshell for CLI, an HTTP client for API).
- **Evidence collected:** screenshots, terminal recordings, HTTP response body + status, log lines with a `requestId`, and the data state in the DB/files after the action.
- **Isolation:** can two verification sessions run in parallel (separate port, separate DB/temp folder)? If not, state a locking rule so a session does not overwrite the developer's.

## 2. Required structure of `.agents/skills/verify-<app-name>/SKILL.md`

Write it for **the next agent who knows nothing about the app** (leave no `<...>` placeholder behind):

1. **Launch:** the full start command and how to confirm the system is ready to serve.
2. **Doctor:** one read-only command running in `< 3 seconds` that answers *"is this instance alive, on the latest build, and ready for testing?"*.
3. **Drive:** the control recipe using the project's real selectors/commands (prefer ARIA role/label, route paths, stable CLI flags).
4. **Evidence & test-run evidence table (`C19`, **visible test evidence** `C29`):** the acceptance-evidence standard for each `AC-ID`:
   - It must go through the real user path (no calling internal functions that skip the flow).
   - Check both the **surface response** and the **real side effects** (DB records, generated files, queue messages - rule `C19`).
   - **Print the test-run evidence table (`C29`):** at the end of every verify run, print a summary table so the developer sees clearly: `AC-ID | Scenario run | Input injected | Output & real side effects | Realism (0 mocks, or which parts are mocked) | Result & time`, with paths to screenshots / trace logs.
   - Save the evidence in a fixed folder so cleanup does not delete it.
5. **Cleanup:** the command that stops exactly the processes this verification session started (by PID / a container with its own name; **never `killall` by a generic name**), removes junk data but keeps the evidence folder (`Evidence`).

## 3. Create the feature map (`features/README.md`)

Create a list of 3-5 core flows matching the most important `SPEC-<NAME>` files. For each flow write four short items:
- `Sub-behaviors (related AC-IDs)`
- `How to reach the flow (user's point of view)`
- `How to drive it with <harness>`
- `Gotchas (known traps + date last checked - the dated-gotcha rule, C18)`

## 4. Real dry run before handover

You must execute the instructions you just wrote once from start to finish for at least 1 flow: **Launch -> Doctor -> Drive -> Capture Evidence -> Cleanup**, then confirm the evidence files still exist after Cleanup. If any step stumbles, fix it in the skill immediately and run again.

## Check before finishing

- [ ] `.agents/skills/verify-<app-name>/SKILL.md` has valid YAML frontmatter (`name`, `description`) and no placeholders left.
- [ ] All 5 sections exist: `Launch`, `Doctor`, `Drive`, `Evidence`, `Cleanup`.
- [ ] At least 1 flow was really run end to end, and its evidence survived the `Cleanup` step.
