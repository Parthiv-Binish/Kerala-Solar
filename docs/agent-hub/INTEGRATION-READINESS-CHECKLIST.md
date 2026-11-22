# Integration Readiness Checklist

**Owner:** A0; evidence owners shown per section  
**Status:** NOT READY — baseline checklist, no implementation evidence asserted  
**Rule:** Mark a box only with a linked PR/commit, test result, environment and reviewer.

## Governance and traceability (A0)
- [ ] Sponsor-approved MVP/Phase 2 scope and business decision authority recorded.
- [ ] All agents acknowledge charters, dependencies, branch/worktree and file ownership.
- [ ] Every task has requirement IDs, DOC issue IDs, owner, reviewer, dependencies, acceptance and tests.
- [ ] ADRs approved or explicitly marked proposed; no unresolved breaking contract conflict.
- [ ] Cross-agent handoffs use the mandatory report template.

## API/backend (A3; A0/A8 review)
- [ ] Reviewed OpenAPI is version-controlled and generated from FastAPI.
- [ ] Request/response DTOs, stable error envelope, pagination/filtering and version semantics documented.
- [ ] Authn, session lifecycle, refresh rotation, logout/revocation and browser/mobile storage verified.
- [ ] Every endpoint maps to permission, resource predicate, field restrictions, rate limit and audit.
- [ ] Deny-overrides, six canonical employee scopes, customer/site isolation and fail-closed behavior tested.
- [ ] Idempotency keys, request hash conflict, concurrency/ETag and correlation IDs tested.
- [ ] Transactional outbox and consumer dedupe tested.

## Database/data (A4; A3/A8 review)
- [ ] SQL 0001–0006 execute in order on disposable PostgreSQL with clean install and no seed data.
- [ ] Constraints, FKs, triggers, indexes, transaction rollback and failure-stop behavior tested.
- [ ] One migration authority and checksum/version ledger documented; no duplicate Alembic path.
- [ ] Stage 1–3 dictionary and logical-to-physical mapping reconciled; deferred entities explicitly listed.
- [ ] New domain DDL reviewed by A3 and mapped to API/workflow; retention/provenance defined.
- [ ] Backup and restore tested; production migration plan/rollback reviewed.

## Web and mobile (A1/A2; A3/A8 review)
- [ ] Every screen maps to approved screen spec and OpenAPI operation.
- [ ] Staff, customer and technician identities/contexts remain separate.
- [ ] Backend authorization is enforced for detail/list/search/count/export/files/realtime/background jobs.
- [ ] Loading, empty, validation, forbidden, error and recovery states exist.
- [ ] Web responsive/accessibility tests and mobile device/session/deep-link tests pass.
- [ ] MVP mobile flows are online-first; offline capability is not implied or falsely shown.

## Notifications and WhatsApp (A3/A5/A6; A8 review)
- [ ] Event schema/version, recipient eligibility, consent and preferences approved.
- [ ] Delivery attempts, idempotency, retry/backoff, dead-letter and status mapping tested.
- [ ] WhatsApp provider/account/terms/templates/pricing/webhook signature/session lifecycle verified.
- [ ] Push/email/SMS provider credentials and callbacks verified in approved sandbox.
- [ ] Payloads are minimal and do not disclose sensitive data; opt-out and suppression work.

## Monitoring/IoT (A3/A4/A7; A8 review)
- [ ] Exact make/model/firmware/data owner and authorized API/gateway access documented.
- [ ] Rate limits, data rights, units/timezones/quality/freshness and outage semantics mapped.
- [ ] Stale/missing telemetry is not represented as zero generation.
- [ ] Duplicate/out-of-order readings and alert debounce/dedupe/recovery tested.
- [ ] No remote control capability enabled in initial release.

## Security, privacy and QA (A8)
- [ ] Threat model covers auth, customer portal, files, finance, integrations, webhooks and admin.
- [ ] Cross-customer/site/group negative tests and privilege escalation tests pass.
- [ ] Dependency/container/secret scans and security headers/CSRF/CORS/rate-limit tests pass.
- [ ] Data classification, purpose, consent, retention, data-subject workflow and legal applicability reviewed by qualified owner.
- [ ] File upload/download, exports, audit, logs and push/SMS minimization tested.
- [ ] Independent penetration test findings triaged before public launch.

## Infrastructure/reliability (A9; A8 review)
- [ ] Reproducible Docker dev/staging; secrets outside Git; non-root/minimal containers.
- [ ] PostgreSQL and Redis private; HTTPS ingress only; network/SSH/admin controls reviewed.
- [ ] CI checks, protected branches, migration checks and deployment approvals work.
- [ ] Structured logs, metrics, health/readiness, queue depth, DB, storage and certificate monitoring work.
- [ ] Encrypted offsite backups and restore drill pass; RPO/RTO approved and measured.
- [ ] Rollback, incident response, access review and on-call ownership documented.

## Business/pilot acceptance (A0 + sponsor)
- [ ] End-to-end enquiry → accepted quotation → customer/site/project → delivery → handover → service scenario accepted.
- [ ] Utility/government data is represented as sourced observations, not fabricated integrations.
- [ ] Finance receipt verification and allocation controls accepted; no assumed gateway settlement.
- [ ] Real operating staff, customer communication and support ownership trained.
- [ ] Pilot scope, known limitations, support window, rollback and success metrics signed off.
