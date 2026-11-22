# GreenGrid Solar — Multi-Agent Development Work Plan

**Document ID:** DEV-AGENT-PLAN-001  
**Status:** Proposed execution plan — requires project-owner approval  
**Repository:** `Parthiv-Binish/Kerala-Solar`  
**Purpose:** Divide the complete GreenGrid Solar platform into independently deliverable workstreams for specialist AI/software agents, with explicit ownership, dependencies, contracts and integration gates.

[← Project Book](../../../INDEX.md) · [← Platform specification](../README.md) · [← Application suite](../12-application-experience/00-application-suite-and-screen-inventory.md) · [← UI/UX system](../12-application-experience/24-ui-ux-design-system-and-interaction-standards.md)

---

## 1. Operating model

GreenGrid Solar is one connected product suite, not a collection of unrelated apps. Agents may work in parallel only where their interfaces and ownership boundaries are agreed.

**Shared technical baseline**
- Web: React + TypeScript.
- Android: React Native + Expo + TypeScript.
- Backend: FastAPI modular monolith, with separately deployable workers where justified.
- Database: one authoritative PostgreSQL database.
- Background processing: Redis + ARQ (or another explicitly approved queue implementation).
- Files: private object storage; file metadata and access policy managed by the backend.
- Realtime: authenticated WebSocket/API event delivery where required.
- Deployment: Docker Compose, Nginx, VPS, GitHub Actions.
- API contract: reviewed, version-controlled OpenAPI specification.
- UI: the common GreenGrid UI/UX design system.

Technology choices above are the working baseline from the platform study. Any change requires an Architecture Decision Record (ADR), impact analysis and coordinator approval.

### Non-negotiable system rules

1. Web and mobile clients communicate only with the backend API. They never connect directly to PostgreSQL, Redis or private object storage.
2. Backend authorization is authoritative. Hiding a button in a client is not access control.
3. The company has one authoritative customer/site/project/plant identity across all channels.
4. No agent creates a parallel business rule, duplicate entity, competing API route or independent source of truth.
5. Database schema changes require a reviewed migration and a data dictionary update.
6. All external providers are adapters behind internal interfaces; credentials stay server-side.
7. WhatsApp, email, SMS and push delivery must be queued, idempotent, observable and retry-safe.
8. Missing or stale telemetry is never silently represented as zero generation.
9. Government portal status is recorded as an observation unless an authorised integration is verified; the external portal remains authoritative.
10. Do not seed fake customers, employees, projects, payments, devices or telemetry into production.
11. Proposed rules and unresolved assumptions remain marked **PROPOSED** or **VERIFY** until approved.
12. Each feature must include loading, empty, validation, permission-denied, failure and recovery states.

---

## 2. Agent organisation

| Agent | Name | Primary ownership | Main output |
|---|---|---|---|
| A0 | Project Architect & Integration Lead | Architecture, planning, shared contracts, integration and release coordination | ADRs, sprint plan, integration builds, release gates |
| A1 | Public Website & Web Frontend | Public website, landing pages, staff portal and platform administration UI | React web applications |
| A2 | Android Applications Frontend | Technician Android app and customer Android app | Expo/React Native applications |
| A3 | Backend & Business Logic | FastAPI modules, API, workflows, authorization and events | Backend services and OpenAPI |
| A4 | Database & Data Engineering | PostgreSQL schemas, constraints, indexes, migrations and data governance | Reviewed database migrations and data dictionary |
| A5 | WhatsApp Business Integration | WhatsApp provider, templates, inbound/outbound messaging and webhooks | WhatsApp adapter and operational message flows |
| A6 | Notifications & Communications | In-app, push, email, SMS, notification preferences and delivery orchestration | Unified communication service |
| A7 | Solar Monitoring & IoT | Manufacturer/gateway adapters, telemetry, plant health and alerts | Monitoring ingestion and alert engine |
| A8 | QA, Security & Compliance | Test strategy, automation, security validation, privacy and acceptance | Test suites, security findings and release evidence |
| A9 | DevOps, Infrastructure & Reliability | Environments, CI/CD, VPS, containers, backups and observability | Reproducible deployments and operations runbooks |

The agents are logical responsibilities. One person or model may temporarily cover multiple agents, but ownership and review boundaries remain explicit.

---

## 3. Detailed agent charters

### A0 — Project Architect & Integration Lead

**Owns**
- Master implementation backlog, dependencies, milestones and agent assignments.
- Architecture decisions and shared engineering standards.
- API/event contract review and compatibility.
- Cross-agent integration, pull-request coordination and release readiness.
- Scope control and conflict resolution.

**Must deliver**
- Approved repository structure and branching/PR rules.
- Architecture Decision Records (ADRs).
- Shared API, event and error conventions.
- Feature dependency graph and sprint plan.
- Integration checklist and release sign-off record.
- A traceability map from requirement → screen → API → data → test.

**Must not**
- Silently change another agent's owned implementation.
- approve unreviewed schema/API breaking changes.
- Mark proposed business policy as approved.

**Acceptance**
- Every feature has an owner, acceptance criteria, dependency list and integration contract.
- No unresolved blocking contract conflict remains at a release gate.

### A1 — Public Website & Web Frontend

**Owns**
1. Public marketing website and landing page.
2. Services, process, project showcase, FAQs and enquiry/contact journey.
3. Staff Portal shell, navigation, dashboards and operational modules.
4. Platform Administration screens inside the protected staff web experience.
5. Responsive behaviour for desktop, tablet and mobile browsers.
6. Web-side design system implementation and reusable components.

**Feature areas**
- Public pages: home, about, services, solar solutions, how it works, projects/case studies, FAQs, contact/enquiry, privacy and legal pages.
- Staff: dashboard, enquiries, customers, surveys, design/quotations, projects, utility/subsidy tracking, procurement, inventory, finance, installation, assets/warranty, monitoring, service desk, documents/reports, people/access/settings.
- Admin: integrations, reference data, background jobs, audit search, feature settings and operational status.

**Must deliver**
- Route map and page-level access map.
- Shared component library aligned with the UI/UX design system.
- Screen implementations connected to approved API clients.
- Form validation, accessible interactions and responsive states.
- Component and page tests.

**Must not**
- Implement business rules as client-only logic.
- access database or provider secrets directly.
- invent testimonials, customer counts, savings, certifications or live monitoring claims.
- create a second staff/customer identity store.

**Acceptance**
- Every screen maps to its screen specification and API contract.
- Every protected route handles loading, unauthenticated, forbidden and error states.
- Public enquiry submission works through the backend and displays a clear reference/confirmation only after successful server response.

### A2 — Android Applications Frontend

**Owns**
- Technician Android app.
- Customer Android app.
- Shared mobile UI primitives only where they genuinely serve both apps.
- App navigation, local presentation state, device permissions and API integration.

**Technician app feature areas**
- Sign-in, device/session handling and assigned work.
- Today view, job list, filters, job details and status transitions.
- Site contact/address/access instructions.
- Survey checklists, measurements and evidence capture.
- Installation tasks, serial scanning/manual fallback and commissioning.
- Service visits, diagnosis, work performed, parts used and outcomes.
- Customer acknowledgement and required evidence.
- Notifications and profile/settings.
- Connectivity indicators and unsent-input preservation.

**Customer app feature areas**
- Invitation/onboarding, sign-in and account recovery.
- Home dashboard, profile, household contacts and multiple sites.
- Enquiries, appointments and project timeline.
- Quotation/design review and acceptance where approved.
- Documents, payment instructions, receipt history.
- Plant list, monitoring charts, data freshness and alerts.
- Service requests, case tracking, notifications and support.
- Privacy, consent and account requests.

**Must deliver**
- Independent navigation and information architecture for each audience.
- API client generated from or validated against OpenAPI.
- Secure token/session handling using platform-appropriate secure storage.
- Camera, file and notification permission flows.
- Device-level tests and supported Android version matrix.
- Accessible touch targets and small-screen layouts.

**Offline boundary**
- MVP is online-first. Show connectivity and sync state and preserve current unsent input where practical.
- Full encrypted offline job packs, durable offline drafts, media queue, conflict resolution and background sync are Phase 2 unless explicitly approved earlier.
- Never claim a write was saved remotely until the server confirms it.

**Must not**
- connect directly to the database.
- duplicate backend business rules.
- assume technician and customer apps share the same navigation or permissions.
- store long-lived secrets in app source or ordinary local storage.

### A3 — Backend & Business Logic

**Owns**
- FastAPI application and modular business services.
- Authentication/session integration and server-side authorization.
- REST API, validation, business transactions and domain events.
- Background job interfaces and internal service contracts.
- OpenAPI generation and API version compatibility.

**Business modules**
- Identity, employee groups, membership, permissions, scopes and audited overrides.
- Enquiries, follow-ups, customer/contact/site management and conversion.
- Surveys, design versions, BOM and quotation approval/acceptance.
- Projects, tasks, milestones, scheduling and dependencies.
- Government application and subsidy tracking.
- Suppliers, purchase orders, stock, serial allocation and inventory movements.
- Finance: instructions/due amounts, receipts, verification, allocations, reversals/refunds and project summaries.
- Installation, commissioning, quality and handover.
- Plants, assets, devices, warranties and maintenance plans.
- Service cases, duplicate prevention, work orders and field visits.
- Documents and signed/approved file access.
- Notification event production, integration interfaces and audit events.

**Must deliver**
- Modular backend package structure and dependency rules.
- Reviewed API routes, request/response schemas and error catalogue.
- Transaction-safe workflows and idempotency for retried commands.
- Server-side authorization and resource-scope checks.
- Domain events/outbox contracts for asynchronous work.
- Unit and integration tests, API documentation and operational health endpoints.

**Must not**
- put WhatsApp provider-specific code in core business modules.
- place manufacturer-specific logic in generic project/service modules.
- accept client-provided permission or scope as authoritative.
- use a generic payment endpoint that accidentally initiates a payment gateway.
- create projects from a survey alone: conversion requires the approved quotation and commercial/site preconditions in the canonical workflow.

### A4 — Database & Data Engineering

**Owns**
- PostgreSQL physical model and schema lifecycle.
- Canonical names, foreign keys, constraints, indexes and data types.
- Migration design, ordering, rollback/forward-fix guidance and integrity checks.
- Data dictionary and schema-to-API mapping.
- Data retention implementation only after policy approval.

**Working schema domains**
`ref`, `org`, `iam`, `crm`, `catalog`, `sales`, `project`, `gov`, `supply`, `finance`, `install`, `asset`, `monitor`, `service`, `comms`, `files`, `platform`, `audit`.

**Must deliver**
- Approved ERDs and canonical data dictionary.
- Migration files compatible with the selected migration runner.
- Constraints, indexes and referential-integrity tests.
- Data classification and retention mapping.
- Migration test evidence on a clean database and an upgrade database.
- Seed policy limited to safe reference data; no fabricated business records.

**Must not**
- independently redefine domain semantics owned by business requirements.
- add columns/tables without documenting their purpose and consumers.
- store provider credentials as plaintext.
- expose database ports to web/mobile clients or the public internet.
- execute migrations against production without an approved deployment procedure.

**Coordination rule**
A4 proposes schema changes; A3 confirms transaction/API usage; affected agents review field semantics; A0 approves cross-domain changes. A4 owns the migration file and final schema definition.

### A5 — WhatsApp Business Integration

**Owns**
- WhatsApp Business Platform/provider research and verified provider adapter.
- Template catalogue, approval status, language variants and parameter validation.
- Outbound message submission and inbound webhook processing.
- Delivery/status callbacks and message correlation.
- Provider rate limits, retries, deduplication and failure handling.

**Use cases**
- Enquiry acknowledgement and reference number.
- Appointment/visit confirmation and changes.
- Quotation available and customer action request.
- Project milestone/status updates.
- Payment instructions and verified receipt confirmation.
- Installation/commissioning/handover updates.
- Monitoring/service case acknowledgement and updates.
- Technician assignment or schedule change where appropriate.
- Human hand-off and inbound customer replies.

**Must deliver**
- Provider comparison and account/access prerequisites.
- Provider-neutral internal interface and provider-specific adapter.
- Template register: purpose, language, variables, approval status and owner.
- Secure webhook verification, replay protection and idempotent event handling.
- Delivery state mapping and operational dashboard/API.
- Sandbox-to-production test evidence and opt-out handling.

**Must not**
- assume a WhatsApp account/API is already approved or operational.
- send arbitrary promotional messages without consent and applicable policy review.
- expose provider tokens to frontend clients.
- treat an API submission as proof of delivery or read.
- send sensitive personal, financial or security details unnecessarily.

**Dependency**
A6 owns the common notification event/queue model. A5 owns the WhatsApp channel adapter and provider lifecycle. A3 owns business-event generation and recipient eligibility.

### A6 — Notifications & Communications

**Owns**
- Unified notification orchestration across in-app, push, email, SMS and WhatsApp channel interfaces.
- Notification preferences, recipient resolution, template-variable contracts and delivery lifecycle.
- Queue processing, retry/backoff, idempotency, dead-letter handling and observability.
- In-app notification centre and unread/read state APIs.

**Must deliver**
- Event-to-recipient/channel matrix.
- Notification preference and consent contract.
- Common message envelope and channel adapter interface.
- Queue/outbox and retry policy.
- Delivery-state vocabulary and provider callback correlation.
- Push token registration/revocation and email/SMS adapter contracts.
- Tests for duplicate events, provider outage, retry exhaustion and user opt-out.

**Must not**
- implement WhatsApp provider-specific API logic (A5 owns it).
- invent business events or decide business eligibility without A3.
- equate queued, accepted, delivered and read states.
- leak confidential message content into logs.

### A7 — Solar Monitoring & IoT

**Owns**
- Inverter, meter, gateway and manufacturer integration adapters.
- Telemetry ingestion, normalization, validation and aggregation.
- Plant/device health, freshness evaluation and alert lifecycle.
- Monitoring service APIs and data contracts with A3.

**Must deliver**
- Manufacturer capability and access verification register.
- Provider adapter interface and device identity mapping.
- Raw/normalized telemetry contract with units, timezone, source and quality.
- Ingestion schedules/webhooks, retry, rate-limit and backfill strategy.
- Duplicate/late/out-of-order handling.
- Freshness and missing-data policy.
- Alert rules, severity, deduplication, suppression, acknowledgement and recovery.
- Monitoring integration tests using clearly labelled synthetic test fixtures only in test environments.

**Must not**
- assume every inverter brand/model has a usable API.
- treat missing telemetry as zero production.
- create a service case for every repeated poll failure without deduplication/policy.
- mark a service case resolved merely because an alert recovered.
- remotely control an inverter or update firmware in this scope.

**Dependency**
A4 owns telemetry storage schema; A3 owns plant/device business identity and service-case workflow; A6 handles notification delivery.

### A8 — QA, Security & Compliance

**Owns**
- Test strategy and requirement traceability.
- Automated unit, integration, API, UI, mobile and end-to-end testing.
- Authorization matrix and negative access tests.
- Security review, privacy controls, dependency scanning and release acceptance.
- Regression suite and defect severity policy.

**Must deliver**
- Test plan mapped to SRS and screen/API catalogue.
- Role/group/scope test matrix, including deny precedence and cross-customer isolation.
- API contract tests and migration integrity tests.
- Browser/device coverage matrix.
- WhatsApp webhook and delivery simulation tests.
- Monitoring data-quality and alert lifecycle tests.
- Backup/restore verification tests.
- Privacy/data minimisation and retention review.
- Release evidence, defect register and go/no-go recommendation.

**Must not**
- approve a feature solely because the happy path works.
- use production customer data in test fixtures without approved safeguards.
- waive a critical security or data-isolation failure without documented owner approval.

### A9 — DevOps, Infrastructure & Reliability

**Owns**
- Development, staging and production environment design.
- VPS hardening, Docker, Nginx, TLS, DNS and network boundaries.
- GitHub Actions CI/CD, artifact handling and release promotion.
- Secrets/configuration management, backups, restore and disaster recovery.
- Central logs, metrics, health checks, uptime and resource monitoring.

**Must deliver**
- Environment inventory and deployment architecture.
- Dockerfiles and Compose definitions with health checks.
- CI workflows for lint, typecheck, tests, build and migration validation.
- Safe deployment/rollback procedure.
- TLS, firewall, private database/Redis/object storage networking.
- Encrypted backups and restore drill evidence.
- Secret rotation and environment variable register.
- Monitoring, alerting, log retention and incident runbooks.

**Must not**
- commit secrets, private keys, tokens or customer data.
- expose PostgreSQL, Redis or private storage publicly.
- run schema migrations automatically without release ordering and backup safeguards.
- claim production deployment or restore success without execution evidence.

---

## 4. Ownership boundaries and hand-offs

| Capability | Primary owner | Required collaborators |
|---|---|---|
| Landing page and public enquiry UI | A1 | A3, A6, A8 |
| Staff Portal UI | A1 | A3, A4, A8 |
| Technician app UI | A2 | A3, A4, A8 |
| Customer app UI | A2 | A3, A4, A6, A8 |
| Authentication and permissions | A3 | A4, A1, A2, A8 |
| PostgreSQL schema and migrations | A4 | A3, A7, A5, A6 |
| Business workflows and APIs | A3 | A1, A2, A4, A8 |
| WhatsApp provider adapter | A5 | A3, A6, A8, A9 |
| Notification orchestration | A6 | A3, A5, A1, A2 |
| Inverter integrations and telemetry | A7 | A3, A4, A6, A8 |
| Test automation and security verification | A8 | All agents |
| Infrastructure and release | A9 | A0, A3, A4, A5, A6, A7 |
| Architecture and integration approval | A0 | All agents |

A primary owner is accountable for the deliverable. Collaborators review the contract and affected behaviour; they do not take over ownership by editing the same files.

---

## 5. Shared contracts every agent must follow

### 5.1 API contract
- OpenAPI is the normative API contract after review.
- Every operation defines authentication, capability, scope, request, response, validation, errors and idempotency requirements.
- Use consistent resource vocabulary: `enquiries`, `service-cases`, `receipts`, `receipt-allocations`.
- API examples in older planning documents are illustrative until promoted into reviewed OpenAPI.
- Breaking changes require version/compatibility planning and consumer sign-off.

### 5.2 Authorization contract
- Groups are grant sources; groups are not permissions or data scopes.
- An employee can belong to multiple groups.
- Canonical employee scopes: `own`, `assigned`, `team`, `related`, `location`, `company`.
- Valid allows combine; any matching deny blocks; individual allow does not override a matching deny; fail closed.
- Enforce authorization before list pagination, counts, search, export, file access, realtime delivery and background processing.
- Customer access uses customer/site relationships, not employee scopes.

### 5.3 Data contract
- PostgreSQL is the authoritative business store.
- Use snake_case identifiers.
- Preserve explicit relationships between customer, site, project, plant, device, telemetry, alert and service case.
- Store timestamps consistently and define timezone interpretation.
- Record source/provenance for imported reference data and external observations.
- No destructive overwrite of manually entered address or verified business data by an external lookup.

### 5.4 Event contract
Every event includes:
- Stable event name and schema version.
- Unique event ID and occurrence timestamp.
- Actor/source and correlation ID.
- Relevant entity IDs (not unnecessary personal data).
- Idempotency/deduplication key where needed.
- Versioned payload and retry-safe consumer behaviour.

Events are facts that something happened; consumers must not infer an unapproved business transition.

### 5.5 Error and status contract
- Use stable machine-readable error codes and safe user-facing messages.
- Distinguish validation, authentication, authorization, conflict, unavailable provider, timeout, rate limit and internal failure.
- Distinguish queued, submitted, accepted, delivered, read and failed communication states where the channel supports them.
- Distinguish monitoring stale/no data from measured zero.
- Never show success before server confirmation.

---

## 6. Repository and code ownership proposal

Suggested implementation layout (to be approved by A0 before code scaffolding):

```text
/
├── apps/
│   ├── public-web/             # A1
│   ├── staff-portal/            # A1
│   ├── technician-mobile/       # A2
│   └── customer-mobile/         # A2
├── services/
│   ├── api/                     # A3
│   ├── worker/                  # A3/A6 orchestration
│   ├── whatsapp-adapter/        # A5 (may be a backend module initially)
│   └── monitoring-worker/       # A7
├── packages/
│   ├── web-ui/                  # A1
│   ├── mobile-ui/               # A2
│   ├── api-client/              # generated/shared, A0+A3
│   └── contracts/               # A0+A3, reviewed by consumers
├── database/
│   ├── migrations/              # A4
│   └── seeds/                   # A4, reference data only
├── infra/                       # A9
├── tests/                       # A8 with agent-owned local tests
└── docs/                         # A0 maintains index; agents maintain owned technical docs
```

This is a proposed layout, not a claim that these code directories already exist. Avoid splitting the backend into microservices merely to match the agent chart; begin with a modular monolith and extract a separately deployable worker/adapter only when there is a clear operational reason.

### Git and pull-request rules
1. Each agent works on a feature branch named `agent/<agent-id>/<short-feature>`.
2. Each PR has one accountable owner and a small, reviewable scope.
3. No direct commits to `main` for implementation work.
4. A PR includes purpose, changed areas, requirements/screens covered, API/schema/event impact, tests, screenshots where relevant, migration notes and rollback considerations.
5. Schema changes require A4 review; API changes require A3 review; cross-system changes require A0 review.
6. A8 reviews tests/security for release-critical paths.
7. A9 owns production deployment workflow; only approved releases are deployed.
8. Never place credentials, tokens, private customer files or production dumps in Git.

---

## 7. Dependency and delivery sequence

Agents can work in parallel on discovery, contracts, prototypes and isolated components. Integration follows the gates below.

| Phase | Work | Primary agents | Exit condition |
|---|---|---|---|
| 0 — Alignment | Confirm scope, repo structure, environments, ADRs and interface rules | A0, all | Owners and contracts agreed |
| 1 — Foundation | CI, app shells, database baseline, API skeleton, auth/access design | A0, A1, A2, A3, A4, A8, A9 | Clean build, migration test, login/access contract |
| 2 — Core CRM | Enquiries, contacts, customers, sites, assignment and follow-up | A1, A2, A3, A4, A6 | Enquiry can be captured, assigned and tracked |
| 3 — Pre-sales | Survey, design, BOM, quotation and customer response | A1, A2, A3, A4, A6 | Approved quotation acceptance workflow |
| 4 — Project delivery | Project, tasks, government tracking, procurement, finance, installation and handover | A1, A2, A3, A4, A6 | End-to-end project lifecycle validated |
| 5 — Communication | WhatsApp, push, email/SMS and in-app notifications | A3, A5, A6, A8, A9 | Verified sandbox delivery, webhook and retry tests |
| 6 — Plant & monitoring | Plant/device registry, provider adapters, telemetry, alerts and customer views | A1, A2, A3, A4, A6, A7 | Verified adapter and data-quality/alert tests |
| 7 — Service lifecycle | Service request, duplicate prevention, work order, visit and resolution | A1, A2, A3, A4, A5, A6, A7 | Customer-to-technician service journey passes |
| 8 — Hardening | Performance, security, privacy, accessibility, backup/restore, UAT | A0, A8, A9, all | No unresolved release-blocking defects |
| 9 — Release | Staging sign-off, production deployment, smoke tests and handover | A0, A8, A9 | Approved production release and runbooks |

**Parallel work examples**
- A1 can build public website and static staff/mobile screen shells while A3/A4 define API and schema contracts.
- A2 can build navigation and local UI against typed mock fixtures while waiting for API endpoints; fixtures must be clearly test-only and never presented as production data.
- A5 can verify provider prerequisites and design the adapter contract before credentials are available.
- A7 can build a provider-neutral ingestion framework and synthetic test harness while manufacturer API access is being verified.
- A8 can prepare authorization, workflow and data-integrity tests from the requirements before the feature implementation is complete.
- A9 can prepare CI and non-production infrastructure before application code is ready.

---

## 8. Definition of Ready and Definition of Done

### Definition of Ready
A task may be assigned when it has:
- Unique task ID and named agent owner.
- User/business outcome and source requirement.
- Screen/workflow references.
- Acceptance criteria and edge cases.
- Dependencies and external approvals identified.
- API, event and schema contracts identified or explicitly marked as pending.
- UX reference and states where user-facing.
- Security/privacy classification where relevant.

### Definition of Done
A task is complete only when:
- Implementation matches the approved requirement and design system.
- API, database and event contracts are followed.
- Authorization and resource scope are enforced server-side.
- Validation, loading, empty, error, offline/unavailable and recovery states are covered.
- Automated tests pass and relevant manual evidence is attached.
- Accessibility and responsive/device behaviour are checked where relevant.
- Logs contain useful correlation IDs without secrets or unnecessary personal data.
- Documentation and traceability links are updated.
- Code is reviewed and merged through the approved PR process.
- Integration and staging checks pass where the task crosses system boundaries.

---

## 9. Agent task handoff template

Use this template whenever A0 assigns work to an agent.

```text
TASK ID:
AGENT:
TASK TITLE:

BUSINESS OUTCOME:
SOURCE REQUIREMENTS:
IN-SCOPE:
OUT-OF-SCOPE:

FILES / MODULES OWNED:
DEPENDENCIES:
API CONTRACT:
DATABASE / DATA CONTRACT:
EVENTS / NOTIFICATIONS:
PERMISSIONS / DATA SCOPE:

USER EXPERIENCE / DESIGN REFERENCES:
ACCEPTANCE CRITERIA:
EDGE CASES AND FAILURE STATES:
SECURITY / PRIVACY NOTES:

TESTS REQUIRED:
DOCUMENTATION TO UPDATE:
DELIVERABLES:
PR / BRANCH:
BLOCKERS / DECISIONS REQUIRED:
```

Agents must report blockers explicitly rather than inventing missing business rules or provider behaviour.

---

## 10. Recommended initial task allocation

| Task | Agent | Deliverable |
|---|---|---|
| AG-0001 | A0 | Confirm repository structure, ADR process, branch and PR standards |
| AG-0002 | A3 | Backend skeleton, health endpoints, configuration and OpenAPI baseline |
| AG-0003 | A4 | Reconcile bootstrap SQL with one formal migration strategy; test clean install |
| AG-0004 | A3 + A4 | Authentication, employee, group, permission and scope contract |
| AG-0005 | A1 | Public website shell and landing page using approved design tokens |
| AG-0006 | A1 | Staff Portal shell, navigation and dashboard shell |
| AG-0007 | A2 | Technician app shell, navigation and secure session foundation |
| AG-0008 | A2 | Customer app shell, navigation and secure session foundation |
| AG-0009 | A5 | WhatsApp provider feasibility, prerequisites and adapter design |
| AG-0010 | A6 | Notification event catalogue, preferences and delivery lifecycle design |
| AG-0011 | A7 | Inverter/provider capability register and telemetry adapter contract |
| AG-0012 | A8 | Traceability matrix, test harness and authorization test plan |
| AG-0013 | A9 | CI pipeline, development/staging environment and secure deployment baseline |

The first implementation milestone is not “build every screen at once”. It is a working, testable foundation: repository conventions, repeatable builds, a clean database migration path, authentication/authorization contracts and app shells.

---

## 11. Risks and controls

| Risk | Control |
|---|---|
| Agents build incompatible API payloads | OpenAPI contract-first workflow and generated/validated clients |
| Duplicate or conflicting database entities | A4 schema ownership and canonical data dictionary |
| Frontend reimplements business rules | Backend is authoritative; client logic is presentation-only |
| Group names become permissions | Separate group, permission, scope and override model |
| WhatsApp provider is not approved | A5 verifies account/API/template prerequisites before claiming delivery |
| Inverter APIs are unavailable | A7 verifies exact manufacturer/model access; no assumed universal API |
| Concurrent agents overwrite each other's work | File ownership, feature branches and PR review |
| Mock data reaches production | Test-only fixtures, no fake business seed records |
| Unverified regulatory calculations | Rules carry source, version, effective date, reviewer and approval state |
| Production migration damages data | Staging rehearsal, backup, reviewed migration and rollback/forward-fix plan |
| Scope expands without control | A0 records change requests and impact before assignment |

---

## 12. Approval checklist

Before agents start implementation, the project owner and A0 should confirm:
- [ ] Agent ownership and whether any agent will be combined.
- [ ] MVP versus Phase 2 feature boundaries.
- [ ] Repository layout and branch protection/PR rules.
- [ ] API contract and versioning policy.
- [ ] PostgreSQL migration runner and bootstrap reconciliation plan.
- [ ] Authentication/session and access-control design.
- [ ] WhatsApp provider/account and template approval path.
- [ ] Inverter manufacturers/models and API access evidence.
- [ ] Hosting provider, VPS sizing, domains and backup destination.
- [ ] Production data, privacy, retention and incident ownership.
- [ ] Acceptance owner for business workflows and release sign-off.



---

## 13. Common Agent Workspace — the single source of truth

All agents must share project information through one common, version-controlled workspace in the same repository. Private agent memory, chat history, direct messages and local notes are not authoritative project records.

**Canonical shared workspace:** `docs/agent-hub/`

Proposed structure:

```text
docs/agent-hub/
├── README.md                    # How agents collaborate; links to all shared records
├── PROJECT-STATUS.md             # Current phase, milestone, overall health and last update
├── TASK-BOARD.md                 # Task ID, owner, status, priority, dependencies and PR
├── AGENT-STATUS/                 # One current status report per agent
│   ├── A0-status.md
│   ├── A1-status.md
│   ├── A2-status.md
│   ├── A3-status.md
│   ├── A4-status.md
│   ├── A5-status.md
│   ├── A6-status.md
│   ├── A7-status.md
│   ├── A8-status.md
│   └── A9-status.md
├── CONTRACTS/
│   ├── API-CONTRACT-REGISTER.md
│   ├── DATABASE-CHANGE-REGISTER.md
│   ├── EVENT-CONTRACT-REGISTER.md
│   ├── UI-COMPONENT-CONTRACT.md
│   └── INTEGRATION-CONTRACT-REGISTER.md
├── DECISIONS/
│   ├── ADR-INDEX.md
│   └── DECISION-LOG.md
├── HANDOFFS/
│   └── HANDOFF-TEMPLATE.md
├── BLOCKERS/
│   └── BLOCKER-AND-DEPENDENCY-LOG.md
├── TESTING/
│   ├── TEST-STRATEGY.md
│   ├── TEST-CASE-REGISTER.md
│   ├── REGRESSION-RESULTS.md
│   └── RELEASE-TEST-REPORT.md
└── RELEASES/
    ├── CHANGELOG.md
    └── RELEASE-READINESS.md
```

This folder is the proposed shared coordination hub. A0 owns its structure and index; each specialist agent owns updates to its own status and the technical records it authors. The project owner can inspect the same records without needing to reconstruct decisions from multiple agent conversations.

### 13.1 What every agent must publish

At the beginning of a task:
- Task ID, assigned owner and intended outcome.
- Planned files/modules and expected interfaces.
- Dependencies and assumptions.
- Questions requiring a decision.
- Planned test cases and acceptance criteria.

During work:
- Current status: `NOT STARTED`, `IN PROGRESS`, `BLOCKED`, `IN REVIEW`, `DONE`.
- Files/PRs changed and the latest commit/PR reference.
- API/schema/event changes proposed.
- Decisions made or required.
- Test results, including failed tests.
- Blockers, affected agents and what is needed to unblock them.

At handoff:
- Completed deliverables and exact locations.
- What changed and what did not change.
- Contract/schema/event versions.
- Tests executed and actual results.
- Known defects, limitations and follow-up tasks.
- Deployment/migration impact.
- Next agent(s), required action and acceptance owner.

### 13.2 Communication protocol

1. **Repository records are authoritative.** If a decision or contract is not recorded, it is not an approved shared decision.
2. **Use task IDs in every handoff.** A1 should refer to `AG-0005`, not an informal description such as “the website work”.
3. **Use PRs for code collaboration.** Reviews and change requests must remain visible on the PR.
4. **Use contract registers for cross-agent interfaces.** Do not send an API/schema change only in chat and assume other agents know about it.
5. **Use the blocker log for dependencies.** A blocked agent records the blocker, owner, impact, required decision and date raised.
6. **Use ADRs for architecture decisions.** Include context, options, decision, consequences, status and approver.
7. **Use the task board for status.** The status report and task board must link to each other.
8. **A0 publishes an integration summary** after each integration cycle, listing merged work, contract changes, failing checks and next actions.
9. **No silent breaking changes.** Notify every listed consumer and obtain compatibility sign-off before merging.
10. **Do not use chat as the only record.** Conversations may be used to discuss, but decisions and outcomes must be copied into the repository.

### 13.3 Contract change handshake

For any API, database, event, UI component or provider integration change:

1. Proposing agent creates a change entry with reason and proposed version.
2. Owning agent reviews impact and updates the relevant contract.
3. Every consuming agent confirms compatibility or records required changes.
4. A0 resolves conflicts and records approval or rejection.
5. Implementation and tests are updated together.
6. The contract register records merged PR/commit and effective version.

### 13.4 Agent status report template

```text
AGENT:
REPORT DATE:
CURRENT TASK IDS:
OVERALL STATUS: NOT STARTED / IN PROGRESS / BLOCKED / IN REVIEW / DONE

COMPLETED SINCE LAST UPDATE:
CURRENT WORK:
FILES / MODULES CHANGED:
BRANCH / PR / COMMIT:

CONTRACTS CREATED OR CHANGED:
DEPENDENCIES:
BLOCKERS / DECISIONS NEEDED:
TESTS RUN:
TEST RESULTS:
KNOWN DEFECTS / RISKS:

NEXT ACTION:
NEXT AGENT / HANDOFF:
```

### 13.5 Task board status rules

- `BACKLOG`: not yet ready for assignment.
- `READY`: Definition of Ready satisfied.
- `IN PROGRESS`: an agent has started work.
- `BLOCKED`: work cannot safely continue; blocker is logged.
- `IN REVIEW`: deliverable and tests are submitted for review.
- `CHANGES REQUESTED`: review found required corrections.
- `INTEGRATING`: approved work is being tested with dependent components.
- `DONE`: Definition of Done met and evidence linked.
- `DEFERRED`: intentionally moved to a later phase with reason and approval.

Only A0 (or an explicitly delegated release coordinator) changes cross-agent milestone status to `DONE`. An agent may report its own implementation complete, but integration is not complete until dependent checks pass.

---

## 14. Mandatory testing rules and test case catalogue

Testing is part of every agent's deliverable, not a final activity assigned only to A8. Each implementation PR must add or update tests for the behaviour it changes. A8 owns the overall strategy, cross-system regression and independent release evidence.

### 14.1 Test levels

| Test level | Purpose | Main owner |
|---|---|---|
| Static checks | Formatting, lint, type checking, dependency and secret scanning | Each agent; A9 runs CI |
| Unit tests | Individual functions, validators, components and domain rules | Implementing agent |
| Component tests | UI components, API handlers and adapters in isolation | Implementing agent |
| Contract tests | API schemas, event payloads and provider adapter interfaces | A3/A5/A6/A7 with A8 |
| Database tests | Migrations, constraints, transactions and data integrity | A4 with A8 |
| Integration tests | Multiple modules/services working together | Relevant agents with A8 |
| End-to-end tests | Complete user journeys across apps/API/database | A8 with A1/A2/A3 |
| Security tests | Authentication, authorization, tenant/customer isolation, abuse cases | A8 with A3/A4/A9 |
| Operational tests | Deployment, restore, retry, queue recovery and monitoring | A9 with A8 |
| User acceptance tests | Real business workflow acceptance by authorised GreenGrid stakeholders | Project owner/business users, coordinated by A0 |

### 14.2 Mandatory cross-platform test cases

The following baseline cases must be included in the test register. Each test must have a stable ID, requirement link, setup, steps, expected result, actual result, evidence and status.

| Test ID | Area | Scenario | Expected result |
|---|---|---|---|
| CORE-001 | Identity | Valid user signs in | Correct account/session established; no secrets exposed |
| CORE-002 | Identity | Invalid credentials | Safe error; no account enumeration or sensitive detail |
| CORE-003 | Identity | Expired/revoked session calls protected API | Request rejected and client prompted to re-authenticate |
| AUTH-001 | Access | Employee has permission through one valid group | Permitted action succeeds within granted scope |
| AUTH-002 | Access | Employee belongs to multiple groups | Valid grants combine according to canonical policy |
| AUTH-003 | Access | Matching deny exists alongside an allow | Deny wins; action and record remain inaccessible |
| AUTH-004 | Access | User requests another customer's record | Server rejects access without leaking record details |
| AUTH-005 | Access | User attempts access by changing URL/ID | Server independently checks resource scope |
| AUTH-006 | Access | List, count, search, export and file endpoints | All enforce the same authorization boundary |
| CRM-001 | Enquiry | Public visitor submits valid enquiry | Server creates one enquiry and returns its reference |
| CRM-002 | Enquiry | Required field missing or malformed | Field-level validation; no partial invalid record |
| CRM-003 | Enquiry | Same request retried after timeout | Idempotency prevents duplicate enquiry |
| CRM-004 | Conversion | Survey exists but quotation not accepted | Project conversion is blocked |
| CRM-005 | Conversion | Accepted quotation and commercial/site preconditions satisfied | One idempotent conversion links correct customer, site and project |
| CRM-006 | Conversion | Site or quotation version is ambiguous | Conversion blocked with actionable explanation |
| FILE-001 | Files | User uploads allowed file type and size | File stored privately; metadata and access policy recorded |
| FILE-002 | Files | Disallowed file type/oversized upload | Rejected safely; no public file created |
| FILE-003 | Files | User requests another customer's file | Access denied server-side |
| FIN-001 | Finance | Staff records funds received | Receipt is recorded as unverified, not automatically posted |
| FIN-002 | Finance | Customer uploads payment screenshot | Screenshot alone does not mark receipt verified |
| FIN-003 | Finance | Authorised staff verifies receipt | Verified/posted state and audit trail created |
| FIN-004 | Finance | Duplicate receipt verification request | Idempotent result; no duplicate allocation |
| NOTIF-001 | Notifications | Business event emitted once | Eligible recipient/channel jobs created once |
| NOTIF-002 | Notifications | Same event consumed repeatedly | No duplicate outbound message |
| NOTIF-003 | Notifications | Provider unavailable | Retry/backoff; event remains observable |
| NOTIF-004 | Notifications | User opted out of a channel | That channel is not used where opt-out applies |
| NOTIF-005 | Notifications | Provider accepts request but callback says failed | State reflects provider callback; never falsely marked delivered |
| WA-001 | WhatsApp | Invalid webhook signature | Request rejected; no event processed |
| WA-002 | WhatsApp | Valid webhook replayed | Replay/deduplication prevents duplicate processing |
| WA-003 | WhatsApp | Template not approved or invalid variables | Message is blocked and reason recorded |
| MON-001 | Monitoring | Telemetry is missing or stale | UI shows unavailable/stale, not zero generation |
| MON-002 | Monitoring | Actual measured generation is zero | Zero is represented as a real measurement with timestamp/source |
| MON-003 | Monitoring | Duplicate/out-of-order readings arrive | Data-quality policy handles them deterministically |
| MON-004 | Monitoring | Alert condition repeats | Alert deduplicated/suppressed according to rule |
| MON-005 | Monitoring | Telemetry recovers | Alert recovery recorded; service case remains independently managed |
| MON-006 | Monitoring | Provider API rate-limits or times out | Backoff and health status; no false healthy reading |
| SVC-001 | Service | Customer submits a service request | Case created and customer receives server-confirmed reference |
| SVC-002 | Service | Duplicate report submitted for same active issue | Duplicate prevention policy prompts/links rather than creating uncontrolled duplicates |
| SVC-003 | Service | Technician lacks assignment | Restricted job details/actions denied |
| SVC-004 | Service | Technician completes visit with required evidence missing | Completion blocked with exact missing requirements |
| SVC-005 | Service | Technician submits valid completion | Server validates, records evidence and moves case/work order according to workflow |
| MOB-001 | Mobile | App loses connectivity while editing | Clear offline state; unsent input preserved where supported |
| MOB-002 | Mobile | API write times out with uncertain result | Client does not claim success; safe retry/idempotency prevents duplicates |
| MOB-003 | Mobile | Camera/notification permission denied | Explain limitation and provide safe alternative where possible |
| WEB-001 | Web | Direct navigation to protected route without session | Redirect/sign-in state; protected data not rendered |
| WEB-002 | Web | Narrow mobile browser viewport | Layout remains usable without horizontal overflow for normal content |
| OPS-001 | Operations | Worker restarts with queued jobs | Retry/recovery does not lose or duplicate business effects |
| OPS-002 | Operations | Database backup is restored in isolated environment | Restore evidence and integrity checks pass |
| OPS-003 | Deployment | New release health check fails | Release is halted or rolled back using approved procedure |
| OPS-004 | Audit | Privileged access or sensitive state change occurs | Required audit event recorded with actor, time and correlation |

This is a baseline catalogue, not the complete test suite. Each screen, API operation, field validation, workflow transition and integration requires additional feature-specific cases.

### 14.3 Required test case format

```text
TEST ID:
TITLE:
REQUIREMENT / SCREEN / API:
PRIORITY: P0 / P1 / P2 / P3
TYPE: UNIT / COMPONENT / CONTRACT / INTEGRATION / E2E / SECURITY / UAT

PRECONDITIONS:
TEST DATA:
STEPS:
EXPECTED RESULT:
ACTUAL RESULT:
PASS / FAIL / BLOCKED / NOT RUN:
ENVIRONMENT / BUILD:
AUTOMATION LOCATION:
EVIDENCE:
DEFECT ID (IF FAILED):
OWNER:
LAST EXECUTED:
```

### 14.4 Test data and environment rules

- Unit/integration tests use isolated fixtures and disposable databases.
- Synthetic customer, employee, plant and telemetry records must be clearly labelled test data and must never enter production.
- Never copy production personal data into development/test environments without approved lawful basis, minimisation and protection.
- Provider sandboxes or mocks are used until production credentials and approvals are verified.
- Test results must identify environment, build/commit and execution date.
- Flaky tests are logged and fixed; they are not silently skipped to make CI green.
- A failed security/data-isolation test blocks release until fixed and retested.
- A8 maintains regression selection and records any approved exception with owner, reason, expiry and compensating control.

### 14.5 Release test gates

A release cannot be marked ready unless:
1. Required static checks, unit tests and contract tests pass.
2. All changed migrations pass clean-install and upgrade-path tests.
3. Critical end-to-end business journeys pass.
4. Authorization and customer-data isolation tests pass.
5. WhatsApp/provider integrations are either verified in the intended environment or explicitly disabled/labelled unavailable.
6. Monitoring data-quality and alert lifecycle checks pass for any monitoring release.
7. No unresolved P0/P1 defect remains without documented exceptional approval.
8. Backup/restore and rollback procedures are current for the release risk.
9. A8 publishes the test report; A0 records the release decision; A9 executes only the approved deployment.

---

## 15. Shared workspace bootstrap checklist

The shared workspace has been created and verified in the repository at [docs/agent-hub/](../../../../agent-hub/README.md). It contains:
- [ ] Initial README and collaboration protocol.
- [ ] Project status and assigned task board.
- [ ] One status report file for every agent A0–A9.
- [ ] API, database, event, UI and integration contract registers.
- [ ] ADR index and decision log.
- [ ] Handoff and blocker templates.
- [ ] Test strategy and test case register.
- [ ] Regression results and release test report templates.
- [ ] Changelog and release readiness checklist.

**Execution status:** Workstream ownership and initial task assignments are recorded in the task board. The agents themselves have not been launched; tasks are not marked as started. The workspace is ready for coordinated execution once the project owner authorises the implementation start.


**Status note:** This document is an agent execution plan. It does not mean agents have been started, code has been implemented, external accounts have been approved, or deployment has occurred. All workstreams remain subject to the project scope, stakeholder validation and the existing canonical consistency decisions.
