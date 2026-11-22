# Platform Administration — Identity, Configuration, Integrations & Operations

**Document ID:** UX-ADMIN-001 · **Status:** Proposed

## 1. Purpose and boundary
Restricted administrative workspace for platform operators. Business managers use Staff Portal permissions; platform administrator access is separate, minimal, time-bounded where possible and audited.

## 2. Navigation
Admin Overview, User Accounts, Groups & Permission Sets, Access Overrides, Sessions & MFA, Reference Data, Integrations, Background Jobs, Error Events, Audit Explorer, Backup & Recovery, Feature Flags, System Configuration and Release Health.

## 3. Screens
**A01 Overview:** service health, queue backlog, integration failures, recent privileged actions and backup freshness. No secrets displayed.
**A02 User Accounts:** search, status, identity provider, MFA state, linked employee/customer identities, suspend/reactivate and revoke sessions.
**A03 Access Control:** groups, permissions, scopes, effective access preview, overrides and access review. Changes require reason and approval.
**A04 Sessions:** active sessions, device metadata, revoke action and suspicious login history.
**A05 Reference Data:** approved geography, PIN/post-office, categories and workflow reference records with provenance/version/import run.
**A06 Integrations:** provider, environment, supported capability, connection test, health, credential reference, last success and disable/rotate actions. Secret values never returned to UI.
**A07 Jobs:** queue, job name, schedule, run history, retries, manual replay with idempotency safeguards.
**A08 Errors:** sanitized exception, correlation ID, affected operation, severity, occurrence count and resolution status. No raw secrets or unnecessary personal data.
**A09 Audit Explorer:** actor, action, resource, timestamp, outcome, reason and correlation ID. Append-only and restricted.
**A10 Backup/Recovery:** last backup, retention, encryption, restore-test status, RPO/RTO and incident notes.
**A11 Feature Flags:** target scope, rollout, owner, expiry and rollback.
**A12 Settings:** environment-safe operational settings, version history and approval.

## 4. Privileged access
Require MFA for privileged users, separate daily account from admin account where feasible, short sessions, just-in-time elevation and approval for high-risk changes. Emergency break-glass access records reason and triggers review. No shared admin accounts.

## 5. Reference data governance
Each dataset records source, licence/terms, version, retrieval/import time, checksum, transformation, approver and refresh policy. External PIN lookup must be verified; access-controlled CEPT API is not assumed to be public. Manual address entry remains possible if provider unavailable.

## 6. Integration security
Secrets stored in secret manager, least-privilege scopes, rotation, expiry alerts and redacted diagnostics. Admin UI exposes secret reference/status, never secret plaintext. Disable integration safely without deleting historical provider data.

## 7. Background jobs
Show queued/running/succeeded/failed/retrying/dead-letter, attempt count, schedule, next run and correlation ID. Replay only idempotent jobs or through explicit safe replay workflow.

## 8. Audit and operations
Log authentication, permission changes, exports, sensitive record access, integration configuration, job replay, backup restore and feature flags. Logs have access controls and retention. Backup success is not proof of recoverability; restore drills are required.

## 9. Acceptance tests
- [ ] Admin cannot read secret plaintext.
- [ ] Privileged action requires appropriate capability/MFA.
- [ ] Access change creates audit event.
- [ ] Expired override ceases to grant access.
- [ ] Job replay is idempotent.
- [ ] Audit records cannot be edited through normal admin UI.
- [ ] Backup status includes restore-test evidence.
- [ ] Integration disable does not corrupt business history.
