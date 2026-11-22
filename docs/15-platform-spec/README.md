# GreenGrid Solar Platform — Documentation Package

[← Back to the Project Book & Master Index](../../INDEX.md)

Version 1.0-draft | Prepared 22 November 2026 | Client: GreenGrid Solar Solutions, Erattupetta, Kottayam, Kerala.

This package supplements the business study and visual showcase. It defines the proposed internal operations platform, customer app, technician app, group-based access, utility tracking, IoT monitoring and service workflows.

For the complete repository reading order and chapter descriptions, use the [Project Book & Master Index](../../INDEX.md).

## Application experience

The application suite blueprint defines the proposed products and overall screen inventory. Detailed screen specifications are added chapter by chapter.

- [Staff Portal — Navigation, Workspace Shell & Dashboard](12-application-experience/01-staff-portal-navigation-and-dashboard.md)
- [Staff Portal — Enquiries, Follow-ups & Customer Management](12-application-experience/02-staff-portal-enquiries-and-customers.md)
- [Staff Portal — Survey Scheduling, Site Assessment & Survey Review](12-application-experience/03-staff-portal-survey-management.md)
- [Staff Portal — Solar Design, Bill of Materials & Quotation Management](12-application-experience/04-staff-portal-design-and-quotations.md)

- [Application Suite, Screen Inventory & User Experience Blueprint](12-application-experience/00-application-suite-and-screen-inventory.md) — defines the proposed applications, users, navigation, screens, workflows, data movement and usability principles.
- [UI/UX Design System & Interaction Standards](12-application-experience/24-ui-ux-design-system-and-interaction-standards.md) — shared visual tokens, typography, layout, navigation, controls, dialogs, notifications, accessibility and responsive behaviour.

## Folder map
- 01-strategy: charter and business requirements
- 02-workflows: enquiry conversion, project, utility, installation and service
- 03-requirements: software requirements specification
- 04-architecture: system architecture and technology decisions
- 05-data-and-api: logical data model and API outline
  - [Stage 1 — Database Scope and Entity Inventory](05-data-and-api/stage-1-database-scope-and-entity-inventory.md)
  - [Stage 2 — Master Data & Geography ER Design](05-data-and-api/stage-2-master-data-and-geography-er-design.md)
  - [Stage 2 — Organization, Employees & Access Control ER Design](05-data-and-api/stage-2-organization-employees-and-access-control-er-design.md)
  - [Stage 2 — Customers, Contacts, Addresses & CRM ER Design](05-data-and-api/stage-2-customers-contacts-addresses-and-crm-er-design.md)
  - [Stage 2 — Survey, Solar Design & Quotations ER Design](05-data-and-api/stage-2-survey-design-and-quotations-er-design.md)
  - [Stage 2 — Project Management, Tasks, Milestones & Scheduling ER Design](05-data-and-api/stage-2-project-management-tasks-milestones-and-scheduling-er-design.md)
  - [Stage 2 — Government Applications, Subsidies & External Portal Tracking ER Design](05-data-and-api/stage-2-government-applications-subsidies-and-external-tracking-er-design.md)
  - [Stage 2 — Procurement, Suppliers, Purchase Orders & Inventory ER Design](05-data-and-api/stage-2-procurement-suppliers-purchase-orders-and-inventory-er-design.md)
  - [Stage 2 — Installation, Commissioning, Quality & Handover ER Design](05-data-and-api/stage-2-installation-commissioning-quality-and-handover-er-design.md)
  - [Stage 2 — Finance, Payments, Receipts, Expenses & Profitability ER Design](05-data-and-api/stage-2-finance-payments-receipts-expenses-and-profitability-er-design.md)
  - [Stage 2 — Asset Registry, Equipment Lifecycle & Warranty ER Design](05-data-and-api/stage-2-asset-registry-equipment-lifecycle-and-warranty-er-design.md)
  - [Stage 2 — Solar Monitoring, IoT, Telemetry, Analytics & Alerts ER Design](05-data-and-api/stage-2-solar-monitoring-iot-telemetry-analytics-and-alerts-er-design.md)
  - [Stage 2 — Service Management, Work Orders, Field Visits & Maintenance ER Design](05-data-and-api/stage-2-service-management-work-orders-field-visits-and-maintenance-er-design.md)
  - [Stage 2 — Notifications, Communication, WhatsApp, Email, SMS & Push ER Design](05-data-and-api/stage-2-notifications-communication-whatsapp-email-sms-and-push-er-design.md)
  - [Stage 2 — Documents, File Storage, Digital Signatures, Audit Logs & Data Governance ER Design](05-data-and-api/stage-2-documents-file-storage-signatures-audit-and-data-governance-er-design.md)
  - [Stage 2 — Platform Settings, Integrations, Background Jobs, Error Logging & Administration ER Design](05-data-and-api/stage-2-platform-settings-integrations-background-jobs-error-logging-and-administration-er-design.md)
  - [Stage 3 — PostgreSQL Implementation Blueprint & Migration Plan](05-data-and-api/stage-3-postgresql-implementation-blueprint-and-migration-plan.md)
  - [Stage 3 — Canonical Data Dictionary & Migration Backlog](05-data-and-api/stage-3-canonical-data-dictionary-and-migration-backlog.md)
  - [PostgreSQL Bootstrap SQL Migrations](../../database/migrations/README.md)
- 06-security-and-access: authorization, privacy and security
  - [Platform Security — Authentication, Authorization, Privacy & Compliance](06-security-and-access/platform-security-authentication-authorization-privacy-and-compliance.md)
- 07-iot-monitoring: device integrations, telemetry and alerts
- 08-integrations: notifications and external systems
- 09-mobile-apps: customer and technician applications
- 10-delivery: roadmap, effort and cost assumptions
- 11-governance: discovery questions, acceptance and verification
- 12-application-experience: product suite, navigation, screen inventory and user experience
  - [Complete Application Documentation Programme](12-application-experience/MASTER-APPLICATION-DOCUMENTATION-PROGRAMME.md)
  - [Application suite and screen inventory](12-application-experience/00-application-suite-and-screen-inventory.md)
  - [Staff Portal — Navigation and Dashboard](12-application-experience/01-staff-portal-navigation-and-dashboard.md)
  - [Staff Portal — Enquiries and Customers](12-application-experience/02-staff-portal-enquiries-and-customers.md)
  - [Staff Portal — Survey Management](12-application-experience/03-staff-portal-survey-management.md)
  - [Staff Portal — Design and Quotations](12-application-experience/04-staff-portal-design-and-quotations.md)
  - [Staff Portal — Projects, Milestones and Scheduling](12-application-experience/05-staff-portal-project-workspace-and-scheduling.md)
  - [Staff Portal — Utility and Subsidy Tracking](12-application-experience/06-staff-portal-utility-and-subsidy-tracking.md)
  - [Staff Portal — Procurement and Inventory](12-application-experience/07-staff-portal-procurement-and-inventory.md)
  - [Staff Portal — Finance and Project Profitability](12-application-experience/08-staff-portal-finance-and-project-profitability.md)
  - [Staff Portal — Installation, Commissioning and Handover](12-application-experience/09-staff-portal-installation-commissioning-handover.md)
  - [Staff Portal — Plant, Assets and Warranty](12-application-experience/10-staff-portal-plant-assets-and-warranty.md)
  - [Staff Portal — Monitoring and Alerts](12-application-experience/11-staff-portal-monitoring-and-alerts.md)
  - [Staff Portal — Service Desk and Work Orders](12-application-experience/12-staff-portal-service-desk-and-work-orders.md)
  - [Staff Portal — Documents and Analytics](12-application-experience/13-staff-portal-documents-and-analytics.md)
  - [Staff Portal — People, Access and Settings](12-application-experience/14-staff-portal-people-access-and-settings.md)
  - [Technician Android App](12-application-experience/15-technician-android-app.md)
  - [Customer Android App](12-application-experience/16-customer-android-app.md)
  - [Customer Web Portal](12-application-experience/17-customer-web-portal.md)
  - [Solar Monitoring Engine](12-application-experience/18-solar-monitoring-engine.md)
  - [Notification and Communication Engine](12-application-experience/19-notification-and-communication-engine.md)
  - [Platform Administration](12-application-experience/20-platform-administration.md)
  - [Cross-Application Workflows](12-application-experience/21-cross-application-workflows.md)
  - [Screen-to-Data and API Catalogue](12-application-experience/22-screen-data-api-catalogue.md)
  - [Quality, Security and Operations](12-application-experience/23-quality-security-and-operations-runbooks.md)
  - [Complete Application Documentation Programme](12-application-experience/MASTER-APPLICATION-DOCUMENTATION-PROGRAMME.md)
  - [Application Suite and Screen Inventory](12-application-experience/00-application-suite-and-screen-inventory.md)
  - [Staff Portal — Navigation and Dashboard](12-application-experience/01-staff-portal-navigation-and-dashboard.md)
  - [Staff Portal — Enquiries and Customers](12-application-experience/02-staff-portal-enquiries-and-customers.md)
  - [Staff Portal — Survey Management](12-application-experience/03-staff-portal-survey-management.md)
  - [Staff Portal — Design and Quotations](12-application-experience/04-staff-portal-design-and-quotations.md)
  - [Staff Portal — Navigation and Dashboard](12-application-experience/01-staff-portal-navigation-and-dashboard.md)
  - [Staff Portal — Enquiries and Customers](12-application-experience/02-staff-portal-enquiries-and-customers.md)

## Status vocabulary
Confirmed from supplied brief = explicitly supplied information. Proposed = recommended design. VERIFY = client, authority, manufacturer or professional confirmation required. Deferred = not part of initial release, not permanently excluded.

## Principles
1. Enquiry, customer, project, plant, device and case are separate entities.
2. One customer may have multiple sites and projects.
3. Government portals remain authoritative; mirror status unless an authorised API is confirmed.
4. Group grants combine, explicit deny overrides, and resource scope is enforced server-side.
5. Device alerts and service cases are distinct.
6. Every pending milestone has an owner, reason, evidence and next action.
7. Do not commit credentials or customer personal data to this repository.

This is a planning specification, not legal, tax, electrical engineering or API-access approval. Reverify regulatory and provider claims before implementation.

## 13. Implementation blueprints and documentation governance

- [Implementation blueprints book index](13-implementation-blueprints/README.md)
- [Full Documentation Consistency Review](13-implementation-blueprints/09-full-documentation-consistency-review.md)
- [Consistency Resolution Decisions](13-implementation-blueprints/10-consistency-resolution-decisions.md)
- [Master Documentation Register](13-implementation-blueprints/DOCUMENTATION-REGISTER.md)
- [Screen & Experience Implementation Specification](13-implementation-blueprints/01-screen-and-experience-implementation-specification.md)
- [API & Backend Contracts](13-implementation-blueprints/02-api-and-backend-contracts.md)
- [Database Completion & Data Governance](13-implementation-blueprints/03-database-completion-and-data-governance.md)
- [External Integration Contracts](13-implementation-blueprints/04-external-integration-contracts.md)
- [Security, Privacy & Compliance Implementation](13-implementation-blueprints/05-security-privacy-and-compliance-implementation.md)
- [Application Engineering & Deployment](13-implementation-blueprints/06-application-engineering-and-deployment.md)
- [Testing, Traceability & Acceptance](13-implementation-blueprints/07-testing-traceability-and-acceptance.md)
- [Business User Manuals & SOPs](13-implementation-blueprints/08-business-user-manuals-and-operating-procedures.md)
