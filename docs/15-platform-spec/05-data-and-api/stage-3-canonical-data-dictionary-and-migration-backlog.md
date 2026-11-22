# Stage 3 — Canonical Data Dictionary & Migration Backlog

**Project:** GreenGrid Solar Solutions — Solar Agency Management Platform  
**Status:** Proposed canonical physical data dictionary; pending engineering and stakeholder approval  
**Date:** 22 November 2026  
**Depends on:** Stage 1 database inventory, Stage 2 domain ER designs and Stage 3 PostgreSQL implementation blueprint.

## 1. Purpose and rules

This document turns the logical ER designs into a consistent implementation register. It identifies domain ownership, proposed tables, key columns, relationships, constraints, indexes, API ownership and migration dependencies. It is a design control document, not executable DDL. Names and columns must be reconciled against detailed ER documents before SQL generation.

Non-negotiable:
- PostgreSQL is the authoritative operational store. Clients never connect directly.
- Business master data is manually entered and maintained through authorized application screens and stored in PostgreSQL.
- No mock/sample operational data or hidden business seed scripts.
- Migrations create structure only. Do not preload customers, employees, products, suppliers, payment modes, or business master values.
- Approved external reference data, such as India Post PIN/post-office records, may be imported through a controlled and auditable synchronization process. This is a documented source-data import, not mock data.
- Record source, retrieval time, dataset version and provenance for imported reference records.
- Use snake_case; TIMESTAMPTZ for instants; DATE for calendar dates; NUMERIC for money and measurements; VARCHAR for identifiers such as PIN codes and phone numbers.
- Secrets and API credentials belong in a secret manager, not ordinary database columns.

## 2. Canonical schema ownership

| Schema | Domain | Main table families |
|---|---|---|
| ref | Reference data | geography, postal offices, units, address types, source provenance |
| org | Organization | company locations, departments, employees, groups, memberships |
| iam | Identity and access | accounts, credentials, sessions, MFA, permissions, grants, invitations |
| crm | CRM | enquiries, contacts, addresses, customers, conversion history |
| catalog | Product catalogue | categories, manufacturers, models, units, compatibility |
| sales | Sales and survey | surveys, visits, design versions, quotations, approvals |
| project | Project execution | projects, sites, milestones, tasks, assignments, dependencies |
| gov | Government tracking | schemes, applications, events, subsidy tracking |
| supply | Procurement/inventory | suppliers, purchase orders, warehouses, stock ledger |
| finance | Finance | receipts, payment records, allocations, expenses, project costs |
| install | Installation | jobs, checklists, inspections, commissioning, handover |
| asset | Asset registry | solar systems, assets, components, warranties |
| monitor | Monitoring | devices, integrations, telemetry, aggregates, alerts |
| service | Service | cases, work orders, visits, maintenance, parts usage |
| comms | Communications | events, templates, notifications, recipients, attempts, consent |
| files | Documents | metadata, versions, entity links, access grants, signatures |
| platform | Platform operations | integrations, webhook inbox, outbox, jobs, settings, incidents |
| audit | Audit/security | audit events, security events, privileged actions, export events |

## 3. Shared physical conventions

| Column/category | Recommended type | Rule |
|---|---|---|
| Primary key | UUID or BIGINT identity | Choose one policy before DDL; FKs match exactly |
| Public identifier | UUID | Use if internal sequential IDs are retained |
| created_at / updated_at | TIMESTAMPTZ | UTC instant |
| created_by / updated_by | Same type as identity PK | Nullable only for documented system/import events |
| row_version | INTEGER | Optimistic concurrency on mutable records |
| Money | NUMERIC with approved precision | Never floating point; explicit currency code |
| Quantity/measurement | NUMERIC(p,s) | Explicit unit and approved precision |
| Postal code / phone | VARCHAR | Identifiers, not numbers |
| Email | VARCHAR | Preserve display form; normalized comparison value if needed |
| Metadata | JSONB | Provider payload/config only, not core relational fields |
| File binary | Private object storage | PostgreSQL stores metadata, key reference and checksum |
| Secret | Secret-manager reference | Never plaintext |

Common audit columns should be used where meaningful, not mechanically added to every junction or append-only event table. Referenced master records should be deactivated/archived, not physically deleted. Use RESTRICT for business history; CASCADE only for disposable dependent children. Use explicit status history and service-level transition validation.

## 4. Reference and geography dictionary

| Table | Important columns and relationships | Constraints / notes |
|---|---|---|
| ref.countries | country_id PK, country_code, country_name, calling_code, is_active | country_code unique |
| ref.states | state_id PK, country_id FK, state_code, state_name, normalized_name | country + normalized name unique |
| ref.districts | district_id PK, state_id FK, district_name, normalized_name | state + normalized name unique |
| ref.local_body_types | local_body_type_id PK, type_name, is_active | Manually maintained master |
| ref.local_bodies | local_body_id PK, district_id FK, local_body_type_id FK, name, official_code | District + normalized name unique where appropriate |
| ref.postal_codes | postal_code_id PK, country_id FK, postal_code, is_active | Country + postal code unique; India PIN stored as VARCHAR(6) |
| ref.post_offices | post_office_id PK, postal_code_id FK nullable, office_name, office_type, delivery_status, district_id FK nullable, state_id FK nullable, circle, region, division | Multiple offices may share one PIN |
| ref.postal_code_post_offices | postal_code_id PK/FK, post_office_id PK/FK, is_primary | Unique pair; many-to-many mapping |
| ref.address_types | address_type_id PK, type_name, is_active | Manually maintained master |
| ref.units | unit_id PK, unit_code, unit_name, dimension, precision_scale, is_active | Unit codes unique |
| ref.reference_sources | source_id PK, source_code, source_name, source_type, terms_url, is_active | Source and data-use record |
| ref.reference_import_runs | import_run_id PK, source_id FK, started_at, completed_at, status, dataset_version, record_count, checksum, error_summary | Immutable run history |
| ref.reference_record_provenance | provenance_id PK, source_id FK, source_record_key, source_updated_at, retrieved_at, payload_hash, import_run_id FK | Trace imported record to source/run |

### 4.1 India Post PIN/post-office data integration

**Preferred source:** Government of India Open Government Data catalog, “All India Pincode Directory (Through WebService),” attributed to the Department of Posts. Its catalog describes Circle, Region, Division, Office Name, Pincode, Office Type, Delivery, District and State Name.

Official catalog: https://data.gov.in/catalog/all-india-pincode-directory-through-webservice

**CEPT integration option:** Department of Posts integration documentation describes the PIN validation endpoint:
https://api.cept.gov.in/CommonFacilityMaster/api/values/Fetch_Facility

The published CEPT integration guide says the customer's public IP must be whitelisted. Therefore, treat this as an access-controlled integration, not an anonymous public API. Confirm current endpoint availability, access approval, IP allowlisting, request limits, terms and production support with CEPT before enabling it.

**Do not assume** the interactive India Post “Know Your PIN Code” website is itself a supported public REST API. Use the documented OGD API or obtain explicit CEPT integration access.

#### Local-first lookup flow
1. User enters a six-digit PIN.
2. Backend validates format and searches PostgreSQL first.
3. If local data is missing or beyond the approved freshness period, backend requests the approved source.
4. Validate source response, PIN, fields and provenance.
5. Upsert postal code and all associated post offices using a stable source key or reviewed natural key.
6. Store source, dataset version, retrieval time, import run and payload hash.
7. Return all matching offices; user selects the correct office.
8. Preserve free-text address and permit correction. Never silently overwrite the user's locality or address.

#### Required source metadata
Store source_id, source_record_key, dataset_version (if supplied), source_updated_at (if supplied), retrieved_at, last_verified_at, payload_hash and import_run_id. Retain previous provenance/snapshots according to source terms and retention policy.

#### Resilience and conflict rules
- PostgreSQL is the local lookup/cache store; do not call the provider on every form render.
- Provider timeout must not block legitimate address entry if the user can provide a valid free-text address.
- Distinguish invalid PIN, provider unavailable, stale local record and needs review.
- Rate-limit calls and prevent duplicate concurrent refreshes for the same PIN.
- Bulk refresh runs as a background job, not on every user lookup.
- India Post/CEPT/official OGD is preferred for postal mapping. Third-party aggregators require separate reliability, licensing, privacy and uptime review.
- Preserve manually entered address text if postal data conflicts; flag the mapping for review.
- PIN alone does not uniquely identify a village, local body or customer site.
- Never invent coordinates from a PIN.

#### Proposed GreenGrid endpoints
- GET /api/v1/geography/pincodes/{pincode} — local-first lookup and office list.
- GET /api/v1/geography/post-offices/{post_office_id} — office detail.
- POST /api/v1/admin/reference-imports/postal-data — permission-protected sync request.
- GET /api/v1/admin/reference-imports/{import_run_id} — import status and errors.

These are proposed paths, not final OpenAPI contracts. The frontend calls GreenGrid's backend, never the external provider. Provider credentials remain in a secret manager.

## 5. Organization and identity dictionary

| Table | Important columns and relationships | Constraints / notes |
|---|---|---|
| org.company_locations | location_id PK, name, location_type_id, address references | Company office/warehouse |
| org.departments | department_id PK, parent_department_id FK nullable, name | Prevent hierarchy cycles in service |
| org.employees | employee_id PK, employee_code, display_name, department_id FK, manager_employee_id FK, employment_status_id | Employee code unique in company |
| org.employee_contacts | contact_id PK, employee_id FK, contact_type_id, value, normalized_value, is_primary, is_verified | Multiple contact methods |
| org.employee_addresses | employee_address_id PK, employee_id FK, address_type_id FK, address fields | Explicit ownership |
| org.employee_groups | group_id PK, group_name, description, is_active | Configurable groups, not roles |
| org.employee_group_memberships | membership_id PK, employee_id FK, group_id FK, valid_from, valid_to | Multiple groups; unique active membership |
| iam.identity_accounts | account_id PK, account_type, account_status, normalized login identifiers | One account population per account; typed subject links; no unconstrained polymorphic IDs |
| iam.account_credentials | credential_id PK, account_id FK, credential_type, secret_hash/reference | No plaintext passwords |
| iam.sessions | session_id PK, account_id FK, token_hash, issued_at, expires_at, revoked_at | Store token hash |
| iam.mfa_methods | mfa_method_id PK, account_id FK, method_type, secret_reference, verified_at | Secret material protected |
| iam.permissions | permission_id PK, permission_key, description | permission_key unique |
| iam.permission_sets | permission_set_id PK, name, description | Reusable permission bundle |
| iam.permission_set_permissions | permission_set_id PK/FK, permission_id PK/FK, effect | Explicit allow/deny |
| iam.group_permission_set_grants | grant_id PK, group_id FK, permission_set_id FK, scope_type/reference, effect, validity | Groups and permissions remain separate |
| iam.account_permission_overrides | override_id PK, account_id FK, permission_id FK, scope, effect, reason, validity | Individually audited |
| iam.invitations | invitation_id PK, account_id FK, token_hash, expires_at, accepted_at, revoked_at | Single-use and expiry; application validates intended subject context |
| iam.customer_account_links | customer_account_link_id PK, account_id FK, customer_id FK, optional customer_contact_id FK, relationship_type, status, verification/revocation audit | Customer-specific verified authorization; migration 0006 |

Authentication and authorization remain separate. Manager relationships do not automatically grant permissions. Employee links use `iam.employee_account_links`; customer links use `iam.customer_account_links`. The initial model does not support one account simultaneously acting as employee and customer. See [ERD Logical-to-Physical Mapping](ERD-LOGICAL-PHYSICAL-MAPPING.md).

## 6. CRM, sales and project dictionary

| Table | Important columns and relationships | Constraints / notes |
|---|---|---|
| crm.enquiries | enquiry_id PK, enquiry_reference, source_id FK, status_id FK, prospect_name, assigned_employee_id FK | May exist before customer |
| crm.enquiry_contacts | enquiry_contact_id PK, enquiry_id FK, contact_type_id, value, normalized_value | Multiple contacts |
| crm.enquiry_addresses | enquiry_address_id PK, enquiry_id FK, address and postal references | Preserve pre-conversion address |
| crm.enquiry_activities | activity_id PK, enquiry_id FK, activity_type_id, actor_id, occurred_at | Append history |
| crm.customers | customer_id PK, public_id, customer_reference, customer_kind, legal_name, display_name, customer_status | Core subject table in migration 0006; later migrations add approved master FKs and remaining CRM fields |
| crm.customer_contacts | customer_contact_id PK, public_id, customer_id FK, full_name, relationship_or_designation, is_primary_contact | Core contact subject in migration 0006; contact methods/consent remain later migrations |
| crm.customer_addresses | customer_address_id PK, customer_id FK, address_type_id FK, address fields | Multiple addresses |
| crm.enquiry_conversions | conversion_id PK, enquiry_id FK unique, customer_id FK, converted_at/by | Preserve source history |
| catalog.product_categories | category_id PK, parent_category_id FK, name, is_active | Configurable |
| catalog.manufacturers | manufacturer_id PK, name, country reference, is_active | Master data |
| catalog.product_models | model_id PK, manufacturer_id FK, category_id FK, model_code, specifications | Manufacturer + model unique |
| sales.surveys | survey_id PK, enquiry_id/project_id link, site reference, status_id, survey_date | Support pre-project survey |
| sales.survey_visits | visit_id PK, survey_id FK, assigned_employee_id FK, scheduled_at, completed_at | Visit history |
| sales.design_versions | design_version_id PK, survey_id FK, version_no, status, capacity, unit_id FK | Survey + version unique |
| sales.quotations | quotation_id PK, enquiry_id FK, design_version_id FK, reference, version_no, currency, totals, status | Version unique; approved version preserved |
| sales.quotation_items | item_id PK, quotation_id FK, product_model_id FK, description, quantity, unit_id FK, unit_price, tax, total | Exact decimals |
| sales.quotation_approvals | approval_id PK, quotation_id FK, approver_id, decision, decided_at | Append approval history |
| project.projects | project_id PK, project_reference, customer_id FK, enquiry_id FK, quotation_id FK, status_id, owner_employee_id FK | Explicit source links |
| project.project_sites | project_site_id PK, project_id FK, site/address reference | Project/site separation |
| project.milestones | milestone_id PK, project_id FK, type_id, sequence_no, due_at, status_id, owner_id | Project + sequence unique |
| project.tasks | task_id PK, project_id FK, milestone_id FK, parent_task_id FK, assigned_employee/group FK, due_at, status_id, row_version | Scope enforced server-side |
| project.task_events | event_id PK, task_id FK, actor_id, event_type, occurred_at, payload | Append-only |
| project.task_dependencies | task_id PK/FK, depends_on_task_id PK/FK, dependency_type | No self-dependency; prevent cycles |

## 7. Government, procurement, finance and installation dictionary

| Table | Important columns and relationships | Constraints / notes |
|---|---|---|
| gov.schemes | scheme_id PK, scheme_name, authority, validity, is_active | Applicability verified |
| gov.applications | application_id PK, project_id FK, customer_id FK, scheme_id FK, external_reference, status | Authority portal remains source of truth |
| gov.application_events | event_id PK, application_id FK, event_at, status, source, evidence_document_id FK | Append-only |
| gov.subsidy_records | subsidy_id PK, application_id FK, amount, currency, status, received_at | Approval != payment |
| supply.suppliers | supplier_id PK, supplier_reference, name, status_id | UI-managed master |
| supply.supplier_contacts | contact_id PK, supplier_id FK, contact fields | Multiple contacts |
| supply.warehouses | warehouse_id PK, company_location_id FK, name, is_active | Company location |
| supply.purchase_orders | purchase_order_id PK, supplier_id FK, project_id FK, reference, status, currency, totals | Unique reference |
| supply.purchase_order_items | item_id PK, purchase_order_id FK, product_model_id FK, quantity, unit_id FK, unit_price | Decimal quantities/prices |
| supply.stock_items | stock_item_id PK, product_model_id FK, sku, is_active | SKU unique in scope |
| supply.stock_movements | movement_id PK, stock_item_id FK, warehouse_id FK, movement_type, quantity, occurred_at, source_reference | Append-only ledger, idempotent posting |
| supply.stock_balances | stock_item_id FK, warehouse_id FK, quantity_on_hand, row_version | Derived cache, reconcile to ledger |
| finance.receipts | receipt_id PK, customer_id FK, project_id FK, reference, received_at, amount, currency, payment_mode_id FK | Evidence of received funds |
| finance.payment_records | payment_record_id PK, receipt_id FK, provider_reference, amount, status, recorded_at | No gateway assumption |
| finance.payment_allocations | allocation_id PK, receipt_id FK, project_id FK, amount | Cannot exceed unallocated receipt |
| finance.expenses | expense_id PK, project_id/supplier/category refs, amount, currency, incurred_at | Approval and audit |
| finance.project_cost_entries | cost_entry_id PK, project_id FK, source_type/id, amount, currency | Reconcile source; prevent duplicate cost |
| install.installation_jobs | job_id PK, project_id FK, site_id FK, scheduled dates, status | Project/site relationship |
| install.checklist_templates | template_id PK, name, version_no, is_active | Versioned template |
| install.checklist_items | item_id PK, template_id FK, item_key, description, required_flag | Template + item key unique |
| install.inspections | inspection_id PK, job_id FK, inspector_id FK, inspected_at, result | Preserve reinspection |
| install.inspection_results | result_id PK, inspection_id FK, checklist_item_id FK, result_code, remarks, document_id FK | One result per item/inspection |
| install.commissioning_records | commissioning_id PK, job_id FK, commissioned_at, outcome, evidence | Prerequisites enforced |
| install.handover_records | handover_id PK, project_id FK, customer_id FK, handed_over_at, accepted_by, status | Acknowledgement evidence |

## 8. Asset, monitoring, service, communications and platform dictionary

| Table | Important columns and relationships | Constraints / notes |
|---|---|---|
| asset.solar_systems | solar_system_id PK, project_id FK, site_id FK, reference, capacity, unit_id FK, commissioned_at, status | Multiple systems per customer/site |
| asset.assets | asset_id PK, solar_system_id FK, product_model_id FK, serial_number, installed_at, status | Serial uniqueness policy |
| asset.asset_components | component_id PK, parent_asset_id FK, asset_id FK, component_type_id | Component hierarchy |
| asset.warranties | warranty_id PK, asset_id FK, warranty_type, starts_on, ends_on, provider, document_id FK | End >= start |
| monitor.devices | device_id PK, asset_id FK, solar_system_id FK, manufacturer/model refs, serial_number, status | Device distinct from provider connection |
| monitor.device_integrations | mapping_id PK, device_id FK, integration_id FK, external_device_reference, status | Secrets by reference only |
| monitor.telemetry_readings | reading_id PK, device_id FK, metric_id FK, measured_at, ingested_at, value NUMERIC, unit_id FK, quality_code | Partition by measured_at when justified |
| monitor.telemetry_raw_events | raw_event_id PK, mapping_id FK, received_at, payload JSONB, payload_hash | Restricted retention |
| monitor.telemetry_aggregates | aggregate_id PK, device_id FK, metric_id FK, period_start/end, value, unit_id FK, quality_summary | Rebuildable |
| monitor.alerts | alert_id PK, device_id FK, solar_system_id FK, alert_type_id FK, severity, opened_at, recovered_at, status | Recovery != case resolution |
| monitor.alert_events | event_id PK, alert_id FK, event_type, occurred_at, payload | Append-only |
| service.service_cases | case_id PK, customer_id FK, solar_system_id FK, alert_id FK, reference, status, priority, assigned_group_id FK | Independent case lifecycle |
| service.work_orders | work_order_id PK, case_id FK, assigned_employee/group, status, scheduled_at | Assignment/scope |
| service.field_visits | visit_id PK, work_order_id FK, technician_id FK, started_at, completed_at, outcome | Visit history |
| service.parts_usage | usage_id PK, visit_id FK, stock_item_id FK, quantity, stock_movement_id FK unique | Atomic with stock movement |
| service.maintenance_plans | plan_id PK, solar_system_id FK, plan_type, interval, next_due_at, status | Configurable schedule |
| comms.notification_events | event_id PK, event_key, source_domain, source_record_reference, occurred_at, payload | Idempotent event identity |
| comms.notifications | notification_id PK, event_id FK, template_id FK, channel_id FK, status, created_at | Event distinct from delivery |
| comms.notification_recipients | recipient_id PK, notification_id FK, account/contact reference, status, read_at | Per-recipient status |
| comms.delivery_attempts | attempt_id PK, notification_id FK, recipient_id FK, provider_reference, attempted_at, result | Retry history; accepted != delivered |
| comms.templates | template_id PK, template_key, version_no, locale, channel_id FK, content | Key/version/locale/channel unique |
| comms.preferences | preference_id PK, account_id FK, channel_id FK, enabled, updated_at | User preferences |
| comms.consent_records | consent_id PK, subject reference, purpose, channel_id FK, decision, recorded_at, evidence | Consent separate from contact |
| files.documents | document_id PK, document_type_id FK, title, owner_scope, created_by, status | Metadata only |
| files.document_versions | version_id PK, document_id FK, version_no, storage_key, checksum, size_bytes, mime_type, scan_status | Immutable version; unique document/version |
| files.document_entity_links | link_id PK, document_id FK, entity type/public ID, relationship | Typed links preferred for core entities |
| files.document_access_grants | grant_id PK, version_id FK, subject reference, permission, expires_at | Least privilege |
| files.signature_envelopes | envelope_id PK, document_id FK, provider_reference, status, sent_at, completed_at | Legal validity VERIFY |
| platform.integrations | integration_id PK, provider_code, display_name, capabilities JSONB, status | No credentials |
| platform.integration_accounts | account_id PK, integration_id FK, label, secret_reference, config JSONB, status | Secret manager |
| platform.webhook_inbox | webhook_id PK, account_id FK, external_event_id, received_at, signature_valid, payload_hash, status | Provider/event unique |
| platform.domain_event_outbox | outbox_id PK, event_key, aggregate_type/id, occurred_at, payload JSONB, published_at | Same transaction as business change |
| platform.background_jobs | job_id PK, job_type, payload JSONB, status, priority, scheduled_at, attempts, locked_at | Idempotency and bounded retries |
| platform.job_attempts | attempt_id PK, job_id FK, started_at, finished_at, outcome, sanitized_error | Append-only |
| platform.settings | setting_id PK, setting_key, value_type, value JSONB, scope, version_no, is_active | No secrets; versioned |
| platform.incidents | incident_id PK, severity, summary, status, opened_at, resolved_at | Sanitized operations evidence |
| audit.audit_events | event_id PK, actor_id, action_key, entity_type/public_id, occurred_at, request_id, change_summary | Append-only |
| audit.security_events | event_id PK, event_type, actor/account, occurred_at, source_ip, outcome, metadata | Sensitive access controls |
| audit.data_export_events | export_id PK, actor_id, export_scope, purpose, occurred_at, result | Sensitive export tracking |

**Polymorphic reference warning:** entity_type + entity_id cannot provide a normal FK to multiple tables. Prefer typed link tables or a controlled entity registry with validation for sensitive core relationships.

## 9. Constraint and index backlog

### Constraints
- Every FK has a documented delete policy and appropriate index.
- Unique constraints for public references, provider event IDs, document versions, idempotency keys and domain-specific natural keys.
- Partial unique indexes for active-only uniqueness where history is retained.
- CHECK constraints for amount/quantity/date/coordinate/percentage/file-size bounds.
- Project/site/customer consistency enforced by composite FKs or service transaction checks.
- Status transitions validated in domain services with status history.
- Financial and inventory ledgers are authoritative; cached balances are rebuildable.
- Missing telemetry remains unknown, not zero.

### Index candidates
| Query | Candidate |
|---|---|
| PIN lookup | ref.postal_codes(country_id, postal_code) unique |
| Offices for PIN | ref.postal_code_post_offices(postal_code_id, post_office_id) |
| Employee queue | project.tasks(assigned_employee_id, status_id, due_at) |
| Enquiry pipeline | crm.enquiries(status_id, created_at DESC) |
| Customer project history | project.projects(customer_id, created_at DESC) |
| Project milestone order | project.milestones(project_id, sequence_no) unique |
| Stock history | supply.stock_movements(stock_item_id, occurred_at DESC) |
| Receipt history | finance.receipts(customer_id, received_at DESC) |
| Telemetry history | monitor.telemetry_readings(device_id, measured_at DESC) |
| Service queue | service.service_cases(status_id, priority_id, updated_at DESC) |
| Notification attempts | comms.delivery_attempts(notification_id, attempted_at DESC) |
| Runnable jobs | Partial index on queued/scheduled jobs by priority and scheduled_at |
| Audit timeline | audit.audit_events(entity_type, entity_public_id, occurred_at DESC) |

Validate indexes with EXPLAIN ANALYZE and realistic data volumes; do not index every column.

## 10. Migration backlog and dependency order

Migrations create schema only. Postal data import is a separate, logged data-import operation after source access and data-use terms are confirmed.

| Batch | Scope | Dependencies | Exit criteria |
|---|---|---|---|
| M00 | PK policy, schema names, types, PostgreSQL version | Decisions | Architecture sign-off |
| M01 | Schemas and migration metadata | M00 | Fresh DB initializes |
| M02 | Reference sources/provenance and empty geography tables | M01 | Empty master API works |
| M03 | Organization, employees, groups | M01/M02 | Employee/group model tests |
| M04 | Identity, sessions, MFA, permissions, grants | M03 | AuthZ tests pass |
| M05 | Audit/security foundations | M01/M04 | Sensitive actions audited |
| M06 | Integrations, webhook inbox, outbox and jobs | M01/M05 | Retry/idempotency tests |
| M07 | CRM enquiry, contacts, addresses, customer, conversion | M02/M03/M04 | Enquiry conversion tests |
| M08 | Product catalogue and units | M02 | Catalogue/FK tests |
| M09 | Survey, design, quotation | M07/M08 | Version/approval tests |
| M10 | Projects, sites, tasks, milestones | M07/M09/M03 | Lifecycle/scope tests |
| M11 | Government application tracking | M10/M06 | External status mirror tests |
| M12 | Suppliers, purchase orders, warehouse, stock ledger | M08/M10 | Stock reconciliation |
| M13 | Receipts, allocations, expenses | M07/M10/M12 | Finance reconciliation |
| M14 | Installation, inspection, commissioning, handover | M10/M12/M13 | Completion prerequisites |
| M15 | Solar systems, assets, warranties | M14/M08 | Asset genealogy tests |
| M16 | Device registry, telemetry, alerts, partitions | M15/M06 | Ingestion/missing-data tests |
| M17 | Service cases, work orders, visits, parts usage | M15/M16/M12 | Case/stock tests |
| M18 | Notification templates, preferences, consent, delivery | M04/M06/M07 | Delivery/retry tests |
| M19 | Document metadata, versions, grants, signatures | M04/M06 | Secure file tests |
| M20 | Reporting, retention, indexes, performance tuning | Domain batches | Load/restore/reconciliation |

Actual migration order must follow the FK dependency graph. Create minimal audit/files foundations earlier if referenced. Add FKs in later migrations when circular dependencies require staged creation.

## 11. Data import and master administration

### Manual master data
Authorized user opens Administration → Master Data; application fetches database records; user creates/updates; backend validates permissions, duplicates and parent-child consistency; PostgreSQL persists values and audit metadata. All apps consume database-backed APIs. Empty lists show an actionable empty state, not hardcoded fallbacks.

### Official postal data import
1. Administrator enables approved India Post/OGD integration.
2. Backend validates provider access and configuration.
3. Create an import run with source, start time and dataset version.
4. Fetch data through backend-only integration.
5. Validate and normalize while preserving source keys/names.
6. Upsert in bounded transactions.
7. Record import results, rejects, payload hashes and source timestamps.
8. Flag conflicts with curated data; do not destructively overwrite.
9. Show import summary and failures to an authorized administrator.
10. Schedule refresh according to confirmed source cadence and approved retention terms.

## 12. API ownership matrix

| API area | Owner |
|---|---|
| /geography, /master-data | ref |
| /organization, /employees, /groups | org |
| /auth, /sessions, /permissions | iam |
| /enquiries, /customers | crm |
| /catalog | catalog |
| /surveys, /designs, /quotations | sales |
| /projects, /tasks | project |
| /government-applications | gov |
| /suppliers, /purchase-orders, /inventory | supply |
| /receipts, /expenses | finance |
| /installations, /commissioning | install |
| /assets, /warranties | asset |
| /monitoring, /telemetry, /alerts | monitor |
| /service-cases, /work-orders | service |
| /notifications, /preferences | comms |
| /documents, /signatures | files |
| /integrations, /jobs, /admin | platform |
| /audit | audit |

All endpoint paths are proposals. OpenAPI must define request/response schemas, permissions, resource scope, pagination, idempotency, error codes and audit requirements.

## 13. Decisions required before DDL

1. Primary key strategy: UUID, BIGINT identity, or internal BIGINT plus public UUID?
2. PostgreSQL version and supported extensions?
3. Confirm CEPT/OGD access method, allowlisting, API limits, data-use terms and refresh cadence.
4. Is the OGD API sufficient for production or is CEPT integration approval required?
5. What postal fields are authoritative versus display-only?
6. How are imported records and manual overrides reconciled?
7. Expected telemetry, notification, job and audit volumes?
8. Which domains are in V1 versus later release?
9. Which fields require field-level encryption?
10. Backup RPO/RTO and retention?
11. Which ORM and migration framework will be used with FastAPI?
12. Who approves canonical DDL and migration PRs?

## 14. Acceptance checklist

- [ ] Every table has domain ownership and key columns.
- [ ] Relationships, FK delete rules and uniqueness are reviewed.
- [ ] Index candidates map to actual API queries.
- [ ] Financial/stock operations are transactionally safe.
- [ ] Telemetry preserves missing-data semantics.
- [ ] No mock/business seed records are in migrations.
- [ ] Postal import is traceable, cache-first and source-attributed.
- [ ] Official API access, caching/retention terms and operational limits are verified before production sync.
- [ ] Dictionary reconciles with all Stage 2 ER designs.
- [ ] Migration DAG and rollback/forward-fix plans are reviewed.
- [ ] Fresh install, upgrade, security, performance and restore tests pass.

## 15. Next implementation artifact

After this dictionary is approved, generate reviewed SQLAlchemy/Alembic migrations in small dependency-ordered batches. Start with empty schemas, reference structures, organization and identity; then test the first vertical slice through enquiry capture. Add the India Post import as a separate auditable integration job only after source access and data-use terms are confirmed.


## 12. Canonical access-control physical mapping and scope vocabulary

The Stage 2 access ER is logical. The current physical bootstrap model uses:
- `org.employee_groups.group_id` and `org.employee_group_memberships.group_id`;
- `iam.permissions`, `iam.permission_sets`, `iam.permission_set_permissions`;
- `iam.group_permission_set_grants` as the group-to-permission-set/scope grant;
- `iam.account_permission_overrides` as the individual allow/deny override;
- `iam.identity_accounts`, `iam.employee_account_links` and `iam.customer_account_links` for typed identity linkage; migration 0006 creates the minimal customer/contact subject tables required by the latter.

Do not create duplicate tables named `group_permissions`, `user_accounts` or `employee_permission_overrides` solely to mirror logical labels. The full mapping and authorization evaluation contract are maintained in [ERD Logical-to-Physical Mapping](ERD-LOGICAL-PHYSICAL-MAPPING.md).

Canonical scope values for new writes are exactly `own`, `assigned`, `team`, `related`, `location`, `company`. Do not use `group`, `resource`, `branch` or `all`. Group is a grant source; scope reference is a separately validated parameter. Scope semantics and deny precedence are defined in [Consistency Resolution Decisions](../13-implementation-blueprints/10-consistency-resolution-decisions.md). Enforce identical predicates for list/detail/search/export/aggregate/file/realtime/background paths.

## 13. Finance and API naming reconciliation

The initial release records receipts for funds actually received; it does not initiate online payments. The physical finance model must distinguish payment instructions/dues, unverified receipts, verified/posted receipts, allocations, reversals/refunds and supplier payment records. A customer-submitted UPI screenshot/reference is not settlement proof. No gateway transaction entity or endpoint is implied unless a separate gateway integration is approved.

Use receipt-oriented command names in the normative API: record receipt, verify receipt, allocate receipt, reverse receipt and record refund. Generic `POST /payments` in older logical examples is illustrative only and must not be implemented as a gateway initiation endpoint.

## 14. Telemetry retention alignment

Use the provisional planning baseline in the consistency decision register: raw observations/provider payloads 90 days; 15-minute aggregates 12 months; daily aggregates 5 years. Alert/fault events, service evidence, customer documents and security/audit logs each require separate schedules. These are not approved legal retention periods. No deletion automation may be enabled until purpose, legal basis, owner and retention approval are recorded.
