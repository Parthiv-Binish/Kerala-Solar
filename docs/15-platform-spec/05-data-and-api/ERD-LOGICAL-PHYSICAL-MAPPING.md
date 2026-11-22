# ERD Logical-to-Physical Mapping Register

**Document ID:** DATA-MAP-001  
**Status:** Proposed physical mapping for implementation review  
**Date:** 22 November 2026  
**Authority:** Stage 2 documents define logical business entities; this register maps them to the current PostgreSQL bootstrap model. It does not claim every domain has been migrated.

## 1. Mapping rules

- A logical entity must map to one canonical physical table or be explicitly marked pending/deferred.
- Physical names use snake_case and schema-qualified names.
- Do not create duplicate tables merely to mirror a logical label.
- A mapping does not imply that every logical attribute is already implemented. Column-level completion is tracked in the canonical data dictionary and migration backlog.
- Any change to a mapping requires an A4 proposal, A3/API impact review, A0 coordination and a recorded decision.
- Current bootstrap migrations are schema scripts, not evidence of execution against a live database.

## 2. Organization and access mapping

| Logical entity / concept | Canonical physical object | Mapping / status |
|---|---|---|
| employees | `org.employees` | Direct; employee profile, not credentials |
| departments | `org.departments` | Direct |
| employee_groups | `org.employee_groups` | Direct; group is membership/grant source |
| employee_group_memberships | `org.employee_group_memberships` | Direct; validity-dated |
| user_accounts / identity_accounts | `iam.identity_accounts` | Canonical account; account_type distinguishes employee/customer/service |
| employee account link | `iam.employee_account_links` | Typed subject link; one employee per linked account and one account per employee in current model |
| customer account link | `iam.customer_account_links` | Typed, customer-specific, verified/revocable link; introduced by migration 0006 |
| permissions | `iam.permissions` | Direct |
| permission sets | `iam.permission_sets` | Physical grouping of permission rules |
| group_permissions | `iam.permission_set_permissions` + `iam.group_permission_set_grants` | Logical relationship is represented by permission rules inside a set and a separate group-to-set grant; do not create `iam.group_permissions` |
| employee_permission_overrides | `iam.account_permission_overrides` | Physical override is account-scoped; employee-only authorization resolver first resolves the employee link |
| permission_scope_types | CHECK-constrained `scope_type` columns | Current bootstrap does not yet have a normalized scope catalogue table; UI labels/descriptions are pending configuration/API work |
| user_sessions | `iam.sessions` | Direct concept; refresh token hash stored |
| credentials | `iam.account_credentials` | Direct |
| invitations | `iam.invitations` | Account invitation/token lifecycle; intended customer/employee context must be validated by application |

## 3. Customer and CRM mapping

| Logical entity / concept | Canonical physical object | Mapping / status |
|---|---|---|
| customers | `crm.customers` | Core subject table introduced in migration 0006; remaining CRM attributes/master FKs are later backlog |
| customer_contacts | `crm.customer_contacts` | Core authorised-contact subject introduced in migration 0006; contact methods and consent remain later CRM work |
| customer_account_links | `iam.customer_account_links` | Links customer identity account to one customer and optional contact; no implicit cross-customer access |
| customer_addresses | Pending CRM migration | Logical design only; not created by migration 0006 |
| customer_contact_methods | Pending CRM migration | Logical design only |
| customer_consents | Pending CRM migration | Logical design only |
| enquiries and enquiry history | Pending CRM migration | Logical design only; enquiry may exist without customer |

## 4. Canonical authorization semantics

### 4.1 Scope keys

The only valid scope keys are `own`, `assigned`, `team`, `related`, `location`, and `company`. Migration 0005 maps legacy aliases. The database CHECK constraints reject legacy values after that migration. Scope references are parameters, not scope types; the application must validate each reference against the authenticated actor and the target resource.

### 4.2 Evaluation model

For a requested permission and record set:

1. Reject inactive/locked accounts, invalid sessions and revoked or inactive subject links.
2. For employee access, resolve the employee and currently valid group memberships. Customer access uses customer-account links and the customer/site policy only.
3. Resolve each grant's scope independently. Never convert a scope into another scope or infer team access from reporting hierarchy.
4. Expand active permission-set rules to individual permission effects. A permission-set `deny` is a deny candidate; a permission-set `allow` is an allow candidate only when the containing group grant is `allow`.
5. A group grant with effect `deny` denies the permissions in that set within the grant's matching scope, regardless of allow grants from other groups.
6. A matching individual override `deny` denies. An individual override `allow` may allow only when the administrator who created it was authorized to grant that permission, and never cancels a matching deny.
7. If any applicable deny matches the permission and record, deny that record. Otherwise allow only if at least one valid allow matches. No matching allow means deny.
8. Apply record predicates before pagination, counts, search, aggregate, export, file download, realtime subscription and background processing. Deny if a relationship or scope cannot be resolved.

This is a policy contract for backend implementation, not a database-only security boundary. The backend must implement and test the resolver; frontend visibility is not authorization.

## 5. Customer identity integrity rules

- A customer identity account is an `iam.identity_accounts` row with `account_type='customer'`.
- One customer account may have separate links to multiple customers; each link is independently verified.
- A customer may have multiple authorised customer accounts/contacts.
- If a link names a contact, that contact must belong to the same customer; migration 0006 enforces this with a composite foreign key.
- A link cannot become active without verification timestamp and customer account type. Revocation is retained, not deleted.
- No account may be treated as a customer merely because its phone/email matches a CRM contact.
- Employee and customer identity populations remain separate in the initial model. Shared login across populations is not supported until explicitly designed and approved.
- Customer account authorization is separate from employee group/scope authorization and must enforce customer/site ownership boundaries.

## 6. Migration coverage

| Migration | Physical scope | Status |
|---|---|---|
| 0001 | Domain schemas | Authored; execution not verified |
| 0002 | Reference/geography | Authored; execution not verified |
| 0003 | Organization and employee groups | Authored; execution not verified |
| 0004 | Identity, credentials, sessions, permissions and grants | Authored; execution not verified |
| 0005 | Canonical scope alias migration and CHECK constraints | Authored; execution not verified |
| 0006 | CRM customer/contact core and customer identity links | Authored; execution not verified |

Migration 0006 is deliberately a minimal customer subject foundation, not the full CRM schema. Later CRM migrations must extend these tables with the approved contact methods, addresses, consent, enquiry and history structures; they must not recreate the two core tables.

## 7. Verification still required

- Run all migrations 0001–0006 in order against a disposable supported PostgreSQL instance.
- Verify clean install, transaction rollback, constraints, trigger behaviour, indexes and no-seed-data rule.
- Add backend authorization truth-table and cross-customer/site isolation tests.
- Confirm business rules for household/customer representation, authorized representatives and verification evidence.
- Confirm whether one human may need employee and customer contexts; current design intentionally does not support a shared account.
- Review DDL with the database owner before treating it as approved.
