# Stage 3 — PostgreSQL Implementation Blueprint, Schema Dependencies, Constraints, Indexes & Migration Plan

Status: Proposed implementation blueprint; requires engineering and stakeholder review  
Date: 22 November 2026  
Scope: Consolidates Stage 1 entity inventory and Stage 2 logical ER designs into a physical PostgreSQL implementation plan.

## 1. Purpose and implementation boundary

The Stage 1 inventory and Stage 2 ER documents define business domains and logical relationships. This Stage 3 blueprint explains how to translate those designs into a maintainable PostgreSQL database, in what order migrations should run, how constraints and indexes should be applied, which domain owns each table, and how APIs and workers interact with the database.

This is not an executable SQL migration. Before coding, engineering must reconcile naming and relationship differences across the domain ER documents, approve a canonical data dictionary, and produce reviewed migrations.

**Non-negotiable rules**
- PostgreSQL is the system of record for business data.
- Web, customer and technician clients never connect directly to PostgreSQL.
- All business master data is manually entered and maintained by authorized users through application screens and stored in PostgreSQL.
- No hardcoded business dropdown lists, operational seed data, fake customers, fake employees, fake payments, sample alerts or mock records.
- Migrations create schemas, tables, constraints, indexes and documented technical metadata only. No business master values are silently seeded.
- Use snake_case for schema objects and columns.
- Every table has a clear owning domain and API/service owner.
- Foreign keys and database constraints enforce integrity; frontend validation alone is insufficient.

## 2. Recommended PostgreSQL namespace layout

Use PostgreSQL schemas to organize domain ownership and reduce naming collisions. These are database namespaces, not separate databases.

| PostgreSQL schema | Ownership / responsibility | Representative entities |
|---|---|---|
| ref | Shared reference/master data and geography | countries, states, districts, postal_codes, address_types, units |
| org | Company structure and employees | departments, company_locations, employees, employee_groups, group_memberships |
| iam | Identity and authorization | identity_accounts, sessions, permissions, permission_sets, group grants, audit decisions |
| crm | Prospects, enquiries and customers | enquiries, enquiry_contacts, customers, customer_contacts, customer_addresses |
| catalog | Product and equipment catalogue | product_categories, manufacturers, models, units |
| sales | Survey, design, quotations and proposals | surveys, design_versions, quotations, quotation_items |
| project | Confirmed projects and delivery planning | projects, project_sites, milestones, tasks, schedules |
| gov | Government application/subsidy tracking | government_applications, application_events, subsidy_records |
| supply | Suppliers, purchasing and inventory | suppliers, purchase_orders, stock_locations, stock_movements |
| install | Installation, inspection and handover | installation_jobs, checklists, inspections, commissioning_records |
| finance | Receipts, payments, expenses and costing | payment_records, receipts, expenses, allocations |
| asset | Installed assets and warranties | solar_systems, assets, asset_components, warranties |
| monitor | Telemetry, monitoring and alerts | devices, telemetry_points, readings, alerts, alert_events |
| service | Service cases and field operations | service_cases, work_orders, field_visits, maintenance_plans |
| comms | Notifications and communication | notification_events, notifications, recipients, attempts, templates |
| files | Documents and storage metadata | documents, document_versions, access grants, retention |
| platform | Integrations, jobs, settings and operational control | integrations, background_jobs, outbox, incidents, settings |
| audit | Append-only audit and security evidence | audit_events, security_events, access logs |

### Namespace rules
1. Shared reference tables belong in ref; domain-specific statuses and business records remain with their owning domain unless reuse is demonstrated.
2. Cross-schema foreign keys are allowed and should be explicit.
3. Do not create a generic common schema that becomes a dumping ground.
4. Do not duplicate the same customer, employee, site, project or asset entity in multiple schemas.
5. Keep PostgreSQL roles and grants aligned to schema ownership. Application runtime roles receive only required privileges.
6. Schema names are a proposed convention. A smaller namespace count is acceptable if logical ownership remains documented.

## 3. Canonical entity ownership and source of truth

| Entity / data | Authoritative owner | Other domains should |
|---|---|---|
| Employee and group membership | org | Reference employee/group IDs; do not copy membership lists |
| Identity, sessions and permissions | iam | Use approved authorization service/policy |
| Customer/contact | crm | Reference IDs; store only justified snapshots |
| Enquiry | crm | Preserve pre-customer prospect history |
| Product/manufacturer/model catalogue | catalog | Reference catalogue IDs |
| Survey/design/quotation | sales | Reference approved versions |
| Confirmed project/milestones/tasks | project | Reference project and task IDs |
| Government application status mirror | gov | Treat authority portal as external source of truth |
| Purchase and stock movements | supply | Never independently adjust stock totals |
| Installation/commissioning evidence | install | Link documents and assets; do not duplicate file bytes |
| Receipts/expenses/payment allocations | finance | Reference receipt/payment IDs; do not infer payment from notification |
| Installed asset/warranty | asset | Reference asset IDs from monitoring/service |
| Telemetry and alert lifecycle | monitor | Do not treat missing readings as zero |
| Service case/work order/visit | service | Alert recovery and work completion do not automatically close cases |
| Notification delivery | comms | Business domains publish events; do not send directly from request handlers |
| Document metadata and file versions | files | Store file references; do not put binaries in relational tables by default |
| Integration/job/outbox state | platform | Domain transactions write outbox rows atomically |
| Audit evidence | audit | Append events; do not silently update historic records |

## 4. Physical data type standards

| Data category | Recommended PostgreSQL type | Rule |
|---|---|---|
| Primary key | BIGINT identity or UUID | Choose a standard per table family; do not mix casually |
| Foreign key | Same type as referenced PK | Enforce actual FK |
| Human/business reference | VARCHAR | Unique, non-sequential where externally exposed |
| Names/codes | VARCHAR with documented limits | Normalize for uniqueness where required |
| Long descriptions | TEXT | Validate at API boundary |
| Money | NUMERIC(14,2) or justified precision | Never use floating point; currency code is explicit |
| Quantity | NUMERIC(p,s) | Precision based on unit and domain |
| Percentages | NUMERIC(p,s) | Define allowed range and unit |
| Date-only | DATE | Do not convert date-only concepts to timestamps |
| Instant | TIMESTAMPTZ | Store UTC instant; render in business/user timezone |
| Local clock time | TIME | Store timezone separately where schedules require it |
| Duration | INTEGER or INTERVAL | Choose based on arithmetic and reporting needs |
| Boolean | BOOLEAN | Avoid string flags |
| PIN/postal code | VARCHAR | Identifier, not number |
| Phone number | VARCHAR | Normalize international format; do not store numeric |
| Email | VARCHAR | Preserve display and normalized comparison form |
| Coordinates | NUMERIC or approved PostGIS geometry | Validate ranges; extension requires approval |
| JSON metadata | JSONB | Variable provider payload/config only; not a replacement for relational columns |
| Binary files | Private object storage | PostgreSQL stores metadata, key reference and checksum |
| Hash/checksum | VARCHAR or BYTEA | Store algorithm explicitly |
| Secret | Secret-manager reference only | Never plaintext column |

### Identifier decision
Choose UUIDs or identity BIGINTs as the primary-key standard for each domain before migrations begin. UUIDs suit externally exposed identifiers and distributed creation; BIGINTs are compact for internal joins. A common compromise is internal BIGINT PK plus a separate random public reference. Do not expose sequential database IDs in public URLs.

### Money and measurement
Every financial amount must have a currency code or be unambiguously tied to a currency-controlled document. Store original amount, tax/discount components and rounding policy as required by finance rules. Solar capacity, power, energy, voltage, current, irradiance and temperature must use explicit units; do not mix kW/kWh or silently convert readings.

## 5. Mandatory integrity and lifecycle patterns

### 5.1 Common columns
Use a consistent subset where meaningful:
- primary key
- created_at / created_by
- updated_at / updated_by
- status_id referencing a database-managed status table where status is configurable
- row_version for optimistic concurrency on mutable records
- archived_at / deactivated_at instead of physical deletion for referenced master records

Do not add meaningless audit columns to pure junction tables or append-only telemetry tables if their event timestamp already provides the required semantics.

### 5.2 Foreign keys and delete behaviour
- Use ON DELETE RESTRICT for business records referenced by financial, project, audit, document or operational history.
- Use ON DELETE CASCADE only for dependent child records with no independent business/audit value.
- Use SET NULL only when historical meaning remains clear and null is approved.
- Never cascade-delete invoices, receipts, stock movements, audit events, signed documents or telemetry history.
- Use composite foreign keys or additional constraints to ensure referenced parent/child scope matches where required.

### 5.3 Unique constraints
Define uniqueness based on business meaning:
- normalized codes within owning company/domain
- version number within parent document/design/template
- sequence number within parent workflow
- external provider message/event IDs within provider account
- idempotency key within producer/operation scope
- one active primary contact/address per relevant owner and type, if confirmed
- unique membership or grant per employee/group/scope/effective period
- one stock movement reference per posting operation
- unique payment/receipt external reference where provider semantics support it

Use partial unique indexes for active-only uniqueness where lifecycle history must be preserved.

### 5.4 Check constraints
Examples requiring database-level validation:
- positive file size and nonnegative attempt count
- valid start/end date ordering
- amount and quantity sign rules by transaction type
- latitude between -90 and 90; longitude between -180 and 180
- PIN code shape where country-specific validation is known
- percentage within approved bounds
- one of mutually exclusive owner references populated
- effective_to is null or greater than effective_from
- delivered_at not earlier than accepted/requested timestamps, allowing documented provider clock skew

Do not encode complex workflow transitions only as CHECK constraints; enforce them through domain services and transactional commands.

### 5.5 Status transitions
Use explicit transition rules in the domain service, with a status history table for important lifecycle entities. A generic status column must not permit arbitrary jumps. Validate actor permissions, prerequisites, evidence and current status in one transaction.

## 6. Indexing strategy

Indexes must be derived from actual API filters, joins, sort order and measured query plans. Avoid indexing every column.

### 6.1 Baseline indexes
- Every primary key and unique business reference.
- Foreign-key columns used in joins or parent deletion checks.
- Common lookup keys such as normalized email/phone hashes where justified and access-controlled.
- (status_id, updated_at) for work queues filtering by status and sorting by update time.
- (owner_id, created_at DESC) for customer/project histories.
- (assigned_employee_id, status_id, due_at) for staff work queues.
- (project_id, milestone_sequence) for project timelines.
- (provider_account_id, provider_message_reference) for communication callbacks.
- Unique idempotency key in the correct producer scope.
- (scheduled_at, status_id) for due background jobs.
- (occurred_at DESC) for event timelines, usually with tenant/domain scope prefix.

### 6.2 Domain-specific examples
| Domain | Candidate index |
|---|---|
| CRM | enquiries(status_id, created_at DESC); customer normalized-name search if needed |
| Projects | tasks(assigned_employee_id, status_id, due_at); milestones(project_id, sequence_no) |
| Procurement | stock_movements(stock_item_id, occurred_at DESC); purchase_orders(supplier_id, status_id) |
| Finance | receipts(customer_id, received_at DESC); unique transaction reference per provider/account |
| Monitoring | devices(project_id, device_status_id); alerts(alert_status_id, last_seen_at) |
| Telemetry | (device_id, measured_at DESC) with time partitioning |
| Service | service_cases(status_id, priority_id, updated_at DESC); work_orders(assigned_group_id, status_id) |
| Communications | notification_recipients(owner_id, recipient_status_id, created_at DESC); unique provider message reference |
| Documents | document_entity_links(entity_type_id, entity_id, document_id); unique document version number |
| Platform jobs | partial index for runnable jobs by priority and scheduled time |
| Audit | (entity_type_id, entity_id, occurred_at DESC); (actor_id, occurred_at DESC) |

These are candidates, not final prescriptions. Confirm names and columns against the canonical model and query plans.

### 6.3 Search indexes
- Use B-tree for exact matches, joins and ordered filters.
- Use trigram or full-text search only for identified requirements and after extension/operational approval.
- Do not put encrypted PII into plaintext search indexes.
- Filter search results by authorization scope before returning records.
- Avoid global search indexes that reveal cross-customer data.

## 7. High-volume telemetry and time-series strategy

Telemetry may grow much faster than transactional data. Do not store high-frequency readings in the same unpartitioned strategy as customer/project records without a volume estimate.

1. Keep device/site/asset metadata in asset/monitor domains.
2. Keep normalized readings in a partitioned telemetry table or approved time-series extension.
3. Partition by measured time (monthly or another interval selected after volume estimation).
4. Index each partition on (device_id, measured_at DESC); add metric-specific indexes only when justified.
5. Preserve raw vendor payload separately with restricted retention if required.
6. Store normalized value, unit, quality/status, source timestamp and ingestion timestamp.
7. Missing intervals remain missing/unknown; never synthesize zero generation.
8. Define late-arriving and out-of-order reading rules.
9. Define aggregation tables/materialized views for daily/monthly summaries and correction strategy.
10. Define retention, archival and deletion policies before production ingestion.

TimescaleDB or other extensions are optional and require hosting compatibility, backup/restore, licensing and operational review. Plain PostgreSQL declarative partitioning is a viable baseline.

## 8. Transaction boundaries and concurrency

Use database transactions for operations that must succeed or fail together:
- business record update plus domain outbox event
- stock movement plus any derived stock balance
- receipt/payment allocation plus corresponding ledger/audit records
- quotation approval/project conversion and source linkage
- technician part usage and inventory movement without double deduction
- notification intent and recipient routing
- document metadata/version state after upload validation
- lifecycle status plus status history and audit event

Use row-level locks or optimistic concurrency (row_version) for stock, finance, quotation approval and other contested updates. Use unique idempotency keys to prevent duplicate commands. Frontend button disabling is not a duplicate-operation control.

### 8.1 Derived balances
For inventory, finance summaries and counters, define an authoritative ledger/movement record. Derived totals may be cached/materialized but must be rebuildable from authoritative records. Avoid independent writes to ledger and cached balance without a transaction and reconciliation.

### 8.2 Outbox and worker execution
A domain service writes the business transaction and platform outbox row in one transaction. Publisher forwards committed events to the queue. Consumers store idempotency/processing results and acknowledge only after durable completion. Jobs reload source records and validate current status before executing.

## 9. Security and PostgreSQL access model

Create separate database roles:
- migration owner: schema changes through controlled deployment
- application runtime: least-privilege CRUD/execute for approved schemas
- read/reporting: read-only approved views
- worker runtime: only domain operations required by job types
- backup/restore operator: tightly controlled and audited
- break-glass administrator: time-limited and reviewed

Requirements:
- No superuser credentials in application environment.
- No direct public access to PostgreSQL.
- TLS connections and private network.
- Rotate credentials through secret manager.
- Use connection pooling with bounded pool sizes.
- Use parameterized queries/ORM-safe bindings.
- Apply row-level security only where the team can test and maintain it correctly; RLS complements, not replaces, application authorization.
- Avoid a shared database role that bypasses all policies for ordinary requests.
- Audit privileged SQL and schema changes.
- Keep production data out of development/test environments unless sanitized and approved.

## 10. API ownership and service boundaries

| API/service area | Owning domain | Main responsibilities |
|---|---|---|
| /auth, /sessions, /identity | iam | Login, recovery, invitations, session lifecycle |
| /organization, /employees, /groups | org | Staff, company structure, group membership |
| /permissions, /access | iam | Permission sets, grants, scopes and authorization |
| /master-data, /geography | ref | Database-backed reference data management |
| /enquiries, /customers, /contacts | crm | Lead capture, conversion and customer records |
| /catalog | catalog | Products, manufacturers and models |
| /surveys, /designs, /quotations | sales | Survey and proposal lifecycle |
| /projects, /tasks, /milestones | project | Project execution and planning |
| /government-applications | gov | Application tracking and evidence |
| /suppliers, /purchase-orders, /inventory | supply | Procurement and stock ledger |
| /installations, /commissioning, /handover | install | Field installation and completion evidence |
| /receipts, /payments, /expenses | finance | Financial records and allocations |
| /assets, /warranties | asset | Installed asset and warranty lifecycle |
| /monitoring, /telemetry, /alerts | monitor | Device readings, analytics and alert lifecycle |
| /service-cases, /work-orders, /visits | service | Service and maintenance operations |
| /notifications, /preferences, /messages | comms | Notification inbox and delivery routing |
| /documents, /files, /signatures | files | File metadata, versions, access and signatures |
| /integrations, /jobs, /health, /admin | platform | Platform operations and integrations |
| /audit, /privacy-requests | audit / governance service | Audit access and governed requests |

Endpoint paths are illustrative. The API contract must define request/response schemas, authentication, permission keys, resource scope, idempotency, pagination, error codes and audit requirements.

## 11. Migration and deployment sequence

Migrations should be small, ordered, reversible where safe, and tested against realistic schema size. Do not mix destructive data changes with unrelated feature migrations.

### Phase 0 — standards and decisions
- Approve primary-key strategy and naming.
- Approve schema ownership and canonical table dictionary.
- Confirm PostgreSQL version, extensions and hosting compatibility.
- Define timezone, currency, numeric precision and audit standards.
- Confirm migration tooling and release process.

### Phase 1 — foundation
1. Create schemas and migration metadata.
2. Create minimal shared reference structures without business values.
3. Create org organization and employee structures.
4. Create iam identity, permissions and authorization structures.
5. Create audit event structures.
6. Create platform integration settings/secret-reference/job/outbox foundations.

### Phase 2 — customer and commercial lifecycle
7. Create crm enquiry, contact, address, customer and conversion structures.
8. Create catalog product/manufacturer/model structures.
9. Create sales survey, design and quotation structures.
10. Create project projects, sites, milestones, tasks and scheduling.
11. Create gov application/subsidy tracking structures.

### Phase 3 — fulfilment and finance
12. Create supply suppliers, procurement and inventory ledger.
13. Create finance payment/receipt/expense structures.
14. Create install installation, inspection, commissioning and handover.
15. Create asset solar system, equipment and warranty structures.

### Phase 4 — operations after installation
16. Create monitor device, telemetry, analytics and alert structures.
17. Create service cases, work orders, visits and maintenance structures.
18. Create comms notification, template, consent and delivery structures.
19. Create files document, version, storage and signature structures.

### Phase 5 — hardening and optimization
20. Add remaining indexes, partitioning, views and reporting projections.
21. Add RLS policies only if approved and tested.
22. Add retention/archive jobs and reconciliation checks.
23. Run migration, rollback/forward-fix, backup/restore and load tests.

**Dependency note:** Actual migrations must follow FK dependencies, not this list blindly. For example, files may need minimal document-reference structures earlier if other domains reference document IDs; create the minimum table early or add FKs in a later migration. The same applies to audit, platform and org references.

## 12. Migration quality and release controls

Every migration must:
- Have a unique ordered identifier and description.
- Be reviewed in pull request.
- Avoid inserting business master or mock data.
- Add constraints/indexes with an appropriate online strategy for production size.
- Include a data backfill plan where needed.
- Define rollback or forward-fix plan.
- Be tested on a disposable database and representative volume.
- Avoid long blocking locks where possible.
- Record migration version and deployment metadata.
- Be deployed once by controlled CI/CD or migration operator, not by every API replica at startup.

For large tables, use concurrent index creation where supported, staged NOT NULL enforcement, batched backfills and explicit lock/timeout settings. Some PostgreSQL operations cannot run inside a transaction; migration tooling must support those cases.

## 13. Testing and data integrity strategy

### Schema and migration tests
- Fresh database can migrate to latest schema.
- Upgrade from previous release preserves data.
- Constraints reject invalid references and values.
- Unique/idempotency constraints prevent duplicate operations.
- Rollback or forward-fix procedure is tested.

### Domain integration tests
- Enquiry can exist without customer; conversion preserves history.
- Customer can have multiple addresses, contacts, sites and projects.
- Group grants, explicit denies and resource scopes work across APIs and workers.
- Quotation approval and project conversion are atomic.
- Stock movement and technician part usage cannot double-deduct.
- Finance receipts and allocations are atomic and auditable.
- Missing telemetry is not interpreted as zero.
- Alert recovery does not automatically resolve a service case.
- Provider acceptance is not treated as proof of delivery/read.
- Document versions remain immutable and unauthorized access is denied.
- Webhook replay and duplicate job execution do not duplicate business effects.

### Security and performance tests
- Cross-customer and cross-project access tests.
- Unauthorized file and export access tests.
- Query-plan review for critical list/detail endpoints.
- Load tests for telemetry ingestion, notification fanout and worker concurrency.
- Backup restore and point-in-time recovery test.
- Privileged action and audit integrity tests.

## 14. Reporting and read models

- Use database views or dedicated read models for dashboards; reporting queries must not mutate transactional records.
- Complex analytics may use materialized views or a separate reporting store when justified.
- Keep access scope in reporting queries; do not create unrestricted aggregate endpoints that expose personal data.
- Document freshness and refresh cadence for every materialized/read model.
- Financial reports must reconcile to authoritative finance transactions.
- Inventory reports must reconcile to stock movements.
- Monitoring summaries must preserve data-quality/missing-data indicators.

## 15. Open engineering decisions before SQL generation

1. Primary key standard: UUID, BIGINT identity, or internal BIGINT plus public UUID/reference?
2. PostgreSQL major version and hosting topology?
3. Is PostGIS or a time-series extension required and supported?
4. Expected customer, project, asset, device and telemetry volumes?
5. Expected notification fanout, background job volume and concurrency?
6. Which domains share one API service initially, and which require separate services/workers?
7. Which ORM/query/migration framework will be used with FastAPI?
8. How will RLS be used, if at all, alongside application authorization?
9. What are approved retention and partition intervals?
10. What are backup, point-in-time recovery, RPO and RTO targets?
11. Which fields require field-level encryption and search-by-hash?
12. Which financial/tax precision and rounding policies are approved?
13. Which reporting queries and dashboards are needed for first release?
14. Which existing ER documents need naming/relationship reconciliation before DDL?
15. Who signs off the canonical data dictionary and migration PRs?

## 16. Acceptance checklist

- [ ] All domains have clear schema/table/API ownership.
- [ ] Canonical names, PK strategy and physical types are approved.
- [ ] Every relationship has an explicit FK or documented controlled association.
- [ ] Delete behaviour is defined for business history.
- [ ] Unique, check and lifecycle constraints are documented.
- [ ] Critical query indexes are mapped to API access patterns.
- [ ] Telemetry partition/retention strategy is capacity-based.
- [ ] Money and measurement values use exact numeric types and explicit units.
- [ ] Transactions, idempotency and concurrency are defined for finance/stock/jobs.
- [ ] Outbox and worker execution are reliable and observable.
- [ ] Database roles and network access follow least privilege.
- [ ] Migration order respects FK dependencies.
- [ ] No mock/business seed data is inserted.
- [ ] Fresh-install, upgrade, backup/restore, security and load tests pass.
- [ ] Stakeholders approve unresolved technical and legal assumptions before production.

## 17. Next implementation artifact

After this blueprint is approved, produce the canonical data dictionary and migration backlog. Then generate SQL migrations in dependency-ordered batches, review each batch against the relevant ER design, and test it against a clean PostgreSQL database. Do not generate the entire production schema from conceptual diagrams in one unreviewed script.
