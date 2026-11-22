# Staff Portal — Service Desk, Cases, Work Orders & Maintenance

**Document ID:** UX-STAFF-012 · **Status:** Proposed

## 1. Purpose
Manage faults and customer support from first report to verified resolution. Cases may be raised by customers or staff. Duplicate detection and atomic creation prevent two competing cases for the same reported issue where appropriate.

## 2. Navigation
Service Desk → Inbox, My Cases, Unassigned, Priority Queue, Work Orders, Visit Calendar, Escalations, Resolved, Reopened and Service Analytics.

## 3. Case intake
Sources: customer app/web, staff portal, phone/WhatsApp manually recorded, monitoring alert or scheduled maintenance. Fields: customer/site/plant, reporter, channel, issue category, description, observed time, severity, photos, consent, contact preference and availability. Validate identity and access before linking a customer asset.

## 4. Duplicate prevention
Before create, search open cases for same plant/site, category and related time window. Show candidate matches to authorised user. A confirmed duplicate can be linked as an additional report; do not discard new evidence. Case creation must be atomic/idempotent. A first successful creation returns the canonical case reference to concurrent submitters where matching policy permits.

## 5. Case states
New, Triage, Assigned, Awaiting Customer, Scheduled, In Progress, Waiting Parts, Escalated, Resolved, Closed, Reopened, Duplicate/Linked, Cancelled. State changes require permitted action and reason. Resolution and closure are distinct if customer confirmation or quality review is required.

## 6. Triage and prioritisation
Capture impact, safety risk, plant downtime, customer impact, warranty possibility and response target. Safety concerns are escalated according to approved procedure; app prompts do not replace emergency response. Priority matrix must be approved by operations.

## 7. Work orders
A case may create one or more work orders. Fields: job type, linked case, plant/site, assigned team, planned slot, required skills, parts/tools, checklist, access instructions, safety notes, expected outcome and status. Rescheduling and assignment changes notify affected parties.

## 8. Technician execution
Technician receives only assigned work. Record arrival, diagnosis, tests, work performed, parts used/returned, before/after evidence, customer acknowledgement, follow-up and unresolved conditions. Offline submissions sync with conflict detection.

## 9. Resolution
Resolution record includes cause category, corrective action, replaced equipment/serial, test result, evidence, downtime estimate/source, warranty disposition and reviewer. Alert recovery does not automatically resolve case. Customer confirmation may be requested but lack of response follows an approved closure policy.

## 10. SLA and escalation
SLA clocks use approved business hours, severity and pause rules. Display due time, elapsed time, pause reason and breach state. Do not promise a response time until GreenGrid approves and staffs the policy.

## 11. Data movement
Reads: customer/site/plant/assets/warranty, telemetry alert, technician availability, inventory and maintenance plan. Writes: case, report, duplicate link, work order, assignment, visit, diagnosis, parts movement reference, resolution, communication and audit.

## 12. Permissions and acceptance
case.view/create/triage/assign/escalate/resolve/close/reopen; work_order.create/assign/schedule/review; customer_contact.view; service_export. Tests: customer and staff intake share case store; duplicate handling preserves evidence; parts link to inventory movements; alert and case lifecycle remain separate; resolution requires evidence; reopened cases preserve history.

## 13. Decisions
Confirm severity matrix, SLA, duplicate matching rules, emergency escalation, customer confirmation, warranty disposition and work order approval policy.
