# Shared API and Data Contract Baseline

**Owner:** A3 (API implementation) + A4 (physical data); A0 arbitrates; A8 validates  
**Status:** PROPOSED — exact schemas become normative only after reviewed OpenAPI/DDL PRs  
**Date:** 2026-11-22

## API conventions

- One FastAPI modular monolith is the business API. Clients never access PostgreSQL, Redis or private object storage directly.
- Proposed base prefix: `/api/v1`. Exact route paths and methods require reviewed OpenAPI; design examples are not implementation promises.
- Request and response DTOs are explicit and separate from ORM/database objects. Do not leak internal BIGINT keys.
- Public resource identifiers use UUIDs. Internal relational primary keys may use BIGINT identity.
- Timestamp input/output uses ISO 8601 with timezone offsets; persist normalized UTC.
- Monetary values use decimal-safe values and explicit ISO currency code; never binary floating-point as the authoritative amount.
- Pagination is bounded; filter and sort keys are allowlisted. Apply authorization predicates before pagination, search, counts, aggregates and exports.
- Mutations that can be retried or create side effects accept an idempotency key. Persist actor/client scope, request hash and result reference. Same key/different payload returns conflict.
- Mutable resources use version/ETag or equivalent optimistic concurrency; stale update returns a stable conflict response.
- Every request has a correlation ID propagated to logs, events and jobs.

## Error envelope (proposed)

```json
{
  "error": {
    "code": "stable_machine_code",
    "message": "Safe user-facing message",
    "field_errors": [],
    "correlation_id": "uuid",
    "retryable": false
  }
}
```

HTTP status semantics are defined in reviewed OpenAPI. Error codes must distinguish validation, unauthenticated, forbidden, not found, conflict/stale version, rate limit, provider unavailable and internal failure. Never return SQL, stack traces, secrets or sensitive policy internals.

## Authentication and authorization context

- Employee and customer account populations remain separate in the initial model; no shared employee/customer identity is implied.
- Server derives principal/context from validated session/token. Do not trust client-supplied employee, group, customer, contact, site or project ownership claims.
- Employee authorization uses group membership → permission-set rules → scope predicates, with explicit deny-overrides. Canonical employee scopes: `own`, `assigned`, `team`, `related`, `location`, `company`.
- Customer authorization uses active, verified customer-account/contact links and customer/site policy. Phone/email matching alone is not authorization.
- Unknown permission, unresolvable scope or missing policy mapping fails closed.
- File download, export, search, count, realtime subscription and background jobs re-check the same authorization policy.
- Browser cookie sessions require Secure, HttpOnly, SameSite and applicable CSRF protections. Mobile tokens/refresh material use platform secure storage.

## Canonical event envelope (proposed)

```json
{
  "event_id": "uuid",
  "event_type": "domain.resource.action",
  "schema_version": 1,
  "occurred_at": "2026-11-22T12:00:00Z",
  "actor": {"type": "employee", "public_id": "uuid"},
  "tenant_context": {"company_public_id": "uuid"},
  "aggregate": {"type": "resource", "public_id": "uuid", "version": 1},
  "correlation_id": "uuid",
  "idempotency_key": "stable-key",
  "privacy_classification": "internal",
  "payload": {}
}
```

The example is a shape, not an approved final schema. A3 owns business event/outbox semantics; A6 owns notification delivery envelope mapping; A0 approves cross-domain compatibility. Avoid personal data and secrets in event payloads. Persist outbox record in the same transaction as business state. Consumers deduplicate by event ID and handle schema version explicitly.

## Domain/data ownership

| Domain | Canonical owner | Key integration boundary |
|---|---|---|
| Identity, employee, groups, permissions | A3 behavior; A4 DDL | Employee identity links and authorization resolver |
| Customer, contacts, sites, enquiries | A3 behavior; A4 DDL | Verified customer account/contact link; no implicit cross-customer access |
| Survey, design, quotation, project | A3 behavior; A4 DDL | Exact accepted quotation version and confirmed site required for conversion |
| Finance/receipts | A3 behavior; A4 DDL | Posted receipt and authorized verification; no assumed gateway |
| Files/documents | A3 access policy; A4 metadata schema; A9 storage | Private object storage; backend mediated |
| Notification/delivery | A6 orchestration; A3 outbox; A4 DDL | Consent, preferences, recipient eligibility, attempts and status |
| Plant/device/telemetry | A7 adapter/normalization; A3 APIs; A4 DDL | Canonical plant/device IDs, units, quality, freshness and provenance |

## Migration/data contract

- One PostgreSQL database. SQL 0001–0006 are current canonical bootstrap scripts, in order, until a separately approved migration-runner transition.
- A4 owns schema/migration files and dictionary; A3 reviews application/transaction impact; A8 validates clean install/upgrade and security implications.
- Do not create duplicate logical/physical tables; use the logical-to-physical mapping register.
- No fake customer, employee, project, payment, device or telemetry seed records in production.
- Imported reference data must record source, import run, source record key and retrieval/verification timestamps.
- Schema change is not accepted until DDL, dictionary, mapping, API DTO and tests are aligned.

## Compatibility policy

Breaking changes require an ADR/change record, A0 approval, A3/A4 review, A8 test impact review and sign-off from affected A1/A2/A5/A6/A7 consumers. Prefer additive optional fields and versioned event schemas. Document deprecation and migration window. No consumer may infer undocumented defaults.
