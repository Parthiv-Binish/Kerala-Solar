# Staff Portal — Enquiries, Follow-ups & Customer Management

**Document ID:** UX-STAFF-002  
**Application:** APP-01 Management and Staff Web Portal  
**Status:** Proposed — stakeholder validation required  
**Primary workflow:** Enquiry capture → qualification → follow-up → survey/quotation → Won/Lost/On Hold → customer/project conversion

[← Staff Portal navigation and dashboard](01-staff-portal-navigation-and-dashboard.md) · [← Application experience index](../00-application-suite-and-screen-inventory.md) · [← Project Book](../../../INDEX.md)

---

## 1. Purpose and boundaries

This module manages a potential customer's journey before and during conversion to a registered customer.

**An enquiry is not a customer.** An enquiry can exist with prospect/contact information only. Creating an enquiry must not automatically create a customer, project, quotation, payment or login account.

A customer is a registered business relationship. A customer may have multiple contacts, sites, enquiries and projects over time.

The module must make it easy to capture an enquiry quickly, assign a responsible employee, record every follow-up and understand the next action.

## 2. Navigation

Staff Portal → Enquiries:
- Enquiry Overview
- All Enquiries
- My Enquiries
- Unassigned Enquiries (permission-dependent)
- Follow-ups Due
- Overdue Follow-ups
- On Hold
- Won
- Lost
- Enquiry Sources / Loss Reasons (authorised master-data management)

Staff Portal → Customers:
- Customer Overview
- All Customers
- Add Customer
- Customer Profile
- Contacts
- Sites & Addresses
- Customer Activity

A customer may also be opened from a converted enquiry, project, quotation or service record, subject to permission.

## 3. Enquiry List screen

### 3.1 Purpose

Give sales/enquiry employees a quick view of prospects and the next action required.

### 3.2 Default columns

- Enquiry reference
- Prospect/contact name
- Primary contact method (masked if required)
- Location/locality
- Requirement summary
- Current stage
- Assigned employee
- Next follow-up date
- Last activity date
- Age since received
- Priority (if enabled)

### 3.3 Filters

- Stage/status
- Assigned employee
- Team/group scope
- Source/campaign
- Date received
- Next follow-up date
- Locality/district
- Customer category
- Requirement/system type
- Priority
- Unassigned / overdue

Filters are applied server-side within the user's permitted scope.

### 3.4 Actions

- Add enquiry
- Open details
- Assign/reassign (permission)
- Schedule follow-up
- Record activity
- Mark on hold
- Mark lost (requires reason)
- Reopen (permission and reason)
- Convert to customer/project (only when eligible and authorised)
- Export (separate permission; sensitive-data controls apply)

Bulk assignment may be supported. Bulk status changes must not bypass per-record validation or audit history.

### 3.5 Data behaviour

**Reads:** enquiries, contacts, addresses, sources, assignments, status history, latest activity and next open follow-up.

**Processes:** search matching, scope filtering, due/overdue calculation, duplicate-warning indicators, pagination and sorting.

**Writes:** none for normal viewing. List actions call the owning workflow service and create domain/audit records.

**Empty state:** explain that there are no enquiries in this view and offer Add Enquiry if permitted. Never show fabricated sample enquiries.

## 4. New Enquiry screen

### 4.1 Design principle

Keep the first capture short enough for a phone call or walk-in. Advanced qualification can be completed later. Do not require technical details the prospect may not know.

Use a guided form with five sections:
1. Contact
2. Location
3. Solar requirement
4. Source and assignment
5. Notes and communication preferences

### 4.2 Fields

| Field | Required? | Input / behaviour | Validation and notes |
|---|---|---|---|
| Contact/prospect name | Yes | Text | Trim whitespace; reject empty values |
| Customer category | If configured | Database-backed select | Individual, business or approved categories |
| Primary phone | At least one contact method | Phone with country code | Store as text; normalize for matching |
| WhatsApp number | Optional | Separate phone or explicit WhatsApp flag | Never assume every phone supports WhatsApp |
| Email | Optional | Email input | Normalize for matching; preserve display form |
| Preferred contact channel | Optional | Database-backed select | Phone, WhatsApp, email or approved channel |
| Communication consent | Policy-dependent | Explicit consent record | Purpose, channel, source, timestamp and evidence where required |
| Site locality/address | Enough to identify approximate area | Address fields | Full address may be collected later |
| PIN code | Optional at first capture | Six-character text input | Validate format; postal lookup may suggest post offices |
| District/state | Optional or suggested | Database-backed geography select | Suggestions must not overwrite user text |
| Enquiry source | Yes if known; otherwise Unknown | Database-backed select | Phone, website, WhatsApp, referral, walk-in, social, campaign etc. |
| Campaign/referrer | Optional | Text or linked campaign | Do not create a campaign implicitly |
| Requirement type | Optional | Database-backed select | Residential, commercial or approved categories |
| Approximate bill/consumption | Optional | Amount/number plus unit and period | Do not treat estimate as verified bill |
| Expected capacity | Optional | Positive number with kW unit | Validate configured range |
| Timeline | Optional | Database-backed select/date range | Avoid false urgency |
| Assigned employee | Optional by workflow | Employee search/select | Must be active and assignable |
| Initial notes | Optional | Multiline text | Warn against Aadhaar, bank credentials or unnecessary sensitive data |
| Attachment | Optional | Approved file upload | Validate type/size; private storage |

If neither phone nor email is available, allow an approved alternative contact method only if GreenGrid confirms the process. Do not create fake contact values to bypass validation.

### 4.3 Duplicate detection

Before saving, search possible matches using:
- normalized phone
- normalized email
- prospect name plus locality as a weaker signal
- existing customer contacts where accessible

Show likely matches with permission-appropriate details. The user may:
- Link to an existing enquiry/add activity
- Link to an existing customer where rules allow
- Continue as a separate enquiry
- Cancel and review

Do not silently merge records. Record how the duplicate warning was resolved.

### 4.4 Save behaviour

Actions:
- Save Draft (if draft capture is enabled)
- Save Enquiry
- Cancel

On successful save:
- Create enquiry reference.
- Create initial status/history event.
- Save contact/address associations.
- Save source and assignment where supplied.
- Record creator and timestamp.
- Add initial activity.
- Trigger configured acknowledgement/assignment events only after commit.
- Open Enquiry Details with confirmation.

A retry after a network timeout must not create duplicate enquiries; use idempotent request handling.

### 4.5 Data flow

**Reads:** source options, customer categories, contact methods, geography/postal references, active employees and duplicate candidates.

**Writes:** enquiry, contact/address associations, assignment if supplied, initial status history, activity, consent if captured, attachment metadata and audit event.

**Does not write:** customer, project, quotation, payment, solar plant or login account.

## 5. Enquiry Details screen

### 5.1 Header

Display:
- Enquiry reference
- Prospect name
- Stage/status
- Priority if enabled
- Assigned owner/team
- Received date
- Next action and due date

Actions, only when permitted and valid:
- Edit
- Assign / Reassign
- Add Follow-up
- Log Activity
- Schedule Survey
- Prepare Quotation (only after required survey/design conditions)
- Mark On Hold
- Mark Lost
- Reopen
- Convert to Customer & Project

### 5.2 Tabs / sections

**Overview:** contact summary, location, requirement, source, current status, owner and next action.

**Activity:** calls, meetings, messages, notes and system events, with actor, timestamp, outcome and next action.

**Follow-ups:** open/completed follow-ups, owner, due date, channel and outcome.

**Surveys:** linked appointments/submissions, review status and evidence.

**Quotations:** linked quotation versions and customer responses. The accepted version must be explicit.

**Documents:** authorised enquiry attachments.

**History:** status transitions, assignment changes, edits and conversion events. Show before/after values for important fields where policy permits.

### 5.3 Editing rules

- Contact changes preserve prior values in appropriate history/audit records.
- Reassignment creates a new assignment event; it does not erase the previous owner.
- Status changes use allowed transition actions, not arbitrary text or unrestricted dropdowns.
- Lost requires a reason.
- On Hold requires a reason and review date.
- Reopen requires permission and reason.
- Accepted quotation versions are immutable; revisions create a new version in the quotation module.

## 6. Follow-up Planner

### 6.1 Create follow-up

Fields:
- Linked enquiry (pre-filled when opened from a record)
- Follow-up type/channel
- Due date and time
- Assigned employee
- Reminder preference (if supported)
- Purpose/notes
- Priority (optional)

Validation:
- Valid due date/time.
- Owner must be active and assignable.
- Follow-up type must be active master data.
- Follow-up must link to an enquiry or other supported record.
- Past-due scheduling requires an explicit reason or approved policy.

### 6.2 Complete follow-up

Capture:
- Completion timestamp (system-generated)
- Outcome
- Notes
- Contact result (reached, no answer, requested callback, not interested or approved value)
- Whether another action is required
- Next follow-up date/owner, if required

Processing:
- Mark this follow-up complete.
- Append activity to the enquiry timeline.
- Create a new follow-up if another action is needed; do not overwrite the completed record.
- Update next-action summary.
- Trigger notifications only when configured.

### 6.3 Follow-up queues

- Due today
- Overdue
- Upcoming
- Completed recently
- Unassigned (permission-dependent)

Make ownership and next action obvious.

## 7. Qualification and stage changes

### 7.1 Suggested stages

New → Contacted → Qualified → Survey Scheduled → Survey Completed → Quotation Prepared → Quotation Sent → Negotiation → Won / Lost / On Hold.

The exact stages and transition policy require GreenGrid approval. Some stages may be represented by linked workflow records rather than a single status field.

### 7.2 Qualification information

Capture when known:
- Customer use case/category
- Site availability and locality
- Approximate load/consumption
- Consumer category, if relevant and verified
- Roof/site access availability
- Desired timeline
- Decision-maker/contact
- Key concerns/questions
- Whether a survey is appropriate
- Next action and owner

Do not promise subsidy eligibility, savings, generation, approvals or installation dates based only on preliminary enquiry information.

### 7.3 Transition validation

Before changing stage, backend checks:
- Current state permits transition.
- Required information exists.
- Required survey/quotation record exists where applicable.
- User has transition permission.
- Required approval exists.
- No conflicting conversion/closure is in progress.

Record actor, timestamp, previous state, new state, reason and linked evidence.

## 8. Mark Lost and On Hold

### 8.1 Lost

Required:
- Loss reason from database-backed list
- Lost timestamp
- Actor

Optional:
- Explanatory notes
- Competitor/alternative chosen, only if GreenGrid wants to collect it
- Future follow-up date where lawful and consented

Lost records remain searchable and reportable. They are not deleted.

### 8.2 On Hold

Required:
- Hold reason
- Review date or next contact date
- Responsible owner

A review due date returns to the owner's work queue. Reopening is a distinct audited action.

## 9. Customer List

### 9.1 Default columns

- Customer reference
- Customer/organisation name
- Primary contact (masked based on permission)
- Customer category
- Number of sites
- Number of active projects
- Last activity
- Customer status

### 9.2 Filters

- Customer category
- Active/inactive
- Location/district
- Relationship owner, if configured
- Has active project
- Has service case
- Created date

### 9.3 Actions

- Add customer
- Open profile
- Edit permitted details
- Add contact
- Add site/address
- Start a new enquiry for an existing customer
- Create project only through approved project workflow
- Export under explicit permission

A basic customer lookup permission must not expose finance/contact data unnecessarily.

## 10. Add / Edit Customer

### 10.1 Customer identity

Possible fields:
- Customer category/type
- Person's name or registered organisation name
- Display name
- Legal/registered name where relevant
- Business registration/tax identifiers only where there is a confirmed operational need and appropriate access/retention controls
- Preferred language
- Relationship status

Do not collect Aadhaar or sensitive identity documents by default. Any verification requirement needs a separate documented purpose and safeguards.

### 10.2 Contact methods

Support multiple phone, WhatsApp-capable, email and alternate contact methods.

Each method may have:
- Label
- Value
- Primary flag
- Verification state
- Active state
- Communication consent/preferences stored separately

WhatsApp capability and consent must be explicit; they cannot be inferred from the existence of a phone number.

### 10.3 Addresses and sites

Distinguish:
- Registered/customer address
- Billing address
- Correspondence address
- Installation site
- Other approved address types

A site is a separate record with its own address, access details and site contact. Do not overwrite the customer's residential address when recording an installation location.

Address fields:
- Address label/type
- Door/house/building
- Street/road
- Locality/area
- Post office, where available
- PIN code
- Local body/municipality/panchayat, where applicable
- District
- State
- Country
- Directions/access notes
- Optional coordinates with source/accuracy metadata

### 10.4 PIN lookup behaviour

1. User enters a six-character PIN.
2. Backend checks local PostgreSQL postal reference data first.
3. If missing/stale, an approved source may be queried if configured.
4. Return matching post offices/localities; multiple post offices may share one PIN.
5. User chooses the correct option.
6. User reviews suggested district/state/local body.
7. User can still enter or edit free-text address details.
8. Provider failure never blocks address entry.

Do not infer exact coordinates from a PIN. Do not silently overwrite manually entered values. Verify external data source access, rights, availability and refresh policy.

### 10.5 Customer duplicate checks

Compare normalized contact methods and relevant identity attributes. Show candidates; do not automatically merge. Merging requires a separate authorised workflow with relationship/history reconciliation.

## 11. Customer Profile

### 11.1 Header summary

- Customer reference and display name
- Relationship status
- Primary contact (permission-aware)
- Relationship owner, if configured
- Quick actions allowed by permission

### 11.2 Tabs

- **Overview:** customer summary, preferred contact method, important flags and next action.
- **Contacts:** multiple contacts/methods, verification and consent state.
- **Sites:** addresses, installation locations, access notes and site contacts.
- **Enquiries:** linked enquiries and conversion relationships.
- **Projects:** active and historical projects.
- **Quotations:** permitted quotation versions and responses.
- **Finance:** receipts, due balances and statements for finance-authorised users only.
- **Documents:** customer/site/project documents by classification and access.
- **Service:** service cases, visits, warranty and AMC.
- **Activity:** customer events and communications the viewer may access.

### 11.3 Data rules

- Do not create a separate customer record for every project.
- Do not treat every enquiry as a registered customer.
- Keep contact persons separate from the customer identity record where needed.
- Keep site ownership/association and installation location explicit.
- Preserve history when a contact/address changes.
- Customer portal access is linked through a verified account relationship; a phone number alone is not a login.
- Account activation/invitation is separate from customer record creation.

## 12. Customer account invitation

### 12.1 Invitation flow

1. Authorised employee opens Customer Profile.
2. Selects Invite Customer.
3. System confirms an approved contact channel exists.
4. Employee selects the permitted channel.
5. Backend creates a time-limited invitation token and stores only its secure hash.
6. Notification service sends the invitation.
7. Customer completes verification and activation.
8. Backend links customer identity/account to the correct customer record.
9. Invitation is consumed and cannot be reused.

Invitation states:
- Not invited
- Pending
- Sent
- Activated
- Expired
- Revoked
- Delivery failed

Do not invite automatically merely because a customer record was created unless GreenGrid approves that policy.

## 13. Enquiry-to-customer/project conversion

### 13.1 Eligibility checks

- Enquiry is Won/eligible.
- Required qualification and commercial checks are complete.
- Required quotation version is identified and accepted if this is the agreed rule.
- User has conversion permission.
- Customer duplicate candidates have been reviewed.
- Site information is sufficient to create or link an installation site.
- No previous conversion has completed.

### 13.2 Conversion wizard

**Step 1 — Review enquiry:** show prospect/contact, requirement, activity and documents; highlight missing required information.

**Step 2 — Choose customer:** create a new customer or link a confirmed existing customer; show duplicate candidates; preserve original enquiry details.

**Step 3 — Confirm site:** create/link installation site; confirm site contact and address; do not assume registered address is installation site.

**Step 4 — Confirm commercial basis:** select accepted quotation version/contract reference where required; show value and validity; do not silently select a newer draft.

**Step 5 — Project setup:** enter project title/reference details, responsible owner and expected start window; select approved project type/workflow template; review initial milestones.

**Step 6 — Review and convert:** show all records to be created/linked and request confirmation.

### 13.3 Atomic processing

On confirmation, backend:
1. Locks/validates enquiry conversion state.
2. Creates or links customer.
3. Creates or links site.
4. Creates project linked to customer/site/enquiry.
5. Links accepted quotation version, survey and relevant documents.
6. Creates initial milestones/tasks from approved template.
7. Records conversion actor/time and audit event.
8. Marks enquiry converted and retains history.
9. Commits the transaction.
10. Only after commit, queues notifications and optional invitation.

If a required database operation fails, roll back the transaction. A repeated request with the same idempotency key returns the existing conversion result rather than creating another project.

### 13.4 Post-conversion

- Enquiry shows linked customer and project.
- Customer profile shows originating enquiry.
- Project workspace receives initial records.
- Responsible employees receive configured notifications.
- Customer receives an update only if channel, consent and notification rules permit.

## 14. Data ownership and record effects

| User action | Data read | Data created/updated | Side effects |
|---|---|---|---|
| View enquiry list | Enquiries, contacts, addresses, assignments, follow-ups, statuses | None | Access-checked search/filter |
| Create enquiry | Sources, categories, geography, employees, duplicate candidates | Enquiry, contact/address links, initial status, activity, assignment if supplied | Optional acknowledgement/assignment event |
| Edit enquiry | Current enquiry and history | Allowed fields and audit history | Duplicate check if contact changes |
| Assign enquiry | Employee/group scope and current assignment | Assignment history | Notify new owner if configured |
| Schedule follow-up | Enquiry, employees, follow-up types | Follow-up record | Reminder event |
| Complete follow-up | Follow-up, enquiry | Completion outcome, activity and optional new follow-up | Work queue refresh |
| Mark lost | Current status, loss reason options | Status history and loss reason | Reporting/notification event if configured |
| Mark on hold | Current status, hold policy | Status history, reason and review date | Future reminder |
| Add customer | Contact/address categories, duplicate candidates | Customer, contacts, addresses/sites, audit | Optional invitation as separate action |
| Update customer | Current customer and related data | Allowed changes and history | Verification/notification if policy requires |
| Invite customer | Customer, verified contacts, invitation policy | Invitation record and secure token hash | Notification queue |
| Convert enquiry | Enquiry, customer matches, accepted quotation, survey, site, templates | Customer/site/project links, initial milestones/tasks, conversion/audit | Notifications after commit |

## 15. Critical validation and business rules

- At least one valid contact method is required unless an approved alternative process exists.
- Duplicate candidates are advisory until reviewed; no silent merge.
- One customer may have multiple enquiries, sites and projects.
- An enquiry is not automatically a customer.
- An enquiry can be converted only once; retry must be idempotent.
- Won conversion requires configured checks and permission.
- Lost requires a reason.
- On Hold requires reason and review date.
- Reassignment preserves previous owner history.
- Customer invitation is separate from customer record creation.
- Customer profile and finance information are permission-controlled.
- Address suggestions never overwrite manual data.
- Do not collect unnecessary sensitive information at initial enquiry.
- Critical transitions are server-validated and audited.

## 16. Acceptance tests

- [ ] Employee can create an enquiry with minimal required information.
- [ ] Draft save works if enabled.
- [ ] Invalid phone/email formats are identified clearly.
- [ ] Duplicate candidates appear without automatic merging.
- [ ] Enquiry filters work within the employee's scope.
- [ ] Assignment history retains previous owner.
- [ ] Follow-up completion adds activity and preserves the completed follow-up.
- [ ] Lost requires a loss reason.
- [ ] On Hold requires reason and review date.
- [ ] Customer can have multiple contacts and distinct sites.
- [ ] Customer address and installation site remain separate.
- [ ] PIN lookup failure does not block free-text address entry.
- [ ] Customer invitation is separate and time-limited.
- [ ] Customer portal cannot access an unlinked customer record.
- [ ] Conversion identifies duplicate candidates and exact accepted quotation version.
- [ ] Conversion creates one customer/site/project relationship transactionally.
- [ ] Retry does not create duplicate projects.
- [ ] Important actions are audited.
- [ ] No fake operational records are used.

## 17. Stakeholder decisions required

- Exact enquiry stages and who may change each stage.
- Minimum mandatory fields for phone, walk-in, website and WhatsApp enquiries.
- Assignment rules: manual, round-robin, territory, team queue or combination.
- Whether enquiry owner and follow-up owner may differ.
- Approved loss reasons and on-hold policy.
- When an enquiry is considered Won.
- Whether accepted quotation is mandatory before conversion.
- Whether conversion always creates a project or can create a customer first.
- Customer categories and required legal/business fields.
- Whether customers may have multiple named contacts/decision-makers.
- Customer invitation policy and verification method.
- Customer profile fields that may be self-updated.
- Contact consent and communication retention rules.
- Duplicate review and merge authority.

**Next chapter:** Surveys, survey scheduling, technical assessment, design and quotation screens, including field capture, review/approval, versioning and customer response.
