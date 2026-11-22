# 04 — Platform Architecture, Access Control and Data Model

## Recommended stack

| Layer | Choice | Reason |
|---|---|---|
| Web | React + TypeScript | Reuse skills/ecosystem |
| Backend | FastAPI + Pydantic | Typed APIs and async Python |
| Database | PostgreSQL | Relational integrity and JSONB |
| Time-series | PostgreSQL initially; TimescaleDB later | Avoid premature complexity |
| Cache/queue | Redis | Cache, jobs and event fan-out |
| Worker | ARQ initially | Lightweight asyncio worker |
| Mobile | React Native | Reuse React/TypeScript |
| Files | S3-compatible object storage | Keep binaries out of DB |
| Deployment | VPS + Docker Compose initially | Cost-effective |
| CI/CD | GitHub Actions | Automated test/build/deploy |

## Modular monolith

~~~mermaid
flowchart TB
 WEB[React operations web]
 APP[React Native customer / technician]
 API[FastAPI]
 API --> AUTH[Identity and policy]
 API --> CRM[Customers and leads]
 API --> PROJECT[Projects and utility]
 API --> INV[Inventory and procurement]
 API --> CASE[Cases and work orders]
 API --> DEVICE[Devices and telemetry]
 API --> NOTIFY[Notifications]
 API --> DOC[Documents]
 API --> AUDIT[Audit and reporting]
 AUTH --> DB[(PostgreSQL)]
 CRM --> DB
 PROJECT --> DB
 INV --> DB
 CASE --> DB
 DEVICE --> DB
 NOTIFY --> DB
 DOC --> OBJ[(Object storage)]
 API --> REDIS[(Redis)]
 REDIS --> WORKER[ARQ workers]
 WORKER --> EXT[OEM APIs / WhatsApp / email / SMS]
 WEB --> API
 APP --> API
~~~

Keep domain modules separate. Extract services only when independent scaling, ownership or fault isolation justifies the operational cost.

Suggested modules: identity, access_control, customers, leads, surveys, quotes, projects, regulatory, utility_applications, procurement, inventory, installations, devices, telemetry, alerts, cases, work_orders, warranties, amc, payments, documents, notifications, reports and audit.

## Group-based access control

Use **group-based RBAC + scope-aware ABAC**, with relationship checks where useful:
- RBAC: what action?
- Groups: which permission bundles?
- ABAC: under what conditions/scope?
- ReBAC: does an assignment/team relationship exist?

Users can belong to many groups. Effective grants are additive and constrained by scope. Explicit deny takes precedence. Default is deny.

### Example groups

| Group | Typical permissions |
|---|---|
| Owner | All authorised business data/configuration |
| Administrator | User/group management |
| Staff | Broad operational visibility within approved scope |
| Sales | Leads, quotations, follow-ups |
| Designer | Surveys, design and BOM |
| Project Manager | Project milestones and assignments |
| Technician | Assigned work orders, cases and reports |
| Accounts | Invoices and payments |
| Support | Customer cases and communications |
| Inventory | Stock and purchasing |
| Auditor | Read-only selected records |

### Arun example

Arun belongs to Technician and Staff.

Technician grants: case.read scope assigned; case.update scope assigned; work_order.read/update scope assigned.

Staff grants: case.read scope branch (or all only if explicitly approved); project.read scope branch; customer.read scope branch.

Arun sees the union of assigned cases and cases within the approved Staff scope. Staff membership does not grant financial access unless Staff explicitly has those permissions.

### Schema sketch

~~~mermaid
erDiagram
 users ||--o{ user_group_memberships : member
 groups ||--o{ user_group_memberships : includes
 groups ||--o{ group_permission_grants : grants
 permissions ||--o{ group_permission_grants : defines
 users ||--o{ user_permission_denies : denied
 permissions ||--o{ user_permission_denies : restricts
 users ||--o{ audit_logs : acts
 users ||--o{ delegation_grants : delegates
 users { uuid id PK; string email; string status; uuid branch_id }
 groups { uuid id PK; string name }
 permissions { uuid id PK; string resource; string action }
 user_group_memberships { uuid user_id FK; uuid group_id FK; datetime starts_at; datetime expires_at }
 group_permission_grants { uuid group_id FK; uuid permission_id FK; string scope_type; json scope_constraints }
 user_permission_denies { uuid user_id FK; uuid permission_id FK; string scope_type; json scope_constraints }
 audit_logs { uuid id PK; uuid actor_user_id FK; string action; string resource_type; uuid resource_id; datetime created_at }
 delegation_grants { uuid id PK; uuid delegator_id FK; uuid delegate_id FK; datetime starts_at; datetime expires_at }
~~~

Additional tables: branches, teams, team_memberships, group_scope_assignments, temporary_elevation_requests/approvals and access_policy_versions.

Scopes: self, assigned, team, branch, all and relationship.

Assigned-case query:
~~~sql
SELECT c.*
FROM cases c
WHERE c.assigned_user_id = :current_user_id;
~~~

Branch query:
~~~sql
SELECT c.*
FROM cases c
JOIN projects p ON p.id = c.project_id
WHERE p.branch_id = :current_branch_id;
~~~

Apply filters in database before pagination and counts. Never fetch all records and hide them in React.

### Enforcement
1. Authentication validates identity/session.
2. FastAPI dependency loads permission context.
3. Service layer checks action.
4. Repository applies scope filters.
5. Optional PostgreSQL RLS is defence in depth.
6. Redis caches effective permissions briefly with policy version.
7. Membership changes invalidate cache.
8. Sensitive actions create audit events.

Deny precedence: matching explicit deny blocks; otherwise union grants; apply tenant/branch constraints; apply relationship filters; deny by default.

Temporary elevation requires reason, approver, exact permission, expiry and immutable audit. Never grant indefinite elevation by default.

### Tests
Test multi-group users, scope union, deny precedence, expired memberships, delegation expiry, branch boundary, reassignment, cache invalidation, IDOR, attachment access, exports, counts and pagination leakage.

## Core data model

~~~mermaid
erDiagram
 CUSTOMER ||--o{ SITE : owns
 SITE ||--o{ PROJECT : hosts
 CUSTOMER ||--o{ LEAD : creates
 LEAD ||--o| PROJECT : converts
 PROJECT ||--o{ QUOTATION : has
 PROJECT ||--o{ UTILITY_APPLICATION : tracks
 PROJECT ||--o{ INSTALLATION : has
 PROJECT ||--o{ PAYMENT : receives
 PROJECT ||--o{ DOCUMENT : stores
 SITE ||--o{ DEVICE : contains
 DEVICE ||--o{ TELEMETRY_POINT : emits
 DEVICE ||--o{ ALERT : raises
 ALERT ||--o| CASE : creates
 CUSTOMER ||--o{ CASE : requests
 CASE ||--o{ WORK_ORDER : schedules
 DEVICE ||--o{ WARRANTY : covered_by
 CUSTOMER ||--o{ AMC_CONTRACT : subscribes
~~~

Core entities: customers, sites, leads, activities, projects, milestones, survey/design versions, quotations/items, regulatory rule sets, utility applications/events, purchase orders, inventory transactions, installations/checklists, devices, encrypted credential references, telemetry/aggregates, alert rules/events, cases/comments/assignments, SLA policies, work orders/visit reports, warranties/claims, AMC contracts, payments, documents, notification outbox/attempts/templates, groups, memberships, permissions, grants, denies and audit logs.

## API outline

Prefix /api/v1. Use pagination, filters, consistent errors, idempotency keys and request IDs.

| Method | Endpoint | Purpose |
|---|---|---|
| POST | /auth/otp/request | Request OTP |
| POST | /auth/otp/verify | Verify/login |
| POST | /auth/refresh | Rotate refresh token |
| GET/POST | /customers | Customer list/create |
| GET/POST | /leads | Lead list/create |
| POST | /leads/{id}/convert | Convert lead |
| GET/POST | /sites | Site management |
| POST | /sites/{id}/surveys | Create survey |
| GET/POST | /projects | Project management |
| GET/POST | /projects/{id}/quotations | Quote versions |
| POST | /projects/{id}/utility-applications | Utility tracking |
| POST | /utility-applications/{id}/events | Status/evidence event |
| GET/POST | /inventory/items | Inventory |
| POST | /projects/{id}/installations | Installation |
| GET/POST | /devices | Device registry |
| POST | /telemetry/ingest | Authenticated ingestion |
| GET | /sites/{id}/telemetry | Site metrics |
| GET/POST | /alerts | Alert management |
| GET/POST | /cases | Cases |
| POST | /cases/{id}/assign | Assignment |
| POST | /cases/{id}/escalate | Escalation |
| GET/POST | /work-orders | Field work |
| POST | /work-orders/{id}/visit-reports | Technician report |
| GET/POST | /amc-contracts | AMC |
| GET/POST | /payments | Payment ledger |
| GET/POST | /documents | Document metadata/upload intent |
| GET/POST | /groups | Group administration |
| POST | /users/{id}/groups | Membership |
| GET | /me/permissions | Effective permission summary |
| GET | /notifications | Delivery history |
| GET | /audit-logs | Audit search |

Never trust client-supplied user, branch or tenant IDs for access. Validate every object access, sign webhooks, rate-limit OTP and use idempotency for payments/webhooks.

## Redis and workers

Redis: short-lived cache, ARQ queue, rate limiting, WebSocket/SSE fan-out and limited coordination. PostgreSQL remains durable source of truth. Use transactional outbox or durable streams for important events.

| Worker | Strength | Trade-off |
|---|---|---|
| ARQ | Asyncio-native/lightweight | Smaller ecosystem |
| Celery | Mature scheduling/retries | More operational configuration |
| RQ | Simple Redis queue | Less native async |

Start with ARQ; move to Celery only if needed.

## Multi-tenancy and deployment

Include tenant_id in business tables where practical; scope object storage and cache keys by tenant; enforce tenant filtering in policy/repository layer. Do not build full SaaS billing/tenant admin until needed.

Deploy with Docker Compose initially, HTTPS reverse proxy, private DB/Redis network, firewall, SSH keys, secrets management, staging/production separation, GitHub Actions, monitoring, off-site backups and tested rollback. A single VPS is a single point of failure; separate database or second VPS when reliability needs grow.