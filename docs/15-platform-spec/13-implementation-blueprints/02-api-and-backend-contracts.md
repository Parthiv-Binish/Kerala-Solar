# API & Backend Contracts

**Covers:** API-D01–API-D09 · Draft; exact OpenAPI routes require review

## Principles and conventions
All clients use the central FastAPI service. No client connects directly to PostgreSQL, Redis or private object storage. APIs expose business use cases rather than arbitrary table CRUD. Use a versioned prefix such as /api/v1. GET is read-only; mutations use POST/PUT/PATCH according to documented semantics. Posted financial and audit history is never deleted.

## Endpoint families
Authentication/me; employees/groups/permission sets; customers/contacts/sites; enquiries/follow-ups; surveys/appointments/reviews; catalogue/designs/BOM/quotations; projects/milestones/tasks; utility applications/subsidies; suppliers/purchase requests/POs/receipts/inventory; receipts/allocations/bills/payments/expenses/refunds; installation/inspection/commissioning/handover; plants/assets/equipment/warranty; telemetry/devices/alerts/integrations; service cases/work orders/visits; documents/templates/exports; notifications/preferences/delivery; admin/jobs/audit/reference data. Exact route names are approved through OpenAPI review.

## Schemas and errors
Define request and response schemas separately; never expose ORM objects directly. Each property defines type, requiredness, nullability, format, enum, limits, visibility and description. Use ISO 8601 timestamps with offsets at API boundaries and UTC storage. Money uses decimal-safe representation plus currency. Error envelope: stable code, safe message, optional field errors, correlation ID and retryable flag. Categories include validation, unauthenticated, forbidden, not found, conflict/stale version, rate limit, provider unavailable and internal failure. Never return SQL, stack traces or secrets.

## Pagination and filters
Use bounded page or cursor pagination consistently. Allowlist filters and sort fields. Apply organisation and resource scope before pagination and aggregation. Exports use a separate asynchronous flow and repeat the same authorization and masking.

## Authentication and authorization
Specify identity provider, password/OTP/MFA, session lifetime, refresh rotation, logout, revocation, device/session listing and recovery. Web cookie sessions require Secure, HttpOnly, SameSite and CSRF controls as applicable. Mobile credentials use secure platform storage. Every operation declares capability, resource scope, field restrictions and approval authority. Object-level authorization prevents IDOR and cross-customer/site access.

## Idempotency and concurrency
Create, submit, receipt, payment, case, notification and webhook operations use idempotency keys when retries can duplicate effects. Store actor/client scope, request hash and result reference. Reusing a key with a different payload returns conflict. Mutable records use version/ETag; stale writes return conflict and safe refresh guidance.

## Transactions and events
Related writes use database transactions. Write an outbox event in the same transaction. Workers publish events; consumers track event ID and schema version. Use bounded retries and dead-letter review. External calls do not run inside long database transactions. Long-running operations expose job ID/state.

## Files and realtime
Use authorized upload-intent, completion and download-intent operations. Validate file size/type/content, scan where available, store privately and bind metadata to permitted records. Realtime (SSE/WebSocket) is optional; authenticate connections, scope subscriptions and treat events as hints to refetch authoritative data.

## OpenAPI and backend boundaries
Every route has operation ID, auth, capability, schemas, errors, idempotency/concurrency rules and synthetic examples. CI validates schema and breaking changes. Routers handle transport, services enforce use cases, domain modules own rules, repositories persist, adapters integrate providers and workers process asynchronous work.

## Canonical naming decisions\nThe logical API outline and screen examples are illustrative. The reviewed OpenAPI document is normative. Use enquiries (not a parallel leads resource without an approved lead entity), service-cases for after-sales cases, and receipt/receipt-allocation commands for received funds. A generic payment route must not initiate a gateway in the MVP. Each operation has one stable operationId.\n\n## Acceptance
All routes have OpenAPI contracts; every operation has permission tests; mutations have transaction/idempotency policy; stale writes are detected; errors are safe; events are idempotent; files are private; no client accesses the database or queue directly.
