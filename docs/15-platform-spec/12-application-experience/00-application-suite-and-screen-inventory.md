# GreenGrid Solar — Application Suite, Screen Inventory & User Experience Blueprint

**Document type:** Product and UX architecture  
**Status:** Proposed baseline for stakeholder validation  
**Purpose:** Define the software products, user-facing screens, navigation, workflows and data movement before backend implementation.

[← Back to the Project Book & Master Index](../../INDEX.md)

---

## 1. Why this document exists

This blueprint answers five questions before development begins:

1. What software and applications are we building?
2. Who will use each application?
3. What pages or screens will each person see, and how will they navigate?
4. What can a user do on each screen?
5. What information is read, entered, checked, calculated, saved, updated or sent elsewhere?

The goal is a system that feels straightforward to office staff, technicians and customers. Users should see the information and actions relevant to their work, not database concepts or unnecessary technical complexity.

This is a product-design baseline, not a claim that the screens or integrations are already implemented.

## 2. Product suite

The proposed solution is one connected platform with several focused experiences and background services.

| ID | Product / service | Primary users | Main purpose | Delivery |
|---|---|---|---|---|
| APP-01 | Management and Staff Portal | Management and authorised employees | Run day-to-day solar business operations | Responsive web |
| APP-02 | Technician App | Surveyors, installers and service technicians | Complete assigned field work and submit evidence | Android app |
| APP-03 | Customer App | Solar customers | Follow projects, view plant information and request support | Android app |
| APP-04 | Customer Web Portal | Solar customers | Access customer services through a browser | Responsive web |
| SVC-01 | Solar Monitoring Engine | Automated service; operations users consume its alerts | Receive device telemetry, evaluate health and create alerts | Background service |
| SVC-02 | Notification and Communication Engine | Automated service; customers and employees receive messages | Prepare, queue, deliver and track notifications | Background service |
| APP-05 | Platform Administration | Specifically authorised administrators | Configure the platform, integrations, access and operational controls | Protected web area |

### 2.1 Shared platform foundation

All products use the same secured backend and central PostgreSQL database.

- The web and mobile applications communicate with backend APIs. They never connect directly to PostgreSQL.
- Identity and permissions are checked by the backend for every protected action.
- Customer, employee and service identities remain distinct.
- Employee groups organise people; permission sets define what they may do. A group name alone does not grant access.
- A customer can have multiple sites and projects.
- A solar project, installed plant, device, monitoring alert and service case are separate records connected by explicit relationships.
- Notifications are generated from business events and delivery preferences, not from screens independently sending uncontrolled messages.
- Business master data is entered by authorised users through the application. Database migrations create structure, not fake customers, employees, suppliers or business records.

## 3. Roles and everyday language

The system should present work according to the user's assigned access and responsibilities.

| User group / persona | Typical work |
|---|---|
| Management | Review business status, approve defined actions and monitor performance |
| Sales / Enquiry staff | Record enquiries, contact prospects, arrange surveys and follow quotations |
| Survey team | Schedule and complete site surveys |
| Design / Technical team | Prepare system designs, technical documents and quotations |
| Project coordinator | Coordinate milestones, people, materials and dependencies |
| Procurement / Store staff | Manage suppliers, purchase orders, stock and material allocation |
| Accounts staff | Record receipts, payments, expenses and outstanding balances |
| Regulatory / Liaison staff | Track utility and subsidy applications, documents, inspections and follow-ups |
| Installation team | Complete installation, testing, commissioning and handover tasks |
| Service team | Review faults, assign visits, resolve service cases and manage warranties |
| Customer | Follow their own enquiries, projects, documents, payments, plant and service requests |
| Technician | See only assigned or otherwise authorised field jobs |
| Platform administrator | Configure technical settings and access controls |

One employee may belong to multiple groups. The portal must show only the pages and actions permitted by the employee's effective permissions and data scope.

## 4. Navigation principles

### 4.1 Staff web portal

Recommended primary navigation:

- Home
- Enquiries
- Customers
- Surveys & Design
- Quotations
- Projects
- Work Board
- Utility Applications
- Procurement & Inventory
- Finance
- Solar Plants & Monitoring
- Service & Warranty
- Documents
- Reports
- People & Access
- Settings

The navigation is permission-aware. It should not show inaccessible modules as confusing dead ends.

### 4.2 Technician app

Recommended bottom navigation:

- Today
- My Jobs
- Calendar
- Updates
- Profile

A job opens into a focused workflow with the task details, customer/site information, checklist, forms, photos/documents, notes and completion action. A technician should not have to navigate the full staff portal to finish a field task.

### 4.3 Customer app and web portal

Recommended primary navigation:

- Home
- My Solar
- Projects
- Documents
- Support
- Notifications
- Profile

The customer sees only their own authorised customer, site, project, plant, financial and service information. The app should explain status in plain language and identify the next expected action where possible.

### 4.4 Navigation behaviour shared by all products

- Keep primary navigation stable and predictable.
- Use the same labels for the same concept throughout the platform.
- Put the most common action near the relevant list or detail page.
- Use search, filters and saved views where lists become long.
- Preserve form progress when safe; warn before discarding unsaved changes.
- Show clear validation beside the field that needs attention.
- Use confirmation for irreversible or financially significant actions.
- Show a useful empty state with a next action instead of a blank screen.
- Display status with text, not colour alone.
- Provide a consistent record history or activity timeline where relevant.
- Support responsive layouts, keyboard navigation and readable touch targets.
- Do not make users re-enter information already safely available in the same workflow.

## 5. APP-01 — Management and Staff Web Portal

### 5.1 Main navigation and screen inventory

| Area | Screen | Purpose and primary actions |
|---|---|---|
| Home | Operations Dashboard | Show assigned work, overdue items, pending approvals, project progress, service alerts and business summaries according to access |
| Home | My Work | Bring together tasks, follow-ups, approvals and reminders assigned to the signed-in employee |
| Enquiries | Enquiry List | Search, filter, view and create prospective customer enquiries |
| Enquiries | New / Edit Enquiry | Capture contact, location, requirement, source and initial notes |
| Enquiries | Enquiry Details | View activity, owner, status, follow-ups, linked survey and conversion history |
| Enquiries | Follow-up Planner | Schedule calls, visits and reminders; record outcomes |
| Customers | Customer List | Search and open registered customers |
| Customers | Add / Edit Customer | Record customer identity and contact information with duplicate checks |
| Customers | Customer Profile | View contacts, sites, enquiries, projects, documents, payments and service history according to permission |
| Customers | Sites & Addresses | Add and manage customer properties and installation locations |
| Surveys & Design | Survey Schedule | Plan survey appointments and assign surveyors |
| Surveys & Design | Survey Details | Review visit status, assigned team and site information |
| Surveys & Design | Survey Submission | Review measurements, electrical/site observations, photos, checklist and surveyor notes |
| Surveys & Design | System Design | Prepare or review system configuration, components and design documents |
| Quotations | Quotation List | Track draft, sent, revised, accepted, rejected and expired quotations |
| Quotations | Quotation Builder | Prepare line items, quantities, pricing, taxes and validity under approved rules |
| Quotations | Quotation Details | Review versions, approvals, customer response and linked project conversion |
| Projects | Project List | Find projects by stage, owner, site, status and expected completion |
| Projects | Project Workspace | See project summary, milestones, tasks, team, materials, documents, costs and timeline |
| Projects | Milestone Board | Track stages, due dates, blockers, evidence and responsible owners |
| Work Board | Task List / Board | View and manage work by owner, team, priority, status and due date |
| Work Board | Task Details | Assign work, add instructions, dependencies, checklist and completion evidence |
| Utility | Application Tracker | Track utility / DISCOM / subsidy application status and follow-up dates |
| Utility | Application Details | Store application references, submitted documents, inspection dates, corrections and outcomes |
| Procurement | Supplier Directory | Maintain supplier contacts and commercial details |
| Procurement | Purchase Orders | Prepare, review and track purchase orders |
| Inventory | Stock Overview | View available, reserved, allocated and damaged stock by location |
| Inventory | Item / Batch Details | Track product identity, batch, serial number, movement and allocation |
| Inventory | Stock Movement | Record receipt, issue, transfer, return and adjustment with authorisation |
| Finance | Receipts | Record customer payments received and allocate them to the correct obligation |
| Finance | Payments | Record approved outgoing payments and their references |
| Finance | Expenses | Record project or business expenses with category and evidence |
| Finance | Customer Ledger | View invoices/receivables, receipts, allocations, dues and adjustments |
| Finance | Project Financial Summary | Review estimated and actual cost, receipts and margin indicators |
| Plants | Plant Registry | Find commissioned solar plants and their customer/site links |
| Plants | Plant Details | Review installed capacity, commissioning, components, warranty and monitoring status |
| Monitoring | Monitoring Overview | Review plant health, data freshness, active alerts and communication status |
| Monitoring | Alert Inbox | Triage, acknowledge, assign and track monitoring alerts |
| Service | Service Desk | Review reported faults, cases, priority, owner and response status |
| Service | Service Case Details | Record diagnosis, communication, work orders, visits, resolution and closure |
| Service | Work Order / Visit | Plan and track field service work |
| Warranty | Warranty Register | Review coverage, start/end dates, provider and claim status |
| Documents | Document Centre | Search authorised project/customer documents and manage versions/access |
| Reports | Operational Reports | View role-appropriate pipeline, project, stock, finance and service reports |
| People & Access | Employee Directory | View employee records and employment status |
| People & Access | Groups & Memberships | Create groups and manage which employees belong to them |
| People & Access | Permission Sets | Define allowed actions and resource scopes independently from group names |
| People & Access | Access Review | Review effective grants, overrides and access history |
| Settings | Business Settings | Configure approved operational reference values and workflow options |
| Settings | Notification Rules | Configure supported event, audience, channel and template rules |

This is a product-level inventory. Some rows may become tabs within one workspace rather than separate URLs. The detailed screen specifications will decide the final composition.

### 5.2 Staff portal's main end-to-end journey

**Enquiry → Survey → Design → Quotation → Customer approval → Project → Utility tracking → Procurement → Installation → Commissioning → Handover → Monitoring → Service**

At each transition, the system should check that required information and approvals exist. It should not allow a user to accidentally skip a mandatory stage simply by changing a status field.

### 5.3 Example: creating an enquiry

**Screen:** New Enquiry

- User enters: contact name, one or more contact methods, location, enquiry source, requested system/requirement and notes.
- System reads: existing customers, contacts, open enquiries and permitted geography/reference data to suggest possible matches.
- System processes: required-field checks, phone/email format checks, duplicate warnings and assignment rules.
- System stores: a new enquiry and its initial activity record. It may link to an existing customer/contact if the user confirms the match.
- System triggers: an acknowledgement and internal assignment notification when the configured rules and delivery channels are available.
- System does not: automatically create a confirmed customer, project, quotation or payment record merely because an enquiry was submitted.

## 6. APP-02 — Technician Mobile App

### 6.1 Navigation and screen inventory

| Screen | Purpose and primary actions |
|---|---|
| Sign in / Device Verification | Authenticate the employee and verify permitted device/session requirements |
| Today | Show today's assigned work, priority, location and due time |
| My Jobs | List assigned surveys, installation tasks and service visits |
| Job Details | Show job instructions, customer/site contact details and current status |
| Site Information | Show authorised address, access notes and relevant installation/site history |
| Start Job | Record arrival/start time and job acceptance where required |
| Survey Checklist | Enter site observations, measurements and structured answers |
| Photo & Document Capture | Capture and upload site evidence with category and context |
| Installation Checklist | Complete assigned installation steps and record required evidence |
| Equipment / Serial Capture | Record installed component identity and serial numbers against the correct project/plant |
| Testing & Commissioning | Enter readings, test outcomes, defects and completion evidence |
| Service Visit | Review reported issue, diagnosis, actions taken, parts used and visit outcome |
| Customer Acknowledgement | Capture customer acknowledgement where the approved process requires it |
| Submit Work | Validate required checklist items and evidence, then submit for review |
| Job History | Review completed and returned jobs |
| Updates | Receive assignment changes, instructions and work-related notifications |
| Profile | View own details, app preferences and sign-out |

### 6.2 Field workflow

1. Technician signs in.
2. Opens Today or My Jobs.
3. Opens a specific assigned job and checks the site and instructions.
4. Starts the job when on site and permitted.
5. Completes only the checklist relevant to that job type.
6. Captures readings, serial numbers, notes and photos as required.
7. Reviews the submission for missing mandatory items.
8. Submits the work.
9. The office reviewer accepts it or returns it with a reason.
10. The technician receives the decision and any follow-up task.

### 6.3 Field data behaviour

- Save drafts locally where safe and supported; clearly show whether data is pending upload or successfully synchronised.
- Do not show a successful server submission until the backend confirms it.
- Keep original evidence and its metadata; do not silently replace submitted evidence.
- Record who submitted or changed a result and when.
- Prevent duplicate submissions when a user retries after a network interruption.
- Restrict access to customer information to assigned or otherwise authorised work.
- Do not let a technician alter commercial quotations, financial ledgers or global inventory settings unless separately authorised.

## 7. APP-03 and APP-04 — Customer Android App and Customer Web Portal

Both customer experiences should provide the same core capabilities and terminology. Layout may adapt to mobile or browser, but the business rules and access rights remain consistent.

### 7.1 Navigation and screen inventory

| Screen | Purpose and primary actions |
|---|---|
| Welcome / Sign In | Explain customer access and authenticate the customer |
| Account Verification | Verify an approved contact or invitation flow before linking the account |
| Home | Show current project stage, plant summary, important updates and next action |
| My Profile | View and update permitted personal/contact details |
| My Properties | View the customer's registered sites and addresses |
| My Enquiries | View submitted enquiries and their current progress |
| Enquiry Details | See status, assigned follow-up information and customer-visible activity |
| My Projects | List projects linked to the signed-in customer |
| Project Timeline | Explain completed, current and upcoming project stages in plain language |
| Survey / Visit Schedule | View customer-visible appointments and visit updates |
| Quotations | View authorised quotation versions and their validity |
| Quotation Response | Accept, decline or request clarification using the approved workflow |
| Documents | Access permitted quotations, receipts, certificates, manuals and handover files |
| Payments | View authorised payment requests, due amounts and recorded receipts |
| My Solar Plants | List commissioned plants linked to the customer |
| Plant Details | View system details, commissioning information and warranty summary |
| Solar Performance | View available generation/performance data with data freshness and source context |
| Notifications | Read important project, payment, monitoring and service updates |
| Raise a Service Request | Describe an issue, choose the relevant plant/site and attach evidence |
| My Service Requests | Track submitted cases, appointments and customer-visible updates |
| Service Request Details | View status, scheduled visit, requested information and resolution summary |
| Help & Contact | Find approved support contact information and guidance |
| Privacy & Account | Review privacy information and submit account/privacy requests through the approved process |

### 7.2 Customer journey

1. Customer receives an enquiry acknowledgement or account invitation through an approved channel.
2. Customer verifies access and sees only records linked to their account.
3. Customer can follow enquiry and project progress without calling the office for every update.
4. Customer reviews quotation and responds through the available approved action.
5. During execution, customer sees relevant schedule and milestone updates.
6. After commissioning, the plant appears in My Solar Plants.
7. Available monitoring data is displayed with its last update time and any data gaps.
8. Customer can raise a service request and follow its progress.

### 7.3 Customer experience safeguards

- Use plain descriptions such as "Survey scheduled" instead of internal codes.
- Explain what a status means and what happens next.
- Never expose internal notes, employee-only documents or another customer's records.
- Show payment status from recorded transactions; do not imply that a payment succeeded merely because the customer viewed instructions or uploaded a screenshot.
- Clearly distinguish a device alert from a confirmed service case.
- If monitoring data is unavailable or stale, say so. Never display missing telemetry as zero generation.
- Customer-facing actions must have a confirmation and a clear result.

## 8. SVC-01 — Solar Monitoring & Alert Engine

This is an automated service, not a manual data-entry application for customers.

### 8.1 Operations screens that consume monitoring data

| Screen | Primary users | Purpose |
|---|---|---|
| Monitoring Overview | Operations / authorised management | View plant connectivity, data freshness and health summaries |
| Plant Monitoring Details | Monitoring / service team | Inspect current and historical readings and device status |
| Alert Inbox | Monitoring / service team | Review, acknowledge, assign and correlate alerts |
| Alert Details | Monitoring / service team | Inspect source event, severity, evidence, history and recovery |
| Integration Health | Platform administrator | Review provider connection health, last successful poll and failures |

### 8.2 Automated processing flow

1. A configured provider/device connector supplies telemetry or status data.
2. The backend validates source identity, timestamp, payload shape and plant/device mapping.
3. The system records accepted readings and ingestion metadata.
4. Rules evaluate readings, device status, data freshness and configured thresholds.
5. The engine creates or updates an alert when a defined condition is met.
6. Alert deduplication and recovery rules prevent repeated noise.
7. An alert may be routed to an authorised operations queue and may trigger a notification.
8. An employee may create or link a service case after triage.
9. Alert recovery and service-case resolution remain separate events.

**Important:** Manufacturer APIs, protocols, credentials, polling limits and commercial access must be verified for each device/provider. Do not assume all inverter brands expose a supported API.

## 9. SVC-02 — Notification & Communication Engine

### 9.1 Notification management screens

| Screen | Users | Purpose |
|---|---|---|
| Notification Inbox | Each signed-in employee/customer | Read notifications relevant to that identity |
| Notification Rules | Authorised administrator | Configure supported business events, recipients and channels |
| Message Templates | Authorised administrator | Maintain approved message templates and language variants |
| Delivery Log | Authorised operations/admin | Review queued, sent, delivered, failed and retried messages |
| Provider Configuration | Platform administrator | Configure provider references and connection status without exposing secrets |

### 9.2 Notification workflow

1. A business event occurs, such as enquiry received, survey scheduled, quotation issued, milestone updated, payment recorded, job assigned or service case changed.
2. The backend checks the event's notification rule and intended audience.
3. It resolves recipients from authorised customer/employee relationships and preferences.
4. It prepares a message from an approved template.
5. It queues delivery through the configured channel provider.
6. The provider response and subsequent delivery events are recorded when available.
7. Failed messages follow a bounded retry and failure-handling policy.
8. The in-app notification remains available where the product supports it, even if an external channel fails.

WhatsApp, SMS, email and push delivery require provider configuration, consent/preferences where applicable, templates and production verification. A notification being queued is not proof that it was delivered or read.

## 10. APP-05 — Platform Administration

This is a protected area for technical and security administration. It is not a general-purpose staff workspace.

| Screen | Purpose |
|---|---|
| Admin Overview | Show platform health, background job status, integration health and security warnings |
| User Accounts | Review account status, invitations, lockouts and identity links |
| Groups & Permission Sets | Configure employee group membership and permission definitions |
| Individual Access Overrides | Review exceptional grants/denials with reason and expiry where applicable |
| Session & MFA Management | Review and revoke sessions or manage approved authentication controls |
| Reference Data | Manage approved master/reference data through controlled screens |
| Integration Registry | Configure and inspect provider integrations |
| Background Jobs | Review scheduled/queued job execution and failures |
| Error Logs | Investigate application errors with sensitive values redacted |
| Audit Events | Search security-sensitive and business-critical changes |
| Backup & Recovery Status | Review backup jobs, last successful backup and restore-test evidence |
| System Settings | Manage approved application-level settings |

Secrets must be stored in a suitable secret-management mechanism or protected deployment environment, not displayed in plain text or committed to the repository.

## 11. Shared data lifecycle and ownership

The same business record may be used by multiple applications, but each kind of data should have a clear source of truth.

| Information | First created / maintained in | Used by | Main processing |
|---|---|---|---|
| Employee and group membership | Staff portal / protected admin | Staff portal, technician app, backend | Effective access calculation and audit |
| Customer and contact | Staff portal; customer may update permitted profile fields | All authorised customer/project workflows | Identity matching, validation and relationship linking |
| Enquiry | Staff portal or approved customer-facing enquiry entry | CRM, notifications, sales reports | Assignment, follow-up, conversion |
| Site and address | Staff portal; customer may propose permitted changes | Survey, project, technician, plant and service | Address validation and postal-reference lookup |
| Survey | Technician app or authorised staff workflow | Design, quotation, project | Completeness checks and technical review |
| Design and quotation | Staff portal | Customer portal, project, finance | Versioning, approvals and conversion |
| Project and milestones | Staff portal | Technician app, customer app, reports | Dependency checks, progress and overdue calculation |
| Utility application | Staff portal | Project, customer updates, reports | External status and follow-up tracking |
| Supplier, item and stock | Staff portal | Procurement, projects, finance, installation | Availability, reservation, allocation and movement |
| Receipt, payment and expense | Finance screens in staff portal | Customer portal, project, reports | Allocation, balance and reconciliation checks |
| Installation and commissioning evidence | Technician app / authorised reviewer | Project, asset registry, customer portal | Checklist validation and handover readiness |
| Plant and device registry | Staff portal / approved integration workflow | Monitoring, customer portal, service | Device-to-plant mapping and warranty linkage |
| Telemetry | Monitoring connectors | Monitoring, analytics and customer portal | Validation, storage, aggregation and freshness |
| Alert | Monitoring engine; staff may triage/update | Service desk, notifications, monitoring dashboard | Deduplication, acknowledgement, recovery |
| Service case | Customer app or staff/service desk | Technician app, service desk, customer portal | Deduplication, assignment, visit and resolution |
| Documents | Relevant workflow with protected file upload | Customer, staff and technician apps as authorised | Classification, access checks, versioning and retention |
| Notification delivery | Notification engine | In-app inbox and configured external channels | Queueing, provider response, retry and audit |

## 12. Screen-level data specification standard

Every screen will receive a detailed specification using this template before its implementation.

| Field | What the specification must state |
|---|---|
| Screen ID and name | Stable identifier and user-facing label |
| Application | Staff portal, technician app, customer app/web or admin |
| Audience and permission | Who can open it and at what data scope |
| Entry points | How the user navigates to the screen |
| Purpose | The problem the screen solves |
| Information displayed | Data read and its source record |
| User inputs | Fields, formats, required/optional status and help text |
| Actions | Create, edit, submit, approve, assign, cancel, export or other actions |
| Validation | Field, business-rule and cross-record checks |
| Processing | Calculations, workflow transitions, matching and automation |
| Data writes | Records created or updated and the owning domain |
| Side effects | Stock movement, ledger allocation, task creation or other linked changes |
| Notifications | Event, recipient, channel and delivery status |
| Audit | Who did what, when, reason and before/after values as appropriate |
| Failure states | Validation, permission, network, provider and conflict handling |
| Success state | Confirmation and next recommended action |
| Acceptance tests | Verifiable scenarios proving the screen works correctly |

### Example detailed data flow — Record a customer receipt

**Screen:** Finance → Receipts → Record Receipt

- **User sees:** customer, related project, outstanding obligations, receipt history and available allocation balance.
- **User enters:** received amount, date, payment method, reference/transaction identifier, receiving account/cash reference and optional evidence.
- **System reads:** customer/project relationship, outstanding balances, existing receipts and finance permissions.
- **System validates:** positive amount, permitted date, required reference for the selected method, duplicate transaction reference checks and allocation limits.
- **System processes:** creates the receipt and allocates it to one or more eligible obligations according to the user's authorised selection.
- **System stores:** receipt, allocation records, evidence metadata and audit event in one consistent transaction.
- **System updates:** outstanding balance and relevant project/customer financial summaries.
- **System notifies:** customer and authorised staff according to configured rules.
- **System prevents:** duplicate receipt posting, over-allocation and treating an unverified payment instruction as received money.

The final detailed design must specify exact field names, allowed values, table ownership and API operations against the canonical data dictionary.

## 13. Usability and error-prevention requirements

These apply across the entire product suite.

1. **Progressive disclosure:** show essential information first; place advanced fields in expandable sections.
2. **Contextual forms:** ask only for information relevant to the selected workflow or job type.
3. **Smart defaults:** prefill known customer, site, project, owner and date information when safe.
4. **No silent overwrites:** explain conflicts and preserve manually entered information.
5. **Field-level validation:** show the exact field and how to correct it.
6. **Business validation:** block actions that would create inconsistent records. For example, a receipt must be recorded before it can be allocated as money received.
7. **Safe save behaviour:** distinguish draft, submitted, approved and synchronised states.
8. **Duplicate prevention:** detect likely duplicate enquiries, contacts, receipts, service cases and provider events.
9. **Clear status language:** explain what happened, what is waiting and who owns the next action.
10. **Role-aware simplicity:** hide irrelevant actions without hiding information the user needs to complete their work.
11. **Evidence-first field work:** make required photos, readings and checklist items clear before submission.
12. **Accessible design:** readable typography, keyboard support, screen-reader labels, contrast and touch-friendly controls.
13. **Network-aware mobile use:** show offline/pending-sync state and safe retry behaviour.
14. **Traceability:** preserve important changes and the identity of the person or process that made them.

## 14. Important boundaries and exclusions

- The platform tracks government/utility application progress; it does not replace official portals. Automated submission is only possible where an authorised, supported integration is verified.
- The platform records payments and financial operations; no payment gateway is assumed.
- The finance module is operational project/customer finance, not a complete statutory accounting, payroll, GST filing or tax-return product unless separately scoped.
- Monitoring is read/observe/alert oriented. Remote inverter control, firmware updates or unsafe device commands are not included.
- The platform does not assume every manufacturer offers a usable API.
- Missing or stale telemetry must never be interpreted as zero production.
- A monitoring alert is not automatically a confirmed service case.
- Notification queueing is not proof of delivery or reading.
- No mock business data or prefilled customer/employee/supplier records are to be inserted by schema migrations.
- Legal, privacy, regulatory, tax and electrical-engineering requirements require qualified review and current evidence.

## 15. Implementation planning gates

Do not begin detailed backend implementation until the following product-design outputs have been reviewed:

| Gate | Required output | Completion condition |
|---|---|---|
| UX-01 | Product suite and ownership | Every application/service has a clear purpose, audience and boundary |
| UX-02 | Navigation maps | Main navigation and route hierarchy approved for each user experience |
| UX-03 | Screen inventory | Every required screen is listed and duplicate/unnecessary screens are resolved |
| UX-04 | Screen specifications | Inputs, outputs, processing, permissions and failure states documented |
| UX-05 | Workflow maps | End-to-end business journeys and exception paths are reviewed |
| UX-06 | Data mapping | Every screen action maps to a data owner and approved entity/table |
| UX-07 | Notifications | Events, recipients, channels, consent/preferences and failure handling specified |
| UX-08 | Acceptance criteria | Each critical screen and workflow has testable acceptance scenarios |
| UX-09 | Stakeholder validation | GreenGrid confirms operational details and unresolved assumptions are recorded |

## 16. Next documents to create

This blueprint establishes the product map. It should be expanded into separate, reviewable documents:

1. Staff Portal — complete navigation tree and detailed screen specifications.
2. Technician App — screen-by-screen field workflows and offline/synchronisation behaviour.
3. Customer Android and Web — customer journeys, screen specifications and access rules.
4. Monitoring & Alert Engine — provider ingestion, rules, alert lifecycle and operations screens.
5. Notification Engine — event catalogue, templates, recipients, preferences and delivery states.
6. Platform Administration — identity, permissions, settings, integrations, audit and operations.
7. Cross-application workflow maps — enquiry-to-installation, commissioning-to-monitoring and service resolution.
8. Screen-to-data/API mapping — exact reads, writes, validations and side effects for every screen.

**Design rule:** keep the experience simple for the user while keeping validation, permissions, data integrity and audit controls strong behind the scenes.
