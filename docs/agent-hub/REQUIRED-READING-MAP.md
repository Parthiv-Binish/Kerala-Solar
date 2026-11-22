# Required Document Navigation — Agents A0–A9

**Purpose:** Give every agent a precise reading route through the project documentation before it plans or changes code. This map is mandatory. Do not assume an agent has inherited context from another agent's chat.

## 1. Mandatory reading for every agent

Read these in order before starting any task:

1. [Project overview and complete business study](../../casestudy/greengrid-solar-platform-study.md) — business context, goals and proposed capabilities.
2. [Business workflows](../../casestudy/01-business-workflows.md) — real-world operational lifecycle and hand-offs.
3. [Project charter and scope](../15-platform-spec/01-strategy/01-project-charter-and-scope.md) — goals, boundaries and non-goals.
4. [Business requirements](../15-platform-spec/01-strategy/02-business-requirements.md) — business outcomes.
5. [Enquiry-to-customer workflow](../15-platform-spec/02-workflows/01-enquiry-to-customer.md).
6. [Project, utility, installation and service workflow](../15-platform-spec/02-workflows/02-project-utility-installation-service.md).
7. [Software Requirements Specification](../15-platform-spec/03-requirements/01-software-requirements-specification.md) — functional and non-functional requirements.
8. [System architecture and technology stack](../15-platform-spec/04-architecture/01-system-architecture-and-stack.md).
9. [Canonical consistency decisions](../15-platform-spec/13-implementation-blueprints/10-consistency-resolution-decisions.md) — resolves conflicting terminology and proposed canonical rules.
10. [Multi-agent development plan](../15-platform-spec/13-implementation-blueprints/11-multi-agent-development-work-plan.md) — ownership, interfaces, test and handoff rules.
11. [Application suite and screen inventory](../15-platform-spec/12-application-experience/00-application-suite-and-screen-inventory.md).
12. [UI/UX design system](../15-platform-spec/12-application-experience/24-ui-ux-design-system-and-interaction-standards.md).
13. [Discovery, acceptance and verification register](../15-platform-spec/11-governance/01-discovery-acceptance-and-verification.md) — unresolved facts and decisions; never treat VERIFY items as established facts.

Then read the [Agent Hub README](README.md), [Project Status](PROJECT-STATUS.md), [Task Board](TASK-BOARD.md), your own status file under [AGENT-STATUS](AGENT-STATUS/), and the relevant [contract registers](CONTRACTS/).

## 2. Agent-specific reading routes

### A0 — Project Architect & Integration Lead
- Mandatory reading above, especially charter, SRS, architecture, canonical decisions, agent plan and discovery register.
- [Full application suite and cross-application workflows](../15-platform-spec/12-application-experience/00-application-suite-and-screen-inventory.md)
- [Cross-application workflows](../15-platform-spec/12-application-experience/21-cross-application-workflows.md)
- [Screen-to-data and API catalogue](../15-platform-spec/12-application-experience/22-screen-data-api-catalogue.md)
- [Full documentation consistency review](../15-platform-spec/13-implementation-blueprints/09-full-documentation-consistency-review.md)
- [Implementation blueprint index](../15-platform-spec/13-implementation-blueprints/README.md)
- Keep the master [Project Book index](../../INDEX.md) as the entry point for newly added chapters.

### A1 — Public Website & Web Frontend
- [Application suite and screen inventory](../15-platform-spec/12-application-experience/00-application-suite-and-screen-inventory.md)
- [UI/UX design system — includes public landing page, enquiry journey, authentication and all products](../15-platform-spec/12-application-experience/24-ui-ux-design-system-and-interaction-standards.md)
- [Staff portal navigation and dashboard](../15-platform-spec/12-application-experience/01-staff-portal-navigation-and-dashboard.md)
- Staff screens: [enquiries/customers](../15-platform-spec/12-application-experience/02-staff-portal-enquiries-and-customers.md), [surveys](../15-platform-spec/12-application-experience/03-staff-portal-survey-management.md), [design/quotations](../15-platform-spec/12-application-experience/04-staff-portal-design-and-quotations.md), [projects/scheduling](../15-platform-spec/12-application-experience/05-staff-portal-project-workspace-and-scheduling.md), [utility/subsidy](../15-platform-spec/12-application-experience/06-staff-portal-utility-and-subsidy-tracking.md), [procurement/inventory](../15-platform-spec/12-application-experience/07-staff-portal-procurement-and-inventory.md), [finance](../15-platform-spec/12-application-experience/08-staff-portal-finance-and-project-profitability.md), [installation/handover](../15-platform-spec/12-application-experience/09-staff-portal-installation-commissioning-handover.md), [assets/warranty](../15-platform-spec/12-application-experience/10-staff-portal-plant-assets-and-warranty.md), [monitoring/alerts](../15-platform-spec/12-application-experience/11-staff-portal-monitoring-and-alerts.md), [service desk](../15-platform-spec/12-application-experience/12-staff-portal-service-desk-and-work-orders.md), [documents/analytics](../15-platform-spec/12-application-experience/13-staff-portal-documents-and-analytics.md), [people/access/settings](../15-platform-spec/12-application-experience/14-staff-portal-people-access-and-settings.md).
- [Platform administration](../15-platform-spec/12-application-experience/20-platform-administration.md), [customer web portal](../15-platform-spec/12-application-experience/17-customer-web-portal.md), [screen/API catalogue](../15-platform-spec/12-application-experience/22-screen-data-api-catalogue.md).
- [Security and authorization](../15-platform-spec/06-security-and-access/platform-security-authentication-authorization-privacy-and-compliance.md).

### A2 — Android Applications Frontend
- [Technician Android app](../15-platform-spec/12-application-experience/15-technician-android-app.md)
- [Customer Android app](../15-platform-spec/12-application-experience/16-customer-android-app.md)
- [Cross-application workflows](../15-platform-spec/12-application-experience/21-cross-application-workflows.md)
- [UI/UX design system — mobile navigation, forms, states and accessibility](../15-platform-spec/12-application-experience/24-ui-ux-design-system-and-interaction-standards.md)
- [Screen-to-data and API catalogue](../15-platform-spec/12-application-experience/22-screen-data-api-catalogue.md)
- [Mobile app overview](../15-platform-spec/09-mobile-apps/01-customer-and-technician-apps.md)
- [Security and authorization](../15-platform-spec/06-security-and-access/platform-security-authentication-authorization-privacy-and-compliance.md).

### A3 — Backend & Business Logic
- [SRS](../15-platform-spec/03-requirements/01-software-requirements-specification.md), [architecture](../15-platform-spec/04-architecture/01-system-architecture-and-stack.md), [logical data model and API](../15-platform-spec/05-data-and-api/01-logical-data-model-and-api.md).
- [Canonical data dictionary and migration backlog](../15-platform-spec/05-data-and-api/stage-3-canonical-data-dictionary-and-migration-backlog.md)
- [Security, authentication, authorization, privacy and compliance](../15-platform-spec/06-security-and-access/platform-security-authentication-authorization-privacy-and-compliance.md)
- [Enquiry-to-customer workflow](../15-platform-spec/02-workflows/01-enquiry-to-customer.md), [project/utility/installation/service workflow](../15-platform-spec/02-workflows/02-project-utility-installation-service.md).
- [Screen-to-data and API catalogue](../15-platform-spec/12-application-experience/22-screen-data-api-catalogue.md), [cross-app workflows](../15-platform-spec/12-application-experience/21-cross-application-workflows.md).
- All Stage 2 ERDs are linked in the [platform documentation index](../15-platform-spec/README.md); read the ERD for each domain before implementing its API.
- [Backend/API implementation blueprint](../15-platform-spec/13-implementation-blueprints/02-api-and-backend-contracts.md).

### A4 — Database & Data Engineering
- [Stage 1 database scope and entity inventory](../15-platform-spec/05-data-and-api/stage-1-database-scope-and-entity-inventory.md)
- [Stage 3 PostgreSQL implementation blueprint and migration plan](../15-platform-spec/05-data-and-api/stage-3-postgresql-implementation-blueprint-and-migration-plan.md)
- [Stage 3 canonical data dictionary and migration backlog](../15-platform-spec/05-data-and-api/stage-3-canonical-data-dictionary-and-migration-backlog.md)
- [Existing SQL bootstrap migrations and instructions](../../database/migrations/README.md)
- Read relevant Stage 2 ERD before each domain migration; use the [platform documentation index](../15-platform-spec/README.md) for the complete list.
- [Security/data governance](../15-platform-spec/06-security-and-access/platform-security-authentication-authorization-privacy-and-compliance.md).
- Coordinate migration-runner/baseline decisions with A3 and A0; never introduce a second migration authority.

### A5 — WhatsApp Integration (OpenWA candidate)
- [Notifications and external systems integration overview](../15-platform-spec/08-integrations/01-notifications-and-external-systems.md)
- [Notifications, communication, WhatsApp, email, SMS and push ERD](../15-platform-spec/05-data-and-api/stage-2-notifications-communication-whatsapp-email-sms-and-push-er-design.md)
- [Notification and communication engine](../15-platform-spec/12-application-experience/19-notification-and-communication-engine.md)
- [Platform administration and integrations ERD](../15-platform-spec/05-data-and-api/stage-2-platform-settings-integrations-background-jobs-error-logging-and-administration-er-design.md)
- [Security/privacy and compliance](../15-platform-spec/06-security-and-access/platform-security-authentication-authorization-privacy-and-compliance.md)
- [External integration contracts blueprint](../15-platform-spec/13-implementation-blueprints/04-external-integration-contracts.md)
- [Integration contract register](CONTRACTS/INTEGRATION-CONTRACT-REGISTER.md) and [event contract register](CONTRACTS/EVENT-CONTRACT-REGISTER.md).
- OpenWA remains a candidate pending feasibility, terms/policy, session reliability, security and operational verification; do not call it an official Meta API.

### A6 — Notifications & Communications
- [Notification and communication engine](../15-platform-spec/12-application-experience/19-notification-and-communication-engine.md)
- [Notifications/communications ERD](../15-platform-spec/05-data-and-api/stage-2-notifications-communication-whatsapp-email-sms-and-push-er-design.md)
- [Notifications and external systems overview](../15-platform-spec/08-integrations/01-notifications-and-external-systems.md)
- [Cross-application workflows](../15-platform-spec/12-application-experience/21-cross-application-workflows.md)
- [Screen/API catalogue](../15-platform-spec/12-application-experience/22-screen-data-api-catalogue.md)
- [Security/privacy and compliance](../15-platform-spec/06-security-and-access/platform-security-authentication-authorization-privacy-and-compliance.md)
- Coordinate A3 business events and recipient eligibility; A5 WhatsApp adapter; A2 push token lifecycle.

### A7 — Solar Monitoring & IoT
- [Device monitoring study](../../casestudy/03-device-monitoring.md)
- [Device integrations and telemetry overview](../15-platform-spec/07-iot-monitoring/01-device-integrations-and-telemetry.md)
- [Solar monitoring engine](../15-platform-spec/12-application-experience/18-solar-monitoring-engine.md)
- [Monitoring and telemetry ERD](../15-platform-spec/05-data-and-api/stage-2-solar-monitoring-iot-telemetry-analytics-and-alerts-er-design.md)
- [Asset/equipment lifecycle and warranty ERD](../15-platform-spec/05-data-and-api/stage-2-asset-registry-equipment-lifecycle-and-warranty-er-design.md)
- [Staff monitoring and alerts screens](../15-platform-spec/12-application-experience/11-staff-portal-monitoring-and-alerts.md)
- [Service management ERD](../15-platform-spec/05-data-and-api/stage-2-service-management-work-orders-field-visits-and-maintenance-er-design.md)
- [External integration contracts blueprint](../15-platform-spec/13-implementation-blueprints/04-external-integration-contracts.md).

### A8 — QA, Security & Compliance
- [SRS](../15-platform-spec/03-requirements/01-software-requirements-specification.md), [security/privacy/compliance](../15-platform-spec/06-security-and-access/platform-security-authentication-authorization-privacy-and-compliance.md), [discovery/acceptance/verification register](../15-platform-spec/11-governance/01-discovery-acceptance-and-verification.md).
- [Full documentation consistency review](../15-platform-spec/13-implementation-blueprints/09-full-documentation-consistency-review.md) and [canonical resolution decisions](../15-platform-spec/13-implementation-blueprints/10-consistency-resolution-decisions.md).
- [Quality, security and operations runbooks](../15-platform-spec/12-application-experience/23-quality-security-and-operations-runbooks.md)
- [Testing, traceability and acceptance blueprint](../15-platform-spec/13-implementation-blueprints/07-testing-traceability-and-acceptance.md)
- [Mandatory test cases in agent plan §14](../15-platform-spec/13-implementation-blueprints/11-multi-agent-development-work-plan.md)
- Read each feature's screen, API and ERD documents before writing acceptance/regression tests.

### A9 — DevOps, Infrastructure & Reliability
- [System architecture and stack](../15-platform-spec/04-architecture/01-system-architecture-and-stack.md)
- [Application engineering and deployment blueprint](../15-platform-spec/13-implementation-blueprints/06-application-engineering-and-deployment.md)
- [PostgreSQL implementation/migration plan](../15-platform-spec/05-data-and-api/stage-3-postgresql-implementation-blueprint-and-migration-plan.md)
- [Security and privacy implementation](../15-platform-spec/13-implementation-blueprints/05-security-privacy-and-compliance-implementation.md)
- [Platform administration ERD](../15-platform-spec/05-data-and-api/stage-2-platform-settings-integrations-background-jobs-error-logging-and-administration-er-design.md)
- [Quality/security/operations runbooks](../15-platform-spec/12-application-experience/23-quality-security-and-operations-runbooks.md)
- [Discovery/acceptance/verification register](../15-platform-spec/11-governance/01-discovery-acceptance-and-verification.md).

## 3. Read-before-code rule

For every task, the assigned agent must:
1. Read the mandatory documents and its role-specific route above.
2. Read the exact feature screen specification, relevant workflow, ERD/data dictionary, API catalogue and security rule before implementing that feature.
3. Check this hub's current task board, status, contracts, decisions and blockers.
4. Record the documents reviewed in its task status or PR description.
5. Raise any conflict, missing requirement or ambiguous business rule with A0 before coding. Do not invent a resolution.
6. Add or update tests and traceability links with the implementation.

A0 verifies reading-route compliance at task kickoff. A task is not READY for implementation until its relevant documents and acceptance criteria are identified. New documents added to the project book must be linked into the relevant route; the [master index](../../INDEX.md) is the canonical navigation index.
