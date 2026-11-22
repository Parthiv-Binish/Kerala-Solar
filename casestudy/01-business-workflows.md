# 01 — Business and Domain Workflows

**Client:** GreenGrid Solar Solutions, Erattupetta, Kottayam, Kerala  
**Research snapshot:** 22 November 2026

## Scope and assumptions
The supplied brief describes residential, commercial and industrial rooftop solar, on-grid, off-grid and hybrid systems, and solar water heaters. Website content was not fully readable during initial review. Confirm actual services, brands, service area, headcount, volumes and internal processes with GreenGrid.

The platform is GreenGrid's operational system of record. It does not replace KSEB, MNRE, Electrical Inspectorate, manufacturer or bank systems.

## End-to-end lifecycle

~~~mermaid
flowchart TD
 A[Lead / enquiry] --> B[Qualification]
 B --> C[Site survey]
 C --> D[Technical design and yield estimate]
 D --> E[Quotation and proposal]
 E --> F{Customer accepts?}
 F -- No --> G[Follow-up / lost reason]
 G --> E
 F -- Yes --> H[Contract and payment schedule]
 H --> I[Utility and scheme application preparation]
 I --> J[Feasibility / vendor selection]
 J --> K[Procurement and material reservation]
 K --> L[Installation work order]
 L --> M[Installation and safety tests]
 M --> N[Completion report and photographs]
 N --> O[Inspection / utility coordination]
 O --> P[Agreement and meter]
 P --> Q[Commissioning / grid connection]
 Q --> R[Customer handover]
 R --> S[Monitoring / AMC / warranty]
~~~

Support rework loops: inspection defects return to corrective work; applications can be returned for document correction; quotations can be revised. Keep installation, inspection, agreement, meter, commissioning and subsidy as separate milestones.

## Roles and responsibilities

| Role | Work | Access scope |
|---|---|---|
| Owner/admin | Business oversight, approvals, configuration | All authorised business records |
| Sales | Enquiries, leads, quotations, follow-up | Own/team leads and projects |
| Surveyor | Roof, shading, electrical and site data | Assigned surveys |
| Designer/engineer | Capacity, layout, inverter/battery selection, SLD | Assigned technical projects |
| Project manager | Scheduling, procurement coordination, installation | Team/branch projects |
| Procurement/inventory | Suppliers, purchase orders, stock, serials | Inventory and purchasing |
| Technician | Installation, tests and field service | Assigned jobs/cases |
| Accounts | Invoices, receipts, dues, reconciliation | Financial records |
| Support | Customer requests, cases, follow-ups | Assigned/team queue |

One person may hold multiple responsibilities. Permissions must derive from group membership and record scope, not job title alone.

## Lead and enquiry management
Capture lead source, customer contact, site address, consumer/property category, consumption/bill information where necessary, connection type/phase/load, desired system type/capacity, budget, consent and communication preferences, assigned sales owner and next action.

Suggested stages: New → Contact attempted → Contacted → Qualified → Survey scheduled → Proposal pending → Won/Lost/On hold. Do not collect Aadhaar or sensitive documents at lead stage without a defined need.

## Site survey
Capture roof type, usable area, orientation, tilt, shading, structural observations, cable route, inverter location, earthing, lightning protection, distribution board, grid phase, meter details, connectivity, battery location, photos, surveyor notes and customer requirements. Version surveys and preserve prior records. Mobile forms should support offline drafts.

## Design and quotation
A quote should contain DC/AC capacity, module make/model/wattage/quantity, inverter and phase, battery and datalogger where applicable, mounting/BOS/protection/cabling/earthing, generation estimate and assumptions, expected bill impact, installation/transport/civil charges, tax lines, discount, payment milestones, validity, exclusions, warranty and AMC options.

Preserve every quotation revision. Never silently change an accepted quote. Store the regulatory rule-set version used for calculations.

GST depends on actual goods/services, HSN/SAC, contract structure and current notifications. Do not hardcode one generic solar GST rate; require accountant approval.

## Contract, payment and accounts
Support advance/milestone/final payment schedules, invoices, receipts, payment method, reconciliation, refunds/credit notes and outstanding balance. Distinguish initiated, received, verified/reconciled, failed and refunded. Do not treat an unverified screenshot as settlement proof.

## Procurement and inventory
Track SKU, manufacturer/model, batch/serial, supplier, purchase order, goods receipt, reserved/issued/returned quantity, warehouse, project allocation, warranty evidence and RMA. Track inverters, batteries, dataloggers and meters individually. Project BOM should reserve stock; material issue should link quantity and serials to installation.

## Installation and field work
1. Project manager creates work order.
2. Assign team/technician and date.
3. Issue materials.
4. Technician downloads checklist.
5. Record progress and time.
6. Capture photos and serial numbers.
7. Record test results.
8. Project manager reviews evidence.
9. Defects return for rework.
10. Complete work order.

Physical installation completion is not utility commissioning.

## Utility and commissioning milestones
Track separately: application submitted, feasibility, vendor selection, installation completed, completion report submitted, inspection requested/scheduled/completed, defects/rectification, agreement signed, meter requested/installed/tested, commissioning approved, handover completed and subsidy status.

## Handover
Provide final configuration, equipment serials, warranties, electrical/commissioning documents, manuals, emergency contacts, monitoring onboarding, safe shutdown instructions, AMC options and customer acknowledgement.

## Service, warranty and AMC
Service categories: inverter fault/offline, low generation, cleaning, cabling/connector issue, battery fault, grid issue, monitoring connectivity, warranty claim, physical damage, AMC visit and general enquiry.

Warranty claim records should include device/model/serial, purchase and installation dates, actual warranty start/end, evidence, fault code, troubleshooting, manufacturer reference, RMA status, replacement serial and customer communication. Store the actual warranty terms; do not assume commencement date.

AMC records include scope, dates, visits included, frequency, renewal, visit reports, parts/labour and customer sign-off. Cleaning interval must be configurable by site conditions and manufacturer guidance.

## Business-line differences

| Line | Workflow differences | Additional needs |
|---|---|---|
| Residential on-grid | Scheme eligibility, KSEB, meter, CFA | Consumer documents and subsidy tracker |
| Residential off-grid | Standalone and battery backup | Battery sizing, runtime and warranty |
| Hybrid | Solar, grid and battery | Battery commissioning and telemetry |
| Commercial | Larger loads and commercial billing | Load analysis and ROI |
| Industrial | Complex engineering/protection/approvals | SLD revisions and engineering records |
| Solar water heater | Thermal/plumbing system | Tank, collector, leak and corrosion service |

Solar water heaters need a separate product/service model; they are not an inverter-based PV plant.

## Case and field-service workflow

~~~mermaid
flowchart TD
 A[Manual request / device alert / scheduled event] --> B[Create or deduplicate case]
 B --> C[Classify severity and category]
 C --> D[Apply SLA]
 D --> E[Assign team / technician]
 E --> F[Acknowledge]
 F --> G[Remote diagnosis]
 G --> H{Field visit needed?}
 H -- No --> I[Remote resolution]
 H -- Yes --> J[Create field work order]
 J --> K[Visit and troubleshoot]
 K --> L[Parts / RMA / replacement]
 L --> I
 I --> M[Customer confirmation and closure]
 M --> N[Feedback and audit]
~~~

Use one case engine for manual requests, device alerts, overdue milestones, warranty events and AMC schedules.

## MVP workflow order
1. Staff identity, groups and audit.
2. Leads, customers and sites.
3. Surveys and quotations.
4. Project milestones and utility status mirror.
5. Document vault.
6. Cases, assignment and SLA.
7. Installation work orders.
8. WhatsApp/email notification outbox.
9. Customer project tracking and service requests.
10. Device monitoring after equipment inventory is confirmed.