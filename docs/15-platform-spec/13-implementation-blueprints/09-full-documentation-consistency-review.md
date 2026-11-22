# Full Documentation Consistency Review

**Review ID:** DOC-AUDIT-001  
**Branch:** main  
**Review date:** 22 November 2026  
**Review type:** Expanded static repository/documentation review  
**Overall result:** Broadly coherent product direction; implementation is blocked by unresolved access-control semantics, logical-to-physical mappings, identity linkage and MVP boundaries.

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

## 8. Additional findings from expanded repository pass

### AUD-013 — Application documentation file count is inaccurate

**Evidence:** The application experience folder contains the suite inventory (00), chapters 01–23, and the master programme: 25 Markdown files. The Documentation Register currently describes this as a 24-file book.

**Risk:** Progress reporting and completeness checks can undercount the authored material.

**Required action:** Correct the register to 25 files and define whether the master programme is counted as a chapter or as governance metadata. The actual application chapters are 24 files (00–23); the master programme is the 25th file.

**Owner:** Documentation owner.  
**Acceptance:** Folder inventory, master programme and register use one counting convention.

### AUD-014 — “Plant” and “solar system” are not formally reconciled

**Evidence:**
- The logical data/API outline uses `plants` and endpoints such as `GET /plants`.
- Application screens and customer language consistently refer to a solar plant.
- Stage 2 asset, monitoring and service ER designs use `solar_systems` and `solar_system_id`.
- Stage 3 physical dictionary uses `asset.solar_systems` with `solar_system_id`.

**Risk:** Different teams may create both a plant table and a solar_systems table, duplicate identity, or build API mappings without a documented alias.

**Required decision:** Confirm whether “plant” is the user-facing business term for the canonical `asset.solar_systems` entity. If yes, document one mapping (`plant` API/resource → `asset.solar_systems` physical table) and use the same opaque ID and lifecycle across screens, API, monitoring and service. If they are distinct concepts, define the relationship and cardinality.

**Owner:** Product owner + asset/data architect.  
**Acceptance:** One canonical glossary and mapping is used by logical model, Stage 2 ER, Stage 3 dictionary, API and all application chapters.

### AUD-015 — Customer identity linkage is ahead of the bootstrap migration

**Evidence:**
- Stage 2 access ER describes a generic `user_accounts` entity with optional employee and customer links.
- Bootstrap migration 0004 creates `iam.identity_accounts` and `iam.employee_account_links`; the migration does not yet create a customer-account link.
- The migration README states that customer identity linking is part of a later migration batch.

**Assessment:** This is a planned sequencing gap, not necessarily a design contradiction. However, the Stage 2 conceptual entity and physical identity model need an explicit mapping before customer login is built.

**Required action:** Define customer identity/account linking in a later migration: customer/contact principal, verified contact ownership, multiple authorised household contacts, invitation lifecycle, revocation, account linking and prevention of accidental employee/customer identity collision. Clarify whether one login can represent both employee and customer and how that is audited. Do not assume a phone number alone proves authority over a customer/site.

**Owner:** IAM/security lead + CRM/customer data owner.  
**Acceptance:** Customer identity ER, physical DDL, invitation workflow, API contract and cross-customer authorization tests agree.

### AUD-016 — MVP and full-suite scope are not traced feature by feature

**Evidence:**
- Project Charter defines an MVP and explicitly places inventory depth, procurement, AMC/RMA and manufacturer telemetry connectors in later scope.
- Application chapters describe full procurement/inventory, finance, asset/warranty, monitoring and service capabilities.
- The roadmap Phase 1 scope lists core MVP items but does not map each application/screen chapter to a phase, release or acceptance gate.
- Customer Web Portal appears in the application suite, but the charter's application summary only names customer mobile and technician mobile experiences.

**Risk:** Stakeholders may interpret every documented screen as an MVP commitment, creating scope creep, inaccurate estimates and mismatched acceptance.

**Required action:** Create a feature-level release matrix with requirement ID, application/screen, Must/Should/Could, MVP/later phase, dependency, estimate, acceptance gate and explicit exclusion. Confirm whether Customer Web Portal is MVP, pilot, or later. Separate basic stock/serial traceability required for installation from advanced inventory/procurement depth if those have different release timing.

**Owner:** Business sponsor + product owner + delivery lead.  
**Acceptance:** Charter, SRS, application chapters, roadmap and UAT plan use the same release boundary.

### AUD-017 — SRS is not yet a complete cross-application acceptance baseline

**Evidence:** The SRS has compact requirement groups for CRM, project, utility, field, monitoring and communication. It does not yet provide atomic, separately testable requirements for the complete Customer Web Portal, detailed customer-account linking/household delegation, finance verification/allocation/reversal, stock reservation versus issue, monitoring quality/freshness, notification delivery states, provider-specific integration failures, and cross-channel parity.

**Risk:** The application books may be treated as approved features without an authoritative requirement ID, making scope and acceptance hard to control.

**Required action:** Expand the SRS into atomic requirements with unique IDs. Include acceptance criteria and priority for each. Map each requirement to screen/action, API operation, data entity/constraint, capability/scope, event and test case. Explicitly classify non-functional requirements with measurable targets or mark targets as pending stakeholder approval.

**Owner:** Product owner + business analyst + QA lead.  
**Acceptance:** No in-scope screen action is orphaned from an approved requirement and test.

### AUD-018 — Scope vocabulary also needs physical meaning for the SQL “group” scope

**Evidence:** Migration 0004 accepts `own`, `assigned`, `group`, `company` and `resource`. The conceptual ER also describes `team` scope, while other documents use branch/location and related-record scopes. The physical value `group` may be interpreted as an employee group, operational team, or arbitrary resource group.

**Risk:** A group-based permission grant could accidentally expose every record associated with an employee access group, even when that group is only an organisational label.

**Required action:** Define `group` scope precisely or rename it to a non-ambiguous canonical key such as `team` if that is its actual meaning. Distinguish employee permission groups from operational record-owning teams. Define the required team/resource relationship tables and record predicates. Update migration constraints only through a reviewed migration.

**Owner:** Security/architecture lead + database lead.  
**Acceptance:** Every stored scope key has one meaning, one resolver and positive/negative authorization tests.

### AUD-019 — Repository link validation and generated registers remain unproven

**Evidence:** INDEX and README provide navigation and the new blueprint book has its own index. The repository does not yet contain the generated screen/action, field, navigation, permission, notification, API and requirement-to-test registers described by the documentation programme. A full automated relative-link check was not run as part of this static pass.

**Risk:** Documentation may drift; links and traceability can break as chapters evolve.

**Required action:** Add CI validation for Markdown relative links, required document IDs, duplicate IDs, register coverage and API/schema references. Generate or validate registers from a controlled source rather than hand-maintaining conflicting copies.

**Owner:** Documentation/engineering owner.  
**Acceptance:** CI reports broken local links and orphaned/missing IDs; register generation is repeatable.

### AUD-020 — Roadmap infrastructure targets are planning assumptions, not validated commitments

**Evidence:** Architecture proposes a 4 vCPU / 8 GB pilot starting point and initial RPO/RTO targets, while the implementation blueprint requires workload measurement and restore drills before production sizing.

**Assessment:** The documents are compatible if the values remain explicitly provisional. They must not be presented as guaranteed capacity or achieved recovery performance.

**Required action:** Label these as planning assumptions in all cost/roadmap material. Record actual concurrency, telemetry rate, storage growth, backup/restore measurements and approved business RPO/RTO before production.

**Owner:** Technical lead + operations owner + business sponsor.  
**Acceptance:** Published cost/architecture figures distinguish estimate, approved target and measured result.

## 9. Updated consistency matrix

| Area | Current assessment | Required next action |
|---|---|---|
| Product architecture | Coherent central API/database and client-suite direction | Confirm MVP channel/release boundaries |
| Workflow semantics | Mostly aligned; exact conversion prerequisites should be repeated in all contracts | Keep accepted issued quotation as explicit conversion gate |
| Access control | High-risk inconsistency in scope keys and precedence | Gate 1 decision and policy truth table |
| Logical-to-physical data | Broad domain coverage, but access names and plant/solar-system vocabulary need mapping | Canonical mapping register |
| Customer identity | Conceptually covered; physical customer link is in a later migration | Complete identity-link design before customer auth |
| Finance | Operational ledger boundary and no-gateway assumption are consistent | Preserve verification, allocation and reversal rules in SRS/API |
| Monitoring/service | Alert and case lifecycles are correctly separate | Canonical plant/system mapping and provider contracts |
| Application documentation | All application chapters exist as drafts; file count corrected to 25 total | Score all chapters against G1–G8 |
| API | Families and conventions exist; exact contract remains pending | OpenAPI and operation catalogue |
| Integrations/regulation | Verification boundaries are correctly cautious | Evidence ledger and provider approval |
| Deployment/operations | Proposed architecture is coherent | Measure sizing; prove backup restore and RPO/RTO |
| Governance/testing | Frameworks exist, traceability evidence not populated | Generate registers and execute tests/UAT |

## 10. Updated prioritised remediation gates

### Gate 0 — correct documentation metadata
- [ ] Correct application documentation count to 25 total files (24 chapters plus master programme).
- [ ] Add the consistency review to the master index and implementation-blueprints index.
- [ ] Run automated local-link and stable-ID checks.

### Gate 1 — decisions that block implementation
- [ ] Canonical permission scope vocabulary and deterministic precedence.
- [ ] Distinguish employee permission groups from operational teams.
- [ ] Map Stage 2 access ER entities to physical SQL.
- [ ] Define customer account/contact/household identity linking.
- [ ] Decide whether “plant” is the business/API alias for `asset.solar_systems`.
- [ ] Confirm exact accepted-quotation/Won/project conversion trigger.
- [ ] Approve MVP versus later feature matrix, including Customer Web Portal.

### Gate 2 — buildable contracts
- [ ] Expand SRS into atomic cross-application requirements.
- [ ] Score all application chapters against G1–G8.
- [ ] Populate screen/action, field, navigation, permission and notification registers.
- [ ] Complete API request/response/error schemas and OpenAPI.
- [ ] Complete entity-to-DDL and migration coverage matrix.
- [ ] Agree Alembic baseline without duplicate migration execution.

### Gate 3 — verified external and regulated behaviour
- [ ] Verify postal/PIN source access, licence and refresh rights.
- [ ] Verify current KSEB/DISCOM and subsidy processes.
- [ ] Verify manufacturer/model API and telemetry semantics.
- [ ] Verify WhatsApp/SMS/email/push providers, pricing, templates and consent.
- [ ] Obtain qualified legal, privacy, tax and electrical-engineering review.

### Gate 4 — evidence-based release readiness
- [ ] Complete requirement-to-test traceability.
- [ ] Run migrations on disposable PostgreSQL and verify constraints.
- [ ] Test authorization, IDOR, offline sync and provider failure/recovery.
- [ ] Complete security review and penetration testing.
- [ ] Complete backup restore drill and operational runbooks.
- [ ] Conduct GreenGrid UAT and record formal approval.
- [ ] Publish user manuals from the verified application build.

## 11. Review limitations

This is a static review of the repository's Markdown and SQL design artefacts on the main branch. It does not execute migrations against PostgreSQL, validate a generated OpenAPI document, run application code or automated tests, perform a complete link-check CI run, verify external provider endpoints/terms, obtain stakeholder sign-off, or provide legal, tax, security or electrical-engineering certification.

## 12. Conclusion

**Conditionally coherent; not yet ready for direct full implementation without resolving Gate 1.**

The highest-risk inconsistency is the access-control scope and precedence model because it affects every API and data query. The second is mapping logical access ER names to physical SQL. The project-creation trigger should also be stated unambiguously. After these decisions, turn the authored screen/workflow drafts into exact screen/action, API, data and test contracts.


## 9. Additional findings from the full-suite pass

The following findings extend AUD-001–AUD-012 after comparing the project charter, SRS, workflow documents, case study, architecture, application suite, monitoring specifications, API catalogue, implementation blueprints and bootstrap SQL.

### AUD-013 — Application product boundaries are not fully reconciled

**Evidence**
- The project charter lists an internal web workspace, customer mobile experience and technician mobile experience.
- The application suite separately identifies staff web, technician Android, customer Android, customer web, monitoring engine, notification engine and platform administration.
- The mobile architecture says customer and technician experiences may share a React Native codebase.

**Risk:** Teams may mistake a shared codebase for one app, omit the customer web portal from MVP planning, or treat background engines/admin functions as independently deployed products without defining their runtime boundary.

**Required decision:** Approve a product/deployment matrix with user audience, installable app/package, web route/domain, shared code packages, backend service/module, release cadence and MVP phase. Explicitly decide whether customer web is MVP, and whether platform administration is a protected area of the staff portal or a separate deployment.

**Owner:** Product owner + technical lead.  
**Acceptance:** Charter, suite inventory, architecture, roadmap, deployment blueprint and app-store plan show the same product boundaries.

### AUD-014 — Technician offline capability has conflicting priority

**Evidence**
- Business requirements BR-014 marks offline-capable technician workflows as **Should**.
- SRS FR-064 requires offline drafts and conflict-aware sync.
- The charter includes technician app foundations in MVP.
- Technician app and cross-application workflow documents describe offline capture and synchronisation as expected behaviour.

**Risk:** MVP scope, estimates and acceptance criteria can disagree. Offline support is a major architectural requirement, not a minor UI enhancement.

**Required decision:** Decide whether offline capture is a must-have MVP requirement or a later phase. If MVP, define minimum offline scope precisely (assigned job cache, allowed fields, photos, local encryption, operation IDs, conflict rules, expiry, revoke behaviour and sync evidence). If deferred, update FR-064 and app/workflow claims consistently.

**Owner:** Business owner + product/technical lead.  
**Acceptance:** BRD, SRS, charter, mobile specification, roadmap and QA plan share one priority and minimum acceptance boundary.

### AUD-015 — Telemetry retention proposals conflict

**Evidence**
- Case study monitoring design proposes raw points for 30–90 days, 5-minute aggregates for 12–24 months and daily aggregates while justified.
- Monitoring application specification proposes raw 1–5-minute points for 90 days, 15-minute aggregates for 12 months and daily aggregates for 5 years.
- IoT monitoring overview proposes raw points for 90 days, 15-minute aggregates for 12 months and daily aggregates for 5 years.

**Risk:** Storage forecasts, cost estimates, deletion jobs, customer history and incident investigations will use different retention expectations.

**Required decision:** Approve a metric-class retention schedule (raw, 5/15-minute, hourly/daily, fault/event, service evidence) with purpose, legal/business basis, storage estimate, aggregation method, deletion/archive process and owner. Confirm whether 5-minute or 15-minute aggregates are required; do not retain daily data for five years by default without approval.

**Owner:** Product/data owner + operations + privacy reviewer.  
**Acceptance:** One approved retention table is referenced by monitoring, database, privacy, backup/cost and operations documents.

### AUD-016 — Site creation/linking during conversion is ambiguous

**Evidence**
- Enquiry conversion workflow says to create a project linked to customer and site.
- It also says a customer can be created or an existing customer linked.
- The workflow does not define the decision when the enquiry has no verified site, the address is incomplete, or the customer already has a matching site.
- SRS requires multiple sites/projects per customer and duplicate-candidate review.

**Risk:** Duplicate site records, project linked to the wrong property, or a conversion that cannot complete because a site record is missing.

**Required decision:** Define a site resolution step: identify candidate existing site; confirm relationship and address; create a new site only after required minimum verification; allow a controlled pending-site state if business needs it; bind the project to exactly one confirmed site before execution. Define merge/correction rules and audit.

**Owner:** CRM/product owner.  
**Acceptance:** Conversion flow, data model, API transaction and duplicate tests cover new, existing, ambiguous and incomplete sites.

### AUD-017 — Finance terminology may imply payment processing beyond the agreed scope

**Evidence**
- Product/architecture documents say no payment gateway is assumed and finance is operational project/customer finance.
- Customer app inventory includes invoices and payment history.
- Logical API outline proposes POST /payments; the screen/API blueprint also refers to payment operations.
- Cross-application workflow correctly states receipt is recorded only after verified funds and allocation is separate.

**Risk:** A developer or customer may interpret a payment endpoint as initiating online payment or treating a submitted reference as confirmed funds.

**Required decision:** Define the MVP as manual receipt recording and verification (cash/UPI/bank transfer or other approved modes), with reference/evidence, received-by, received-at, verification status, allocation, reversal/refund and audit. Rename API operations to 'record-receipt', 'verify-receipt', 'allocate-receipt' or another approved vocabulary. A gateway is a separate future integration requiring explicit approval.

**Owner:** Finance/business owner + backend lead.  
**Acceptance:** Finance requirements, UI labels, API names, database entities and customer display distinguish payment intent, funds received, verified receipt, allocation, refund and gateway transaction.

### AUD-018 — API route examples are not consistently labelled as illustrative

**Evidence**
- Logical API document gives concrete routes such as /auth/login, /enquiries, /leads, /cases, /service-cases and payment/receipt concepts across different files.
- The screen-to-data catalogue says route names are not final and must be assigned during API design.
- The backend blueprint lists endpoint families but does not publish a normative route table.

**Risk:** Developers may implement whichever example they encounter first, generating duplicate aliases or incompatible clients.

**Required decision:** Mark all route tables as illustrative until OpenAPI approval. Then choose one canonical resource vocabulary (for example, enquiry vs lead; case vs service-case; payment vs receipt), define command routes and deprecate alternatives. Give each operation a stable operation ID.

**Owner:** Backend/API lead + product owner.  
**Acceptance:** One reviewed OpenAPI document is the only normative route/schema contract; other documents link to it or label examples non-normative.

### AUD-019 — Regulatory and commercial reference data needs temporal applicability at field level

**Evidence**
- Case study contains capacity bands, CFA amounts, storage conditions, fees/charges and GST observations with VERIFY caveats.
- SRS requires versioned regulatory rules.
- Regulatory workflow and implementation blueprint describe external status mirrors and effective-dated rules, but no single approved data contract specifies all applicability dimensions.

**Risk:** A correct historical rule may be applied to a new application, or a current rule may be retroactively applied to an earlier project. Customer quotations could present a reference figure as a guaranteed entitlement.

**Required decision:** Each rule record must include source authority, exact clause/paragraph, publication date, effective-from/to, application/commissioning date basis, geography/DISCOM, consumer category, capacity range, system type, scheme version, formula/units, exclusions, reviewer and approval state. Store calculated estimate separately from official submission, sanction and credit. Do not use case-study values as production defaults.

**Owner:** Regulatory/business reviewer + engineering lead.  
**Acceptance:** Regulatory rule schema, quote calculator, utility tracker, customer copy and tests use the same versioned rule and applicability dimensions.

## 10. Additional cross-document consistency matrix

| Area | Current observation | Required disposition |
|---|---|---|
| App suite | Charter lists fewer client surfaces than suite inventory | Approve product/deployment matrix |
| Technician offline | BRD says Should; SRS/mobile flow make it required | Set one MVP priority |
| Telemetry retention | Raw/aggregate retention differs across three docs | Approve one retention schedule |
| Conversion | Project requires a site, but create/link decision is underspecified | Define site resolution transaction |
| Finance | Payment terminology may be confused with payment gateway | Use receipt verification vocabulary |
| API routes | Examples vary and are explicitly non-final in catalogue | Publish one normative OpenAPI |
| Regulation | Values are version/date/category-sensitive | Add temporal applicability to rules and tests |

## 11. Revised overall assessment

The review confirms a coherent high-level product and architecture direction, but the documentation is **not yet a single internally consistent build contract**. AUD-001–AUD-004 remain the highest-risk blockers because they affect authorization, data integrity and conversion correctness. AUD-013–AUD-019 should be resolved before freezing MVP scope, API naming, finance behaviour, telemetry storage and regulatory calculation rules.

This is a static review of repository contents on the main branch. No live database migration, application test suite, deployed service, provider integration, official portal workflow, legal applicability or stakeholder approval was executed or independently certified.


### AUD-020 — Master index chapter numbering and navigation are inconsistent

**Evidence:** The implementation-blueprint section places the consistency review at II.66 before chapters II.57–II.65. The platform specification README also contains repeated application chapter links in its navigation list.

**Risk:** Readers encounter non-sequential numbering and duplicate navigation entries, weakening the master index as a reliable document map.

**Correction:** Renumber the implementation-blueprint chapters sequentially II.57–II.66 and remove duplicate application links from the platform README. Keep the audit linked from both the root index and implementation-blueprint book index.

**Owner:** Documentation maintainer.  
**Acceptance:** One unique chapter number per entry; all internal links resolve to existing paths; no duplicate navigation entries.
