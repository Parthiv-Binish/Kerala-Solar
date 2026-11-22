# Staff Portal — Navigation, Workspace Shell & Dashboard Specification

**Document ID:** UX-STAFF-001  
**Application:** APP-01 Management and Staff Web Portal  
**Status:** Proposed — stakeholder validation required

[← Application experience index](../00-application-suite-and-screen-inventory.md) · [← Project Book](../../../INDEX.md)

---

## 1. Purpose

The Staff Portal is the central workspace for running GreenGrid's solar business. It connects enquiry handling, customer records, surveys, quotations, project delivery, utility follow-up, procurement, finance, installation, monitoring and service.

It should help every employee answer:
1. What needs my attention?
2. What work am I responsible for?
3. What is the next action?

The portal is not a wall of company-wide numbers. It is a role-aware work area. Each employee sees only the modules, records and actions permitted by their effective permissions and data scope.

## 2. Access and sign-in

### 2.1 Sign-in sequence

1. User opens the staff portal.
2. The application checks for a valid session.
3. If there is no valid session, show sign-in.
4. User submits the configured login identifier and authentication proof.
5. Backend verifies credentials, account status, MFA requirements and security controls.
6. Backend resolves employee identity, group memberships, permission sets, individual overrides and data scopes.
7. Backend establishes the secure session.
8. Portal loads the user's Home dashboard and permitted navigation.

**Data read:** identity account, employee link, account status, authentication policy, group memberships, permission-set grants, individual overrides and session/device policy.

**Data written:** authentication/security event and session metadata. Passwords and raw refresh tokens must never be stored in readable form.

**Failure states:** invalid credentials, disabled account, expired invitation, MFA failure, locked account or temporary service outage. Messages must be understandable but must not reveal sensitive account existence or internal security details.

### 2.2 First-time access

- An authorised administrator creates/invites the employee account.
- Employee profile and login identity are explicitly linked.
- Employee receives an invitation through an approved channel.
- Employee completes activation and required authentication.
- Employee sees only permitted modules and records.
- No shared staff password or universal administrator account is allowed.

### 2.3 Account menu

- My Profile
- My Security (MFA/session options where enabled)
- Organisation/location context (only if multi-location access is approved)
- Help / Contact Administrator
- Sign Out

Do not expose internal permission implementation details to ordinary users.

## 3. Global workspace layout

### 3.1 Top bar

- GreenGrid product identity
- Current page title and breadcrumb
- Global search
- Notification centre
- Help entry
- Account menu

### 3.2 Primary navigation

1. Home
2. My Work
3. Enquiries
4. Customers
5. Surveys & Design
6. Quotations
7. Projects
8. Work Board
9. Utility Applications
10. Procurement & Inventory
11. Finance
12. Solar Plants & Monitoring
13. Service & Warranty
14. Documents
15. Reports
16. People & Access
17. Settings

Navigation is permission-aware. Do not show inaccessible modules as dead ends.

### 3.3 Main content area

Every page should follow a consistent pattern:
- Page title and short explanation
- Primary action, if permitted
- Search and relevant filters
- Main list, board, form or detail content
- Contextual help and related records where useful

### 3.4 Responsive behaviour

- Desktop: persistent sidebar and full workspace.
- Tablet: collapsible navigation drawer.
- Mobile browser: compact navigation and single-column forms.
- Tables should become readable card/list layouts where horizontal scrolling would be unusable.
- Keep status, ownership, due date and validation information visible on smaller screens.

### 3.5 Navigation rules

- Show a navigation item only if the user has view permission.
- Create, edit, approve, assign, delete/deactivate and export actions require separate permissions.
- Direct URL and API access must be checked by the backend.
- A view-only user must not receive active edit controls.
- Permission changes must take effect according to the session/cache invalidation policy.
- Branch/location filters narrow authorised data; they never expand access.
- Use the same labels for the same concept throughout the product.
- Use badges only for meaningful counts, such as overdue work or active alerts.
- Warn before discarding unsaved changes.
- Preserve safe form drafts after recoverable errors.

### 3.6 Breadcrumbs and record navigation

Example: Home → Enquiries → Enquiry details → Follow-ups.

- Breadcrumbs show the real parent path.
- Related-record links appear only when the user may access the target record.
- Opening a customer, project or site must trigger its own access check.
- Use human-readable business references in the UI; internal IDs remain behind the scenes.

## 4. Global search

### 4.1 Searchable record types

Only return records the user is authorised to discover:
- Enquiries
- Customers and contacts
- Sites/addresses
- Quotations
- Projects
- Tasks and work orders
- Utility applications
- Suppliers and purchase orders
- Receipts and expenses (finance permission required)
- Plants and equipment
- Monitoring alerts
- Service cases
- Document metadata

### 4.2 Search behaviour

- Search by business reference, permitted name/contact value, site locality, serial number or approved indexed field.
- Normalize phone/email input before matching.
- Mask sensitive contact details when the user lacks permission.
- Show record type, short description, status and relevant owner/date.
- Group results by type and limit the result count.
- Do not disclose hidden records when a user knows their reference number.
- Do not index document contents or sensitive fields without an explicit privacy/security decision.
- Fuzzy matches are suggestions only; never auto-merge records.

### 4.3 States

- Empty: show examples of supported searches.
- Loading: show progress without freezing the page.
- Results: grouped by type with permission-filtered links.
- No results: say no matching accessible records were found.
- Error: provide retry guidance without database/query details.

## 5. Notification centre

### 5.1 Notification categories

- New assignment or reassignment
- Follow-up due/overdue
- Approval requested
- Work returned for correction
- Project milestone at risk/overdue
- Purchase or stock action awaiting approval
- Relevant payment/receipt event
- Utility follow-up due
- Monitoring alert requiring attention
- Service case assignment or escalation
- Integration/background-job failure requiring administrator attention

### 5.2 Interaction

- Bell opens a panel with unread count.
- Selecting an item opens its linked record after access validation.
- Allow mark-as-read/unread and, if useful, bulk mark-as-read.
- Avoid sensitive personal/financial details in notification previews.
- Preferences may control non-critical categories/channels; mandatory security messages cannot be silently disabled.

### 5.3 Data flow

Business event → notification event → recipient resolution → preference/policy check → message preparation → queue → provider delivery attempt → delivery status → in-app inbox state.

Store event identity, recipient, channel, template/version, timestamps, provider reference, attempt result and safe failure code. Queueing is not proof of delivery.

## 6. Home — Operations Dashboard

### 6.1 Design objective

The dashboard is a personal action centre. It should answer "What should I do next?" before presenting broad statistics.

### 6.2 Section A — Greeting and context

Display:
- Greeting and employee display name
- Current date/time in configured organisation timezone
- Current organisation/location context, if applicable
- Short explanation of what needs attention

### 6.3 Section B — My Attention

Potential cards:
- Tasks due today
- Overdue tasks
- Follow-ups due
- Approvals waiting for the user
- Work returned for correction
- Assigned service/monitoring items
- Records blocked by missing information

Each card opens a filtered list. Counts must be calculated only from records the user may access.

### 6.4 Section C — My Work Queue

Each row/card shows:
- Work reference and type
- Short action-oriented title
- Customer/project/site, where permitted
- Next action
- Due date/time
- Priority
- Current status
- Owner/assignee
- One primary action

Sort urgent/overdue work first, then due date. Do not rank only by creation date.

### 6.5 Section D — Team/business overview

Show only with explicit aggregate-report permission. Possible indicators:
- New/unassigned enquiries
- Enquiries awaiting follow-up
- Surveys awaiting scheduling/review
- Quotations awaiting response
- Active projects by stage
- Overdue/at-risk milestones
- Utility applications awaiting action
- Stock shortages or allocations needing attention
- Receivables/finance exceptions for finance-authorised users
- Active monitoring alerts
- Open/overdue service cases

Only show indicators with clear definitions and useful drill-down actions.

### 6.6 Section E — Recent Activity

Show recent events on accessible records:
- Actor
- Action
- Timestamp
- Record link
- Whether the event was user-generated or system-generated

Do not expose internal notes or private details to users without access.

### 6.7 Section F — Quick Actions

Examples, only when permitted:
- Add enquiry
- Add customer
- Schedule survey
- Create task
- Create service case
- Record receipt
- Register plant

Show only common actions the user can actually perform.

### 6.8 Dashboard data sources and processing

| Dashboard element | Reads from | Processing | Destination |
|---|---|---|---|
| My tasks | Tasks, assignments, status history | Filter by employee and authorised scope; calculate due state | My Work/task detail |
| Follow-ups | Enquiry follow-ups, ownership, status | Calculate due/overdue in organisation timezone | Follow-up queue |
| Approvals | Approval records and workflow state | Resolve pending approver and allowed actions | Approval detail |
| Enquiry counts | Enquiries, assignments, status | Count by permitted status/owner/date | Filtered enquiry list |
| Project progress | Projects, milestones, history | Summarise stage, overdue and blocked milestones | Project workspace |
| Utility queue | External applications and milestones | Find pending action and ageing since last verified update | Utility tracker |
| Inventory exceptions | Stock balances/reservations/requests | Calculate shortage and allocation exceptions | Inventory queue |
| Finance indicators | Receipts, allocations, expenses | Calculate from posted records and approved finance rules | Finance views |
| Monitoring alerts | Alerts, events, status | Count active/unacknowledged alerts; respect recovery | Alert inbox |
| Service queue | Cases, assignments, SLA events | Calculate priority, ageing and escalation | Service desk |
| Recent activity | Activity/audit event views | Filter accessible records and redact protected fields | Record history |

Dashboard values are derived views, not independently editable totals.

### 6.9 Date/time rules

- Store timestamps consistently in UTC.
- Display using the configured organisation timezone.
- Due dates use the business timezone and configured business calendar.
- Calculate overdue from due time, current time and completion/pause rules.
- A browser timezone difference must not change a business due date.
- Record the timezone used when interpreting user-entered schedule values where needed.

### 6.10 Dashboard filters

Where relevant:
- Date range
- Organisation location/branch
- Team
- Assigned employee
- Project stage
- Status

Filters narrow the authorised dataset only. Remembered filters must be visible and easy to clear.

### 6.11 Empty, loading and failure states

- No assigned work: "You have no work assigned right now" and relevant next action.
- No permission for a metric: omit the card or explain access is unavailable; do not show a misleading zero.
- No business records: show a setup-oriented empty state, never fake sample figures.
- Loading: stable skeleton/placeholder layout.
- Partial failure: identify the failed section and allow section-level retry.
- Stale integration data: show last successful update and warning.
- Zero alerts: say "No active alerts" only after a successful query.

## 7. My Work workspace

### 7.1 Purpose

One place for the employee to manage assigned actions across modules.

### 7.2 Views

- Today
- Upcoming
- Overdue
- Waiting for someone else
- Returned to me
- Completed recently

### 7.3 Work item types

- Enquiry follow-up
- Survey appointment/review
- Quotation preparation/revision
- Project task/milestone
- Utility follow-up
- Purchase/stock approval
- Finance action
- Installation job
- Monitoring alert
- Service case/visit
- Document review

### 7.4 Work item display

Show reference, type, action-oriented title, linked customer/project/site (if authorised), due date, priority, status, owner, blocker/dependency and one primary action.

### 7.5 Processing rules

Completing a work item must update its owning domain through the correct workflow service. Do not mark an enquiry follow-up, milestone, service case and installation order complete through one generic status update that bypasses domain validation.

My Work is a consolidated view, not a second source of truth. Completion writes to the owning domain and creates activity/audit history.

## 8. My Profile

### 8.1 Sections

- Basic employee details
- Contact methods
- Profile photo (if enabled)
- Work groups visible to employee
- Reporting contact (if configured)
- Language/display preferences
- Notification preferences
- Security/session options

### 8.2 Edit permissions

Employees may edit only approved fields, such as display preferences or selected contact methods. Legal name, employee identifier, employment status, group membership, permission assignments and reporting relationship require authorised workflows.

### 8.3 Validation

- Normalize and verify contact values according to policy.
- A changed phone/email does not automatically change the login identifier.
- Sensitive profile changes are audited.
- Show pending-verification state where required.

## 9. Shared list, detail and form conventions

### 9.1 List pages

Every module list should contain:
- Page title and one-sentence purpose
- Primary create action, if permitted
- Search
- Useful filters
- Saved views where justified
- Result count and pagination
- Role-appropriate columns
- Row action menu with permitted actions only
- Empty, no-result and error states

Prioritise reference, subject, status, owner, due date and useful context. Do not expose every database field as a column.

### 9.2 Detail pages

A record detail page should generally include:
- Header with reference, title, status and permitted actions
- Summary
- Current owner and next action
- Relevant tabs/sections
- Linked records
- Documents/evidence
- Activity timeline
- Audit-sensitive history where authorised

### 9.3 Forms

- Group fields by the user's task, not database tables.
- Mark required fields and explain why.
- Show conditional fields only when relevant.
- Load business options from database-backed APIs.
- Provide plain-language help for unfamiliar terms.
- Validate in UI and backend.
- Preserve values after recoverable errors.
- Warn before leaving with unsaved changes.
- Use a review step for consequential submissions.
- Never rely on frontend validation alone.

## 10. Permission capability catalogue

Proposed capabilities to reconcile with the IAM design:
- dashboard.view
- work_queue.view
- enquiry.view/create/update/assign/convert
- customer.view/create/update
- survey.view/schedule/review
- quotation.view/create/approve/send
- project.view/update/approve
- task.view/assign/complete
- utility_application.view/update
- inventory.view/receive/issue/adjust/approve
- finance.view/receipt.create/payment.create/adjust
- plant.view
- monitoring.view
- alert.acknowledge
- service_case.view/assign/resolve/close
- document.view/upload/download
- report.view/export
- employee.view
- group.manage
- permission.manage
- settings.manage
- integration.manage
- audit.view

These are capability examples, not hardcoded employee roles.

**Scope examples:** own, assigned, team, location/branch, related customer/project, company-wide. Backend applies scope to every query and mutation. Explicit deny overrides grants. Individual overrides require reason, actor, timestamps and expiry/review policy. Reporting hierarchy alone does not grant unrestricted visibility.

## 11. Global errors and feedback

Use clear messages:
- "You don't have access to this action. Contact your administrator if you think this is incorrect."
- "This record was updated by another user. Review the latest version before saving."
- "Your changes are saved as a draft. They have not been submitted."
- "The connection was interrupted. Your draft is preserved; retry when you're online."
- "The action could not be completed. No changes were saved."
- "This item is already processed. Open the record to view its current status."

Never show stack traces, SQL errors, credentials, provider secrets or raw internal exceptions.

## 12. Acceptance checklist

- [ ] Sign-in and session flow follows the identity/security specification.
- [ ] Navigation is generated from effective permissions.
- [ ] Direct URL/API access is server-authorised.
- [ ] Dashboard cards show only authorised data.
- [ ] Dashboard distinguishes real zero from failed/stale data.
- [ ] My Work aggregates tasks without becoming a second source of truth.
- [ ] Global search does not disclose inaccessible records.
- [ ] Notification previews avoid protected data.
- [ ] Responsive navigation and forms remain usable.
- [ ] Empty, loading, partial-failure and error states are defined.
- [ ] Important actions create activity/audit events.
- [ ] No business data is hardcoded or inserted as mock migration seed data.

## 13. Stakeholder decisions required

- Organisation timezone, working days, holidays and business hours.
- Multiple branches/warehouses in initial scope.
- Which groups need dashboard metrics and aggregate reporting.
- Approval matrix and financial/inventory action limits.
- Employee profile fields that employees may self-edit.
- Global search privacy rules for contact, serial and finance references.
- Dashboard refresh expectations and data freshness requirements.
- Whether saved views and personal dashboard customisation are required in V1.

**Next chapter:** detailed Enquiries and Customer Management screens, fields, validations, actions, data writes and enquiry-to-customer conversion.
