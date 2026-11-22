# Stage 2 — Organization, Employees & Access Control ER Design

**Project:** GreenGrid Solar Solutions — Solar Agency Management Platform  
**Stage:** 2 — Logical relationship design  
**Status:** Proposed design for stakeholder validation  
**Date:** 22 November 2026

## 1. Purpose

This document defines the logical data model for company organization, employee records, configurable employee groups, group membership, permissions, reporting relationships, user accounts, and access-control auditability.

The design follows the project requirement: employees are assigned to configurable groups, not forced into one fixed role. An employee may belong to multiple groups. Groups are created and maintained in the database by authorized administrators. Permissions are separate records and are granted through group-permission mappings, with optional individual overrides.

This is a logical design only. Physical PostgreSQL types, indexes, migrations, and final API contracts belong to later stages.

## 2. Core access-control principles

1. Employees may belong to multiple groups at the same time.
2. Group names are organizational labels, not permission definitions.
3. Permissions are granular system capabilities and are stored separately from groups.
4. A group can contain multiple permissions; a permission can be granted to multiple groups.
5. Individual employee overrides are supported, must be justified, time-bounded where appropriate, and audited.
6. Data scope is separate from the action permission. A user may be allowed to view enquiries but only within an assigned/team/company scope.
7. A reporting-manager relationship does not automatically grant access to all subordinate data.
8. Authorization is enforced by the backend for every protected operation. Hiding a button in the UI is not authorization.
9. Access changes should take effect promptly and be reflected consistently across web and mobile clients.
10. Do not hardcode department names, group names, permissions, or group-permission assignments in application code.

## 3. Proposed entities

### 3.1 employees

Stores the organization's employee profile. It is not the authentication credential record.

| Column | Key | Meaning |
|---|---|---|
| employee_id | PK | Stable employee identifier |
| employee_code | UQ | Company employee identifier, if used |
| first_name |  | Employee first name |
| middle_name |  | Optional middle name |
| last_name |  | Employee last name |
| display_name |  | Optional preferred display name |
| department_id | FK, nullable | Current department |
| employment_status_id | FK | Employment status master |
| date_of_joining |  | Optional joining date |
| date_of_leaving |  | Optional leaving date |
| is_active |  | Operational indicator; not a substitute for account status |
| created_at, created_by |  | Creation audit fields |
| updated_at, updated_by |  | Update audit fields |

Contact details and employee addresses remain in the separate employee contact/address entities documented in Stage 1. Authentication email/username and credentials are not duplicated here.

### 3.2 departments

| Column | Key | Meaning |
|---|---|---|
| department_id | PK | Stable identifier |
| department_name | UQ | Database-managed department name |
| department_code | UQ, nullable | Optional internal code |
| description |  | Optional description |
| is_active |  | Selectable status |
| created_at, created_by, updated_at, updated_by |  | Audit fields |

Departments are master data. Authorized administrators create and maintain them through the application. Do not hardcode department lists.

### 3.3 employment_statuses

| Column | Key | Meaning |
|---|---|---|
| employment_status_id | PK | Stable identifier |
| status_name | UQ | Database-managed status label |
| description |  | Optional description |
| is_active |  | Selectable status |

Actual status values must be configured in the database by an authorized administrator. Do not encode the business status list only as application enums.

### 3.4 employee_groups

| Column | Key | Meaning |
|---|---|---|
| employee_group_id | PK | Stable group identifier |
| group_name | UQ | Group name |
| group_code | UQ, nullable | Optional internal code |
| description |  | Purpose of the group |
| is_active |  | Whether the group can receive new memberships |
| created_at, created_by |  | Creation audit fields |
| updated_at, updated_by |  | Update audit fields |

Examples for discussion only: Admin, Sales, Marketing, Technician, Operations, Accounts, and Management. These are not hardcoded defaults. GreenGrid administrators will create the actual groups through the application.

### 3.5 employee_group_memberships

Many-to-many junction between employees and groups.

| Column | Key | Meaning |
|---|---|---|
| employee_group_membership_id | PK | Membership record identifier |
| employee_id | FK | Employee |
| employee_group_id | FK | Group |
| valid_from |  | Membership start |
| valid_to |  | Optional membership end |
| is_active |  | Current membership state |
| assigned_by | FK | Employee/admin who assigned membership |
| created_at |  | Assignment timestamp |
| ended_by | FK, nullable | Employee/admin who ended membership |
| ended_at |  | Optional end timestamp |
| change_reason |  | Optional reason |

Suggested constraint: prevent overlapping active duplicate memberships for the same employee/group. Preserve ended memberships for audit history rather than deleting them.

### 3.6 permissions

Defines individual capabilities in the platform. Permission keys should be stable machine identifiers; descriptions and display labels are maintained in the database.

| Column | Key | Meaning |
|---|---|---|
| permission_id | PK | Stable identifier |
| permission_key | UQ | Stable key such as crm.enquiry.view |
| permission_name |  | Display name |
| module_key |  | Module grouping key |
| description |  | What the permission allows |
| is_sensitive |  | Whether additional controls/audit are required |
| is_active |  | Whether permission can be assigned |
| created_at, created_by, updated_at, updated_by |  | Audit fields |

The permission catalogue is system configuration and needs controlled administration. Avoid changing a permission key after it has been referenced. New application capabilities may require a reviewed schema/configuration release to register their permission definitions; do not invent permissions dynamically from arbitrary user input.

### 3.7 group_permissions

Many-to-many junction assigning permissions to groups.

| Column | Key | Meaning |
|---|---|---|
| group_permission_id | PK | Assignment identifier |
| employee_group_id | FK | Group |
| permission_id | FK | Permission |
| effect |  | Grant or deny, if group-level deny is supported |
| scope_type_id | FK | Data scope |
| created_at, created_by |  | Assignment audit fields |
| updated_at, updated_by |  | Update audit fields |

Group-level effect is supported and is either allow or deny. A matching deny from any active group grant blocks the affected permission/records even when another group grants allow. Individual overrides also support allow/deny; individual allow cannot override a matching deny. The physical implementation uses permission sets and group_permission_set_grants rather than a direct group_permissions table. Maintain the logical-to-physical mapping in Stage 3; do not create duplicate tables. Logical uniqueness must prevent ambiguous duplicate grants for the same group, permission-set, scope and validity window.

### 3.8 permission_scope_types

Database-managed catalogue of the supported data scopes.

| Column | Key | Meaning |
|---|---|---|
| scope_type_id | PK | Stable identifier |
| scope_key | UQ | Stable key |
| scope_name |  | Display label |
| description |  | Scope semantics |
| is_active |  | Whether assignable |

Canonical scope keys (exact values): own, assigned, team, related, location, company.
- own: records owned/created by the employee, only where the domain defines ownership.
- assigned: records actively assigned to the employee through a validity-dated assignment relation.
- team: records assigned to an explicitly configured team; never infer team membership from manager hierarchy.
- related: records reachable through an explicitly approved domain relationship with bounded traversal.
- location: records associated with an operating location the employee is authorised for.
- company: records within the single GreenGrid company boundary, subject to the permission.

Do not use branch, all, group or resource as scope keys. Group is the grant source, not a data scope. A resource identifier is a validated scope parameter, not a scope type. Company does not mean cross-company access. The backend resolves each scope independently for list/detail/search/export/aggregate/file/realtime/background access. Store scope definitions in the database; do not hardcode dropdowns. Missing relationship data means deny.

### 3.9 employee_permission_overrides

Allows an authorized administrator to grant or deny an individual employee a specific permission/scope that differs from group-derived access.

| Column | Key | Meaning |
|---|---|---|
| employee_permission_override_id | PK | Override identifier |
| employee_id | FK | Employee receiving override |
| permission_id | FK | Permission affected |
| effect |  | Grant or deny |
| scope_type_id | FK, nullable | Scope affected; null only if explicitly defined as permission-wide |
| valid_from |  | Start timestamp |
| valid_to |  | Optional expiry |
| reason |  | Mandatory business justification |
| created_by | FK | Authorizing administrator |
| created_at |  | Creation timestamp |
| revoked_by | FK, nullable | Administrator revoking override |
| revoked_at |  | Revocation timestamp |
| revocation_reason |  | Reason for revocation |

Overrides must be auditable and should normally have an expiry for temporary exceptions. Do not allow an employee to grant themselves permissions. The permission-management service must verify that the actor is authorized to administer the affected permission.

### 3.10 employee_reporting_relationships

Stores reporting relationships separately from access grants.

| Column | Key | Meaning |
|---|---|---|
| employee_reporting_relationship_id | PK | Relationship identifier |
| employee_id | FK | Employee reporting to another employee |
| manager_employee_id | FK | Reporting manager |
| valid_from |  | Effective start |
| valid_to |  | Optional end |
| is_primary |  | Primary reporting relationship |
| created_at, created_by |  | Audit fields |

This supports reporting and workflow routing. It does not automatically grant a manager access to every record owned by a subordinate. If manager visibility is required, grant a suitable permission and explicit team scope.

### 3.11 identity_accounts

Authentication identity is separate from employee/customer profile data. The physical account table is `iam.identity_accounts`; each account has exactly one `account_type` (`employee`, `customer` or `service`) and an account status. Normalized login email/phone values are unique when present. Credentials, sessions and MFA are separate child entities. Do not add nullable `employee_id` and `customer_id` columns to this account table.

Employee subjects link through `iam.employee_account_links`. Customer subjects link through `iam.customer_account_links` (see below). The initial model does not support one account simultaneously representing an employee and customer; a shared identity context requires a separately approved design.

### 3.11.1 customer_account_links

A customer account is linked to a customer and optionally to one contact belonging to that same customer. The physical table is `iam.customer_account_links`; migration 0006 adds it and the minimum `crm.customers` / `crm.customer_contacts` subject tables. Links have pending, active, rejected and revoked states. Activation requires verification by an employee account; revocation retains timestamp, employee actor and reason. One customer can have multiple authorized accounts, and an account may be linked to multiple customers only through separate verified records. This link is not an employee permission grant and does not grant access to other customers or sites automatically.

### 3.12 account_statuses

Database-managed account status catalogue. Actual values are maintained through authorized configuration. Status transitions and security restrictions must be enforced server-side.

### 3.13 user_sessions

| Column | Key | Meaning |
|---|---|---|
| user_session_id | PK | Session identifier |
| user_account_id | FK | Account |
| session_token_hash | UQ | Hash of session token; never store raw bearer token |
| created_at |  | Creation time |
| expires_at |  | Expiration |
| last_seen_at |  | Last activity |
| revoked_at |  | Optional revocation |
| revocation_reason |  | Optional reason |
| device_metadata |  | Minimized device/client information |

Session tokens must be high entropy, stored hashed, revocable, and protected from exposure in logs.

### 3.14 authentication_events

| Column | Key | Meaning |
|---|---|---|
| authentication_event_id | PK | Event identifier |
| user_account_id | FK, nullable | Account, if known |
| event_type |  | Login success/failure, logout, reset, lockout, etc. |
| occurred_at |  | Event time |
| source_ip |  | Security-relevant source metadata, subject to retention policy |
| user_agent_summary |  | Minimized client metadata |
| outcome |  | Success/failure |
| details |  | Safe structured metadata; never credentials or tokens |

Authentication event types and outcomes should be defined in a controlled way. Do not log passwords, OTPs, session tokens, or secrets.

## 4. Entity relationship diagram

~~~mermaid
erDiagram
    DEPARTMENTS ||--o{ EMPLOYEES : organizes
    EMPLOYMENT_STATUSES ||--o{ EMPLOYEES : classifies
    EMPLOYEES ||--o{ EMPLOYEE_GROUP_MEMBERSHIPS : joins
    EMPLOYEE_GROUPS ||--o{ EMPLOYEE_GROUP_MEMBERSHIPS : has_members
    EMPLOYEE_GROUPS ||--o{ GROUP_PERMISSIONS : receives
    PERMISSIONS ||--o{ GROUP_PERMISSIONS : assigned_to
    PERMISSION_SCOPE_TYPES ||--o{ GROUP_PERMISSIONS : scoped_by
    EMPLOYEES ||--o{ EMPLOYEE_PERMISSION_OVERRIDES : receives
    PERMISSIONS ||--o{ EMPLOYEE_PERMISSION_OVERRIDES : overridden_for
    PERMISSION_SCOPE_TYPES ||--o{ EMPLOYEE_PERMISSION_OVERRIDES : scoped_by
    EMPLOYEES ||--o{ EMPLOYEE_REPORTING_RELATIONSHIPS : reports
    EMPLOYEES ||--o{ EMPLOYEE_REPORTING_RELATIONSHIPS : manages
    EMPLOYEES ||--o| IDENTITY_ACCOUNTS : via_employee_account_link
    IDENTITY_ACCOUNTS ||--o{ CUSTOMER_ACCOUNT_LINKS : customer_subject_link
    CUSTOMERS ||--o{ CUSTOMER_ACCOUNT_LINKS : authorized_accounts
    CUSTOMER_CONTACTS o|--o{ CUSTOMER_ACCOUNT_LINKS : optional_contact_scope
    IDENTITY_ACCOUNTS ||--o{ USER_SESSIONS : opens
    IDENTITY_ACCOUNTS ||--o{ AUTHENTICATION_EVENTS : generates
    ACCOUNT_STATUSES ||--o{ IDENTITY_ACCOUNTS : classifies
~~~

The diagram is conceptual. Employee accounts link through `iam.employee_account_links`; customer accounts link through `iam.customer_account_links` to `crm.customers` and optionally `crm.customer_contacts`. These typed link tables prevent unconstrained polymorphic subject IDs. Employee contact and address entities remain separate and reference employees.

## 5. Authorization evaluation rules

The backend evaluates access using the canonical policy in [Consistency Resolution Decisions](../13-implementation-blueprints/10-consistency-resolution-decisions.md):
1. Authenticate account and verify active status/session.
2. Resolve employee identity and currently valid group memberships.
3. Collect currently valid group permission-set grants and their scopes.
4. Resolve each scope independently against the requested records. Do not merge different scope labels into a broader scope.
5. Apply matching explicit denies from permission-set rules, group grants and individual overrides. Any matching deny blocks the affected permission for those records.
6. Otherwise, valid allows from groups and authorised individual overrides may grant access within their respective scopes.
7. An individual allow never overrides a matching deny. Removing a deny is a separate authorised, audited action.
8. Enforce scope before pagination, counts, search, aggregate, export, file access, realtime and background processing.
9. Deny by default if no valid permission/scope authorises the action. Missing relationship data means deny.
10. Audit sensitive permission changes and security-relevant access decisions.

Customer accounts use customer/site relationship authorisation, not employee scopes. Client-supplied scope references must be validated against the actor's authority. Reporting-manager relationships do not create access.

## 6. Master data and configuration rules

The following are database-managed records, not hardcoded business lists:
- Departments
- Employment statuses
- Employee groups
- Permission scope definitions and display descriptions
- Account statuses
- Other organizational classifications approved during discovery

Administrators create and maintain organizational master data through permission-protected application screens. Initial business master lists may be empty. The system must show a useful empty state rather than silently supplying hardcoded defaults.

Permission keys are stable technical capability identifiers used by backend authorization. Their definitions are controlled configuration, not arbitrary values created by ordinary administrators. The application may register new permission definitions as part of a reviewed software release; group-to-permission assignments remain managed through the database and application UI.

## 7. Constraints and integrity rules

- One employee may have many group memberships; one group may have many employees.
- One group may receive many permissions; one permission may be assigned to many groups.
- An employee may have multiple reporting relationships over time; only approved active/primary relationships may apply at a given time.
- Prevent an employee from reporting to themselves.
- Prevent invalid self-approval or privilege escalation.
- Enforce effective dates and prevent overlapping duplicate active memberships/overrides where they would be ambiguous.
- Do not physically delete employees, groups, permissions, or membership history that has been referenced; deactivate or end-date instead.
- Employee employment status and user-account status are distinct.
- An inactive employee should not retain usable employee access; account/session revocation must be handled explicitly and atomically as part of offboarding.
- Customer and employee identities must not be confused when linking user accounts.
- Do not store plaintext passwords, OTPs, raw session tokens, or API secrets.
- Audit group membership changes, permission assignments, overrides, account status changes, and session revocations.
- Reporting relationships alone never grant data access.

## 8. Admin workflows

### 8.1 Configure groups and permissions

1. Authorized administrator creates a group in the application.
2. Administrator adds a description and activates the group.
3. Administrator assigns permissions and approved data scopes.
4. Backend validates the administrator's authority and records an audit event.
5. Group becomes available for employee membership assignment.

### 8.2 Assign employee to groups

1. Authorized administrator opens an employee record.
2. Administrator selects one or more active groups.
3. Backend validates membership rules and records who assigned the membership and when.
4. Employee receives the combined effective access of active groups, subject to individual overrides and scope enforcement.
5. Removing membership ends the membership record; it does not erase history.

### 8.3 Add an individual override

1. Authorized administrator selects employee, permission, effect, scope, validity period, and mandatory reason.
2. Backend verifies privilege to administer that permission.
3. Backend checks for conflicting active overrides.
4. Override is saved with actor and timestamp.
5. Effective access is recalculated; the action is audited.
6. Temporary overrides expire automatically according to their validity window.

### 8.4 Employee offboarding

1. Mark employment status as leaving/inactive with effective date.
2. Disable or revoke the employee's account access at the effective time.
3. Revoke active sessions and refresh tokens.
4. End group memberships and temporary overrides as required by policy.
5. Preserve employee, assignment, approval, and audit history for legitimate business retention.

## 9. API expectations

Permission-protected API capabilities will be needed for employee search/profile/create/update/status changes; department and employment-status master data; group CRUD and activation/deactivation; group membership assignment/listing/termination; permission catalogue read and controlled configuration; group-permission assignment and scope configuration; employee-specific permission override creation/listing/expiry/revocation; reporting relationship management; account provisioning, activation/deactivation, session listing/revocation; and effective-permission inspection for authorized administrators and security support.

All authorization decisions must be made server-side. API endpoints must not trust a client-supplied employee ID or group membership as proof of access.

## 10. Open decisions for stakeholder validation

- Actual departments, employee groups, and reporting structure.
- Whether employees can have multiple active managers or one primary manager plus secondary relationships.
- Whether groups need explicit deny, or whether deny is only available through individual overrides.
- Whether group grants combine scopes by union, or whether one explicit scope must be selected per permission.
- How team boundaries are defined (explicit teams, department membership, project teams, or a combination).
- Who may create permission definitions and who may assign sensitive permissions.
- Whether employee and customer identities may ever share one login account.
- Account provisioning, MFA, password policy, identity-provider integration, session duration, and lockout policy.
- Offboarding timing and retention requirements for employee and authentication audit records.

Do not invent answers. Record stakeholder decisions before physical schema implementation.

## 11. Stage 2 acceptance checklist

- [ ] Group-based access model approved; employees may belong to multiple groups.
- [ ] Departments and employee groups are database-managed, not hardcoded.
- [ ] Permission catalogue and group-permission mapping reviewed.
- [ ] Own, assigned, team, and company scope semantics approved.
- [ ] Individual override precedence, expiry, and approval authority approved.
- [ ] Reporting hierarchy is confirmed to be separate from authorization.
- [ ] Account identity, session, and offboarding model approved.
- [ ] Audit and privilege-escalation safeguards reviewed.
- [ ] Open decisions are answered or explicitly deferred.

**Next domain:** Customers, Contacts, Addresses & CRM ER Design.
