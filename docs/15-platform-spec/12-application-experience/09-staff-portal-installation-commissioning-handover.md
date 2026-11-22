# Staff Portal — Installation, Commissioning, Quality Checks & Handover

**Document ID:** UX-STAFF-009 · **Status:** Proposed; engineering and safety review required

## 1. Purpose
Coordinate approved installation work, technician assignments, site readiness, materials, quality checkpoints, test evidence, commissioning and customer handover. The app supports the workflow; it does not replace competent electrical/structural supervision or statutory inspection.

## 2. Navigation
Projects → Installation: Readiness, Schedule, Job Packs, Installation Progress, Quality Inspections, Commissioning, Defects/Punch List, Handover and Completed Installations.

## 3. Readiness gate
Before dispatch verify: approved design/version, accepted scope, site access, customer appointment, required utility prerequisites, materials availability/reservation, competent team, safety plan, weather/site constraints and required permits/approvals. Each check has owner, status, evidence and timestamp. Missing mandatory readiness item blocks dispatch unless authorised exception is recorded.

## 4. Job pack
Contains project/site details, customer contact with controlled visibility, approved drawings, BOM, allocated equipment, safety instructions, work scope, checklist, emergency escalation and expected customer interaction. Technician receives only information needed for assigned work.

## 5. Installation stages
Proposed stages: Site Ready, Team Assigned, Work Started, Structure/Module Work, Electrical Work, Inspection, Commissioning Ready, Commissioned, Punch List, Handover Ready, Handed Over. Actual stages depend on approved installation method and system type. Each stage has responsible person, checklist, evidence and completion criteria.

## 6. Field evidence
Capture timestamp, actor, job, evidence category, description, photo/file, optional location with consent, device/source and upload status. Preserve original file and metadata where lawful. Avoid unnecessary images of people, identity documents or private property. Customer consent and retention policy apply.

## 7. Equipment and serial capture
Capture product/model, serial number, batch, source receipt, installation location/role and scan/manual entry method. Validate against inventory issue and uniqueness rules. A serial mismatch routes to supervisor; do not silently substitute equipment from design BOM.

## 8. Quality and commissioning
Use versioned checklists approved by competent technical personnel. Capture test item, method/reference, instrument identifier/calibration where applicable, result, unit, pass/fail/not-applicable, tester, time and evidence. Numeric limits must come from verified standards/manufacturer/approved engineering policy. Do not invent thresholds. Failed critical checks block commissioning and create corrective action.

## 9. Punch list
Defect record includes category, severity, description, owner, due date, evidence, customer impact, resolution and reviewer. Reinspection is recorded. A waived item requires authorised reason and must not conceal a safety-critical defect.

## 10. Handover
Handover checklist may include approved as-built documents, equipment details, warranty documents, user instructions, safety guidance, monitoring access, contact/support route, commissioning report and customer acknowledgement. Handover completion records exact document versions, recipient and timestamp. It does not imply utility approval or subsidy credit unless separately confirmed.

## 11. Data movement
Reads: project, design, BOM, inventory allocation, site, customer appointment, technician and safety/checklist templates. Writes: installation jobs, assignments, work-stage events, equipment serial links, inspection/test records, defects, evidence metadata, handover record and audit events.

## 12. Permissions
installation.schedule/assign/start/update; inspection.record/review; commissioning.record/approve; defect.manage; equipment.serial.assign; handover.prepare/approve; evidence.view/export. Enforce assigned-job and site scopes.

## 13. Failures and acceptance tests
Handle offline upload, duplicate serial, wrong material, unsafe condition, failed test, incomplete checklist, unavailable customer, lost access and reviewer rejection. Acceptance: readiness gates block dispatch; critical failures block commissioning; evidence links to exact job/version; serial traceability is preserved; handover records customer acknowledgement; changes are audited.

## 14. Decisions
Confirm approved checklists, safety procedures, competent sign-off roles, required tests, evidence retention, customer acknowledgement method and handover package.
