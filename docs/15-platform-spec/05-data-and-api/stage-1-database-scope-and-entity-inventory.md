# Stage 1 — Database Scope and Entity Inventory

**Project:** GreenGrid Solar Solutions — Solar Agency Management Platform  
**Repository baseline:** `docs/15-platform-spec/`  
**Status:** Stage 1 planning inventory — proposed, pending stakeholder validation  
**Date:** 22 November 2026

## 1. Purpose

This document records the Stage 1 database discovery and logical entity inventory for the GreenGrid Solar platform. It consolidates the SRS v2.0 baseline, the operational workflow requirements discussed so far, and the additional address and contact requirements.

Stage 1 is for identifying data domains, entities, relationships, ownership, and important data rules before preparing the detailed ER diagram and PostgreSQL schema.

## 2. Scope and decisions

- Cover the company operations portal, employee and technician workflows, customer portal and Android app, solar project lifecycle, inventory, finance, monitoring, service, notifications, and administration.
- Support the full lifecycle from enquiry through survey, design, quotation, project confirmation, procurement, installation, commissioning, handover, monitoring, warranty, and service.
- A customer may have multiple addresses, installation sites, projects, and solar systems.
- An enquiry/prospect can exist before a customer account is created.
- Employees can belong to multiple configurable groups. Permissions are separate from group names and are enforced with resource scope.
- Keep customer, enquiry, project, installation site, solar system, equipment, alert, and service case as distinct concepts.
- Do not assume integrations or API access to government portals, inverter manufacturers, WhatsApp, email, or payment providers until verified.
- Do not treat missing monitoring data as zero generation.
- Preserve audit history for sensitive business actions and important status changes.
- No mock data, sample customers, sample employees, sample addresses, sample payments, or operational seed records are to be created as part of Stage 1.
- The entity list is conceptual. It is not a promise that every listed item becomes a separate physical table; related entities may be consolidated or split during detailed modelling.
- No production SQL schema or final ERD is approved by this inventory alone.

## 3. Address, location, and contact data — required

Location and contact information must be modelled explicitly across customers, prospects/enquiries, employees, suppliers, company offices, and installation sites.

### 3.1 Address fields

Capture the following where applicable:

| Field | Purpose / rule |
|---|---|
| address_line_1 | House, building, or premises name and primary address |
| address_line_2 | Street, locality, ward, or additional address detail |
| place | Town, village, or locality |
| post_office | Relevant post office |
| pincode | Indian PIN code; store as `VARCHAR(6)`, not an integer |
| local_body | Panchayat, municipality, or corporation, where applicable |
| district | District |
| state | State |
| country | Country; defaulting rules to be confirmed |
| landmark | Nearby landmark, optional |
| latitude / longitude | Optional coordinates for mapping and technician navigation |
| address_label / address_type | Home, office, billing, site, warehouse, etc. |
| is_primary | Indicates the primary address within its owner context |
| valid_from / valid_to | Optional effective dates for address history |

Keep the human-readable address even when reference/master tables are used. PIN codes and post-office/locality mappings should not be assumed to be one-to-one.

### 3.2 Address ownership and address entities

Use domain-owned address records or explicit relationship tables with real foreign keys. Avoid a generic `owner_type + owner_id` design that cannot enforce referential integrity.

Proposed entities:
- `customer_addresses`
- `enquiry_addresses` or `enquiry_location_details` — preserves prospect/site details before customer conversion
- `employee_addresses`
- `supplier_addresses`
- `company_locations` — head office, branch, warehouse, or other company premises
- `installation_sites` — a distinct site record linked to a customer and later to project/system records
- `countries`, `states`, `districts`, `local_bodies`, `postal_codes` — optional reference data where it provides reliable value

An installation address must not be assumed to be the customer's residential or billing address. A customer may install systems at multiple properties. When an enquiry converts, link the enquiry to the customer while preserving the original enquiry details and history. A copied address may be used as a starting point for a site record, but the site must remain independently editable and historically meaningful.

### 3.3 Phone numbers and email addresses

Support multiple contact methods per person or organisation. Phone numbers must be stored as text, not numeric values, and should include country code in a consistent international format. Email addresses should be normalized for matching while preserving a display form.

Proposed entities:
- `customer_contacts`
- `enquiry_contacts`
- `employee_contacts`
- `supplier_contacts` and, if needed, `supplier_contact_methods`
- `company_location_contacts`

Suggested contact attributes:
- `contact_type` — phone, email, or another approved channel
- `contact_value`
- `country_code` — for phone contacts
- `label` — personal, work, accounts, site contact, etc.
- `is_primary`
- `is_whatsapp` — explicit; do not assume every phone number is WhatsApp-enabled
- `is_verified`, `verified_at`
- `is_active`
- `valid_from`, `valid_to`

Authentication/login identifiers belong to user-account records. Do not duplicate login credentials in employee/customer contact records. Communication consent and channel preferences must be stored separately from the mere existence of a phone number or email address.

### 3.4 Where contact and address data is needed

| Domain | Required information |
|---|---|
| Prospect / enquiry | Prospect name, one or more phone/email contacts, enquiry/property location, preferred contact channel, consent |
| Customer | Multiple contact methods and multiple address types |
| Installation site | Full site address, PIN code, district/state, optional coordinates, site contact |
| Employee | Contact methods and address details; login identity remains separate |
| Supplier | Organisation address and multiple supplier representatives/contact methods |
| Company | Office/branch/warehouse address and office contact methods |

## 4. Proposed logical entity inventory

The following is the Stage 1 working inventory. Names are proposed snake_case identifiers.

### 4.1 Organization and identity
- `employees`
- `employee_groups`
- `permissions`
- `group_permissions`
- `employee_group_memberships`
- `employee_reporting_relationships`
- `employee_permission_overrides`
- `user_accounts`
- `user_sessions`
- `authentication_events`
- `employee_contacts`
- `employee_addresses`

Employees may belong to multiple groups. Group membership does not by itself grant unrestricted access. Permission scope and individual overrides must be auditable. Reporting relationships do not automatically grant company-wide access.

### 4.2 Customer management
- `customers`
- `customer_contacts`
- `customer_addresses`
- `customer_user_accounts`
- `customer_preferences`
- `customer_consents`

A customer can have multiple contact methods, addresses, user accounts where permitted, sites, projects, and systems.

### 4.3 Enquiry and CRM
- `enquiries`
- `enquiry_sources`
- `enquiry_contacts`
- `enquiry_addresses`
- `enquiry_assignments`
- `enquiry_status_history`
- `enquiry_notes`
- `enquiry_followups`
- `enquiry_duplicate_matches`
- `enquiry_merges`
- `enquiry_loss_reasons`
- `enquiry_tracking_tokens`

Enquiries may originate from website, WhatsApp, phone, walk-in, referral, social media, or manual entry. Preserve prospect details and history when converting an enquiry to a customer. Active enquiries need an accountable owner and next action.

### 4.4 Site survey
- `surveys`
- `survey_versions`
- `survey_appointments`
- `survey_checklists`
- `survey_checklist_responses`
- `survey_photos`
- `survey_electrical_details`
- `survey_roof_details`
- `survey_load_details`

Survey data includes roof type, usable area, orientation, shading, structure/access, meter/electrical details, inverter location, cable route, consumption/load, photos, documents, and review history.

### 4.5 Design, products, and quotation
- `solar_designs`
- `design_versions`
- `products`
- `product_categories`
- `product_specifications`
- `bills_of_materials`
- `bom_items`
- `quotations`
- `quotation_versions`
- `quotation_items`
- `quotation_approvals`
- `quotation_customer_responses`

Quotation versions must be retained. Customer acceptance must identify the exact version accepted. Keep subsidy estimates distinct from the agency's quotation and distinguish manufacturer warranties from workmanship warranties.

### 4.6 Project management
- `projects`
- `project_status_history`
- `project_milestones`
- `project_milestone_history`
- `tasks`
- `task_assignments`
- `task_dependencies`
- `task_checklists`
- `task_checklist_responses`
- `task_activity_logs`
- `project_schedules`
- `project_rescheduling_history`

A project should be created only after the required customer confirmation/quotation acceptance. Each task needs one accountable owner, with optional collaborators, due date, priority, status, dependencies, checklist, evidence, and activity history.

### 4.7 Government and external applications
- `external_applications`
- `external_application_milestones`
- `external_application_status_history`
- `external_references`
- `external_approvals`
- `government_scheme_records`

Track who is responsible for each step: customer, GreenGrid, DISCOM, or external portal/authority. Store reference numbers, status evidence, dates, and pending actions. Do not imply direct portal integration unless verified.

### 4.8 Procurement and inventory
- `suppliers`
- `supplier_contacts`
- `supplier_addresses`
- `purchase_requests`
- `purchase_request_items`
- `purchase_approvals`
- `supplier_quotations`
- `purchase_orders`
- `purchase_order_items`
- `goods_receipts`
- `goods_receipt_items`
- `stock_locations`
- `stock_movements`
- `stock_reservations`
- `project_material_allocations`
- `stock_adjustments`
- `stock_adjustment_approvals`

Track available, reserved, allocated, damaged, and returned stock. Serial-numbered equipment should be traceable from receipt through project allocation and installation. Stock changes require reasons and appropriate approval.

### 4.9 Installation and handover
- `installations`
- `installation_assignments`
- `installation_schedules`
- `installation_checklists`
- `installation_checklist_responses`
- `installation_photos`
- `installation_material_usage`
- `commissioning_records`
- `quality_inspections`
- `handover_records`
- `handover_documents`
- `customer_acknowledgements`

Installation records must reference the relevant project and installation site. Preserve completion evidence, commissioning details, quality checks, and customer handover acknowledgement.

### 4.10 Finance
- `project_financial_records`
- `payment_milestones`
- `payments`
- `payment_receipts`
- `payment_adjustments`
- `project_expenses`
- `supplier_payments`

Track expected amounts separately from actual payments received. Support partial, due, paid, and overdue states. Preserve payment records; corrections should use authorized adjustment or reversal records. Do not assume a payment gateway is required.

### 4.11 Solar systems, equipment, and warranties
- `solar_systems`
- `solar_system_components`
- `equipment`
- `equipment_models`
- `equipment_manufacturers`
- `equipment_installation_history`
- `equipment_replacements`
- `equipment_warranties`
- `workmanship_warranties`

A customer may own multiple systems. A system belongs to an installation site and project. Preserve equipment serial numbers, manufacturer/model, installation history, replacements, and warranty coverage.

### 4.12 Monitoring and integrations
- `integration_providers`
- `integration_connections`
- `integration_credentials`
- `integration_devices`
- `monitoring_sites`
- `monitoring_devices`
- `monitoring_sync_runs`
- `monitoring_sync_errors`
- `telemetry_readings`
- `telemetry_aggregates`
- `telemetry_raw_events`
- `monitoring_status_history`
- `monitoring_manual_readings`

Use a vendor-neutral integration adapter and normalized telemetry model. Support manufacturer/cloud APIs, webhooks, local gateway/Modbus, third-party integrations, and manual fallback where feasible. Track provider, plant/site, inverter/logger/gateway, model, serial, sync state, last success/attempt/error, and quotas. Protect credentials; do not store secrets in source control. Preserve source timestamps, units, raw payload references, and aggregation details.

### 4.13 Alerts
- `alert_rules`
- `alert_rule_versions`
- `alerts`
- `alert_events`
- `alert_status_history`
- `alert_acknowledgements`
- `alert_suppressions`
- `alert_case_links`
- `alert_evaluations`

Support device faults, offline/stale data, API errors, low generation, grid events, and maintenance/warranty alerts. Deduplicate recurring alerts and preserve first/last seen, count, and source. Alert recovery is separate from service-case resolution.

### 4.14 Service and work orders
- `service_cases`
- `case_reporters`
- `case_duplicate_reports`
- `case_links`
- `case_status_history`
- `case_assignments`
- `case_notes`
- `case_activity_logs`
- `work_orders`
- `work_order_assignments`
- `service_visits`
- `service_visit_checklists`
- `service_visit_responses`
- `service_visit_materials`
- `service_visit_evidence`
- `service_resolutions`
- `case_customer_acknowledgements`

Cases can be raised by customers or staff and linked to customer, project, system, equipment, and alert. Preserve original reporter and report time. Similar reports should be linked only when confidently identified as the same incident; uncertain matches must not be auto-merged. Reopening requires a reason. A case must not close merely because an alert disappears.

### 4.15 Warranty and preventive maintenance
- `warranty_claims`
- `warranty_claim_history`
- `maintenance_plans`
- `maintenance_plan_items`
- `maintenance_schedules`
- `maintenance_visits`
- `maintenance_visit_reports`

### 4.16 Notifications and communication
- `notification_templates`
- `notification_events`
- `notifications`
- `notification_recipients`
- `notification_attempts`
- `notification_preferences`
- `push_devices`
- `communication_logs`
- `whatsapp_messages`
- `whatsapp_webhook_events`
- `email_messages`

Support in-app, push, WhatsApp, and email channels. Track queued/sent/delivered/failed states, retries, idempotency, opt-outs, recipient preferences, and communication history. Do not send marketing messages without appropriate consent.

### 4.17 Documents, audit, and platform operations
- `documents`
- `document_categories`
- `document_versions`
- `document_access_logs`
- `audit_logs`
- `data_access_logs`
- `system_settings`
- `system_integrations`
- `background_jobs`
- `background_job_attempts`
- `system_error_logs`
- `data_export_logs`

Store files in private object/file storage and keep metadata and access controls in the database. Audit sensitive changes, access to sensitive records, exports, permission changes, and financial/inventory corrections.

## 5. Important relationship rules

1. One customer can have many contacts, addresses, installation sites, projects, and solar systems.
2. One enquiry can have multiple contacts and one or more captured property/site locations; it may later link to a customer.
3. One installation site belongs to a customer and can be referenced by one or more projects/systems as the business rules permit.
4. One project is linked to a customer, accepted quotation/version, and installation site.
5. A project can contain multiple tasks, milestones, procurement allocations, installations, payments, and documents.
6. One solar system can contain multiple equipment components and monitoring devices.
7. One monitoring device can produce many telemetry readings and alert events.
8. An alert may be linked to a service case; multiple alerts may be associated with one case.
9. A service case may have multiple reporters, assignments, work orders, visits, evidence items, and status events.
10. Notifications are linked to triggering events and recipients, with separate delivery attempts.
11. Employee group membership, permissions, and reporting relationships are separate relationships.
12. Contact consent and notification preferences are separate from contact details.

## 6. Data integrity and validation rules

- PIN code: store as `VARCHAR(6)`; validate format and any authoritative mapping in the application layer.
- Phone: store as text with country code; never use an integer type.
- Email: trim and normalize for matching; retain a suitable display value.
- Multiple contacts: allow more than one phone/email and identify a primary contact per owner/context.
- WhatsApp: store explicit WhatsApp capability/consent; do not infer it from a phone number.
- Addresses: distinguish residential, permanent, billing, office, supplier, warehouse, and installation-site addresses.
- Installation site: independent from customer residential address.
- History: retain important changes to addresses, contacts, statuses, quotations, permissions, payments, stock, and equipment.
- Authorization: enforce ownership and scope checks on the server, not only in the UI.
- Monitoring: represent unavailable/stale telemetry distinctly from a numeric zero.
- Transactions: use atomic operations for payment adjustments, case creation, and stock reservation/allocation.
- Files: validate type/size, use private storage, and log access where required.
- Secrets: never commit API keys, passwords, access tokens, customer personal data, or real operational records to GitHub.

## 7. Critical transactional workflows to model

- Enquiry conversion while retaining enquiry history.
- Acceptance of a specific quotation version before project confirmation.
- Payment recording and authorized adjustment/reversal.
- Stock reservation, allocation, receipt, and adjustment.
- Installation-site and equipment traceability.
- Atomic service-case creation and duplicate-report linking.
- Notification queueing with idempotency and retry handling.
- Monitoring synchronization with stale/error states and normalized readings.

## 8. Open questions — do not assume answers

The following require GreenGrid stakeholder confirmation:
- Exact employee count, departments, groups, reporting hierarchy, and approval limits.
- Whether one customer can have multiple legal owners or co-applicants per site.
- Required address types and whether any address proof is collected.
- Preferred phone/email verification method and who may update customer contacts.
- Whether supplier contacts need named people and role/title.
- Exact stock locations, warehouses, and stock valuation method.
- Inverter manufacturers/models and available monitoring APIs/protocols.
- Government/DISCOM portal processes and integration permissions.
- Tax, invoice, accounting, and statutory reporting requirements.
- Data retention, deletion, backup, RPO, and RTO requirements.
- Required customer and employee identity verification methods.

## 9. Stage 1 completion criteria

Stage 1 is ready for detailed ER modelling when:
- Stakeholders validate the entity domains and key business relationships.
- Address, location, contact, and consent requirements are confirmed.
- Employee groups, permission scopes, and approval responsibilities are documented.
- Project, finance, inventory, monitoring, and service lifecycle rules are agreed.
- Open questions are either answered or explicitly marked as deferred.
- The team agrees on identifiers, audit requirements, retention, and sensitive-data handling.

**Next stage:** prepare the logical ER diagram, define primary/foreign keys and cardinalities, resolve normalization choices, then prepare the PostgreSQL schema and migration plan. No mock data is required for these steps.
