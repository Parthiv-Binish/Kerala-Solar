# Agent Task Board

Task assignments below are work ownership, not evidence that work has started. An agent starts only when the task is READY and records a branch/PR and status update.

| Task | Owner | Work package / deliverable | Dependencies | Priority | Status |
|---|---|---|---|---|---|
| AG-0001 | A0 | Repository conventions, ownership map, sprint/backlog and integration gates | Owner scope approval | P0 | READY |
| AG-0002 | A3 | FastAPI skeleton, configuration, health endpoints and OpenAPI baseline | AG-0001 | P0 | BACKLOG |
| AG-0003 | A4 + A3 | Reconcile SQL bootstrap with one migration strategy; clean-install test | AG-0001 | P0 | READY |
| AG-0004 | A3 + A4 | Identity, employee, groups, membership, permission, scope and deny-precedence contracts; resolve DOC-001–DOC-003 | AG-0003; mapping register; migration 0006; business approval | P0 | BLOCKED — backend resolver and test evidence pending |
| AG-0005 | A1 | Public website and landing-page shell using approved design tokens | AG-0001; UI design system | P1 | BACKLOG |
| AG-0006 | A1 | Staff portal shell, navigation, dashboard shell and route guards | AG-0001; AG-0002/0004 contracts | P1 | BACKLOG |
| AG-0007 | A2 | Technician Android shell, navigation and secure session foundation | AG-0001; AG-0002/0004 | P1 | BACKLOG |
| AG-0008 | A2 | Customer Android shell, navigation and secure session foundation | AG-0001; AG-0002/0004 | P1 | BACKLOG |
| AG-0009 | A5 | OpenWA/provider feasibility, account/session risks, adapter design and test plan | A6 message contract | P0 | READY |
| AG-0010 | A6 | Notification event catalogue, preferences, channel abstraction and delivery lifecycle | A3 event/outbox direction | P0 | READY |
| AG-0011 | A7 | Inverter/provider capability register and telemetry adapter contract | Device/plant identity from A3/A4 | P1 | READY |
| AG-0012 | A8 | Requirement traceability, test harness and authorization test plan | Existing SRS/screen inventory | P0 | READY |
| AG-0013 | A9 | CI pipeline, dev/staging architecture and secure deployment baseline | AG-0001 | P0 | READY |
| AG-0014 | A0 | Establish contract review cadence, cross-agent dependency map and weekly integration report | AG-0001 | P0 | READY |
| AG-0015 | A3 | Enquiry/customer/site APIs and idempotent enquiry intake | AG-0002/0003/0004; DOC-002 customer verification model | P1 | BLOCKED — customer/site authorization contract pending |
| AG-0016 | A4 | CRM/project/finance/monitoring schema implementation sequence and dictionary; reconcile DOC-003 | AG-0003; migration 0006; ERD mapping register | P1 | BLOCKED — remaining domain mappings and database review pending |
| AG-0017 | A1 | Enquiry, customer, survey and quotation staff screens | AG-0006; A3 contracts | P1 | BACKLOG |
| AG-0018 | A2 | Customer enquiry, project timeline and service request app journeys | AG-0008; A3 contracts | P2 | BACKLOG |
| AG-0019 | A2 | Technician assigned jobs, survey, installation and service visit journeys | AG-0007; A3 contracts | P2 | BACKLOG |
| AG-0020 | A3 + A6 | Transactional outbox, notification events and recipient eligibility | AG-0010; AG-0003 | P1 | BACKLOG |
| AG-0021 | A5 + A6 | OpenWA adapter integration, webhook/status mapping, dedupe and retry tests | AG-0009/0010/0020; approval | P1 | BACKLOG |
| AG-0022 | A7 + A3 | Plant/device registration, telemetry ingestion and monitoring APIs | AG-0011; schema contracts | P2 | BACKLOG |
| AG-0023 | A8 | Cross-app E2E, security, privacy and regression suite | Implemented journeys | P1 | BACKLOG |
| AG-0024 | A9 | Staging deployment, backup/restore drill and observability | AG-0002/0003/0013 | P1 | BACKLOG |
| AG-0025 | A3 + A4 + A8 | Customer identity lifecycle: invitation/verification/revocation, customer/site authorization resolver and isolation tests (DOC-001/DOC-002) | AG-0004; migration 0006; approved customer/contact policy | P0 | BLOCKED — business verification policy and backend test harness pending |

## Workstream assignment summary
- A0: AG-0001, AG-0014; coordinates all integrations and release gates.
- A1: AG-0005, AG-0006, AG-0017; then remaining staff/public web screens.
- A2: AG-0007, AG-0008, AG-0018, AG-0019; then mobile feature completion.
- A3: AG-0002, AG-0004, AG-0015, AG-0020 (co-owner); then all domain APIs/workflows.
- A4: AG-0003, AG-0004 (co-owner), AG-0016; then migrations/data quality.
- A5: AG-0009, AG-0021 (co-owner); WhatsApp adapter and provider operations.
- A6: AG-0010, AG-0020 (co-owner), AG-0021 (co-owner); all channel orchestration.
- A7: AG-0011, AG-0022 (co-owner); telemetry, device integrations and alert engine.
- A8: AG-0012, AG-0023; continuous tests and release evidence.
- A9: AG-0013, AG-0024; environments, CI/CD and reliability.

## Task rules
DOC-001–DOC-003 are partially remediated at documentation/schema-artifact level only. Migration 0006 is authored but not executed. AG-0004, AG-0015 and AG-0025 remain blocked until backend authorization and customer identity behaviour are implemented and tested. AG-0016 is limited to schema/documentation planning until migration strategy and database review are approved.\n\nEvery task must add: requirement links, planned files, acceptance criteria, test IDs, dependencies, owner, reviewer and PR. Do not mark DONE without merged code/docs and test evidence. A8 may mark test execution complete; A0 controls integrated milestone status.
