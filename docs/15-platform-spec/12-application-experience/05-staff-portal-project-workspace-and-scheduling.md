# Staff Portal — Project Workspace, Milestones, Tasks & Scheduling

**Document ID:** UX-STAFF-005 · **Status:** Proposed, review required

## 1. Purpose
Turn an accepted commercial proposal into a controlled delivery workspace. A project is a delivery record, not the quotation itself. It retains customer, site, accepted quotation version, design version and project ownership references.

## 2. Navigation
Staff Portal → Projects: Overview, Project Register, My Projects, Project Board, Calendar, Milestones, Tasks, Blockers, Delayed Projects, Completed Projects. Entry points include accepted quotation hand-off, customer/site profile and My Work.

## 3. Project creation
Preconditions: exact accepted quotation version, acceptance evidence, valid customer/site, no existing conversion for the same acceptance, required internal approvals. Creation is idempotent. Show a review screen before commit: customer/site, scope, accepted quote, design/BOM references, payment prerequisites, target dates, project manager and delivery team.

Fields: project reference (generated), title, customer, site, accepted quotation/version, approved design/version, project type, priority, owner, planned start/end, scope summary, internal notes, customer-visible summary. Do not copy mutable quotation values without preserving source snapshots.

## 4. Project workspace
Header: status, reference, customer/site, owner, priority, progress, next milestone, due date and blocker indicator. Tabs: Overview, Scope, Milestones, Tasks, Schedule, Utility, Procurement, Installation, Finance summary, Documents, Activity, Risks and Change Requests. Tabs are permission filtered.

Overview shows current phase, next action, overdue items, assigned teams, open blockers and recent activity. Scope shows included/excluded work from accepted quote. Changes require a controlled change request and commercial/technical approval where scope or price changes.

## 5. Lifecycle
Proposed states: Preparing, Ready to Schedule, In Progress, On Hold, At Risk, Completed, Cancelled, Closed. State transitions require permission and reason. Completed requires mandatory milestones and evidence; Closed requires administrative checks. On Hold requires reason, owner and review date. A delayed project is a calculated flag, not an independent status.

## 6. Milestones
Milestone fields: type, title, sequence, planned start/due, actual start/completion, owner, predecessor, status, evidence requirement, customer visibility and completion note. Templates may create standard milestone sets but must be configurable. Dependencies prevent completion before prerequisites unless an authorised override is recorded. Milestone completion validates required tasks, documents and approvals.

## 7. Tasks
Task fields: title, description, project, milestone, assignee/team, priority, start/due, estimate, status, dependency, checklist, attachments, visibility and completion evidence. Statuses: Open, Assigned, In Progress, Blocked, In Review, Done, Cancelled. Task reassignment preserves history. Tasks can be internal or field-executable; field jobs appear in Technician App only after dispatch/assignment rules pass.

## 8. Calendar and scheduling
Views: list, week, month and resource schedule. Filters by owner, team, project, milestone and task type. Rescheduling checks availability, dependencies, leave/working calendar and site appointment constraints when those data exist. Conflicts are shown, not silently overwritten. Time zone is organisation-configured; store timestamps consistently.

## 9. Blockers, risks and changes
Blocker record: affected item, category, description, owner, raised date, target resolution, impact, next action and resolution evidence. Risk record includes probability/impact and mitigation. Change request records requester, reason, scope impact, cost/schedule impact, technical review, approval and resulting new baseline. Do not edit baseline dates without history.

## 10. Customer visibility
Only approved milestones and customer-safe summaries are exposed to customer channels. Internal task notes, staff assignments, supplier prices, risk commentary and private documents remain internal. A customer-facing progress statement must be derived from the project record and explicitly published.

## 11. Data movement
Reads: customer/site, accepted quotation snapshot, design, employee/team, project templates, calendars, payment prerequisites. Writes: project, project scope snapshot, milestones, tasks, assignments, dependencies, blocker/risk/change records, activity and audit events. Project creation and source conversion must be one transaction or a recoverable idempotent workflow.

## 12. Permissions
project.view/create/update/assign/hold/complete/close/cancel; milestone.manage/complete; task.create/assign/update/review; schedule.manage; blocker.manage; risk.manage; change_request.submit/approve; project.export. Apply record scope and separate customer-visible publishing permission.

## 13. Notifications and failures
Notify owners on assignment, due/overdue, blocker, schedule change, review request and milestone completion. Failure cases: duplicate conversion, missing acceptance, invalid dependency, unavailable assignee, conflicting schedule, stale concurrent edit and missing completion evidence. Use optimistic concurrency and explain corrective action.

## 14. Acceptance tests
- [ ] Accepted quotation version is preserved.
- [ ] Repeated conversion does not create duplicate project.
- [ ] Milestone dependencies are enforced.
- [ ] Reassignment and schedule changes are audited.
- [ ] Required evidence blocks premature completion.
- [ ] Customer view excludes internal-only details.
- [ ] On-hold projects require reason and review date.
- [ ] Changes to baseline require approved change request.
- [ ] Project completion checks required workflow stages.

## 15. Decisions
Confirm project templates, project states, milestone definitions, working calendar, customer-visible milestone policy, completion/closure rules, project manager authority and change approval matrix.
