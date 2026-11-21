# Conflicts and bugs

User-reported runtime symptoms remain unverified here; see [spec provenance](specs/SPEC-AGENT-EXECUTION.md#1-outcome-and-provenance). Baselines below identify observed states; the maintenance fix SHA is discoverable with `git log -1 -- docs/conflicts-and-bugs.md` after committing.

## DOC-001 - Retry count versus total attempts: fixed

- Baseline: `da048bf`, observed 2026-11-09; contained in spec commit `e977b0a`, source pack corrected in this maintenance batch.
- Root cause / blast radius: the job pack mixed additional retries with total executions, allowing an extra attempt or an early stop.
- Fix: [PK-JOB](../packs/PK-JOB.md) defines maximum attempts as initial execution plus retries; retries are at most `max-attempts - 1`.
- Mechanical check: inspect parameter, R02, R03 and AC02 together with `rg -n 'attempt|retry|retries' packs/PK-JOB.md`; the example still permits exactly three total attempts. No runtime job test is claimed.

## DOC-002 - Repository documentation gate: fixed

- Baseline: `e977b0a` plus nine pre-existing modified skill files, observed 2026-11-09; 24 gate failures.
- Root causes: English trigger/C17 equivalents rejected, oversized entry points and personal absolute paths. Blast radius: whole-repository gate failure and excess prompt loading.
- Fix: precise bilingual patterns, conditional reference extraction under unchanged limits, portable paths. Existing translations preserved.
- Mechanical check: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/validate.ps1`; regression: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/test-validation.ps1`. Both pass; the regression includes negative cases.

## ENV-001 - Default Windows Bash shim: workaround verified

- Baseline: `da048bf`, observed 2026-11-09; `bash` resolved to WindowsApps and failed before execution with `Bash/Service/CreateInstance/E_ACCESSDENIED`.
- Host root cause remains unverified. The health script also used personal installed paths, causing ten failures when native Bash actually ran.
- Fix / containment: derive paths from the script location; use installed Git Bash without altering host configuration.
- Mechanical check: `& 'C:/Program Files/Git/bin/bash.exe' -c 'cd scripts && bash skill-health-check.sh'` passes all ten checks. Sandbox process restrictions require elevated tool execution on this host; no runtime acceptance follows.

## DOC-003 - Unsafe reuse and cleanup races: draft corrected

- Baseline: `da048bf`; corrected before spec commit `e977b0a` after independent same-model review.
- Root causes / blast radius: excluded consumed generated artifacts, disposable borrowing and non-durable cleanup barriers could permit stale evidence or conflicting replacement.
- Fix: fingerprint consumed artifacts/provenance, prohibit disposable borrowing, protect active persistent borrowers and reconcile durable barriers under the startup lock.
- Mechanical acceptance: planned [AC09 and AC17](specs/SPEC-AGENT-EXECUTION.md#8-acceptance-criteria-and-visible-test-matrix), still unexecuted. Document review establishes contract completeness only.

## DOC-004 - Configuration identity and secret persistence: draft corrected

- Baseline: `e977b0a`, observed 2026-11-09 during maintenance review.
- Root causes / blast radius: changing configuration could imply a fresh logical identity and bypass old-instance reconciliation; full logs/arguments could persist secrets; lock waits could evade operation deadlines.
- Fix: stable environment slot, separate configuration version, shared reconciliation lock, inclusive deadlines and redaction before persistence. Incomplete evidence cannot authorize reuse.
- Mechanical acceptance: planned [AC03, AC05 and AC14](specs/SPEC-AGENT-EXECUTION.md#8-acceptance-criteria-and-visible-test-matrix), unexecuted.

## INSTALL-001 - Standalone local assets omitted: fixed

- Baseline: `e977b0a`; exposed by reference extraction in this maintenance batch before publication.
- Root cause / blast radius: PowerShell standalone copied shared assets and SKILL.md but omitted local references/templates/scripts, breaking mandatory procedure links.
- Fix: overlay each sub-skill's local assets after shared assets. Removed guidance advertising nonexistent PK-UI, PK-E2E and PK-SEC packs.
- Mechanical check: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/test-validation.ps1` invokes the production standalone block in a disposable fixture and compares all local asset hashes. Passes for all 15 skills.

## INSTALL-002 - Bash installer has an older skill inventory: fixed

- Baseline: `e977b0a`, observed 2026-11-09. Fix commit: none.
- Root cause / blast radius: install.sh enumerates ten core skills while PowerShell discovers fifteen. Bash standalone omits the five beginner skills; Bash lean leaves their nested SKILL.md entries discoverable. It also lacks the standalone local-asset overlay.
- Containment: use PowerShell lean installation for this synchronization. Fixed 2026-11-21: `install.sh` now discovers `skills/*/` like PowerShell and overlays each skill's local assets. Kit signal: `kit-missed` · full · pre-`20521c3`.
- Mechanical check: compare `rg -n 'SUBSKILLS|SUB_DEST|cp -r' install.sh` with `Get-ChildItem skills -Directory` and the PowerShell standalone regression fixture ; after the fix, `HOME=$(mktemp -d) bash install.sh --standalone` yields 15 skill dirs and lean yields 1 top-level skill with 14 nested, 0 `SKILL.md`.

## ROUTE-001 - auto-guide routed by file count only: fixed

- Baseline: `22538d4`, observed 2026-11-21 from 3 user projects (research repo with 239 source files would go to the full process). Fix commit: `6f322ce`.
- Root cause / blast radius: size rule `< 50 files` ignored project type; research loops that drop gates by hand were forced into the heavy process.
- Fix: experiment/research loop routes to `fast-track` at any size.
- Mechanical check: `rg -n "fast-track" skills/auto-guide/SKILL.md`. Kit signal: `kit-missed` · full · `22538d4`.

## STALE-001 - Counts and line limits in docs out of date: fixed

- Baseline: `20521c3`, observed 2026-11-21. Fix commit: this batch.
- Root cause: `AGENTS.md` said 64 lines (ratchet allows 65) and `README.md` said 9 sub-skills while 14 install. Hardcoded numbers drift.
- Fix: updated both. Mechanical check: `bash scripts/skill-health-check.sh` and `scripts/validate.ps1` (line ratchet). Kit signal: `kit-ignored` (one-truth-one-place: counts should be derived, not copied) · full · `20521c3`.

## PRIV-001 - Machine path in new script example: fixed

- Baseline: uncommitted `audit-project.ps1`, 2026-11-21; caught by `validate.ps1` `[PRIVACY]`. Fix: placeholder path before commit.
- Mechanical check: `scripts/validate.ps1`. Kit signal: `kit-caught` · full · `20521c3`.
