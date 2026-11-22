# Full Documentation Consistency Review

**Review ID:** DOC-AUDIT-001  
**Branch:** main  
**Review date:** 22 November 2026  
**Review type:** Static repository/documentation review  
**Overall result:** Broadly coherent product direction; high-priority contract mismatches must be resolved before API/database implementation.

## 1. Executive assessment

The repository describes one central API and PostgreSQL system of record, a staff web portal, technician Android app, customer Android app and web portal, monitoring and notification background services, and a restricted platform administration area.

The following principles are repeated consistently:
- Configurable employee groups; users may belong to multiple groups.
- Group membership, permission capabilities and resource scope are separate concepts.
- APIs enforce authorization; clients do not connect directly to PostgreSQL or Redis.
- Enquiry, customer, site, project, plant, device, alert and service case are distinct linked records.
- Government portals and manufacturer clouds remain external/authoritative unless authorised integrations are verified.
- No payment gateway is assumed.
- Monitoring is read-only; missing telemetry is not zero; alert recovery does not close a service case.
- Provider delivery, government status and internal workflow status are not conflated.
- Draft documents are not proof of approval, implementation, testing or compliance.

These are strong foundations. The main issues are at the boundary between logical design, physical schema, workflow wording and implementation contracts.

## 2. Findings by severity

### High priority — resolve before implementation

#### AUD-001 — Resource-scope vocabulary is inconsistent

**Evidence**
- SRS FR-004 lists own, assigned, team, branch, related and all.
- Application chapters and screen blueprint use own, assigned, team, related customer/project, location and company.
- Stage 2 access ER design defines own, assigned, team and company as initial conceptual scope keys.
- Migration 0004 constrains scope_type to own, assigned, group, company and resource.

**Risk:** A permission may be designed with one scope label and rejected or interpreted differently by the database/API. Group, resource, related, location, branch and company are not interchangeable.

**Required decision:** Approve one canonical scope vocabulary and semantics table. For every scope define the record predicate, relationship data required, valid domains and behaviour for list, detail, search, export, aggregate, file download, realtime and background jobs. Decide whether branch is retained, renamed to location or represented as a resource relationship. Avoid generic all unless its company boundary is explicit.

**Owner:** Security/architecture lead + business owner.  
**Acceptance:** SRS, Stage 2 ER, Stage 3 dictionary, SQL constraints, API contract and permission matrix use the same canonical values.

#### AUD-002 — Permission-deny precedence is not fully specified

**Evidence**
- The short security overview says group grants combine and explicit deny overrides allow.
- Stage 2 ER says group-level deny is optional and suggests individual deny overrides if group-level deny is not required.
- Migration 0004 supports allow/deny in permission-set permissions, group grants and account overrides.
- Application chapters refer to direct grants, explicit denies and individual overrides, but do not provide one complete deterministic precedence algorithm.

**Risk:** Two engineers can calculate different effective permissions for the same user, especially where multiple groups, overlapping scopes or expired memberships exist.

**Required decision:** Publish one deterministic policy covering membership validity, permission-set effect, group grant effect, account override, scope intersection, expiry, explicit-deny precedence, service identities and emergency access. Define whether a deny can be overridden and by whom. Add truth-table examples and automated tests.

**Owner:** Security lead.  
**Acceptance:** One authoritative policy is referenced by Stage 2, Stage 3, security architecture, staff/admin UX and API tests.

#### AUD-003 — Logical access ER names do not map cleanly to bootstrap SQL

**Evidence**
- Stage 2 ER uses names such as employee_group_id, employee_group_membership_id and a group_permissions relationship.
- Migration 0003 uses org.employee_groups.group_id and group_id in membership rows.
- Migration 0004 implements permission_sets, permission_set_permissions, group_permission_set_grants and account_permission_overrides rather than the same entity names used in the Stage 2 conceptual model.
- Stage 3 dictionary has started using physical group_id naming.

**Risk:** The logical ERD, dictionary, migration and API may describe the same concept under different names, causing incorrect foreign keys, duplicate tables or undocumented translation layers.

**Required decision:** Treat Stage 2 as logical naming only if intentional and add a mandatory logical-to-physical mapping table. Otherwise revise Stage 2 to match canonical physical names. Include PK/FK names, cardinality, lifecycle and source-of-truth mapping.

**Owner:** Database lead.  
**Acceptance:** One reviewed mapping covers every Stage 2 access entity and current SQL migration.

#### AUD-004 — Project creation trigger needs one explicit end-to-end rule

**Evidence**
- The enquiry workflow says Won conversion creates/links a customer, creates a project/site, links the accepted quotation and creates milestones transactionally.
- The cross-application workflow says survey approval creates design-eligible work and does not create a project; accepted quotation conversion creates the project idempotently.
- SRS FR-013 says convert Won enquiry to customer/project with duplicate prevention.

**Assessment:** These can be consistent if Won is only reachable after acceptance of an issued quotation and project creation is the conversion transaction. The first workflow does not state this precondition explicitly enough.

**Required clarification:** Define the canonical rule: survey approval enables design; approved design enables quotation; customer acceptance of an exact issued quotation enables Won; Won conversion creates/links customer, site and project exactly once. If GreenGrid needs a pre-sales project before quote acceptance, model it as a separate prospect-work record/status with defined restrictions.

**Owner:** Product/business owner.  
**Acceptance:** Workflow, SRS, screen actions, API command and transaction tests use the same trigger and prerequisites.

### Medium priority — resolve during contract completion

#### AUD-005 — Application programme had stale status and next-step information

The application documentation programme listed Staff Portal chapters A05–A14 and app/service books as Planned and named A05 as the next delivery even though those chapters and app/service books already existed.

**Correction made during this review:** A05–A14 now show Draft; the old delivery order was replaced with remaining screen/action, field, permission, workflow, API/data and acceptance work; the next delivery statement was corrected.

**Status:** Corrected and committed. The chapters remain drafts, not approved specifications.

#### AUD-006 — Screen-to-API catalogue is a traceability standard, not a complete endpoint contract

The catalogue says concrete routes and schemas are assigned during API design. The API blueprint lists endpoint families but intentionally does not define all operations or request/response schemas.

**Risk:** The API catalogue could be mistaken for a complete build-ready API.

**Required action:** Generate the endpoint register from approved screen/action IDs, including operation ID, method/path, request/response schema, permission, scope, transaction, idempotency, error codes, audit and test ID.

#### AUD-007 — Application chapters are not uniformly at the same depth

The early Staff Portal chapters are substantially more detailed than several later chapters. The programme's G1–G8 quality gates require fields, actions, permissions, data, integration failure, UX states and acceptance tests.

**Required action:** Score every chapter against G1–G8. Populate a screen/action register and field catalogue with coverage status per screen. Do not treat chapter count as proof of equal specification depth.

#### AUD-008 — SRS is too compact to be the sole acceptance baseline

Important rules currently appear only in workflow/application chapters: immutable survey/quotation versions, exact quotation acceptance, receipt verification/allocation, stock reservation versus issue, customer-safe projections, alert/case separation, duplicate prevention, provider webhook handling and offline conflict resolution.

**Required action:** Expand the SRS into atomic, testable requirements with stable IDs. Map each requirement to screen, API, entity, permission and test.

#### AUD-009 — Database migrations are an initial foundation, not the complete application schema

Migrations 0001–0004 create schemas, reference/geography, organisation and identity/access structures. Stage 3 describes many additional business domains. The migration README calls these initial bootstrap scripts.

**Required action:** Maintain a migration coverage matrix: entity/table, target migration, dependency, DDL review and test status. Resolve the Alembic baseline/stamp approach before adopting a formal migration runner. Do not create a second path that reapplies 0001–0004. No claim is made that these SQL scripts have been executed on a live database.

#### AUD-010 — Duplicate security documents need an authority label

The short authorization/privacy/security file is an overview, while the longer platform security architecture is much more comprehensive. Stage 2 access ER and SQL also contain detailed access-control design.

**Required action:** Declare the long security architecture the authoritative security design; mark the short file as a summary linking to it, or merge/retire the duplicate. Stage 2 remains the logical ER source; Stage 3 remains the physical mapping source.

#### AUD-011 — Notification and integration contracts are not provider-ready

The documents describe adapters, consent, template approval, delivery states, idempotency and retries. They do not contain verified provider account details, approved templates, provider API schemas, production pricing or successful integration evidence.

**Required action:** Maintain a provider verification register with official documentation, account owner, terms, scopes, pricing, test evidence, webhook signature validation, opt-in evidence, fallback and production approval. Keep provider status unverified until evidence exists.

#### AUD-012 — Regulatory and cost claims need a dated evidence ledger

The case study marks legal, tax, electrical, scheme, API, price and provider matters VERIFY. The governance document requires source URL, publication/effective date, clause/page, access date, reviewer and next review.

**Required action:** Create a controlled regulatory/economic rule register with jurisdiction, consumer category, capacity band, application/commissioning date, source clause, effective dates, calculation, reviewer and approval status. Keep estimated, submitted, sanctioned and credited subsidy values distinct. Do not hardcode unverified rules.

## 3. Cross-document invariants that are consistent

| Topic | Consistent direction |
|---|---|
| Architecture | Modular monolith, central FastAPI API and PostgreSQL system of record |
| Client access | Web/mobile clients use APIs, never direct database/queue connections |
| Employee access | Configurable multiple groups; permissions and scopes are separate |
| Customer identity | Customer, contact and login identity are distinct; link after verification |
| Business entities | Customer/site/project/plant/device/alert/case are separate linked entities |
| Enquiry | Duplicate-aware capture, assignment, follow-up and idempotent conversion |
| Commercial | Quotations are versioned; acceptance is distinct from payment |
| Finance | Record verified funds; receipt and allocation are separate; no gateway assumed |
| Procurement | BOM, PO, receipt, reservation and stock issue are separate |
| Utility | External portal authoritative; internal mirror needs source/time/evidence |
| Monitoring | Manufacturer-specific adapters; read-only; missing telemetry is not zero |
| Service | Alert lifecycle and service-case lifecycle remain separate |
| Notifications | Durable event/outbox, consent/preference check, retry and provider state |
| Files | Private storage, authorised access and metadata/audit |
| Governance | Authored draft is not approved, implemented, tested or legally certified |

## 4. Repository navigation and status

The root README points to INDEX.md. The index links to the case study, platform specification, database migrations and showcase. The platform specification README links to the application experience and implementation blueprint books. The new implementation blueprint index links to its register and eight documents.

The application documentation programme was corrected during this review. This was a static review; it does not claim every external link, official source, provider endpoint, SQL migration or deployed application was tested.

## 5. Recommended source-of-truth hierarchy

1. Business facts and decisions: signed discovery/decision log owned by GreenGrid.
2. Business workflow: workflow documents, with SRS IDs referencing each transition.
3. Product experience: application suite and screen-level specifications.
4. Requirements: SRS as the atomic, testable baseline.
5. Logical data: Stage 1 entity inventory and Stage 2 ER designs.
6. Physical data: Stage 3 canonical dictionary, then reviewed DDL/migrations.
7. API: OpenAPI generated/reviewed from approved screen actions and domain contracts.
8. Security: platform security architecture and approved access policy.
9. Integrations: provider-specific verification and adapter contracts.
10. Testing: traceability matrix and acceptance evidence.
11. Operations: deployment, monitoring, backup, recovery and runbooks.
12. User guidance: manuals derived from the verified released application.

When a lower-level document conflicts with an approved decision, record a change request and update all impacted artefacts. Do not silently edit one file only.

## 6. Prioritised remediation plan

### Gate 1 — architecture and workflow semantics
- [ ] Approve canonical resource-scope vocabulary and resolver.
- [ ] Approve deterministic permission precedence and deny model.
- [ ] Reconcile Stage 2 access ER names with Stage 3 dictionary and SQL.
- [ ] Confirm exact Won/accepted-quotation/project-creation trigger.
- [ ] Confirm customer identity, shared household access and site relationship rules.

### Gate 2 — buildable requirements and data
- [ ] Expand SRS into atomic requirements with stable IDs.
- [ ] Score every application chapter against G1–G8.
- [ ] Populate screen/action and field-validation registers.
- [ ] Complete customer Android/Web parity matrix.
- [ ] Complete API operation/request/response/error catalogue and OpenAPI.
- [ ] Complete entity-to-DDL and migration coverage matrix.
- [ ] Decide Alembic baseline without duplicate migration execution.

### Gate 3 — external and regulated behaviour
- [ ] Verify PIN source/API access and licence/refresh terms.
- [ ] Verify KSEB/DISCOM and government processes against current official instructions.
- [ ] Verify inverter make/model/API/firmware access and metrics.
- [ ] Verify WhatsApp/SMS/email/push providers, consent, templates, pricing and contracts.
- [ ] Complete legal, privacy, tax and electrical-engineering review.

### Gate 4 — readiness evidence
- [ ] Complete requirements-to-test traceability.
- [ ] Run migration tests on disposable PostgreSQL.
- [ ] Complete security/authorization/offline/provider failure tests.
- [ ] Complete restore drill and operational runbooks.
- [ ] Conduct GreenGrid UAT and record approval.
- [ ] Publish user manuals only from the verified application build.

## 7. Review limitations

This review examined repository documents and selected SQL sources on main. It did not execute migrations against PostgreSQL, generate/validate live OpenAPI, run application code/tests/UAT, verify external websites or vendor APIs, obtain GreenGrid stakeholder sign-off, or provide legal/security certification.

## 8. Conclusion

**Conditionally coherent; not yet ready for direct full implementation without resolving Gate 1.**

The highest-risk inconsistency is the access-control scope and precedence model because it affects every API and data query. The second is mapping logical access ER names to physical SQL. The project-creation trigger should also be stated unambiguously. After these decisions, turn the authored screen/workflow drafts into exact screen/action, API, data and test contracts.
