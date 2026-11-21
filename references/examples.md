# Reference examples (taken from a real project, annotated)

Source: the spec set of a dashboard platform (NestJS + Quasar + Prisma). Every example below is a REQ/AC that was **accepted by tests** — use them as the benchmark when writing new specs. Origin: `docs/specs/04-rbac.md`, `13-security-nfr.md`, `docs/decisions.md`.

## 1. REQs in EARS form

| Real example | EARS pattern | Why it passes |
|---|---|---|
| `RBAC-R01` — A user not in the ACTIVE state has an empty effective permission set. | State | Condition + quantified result ("empty" is checkable) |
| `RBAC-R16` — Missing permission → 403 `AUTH_FORBIDDEN`. | Error | Concrete HTTP code + error code |
| `RBAC-R21` — A **narrowing** change (removing permissions, deprecating a role) applies immediately on sync, bumps `permVersion` of the affected users, and writes an AuditLog. | Event | One event + 3 observable consequences |
| `RBAC-R15` — Every change affecting effective permissions ... bumps `permVersion` of **every** affected user **in the same transaction**. | Event | Quantified "every", bounded by "same transaction" — narrow enough to test |
| `RBAC-R30` — MUST (phase 2) — `ORG`/`ORG_TREE` scope is based on `OrgUnit.path`... | Optional + phase | Has a timing; the agent does not build it early |

Contrast: the broken sentence `"The system must be secure and have flexible authorization"` — no EARS pattern, no number, not checkable.

## 2. ACs in Given / When / Then form

| Real AC | Structure |
|---|---|
| `RBAC-AC03` — *Given* a user with `orders:*` and a DENY on `orders:delete`, *when* calling `DELETE /orders/:id`, *then* 403. | The specific deny beats the wildcard; concrete input data |
| `RBAC-AC07` — *Given* a group of 50 members, *when* the group's permissions are edited, *then* `permVersion` of all 50 users is bumped in the same transaction. | Concrete count (50), countable consequence |
| `RBAC-AC12` — *Given* only one ACTIVE SUPER_ADMIN remains, *when* that account is locked, *then* 409 `RBAC_LAST_SUPER_ADMIN`. | AC for the error branch, with an error code |
| `RBAC-AC18` — *Given* the same effective permission set and requested code (including wildcards), *when* `matchPermission` runs on BE and FE, *then* the results are identical (the test uses a shared dataset). | Contract across several runtimes + shared test vectors |
| `NFR-AC08` — *Given* one user calling `POST /reports/:code/runs` over the limit (10 per minute), *when* sending, *then* the over-limit requests get 429 `RATE_LIMITED` and other users are unaffected. | NFR with an AC: numeric threshold + a condition that nothing leaks to others |

## 3. NFRs replace adjectives with numbers

| Vague adjective | Passing REQ (real) |
|---|---|
| "fast" | `NFR-R20` — Permission guard cost p95 < 5 ms (warm cache). |
| "spam-proof" | `NFR-R02` — Rate limit stored in Redis: per IP on `/auth/*`; per user on OTP sending and report export (default 10 per minute). |
| "monitored" | `NFR-R23` — Prometheus metrics: response time, error rate, queue length, number of failed 2FA attempts. |
| "well tested" | `NFR-R24` — Test coverage ≥ 80% for `rbac`, `auth`, `mfa`; CI blocks the merge if it drops below the threshold. |
| "recoverable" | `NFR-R26` — Daily PostgreSQL backup + WAL archiving, stored off the server; periodic restore drills. |

## 4. Decision rows (decisions.md)

| ID | Date | Decision | Short reason | Spec |
|---|---|---|---|---|
| D-08 | 2026-09-23 | Google login + separate 2FA: email OTP mandatory by default; TOTP optional; when TOTP exists, email OTP becomes the secondary method | Business requirement | SPEC-MFA |
| D-11 | 2026-09-23 | Images are pushed to the internal registry. **Replaces the "on GHCR" part of D-04**; the rest of D-04 stays | Use the internal registry | SPEC-REPO |

What makes them pass: one row per decision; a replacing row states *which part* of the old row it replaces; a target Spec is given for traceability.

## 5. Splitting spec areas for a project (the dashboard's 19 specs)

```
Architecture/core:   ARCH, REPO, MOD, DATA, API, NFR, ROADMAP, DOCS
Capability domains:  RBAC, AUTH, MFA, PASSKEY, ADMIN, UIKIT, WIDGET, REPORT, DATASET, NOTIF, INTEG, CLI
```

Derived rule: every spec can answer "who uses this feature to do what"; there is no minimum REQ count. The numbers in the historical example are not a target to fill: write in detail only the part about to be built (**per-batch execution authority** `C30`, **sources & knowledge limits** `C31`). An easy-to-read trial version: [controlled-spec-demo.md](controlled-spec-demo.md).

## 6. Plan per PR (docs/plans/M6.md, abridged)

| PR | Branch | Content | AC | Depends on | Parallel |
|---|---|---|---|---|---|
| 1 | `feat/SPEC-MOD-ext` | DomainEventBus, AuthHooks, ScopeResolver | MOD-AC20, AUTH-AC04 | — | [P] with 2 |
| 2 | `feat/SPEC-API-users` | `/users*`, `/me/permissions` | API-AC01, NFR-AC07 | 1 | |

Each PR carries a "minimum context": links to the exact spec sections + related files, so the agent does not load the whole spec.

## 7. Fixing vague sentences (before → after)

| Before (unusable) | After (passes) |
|---|---|
| "Secure login" | `AUTH-R01` — On receiving a Google ID token, the system MUST verify the signature, `aud`, `iss`, `exp`, `email_verified` on the server side; failure → 401 `AUTH_INVALID_TOKEN`. |
| "Exporting reports must not slow the system" | `REP-R04` — File export runs in the background through a queue; `POST /reports/:code/runs` is rate limited to 10 per minute per user (D-27). |
| "UI with role-based permissions" | `RBAC-R41` — The `v-can` directive (hide) and `v-can.disable` (disable) follow the effective permissions. |

## 8. Presenting direction visually (`C28` — Scope Radar & option cards)

When the user brings a vague idea (*"Build an order notification feature"*), instead of writing 20 dry REQs right away, present a **Scope Radar** + **2 visual options** at Gate 1 / in the Spec:

- **Scope Radar:**
  - (green) **Do now (MVP):** in-app notification bell (`WebSocket`) + store in the `notifications` DB table + mark as read.
  - (yellow) **Next batch (Phase 2):** send a summary email when the user is offline for more than 15 minutes.
  - (red) **Out of scope:** silent browser Web Push, SMS OTP.
- **Concrete I/O snapshot (ASCII wireframe + sample payload):**

```text
+--------------------------------------------------+
| [Bell (3)]  New notifications      [Mark as read]|
|--------------------------------------------------|
| * Order #ORD-102 moved to SHIPPING     1 min ago |
|   Payload: {"id":"n_1","type":"ORDER_SHIPPED"}   |
+--------------------------------------------------+
```

## 9. Visible test evidence (`C29`)

Instead of reporting *"All 12 tests passed"*, show a table so the developer immediately sees how real the tests are:

| AC-ID | Test scenario | Concrete input | Observed output & real side effects | Layer & realism (declare mocks) | Result |
|---|---|---|---|---|---|
| `RBAC-AC03` | `DENY` beats the wildcard `orders:*` | `user={allow:["orders:*"], deny:["orders:delete"]}` calls `DELETE /api/v1/orders/42` | HTTP `403`, body `{"error":{"code":"AUTH_FORBIDDEN"}}`; record `orders#42` still intact in PG | `integration` — **0 mocks** (real PostgreSQL + Redis) | [x] PASS (42ms) |
| `NFR-AC08` | Block above the 10-per-minute rate limit | Send 11 `POST /reports/sales/runs` requests from `user_1`, 1 request from `user_2` | Requests 1..10: `202`; request 11 (`user_1`): `429 RATE_LIMITED`; `user_2`: `202` | `integration` — real Redis, **Mock:** `GotenbergClient.renderPdf` | [x] PASS (68ms) |
