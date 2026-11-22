# Staff Portal — Employees, Groups, Permission Sets & Business Settings

**Document ID:** UX-STAFF-014 · **Status:** Proposed

## 1. Purpose
Provide business-level employee and access administration. Platform-level security operations remain in the restricted administration area. Group membership is a way to organise staff; groups do not replace explicit permissions or resource scope.

## 2. Navigation
Organisation → Employees, Teams/Groups, Permission Sets, Memberships, Individual Overrides, Access Review, Working Calendar, Notification Preferences, Business Settings and Approval Policies.

## 3. Employee directory
Fields: employee reference, name, work contact, employment state, department, location, supervisor, start/end dates and assigned groups. Personal identifiers and sensitive HR data are excluded unless separately approved. Deactivation revokes future access according to session/token policy but preserves historical actor references.

## 4. Groups
Create configurable groups such as Sales, Survey, Technician, Accounts, Stores and Support. A user may belong to multiple groups. Membership has effective dates, inviter/approver, reason and audit. Group names do not inherently grant rights.

## 5. Permission sets and scopes
Permission set is a named collection of capabilities. Scope limits records: own, assigned, team, related customer/project, location or company. The API evaluates identity, active group grants, direct grants, explicit denies/overrides and record scope using documented precedence. UI hiding is not security.

## 6. Individual overrides
Override fields: user, capability, allow/deny, scope, reason, approver, start/end and review date. Temporary elevation expires automatically. Deny precedence and conflict rules must be explicit and tested. Broad company-wide scope requires elevated approval.

## 7. Access review
Managers review group membership, unused grants, temporary overrides, inactive employees and privileged access. Record reviewer, decision, reason and due date. Export access review report under restricted permission.

## 8. Business settings
Manage working days/hours, holiday calendar, time zone, numbering formats, approved contact channels, notification preferences, task templates and workflow policy. Settings are versioned with effective dates and change audit.

## 9. Approval policies
Configure approver roles/limits for discounts, purchasing, expenses, refunds, design review and other controlled actions. Avoid circular approval chains. Changes require elevated permission and test preview.

## 10. Data movement and permissions
Reads: employee, group, permission catalogue, memberships, policy and calendar. Writes: memberships, permission assignments, overrides, review records, business settings and audit. Capabilities include employee.manage, group.manage, permission_set.manage, override.approve, access_review.perform and settings.manage.

## 11. Acceptance tests
- [ ] User can belong to multiple groups.
- [ ] Group name alone grants no implicit access.
- [ ] Backend enforces scope for every read/write.
- [ ] Temporary overrides expire.
- [ ] Deactivated employee cannot continue normal access.
- [ ] Privileged changes are audited and reviewed.
- [ ] Manager access does not automatically equal administrator access.

## 12. Decisions
Confirm group catalogue, permission precedence, direct grant policy, manager review cadence, employee lifecycle, approval limits, working calendar and who can administer access.
