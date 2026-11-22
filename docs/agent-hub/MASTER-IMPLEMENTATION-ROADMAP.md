# A0 Master Implementation Roadmap

**Owner:** A0 — Chief Architect & Integration Coordinator  
**Status:** BASELINE PROPOSED — requires sponsor/business approval and agent acknowledgement  
**Baseline date:** 2026-11-22  
**Repository:** `Parthiv-Binish/Kerala-Solar`  
**Authority:** Agent Hub; detailed product authority remains the approved SRS, workflows, architecture, ERDs, security model and decision register.

## 1. Executive direction

Deliver one GreenGrid platform as a modular FastAPI monolith with one PostgreSQL system of record, React/Vite staff/public web, separate customer and technician React Native/Expo Android experiences, Redis-backed workers where justified, private object storage and Docker-based deployment. All clients use versioned backend APIs. Do not split into microservices without a measured operational reason and an ADR.

The repository is planning/specification plus authored database bootstrap material. No application, provider connection, staging environment, live migration execution or production deployment is verified by this baseline.

## 2. Scope baseline

### MVP (subject to business sign-off)
- Identity and employee access foundation; separate customer identity lifecycle.
- Public enquiry intake and staff CRM; assignment, follow-up and auditable history.
- Customer/site resolution; conversion only after acceptance of an exact issued quotation version, required approvals and one confirmed site; idempotent customer/site/project creation.
- Surveys, design/quotation revisions, project milestones/tasks and document vault.
- Manual utility/DISCOM/subsidy tracking with source, updater, timestamp and evidence.
- Installation work orders, technician assignment/evidence, basic service cases.
- Receipt recording and authorized verification/allocation; no assumed payment gateway.
- Customer and technician Android foundations, online-first.
- Consent-aware notification orchestration; manual/provider-enabled channels only after verification.

### Explicitly later / not silently promoted
- Full encrypted technician offline packs, durable offline drafts, media queueing and conflict-aware sync (Phase 2).
- Customer web portal (Phase 2 by default).
- Full inventory/procurement depth, warranty/AMC/RMA, manufacturer telemetry automation, advanced analytics, local gateways and yield prediction unless re-scoped.
- Multi-company/multi-branch architecture and remote inverter control.

### Non-goals / external boundaries
No assumed E-Kiran/National Portal public API, automatic government submissions, subsidy eligibility guarantee, payment gateway, specific inverter API, or official WhatsApp integration. Government portal remains authoritative; local records are observations with provenance. No fake production business data.

## 3. Delivery sequence and gates

| Stage | Objective | Primary owners | Exit evidence |
|---|---|---|---|
| S0 — Coordination baseline | Confirm ownership, repo workflow, backlog, ADRs and contracts | A0; all agents acknowledge | Hub records merged; task owners/reviewers/branches confirmed |
| S1 — Foundation | Dev environment, FastAPI skeleton, migration validation, identity/authz contract and CI | A3, A4, A8, A9; A0 | Clean PostgreSQL migration test; OpenAPI baseline; authorization truth-table; CI green; reproducible dev stack |
| S2 — Core CRM and commercial | Enquiry, customer/contact/site, survey, quotation, conversion | A3, A4, A1; A8 | CRM schema/API/UI integrated; conversion idempotency and identity isolation tests |
| S3 — Delivery operations | Projects, milestones, utility tracking, work orders, documents, customer/technician app journeys | A3, A4, A1, A2; A8 | Cross-app workflow E2E; field evidence authorization; customer isolation |
| S4 — Communications and service | Outbox, notifications, provider adapters, service cases | A3, A5, A6, A2; A8 | Event contract tests, consent/recipient policy, retry/dedupe and provider sandbox evidence |
| S5 — Monitoring and operations | Plant/device registry, telemetry adapter, alerts, observability | A3, A4, A7, A9; A8 | Verified source/model capability; normalized telemetry quality/freshness; alert dedupe |
| S6 — Pilot readiness | Security, privacy, recovery, deployment, training and business acceptance | A0, A8, A9; all owners | Release checklist complete; restore drill; signed pilot and operational ownership |

Stages are dependency gates, not promises of calendar completion. A0 may run independent discovery/contract work in parallel; downstream implementation cannot bypass a blocking gate.

## 4. Agent work packages

- **A0:** architecture governance, roadmap, dependency management, contract arbitration, integration and release coordination. Does not own application feature implementation.
- **A1:** public website, staff portal and admin UI. API-driven; no client-side business authorization.
- **A2:** customer and technician Android apps; distinct identities/navigation/data visibility; online-first MVP.
- **A3:** FastAPI modules, domain workflows, authn/authz resolver, OpenAPI, outbox and API integration.
- **A4:** PostgreSQL physical model, schema migrations, constraints/indexes, migration ledger, dictionary and data governance.
- **A5:** replaceable WhatsApp adapter; provider feasibility and operations verification first.
- **A6:** notification event envelope, preferences, recipient eligibility, delivery orchestration and channel adapters.
- **A7:** plant/device registry integration boundary, manufacturer/gateway capability validation, telemetry normalization and alert rules.
- **A8:** traceability, test automation, security/privacy/compliance review, cross-app regression and release evidence.
- **A9:** Docker/dev/staging/prod architecture, CI/CD, secrets, backups, restore, monitoring and runbooks.

Detailed task IDs remain in [TASK-BOARD](TASK-BOARD.md); dependencies are in [AGENT-DEPENDENCY-MATRIX](AGENT-DEPENDENCY-MATRIX.md).

## 5. Shared engineering contracts

1. **API:** FastAPI is the only business API. Use `/api/v1` as the proposed version prefix; exact paths are normative only after reviewed OpenAPI is committed. Request/response DTOs are separate from ORM models.
2. **Identity:** employee and customer account populations remain separate. A phone/email match is not proof of identity or authority. Customer access requires verified, active customer/contact links and customer/site policy.
3. **Authorization:** groups are membership/grant sources, never roles. Permissions and data scopes are distinct. Canonical employee scopes: `own`, `assigned`, `team`, `related`, `location`, `company`. Any applicable deny wins; no matching allow means deny. Resolve scopes server-side and fail closed.
4. **Database:** one PostgreSQL database. BIGINT internal keys; UUID public identifiers. Schema changes only via reviewed migration sequence and updated dictionary. SQL 0001–0006 remain the only current bootstrap authority until a reviewed equivalence-tested migration-runner transition is approved.
5. **Events:** transactional outbox for committed business events; versioned event schema, event ID, occurred_at, actor/context, correlation ID, privacy classification and idempotency semantics. Queue acceptance is not channel delivery.
6. **Async:** Redis/ARQ is the working baseline where async jobs are justified. No external call inside long DB transactions. Retry boundedly; dead-letter/review terminal failures.
7. **Data:** timestamps use ISO 8601 with offsets at API edges and UTC storage; money uses decimal-safe representation and explicit currency; pagination/filter/sort bounded and allowlisted.
8. **Files:** private object storage; backend-mediated, authorization-checked upload/download; never expose bucket credentials or unrestricted public paths.
9. **Integrations:** provider adapters; server-side credentials; capability/terms/account/sandbox evidence before activation. No provider API availability inferred.
10. **Quality:** requirement → screen → API → entity → permission → test traceability. Every feature tests loading, empty, validation, forbidden, failure and recovery states.

See [API contract register](CONTRACTS/API-CONTRACT-REGISTER.md), [event register](CONTRACTS/EVENT-CONTRACT-REGISTER.md), and [external integration register](CONTRACTS/INTEGRATION-CONTRACT-REGISTER.md).

## 6. Governance and change control

- Every task has one accountable owner, named reviewer, dependencies, planned file ownership, requirement IDs, acceptance criteria and test IDs.
- Separate branches/worktrees per agent. No shared-file concurrent edits. Coordinate overlapping changes through a single integrator/PR sequence.
- Branch format: `agent/<A#>/<task-id>-<short-name>`; PR title includes task ID. This coordination baseline uses `a0/coordination-baseline`.
- A0 reviews cross-domain API/event/architecture impacts; A3 reviews API semantics; A4 reviews DDL; A8 reviews security/test implications; affected clients sign off on breaking contracts.
- Proposed business/legal/provider policy stays PROPOSED/VERIFY until owner evidence/approval.
- Statuses follow Agent Hub vocabulary. DONE requires merged artifact and test evidence; integrated/release-ready are separate A0 gates.
- Record blocker ID, impact, owner, next action and exit evidence in BLOCKERS; handoff reports must state delivered, not delivered, known limitations, tests and next owner.

## 7. First priorities

P0: AG-0001/0014 coordination; AG-0002 backend baseline; AG-0003 migration validation; AG-0004 authorization contract (blocked until implementation/tests and business approvals); AG-0009/0010 provider and notification contract discovery; AG-0012 QA/traceability; AG-0013 CI/dev-staging baseline; resolve DOC-001–DOC-003 and critical prerequisites.

P1: CRM/domain schema/API and web shell after foundations; customer identity lifecycle and cross-customer isolation; outbox; app shells; provider verification; staging/restore.

## 8. Open approvals and blockers

- Business owner approval of MVP, department/workflow, customer/contact authority verification and conversion policy.
- A3/A4/A8 evidence for server-side deny-overrides, scope resolution and employee/customer isolation.
- A4/A3 migration authority and migration 0001–0006 disposable PostgreSQL clean-install evidence.
- Confirm exact deployment environment, data region, RPO/RTO and operating budget.
- Confirm WhatsApp provider, target inverter makes/models and lawful/authorized government or postal data sources.
- Resolve critical documentation issues DOC-001 onward according to the Documentation Issue Register. Documentation edits alone do not close an issue.

## 9. Links and authority

Start at [Agent Hub README](README.md), [required reading](REQUIRED-READING-MAP.md), [project status](PROJECT-STATUS.md), [task board](TASK-BOARD.md), [dependency matrix](AGENT-DEPENDENCY-MATRIX.md), [sprint plan](SPRINT-MILESTONE-PLAN.md), [integration readiness](INTEGRATION-READINESS-CHECKLIST.md), [decisions](DECISIONS/) and [handoffs](HANDOFFS/).
