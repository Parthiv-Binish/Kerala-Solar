# Documentation Consistency Resolution Decisions

**Document ID:** DOC-DEC-001  
**Status:** Proposed canonical resolutions for GreenGrid stakeholder approval  
**Date:** 22 November 2026  
**Authority:** This document resolves internal wording conflicts for the next specification revision. It does not represent stakeholder approval, legal advice or implemented behaviour.

## 1. How to apply this document

These decisions are the proposed canonical interpretation for all affected documents. Update subordinate documents to match them. If GreenGrid rejects a proposal, record the alternative, approver, date, rationale and affected files in the decision log before implementation. Do not silently maintain competing interpretations.

## 2. Canonical employee access model

### 2.1 Concepts
- **Group:** organisational membership label; employees may belong to multiple groups.
- **Permission:** named action capability (for example, `crm.enquiry.view`).
- **Scope:** which records the capability applies to.
- **Relationship:** business linkage used to resolve related-record access.
- **Override:** time-bounded, justified individual allow or deny.
- Reporting-manager hierarchy never grants data access by itself.

### 2.2 Canonical scope keys

| Key | Meaning | Required resolver |
|---|---|---|
| `own` | Records explicitly owned/created by the authenticated employee, only where the domain defines ownership | Owner field on the record |
| `assigned` | Records actively assigned to that employee | Assignment relation with validity window |
| `team` | Records assigned to an explicitly configured team | Team membership and assignment relation; not inferred from manager |
| `related` | Records reachable through an explicitly approved business relationship, such as a customer/site/project linked to an assigned task | Domain-specific relationship traversal with bounded depth |
| `location` | Records associated with a company operating location the employee is authorised for | Employee-location membership and record location |
| `company` | All records within the single GreenGrid company boundary, subject to the permission | Company boundary predicate |

The following are **not** canonical scope keys: `branch`, `all`, `group`, `resource`. Map branch to `location` only if it means an authorised company operating location. A group is a membership/grant source, not a record scope. A resource reference is a scope parameter, not a scope type. Never interpret `company` as cross-company access.

### 2.3 Scope evaluation
1. Authenticate account and verify active status/session.
2. Resolve the linked employee identity.
3. Collect only currently valid group memberships and grants.
4. Resolve each grant's scope independently against the requested record/query.
5. Union the records authorised by valid allow grants; never widen a scope merely because two different scope labels are present.
6. Apply valid explicit denies. Any matching deny from a permission-set rule, group grant or individual override blocks that permission for the denied records.
7. Apply individual allows only when explicitly authorised by an administrator who can grant that capability; they do not bypass a matching deny.
8. Enforce scope before pagination, counts, aggregates, exports, file access, realtime subscription and background processing.
9. Deny by default. Missing relationship data, expired membership or unresolved scope means no access.

A scope parameter such as a team/location/resource identifier must be validated against the actor's authority; clients cannot choose arbitrary scope references. Customer accounts use verified `iam.customer_account_links` to customer/contact relationships and a separate customer/site authorization policy, not employee scopes. The initial physical model has separate employee/customer/service account types; a shared employee/customer login is unsupported until separately designed and approved.

### 2.4 Canonical precedence
- Account disabled/locked, expired session or revoked identity: deny all.
- Inactive permission, invalid membership/grant or expired validity: ignore it.
- Any matching explicit deny: deny the affected permission and records.
- Otherwise, one or more valid allows may authorise the records in their respective scopes.
- No matching allow: deny.
- An individual allow cannot override a deny. Removing a deny requires a separate authorised, audited change.

The same policy applies to list/detail/search/export/analytics/files/realtime/jobs. Add truth-table tests for overlapping groups, scope intersections, expiry and denies. Permission-set allow rules are effective only through a matching allow group grant; a permission-set deny or a matching deny group grant is a deny candidate. Any matching deny wins over all allows for that permission/record.



### 2.5 Physical mapping and customer identity

The canonical physical mapping is maintained in [ERD Logical-to-Physical Mapping](../05-data-and-api/ERD-LOGICAL-PHYSICAL-MAPPING.md). Employee identity uses `iam.employee_account_links`; customer identity uses `iam.customer_account_links`. The latter is customer-specific, optionally contact-specific, verified before activation and revocable with history. The minimum customer/contact subject tables and link are authored in migration 0006; remaining CRM tables are later migrations. No polymorphic employee/customer ID columns are permitted.

### 2.6 Authorization truth table for implementation tests

Assume the requested record is within the stated scope and all grants/memberships are currently valid.

| Matching group/permission-set allow | Matching group/permission-set deny | Individual allow | Individual deny | Expected |
|---|---|---|---|---|
| No | No | No | No | Deny |
| Yes | No | No | No | Allow within that grant's scope |
| Yes | Yes | No | No | Deny |
| No | No | Yes | No | Allow only if actor is authorised to grant that capability |
| Yes | No | Yes | No | Allow within the union of separately resolved scopes |
| Yes | No | Yes | Yes | Deny affected records |
| No | Yes | Yes | No | Deny affected records |
| Yes, expired | No | No | No | Deny (expired grant ignored) |
| Yes, wrong team/location/resource reference | No | No | No | Deny (scope predicate does not match) |

A positive test is insufficient. For each operation, test cross-customer/site access, search counts, export, file downloads, websocket subscriptions and background jobs. The same deny result must hold across every access path.

## 3. Canonical enquiry-to-project conversion

- Survey completion or approval does not create a project.
- An approved design enables quotation preparation.
- Customer acceptance must identify one exact issued quotation version.
- Commercial approvals/contract preconditions must be satisfied before the enquiry can enter Won.
- Before conversion, staff resolves the customer identity and the installation site. A candidate existing site must be confirmed; a new site must meet the minimum required address/site identity fields.
- An incomplete or ambiguous site remains a prospect-site/enquiry record and blocks project creation. It must not create a project with a guessed or placeholder site.
- The atomic, idempotent Won conversion links/creates the customer, confirmed site and project; links the accepted quotation version, survey and documents; creates initial milestones; records audit; and emits the customer invitation/notification only after commit.
- Repeated requests return the same conversion result. A customer can have multiple sites and projects.
- Corrections/merges are audited; never silently merge duplicate customer or site candidates.

## 4. Product and MVP boundary

| Product/runtime | MVP boundary |
|---|---|
| Staff Portal (responsive web) | MVP primary internal workspace |
| Technician Android | MVP foundation, assigned jobs and online-first field capture |
| Customer Android | MVP foundation for secure customer status and communication |
| Customer Web Portal | Phase 2 unless explicitly pulled into MVP by signed scope change; shares customer API, identity and permissions |
| Monitoring Engine | Background module; manual/initial provider verification first, production connectors gated by provider proof |
| Notification Engine | Background module; approved provider, templates and consent required |
| Platform Administration | Protected staff-portal area/module, not automatically a separate product/deployment |
| Backend/database/workers | One modular-monolith deployment boundary initially; separate worker processes, not independent microservices |

Customer and technician apps may share React Native packages/code, but remain separate user experiences and separately releasable app identities where app-store distribution requires it. A shared codebase does not imply shared navigation, permissions or data visibility.

## 5. Technician offline scope

Offline capture is a **Should / Phase 2** capability, not a condition for MVP acceptance. MVP technician foundations are online-first and must clearly handle connection loss without losing already-entered unsent form data during the current session where practical. Full encrypted local job packs, durable offline drafts across restart, media queueing, conflict resolution, assignment revocation and reliable background sync are Phase 2 deliverables with their own acceptance gate. Do not claim full offline operation in MVP marketing or release notes.

If GreenGrid elects to make offline operation a must-have MVP feature, obtain a scope/cost decision and move the complete offline acceptance set into the MVP before implementation.

## 6. Telemetry retention baseline

Use this provisional planning baseline consistently until GreenGrid approves a retention schedule:

| Data class | Provisional retention | Notes |
|---|---:|---|
| Raw provider payloads and normalized raw observations | 90 days | Restricted access; retain only fields needed |
| 15-minute aggregates | 12 months | Recomputable where source data remains |
| Daily aggregates | 5 years | Subject to storage, purpose and legal review |
| Alerts, fault events and integration audit | Separate approved schedule | Do not inherit telemetry retention automatically |
| Service evidence and customer documents | Separate business/legal schedule | Do not delete with telemetry |
| Security/audit logs | Separate legal/security schedule | Preserve required incident evidence |

This is a planning default, not an approved legal retention period. Remove the competing 5-minute/12–24-month proposal. Any exception requires data owner, purpose, cost estimate, legal basis, access class and approved deletion/archive process. Missing telemetry is never stored as a zero measurement.

## 7. Finance and receipt vocabulary

The initial release records funds received and verified by authorised staff; it does not initiate or confirm online payments through a gateway.

Canonical concepts:
- **Payment instruction/due:** amount requested or milestone expected; not money received.
- **Receipt:** record of funds actually received, initially unverified.
- **Verified/posted receipt:** staff has verified settlement using the approved procedure.
- **Allocation:** application of a posted receipt to an eligible due/invoice/project.
- **Reversal/refund:** compensating, audited record linked to the original receipt.
- **Gateway transaction:** out of scope unless separately approved and integrated.

Use receipt-oriented API command names such as `record-receipt`, `verify-receipt`, `allocate-receipt`, `reverse-receipt` and `record-refund`. Avoid a generic `POST /payments` endpoint in the initial contract. A UPI screenshot, customer claim or submitted reference is not proof of settlement. Supplier payments remain operational records with approval/evidence; they are not a customer payment gateway.

## 8. API naming authority

All routes in the logical API outline and screen examples are illustrative, not normative. Only the reviewed, version-controlled OpenAPI specification is normative. Use one canonical vocabulary:
- `enquiries`, not a parallel `leads` resource unless a separately approved lead entity exists.
- `service-cases` for canonical after-sales cases; generic `cases` only where a distinct case domain is defined.
- `receipts` and `receipt-allocations` for money received; `payment-instructions` or `dues` for amounts expected.
- Each operation has one stable operationId; no duplicate aliases without an explicit deprecation plan.

## 9. Regulatory and commercial rule applicability

Every configurable rule used for quotation, subsidy estimates, technical design or utility tracking must include:
- issuing authority and jurisdiction;
- source URL/document, exact clause/page and access date;
- publication date and effective-from/effective-to;
- date basis (application submission, sanction, commissioning or other explicit trigger);
- DISCOM/geography, consumer category, system type and capacity band where applicable;
- formula, unit, currency, exclusions and required evidence;
- rule version, reviewer, approval state and superseded-by reference.

Keep estimated, submitted, sanctioned and credited subsidy values separate. A case-study figure is not a production default. Customer output must label estimates and must not promise eligibility or entitlement. Qualified regulatory, tax and engineering review is required before activating a rule.

## 10. Logical-to-physical database mapping

Stage 2 ER documents describe logical concepts. Stage 3 dictionary and SQL migrations define physical names. The canonical register is [ERD Logical-to-Physical Mapping](../05-data-and-api/ERD-LOGICAL-PHYSICAL-MAPPING.md); it is the source for mapping status and identifies entities that are still logical-only. For the access domain, canonical physical mapping is:
- `employee_groups.group_id` ↔ logical `employee_group_id`;
- `employee_group_memberships.group_id` ↔ logical membership group FK;
- `iam.permissions.permission_id` ↔ logical permission;
- `iam.permission_sets` and `iam.permission_set_permissions` implement reusable capability bundles;
- `iam.group_permission_set_grants` links groups to permission sets and scope;
- `iam.account_permission_overrides` implements individual allow/deny;
- `iam.identity_accounts`, `iam.employee_account_links` and `iam.customer_account_links` implement authentication identity and typed employee/customer linkage. Migration 0006 adds the minimum customer/contact subject tables required for customer links.

Do not create duplicate physical tables merely to preserve a logical ER label. The physical mapping must include columns, PK/FK, cardinality, delete behaviour and migration.

## 11. Migration baseline

Migrations 0001–0006 are the current bootstrap SQL source. A follow-on migration must alter their schema through a formal, versioned path. Before Alembic adoption, choose exactly one baseline strategy: (a) execute SQL bootstrap once and stamp the equivalent Alembic baseline after schema verification, or (b) translate the bootstrap into Alembic revisions and retire the standalone execution path. Never run both paths against the same database. Migration 0005 canonicalizes scope values; migration 0006 adds the minimum customer/contact subjects and verified/revocable customer-account links. Neither has been executed in this review.

## 12. Change control and approval

All decisions above remain proposed until GreenGrid's authorised business owner and relevant technical reviewers approve them. Approval record must identify decision ID, approver role/name, date, accepted/rejected alternative, rationale and affected documents. No external legal, regulatory, engineering or provider assumption is approved by this document.


## 12. Plant terminology and physical identity

Use **solar plant** as the business-facing and API resource name because it describes the installed generation system in customer, project, monitoring and service workflows. The current physical entity is `asset.solar_systems`; its physical primary key is `solar_system_id`. Map the logical/API resource `plant` to `asset.solar_systems` and `plant_id` to `solar_system_id` in API/database adapters and documentation. Do not create a second `asset.plants` table. A plant is distinct from a project, installation site, inverter/device, meter, monitoring connection and service case. A project may create one or more plants only where the approved business workflow requires it; the default conversion must not assume every project has already been commissioned. Keep this mapping until a future approved data migration renames the physical entity.


## 13. Migration execution authority

For the current foundation, the ordered SQL files in `database/migrations/0001` through `0006` are the single canonical schema-change source. Apply them once, in numeric order, through the documented SQL runner; do not independently recreate their DDL in an Alembic branch or run a second bootstrap path. A migration ledger and disposable-PostgreSQL verification are required before any shared/staging/production application. Alembic is deferred until the backend implementation phase. Before adopting Alembic, convert the complete SQL history into a reviewed, schema-equivalent baseline/revision chain, verify it against a clean database, and retire direct SQL application for environments managed by Alembic. Never stamp an unverified schema and never run both mechanisms against one database.
