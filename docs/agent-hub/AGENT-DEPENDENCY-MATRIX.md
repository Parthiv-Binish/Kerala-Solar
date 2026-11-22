# A0 Agent Dependency Matrix

**Owner:** A0  
**Status:** Proposed coordination baseline; agents must acknowledge/raise conflicts  
**Updated:** 2026-11-22

## 1. Dependency overview

| Agent | Owns | Requires first | Provides to | Critical handoff |
|---|---|---|---|---|
| A0 | Architecture, scope, backlog, contracts, integration/release gates | Sponsor scope/decision authority; repository baseline | A1–A9 | Approved contracts, ADRs, dependency gates, integration sign-off |
| A1 | React/Vite public site, staff portal, admin UI | ADR-0004 workspace boundary; approved UI/UX tokens for static shell; A3 auth/session + domain OpenAPI and A8 security review before protected behavior | A0, A8; consumes A3 | Route/page map, API client contract, screen-to-API map, UI tests |
| A2 | Expo customer and technician Android apps | A0 app/identity separation; A3 auth/domain APIs; A4 stable DTO/data IDs; A8 mobile security | A0, A8; consumes A3/A6/A7 | App identity/navigation, secure session, offline boundary, device tests |
| A3 | FastAPI, workflows, authz, OpenAPI, outbox | A0 API/architecture decisions; A4 schema contract; A8 threat/test requirements | A1, A2, A5, A6, A7, A9 | OpenAPI, DTOs, authz policy, events, error/idempotency semantics |
| A4 | PostgreSQL schemas, migrations, dictionary, data governance | A0 domain boundaries; A3 ORM/API and transaction impact; business owner approval for policy | A3, A7, A6; A1/A2 indirectly | DDL, migration ledger, ERD-to-physical map, constraints and test evidence |
| A5 | WhatsApp provider adapter | A6 event/delivery contract; A3 webhook/outbox/idempotency; provider/legal/security verification; A8 review | A6, A3, A0 | Adapter interface, verified capability matrix, webhook/security/retry evidence |
| A6 | Notification orchestration, preferences, delivery | A3 event/outbox envelope and recipient eligibility; A4 schema; A2 push-token lifecycle; A8 privacy review | A1, A2, A5, A3 | Channel-neutral event/delivery DTOs, preferences, delivery status and retry semantics |
| A7 | Plant/device adapters, telemetry and alerting | A3/A4 plant/device identity and ingestion contracts; exact device/provider evidence; A8 data/security tests | A3, A6, A1, A2 | Normalized telemetry schema, freshness/quality, adapter capability, alert events |
| A8 | QA, security, privacy, compliance | A0 traceability baseline; contracts from A1–A7; A9 CI/security tooling | All agents, A0 release gate | Test plans/results, threat findings, privacy/compliance evidence, release recommendation |
| A9 | Docker, CI/CD, infrastructure, reliability | A0 architecture; A3/A4 service and migration commands; A8 security controls | All agents | Reproducible environments, pipelines, secrets, backups/restore, observability |

## 2. Dependency edges

- **A0 → all:** scope, interfaces, ADR and integration gates. A0 does not absorb implementation ownership.
- **A4 ↔ A3:** schema and API are co-designed. A4 owns DDL/migration; A3 owns service/API/transaction semantics. No independent schema changes by A3.
- **A3 → A1/A2:** clients integrate only against reviewed OpenAPI and stable error/auth/session contracts.
- **A3 + A6 → A5:** WhatsApp consumes channel-neutral notification jobs/events; A5 does not own notification policy or recipient selection.
- **A3 + A4 → A6:** domain event source, consent/preferences and recipient eligibility must be defined before dispatch.
- **A3 + A4 → A7:** canonical plant/device identity and storage/ingestion contract before telemetry features.
- **A2 → A6:** push token registration, refresh, revocation and device notification preferences.
- **A8 ↔ all:** acceptance/test requirements are designed before implementation; security review is continuous, not a final-only activity.
- **A9 ↔ A3/A4/A8:** deployable commands, migration lifecycle, secrets, health/readiness and CI security checks are co-owned.
- **A0 + A8 + A9 → pilot:** A0 coordinates; A8 supplies independent test/security evidence; A9 supplies operational evidence.

## 3. Parallel work rules

Can proceed in parallel after S0:
- A3 API skeleton, A4 migration audit, A8 traceability/test harness, A9 CI/dev stack, A5 provider feasibility, A6 event/notification design, A7 device capability discovery.
- A1 AG-0005 static public shell and AG-0006 staff frame/navigation placeholders may start under ADR-0004 without API wiring, auth or protected data.
- A2 navigation/app shell may start after application identity and session boundary are agreed.

Must wait:
- A1 protected staff routes, permission-aware navigation, auth/session and CRM screens wait for reviewed API-001/API-002 and DOC-001–003 gate resolution.
- A2 protected customer/technician data flows wait for API/authz contracts and verified customer/employee identity boundaries.
- Customer account workflows wait for verified customer/contact relationship policy and customer/site isolation.
- Notification dispatch waits for recipient eligibility/consent and outbox event contracts.
- Provider production integration waits for account, terms, webhook and security evidence.
- Telemetry production ingestion waits for exact make/model/data rights and canonical plant/device contract.
- Production deployment waits for restore, security, privacy, monitoring and business acceptance evidence.

## 4. File ownership and collision prevention

- A1: `apps/web/**` (initial public site + staff portal single Vite app).
- A2: `apps/mobile/**` (distinct customer/technician experiences).
- A3: `apps/api/**`, backend services/routes/OpenAPI/events and backend tests.
- A4: `database/**`, migration files, dictionary and physical mapping.
- A5: provider-specific WhatsApp adapter package/paths approved with A3/A6; no ownership of recipient policy.
- A6: notification orchestration package; coordinate any `apps/api/notifications/**` overlap with A3 before file creation.
- A7: monitoring/telemetry package; coordinate any `apps/api/monitoring/**` overlap with A3 before file creation.
- A8: QA/security docs and test ownership; coordinate shared CI files with A9.
- A9: `infra/**`, Docker/CI/deployment/runbooks; shared workflow files require A8/A0 review.
- A0: `docs/agent-hub/**`, ADRs and coordination/architecture records. A0 does not edit agent-owned implementation files.

These are proposed path boundaries; inspect actual repository structure before creating implementation directories. If overlap is unavoidable, name one file owner and require the other agent's PR to target an interface/contract rather than the same file.

## 5. Mandatory handoff payload

Every handoff includes: task ID; sending/receiving agent; branch/PR/commit; files changed; contract/version; schema/API/event compatibility; requirements and DOC issue IDs; tests run/results/environment; security/data-scope notes; known gaps/blockers; deployment/migration instructions; rollback notes; next action and acceptance owner.
