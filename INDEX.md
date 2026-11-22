# GreenGrid Solar — Project Book & Master Index

> **A guided index to the GreenGrid Solar study, business workflows, software specification and implementation blueprint.**
>
> Repository: [Parthiv-Binish/Kerala-Solar](https://github.com/Parthiv-Binish/Kerala-Solar)  
> Documentation status: Working draft for stakeholder validation  
> Last organised: 22 November 2026

---

## Start here

If this is your first time opening the repository, follow this order:

1. **[Project overview and business study](casestudy/greengrid-solar-platform-study.md)** — understand the problem, the proposed platform and the overall direction.
2. **[Business workflows](casestudy/01-business-workflows.md)** — understand how work moves through the solar agency.
3. **[Platform showcase](showcase/index.html)** — see the proposed experience and how the web workspace, customer app and technician app fit together.
4. **[Project charter and scope](docs/15-platform-spec/01-strategy/01-project-charter-and-scope.md)** — understand what the project intends to deliver.
5. **[Software requirements specification](docs/15-platform-spec/03-requirements/01-software-requirements-specification.md)** — review what the software must do.
6. **[System architecture](docs/15-platform-spec/04-architecture/01-system-architecture-and-stack.md)** — understand how the solution is expected to be built.
7. **[Discovery and verification register](docs/15-platform-spec/11-governance/01-discovery-acceptance-and-verification.md)** — identify what still needs confirmation before implementation or release.

---

# Table of contents

## Part I — The business study

*Understand the organisation, the current business process, the operational challenges and the opportunity for a connected solar platform.*

| Chapter | Document | What you will find |
|---|---|---|
| I.1 | [Complete GreenGrid Solar platform study](casestudy/greengrid-solar-platform-study.md) | Consolidated study, proposed capabilities, business context and platform direction |
| I.2 | [Business workflows](casestudy/01-business-workflows.md) | Enquiry handling, people involved, hand-offs and the solar project lifecycle |
| I.3 | [Regulatory and compliance study](casestudy/02-regulatory-and-compliance.md) | Relevant policy, regulatory and compliance considerations to verify |
| I.4 | [Device monitoring study](casestudy/03-device-monitoring.md) | Inverter/device monitoring, data sources, telemetry and integration considerations |
| I.5 | [Platform architecture study](casestudy/04-platform-architecture.md) | Proposed system components, application structure and technology direction |
| I.6 | [Roadmap, costs and open questions](casestudy/05-roadmap-costs-and-open-questions.md) | Delivery phases, estimates, dependencies and unresolved decisions |

## Part II — The product and software specification

*Define what the platform should do before implementation begins.*

### Book 1 — Strategy and scope

| Chapter | Document | What you will find |
|---|---|---|
| II.1 | [Project charter and scope](docs/15-platform-spec/01-strategy/01-project-charter-and-scope.md) | Goals, boundaries, stakeholders and project outcomes |
| II.2 | [Business requirements](docs/15-platform-spec/01-strategy/02-business-requirements.md) | Business needs and expected operational improvements |

### Book 2 — How the work flows

| Chapter | Document | What you will find |
|---|---|---|
| II.3 | [Enquiry to customer workflow](docs/15-platform-spec/02-workflows/01-enquiry-to-customer.md) | Enquiry capture, assignment, follow-up and conversion |
| II.4 | [Project, utility, installation and service workflow](docs/15-platform-spec/02-workflows/02-project-utility-installation-service.md) | Project execution, external application tracking, installation, handover and service |

### Book 3 — Software requirements

| Chapter | Document | What you will find |
|---|---|---|
| II.5 | [Software requirements specification (SRS)](docs/15-platform-spec/03-requirements/01-software-requirements-specification.md) | Functional requirements, system behaviour, application roles and quality expectations |

### Book 4 — Technical architecture

| Chapter | Document | What you will find |
|---|---|---|
| II.6 | [System architecture and technology stack](docs/15-platform-spec/04-architecture/01-system-architecture-and-stack.md) | Web, mobile, backend, database, background jobs, hosting and deployment design |

### Book 5 — Data, database and APIs

*The data design is split into stages so that each business area can be reviewed independently.*

| Chapter | Document | What you will find |
|---|---|---|
| II.7 | [Stage 1 — Database scope and entity inventory](docs/15-platform-spec/05-data-and-api/stage-1-database-scope-and-entity-inventory.md) | Domain boundaries and the inventory of data entities |
| II.8 | [Stage 2 — Master data and geography ER design](docs/15-platform-spec/05-data-and-api/stage-2-master-data-and-geography-er-design.md) | Geography, postal references, address and shared reference data |
| II.9 | [Stage 2 — Organisation, employees and access control ER design](docs/15-platform-spec/05-data-and-api/stage-2-organization-employees-and-access-control-er-design.md) | Company structure, employees, groups, memberships and access grants |
| II.10 | [Stage 2 — Customers, contacts, addresses and CRM ER design](docs/15-platform-spec/05-data-and-api/stage-2-customers-contacts-addresses-and-crm-er-design.md) | Customer records, contacts, sites, addresses and CRM relationships |
| II.11 | [Stage 2 — Survey, design and quotations ER design](docs/15-platform-spec/05-data-and-api/stage-2-survey-design-and-quotations-er-design.md) | Site surveys, technical design and quotation data |
| II.12 | [Stage 2 — Project management ER design](docs/15-platform-spec/05-data-and-api/stage-2-project-management-tasks-milestones-and-scheduling-er-design.md) | Projects, tasks, milestones, assignments and scheduling |
| II.13 | [Stage 2 — Government applications and subsidies ER design](docs/15-platform-spec/05-data-and-api/stage-2-government-applications-subsidies-and-external-tracking-er-design.md) | Application records, subsidy tracking and external portal references |
| II.14 | [Stage 2 — Procurement and inventory ER design](docs/15-platform-spec/05-data-and-api/stage-2-procurement-suppliers-purchase-orders-and-inventory-er-design.md) | Suppliers, purchasing, stock movements and inventory |
| II.15 | [Stage 2 — Installation and handover ER design](docs/15-platform-spec/05-data-and-api/stage-2-installation-commissioning-quality-and-handover-er-design.md) | Installation work, commissioning, quality checks and handover |
| II.16 | [Stage 2 — Finance ER design](docs/15-platform-spec/05-data-and-api/stage-2-finance-payments-receipts-expenses-and-profitability-er-design.md) | Payments, receipts, expenses and project profitability |
| II.17 | [Stage 2 — Asset and warranty ER design](docs/15-platform-spec/05-data-and-api/stage-2-asset-registry-equipment-lifecycle-and-warranty-er-design.md) | Installed assets, equipment lifecycle and warranty records |
| II.18 | [Stage 2 — Solar monitoring and telemetry ER design](docs/15-platform-spec/05-data-and-api/stage-2-solar-monitoring-iot-telemetry-analytics-and-alerts-er-design.md) | Monitoring sources, telemetry, analytics and alerts |
| II.19 | [Stage 2 — Service management ER design](docs/15-platform-spec/05-data-and-api/stage-2-service-management-work-orders-field-visits-and-maintenance-er-design.md) | Service cases, work orders, field visits and maintenance |
| II.20 | [Stage 2 — Notifications and communications ER design](docs/15-platform-spec/05-data-and-api/stage-2-notifications-communication-whatsapp-email-sms-and-push-er-design.md) | Notification events, delivery channels and message records |
| II.21 | [Stage 2 — Documents, signatures and audit ER design](docs/15-platform-spec/05-data-and-api/stage-2-documents-file-storage-signatures-audit-and-data-governance-er-design.md) | File metadata, access, signatures, audit and data governance |
| II.22 | [Stage 2 — Platform administration and integrations ER design](docs/15-platform-spec/05-data-and-api/stage-2-platform-settings-integrations-background-jobs-error-logging-and-administration-er-design.md) | Platform settings, integration configuration, jobs and operational logs |
| II.23 | [Stage 3 — PostgreSQL implementation blueprint](docs/15-platform-spec/05-data-and-api/stage-3-postgresql-implementation-blueprint-and-migration-plan.md) | Schema implementation strategy, dependencies and migration planning |
| II.24 | [Stage 3 — Canonical data dictionary and migration backlog](docs/15-platform-spec/05-data-and-api/stage-3-canonical-data-dictionary-and-migration-backlog.md) | Proposed canonical tables, fields, constraints, indexes and migration backlog |
| II.25 | [PostgreSQL bootstrap migrations](database/migrations/README.md) | Initial SQL schema scripts, execution order and migration safety notes |

### Book 6 — Security, identity and access

| Chapter | Document | What you will find |
|---|---|---|
| II.26 | [Platform security, authentication, authorization, privacy and compliance](docs/15-platform-spec/06-security-and-access/platform-security-authentication-authorization-privacy-and-compliance.md) | Accounts, sessions, MFA, group-based permissions, scope enforcement, privacy, audit and security controls |

### Book 7 — Monitoring and external connections

| Chapter | Document | What you will find |
|---|---|---|
| II.27 | [Device integrations and telemetry](docs/15-platform-spec/07-iot-monitoring/01-device-integrations-and-telemetry.md) | Monitoring architecture, vendor adapters, telemetry and alert handling |
| II.28 | [Notifications and external systems](docs/15-platform-spec/08-integrations/01-notifications-and-external-systems.md) | WhatsApp, email, SMS, push and other external integration boundaries |

### Book 8 — Mobile applications

| Chapter | Document | What you will find |
|---|---|---|
| II.29 | [Customer and technician applications](docs/15-platform-spec/09-mobile-apps/01-customer-and-technician-apps.md) | Customer-facing visibility and technician field workflows |

### Book 9 — Delivery and governance

| Chapter | Document | What you will find |
|---|---|---|
| II.30 | [Roadmap, estimates and costs](docs/15-platform-spec/10-delivery/01-roadmap-estimates-and-costs.md) | Delivery phases, implementation estimates and cost assumptions |
| II.31 | [Discovery, acceptance and verification](docs/15-platform-spec/11-governance/01-discovery-acceptance-and-verification.md) | Questions for stakeholders, acceptance criteria and items requiring evidence |

### Book 10 — Complete application documentation

| II.32 | [Application suite and screen inventory](docs/15-platform-spec/12-application-experience/00-application-suite-and-screen-inventory.md) | Product list, user groups, navigation, screen inventory and UX principles |
| II.33 | [Staff Portal — Navigation and Dashboard](docs/15-platform-spec/12-application-experience/01-staff-portal-navigation-and-dashboard.md) | Shell, search, notifications, dashboard and shared patterns |
| II.34 | [Staff Portal — Enquiries and Customers](docs/15-platform-spec/12-application-experience/02-staff-portal-enquiries-and-customers.md) | CRM capture, follow-ups, customer profiles, sites and conversion |
| II.35 | [Staff Portal — Survey Management](docs/15-platform-spec/12-application-experience/03-staff-portal-survey-management.md) | Appointments, assessment, evidence, review and approval |
| II.36 | [Staff Portal — Design and Quotations](docs/15-platform-spec/12-application-experience/04-staff-portal-design-and-quotations.md) | Design versions, BOM, costing, quotation approval and acceptance |
| II.37 | [Staff Portal — Projects, Milestones and Scheduling](docs/15-platform-spec/12-application-experience/05-staff-portal-project-workspace-and-scheduling.md) | Project conversion, milestones, tasks, dependencies, blockers and changes |
| II.38 | [Staff Portal — Utility and Subsidy Tracking](docs/15-platform-spec/12-application-experience/06-staff-portal-utility-and-subsidy-tracking.md) | DISCOM processes, evidence, status observations and subsidy tracking |
| II.39 | [Staff Portal — Procurement and Inventory](docs/15-platform-spec/12-application-experience/07-staff-portal-procurement-and-inventory.md) | Suppliers, purchase requests, POs, receipts, stock ledger and serials |
| II.40 | [Staff Portal — Finance and Project Profitability](docs/15-platform-spec/12-application-experience/08-staff-portal-finance-and-project-profitability.md) | Receipts, allocations, supplier payments, expenses and project summaries |
| II.41 | [Staff Portal — Installation, Commissioning and Handover](docs/15-platform-spec/12-application-experience/09-staff-portal-installation-commissioning-handover.md) | Readiness, field work, quality checks, commissioning and handover |
| II.42 | [Staff Portal — Plant, Assets and Warranty](docs/15-platform-spec/12-application-experience/10-staff-portal-plant-assets-and-warranty.md) | Plant registry, equipment, serials, warranty and maintenance plans |
| II.43 | [Staff Portal — Monitoring and Alerts](docs/15-platform-spec/12-application-experience/11-staff-portal-monitoring-and-alerts.md) | Fleet health, telemetry freshness, alerts and integration status |
| II.44 | [Staff Portal — Service Desk and Work Orders](docs/15-platform-spec/12-application-experience/12-staff-portal-service-desk-and-work-orders.md) | Customer/staff reports, duplicate prevention, cases, visits and resolution |
| II.45 | [Staff Portal — Documents and Analytics](docs/15-platform-spec/12-application-experience/13-staff-portal-documents-and-analytics.md) | Private documents, versioning, reports, metrics and exports |
| II.46 | [Staff Portal — People, Access and Settings](docs/15-platform-spec/12-application-experience/14-staff-portal-people-access-and-settings.md) | Employees, groups, permissions, overrides, policies and settings |
| II.47 | [Technician Android App](docs/15-platform-spec/12-application-experience/15-technician-android-app.md) | Field navigation, survey, installation, commissioning, service and offline sync |
| II.48 | [Customer Android App](docs/15-platform-spec/12-application-experience/16-customer-android-app.md) | Customer journeys, projects, quotations, plants, payments and service |
| II.49 | [Customer Web Portal](docs/15-platform-spec/12-application-experience/17-customer-web-portal.md) | Responsive customer pages, parity, accessibility and secure sessions |
| II.50 | [Solar Monitoring Engine](docs/15-platform-spec/12-application-experience/18-solar-monitoring-engine.md) | Provider adapters, telemetry, data quality, freshness and alerts |
| II.51 | [Notification and Communication Engine](docs/15-platform-spec/12-application-experience/19-notification-and-communication-engine.md) | Consent, templates, channels, queues, retries and delivery events |
| II.52 | [Platform Administration](docs/15-platform-spec/12-application-experience/20-platform-administration.md) | Identity, privileged access, integrations, jobs, audit and recovery |
| II.53 | [Cross-Application Workflows](docs/15-platform-spec/12-application-experience/21-cross-application-workflows.md) | End-to-end business processes and integration invariants |
| II.54 | [Screen-to-Data and API Catalogue](docs/15-platform-spec/12-application-experience/22-screen-data-api-catalogue.md) | API conventions, data mapping, errors, permissions and traceability |
| II.55 | [Quality, Security and Operations](docs/15-platform-spec/12-application-experience/23-quality-security-and-operations-runbooks.md) | Test strategy, release readiness, backup, incident and operations |

| II.56 | [Complete Application Documentation Programme](docs/15-platform-spec/12-application-experience/MASTER-APPLICATION-DOCUMENTATION-PROGRAMME.md) | Master scope, documentation standards, quality gates and delivery governance |

### Book 11 — Implementation blueprints and pending documentation

| Chapter | Document | What you will find |
|---|---|---|
| II.57 | [Master Documentation Register](docs/15-platform-spec/13-implementation-blueprints/DOCUMENTATION-REGISTER.md) | Existing and pending document register, owners, dependencies, statuses and approval gates |
| II.58 | [Screen & Experience Implementation Specification](docs/15-platform-spec/13-implementation-blueprints/01-screen-and-experience-implementation-specification.md) | Screen/action contracts, fields, validation, navigation, permissions, notifications and UI states |
| II.59 | [API & Backend Contracts](docs/15-platform-spec/13-implementation-blueprints/02-api-and-backend-contracts.md) | Endpoint families, schemas, errors, auth, idempotency, events and OpenAPI governance |
| II.60 | [Database Completion & Data Governance](docs/15-platform-spec/13-implementation-blueprints/03-database-completion-and-data-governance.md) | Schema reconciliation, DDL, migrations, indexes, provenance, backup and retention |
| II.61 | [External Integration Contracts](docs/15-platform-spec/13-implementation-blueprints/04-external-integration-contracts.md) | PIN, DISCOM, inverter, WhatsApp, email/SMS/push and storage verification |
| II.62 | [Security, Privacy & Compliance Implementation](docs/15-platform-spec/13-implementation-blueprints/05-security-privacy-and-compliance-implementation.md) | DPDP controls, notices, requests, retention, threat model, CERT-In verification and security tests |
| II.63 | [Application Engineering & Deployment](docs/15-platform-spec/13-implementation-blueprints/06-application-engineering-and-deployment.md) | Code structure, environments, VPS, Docker, Nginx, CI/CD, observability and recovery |
| II.64 | [Testing, Traceability & Acceptance](docs/15-platform-spec/13-implementation-blueprints/07-testing-traceability-and-acceptance.md) | Requirement traceability, test layers, end-to-end cases, UAT and release gates |
| II.65 | [Business User Manuals & SOPs](docs/15-platform-spec/13-implementation-blueprints/08-business-user-manuals-and-operating-procedures.md) | Staff, technician and customer manuals, onboarding, business SOPs and support |

## Part III — Visual walkthrough

*Use this section when you want to understand the proposed experience without reading the full technical specification.*

| Resource | Purpose |
|---|---|
| [Open the interactive platform showcase](showcase/index.html) | Walk through the proposed platform, its applications, capabilities and end-to-end operating model |
| [Showcase notes](showcase/README.md) | How to view and maintain the showcase |

## Part IV — Implementation assets

| Resource | Purpose |
|---|---|
| [Database migration directory](database/migrations/) | Versioned PostgreSQL bootstrap SQL files |
| [Database migration instructions](database/migrations/README.md) | Prerequisites, execution order and validation guidance |

Implementation source code will be added in its own application folders as development begins. A design or specification document does not mean the corresponding feature has already been implemented.

---

## How to use this book

- **Business stakeholders:** Read Part I, then Part II Books 1–3, and finish with the discovery and acceptance chapter.
- **Developers:** Read the business workflows first, then the SRS, architecture, data dictionary, security and implementation assets.
- **Operations and field teams:** Focus on the workflow chapters, customer/technician apps, monitoring, notifications and service design.
- **Reviewers:** Use the regulatory study and verification register to distinguish established facts from assumptions that still need evidence.

## Reading and status conventions

The documents use these status terms:

- **Confirmed from supplied brief** — explicitly present in the information provided for the study.
- **Proposed** — a recommended design that still needs stakeholder agreement.
- **VERIFY** — requires confirmation from the client, relevant authority, manufacturer, integration provider or qualified professional.
- **Deferred** — intentionally planned for a later phase; not necessarily excluded permanently.

## Important project note

This repository contains a study, a proposed product design and implementation planning material. It must not be read as proof that the production platform, mobile applications, government integrations, WhatsApp delivery or live inverter monitoring are already operational. External access, provider support, regulatory applicability, engineering decisions and stakeholder requirements must be validated before production commitments.

---

**Navigation rule:** This file is the repository's master table of contents. Add new major documents here when they are created, and keep the relevant folder README in sync.
