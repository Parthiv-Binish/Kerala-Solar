# Cross-Application Workflows — End-to-End Contract

**Document ID:** INT-WF-001 · **Status:** Proposed

## 1. Common workflow contract
Every workflow has initiating actor/event, authoritative owner, command, validation, transaction boundary, resulting records, emitted events, recipient channels, retry/idempotency strategy, audit record and terminal/exception states. Clients never write database records directly.

## 2. Enquiry to customer
Staff captures enquiry or customer submits it through portal. CRM validates contact/site, checks duplicates, stores enquiry and follow-up. Staff qualifies and converts. Conversion links or creates customer/site without duplicating identity. Event: enquiry.converted. Customer invitation is a separate authorised action.

## 3. Survey
Staff creates survey request from enquiry/customer/site, assigns surveyor and appointment. Technician receives assigned job and captures observations/evidence online in MVP. Full offline job packs, durable drafts, media queueing and conflict-aware sync are Phase 2 (Should). Backend validates operation IDs and source version. Staff reviews, returns or approves immutable survey version. Approval event creates design-eligible work; it does not automatically create a project.

## 4. Design and quotation
Designer creates design from exact approved survey version, configures products/BOM and submits for technical review. Approved design enables quotation preparation. Pricing/tax/discount engine calculates authoritative totals. Internal approval freezes issue version. Communication service delivers it. Customer response binds to exact version and evidence. Acceptance enables project conversion only after preconditions pass.

## 5. Project and procurement
After acceptance of the exact issued quotation version and required commercial approvals, staff resolves the customer and confirms exactly one installation site. Ambiguous or incomplete site data blocks project creation. Won conversion links/creates customer, confirmed site and project idempotently; repeated commands return the same result. Project template creates milestones/tasks. Procurement request references approved BOM/project; approval creates PO; receipt creates inventory movement. Reservation and issue are separate. Serialised equipment is linked to installation job and later plant.

## 6. Utility/subsidy
Project owner creates process tracking record and versioned checklist. Customer documents collected; authorised staff records submission and external acknowledgement. Status updates preserve source/time. Government system remains authoritative. Subsidy estimate/sanction/credit are separate values and do not imply receipt.

## 7. Installation and handover
Project readiness gate checks design, approvals, materials, schedule and safety requirements. Staff dispatches job to technician. Technician records work, serials, checks and evidence. Reviewer resolves defects and approves commissioning. Handover pack generated from approved records and customer acknowledgement. Plant activation follows approved handover/commissioning policy.

## 8. Monitoring
Asset registry links device to plant and provider adapter. Monitoring ingests telemetry, normalizes readings and evaluates freshness/rules. Alert event appears in Staff Portal. Customer notification only follows approved policy. Missing data remains missing, not zero.

## 9. Alert to service
Alert can suggest or create a case according to configured policy. Case duplicate check links related reports. Service desk triages, creates work order and assigns technician. Technician reports diagnosis/action/parts/evidence. Reviewer resolves case; alert recovery remains separate. Customer receives safe status update.

## 10. Customer-raised service request
Customer submits from app/web. API verifies site/plant access, checks duplicates and creates canonical case. Customer receives reference. Staff triages and schedules. Technician execution and resolution are shared with staff-created cases.

## 11. Finance
MVP receipt is manually recorded for funds actually received, verified by authorised staff and only then allocated to eligible customer/project obligations. No payment gateway is assumed; customer screenshots/references alone do not prove settlement. Supplier bills match PO/receipt; payment is separate. Reversals/refunds preserve original record. Customer channels display only confirmed receipts and permitted balances.

## 12. Notification outbox
Business transaction writes event/outbox atomically. Worker resolves recipients/consent/template, sends via provider and records delivery state. Provider failure retries without rolling back source business transaction. Event ID prevents duplicate sends.

## 13. Access lifecycle
Admin creates/invites identity, links employee/customer relationship, grants groups/permissions and scope. User can hold multiple groups. Revocation invalidates sessions/tokens according to policy. Every authorization is checked server-side.

## 14. Cross-workflow invariants
- Customer, site, project, plant, device, alert and service case are separate entities.
- An accepted quotation is not a payment.
- A BOM is not a PO; reservation is not issue.
- A monitoring alert is not a service resolution.
- A project milestone update does not disclose internal notes.
- External portal status is not verified government approval unless source evidence supports it.
- No workflow silently overwrites immutable issued/approved versions.
