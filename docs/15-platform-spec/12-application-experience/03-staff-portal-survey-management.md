# Staff Portal — Survey Scheduling, Site Assessment & Survey Review

**Document ID:** UX-STAFF-003  
**Application:** APP-01 Management and Staff Web Portal, with field capture hand-off to APP-02 Technician App  
**Status:** Proposed — stakeholder validation required  
**Workflow:** Enquiry/customer → survey request → appointment → field assessment → submission → office review → approved technical basis

[← Enquiries and customer management](02-staff-portal-enquiries-and-customers.md) · [← Application experience index](../00-application-suite-and-screen-inventory.md) · [← Project Book](../../../INDEX.md)

---

## 1. Purpose and scope

Survey Management organises site visits and captures the information required to assess whether and how a solar installation may be suitable.

The module covers:
- Requesting a survey from an enquiry or existing customer/site.
- Scheduling and assigning survey staff.
- Preparing the surveyor with the right site and contact information.
- Capturing site, roof, electrical and consumption observations.
- Capturing photographs, documents, measurements and limitations.
- Submitting the survey for office review.
- Returning incomplete surveys for correction.
- Approving a specific survey version as the technical input to design and quotation.

A survey is an assessment record. It is not a design approval, engineering certification, utility approval, subsidy approval or promise of generation/savings. Technical decisions and required qualifications must be confirmed by GreenGrid's responsible personnel.

## 2. Navigation

Staff Portal → Surveys & Design:
- Survey Overview
- Survey Requests
- Survey Calendar
- Unassigned Surveys
- My Team's Surveys (scope-dependent)
- Awaiting Review
- Returned for Correction
- Approved Surveys
- Survey Templates / Checklists (authorised configuration)

A survey can be opened from:
- Enquiry Details
- Customer Profile → Sites
- Project Workspace
- My Work
- Survey Calendar

## 3. Survey Overview dashboard

### 3.1 Purpose

Show survey workload and blockers, not unrelated sales statistics.

### 3.2 Summary cards

- Requests awaiting scheduling
- Surveys scheduled today
- Upcoming surveys
- Surveys awaiting submission
- Submitted surveys awaiting review
- Surveys returned for correction
- Overdue surveys
- Approved surveys awaiting design hand-off

Each card opens a filtered list. Counts are computed from authorised records and successful queries only.

### 3.3 Queue columns

- Survey reference
- Enquiry/customer reference
- Site locality
- Appointment date/time
- Assigned surveyor/team
- Survey type
- Status
- Submission/review due date
- Last update
- Next action

Do not expose the customer's full contact details in overview rows unless required by the user's permission.

## 4. Create Survey Request

### 4.1 Entry points

A survey request may be created from:
- An eligible enquiry.
- An existing customer/site with an authorised request.
- A project requiring a reassessment or additional survey.

The user should not have to re-enter known customer and site information.

### 4.2 Request form

| Field | Required? | Behaviour / validation |
|---|---|---|
| Linked enquiry | Required for prospect survey | Pre-filled when opened from enquiry; must be accessible |
| Linked customer | Required for existing-customer survey | Select existing customer; do not create a duplicate |
| Installation site | Required when known; otherwise capture provisional site details | Must distinguish installation location from customer correspondence address |
| Survey purpose | Yes | Database-backed value such as initial assessment, detailed assessment, re-survey or service-related inspection |
| Survey type/checklist | Yes | Load active approved template from database |
| Requested date/window | Optional | Must be a valid future or policy-approved date |
| Preferred time window | Optional | Use organisation working calendar |
| Site contact | Yes before appointment confirmation | Choose existing contact or add a site-specific contact with permission |
| Site access instructions | Optional | Include access constraints, not credentials or unnecessary sensitive data |
| Assigned surveyor/team | Optional at request creation | Active and eligible employee/team only |
| Priority | Optional | Database-backed priority; justification for exceptional priority |
| Request notes | Optional | Plain-language context and customer concerns |
| Supporting files | Optional | Approved file type/size; private storage |

### 4.3 Validation

- Enquiry/customer/site relationship must be valid.
- Site must be active or explicitly marked provisional.
- Survey purpose and template must be active.
- Appointment must not conflict with an existing confirmed appointment for the same surveyor where calendar rules prohibit it.
- A surveyor must be qualified/authorised for the survey type according to GreenGrid's approved capability list.
- A request cannot be assigned to a disabled employee.
- Customer contact must be suitable for appointment coordination.

### 4.4 Save behaviour

On creation:
- Create survey request and stable survey reference.
- Link enquiry/customer/site as applicable.
- Store creator, timestamp and initial status history.
- Store selected checklist template and version.
- Add activity to the linked enquiry/customer/project.
- Add a scheduling task to the appropriate queue.
- Notify assigned coordinator only after successful commit.

Creating a request does not automatically confirm a customer appointment.

## 5. Survey Calendar and Scheduling

### 5.1 Calendar views

- Day
- Week
- Month
- List / agenda

Filters:
- Surveyor
- Team
- Survey type
- Status
- Locality/area
- Appointment confirmation state

### 5.2 Schedule / reschedule form

Fields:
- Survey reference
- Date
- Start time
- Expected duration
- Assigned surveyor(s)
- Site contact
- Customer confirmation status
- Travel/access notes
- Internal scheduling note

Validation:
- Date/time must be valid in the organisation timezone.
- Expected duration must be positive and within configured limits.
- Check employee availability and approved working calendar.
- Warn about conflicts; enforce hard conflicts only where policy defines them.
- Confirm surveyor eligibility.
- Record reason when rescheduling a confirmed appointment.
- Preserve prior appointment history; do not overwrite the old appointment.

### 5.3 Appointment states

Proposed states:
- Requested
- Awaiting scheduling
- Scheduled — confirmation pending
- Confirmed
- Reschedule requested
- Rescheduled
- In progress
- Completed — awaiting submission
- Cancelled
- No access / customer unavailable

Final state names and transition permissions require validation.

### 5.4 Customer communication

When an appointment is scheduled or changed:
1. System prepares an event.
2. Notification service checks the customer's communication preference, consent, verified channel and approved template.
3. It queues an appointment message through the configured provider.
4. Delivery attempts and provider responses are logged.
5. Staff can see sent/delivered/failed/unknown status.

A queued message is not proof the customer received it. If no approved messaging integration is configured, staff may record that the customer was contacted manually, including time and outcome.

## 6. Survey Detail — office view

### 6.1 Header

Show:
- Survey reference
- Linked enquiry/customer/project
- Site locality
- Survey purpose
- Appointment status/date
- Assigned surveyor
- Submission/review state
- Current version

### 6.2 Sections

**Summary**
- Request reason
- Customer/site context
- Appointment information
- Current owner and next action

**Checklist**
- Required sections
- Completion percentage
- Missing mandatory responses
- Conditional questions

**Site observations**
- Roof/site observations
- Electrical observations
- Access/safety limitations
- Measurements and units

**Photos and documents**
- Evidence gallery with capture time, uploader and description
- Document classification
- Private access control

**Review**
- Submission status
- Reviewer comments
- Returned items
- Approval decision and version

**History**
- Assignment and schedule changes
- Survey submission events
- Review/return/approval history
- Version comparisons

## 7. Field assessment — information to capture

The final checklist must be approved by GreenGrid's qualified technical lead. The following is a proposed structured capture inventory, not a substitute for applicable electrical/structural standards or professional judgement.

### 7.1 Site identification

- Survey reference (system-generated)
- Customer/enquiry/project reference
- Site address and PIN
- Site contact and reachable phone
- Visit date/time (system captured, editable only with reason)
- Surveyor identity
- People present / customer representative
- Site access outcome
- Site coordinates only if captured with device permission and source/accuracy metadata

### 7.2 Customer requirement and consumption

- Intended use: residential, commercial, institutional or configured category
- Existing electricity connection details, where relevant and lawfully collected
- Consumer category as stated/verified
- Sanctioned load or contract demand, where available
- Monthly bill/consumption values and period
- Bill copy/photo, if the customer provides it and there is a documented need
- Existing backup/inverter/generator details
- Customer's desired outcome and constraints
- Proposed capacity only as an initial estimate, not an approved design

Do not invent consumption from a verbal estimate. Mark values as customer-reported, document-observed or independently verified.

### 7.3 Roof and mounting location

Where relevant:
- Roof type/material
- Approximate usable area and measurement method
- Roof orientation/azimuth and measurement source
- Tilt/slope and measurement source
- Shading sources and approximate shading periods
- Parapet/obstructions
- Roof condition and visible damage
- Structural/access concerns requiring specialist review
- Waterproofing/drainage considerations
- Safe access route
- Potential mounting constraints
- Photo references for each important observation

Do not label a roof structurally safe solely from visual inspection. Escalate where a structural assessment is required.

### 7.4 Electrical assessment

Capture only information the surveyor is qualified and authorised to inspect:
- Supply phase/type as observed
- Meter location and visible identification
- Main distribution board location
- Earthing/bonding observations
- Cable route possibilities and approximate lengths
- Proposed inverter location constraints
- Existing electrical equipment relevant to the proposed system
- Visible condition/risks
- Measurements with value, unit, instrument/method and timestamp where applicable
- Need for specialist/electrician review

Do not instruct unqualified personnel to open live electrical panels or perform unsafe measurements. The app must include a stop/escalation path for unsafe access or uncertain conditions.

### 7.5 Installation logistics

- Material access route
- Roof access
- Lifting/transport limitations
- Parking/loading constraints
- Working-hour restrictions
- Customer/site coordination requirements
- Nearby obstructions
- Additional work or civil/electrical requirements
- Site safety notes

### 7.6 Photos and evidence

Each image/document should have:
- File reference
- Capture/upload timestamp
- Capturing employee
- Survey section/category
- Caption/observation
- Optional location metadata subject to privacy policy
- Upload/sync status
- Review status

Rules:
- Store files in private storage, not public URLs.
- Validate MIME type, extension, file size and malware scanning policy.
- Preserve original evidence; annotations create a separate derivative/version.
- Do not silently strip context needed for evidence; apply privacy controls to location/metadata.
- Failed uploads remain visibly pending and can be retried.
- Avoid duplicate upload on retry through idempotent file operations.

### 7.7 Survey conclusion

Surveyor records:
- Overall assessment: feasible for further design / feasible with conditions / further information required / not suitable at present / unable to assess
- Key findings
- Constraints and risks
- Additional documents/measurements needed
- Recommended next action
- Whether specialist review is required
- Customer acknowledgement that visit/observations were recorded, not that design or installation is approved

The surveyor must not approve their own submission if separation of duties is required by policy.

## 8. Surveyor submission workflow

1. Surveyor opens assigned survey.
2. App/web confirms current assignment and site details.
3. Surveyor completes required checklist sections.
4. App validates mandatory fields and conditional requirements.
5. Surveyor attaches evidence and records conclusion.
6. Surveyor reviews the submission summary.
7. Surveyor submits the survey.
8. Backend stores an immutable submitted version and status event.
9. Reviewer queue is updated.
10. Reviewer receives notification if configured.

If offline capture is supported by the field app, the survey remains a local draft until sync succeeds. The UI must distinguish saved locally, sync pending, sync failed and submitted successfully.

## 9. Office Review screen

### 9.1 Reviewer workspace

Display:
- Survey reference and linked business records
- Surveyor and visit date
- Completion checklist
- Missing required information
- Key measurements and their sources
- Photo/document evidence
- Risk/constraint flags
- Previous survey versions
- Review comments

### 9.2 Review actions

- Approve survey version
- Return for correction
- Request specialist review
- Mark further information required
- Reject as unusable with reason (only if approved policy permits)

### 9.3 Review validation

Approval must be blocked if:
- Mandatory checklist responses are missing.
- Required evidence is missing.
- Unresolved safety/structural/electrical flags require escalation.
- Required specialist review has not been completed.
- The submitted version has changed since the reviewer opened it.
- Reviewer lacks approval permission.

Return for correction requires clear comments and identifies the sections/items to correct. The surveyor must create a new submission version; the prior submitted version remains preserved.

### 9.4 Approval behaviour

- Approve a specific version, not an editable live draft.
- Record reviewer, timestamp, decision, comments and approved version identifier.
- Mark the survey as approved for its stated purpose.
- Make the approved version available to design/quotation workflows.
- Notify the surveyor and relevant owner.
- Any material change after approval creates a new version and may require re-review.

Approval does not itself create a project, guarantee feasibility or authorise installation.

## 10. Survey versioning and change control

- Draft edits may be saved without creating a formal submitted version.
- Submission creates a numbered version/snapshot.
- Review decision attaches to that version.
- Returned corrections create a subsequent version.
- Approved versions are read-only.
- Re-survey creates a linked survey or new version according to whether it is a correction or a new physical assessment; this rule needs confirmation.
- Preserve who changed what and when.
- Do not overwrite measurements, photographs or prior conclusions.

## 11. Data read, processing and write map

| Action | Data read | Processing | Data written / updated |
|---|---|---|---|
| Create request | Enquiry/customer/site, survey purposes, templates, employees | Validate relationships and eligibility | Survey request, initial status, audit/activity |
| Schedule visit | Survey request, employee calendar, business hours, contacts | Conflict/qualification checks | Appointment and schedule history |
| Reschedule | Existing appointment and history | Validate reason, availability and state | New appointment version/history; old appointment retained |
| Open survey | Survey version, site, linked records, template | Permission and scope checks | Access event where policy requires |
| Complete checklist | Template/version, current draft | Conditional required-field validation | Draft responses and measurements |
| Upload evidence | Survey access, file policy | Type/size/security validation, checksum | Private file object and metadata |
| Submit survey | Draft responses, evidence, required rules | Validate completeness and create snapshot | Submitted version, status history, activity/audit |
| Review survey | Submitted version, evidence, review policy | Check completeness, flags and reviewer permission | Review decision/comments/history |
| Approve survey | Exact submitted version and approvals | Freeze version and enable downstream use | Approval event and approved-version reference |
| Return survey | Exact submitted version and comments | Identify correction items | Returned state and review notes |
| Hand off to design | Approved survey version | Confirm purpose, version and design eligibility | Design workflow reference/queue event |

Exact table/column names must follow the canonical data dictionary and ER model. This chapter does not create a second data model.

## 12. Permissions

Proposed capabilities:
- survey.view
- survey.request.create
- survey.schedule
- survey.assign
- survey.capture
- survey.submit
- survey.review
- survey.approve
- survey.return
- survey.template.view
- survey.template.manage
- survey.evidence.view
- survey.evidence.download
- survey.export

Possible scopes: assigned survey, own team, related enquiry/customer/project, location or company-wide. Backend must enforce access to survey records and private evidence files. Field staff must not gain access to unrelated customer finance or HR data merely because they can view a survey.

Separation of duties for submitter/reviewer/approver must be configured and confirmed.

## 13. Notifications and activity

Potential events:
- Survey request assigned
- Appointment scheduled/changed/cancelled
- Customer confirmation pending
- Survey overdue
- Survey submitted
- Survey returned for correction
- Survey approved
- Specialist review required
- Evidence upload failed or sync incomplete

Each notification must link to an authorised record and avoid unnecessary personal information. Internal reviewer comments must not automatically be sent to customers.

## 14. Failure and exception handling

- **No site access:** record attempt, reason, time and next action; do not mark survey complete.
- **Customer unavailable:** record outcome and request rescheduling.
- **Unsafe condition:** stop the affected activity, record a safety flag and escalate.
- **Missing measurement:** mark not captured with reason; do not enter zero as a substitute.
- **Poor connectivity:** retain local draft if supported; show sync state clearly.
- **Photo upload failure:** preserve pending file and allow retry.
- **Duplicate survey request:** warn and allow authorised linking/cancellation; do not silently discard.
- **Conflicting edits:** show latest server version and require reconciliation.
- **Reviewer unavailable:** keep item in review queue; do not auto-approve.
- **Provider/notification failure:** retain business workflow state and delivery failure separately.

## 15. Acceptance tests

- [ ] Survey can be requested from an eligible enquiry/customer/site.
- [ ] Existing customer/site details are reused without accidental duplication.
- [ ] Survey template version is recorded.
- [ ] Calendar prevents or warns about conflicts according to policy.
- [ ] Appointment rescheduling preserves previous schedule history.
- [ ] Customer communication is consent-aware and delivery status is tracked.
- [ ] Surveyor sees assigned/authorised surveys only.
- [ ] Required fields and conditional checklist rules validate correctly.
- [ ] Measurements include units and source/method where relevant.
- [ ] Missing data is not represented as zero.
- [ ] Evidence is private, validated and retry-safe.
- [ ] Survey submission creates a preserved version.
- [ ] Reviewer can return with actionable comments.
- [ ] Approval is tied to one immutable version.
- [ ] Material changes after approval require a new version/review.
- [ ] Approved survey becomes available to design without automatically creating a project.
- [ ] Safety flags prevent inappropriate approval.
- [ ] All important actions have actor/time history.
- [ ] No fake site, customer or survey records are used.

## 16. Decisions GreenGrid must confirm

- Survey types and the approved checklist for each.
- Which staff are qualified to conduct each survey.
- Whether surveyor and reviewer must be different people.
- Required electrical/structural specialist checks.
- Mandatory photographs and documents.
- Whether GPS capture is needed and the privacy basis.
- Calendar working hours, travel buffers and appointment duration.
- Who confirms appointments with customers and by which channels.
- Offline capture requirements and maximum offline duration.
- Whether a re-survey creates a new survey record or a new linked version.
- Who may approve a survey and what approval means operationally.
- Required customer acknowledgement wording.
- Retention period for photos, bills and survey evidence.

**Next chapter:** Solar Design & Quotation Management — design versions, component/BOM selection, price calculation, approvals, quotation delivery, customer acceptance and revision history.
