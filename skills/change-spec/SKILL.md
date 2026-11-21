---
name: change-spec
description: Use at Step 8 when requirements of a Ready/Done spec must change, or when the user says "draft change proposal CHG-xx", "update an approved SPEC". Only opens when editing an approved spec (ADDED/MODIFIED/REMOVED); do not open when writing a new spec.
---

# Change spec — changing an approved spec

`Draft`/`As-built` specs (describing existing code) not yet approved → edit directly within assigned scope. `Ready`/`In progress`/`Done` specs changing REQ/AC meaning → this process, even before coding; typo/link fixes that don't change meaning edit directly.

## 1. Choose the path (ask 3 questions in order)

| Question | Yes → path |
|---|---|
| Is the new part a **different area** of the system, able to stand alone? | **New child spec** (`write-spec`), old spec only links. |
| Is the new part large (many REQs) but same area, not yet started? | Child spec or new phase batch in a `Draft` spec — never append to a `Ready` spec. |
| Changing/removing existing REQs, or adding few REQs to a `Ready`/`Done` spec? | **Change proposal CHG-xx** (this skill). |

## 2. Write the proposal

Create `docs/changes/CHG-<number>-<slug>/proposal.md` from `templates/docs/changes/_proposal-template.md`:

- **ADDED** — new REQs, numbered continuing the spec's old sequence (never renumber old ones).
- **MODIFIED** — record `old: … → new: …` verbatim old REQ text. Changing a value inside a REQ requires fixing the REQ **in the same PR** (not just a decisions note).
- **REMOVED** — never delete the ID; mark deprecated + reason. Corresponding ACs also deprecated.
- **Impact**: migration, public API, downstream projects, upgrade docs — each item "None" if truly none.
- Attach decision: this change is a decision → add a `D-xx` row to `decisions.md`, proposal only links.

Proposal status: `Proposed` → present to user for approval → `Approved` → apply.

## 3. Apply after approval (same PR)

1. Edit the spec file per ADDED/MODIFIED/REMOVED — including the AC table and index in `docs/specs/README.md`.
2. MODIFIED ACs losing old validity → revert to `[ ]`, record in the spec's "Clarifications": date + CHG-id.
3. Move proposal to `Applied`, relocate into `docs/changes/archive/`.
4. If an AC was `[x]` but its REQ changed meaning → drop to `[ ]`, fix the corresponding test, rerun.
5. Reconcile the current batch in `docs/progress.md` (**per-batch execution authority**, `C30`): an approved CHG doesn't auto-grant execution beyond assigned scope. Revoke authority based on changed REQ/AC; continue only when user commands cover the new content.
6. A previously `Done` spec with new ACs or lost evidence loses `Done`: unconfirmed requirement changes keep `Draft`; confirmed requirements without a batch go `Ready`, executing ones `In progress`. Sync the index; don't self-approve requirements by status flips.

## 4. Closing P-xx

Undecided proposals live in the `P-xx` table in `decisions.md`. On conclusion: add a `D-xx` row (status Active), delete the old P-xx row **from the table** (don't leave finished items behind). Lifecycle: `P-xx (proposal) → D-xx (decided) → fix REQ/spec in same PR`.

## Gotchas

- Appending a large chunk directly into a `Ready` spec — the most common error; spec bloats, traceability chain breaks.
- Changing REQ but forgetting the corresponding AC → AC now proves something no longer true.
- Proposal saying "small tweak for flexibility" — unquantified; MODIFIED must include verbatim old text for comparison.
- decisions changing values (e.g. rate-limit threshold) while REQ keeps old numbers → two sources of truth contradict.

## Check before presenting

- [ ] Chose the right path (child spec vs CHG) per the 3-question table.
- [ ] MODIFIED has verbatim old → new; REMOVED only deprecates, never deletes IDs.
- [ ] Value changes fix the corresponding REQ in the same PR.
- [ ] Impact lists all (migration/API/upgrade); "None" must be truly none.
- [ ] P-xx table has no closed items left.
