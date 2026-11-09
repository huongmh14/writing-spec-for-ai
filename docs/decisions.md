# Decisions

## D-01 — Use native execution tools before adding safeguards

Date: 2026-11-09. Status: Proposed design; implementation not authorized by this record.

Use native runner caches, process inspection and Compose identity first; add a repository-local guard only for a demonstrated gap. Rationale and rejected alternatives: [execution spec, section 2](specs/SPEC-AGENT-EXECUTION.md#2-approach-and-alternatives).

## D-02 — Separate environment identity, run ownership and evidence validity

Date: 2026-11-09. Status: Proposed design.

A conversation restart must not imply a replacement environment or fresh verification. Resource/evidence contracts and limits: [execution spec, sections 4–6](specs/SPEC-AGENT-EXECUTION.md#4-identity-ownership-and-local-records).

## D-03 — Deliver a spec before runtime changes

Date: 2026-11-09. Status: Confirmed scope.

The initial English spec was committed as `e977b0a`, without runtime implementation or remote publication. The subsequent user request authorizes correcting and optimizing the spec and its repository gates. Local skill synchronization follows the repository's explicit AGENTS.md instruction; runtime implementation remains outside this maintenance batch. See [current progress](progress.md).

## D-04 - Preserve logical environment identity across configuration changes

Date: 2026-11-09. Status: Proposed runtime design.

Configuration and revision identify a version of an environment, not a new logical service slot. Reconcile the existing slot under the same lock before replacement; lock waits consume the operation deadline. Redact secrets before persisting logs or evidence. Contracts: [execution spec, sections 4-7](specs/SPEC-AGENT-EXECUTION.md#4-identity-ownership-and-local-records).

## D-05 - Keep loading limits and move detail behind explicit pointers

Date: 2026-11-09. Status: Applied repository maintenance.

Retain the 65-line entry and 110-line beginner-skill limits. Move reference detail into local assets, keep mandatory procedure pointers hot, and preserve those assets in standalone PowerShell installations. Accept precise English and Vietnamese trigger conditions without accepting generic descriptions. Regression check: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/test-validation.ps1`.
