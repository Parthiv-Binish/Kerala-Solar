# GreenGrid Solar Platform — Documentation Package

Version 1.0-draft | Prepared 22 November 2026 | Client: GreenGrid Solar Solutions, Erattupetta, Kottayam, Kerala.

This package supplements the existing product and website documentation. It defines the proposed internal operations platform, customer app, technician app, group-based access, utility tracking, IoT monitoring and service workflows.

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
- 06-security-and-access: authorization, privacy and security
  - [Platform Security — Authentication, Authorization, Privacy & Compliance](../06-security-and-access/platform-security-authentication-authorization-privacy-and-compliance.md)
- 07-iot-monitoring: device integrations, telemetry and alerts
- 08-integrations: notifications and external systems
- 09-mobile-apps: customer and technician applications
- 10-delivery: roadmap, effort and cost assumptions
- 11-governance: discovery questions, acceptance and verification

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
