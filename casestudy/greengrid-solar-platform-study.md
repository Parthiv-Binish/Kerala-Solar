# GreenGrid Solar Platform — Feasibility & Implementation Case Study

**Client:** GreenGrid Solar Solutions, Erattupetta, Kottayam, Kerala  
**Prepared for:** Parthiv  
**Research date:** 22 November 2026  
**Status:** Working study. Items marked **VERIFY** must be checked before implementation or customer quotations.

> This is a product and architecture study, not legal, tax, electrical-engineering or regulatory advice. Applicability depends on consumer category, system capacity, application/feasibility date, DISCOM procedure and the exact notified text.

## 1. Executive summary

**Verdict: technically feasible.** Main risks are changing regulation, inconsistent manufacturer APIs/device models, unconfirmed government-portal APIs, messaging-provider policy/consent, and incomplete knowledge of GreenGrid's actual workflow and installed equipment.

### Recommended technology

| Area | Recommendation |
|---|---|
| Internal web | React + TypeScript |
| Backend | FastAPI (Python), modular monolith |
| Database | PostgreSQL |
| Time-series | TimescaleDB extension if volume justifies it |
| Cache / queue / fan-out | Redis |
| Background workers | ARQ initially; Celery only if complexity warrants |
| Customer + technician mobile | React Native |
| Live UI | WebSockets/SSE; Redis Pub/Sub for fan-out |
| Access control | Group-based RBAC + scope-aware ABAC; explicit deny overrides |
| Device integration | Official manufacturer cloud APIs + supported local Modbus gateways |
| Notifications | Official WhatsApp Business Platform, SMTP email, push; SMS optional |
| File storage | Private S3-compatible object storage |
| Hosting | VPS initially; offsite backups and object storage |

Build a **modular monolith**, not microservices, for the first release. Keep module boundaries so device ingestion, notifications or reporting can be extracted later.

The platform should become GreenGrid's operational system of record. Government portals, inverter clouds, payment services and messaging providers remain external systems. Store references, evidence, status history and follow-up tasks; do not claim to replace external systems.

The strongest differentiator is end-to-end transparency. An installation may be physically complete while inspection, agreement, meter installation, commissioning and subsidy are separate pending milestones. Staff and customers should see the exact blocker and next action.

## 2. Client context and assumptions

The supplied brief describes GreenGrid Solar Solutions in Erattupetta, Kottayam, with residential, commercial and industrial rooftop solar, on-grid, off-grid and hybrid systems, and solar water heaters. The website page text was not independently readable during the initial study; confirm the business range and workflow directly with the client.

Assumptions:
1. GreenGrid is a small installer/EPC and O&M provider.
2. It handles leads, surveys, quotations, installation coordination and post-installation support.
3. It works with multiple inverter, datalogger and battery brands.
4. No authorized E-Kiran or PM Surya Ghar API has been confirmed.
5. First release supports one company but is multi-tenant-ready.
6. Headcount, monthly project volume, existing CRM/accounting tools and device inventory are unknown.

**VERIFY with client:** product lines, service geography, headcount, project volume, existing tools, device models, and tasks performed by GreenGrid versus subcontractors.

---

# PART A — DOMAIN AND BUSINESS WORKFLOW

## 3. End-to-end rooftop solar lifecycle

### 3.1 Lifecycle stages

1. **Lead/enquiry:** source, contact, location, consumer category, electricity connection details, requirement and consent.
2. **Qualification:** system type (on-grid/off-grid/hybrid), capacity, roof type, budget, subsidy expectation and readiness.
3. **Site survey:** roof dimensions, shading, orientation, structure, cable route, electrical panel, grid phase, connected load, earthing and photos.
4. **Engineering design:** module layout, inverter selection, string sizing, cable/protection design, structure, generation estimate, storage sizing and compliance.
5. **Quotation:** BOM, labour, transport, taxes, exclusions, subsidy explanation, payment milestones, validity, timeline and warranty.
6. **Contract/booking:** acceptance, signed contract, advance and project creation.
7. **Utility/subsidy application:** customer guidance, portal references, application IDs, documents and follow-ups.
8. **Procurement:** purchase orders, supplier, serial numbers, delivery, inventory reservation and shortages.
9. **Installation planning:** crew, work order, schedule, safety checklist and material issue.
10. **Installation:** modules/inverter/battery, wiring, protection, earthing, labelling, testing and photos.
11. **Inspection/commissioning:** Electrical Inspectorate and DISCOM steps as applicable; track independently.
12. **Meter/grid connection:** agreement, meter availability, installation, synchronization and commissioning.
13. **Handover:** training, manuals, warranty cards, serial numbers, monitoring access, emergency contact and sign-off.
14. **O&M/AMC:** preventive maintenance, cleaning, remote monitoring, breakdowns and renewal.
15. **Warranty/RMA:** fault evidence, manufacturer case, RMA, replacement, installation and closure.

### 3.2 Project lifecycle process map

~~~mermaid
flowchart TD
 A[Lead / enquiry] --> B{Qualified?}
 B -- No --> B1[Record reason / nurture]
 B -- Yes --> C[Site survey]
 C --> D[Engineering design]
 D --> E[Quote and proposal]
 E --> F{Customer accepts?}
 F -- No --> F1[Revise / lost reason]
 F -- Yes --> G[Contract and advance]
 G --> H[Utility and subsidy tracking]
 H --> I[Procurement]
 I --> J[Installation work order]
 J --> K[Install and test]
 K --> L[Inspection / evidence]
 L --> M[Agreement and meter]
 M --> N[Grid commissioning]
 N --> O[Handover]
 O --> P[Monitoring / AMC / support]
 P --> Q[Warranty / service / renewal]
~~~

### 3.3 Roles and pain points

| Role | Responsibilities | Pain points | Platform support |
|---|---|---|---|
| Owner/admin | Pipeline, approvals, staff, profitability | No single source of truth | Executive dashboard, audit |
| Sales | Leads, follow-ups, quotes | Missed follow-ups | CRM, reminders, templates |
| Surveyor/designer | Survey, layout, sizing | Repeated data collection | Digital survey and attachments |
| Project manager | Schedule, procurement, crew | Coordination delays | Project board and dependencies |
| Technician | Installation, troubleshooting | Poor connectivity, incomplete records | Offline mobile work orders |
| Accounts | Invoices, receipts, dues | Project/payment mismatch | Ledger and reconciliation |
| Support | Complaints, monitoring, warranty | No history or ownership | Unified case desk |
| Customer | Track project, generation, support | Low transparency | Customer portal/app |

### 3.4 Business-line differences

| Line | Distinction | Platform implications |
|---|---|---|
| Residential grid-connected | Household consumer, subsidy eligibility, DISCOM metering | Portal references and subsidy tracker |
| Commercial | Generally outside residential CFA; load profile and ROI | Tariff assumptions, consumption and commercial contract |
| Industrial | Larger engineering/protection and approvals | Multi-site, detailed design and compliance gates |
| Off-grid | No normal grid export/net-metering path | Battery autonomy and charge-controller monitoring |
| Hybrid | Grid + PV + storage + backup logic | Battery/inverter compatibility and modes |
| Solar water heater | Thermal system, not PV generation monitoring | Separate product, service and warranty workflow |

### 3.5 Post-sales and cases

AMC should track contract dates, coverage, visit frequency, exclusions, renewals, service history and payment. Cleaning schedules should follow contract, site and manufacturer conditions; record before/after photos, date, technician and acknowledgement. Do not promise a universal frequency.

Inverter fault workflow: alert/complaint → validate telemetry → triage → remote resolution or visit → parts/RMA → test → closure.

Warranty/RMA records should include component serial, warranty dates, proof of purchase, commissioning date, manufacturer case, evidence, shipment, replacement serial and closure.

Use one case engine with categories:
- Enquiry/sales follow-up
- Site survey/design change
- Installation issue
- Utility/inspection/meter/commissioning
- Subsidy/documentation
- Inverter/battery/generation alert
- Cleaning/AMC/preventive maintenance
- Warranty/RMA
- Billing/payment
- Customer complaint

Each case needs source, customer, project/site, category, priority, status, assigned group/user, SLA, due date, timeline, attachments, internal notes, customer-visible updates, escalation and closure code.

### 3.6 Field visit process

~~~mermaid
flowchart TD
 A[Case created] --> B[Triage]
 B --> C{Remote fix possible?}
 C -- Yes --> D[Remote resolution]
 C -- No --> E[Create field visit]
 E --> F[Assign technician and slot]
 F --> G[Technician accepts]
 G --> H[Travel / check-in]
 H --> I[Checklist, readings, photos]
 I --> J{Parts required?}
 J -- Yes --> K[Request / issue parts]
 K --> I
 J -- No --> L[Customer sign-off]
 L --> M[Supervisor review]
 M --> N[Close case]
~~~

---

# PART B — GOVERNMENT, UTILITY AND COMPLIANCE

## 4. PM Surya Ghar and KSEB

### 4.1 Scheme relationship

- **PM Surya Ghar: Muft Bijli Yojana** is the central residential rooftop solar CFA/subsidy programme.
- **Soura** is KSEB's rooftop solar programme/process in Kerala; it is not a separate central-style subsidy.
- **E-Kiran** is KSEB's online rooftop solar application/clearance and tracking portal.
- National Portal registration and scheme requirements apply to vendors installing under the central CFA programme.

Official starting points:
- [PM Surya Ghar National Portal](https://pmsuryaghar.gov.in/)
- [KSEB E-Kiran](https://ekiran.kseb.in/)
- [MNRE](https://mnre.gov.in/)
- [PIB](https://pib.gov.in/)

### 4.2 Residential CFA reference

MNRE residential subsidy reference for Kerala (non-special-category state):

| Eligible residential capacity | CFA reference |
|---:|---:|
| 1 kW | ₹30,000 |
| 2 kW | ₹60,000 |
| 3 kW and above | ₹78,000 maximum |

This is not a commercial/industrial subsidy. Standalone off-grid systems and solar water heaters are not automatically eligible under the grid-connected residential CFA component. Hybrid eligibility must be checked against exact scheme configuration and current guidelines.

**VERIFY:** current scheme continuation, application cutoff, eligible modules/inverters, vendor obligations, consumer eligibility, bank requirements and portal procedure before quoting. The study brief identifies FY 2026–27 / 31 March 2027 as the scheme horizon; confirm the latest MNRE order.

### 4.3 Indicative national workflow

~~~mermaid
flowchart TD
 A[Consumer registers on National Portal] --> B[Select DISCOM and apply]
 B --> C[Feasibility / deemed acceptance where applicable]
 C --> D[Select registered vendor]
 D --> E[Survey and design]
 E --> F[Installation and testing]
 F --> G[Upload plant details and geo-tagged evidence]
 G --> H[DISCOM inspection]
 H --> I[Metering / connectivity agreement]
 I --> J[Commissioning approval]
 J --> K[Consumer submits bank details and cancelled cheque]
 K --> L[CFA processing]
~~~

MNRE guidelines describe vendor registration, installation, documentation and commissioning responsibilities. The 15-day CFA processing period referenced in guidelines is measured after DISCOM approval; it is not an end-to-end project-duration promise.

### 4.4 Deemed feasibility

The Electricity (Rights of Consumers) Amendment Rules, 2024 provide deemed acceptance for complete rooftop solar applications up to 10 kW without a technical feasibility study. Above 10 kW, feasibility assessment is subject to a 15-day timeframe and deemed-feasibility provision.

Operational implementation and portal procedure must be checked with the DISCOM and regulatory directions. Do not infer that a customer's application is approved solely from capacity.

Software should store separate values: deemed-feasibility eligibility, portal feasibility status, official approval reference, approval date and last verified date. The portal/DISCOM record remains authoritative.

### 4.5 E-Kiran workflow — separate milestones

| Milestone | Evidence/status |
|---|---|
| Consumer application | Portal application ID, submission date |
| Feasibility | Approval/correction/rejection |
| Vendor selection | Vendor selection reference |
| Installation | Work completion date, system details |
| Completion submission | Forms, photos, test reports |
| Inspection | Requested date, result, observations |
| Agreement | Copy and signing date |
| Meter | Type, availability, installation date, serial |
| Commissioning | Certificate/reference and date |
| Subsidy | National portal status, bank submission, payment date |

**VERIFY:** exact current E-Kiran stages, form names, fee schedule, document list, timelines, vendor eligibility and live portal changes. Do not hardcode assumed form names without checking current instructions.

### 4.6 Meter shortages and delay management

Media reports in September 2026 cited more than 2,000 stalled domestic installations in Kannur and around 50,000 applicants statewide waiting for meters. These are reported figures, not live official KSEB inventory.

Build a pending-meter/subsidy tracker: installation completion date, inspection/agreement status, meter type/phase, meter application date, availability/follow-up, KSEB subdivision reference, ageing bucket, customer updates and subsidy stage/payment status.

Suggested ageing: 0–7, 8–15, 16–30, 31–60 and over 60 days.

### 4.7 KSERC final regulations — critical design reference

Use the **final Gazette**, not draft consultation documents:

[KSERC Renewable Energy and Related Matters Regulations, 2025 — final Gazette PDF](https://dev.erckerala.org/api/storage/final-regulations/BDm5OZBLIuAbHoyTX0xoploDz82DbFy1O6klxxfS.pdf)

The study identified this as Kerala Gazette Extraordinary No. 3944, dated 6 November 2025. A later July 2026 web listing should not be mistaken for the notification date.

Key items identified in the final regulation:

| Topic | Study finding — verify exact clauses before implementation |
|---|---|
| Domestic net metering | 1–20 kW subject to connected load and conditions |
| Industrial net metering | 1–500 kW subject to conditions |
| Agriculture net metering | 1–3,000 kW subject to conditions |
| Gross metering / net billing | Separate arrangements under specified conditions |
| Group net metering / virtual net metering | Recognised subject to eligibility and procedure |
| Behind-the-meter | Recognised |
| VPP / peer-to-peer / V2G | Pilot/detailed procedure provisions; do not assume generally available |

Domestic storage provisions identified in the final text:
- Above 5 kW up to 10 kW: hybrid inverter and at least 10% storage capacity for feasibility applications from 1 April 2027.
- Above 10 kW up to 15 kW: 10% storage condition.
- Above 15 kW up to 20 kW: 20% storage condition.
- Other capacity bands and industrial requirements need clause-by-clause verification.

The regulation uses a 19% capacity utilisation factor (CUF) in the relevant storage calculation. Do not implement storage sizing as a generic percentage of nominal battery kWh without implementing the actual formula and units from the Gazette.

The regulation also includes grid-support charge provisions and special treatment for certain domestic capacity/application-date bands. The study identified 50 paise/kWh for the first 300 units and ₹1/kWh for balance units in the applicable provision. **VERIFY** exact applicability, commencement and billing method before quoting.

### 4.8 Draft-to-final change management

Do not rely on draft summaries claiming a universal 3 kW net-metering cap or blanket battery mandate. The final regulation controls. Maintain versioned rules with effective dates, consumer category, capacity bands, metering type, storage condition, formula, source clause and verification date.

### 4.9 ANERT, Electrical Inspectorate, MNRE/BIS/ALMM

- **ANERT:** State nodal agency and programme/technical role. **VERIFY** current responsibilities for each scheme, subsidy, training and vendor activity.
- **Electrical Inspectorate:** inspection/safety requirements depend on system size, installation type and electrical rules. **VERIFY** thresholds, forms, test reports, inspector jurisdiction and sequence.
- **MNRE/BIS/ALMM:** module eligibility, approved lists, BIS standards, inverter protection, testing and procurement obligations depend on scheme and applicable orders. Store make/model, serial, certificates and procurement evidence. **VERIFY** current ALMM list/order and effective dates.
- **KSEB:** distribution feasibility, interconnection, agreement, meter and commissioning.
- **MNRE:** national scheme, vendor registration and CFA.
- **KSERC:** state regulatory framework and tariff/metering rules.

### 4.10 GST and invoicing

Do not apply one blanket GST percentage to all invoices.

The study found solar water heaters under HSN 8419 12 listed at 12% GST (6% CGST + 6% SGST). Specified renewable-energy composite supply treatment can use a 70% goods / 30% service valuation split for qualifying contracts, with different applicable rates on components.

**VERIFY with a GST practitioner:** current notifications, HSN/SAC, exact EPC composite-supply eligibility, goods/service split, input tax credit, separate supply, labour/AMC/repair and solar water-heater classification. Keep tax rules configurable and effective-dated.

### 4.11 DPDP, messaging, privacy and cyber obligations

The platform processes names, contact details, addresses, electricity references, bills, photos, location, device IDs, payments and service history.

Design for clear privacy notice, purpose limitation, consent/other lawful-basis records where applicable, data minimisation, access control/audit, correction/erasure request handling subject to retention, processor/vendor contracts, security safeguards, incident response, retention/deletion schedule, breach assessment/notification, child-data handling if minors can use accounts, and grievance contact.

**VERIFY:** DPDP Act/Rules commencement notifications and phased applicability as of deployment. Do not assume every provision commenced simultaneously.

WhatsApp:
- Use official WhatsApp Business Platform/Cloud API for production.
- Obtain and record opt-in for business-initiated messages.
- Use approved templates outside the customer-service window.
- Respect the 24-hour customer-service window and current template/category/pricing rules.
- Store template version, language, provider message ID, delivery/read/failure state and consent evidence.

SMS: follow applicable TRAI commercial communication/DLT requirements, including entity/header/template registration where required. **VERIFY** current operator/aggregator onboarding.

### 4.12 Government portal integration stance

No public supported API for E-Kiran or the PM Surya Ghar National Portal was confirmed during this study.

**Default: manual entry + status mirror + document vault + reminders + audit.**
- Store portal reference IDs and URLs.
- Store operator, date/time and last verified status.
- Upload acknowledgements and certificates.
- Keep status history.
- Add a “verified against portal” action.
- Do not scrape, automate browser sessions, reuse credentials or bypass access controls.
- Integrate only if an authority publishes an API and grants authorized access.

---

# PART C — DEVICE MONITORING

## 5. Inverter, meter and battery monitoring

### 5.1 Device ecosystem

Candidate brands named in the brief include Growatt, Solis, Sungrow, Huawei, Luminous, Waaree, Havells and Delta. Other brands may be present. Do not assume every product from a brand exposes the same API/protocol. Integration depends on exact model, firmware, datalogger, region, account permissions and installer access.

### 5.2 Integration options

| Route | Advantages | Risks/limitations | Recommendation |
|---|---|---|---|
| Manufacturer cloud API | No local gateway; broad reach | Vendor approval, quotas, cloud outages, polling limits | First choice when officially supported |
| Modbus TCP/RTU | Local data, low latency, cloud-independent | Register maps vary; gateway and network safety | Use for supported sites |
| SunSpec Modbus | Standardised models for supported devices | Implementation varies by device | Prefer when supported |
| MQTT gateway | Efficient event transport | Gateway provisioning/security | Internal ingestion protocol |
| Manual readings | Works for unsupported devices | Low frequency, human error | Fallback only |

### 5.3 Vendor integration status — initial research

| Brand | Route identified | Design note |
|---|---|---|
| Solis | Official developer/API portal | Obtain approval; verify endpoint, quota and granularity |
| Sungrow | Official developer platform/API materials | Confirm plant/device authorization and rate limits |
| Huawei FusionSolar | Northbound API | Access must be enabled/authorized by company administrator |
| Growatt | Cloud/API availability varies | **VERIFY** official supported API and terms for exact model |
| GoodWe | SEMS/API pathways may be available | **VERIFY** authorization and terms |
| Luminous | Model-specific monitoring | **VERIFY** API/local protocol |
| Waaree | Product/model-specific | **VERIFY** |
| Havells | Product/model-specific | **VERIFY** |
| Delta | Product/model-specific | **VERIFY** |

Official starting points:
- [SolisCloud](https://www.soliscloud.com/)
- [Sungrow Developer](https://developer.sungrowpower.com/)
- [Huawei FusionSolar](https://solar.huawei.com/)
- [SunSpec Alliance](https://sunspec.org/)

Do not make unofficial community endpoints a production dependency without legal, security and reliability review.

### 5.4 Recommended hybrid ingestion

1. Manufacturer cloud connectors poll supported APIs at approved intervals.
2. Local gateway reads Modbus TCP/RTU where supported.
3. Gateway normalises vendor-specific fields into a canonical schema.
4. Ingestion API authenticates gateway/device and validates tenant, site, device and timestamps.
5. Redis Streams or durable outbox processes ingestion.
6. PostgreSQL/TimescaleDB stores telemetry.
7. Rules engine evaluates offline, underperformance and fault conditions.
8. Case engine creates/deduplicates cases.
9. WebSocket/SSE delivers UI updates.

~~~mermaid
flowchart LR
 A[Inverter / meter / battery] --> B[Manufacturer cloud]
 A --> C[Local Modbus gateway]
 B --> D[Cloud connector workers]
 C --> E[MQTT / HTTPS gateway]
 D --> F[Normalisation and validation]
 E --> F
 F --> G[Redis Streams / durable queue]
 G --> H[PostgreSQL + TimescaleDB]
 H --> I[Alert rules engine]
 I --> J[Case / SLA engine]
 H --> K[WebSocket / SSE]
 J --> L[Notification service]
 K --> M[Staff web / customer app]
 L --> M
~~~

### 5.5 Canonical telemetry model

Entities: sites, energy_systems, devices, device_models, device_credentials (encrypted), device_connectors, telemetry_measurements, device_status_events, device_fault_events, alert_rules, alert_instances and ingestion_runs.

Measurement fields: tenant_id, site_id, device_id, measured_at (UTC), received_at (UTC), metric_key (e.g. pv_power_kw, daily_energy_kwh, battery_soc_pct), value, unit, quality, source and optional protected raw-payload reference.

Store energy and power separately. Define units and Asia/Kolkata display timezone explicitly.

### 5.6 Storage choice and retention

| Option | Fit |
|---|---|
| Plain PostgreSQL | Best start for low/moderate volume |
| TimescaleDB | Recommended if volume, retention, aggregates and time-window queries justify it |
| ClickHouse | Later for high-volume analytical workloads, not MVP |

Starting retention assumptions (not legal requirements): raw high-frequency telemetry 30–90 days; 5/15-minute aggregates 1–2 years; daily/monthly summaries long-term; fault events and commissioning evidence per warranty/legal policy.

### 5.7 Alert logic

| Alert | Rule concept | Safeguard |
|---|---|---|
| Device offline | No heartbeat beyond model-specific threshold | Ignore maintenance; debounce |
| Underperformance | Actual vs irradiance-adjusted expectation or baseline | Require data quality and sustained deviation |
| Inverter fault | Manufacturer fault code | Map severity by model |
| Grid fault | Repeated voltage/frequency/protection event | No unsafe automatic reset |
| Battery fault | BMS alarm, temperature, SOC anomaly | Escalate safety events |
| Zero generation | Daylight + expected generation + no output | Exclude night, weather and shutdown |

Requirements: debounce, hysteresis, deduplication by device/rule/window, maintenance suppression, severity/confidence, auto-ticket threshold, acknowledgement, resolution and reopen policy. Safety-critical events require human review.

---

# PART D — GROUP-BASED ACCESS CONTROL

## 6. Recommended authorization model

### 6.1 Compare models

| Model | Question answered | Strength | Limitation |
|---|---|---|---|
| RBAC | What can this role do? | Simple permissions | Weak data scope alone |
| ABAC | Do attributes/context permit action? | Flexible conditions | Can be hard to administer |
| ReBAC | What relationship exists to the object? | Natural ownership/team relationships | More complex policy graph |
| AD-style groups | Which groups is user in? | Flexible organisation | Needs scope policy |

**Recommendation:** group-based RBAC with ABAC-style scopes. Add relationship checks for customer/site/project ownership where useful.

### 6.2 Evaluation rules

1. Authenticate user and tenant.
2. Load active group memberships.
3. Collect group permission grants.
4. Evaluate object scope (own/team/branch/all).
5. Evaluate contextual conditions.
6. Apply explicit deny rules; deny wins.
7. Audit sensitive actions.
8. Filter database queries before returning rows.

Do not fetch all rows and filter only in React.

### 6.3 Arun: Technician + Staff example

| Group | Permission | Scope |
|---|---|---|
| Technician | case.read | assigned_to_me OR assigned_team |
| Technician | case.update | assigned_to_me OR assigned_team |
| Staff | case.read | all |
| Staff | customer.read | all |
| Staff | project.read | all |

Effective case.read scope is all because Staff grants all. Technician-specific actions remain available. An explicit deny for a restricted case overrides allow.

If Staff should see all operational cases but not confidential HR/legal cases, define a classification condition or deny rule. Group names alone are insufficient.

### 6.4 Suggested schema

Entities: users, groups, group_memberships (effective dates/status), permissions, group_permission_grants, scope_definitions, policy_conditions, explicit_deny_rules, user_delegations, temporary_elevations, audit_logs, teams and branches.

Illustrative SQL:

~~~sql
users(id, tenant_id, email, display_name, is_active)
groups(id, tenant_id, name, description)
group_memberships(id, user_id, group_id, valid_from, valid_until, is_active)
permissions(id, code, description)
group_permission_grants(id, group_id, permission_id, scope_type, conditions_json)
explicit_deny_rules(id, subject_type, subject_id, permission_id, resource_type, conditions_json)
teams(id, tenant_id, name)
user_teams(user_id, team_id)
branches(id, tenant_id, name)
audit_logs(id, actor_id, action, resource_type, resource_id, before_json, after_json, created_at)
~~~

### 6.5 FastAPI enforcement

Use dependencies such as require_permission("case.read"), a request-scoped authorization context, and repository/query helpers applying tenant and scope predicates. Use SQLAlchemy query filters or explicit query-builder functions. Cache permission snapshots in Redis with short TTL and membership-version invalidation. Never trust client-supplied tenant/user/scope/role claims. Enforce tenant isolation at every query boundary; consider PostgreSQL Row Level Security as defence in depth. Audit privilege elevation and sensitive exports.

Delegation specifies delegator, delegate, permission set, resource scope, start/end, reason, approval and audit reference. Temporary elevation is time-limited, reason-bound, approval-gated for sensitive permissions and automatically expires.

Test union/deny precedence, own/team/branch/all, cross-tenant isolation, expired memberships, delegation expiry, elevation audit, SQL-level row filtering and Arun's Technician + Staff case.

---

# PART E — ARCHITECTURE AND IMPLEMENTATION

## 7. Application architecture

### 7.1 Modular monolith modules

1. Identity/access
2. CRM/leads
3. Customer/site/project
4. Survey/engineering
5. Quotations/contracts
6. Procurement/inventory
7. Installation/work orders
8. Utility/subsidy tracker
9. Cases/field service/SLA
10. Devices/telemetry
11. Notifications
12. Billing/payments
13. Documents
14. Reports/audit/settings

~~~mermaid
flowchart TB
 U[Staff web] --> API[FastAPI application]
 C[Customer / technician mobile] --> API
 API --> AUTH[Identity and policy]
 API --> CRM[CRM / projects / quotes]
 API --> OPS[Installation / utility / cases]
 API --> DEV[Device monitoring]
 API --> NOTIF[Notification service]
 API --> DB[(PostgreSQL)]
 API --> REDIS[(Redis)]
 REDIS --> WORKERS[ARQ workers]
 WORKERS --> EXT[WhatsApp / SMTP / SMS / cloud APIs]
 DEV --> TS[(TimescaleDB extension)]
 API --> OBJ[Private object storage]
 WORKERS --> OBJ
~~~

### 7.2 Redis responsibilities

Cache permissions, lookup data and dashboard summaries; queue background tasks/retries; Pub/Sub low-latency fan-out; Streams durable consumer-group processing; rate limits/provider quotas; distributed locks for duplicate scheduled work. Redis must not be the only permanent store for business events, payments, notifications or audit logs.

### 7.3 Worker comparison

| Worker | Advantages | Trade-offs | Decision |
|---|---|---|---|
| ARQ | Async Python, Redis, simple FastAPI fit | Smaller ecosystem | MVP |
| RQ | Very simple Redis queue | Less async-native | Simple sync tasks |
| Celery | Mature scheduling, routing, retries | More operations | Phase 2 if needed |

### 7.4 Notification service

Provider abstraction: NotificationProvider.send(template, recipient, variables, context).

Providers: WhatsApp Cloud API (primary), SMTP email, SMS (optional), push (FCM/APNs), OpenWA/unofficial gateway (development/controlled experiment only).

Store event ID, recipient/channel, consent/purpose, template ID/version/language, provider/message ID, idempotency key, attempts, next retry, delivery/read/failure state and error code.

**OpenWA warning:** unofficial WhatsApp Web automation can violate platform terms, break after WhatsApp changes, lose sessions and expose the number to restrictions. It is not a reliable production failover. Use email/SMS/push as compliant fallbacks. If retained for an experiment, isolate it and do not promise delivery.

Use exponential backoff with jitter, respect provider retry-after/rate limits, idempotency, dead-letter queue, audited replay and webhook validation.

### 7.5 WhatsApp rules

Obtain and record opt-in before business-initiated messages. Use approved templates outside the customer-service window. Follow current service-message rules within the 24-hour window. Keep opt-out records. Utility templates may cover project updates, appointments and receipts where classification is approved; do not classify marketing as utility. Re-check Meta template categories, pricing, quality rules and country charges before launch.

### 7.6 Customer and technician mobile

**Recommendation: React Native.** It reuses the React/TypeScript ecosystem, shares API types and validation patterns, and has mature camera, file, push and offline libraries. Flutter is viable if the team prefers Dart or has strong custom UI needs. Do not maintain both.

Technician app: assigned work orders, offline checklist, local drafts/photos, upload queue, customer sign-off, necessary transparent location capture, conflict resolution for offline edits.

Customer app: project timeline, system status/generation, daily/monthly charts, savings estimate with assumptions, documents/warranty, service request, appointment status, invoice/payment history, notifications and consent settings.

### 7.7 Auth and sessions

Phone OTP for customers; email/password or SSO for staff; short-lived access token; rotating/revocable refresh tokens; device/session management; MFA for administrators; OTP abuse controls; Argon2id if passwords are used. Do not put sensitive information or long-lived secrets in JWT payloads.

### 7.8 Multi-tenancy

Include tenant_id on business entities; enforce in repositories; tenant-aware unique constraints; tenant-scoped object storage; tenant context in jobs/events/logs/cache keys; cross-tenant isolation tests.

### 7.9 Documents

Private object storage for electricity bills, survey photos, quotes/contracts, invoices/receipts, purchase records, serial/warranty evidence, inspection reports, agreements, meter evidence, commissioning certificates, AMC and service reports. Use signed URLs, MIME/size checks, malware scanning where practical, encryption, retention policy and access audit.

### 7.10 Backup, security and operations

Automated daily PostgreSQL backup; WAL/PITR if budget allows; encrypted offsite backup; periodic restore test; secrets outside Git; TLS; firewall; SSH key-only access; least-privilege service accounts; dependency/container scanning; structured logs; health checks; alerting; error tracking; audit privileged actions; CI tests; migrations/rollback; separate staging and production.

### 7.11 VPS sizing

Initial single-company deployment: 2–4 vCPU, 4–8 GB RAM, 80–160 GB NVMe, Ubuntu LTS, Docker Compose/systemd. Prefer 4 vCPU / 8 GB if affordable. Keep object storage and backups off-host. Separate or managed database as load and recovery requirements grow.

---

## 8. Data model and ER diagram

~~~mermaid
erDiagram
 TENANT ||--o{ USER : has
 TENANT ||--o{ CUSTOMER : has
 TENANT ||--o{ GROUP : has
 USER }o--o{ GROUP : member_of
 GROUP }o--o{ PERMISSION : grants
 CUSTOMER ||--o{ SITE : owns
 SITE ||--o{ PROJECT : has
 PROJECT ||--o{ QUOTATION : has
 PROJECT ||--o{ WORK_ORDER : schedules
 PROJECT ||--o{ UTILITY_APPLICATION : tracks
 PROJECT ||--o{ DOCUMENT : contains
 SITE ||--o{ ENERGY_SYSTEM : contains
 ENERGY_SYSTEM ||--o{ DEVICE : contains
 DEVICE ||--o{ TELEMETRY : emits
 DEVICE ||--o{ ALERT : raises
 ALERT ||--o| CASE : may_create
 CUSTOMER ||--o{ CASE : raises
 PROJECT ||--o{ CASE : relates_to
 CASE ||--o{ CASE_EVENT : has
 CASE ||--o{ FIELD_VISIT : schedules
 CUSTOMER ||--o{ INVOICE : receives
 INVOICE ||--o{ PAYMENT : has
 CASE ||--o{ NOTIFICATION : triggers
 PROJECT ||--o{ NOTIFICATION : triggers
 USER ||--o{ AUDIT_LOG : performs
~~~

Additional entities: group_memberships, group_permission_grants, explicit_deny_rules, teams, branches, user_teams, device_models, device_connectors, device_credentials, alert_rules, alert_instances, ingestion_runs, amc_contracts, maintenance_plans, warranty_claims, rma_records, inventory_items, stock_movements, purchase_orders, regulatory_rules, portal_status_history, notification_templates, notification_attempts, consent_records, user_delegations and temporary_elevations.

## 9. API outline

Version endpoints under /api/v1.

| Module | Example endpoints |
|---|---|
| Auth | POST /auth/otp/request, POST /auth/otp/verify, POST /auth/refresh, POST /auth/logout |
| Users/groups | GET /users, POST /groups, POST /groups/{id}/members, POST /groups/{id}/permissions |
| Leads | POST /leads, GET /leads, PATCH /leads/{id} |
| Customers/sites | POST /customers, POST /customers/{id}/sites, GET /sites/{id} |
| Surveys | POST /sites/{id}/surveys, POST /surveys/{id}/submit |
| Quotes | POST /projects/{id}/quotes, POST /quotes/{id}/accept |
| Projects | GET /projects, GET /projects/{id}/timeline |
| Utility | POST /projects/{id}/utility-applications, POST /utility-applications/{id}/status-events |
| Work orders | POST /projects/{id}/work-orders, POST /work-orders/{id}/complete |
| Cases | POST /cases, POST /cases/{id}/assign, POST /cases/{id}/events, POST /cases/{id}/close |
| Devices | POST /devices, POST /ingestion/telemetry, GET /sites/{id}/devices |
| Telemetry | GET /devices/{id}/measurements, GET /sites/{id}/energy-summary |
| Alerts | GET /alerts, POST /alerts/{id}/acknowledge |
| Notifications | POST /notifications/test, GET /notifications/{id} |
| Documents | POST /documents/presign, POST /documents/{id}/complete |
| Billing | POST /invoices, POST /invoices/{id}/payments, GET /customers/{id}/ledger |
| Audit | GET /audit-logs |

All endpoints enforce tenant, permission and resource-scope filters. Use pagination, idempotency keys for payment/notification/webhook operations and consistent errors.

---

# PART F — DELIVERY PLAN

## 10. MoSCoW priorities

### MVP — Must have
- Staff login, user management and group memberships
- Permission grants and scope enforcement
- Leads and customer records
- Sites and projects
- Site survey with photos
- Quotations and project status
- Installation work orders/checklists
- Utility/subsidy tracker with manual portal references
- Document vault
- Case/ticket management, assignment and basic SLA
- Official WhatsApp/email notifications
- Responsive customer portal
- Audit trail
- Basic reports and backup/restore

### Phase 2 — Should have
- React Native customer/technician app
- Offline technician workflows
- Manufacturer cloud connectors for actual installed brands
- Device telemetry dashboards
- Automated alerts and case creation
- AMC and cleaning schedules
- Warranty/RMA workflows
- Inventory and purchase orders
- Payment reconciliation/customer ledger
- Push notifications
- Advanced scope/delegation/elevation

### Phase 3 — Could have
- Local Modbus gateway product
- Advanced energy analytics/performance benchmarking
- Weather/irradiance-based yield expectations
- Multi-branch and multi-company tenancy
- Profitability and forecasting
- Customer appointment scheduling
- Manufacturer RMA integrations
- Versioned regulatory compliance engine
- Additional languages and voice workflows

### Not in initial release
- Replacing KSEB/MNRE portals
- Unauthorized scraping or portal automation
- Guaranteeing subsidy approval or meter timelines
- Supporting every inverter model before inventory is known
- Microservices before scale requires them
- Unofficial WhatsApp automation as primary production channel

## 11. Roadmap and effort

Indicative effort for a solo developer with occasional design/QA support:

| Phase | Scope | Estimate |
|---|---|---:|
| 0 Discovery | Interviews, workflow, data inventory, wireframes | 1–2 weeks |
| 1 Foundation | Repo, auth, tenant model, groups, audit, CI/CD | 2–3 weeks |
| 2 Core operations | CRM, customer/site/project, survey, quote | 3–5 weeks |
| 3 Delivery operations | Work orders, utility tracker, documents | 3–4 weeks |
| 4 Cases/comms | Case engine, SLA, WhatsApp/email | 2–4 weeks |
| 5 Customer portal | Timeline, docs, service request | 2–3 weeks |
| 6 Monitoring pilot | 1–2 inverter integrations, telemetry, alerts | 3–6 weeks |
| 7 Mobile/offline | Technician/customer app | 4–7 weeks |
| 8 Hardening | Security, restore tests, UAT, production | 2–3 weeks |

A usable operational MVP is approximately **11–18 weeks** for one experienced developer, depending on parallel work and client response. Full monitoring and mobile offline capability are a larger follow-on programme.

## 12. Indicative operating costs

Planning ranges, not vendor quotes; taxes, exchange rates, usage and discounts change.

| Item | Early-stage monthly estimate |
|---|---:|
| VPS 4 vCPU / 8 GB | ₹800–₹2,000 |
| Object storage/backups | ₹200–₹800 |
| Domain amortised | ₹50–₹150 |
| SMTP | Free tier to ₹500 |
| Redis | Included on VPS initially |
| Monitoring/error tracking | Free tier to ₹500 |
| WhatsApp | Variable by template category, country, volume and Meta pricing |
| SMS | Variable by DLT/aggregator and volume |
| Push | Usually no per-message fee at modest scale |
| Apple Developer Program | USD 99/year, subject to current terms/taxes |
| Google Play Console | USD 25 one-time registration, subject to current terms |

Planning baseline: **₹1,500–₹4,000/month** before messaging volume, taxes and app-store costs, with one VPS and modest object storage.

Do not hardcode a WhatsApp rate. Model utility, authentication, marketing and service messages by recipient country, Meta pricing and BSP markup. Use WhatsApp for project updates, installation schedules, milestone changes, service tickets, appointments and receipts. Keep marketing opt-in separate.

Growth path: (1) one VPS, Postgres, Redis, API/workers and offsite backups; (2) separate/managed Postgres, object storage and dedicated worker; (3) redundant app instances, managed database, queue monitoring, restore drills and documented recovery objectives.

## 13. Open questions for GreenGrid

### Business/team
1. How many staff and what are their designations?
2. Who reports to whom? Teams, branches or contractors?
3. Who sees all customers/projects versus assigned work only?
4. Average monthly leads, installations and service cases?
5. Which districts are served?

### Products/engineering
6. Which inverter brands and exact models are installed most often?
7. Which batteries, meters and dataloggers are used?
8. Can GreenGrid access monitoring accounts, or only customers?
9. Do installations expose Modbus TCP/RTU or SunSpec?
10. Is solar water heating a separate business line?

### Existing operations
11. Are leads in Excel, WhatsApp, paper, CRM or accounting software?
12. How are quotes, invoices and receipts created?
13. How are inventory and serial numbers tracked?
14. What is the installation checklist?
15. How are KSEB and subsidy IDs/statuses recorded?
16. Who handles manufacturer warranty/RMA?

### Customer/communications
17. Is there an existing WhatsApp Business number?
18. Is customer opt-in already collected?
19. Is responsive web enough for MVP, or is mobile required immediately?
20. What must technicians access offline?

### Commercial
21. Typical project value and payment milestones?
22. Is AMC offered and what does it cover?
23. Are there service, inspection or cleaning charges?
24. Target software/hosting budget?

---

## 14. Security and compliance checklist

### Identity/access
- [ ] Staff MFA for privileged accounts
- [ ] Group membership review and expiry
- [ ] Deny-overrides-allow tests
- [ ] Tenant and row-level filtering
- [ ] Temporary elevation with approval/expiry
- [ ] Sensitive-action audit

### Customer data
- [ ] Privacy notice and purpose mapping
- [ ] Consent/opt-in records
- [ ] Customer access/correction/erasure workflow
- [ ] Retention/deletion schedule
- [ ] Processor agreements
- [ ] Incident/breach response
- [ ] Child-data assessment

### Application security
- [ ] TLS and secure token storage
- [ ] Password hashing and OTP rate limits
- [ ] Input validation and upload checks
- [ ] Secrets outside Git
- [ ] Dependency scanning
- [ ] Admin audit trail
- [ ] API rate limits
- [ ] Signed URLs/private storage

### Infrastructure
- [ ] Firewall and least privilege
- [ ] Encrypted offsite backups
- [ ] Restore test
- [ ] Monitoring/alerting
- [ ] Log retention/redaction
- [ ] Staging/production separation
- [ ] Migration/rollback plan

### Electrical/field safety
- [ ] Never operate electrical equipment solely from unverified cloud telemetry
- [ ] No remote reset/isolation in MVP
- [ ] Manufacturer safety instructions retained
- [ ] Technician safety checklist/sign-off
- [ ] Fault alerts classified by severity
- [ ] Battery thermal/safety incidents escalated to a human immediately

---

## 15. VERIFY register

| Item | Required verification |
|---|---|
| PM Surya Ghar deadline/current guidelines | Latest MNRE order and portal instructions |
| Subsidy eligibility | Consumer, configuration, vendor registration and component rules |
| Deemed feasibility | Current KSEB/KSERC implementation and E-Kiran workflow |
| E-Kiran stages/documents | Current manual and portal screens |
| E-Kiran/National Portal APIs | Written confirmation of public/partner API |
| KSERC storage formula | Exact clause, formula, units, effective date/category |
| Net/gross/group/virtual metering | Eligibility and operating procedure |
| Grid-support charges | Applicability and billing implementation |
| Electrical Inspectorate | Thresholds, forms, reports and sequence |
| ANERT | Current programme-specific role |
| MNRE/BIS/ALMM | Current lists, standards and applicability |
| GST | HSN/SAC, EPC supply treatment, rates, ITC, AMC/repair |
| DPDP | Commencement notifications, Rules and launch obligations |
| TRAI/DLT | Current entity/header/template and SMS rules |
| WhatsApp | Current pricing, templates, opt-in and service-window rules |
| Inverter APIs | Access, quotas, permissions, fields per exact model |
| Modbus | Register map, firmware and local network safety |
| Device inventory | Actual installed models, firmware and dataloggers |
| Meter shortage | Latest official KSEB status; media figures are not live inventory |
| GreenGrid workflow | Client interview and observation |

---

## 16. Source register

Primary starting points; reopen and verify latest versions before relying on any rule, fee or price.

### Government and regulation
1. [PM Surya Ghar National Portal](https://pmsuryaghar.gov.in/) — consumer/vendor workflow and scheme.
2. [MNRE](https://mnre.gov.in/) — scheme guidelines, CFA, vendor and component requirements.
3. [KSEB E-Kiran](https://ekiran.kseb.in/) — Kerala rooftop solar portal/manuals.
4. [KSERC final Renewable Energy and Related Matters Regulations, 2025 — Gazette PDF](https://dev.erckerala.org/api/storage/final-regulations/BDm5OZBLIuAbHoyTX0xoploDz82DbFy1O6klxxfS.pdf) — final regulation; Gazette Extraordinary No. 3944, 6 November 2025 as identified in this study.
5. [Central Electricity Authority](https://cea.nic.in/) — electrical safety/technical standards; identify exact clauses.
6. [ANERT](https://anert.gov.in/) — Kerala renewable energy agency.
7. [PIB](https://pib.gov.in/) — official scheme releases.
8. [CBIC GST](https://cbic-gst.gov.in/) — GST notifications/circulars.
9. [MeitY](https://www.meity.gov.in/) — DPDP Act and Rules.
10. [TRAI](https://www.trai.gov.in/) — commercial communication/DLT rules.

### Equipment/protocols
11. [SolisCloud](https://www.soliscloud.com/) — monitoring portal; obtain official developer access.
12. [Sungrow Developer](https://developer.sungrowpower.com/) — official developer/API resources.
13. [Huawei FusionSolar](https://solar.huawei.com/) — monitoring and Northbound API information.
14. [SunSpec Alliance](https://sunspec.org/) — interoperability and Modbus information.
15. Exact manufacturer manuals/register maps for GreenGrid's installed models — collect during discovery.

### Media/context sources identified in the supplied brief
16. Kerala Kaumudi, September 2026 — net-meter shortage reporting.
17. Onmanorama, 6 September 2026 — Kannur net-meter shortage reporting.
18. Asianet Newsable / PIB — PM Surya Ghar milestones.
19. Mercom India — National Portal issues and KSERC draft coverage.
20. Down To Earth — KSEB net-metering policy concerns and draft analysis.
21. Bioenergy Times — KSERC final notification coverage.
22. Kerala Kaumudi, 7 November 2025 — battery-storage rule coverage.

Media sources are context only. Regulatory decisions must use Gazette, official orders and live DISCOM procedure.

## 17. Final recommendation

Build the MVP around **customers, projects, work orders, utility/subsidy tracking, documents, cases, group permissions and notifications**. These workflows provide value before device APIs are available.

Do not start with a complex IoT platform or mobile app before validating GreenGrid's installed-device inventory and team workflow. Pilot one or two real inverter models after the core project/case system is stable.

The first client workshop should produce:
1. Confirmed organisation hierarchy and group membership rules.
2. Real installation lifecycle, statuses and responsible staff.
3. Sample quotations, invoices, survey forms and installation checklists.
4. Sample E-Kiran application and completed-project evidence.
5. Inventory of inverter, battery, meter and datalogger models.
6. Monthly volumes and service-level expectations.

**Recommended build order:** discovery → access/core data → CRM/project operations → utility tracker/documents → cases/notifications → customer portal → device-monitoring pilot → mobile/offline workflows.

*End of study. This is a working research and architecture brief; all items in the VERIFY register remain open until confirmed from current primary sources and GreenGrid's actual process.*
