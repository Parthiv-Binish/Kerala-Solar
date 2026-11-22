# Complete Application Documentation Programme

**Document ID:** DOC-APP-MASTER-001  
**Status:** Master documentation plan — living specification  
**Purpose:** Define the complete documentation set required before implementation of the GreenGrid Solar platform.

[← Project Book](../../../INDEX.md) · [← Platform specification](../README.md) · [← Application suite and screen inventory](../12-application-experience/00-application-suite-and-screen-inventory.md)

---

## 1. What “complete documentation” means

The platform is not a single website. It is a connected suite of user-facing applications, operational services and shared platform capabilities.

Documentation is complete only when a developer, tester, business owner and end user can understand:
- Which application or service owns each capability.
- Who uses it and what they are allowed to see or do.
- Every screen, navigation path, state and user action.
- The business workflow before and after each action.
- Fields displayed, entered, calculated, validated and saved.
- Which records are read, created, updated or linked.
- API operations and permission checks.
- Notifications, integrations, retries and failure behaviour.
- Audit, privacy, security, offline and recovery requirements.
- Acceptance criteria and unresolved stakeholder decisions.

A list of screens alone is not a complete specification. Every important screen must have a field/action/data/validation specification and be linked to the workflow and API contract.

## 2. Product suite

| ID | Product/service | Primary users | Client/runtime | Main responsibility |
|---|---|---|---|---|
| APP-01 | Management & Staff Portal | Owner, manager, sales, survey, design, accounts, stores, operations, support | Responsive web | Central business operations |
| APP-02 | Technician App | Surveyors, installers, service technicians, field supervisors | Android app | Field work, evidence and job completion |
| APP-03 | Customer App | Customers and authorised household contacts | Android app | Customer self-service and plant visibility |
| APP-04 | Customer Web Portal | Customers and authorised household contacts | Responsive web | Browser-based customer self-service |
| SVC-01 | Solar Monitoring Engine | Operations and support through portal views | Background workers and provider adapters | Collect and process plant telemetry |
| SVC-02 | Notification & Communication Engine | All application users through approved channels | Background workers and provider adapters | Reliable outbound and inbound communication |
| APP-05 | Platform Administration | Restricted platform administrators | Protected web area | Identity, configuration, integration and operational controls |
| CORE-01 | Shared Platform API | All clients and services | FastAPI service | Authentication, authorization, validation and business workflows |
| CORE-02 | Shared Data Platform | Backend services | PostgreSQL and private object storage | Authoritative business records and files |

The seven products/services above are logical products. They do not imply seven databases or seven independent backend deployments. The proposed design uses one central API and authoritative database, with separately deployable background workers where justified.

## 3. Documentation books and deliverables

### Book A — Staff Portal

The Staff Portal is the main operational workspace. Its screen-by-screen chapters are created in sequence.

| Chapter | Scope | Status |
|---|---|---|
| A00 | Application suite and screen inventory | Existing |
| A01 | Navigation, dashboard, My Work and shared UI | Existing |
| A02 | Enquiries, follow-ups and customer management | Existing |
| A03 | Survey scheduling, site assessment and survey review | Existing |
| A04 | Solar design, BOM and quotation management | Existing |
| A05 | Project workspace, milestones, tasks and scheduling | Planned |
| A06 | Utility applications, DISCOM processes and subsidy tracking | Planned |
| A07 | Suppliers, procurement, purchase orders and inventory | Planned |
| A08 | Finance, receipts, payments, expenses and project profitability | Planned |
| A09 | Installation, commissioning, quality checks and handover | Planned |
| A10 | Plant registry, equipment, warranty and maintenance plans | Planned |
| A11 | Monitoring dashboard, telemetry, alerts and plant health | Planned |
| A12 | Service desk, service cases, work orders and field maintenance | Planned |
| A13 | Documents, reports, dashboards and management analytics | Planned |
| A14 | Employees, groups, permission sets, settings and administration | Planned |

### Book B — Technician Android App

The technician book must document:
1. App purpose, personas, permissions and navigation.
2. Sign-in, device registration, session expiry and account recovery.
3. Home/today view, assigned work and priority.
4. Calendar, job list, filters and job detail.
5. Job acceptance, start, pause, resume and completion rules.
6. Site address, contact, directions and access instructions.
7. Survey checklist, measurement capture and required evidence.
8. Photo/document capture, metadata, consent and upload.
9. Installation workflow and task checklist.
10. Product/serial-number scanning and manual fallback.
11. Commissioning tests, readings, evidence and reviewer sign-off.
12. Service visit diagnosis, work performed, parts used and outcome.
13. Customer acknowledgement and signature/confirmation rules.
14. Offline-first data capture, local queue, conflict handling and sync.
15. Safety prompts, blocked actions and escalation.
16. Notifications, job updates, audit and acceptance tests.

### Book C — Customer Android App

The customer app book must document:
1. Customer personas, linked contacts and account access.
2. Installation, onboarding, invitation and verification.
3. Sign-in, recovery, sessions and device security.
4. Home dashboard and actionable status summaries.
5. Customer profile, household contacts and preferences.
6. Multiple properties/sites and site details.
7. Enquiry creation and follow-up visibility.
8. Survey appointment and visit updates.
9. Project milestones and progress timeline.
10. Design/quotation review, response and acceptance evidence.
11. Documents and downloads.
12. Payment instructions, receipts and payment history.
13. Plant list, plant detail and performance.
14. Monitoring charts, data freshness and unavailable telemetry.
15. Alerts and customer-safe explanations.
16. Service request creation, duplicate prevention and case tracking.
17. Notifications, support, privacy, consent and account requests.
18. Accessibility, low-connectivity behaviour and acceptance tests.

### Book D — Customer Web Portal

The web portal must document the same customer capabilities as the mobile app, with browser-appropriate navigation and responsive layouts. It must define:
- Shared identity and account model with the Android app.
- Desktop, tablet and mobile navigation.
- Page-level access and deep-link behaviour.
- Upload/download and document preview behaviour.
- Accessible forms and validation.
- Session expiry and secure account handling.
- Feature parity and any deliberate channel differences.
- Cross-channel state consistency and acceptance tests.

The web portal and Android app must not maintain separate customer records or independent business logic.

### Book E — Solar Monitoring Engine

The monitoring book must document:
1. Monitoring objectives and non-goals.
2. Plant, inverter, meter, gateway and device identity.
3. Provider-neutral adapter architecture.
4. Manufacturer/API capability registry and access verification.
5. Polling, webhook and file-import ingestion patterns.
6. Authentication and credential protection for provider connections.
7. Raw telemetry, normalized telemetry and derived metrics.
8. Units, timestamps, timezone, sampling interval and data quality.
9. Missing/stale data versus genuine zero generation.
10. Duplicate, late, out-of-order and invalid readings.
11. Plant/device health and expected reporting windows.
12. Alert rules, severity, deduplication and suppression.
13. Alert lifecycle, acknowledgement, recovery and escalation.
14. Alert-to-service-case policy; an alert is not automatically a resolved service case.
15. Customer-visible performance and data freshness.
16. Operations dashboard and integration health.
17. Retry, rate limiting, backfill and provider outage behaviour.
18. Retention, monitoring security, audit and acceptance tests.

No manufacturer integration is considered available until its API access, terms, credentials, rate limits, supported models and production behaviour are verified.

### Book F — Notification & Communication Engine

The communication book must document:
1. Channel catalogue and provider selection.
2. Customer/staff contact points and verification.
3. Consent, purpose, opt-out and channel preference.
4. Message event catalogue and recipient rules.
5. Templates, languages and approved variables.
6. WhatsApp business provider requirements and template approval.
7. Email, SMS and push notification delivery.
8. In-app notification inbox and read state.
9. Queue, scheduling, retry, backoff and dead-letter handling.
10. Idempotency and duplicate prevention.
11. Delivery, failure, read and response events where supported.
12. Inbound replies and staff hand-off.
13. Sensitive-data minimisation and redaction.
14. Delivery logs, audit, retention and acceptance tests.

A provider integration must not be represented as operational until account approval, API access and end-to-end delivery are verified.

### Book G — Platform Administration

The administration book must document:
1. Admin roles, break-glass access and privileged session rules.
2. Employee/user lifecycle.
3. Groups, group membership and permission sets.
4. Multiple group membership and permission combination.
5. Individual overrides, expiry and audit.
6. Resource scope and server-side enforcement.
7. Sessions, MFA, device/session revocation and login history.
8. Reference/master data management.
9. Product catalogue and configuration governance.
10. Integration registry and credential rotation.
11. Background job schedules and execution history.
12. Error logs, incident records and diagnostic access.
13. Audit event search and export.
14. Backup, restore and disaster recovery status.
15. Feature flags, maintenance mode and release settings.
16. Privacy requests, retention and account closure workflows.
17. Admin acceptance tests and operational runbooks.

Group names must not automatically imply unrestricted access. Permission and resource scope remain separate.

### Book H — Cross-Application Workflow and Integration

This book connects all applications and services:
- Enquiry to customer conversion.
- Survey assignment and technician submission.
- Design and quotation approval.
- Customer quotation response.
- Project creation and milestone updates.
- Procurement and stock allocation.
- Technician installation and commissioning.
- Plant activation and monitoring onboarding.
- Telemetry alert to service case.
- Customer-raised and staff-raised service cases.
- Technician dispatch and resolution.
- Notifications across each workflow.
- Payment/receipt updates and customer visibility.
- User, group and access changes.
- Document generation and file access.

Each workflow must specify initiating event, actor, source application, API command, validation, records changed, event published, recipients, failure/retry and final state.

### Book I — Screen-to-Data and API Catalogue

For every screen/action:
- Screen ID and control/action ID.
- User capability and resource scope.
- API method and route.
- Request/response schema.
- Field source and destination.
- Validation and business rule.
- Database entities affected.
- Transaction boundary and idempotency key.
- Events and notifications.
- Error codes and user-facing messages.
- Audit event.
- Automated test reference.

### Book J — Quality, Security and Operations

Required cross-cutting documents:
- Role/group/permission and scope matrix.
- API security and authentication rules.
- Data classification and privacy map.
- File upload/download security.
- Offline sync and conflict policy.
- Accessibility and usability standards.
- Test strategy and traceability matrix.
- Backup/restore and disaster recovery runbook.
- Monitoring, logging and alerting.
- Deployment, rollback and environment configuration.
- Incident response and support procedures.
- Release readiness checklist.

## 4. Standard screen specification format

Every screen chapter must use the following template.

| Section | Required description |
|---|---|
| Screen identity | Stable screen ID, name, app and version |
| Audience | User groups, permissions and record scope |
| Navigation | Entry points, parent screen, back/next navigation |
| Purpose | User goal in plain language |
| Layout | Header, tabs, cards, lists, actions and responsive behaviour |
| Display data | Field label, source entity, formatting and visibility |
| Inputs | Field name, type, required state, default and help text |
| Validation | Client hint plus authoritative server-side rule |
| Actions | Action name, confirmation, preconditions and outcome |
| Processing | Business logic, calculations and workflow transition |
| Data writes | Create/update/link records and transaction boundary |
| Side effects | Events, notifications, files and background jobs |
| Permissions | Capability and resource scope required |
| Audit | Actor, time, before/after or event details |
| Failure states | Network, validation, permission, conflict and provider failure |
| Empty/loading states | First-use and no-data experience |
| Accessibility | Keyboard, labels, contrast and assistive technology |
| Acceptance tests | Given/when/then scenarios and edge cases |

## 5. Shared architecture rules

1. All clients use the central API; no client connects directly to PostgreSQL.
2. PostgreSQL is the authoritative store for business records.
3. Private files live in controlled object storage; database rows store metadata and access relationships.
4. Redis/queues support background work but are not the authoritative record of business state.
5. All money calculations are server-side using decimal-safe storage and explicit rounding.
6. All timestamps are stored consistently and displayed in the user's/organisation's configured timezone.
7. Every important business state transition is validated and audited.
8. Retried commands must not create duplicate customers, projects, payments, cases or notifications.
9. Resource scopes are enforced by the API, not merely hidden in the UI.
10. Offline clients must show pending/synced/failed states and must not silently discard changes.
11. External providers are adapters; provider outages must not corrupt internal records.
12. Missing data is not zero, and estimated data is not presented as measured/confirmed data.

## 6. Shared data ownership

| Record family | Authoritative owner | Other apps |
|---|---|---|
| Employee, group, permission | Platform Administration / IAM | Staff Portal and API clients consume access decisions |
| Customer, contact, site | Staff Portal / CRM API | Customer channels view permitted records |
| Survey and evidence | Survey workflow | Technician submits; staff reviews; customer sees approved summary |
| Design and quotation | Staff Portal commercial workflow | Customer views/responds to issued version |
| Project, milestone, task | Project workflow | Technician executes assigned work; customer sees permitted progress |
| Stock and procurement | Supply workflow | Design sees availability; project consumes allocations |
| Payment and receipt | Finance workflow | Customer sees permitted receipt/history |
| Plant and device identity | Asset registry | Monitoring links telemetry to registered equipment |
| Telemetry and alert | Monitoring Engine | Staff and customer views consume permission-filtered projections |
| Service case and work order | Service workflow | Customer reports/tracks; technician performs work |
| Message and delivery event | Communication Engine | Source applications request messages and display outcomes |
| Audit event | Shared audit service | Restricted administrative/reviewer access |

## 7. Documentation quality gates

A chapter is not marked complete merely because it has been written. It must pass:

- **G1 — Coverage:** all screens and important actions in scope are listed.
- **G2 — Workflow:** states, transitions, actors and exception paths are described.
- **G3 — Data:** reads, writes, relationships and source of truth are clear.
- **G4 — Access:** permission and resource scope are explicit.
- **G5 — Integration:** APIs, events, providers and failure modes are addressed.
- **G6 — UX:** loading, empty, validation, error, mobile and accessibility states are specified.
- **G7 — Verification:** acceptance tests and unresolved decisions are recorded.
- **G8 — Traceability:** links exist to SRS, data dictionary, ER design, security and related chapters.

Statuses:
- **Planned:** not yet authored.
- **Draft:** content exists but has not passed all gates.
- **Review required:** ready for stakeholder/technical review.
- **Approved:** authorised by the relevant business/technical owner.
- **Implemented and verified:** built and tested against approved acceptance criteria.

Do not use “complete” or “implemented” to describe a draft specification.

## 8. Delivery order

1. Finish the Staff Portal book (A05–A14).
2. Complete the Technician Android App book.
3. Complete Customer Android App book.
4. Complete Customer Web Portal book and parity map.
5. Complete Monitoring Engine book.
6. Complete Notification & Communication Engine book.
7. Complete Platform Administration book.
8. Complete cross-application workflow maps.
9. Complete screen-to-data/API catalogue.
10. Complete quality, security and operations runbooks.
11. Run a consistency review across all books and update the master index.

This order builds the business lifecycle first, then the field/customer channels, then the automation and administration services, and finally validates the end-to-end contracts.

## 9. Release boundaries and verification

- Government portals remain authoritative unless an authorised integration is verified.
- PIN/post-office lookup requires a verified source, access terms and refresh policy; provider failure must not block free-text address entry.
- Inverter telemetry integrations require manufacturer/provider access verification.
- WhatsApp requires an approved business provider and compliant templates/consent handling.
- Engineering calculations and electrical/structural decisions require approved methods and competent review.
- Tax, subsidy and legal language require current qualified review.
- No remote inverter control, firmware update or custom hardware is implied.
- No payment gateway is assumed.
- Finance scope is operational project/customer finance unless statutory accounting is separately approved.
- No production data, passwords, tokens, private keys or customer personal information belongs in this repository.

## 10. Current progress

The application suite blueprint, all fourteen Staff Portal chapters, Technician Android App, Customer Android App, Customer Web Portal, Monitoring Engine, Notification Engine, Platform Administration, cross-application workflows, API catalogue and quality/operations specification have now been authored as draft specifications in this repository. They have been committed and fetched for content verification. They are not yet stakeholder-approved, legally/technically certified, implemented or tested in a running system. Detailed API route schemas, exact database mappings, provider-specific integration contracts and formal acceptance sign-offs remain follow-on review work. This document remains the programme checklist and distinguishes authored documentation from approved/implemented capability.

**Next delivery:** Staff Portal Chapter A05 — Project Workspace, Milestones, Tasks & Scheduling.
