# API Contract Register

**Owner:** A3; reviewers A0, A1, A2, A5, A6, A7, A8  
**Normative source:** reviewed, version-controlled OpenAPI document in the implementation repository.  
**Shared baseline:** [SHARED-API-DATA-CONTRACT](SHARED-API-DATA-CONTRACT.md).  
**Status:** all contracts below remain PROPOSED until reviewed OpenAPI operations, schemas, authorization and tests are merged.

| Contract ID | Domain | Consumer(s) | Version | Status | Owner | Required review / dependency |
|---|---|---|---|---|---|---|
| API-000 | Common API conventions, errors, pagination, correlation, idempotency, concurrency | A1, A2, A5, A6, A7, A8, A9 | v1 proposed | PROPOSED | A3 | A0 + A8; shared contract baseline |
| API-001 | Authentication/session and principal context | A1, A2 | v1 proposed | PROPOSED | A3 | A8 security; employee/customer separation; secure web/mobile storage |
| API-002 | Employee groups/permissions/scopes | A1, A2 | v1 proposed | BLOCKED | A3/A4 | AG-0004; deny-overrides, six scopes, resolver truth table and business approval |
| API-003 | Enquiries/customers/contacts/sites | A1, A2 | v1 proposed | BLOCKED | A3/A4 | AG-0015/0025; verified customer identity and site isolation |
| API-004 | Surveys/design/quotations/projects/milestones | A1, A2 | v1 proposed | PROPOSED | A3/A4 | Accepted exact quotation version; confirmed site; idempotent conversion |
| API-005 | Receipts/allocations | A1, A2 | v1 proposed | PROPOSED | A3/A4 | Authorized verification and posted-receipt semantics; no gateway assumption |
| API-006 | Plants/devices/monitoring | A1, A2, A7 | v1 proposed | PROPOSED | A3/A4/A7 | Canonical plant/device IDs; verified provider capability |
| API-007 | Service cases/work orders | A1, A2 | v1 proposed | PROPOSED | A3/A4 | Assignment, evidence, customer/staff field visibility |
| API-008 | Notifications/preferences/delivery | A1, A2, A5, A6 | v1 proposed | PROPOSED | A3/A6 | Outbox, consent, recipient eligibility and channel-neutral status |
| API-009 | Documents/uploads/downloads/exports | A1, A2 | v1 proposed | PROPOSED | A3/A4 | Private storage; object-level authz; audit and expiring links |
| API-010 | Administration/jobs/audit/reference data | A1 | v1 proposed | PROPOSED | A3/A4 | Privileged access, audit, safe job controls |

## Contract approval rules
- Exact paths/methods are approved in OpenAPI, not inferred from this register or screen examples.
- Each operation specifies authentication, permission, resource scope, field visibility, validation, rate limit, audit, idempotency and error behavior.
- DTOs are explicit; do not expose ORM models or internal BIGINT identifiers.
- Apply authorization before pagination/search/count/aggregate/export and repeat it in file/realtime/background flows.
- Breaking changes require ADR/change record, A0 arbitration, A3/A4/A8 review and affected consumer sign-off.
- Do not claim an API implemented until merged code and contract/integration tests are linked.
