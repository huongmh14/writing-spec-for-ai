# Progress

## Current batch

- RUN-ID: SPEC-AGENT-EXECUTION-FIX-20261109.
- Authorization: correct remaining errors and optimize the English spec following the initial documentation commit `e977b0a`.
- Deliverables: [execution spec](specs/SPEC-AGENT-EXECUTION.md), smaller skill entry points, portable checks, standalone asset preservation, regression check and updated decision/bug records.
- Preserve the pre-existing English translations of the root entry and eight core sub-skills; do not overwrite or include unrelated translations in this maintenance commit.
- Runtime implementation, Docker operation and remote push remain outside this batch. The 17 runtime acceptance scenarios remain unchecked.

## Verified status

- [x] Tightened stable environment identity, reconciliation, lock-wait deadlines, secret redaction and native-cache-first adoption.
- [x] Fixed 24 documentation gate failures without increasing line limits or removing trigger/C17 requirements.
- [x] Root entry fits 65 lines; all five beginner entries fit 110 lines. Extracted guidance is conditionally linked; mandatory procedure pointers remain explicit.
- [x] Regression check passes: translated triggers accepted; generic descriptions, missing C17 and excessive length rejected. Actual standalone copy block preserves all 15 skills' local assets by hash in an isolated workspace fixture.
- [x] Native Git Bash health check passes all 10 checks, including invocation from another working directory. The default WindowsApps Bash shim remains a host limitation.
- [x] Same-model clean-session review found and verified the fix for missing standalone assets. No remaining actionable findings; this is not cross-model review or runtime evidence.
- [x] Working-tree gate and staged-snapshot regression pass. Selective staging excludes the eight core translations and retains the root translation as an unstaged change. Whitespace check passes.
- [x] PowerShell lean installation synchronized all shared agent roots and agent definitions: one discoverable skill, 15 nested sub-skills. Required portable-bundle sync completed: 261 skills (37 hot, 224 cold), 25 plugins and 20 subagents.
- [x] Maintenance changes are ready for the authorized local commit; obtain its SHA with `git log -1 --oneline`. No remote push is authorized or performed.

## Remaining limits and handoff

The runtime design is still Draft. A future implementation batch discovers the target repository's native runner, fixture commands, revision proof, OS controls and calibrated budgets before implementing or claiming acceptance. Missing evidence causes execution rather than speculative reuse. Bash installer parity is recorded in [INSTALL-002](conflicts-and-bugs.md); use the tested PowerShell lean installation on this host.

No new runner, daemon, cache engine or dependencies were added. Local skill synchronization is required by AGENTS.md; it does not establish runtime acceptance. Consult [decisions](decisions.md) and [bug history](conflicts-and-bugs.md) before continuing.
