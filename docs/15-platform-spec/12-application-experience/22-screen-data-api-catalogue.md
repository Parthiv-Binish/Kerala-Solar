# Screen-to-Data & API Catalogue — Contract and Traceability Standard

**Document ID:** API-CAT-001 · **Status:** Proposed; endpoint catalogue to be expanded with implementation

## 1. Purpose
Provide traceability from every screen action to an API operation, data entity, permission, event and test. This document defines the contract standard; concrete route names and schemas are assigned during API design and must not be guessed from UI labels.

## 2. API conventions
- Base path versioned, e.g. /api/v1.
- JSON request/response; consistent error envelope and correlation ID.
- Authentication via approved session/token design.
- Server-side authorization and resource scoping on every request.
- Pagination, filtering and sorting use allowlisted fields.
- Mutations accept idempotency keys where retries can duplicate effects.
- Updates use entity version/ETag to detect stale writes.
- Timestamps use ISO 8601 with timezone; storage convention is UTC.
- Money uses decimal-safe representation and explicit currency.
- Files use authorized upload/download flow; no public object keys.
- API schema published as OpenAPI and versioned.

## 3. Standard action mapping
| Screen action | Command class | Data effects | Required controls |
|---|---|---|---|
| List records | Query | Read scoped records | permission, scope, pagination |
| Open detail | Query | Read record and permitted relations | object-level authorization |
| Create | Command | Insert record and audit | validation, duplicate/idempotency |
| Edit draft | Command | Update mutable draft | version check, field authorization |
| Submit | Command | State transition and snapshot | transition rules, completeness |
| Approve | Command | Approval event/frozen version | approver authority, separation |
| Issue/send | Command + outbox | Immutable output and delivery event | approved state, recipient/consent |
| Upload evidence | Upload protocol | File metadata and object | scan, type/size, access |
| Export | Async command | Export job/file | row scope, masking, audit |
| Retry background work | Admin command | Job attempt | idempotency, elevated permission |

## 4. Error envelope
Standard errors should include stable code, safe user message, optional field errors, correlation ID and retryability. Categories: validation, unauthenticated, forbidden, not found, conflict/stale version, rate limited, provider unavailable, internal error. Never return stack traces, SQL, tokens or private provider payloads.

## 5. Domain route families
Proposed families: /auth, /me, /employees, /groups, /customers, /sites, /enquiries, /surveys, /designs, /catalogue, /quotations, /projects, /milestones, /tasks, /utility-applications, /suppliers, /purchase-requests, /purchase-orders, /inventory, /receipts, /expenses, /plants, /assets, /telemetry, /alerts, /service-cases, /work-orders, /documents, /notifications, /integrations and /admin. Exact routes require OpenAPI review.

## 6. Traceability matrix template
For each screen action capture:
| Attribute | Required value |
|---|---|
| Screen/action ID | Stable identifier |
| Actor/capability/scope | Exact authorization |
| HTTP method/route | Approved API contract |
| Request schema | Fields, types, requiredness |
| Response schema | Fields and visibility |
| Source entities | Read model and joins |
| Write entities | Insert/update/event |
| Validation | Rules and error codes |
| Transaction/idempotency | Boundary and retry behaviour |
| Side effects | Outbox/events/files |
| Audit | Actor/action/resource/reason |
| Tests | Unit/integration/e2e test IDs |

## 7. Data consistency
Use database transactions for related writes. Publish events through transactional outbox. Consumers track event ID and schema version. Long-running operations use explicit job state and correlation ID. Never use a frontend optimistic update as proof of server commit.

## 8. Security
Validate input on server; parameterize SQL; prevent mass assignment; rate-limit sensitive endpoints; enforce CSRF where applicable; validate file content; prevent IDOR; restrict exports; redact logs; rotate secrets. Authorization tests must include cross-customer and cross-site attempts.

## 9. Completion criteria
Every implemented screen action must have a route, schema, permission, entity mapping, audit rule, error catalogue and automated test. OpenAPI generation and contract tests must match deployed API.
