# Decisions

## D-01 — Use native execution tools before adding safeguards

Date: 2026-11-09. Status: Proposed design; implementation not authorized by this record.

Use native runner caches, process inspection and Compose identity first; add a repository-local guard only for a demonstrated gap. Rationale and rejected alternatives: [execution spec, section 2](specs/SPEC-AGENT-EXECUTION.md#2-approach-and-alternatives).

## D-02 — Separate environment identity, run ownership and evidence validity

Date: 2026-11-09. Status: Proposed design.

A conversation restart must not imply a replacement environment or fresh verification. Resource/evidence contracts and limits: [execution spec, sections 4–6](specs/SPEC-AGENT-EXECUTION.md#4-identity-ownership-and-local-records).

## D-03 — Deliver a spec before runtime changes

Date: 2026-11-09. Status: Confirmed scope.

The user requested an English design/spec and Git commit. This batch writes documentation only. Runtime implementation, skill installation/synchronization and external publication require their own scope; see [current progress](progress.md).
