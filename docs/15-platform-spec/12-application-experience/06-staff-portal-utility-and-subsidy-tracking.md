# Staff Portal — Utility Applications, DISCOM Processes & Subsidy Tracking

**Document ID:** UX-STAFF-006 · **Status:** Proposed; regulatory and portal workflows require current verification

## 1. Purpose and boundary
Track utility/DISCOM and subsidy-related work for each installation without pretending GreenGrid controls the government system. Government/utility portals remain authoritative. This module stores internal preparation, submission references, evidence, status observations and follow-up tasks.

## 2. Navigation
Projects → Utility & Subsidy: Application Register, My Follow-ups, Awaiting Customer Documents, Submitted, Inspection, Metering/Commissioning, Approved, Rejected/Returned, Subsidy Tracking, Portal/Process Reference Library.

## 3. Application record
Fields: internal reference, project/site/plant, customer, utility/distribution company, consumer/account reference (restricted), application type, process/portal name, external application ID, applicant, owner, submission date, current observed status, last checked time, next action/date, source of status, notes and evidence. Sensitive identifiers are masked in list views and access logged.

## 4. Workflow
1. Confirm project/site/customer identity and applicable process.
2. Create checklist from a dated, approved process template.
3. Collect required customer and technical documents.
4. Validate completeness and document validity.
5. Record submission by authorised staff or verified integration.
6. Store external acknowledgement/reference and submitted document snapshot.
7. Track inspection, correction, approval, metering and commissioning stages as applicable.
8. Record status changes with source and timestamp.
9. Escalate rejection, returned documents or overdue follow-up.
10. Close tracking only with final evidence and reviewer confirmation.

## 5. Process checklist
Checklist items have title, source, applicability, required flag, owner, due date, document type, validation and completion evidence. Requirements must be versioned because schemes and utility procedures change. Never hardcode a universal checklist for every DISCOM or scheme.

## 6. Status model
Internal statuses: Preparation, Awaiting Customer, Ready to Submit, Submitted, Under Review, Inspection Pending, Correction Required, Approved, Rejected, Completed, Withdrawn, Status Unknown. External status text is retained separately from normalized internal status. Unknown is not treated as pending or approved.

## 7. Subsidy tracking
Record scheme name/version, eligibility review, application reference, applicant, submitted date, claimed amount (if known), sanctioned amount, credited amount/date and evidence. Estimated subsidy must be clearly labelled as an estimate and must not reduce quotation balance or be shown as received money. Eligibility and benefit are not guaranteed by the platform.

## 8. External status updates
Manual update requires staff member, check time, source portal/reference and evidence where permitted. Automated access is permitted only after official API/access terms, authentication, rate limits and authorization are verified. Do not scrape portals or store credentials without approved security review.

## 9. Data movement
Reads: project/site, customer, plant, approved design, document register, process templates and user access. Writes: utility application, checklist items, external status observations, follow-ups, document links, subsidy milestones and audit events. Preserve status history; do not overwrite old observations.

## 10. Security and permissions
utility.view/create/update/submit/record_status/close; subsidy.view/update; sensitive_consumer_reference.view; process_template.manage. Mask sensitive identifiers; restrict exports; audit every view/export of sensitive identifiers.

## 11. Notifications and exceptions
Notify owner when documents missing, due date approaching, status changes, correction received or follow-up overdue. Handle unavailable portals, changed forms, missing acknowledgement, conflicting status, duplicate application and expired documents. Store the last successful check and clearly mark data stale.

## 12. Acceptance tests
- [ ] Internal status is distinct from external portal status.
- [ ] Every external status has source and checked time.
- [ ] Scheme/process checklist is versioned.
- [ ] Estimated benefit is never recorded as received payment.
- [ ] Rejected/returned cases create a next action.
- [ ] Sensitive consumer identifiers are masked and access audited.
- [ ] No unverified government integration is assumed.

## 13. Decisions and verification
Confirm DISCOM coverage, scheme applicability, process owner, approved checklists, document retention, customer consent, authorised submission roles and any official integration. Regulatory, tax and subsidy claims require current qualified verification.
