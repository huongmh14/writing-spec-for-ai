# Conflicts and bugs

This records encountered conflicts and verified defects, not hypothetical failures. User-reported runtime symptoms are attributed in the [execution spec](specs/SPEC-AGENT-EXECUTION.md#1-outcome-and-provenance); this batch did not reproduce them.

## DOC-001 — Retry count versus total-attempt count

- Observed: 2026-11-09 during the read-only contract survey.
- Documentation baseline: `da048bf`; fix commit: none, the source pack is unchanged in this batch.
- Evidence: [job pack](../packs/PK-JOB.md), parameter definition and retry acceptance example use retries/total attempts inconsistently.
- Root cause: one term counts additional retries while another counts every attempt, including the initial call.
- Blast radius: blindly inheriting the pack could add an extra execution or stop one attempt early.
- Containment: the new execution spec explicitly defines total attempts, including the first, and does not inherit application-job retry counts.
- Mechanical check: `rg -n 'retries|attempt|retry|thử|lần' packs/PK-JOB.md`; inspect its parameter and acceptance wording together before changing or inheriting it.
- Resolution boundary: document the encountered ambiguity now; correcting the existing pack is outside this spec-only batch. No runtime fix is claimed.

## DOC-002 — Repository documentation gate fails outside this batch

- Observed: 2026-11-09; baseline `da048bf` plus nine pre-existing modified skill files. Fix commit: none in this batch.
- Evidence: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/validate.ps1` exited 1: 24 issues across existing entry/skill descriptions, line-count ratchets, an entry marker and machine-specific paths. None names the five new documents. Full output: local temporary artifact `agent-execution-spec-validation.log`.
- Root cause: existing files do not meet the current validator's wording, size and path rules; attribution to a particular earlier commit was not investigated.
- Blast radius: the whole-repository documentation gate remains failing; a passing check of new documents cannot establish a repository-wide pass.
- Containment / mechanical check: preserve unrelated edits; run the command above for the whole gate and separately check this batch's relative links, text hygiene, requirement/AC uniqueness, unchecked runtime status and staged whitespace. Report both outcomes.

## ENV-001 — Bash health check cannot start

- Observed: 2026-11-09 on documentation baseline `da048bf`; fix commit: none.
- Evidence / mechanical check: `bash scripts/skill-health-check.sh` exited 1 before script execution with `Bash/Service/CreateInstance/E_ACCESSDENIED`. Local temporary artifact: `agent-execution-spec-health.log`.
- Root cause boundary: the Windows Bash service rejected startup; the underlying host cause is unverified. The script also targets installed skills, rather than evaluating this spec's runtime behavior.
- Blast radius / containment: the required Bash check is unexecuted; use the available PowerShell document checks, disclose this limitation and leave host configuration unchanged.

## DOC-003 — Draft execution contract allowed unsafe reuse and cleanup races

- Observed: 2026-11-09 in same-model clean-session review; baseline `da048bf`, corrected in this documentation commit before runtime implementation.
- Root causes: generated-output exclusions could hide consumed inputs; disposable-service borrowing could outlive its owner; cleanup failure lacked a precise durable barrier before releasing startup ownership.
- Blast radius: a future implementation could accept stale tests, interrupt a borrower or create a conflicting replacement. No such runtime defect was reproduced in this batch.
- Correction: fingerprint consumed artifacts/provenance; prohibit disposable borrowing and protect active persistent borrowers; persist unresolved barriers and reconcile under the startup lock.
- Mechanical acceptance checks: planned [AC09 and AC17](specs/SPEC-AGENT-EXECUTION.md#8-acceptance-criteria-and-visible-test-matrix). These remain unexecuted; the independent document review checks contract completeness only.
