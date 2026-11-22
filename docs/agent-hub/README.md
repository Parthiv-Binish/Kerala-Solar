# GreenGrid Solar — Agent Hub

This is the single repository-backed coordination workspace for agents A0–A9. Repository records, approved contracts, task board and pull requests are authoritative; chat and private agent notes are not.

## Start here
1. Read the [required agent document navigation](REQUIRED-READING-MAP.md) first. It provides the common mandatory reading list and a role-specific document route for every agent A0–A9.
2. Read the [Documentation Issue Register](../15-platform-spec/13-implementation-blueprints/DOCUMENTATION-ISSUE-REGISTER.md). Identify all open issues that affect your task; do not start work whose Critical prerequisite is unresolved.
3. Read the [multi-agent development plan](../15-platform-spec/13-implementation-blueprints/11-multi-agent-development-work-plan.md), canonical [consistency decisions](../15-platform-spec/13-implementation-blueprints/10-consistency-resolution-decisions.md), [application inventory](../15-platform-spec/12-application-experience/00-application-suite-and-screen-inventory.md), and [UI/UX system](../15-platform-spec/12-application-experience/24-ui-ux-design-system-and-interaction-standards.md).
4. Read [PROJECT-STATUS](PROJECT-STATUS.md) and claim work on [TASK-BOARD](TASK-BOARD.md).
5. Publish progress in your [agent status report](AGENT-STATUS/).
6. Register shared API, database, event, UI and provider changes in [CONTRACTS](CONTRACTS/).
7. Record architectural decisions in [DECISIONS](DECISIONS/); blockers in [BLOCKERS](BLOCKERS/); handoffs in [HANDOFFS](HANDOFFS/).
8. Add tests to [TESTING](TESTING/) with every change. A8 owns cross-system regression and release evidence.

## A0 coordination baseline
- [Master implementation roadmap](MASTER-IMPLEMENTATION-ROADMAP.md)
- [Agent dependency matrix](AGENT-DEPENDENCY-MATRIX.md)
- [Sprint and milestone plan](SPRINT-MILESTONE-PLAN.md)
- [Shared API and data contract](CONTRACTS/SHARED-API-DATA-CONTRACT.md)
- [Integration readiness checklist](INTEGRATION-READINESS-CHECKLIST.md)
- [ADR-0001 platform boundaries](DECISIONS/ADR-0001-platform-boundaries-and-stack.md)
- [ADR-0002 identity and authorization](DECISIONS/ADR-0002-identity-authorization-policy.md)
- [ADR-0003 migration authority](DECISIONS/ADR-0003-database-migration-authority.md)
- [ADR-0004 web frontend workspace and sequencing](DECISIONS/ADR-0004-web-frontend-workspace-and-sequencing.md)
- [A0 handoff](HANDOFFS/A0-BASELINE-HANDOFF.md)

## Agent ownership
- A0 architecture, backlog, integration and release coordination.
- A1 public website, landing pages, staff portal and platform admin UI.
- A2 technician and customer Android apps.
- A3 FastAPI backend, business workflows, API and authorization.
- A4 PostgreSQL model, migrations and data dictionary.
- A5 WhatsApp provider adapter. Initial candidate: OpenWA, subject to feasibility/security/operational validation; keep provider replaceable.
- A6 notification orchestration, preferences, queue, in-app/push/email/SMS and channel contracts.
- A7 inverter/device adapters, telemetry, plant health and monitoring alerts.
- A8 quality engineering, security, privacy, compliance and release testing.
- A9 infrastructure, CI/CD, deployment, backups and observability.

## Collaboration rules
- Do not work outside your assigned ownership without a recorded handoff.
- Use task IDs in branches, PRs, commits and status reports.
- No direct client-to-database access; backend authorization is authoritative.
- No unreviewed schema/API/event breaking changes.
- No production credentials, secrets, customer data or fake business seed data in source control.
- Mark unverified provider, legal, regulatory and business assumptions VERIFY/PROPOSED.
- “Implementation complete” is not “integrated” or “release ready”.

## Status vocabulary
BACKLOG → READY → IN PROGRESS → IN REVIEW → INTEGRATING → DONE. Use BLOCKED, CHANGES REQUESTED or DEFERRED when appropriate. Only A0/release delegate marks cross-agent milestones DONE after evidence.

## Read-before-code gate
Every agent must record the documents reviewed for each task in its status report or PR. Read the relevant screen/workflow, ERD, data dictionary, API contract and security requirements before changing that feature. If documents conflict or omit a required rule, stop and raise it with A0; do not guess. A0 confirms the reading route and acceptance criteria before moving a task to implementation.

## Issue-register gate
The [Documentation Issue Register](../15-platform-spec/13-implementation-blueprints/DOCUMENTATION-ISSUE-REGISTER.md) is the shared remediation tracker. Every task/PR must identify relevant DOC issue IDs, state whether its prerequisites are resolved or formally blocked, and link correction evidence. Critical issues block affected implementation. A0 coordinates cross-document edits; business/legal/engineering/provider decisions require the relevant owner or qualified reviewer.
