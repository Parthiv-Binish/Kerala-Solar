# GreenGrid Solar — Documentation Issue Register

**Document ID:** DOC-ISSUES-001  
**Status:** Open remediation register; proposed corrections, not stakeholder approvals  
**Repository:** Parthiv-Binish/Kerala-Solar  
**Branch reviewed:** `main`  
**Review baseline:** 22 November 2026  
**Purpose:** Give the project owner and agents one traceable list of documentation defects, ambiguities and build-readiness gaps. Preserve existing source documents; resolve issues through controlled edits and recorded decisions.

## 1. How to use this register

- This register supplements, and does not replace, the [Full Documentation Consistency Review](09-full-documentation-consistency-review.md), [Consistency Resolution Decisions](10-consistency-resolution-decisions.md), SRS or domain specifications.
- Issue IDs are stable. Do not reuse an ID; append new findings.
- **Critical** means implementation must not begin in the affected domain until resolved. **High** means resolve before the relevant agent starts that feature. **Medium** means resolve before integration/UAT. **External verification** means evidence from a stakeholder, authority, qualified professional or provider is required.
- A proposed correction is not an approved business decision. Record approver, role, date, rationale and affected artefacts in the decision log.
- A code or document change is not closed until the acceptance criteria are checked and the changed file is fetched from GitHub to verify the committed content.
- A0 coordinates cross-document changes. A3 owns backend/API semantics; A4 owns physical data/migrations; A8 owns security/quality evidence; the business owner approves business rules. Shared ownership is stated per issue.
- Agents must not independently invent business, legal, electrical, tax, provider or regulatory decisions.

## 2. Priority summary

| Priority | Count | Meaning |
|---|---:|---|
| Critical | 3 | Security/identity and foundational data semantics |
| High | 9 | Build contracts and workflow consistency |
| Medium | 5 | Traceability, UX and operational completeness |
| External verification | 5 | Requires evidence beyond repository editing |

Counts describe this initial register and may overlap by affected workstream only where explicitly tagged; each issue has one primary priority.

## 3. Issue register

### DOC-001 — Canonical authorization policy is not propagated to every source
- **Priority:** Critical
- **Remediation status (22 Nov 2026):** PARTIALLY DOCUMENTED — scope vocabulary, typed identity boundaries and deny evaluation semantics have been reconciled in the mapping register, resolution decisions and Stage 2/3 documents. Backend resolver, operation-wide enforcement and automated truth-table tests remain unimplemented/unverified; keep this issue OPEN.
- **Owners:** A3 backend/security, A4 database, A8 QA, A0 integration; business owner approval
- **Affected documents:** SRS; short and full security documents; Stage 2 organization/access ERD; Stage 3 dictionary; migrations 0003–0005; staff access screens; API catalogue; consistency decisions.
- **Problem:** The canonical scopes and deny-overrides algorithm are described in the resolution document, but subordinate specifications and physical constraints may still use legacy terminology or omit identical semantics.
- **Correction:** Publish one authorization policy and permission matrix. Map each scope to a deterministic record predicate, required relationship resolver and supported operation. Define group grants, permission-set effects, account overrides, expiry, deny precedence, privileged elevation, service identities and customer-specific authorization separately.
- **Acceptance:** All relevant documents and SQL use `own`, `assigned`, `team`, `related`, `location`, `company`; no contradictory legacy scope remains except documented migration aliases. Automated truth-table tests cover overlapping groups, denies, expired grants and every read/write/export/file/realtime/background path. Cross-customer and cross-site access is denied.

### DOC-002 — Customer identity and authorised-contact model is incomplete
- **Priority:** Critical
- **Remediation status (22 Nov 2026):** PARTIALLY IMPLEMENTED IN SCHEMA DESIGN — migration 0006 and the Stage 2/3/security documents now define typed, customer-specific links that require employee-account verification and preserve revocation actor/time and the minimum customer/contact subject tables. Full CRM migration, verification workflow, customer/site resolver and isolation tests remain outstanding; keep this issue OPEN.
- **Owners:** A3 IAM/API, A4 CRM/IAM data, A8 security; business owner approval
- **Affected documents:** Full security architecture; Stage 2 customer and access ERDs; Stage 3 dictionary; migration README/backlog; customer app/web; invitation and onboarding workflows.
- **Problem:** Bootstrap migrations create employee identity linkage; customer identity linkage is deferred. The complete model for multiple contacts, representatives, household access, site-specific access, revocation and possible employee/customer dual identity is not yet a build contract.
- **Correction:** Define identity principal, customer/contact relationship, verification evidence, invitation lifecycle, access grant/revocation, audit, account collision handling and customer/site authorization. Decide whether one identity may link to both employee and customer populations and how contexts are separated.
- **Acceptance:** Logical ERD, physical mapping, DDL backlog, invitation workflow, API, screens and tests agree. A phone number alone cannot establish authority. Tests cover multiple contacts, multiple sites, revoked representatives and cross-customer isolation.

### DOC-003 — Logical-to-physical entity and field mapping is incomplete
- **Priority:** Critical
- **Remediation status (22 Nov 2026):** PARTIALLY DOCUMENTED — a canonical mapping register now covers organization/access and customer identity foundations, identifies physical gaps, and links migration 0006. Full column/relationship mapping across every Stage 2 domain and DDL reconciliation remain outstanding; keep this issue OPEN.
- **Owners:** A4 database, A3 backend, A0 architecture
- **Affected documents:** Stage 1 entity inventory; all Stage 2 ERDs; Stage 3 data dictionary and PostgreSQL blueprint; current SQL migrations; logical API model.
- **Problem:** Conceptual entity/field labels differ from physical names, with risk of duplicate tables and incorrect foreign keys.
- **Correction:** Create a complete mapping ledger for every entity and relationship: logical name, physical schema/table, column, PK/FK, cardinality, nullability, delete behaviour, lifecycle owner and migration ID.
- **Acceptance:** Every Stage 2 entity and relationship maps to one physical implementation or is explicitly marked deferred/not persisted. No duplicate entity is introduced solely to preserve a logical label.

### DOC-004 — Project/plant terminology is not reconciled
- **Priority:** High
- **Owners:** A0 product/architecture, A4 data, A3 API, A7 monitoring
- **Affected documents:** Logical data/API outline; Stage 2 asset, monitoring and service ERDs; Stage 3 dictionary; staff/customer app screens; monitoring docs.
- **Problem:** User-facing/API documents use `plant`, while physical documents use `asset.solar_systems` and `solar_system_id`.
- **Correction:** Use “solar plant” as the business/API resource mapped to `asset.solar_systems` (`solar_system_id`) through the adapter/mapping layer. A plant is not a project, site, device, monitoring connection or service case. Do not create a parallel `asset.plants` table.
- **Acceptance:** All domain ERDs, API examples, screen specifications and data dictionaries use the plant→solar_system mapping and preserve distinct project/site/device relationships.

### DOC-005 — Enquiry-to-project conversion prerequisites are not equally explicit everywhere
- **Priority:** High
- **Remediation status (22 Nov 2026):** PARTIALLY DOCUMENTED — workflow, BRD, SRS and canonical decisions now state exact issued-quotation acceptance, commercial approvals, confirmed customer/site, atomic idempotent conversion and post-commit notification. Screen-level coverage, reviewed API schemas and transaction/isolation tests remain outstanding; keep OPEN.
- **Owners:** Business owner, A0 product, A3 backend, A1/A2 UX
- **Affected documents:** Charter, business workflows, SRS FR-013, enquiry/customer screens, quotation screens, project screens, cross-application workflow, API contract.
- **Problem:** The intended conversion is after acceptance of an exact issued quotation version and commercial approvals, but older workflow wording may imply a looser Won conversion.
- **Correction:** State one transition chain: approved survey → design → approved quotation issue → customer acceptance of exact version → required commercial approvals → confirmed customer/site → idempotent Won conversion → project creation/linkage. Define prospect work separately if pre-acceptance project tracking is required.
- **Acceptance:** Every document and API command uses the same preconditions, transaction boundary, idempotency and failure states. Tests prove incomplete/ambiguous site and unaccepted/obsolete quote cannot create a project.

### DOC-006 — SRS is not sufficiently atomic or traceable
- **Priority:** High
- **Remediation status (22 Nov 2026):** PARTIALLY DOCUMENTED — a new SRS traceability matrix decomposes core MVP requirements into testable outcomes and maps them to screens/actions, proposed API operations, data constraints, permissions and test IDs. Remaining domain requirements, exact screen/API IDs, approved schemas and executable test evidence are still outstanding; keep OPEN.
- **Owners:** A0 requirements, A3/A4 domain owners, A8 QA
- **Affected documents:** SRS and all application/workflow/ERD documents.
- **Problem:** Several important rules exist only in screen or workflow chapters, making acceptance coverage easy to miss.
- **Correction:** Expand requirements into uniquely identified, testable statements. Include state transitions, immutability, finance receipt lifecycle, stock reservation/issue, customer-safe projections, alert/case separation, duplicate handling, notification delivery, provider failures, file controls and mobile connectivity behaviour.
- **Acceptance:** Every requirement maps to a screen/action, API operation, data entity, permission/scope, validation and test ID. No requirement relies only on prose buried in a screen chapter.

### DOC-007 — API catalogue is a standard, not a complete API contract
- **Priority:** High
- **Owners:** A3 backend, A0 integration, A8 QA
- **Affected documents:** Logical API outline; screen-data/API catalogue; API/backend blueprint; agent API contract register; all app screens.
- **Problem:** Routes are illustrative and request/response schemas, error codes and operation-level security are incomplete.
- **Correction:** Build an endpoint register from stable screen/action IDs. Specify operationId, method/path, request/response schemas, permission/scope, validation, transaction, idempotency, audit, event/outbox effects, error codes and tests. Generate/review versioned OpenAPI as the sole normative contract.
- **Acceptance:** Every MVP screen action has a reviewed OpenAPI operation and contract test. No frontend/backend agent invents routes or payloads independently.

### DOC-008 — Migration baseline strategy and migration coverage need one source
- **Priority:** High
- **Owners:** A4 database, A3 backend, A9 DevOps
- **Affected documents:** SQL migrations 0001–0006; migration README; Stage 3 migration plan; database completion blueprint; consistency decisions; agent hub.
- **Problem:** SQL bootstrap exists while Alembic is recommended later. A duplicate execution path or untested baseline could corrupt deployed schemas. Existing review text also referenced the earlier 0001–0004 sequence; current bootstrap scripts are 0001–0006.
- **Correction:** Use ordered SQL migrations 0001–0006 as the sole current schema source. Defer Alembic; before adoption, convert the full history to reviewed Alembic revisions and retire direct SQL application. Add a migration ledger, dependency/DDL coverage matrix and disposable PostgreSQL clean-install/upgrade tests.
- **Acceptance:** A fresh disposable PostgreSQL database can be created and upgraded using exactly one supported command path; repeat/upgrade/failure behaviour is tested. No migration is claimed live-executed without evidence.

### DOC-009 — Screen specifications are uneven against G1–G8
- **Priority:** High
- **Owners:** A1 web/product, A2 mobile, A0 product, A8 QA
- **Affected documents:** All files under application-experience; master programme; screen implementation blueprint.
- **Problem:** Some early Staff Portal chapters are detailed, while several later chapters do not yet provide equivalent field/action/access/failure/acceptance depth.
- **Correction:** Score each chapter and each screen against G1 coverage, G2 workflow, G3 data, G4 access, G5 integration, G6 UX, G7 verification and G8 traceability. Record gaps rather than marking chapters complete by file count.
- **Acceptance:** Every MVP screen/action has an owner, actor, permission/scope, fields, validation, data effects, failure/empty/loading states and acceptance tests. Deferred screens are explicitly labelled.

### DOC-010 — Customer Android and Customer Web parity is not fully specified
- **Priority:** High
- **Owners:** A2 mobile, A1 web, A0 product
- **Affected documents:** Customer Android, Customer Web, application suite inventory, cross-app workflows, API catalogue.
- **Problem:** Customer Web is Phase 2 by default, but the exact shared capabilities, app-specific differences and promotion criteria need an explicit matrix.
- **Correction:** Create a feature parity matrix showing MVP Android functions, Phase 2 web functions, shared API/identity, deep links, document access, notification preferences and responsive/accessibility behaviour.
- **Acceptance:** Each feature has one owner/source of truth, phase, channel availability and API/permission mapping. No web feature is implied as MVP without signed scope change.

### DOC-011 — Notification event/recipient/consent matrix is incomplete
- **Priority:** High
- **Owners:** A6 notifications, A5 WhatsApp adapter, A3 outbox, A8 privacy
- **Affected documents:** Notification engine; notifications ERD; integrations overview; customer/technician screens; cross-app workflows; integration contract register.
- **Problem:** General event/outbox/retry principles exist, but the complete per-event recipient, channel, consent, template, priority, retry and fallback matrix is not yet approved.
- **Correction:** Define event ID/schema, trigger, recipient resolver, purpose, channel eligibility, consent/preferences, template version, locale, idempotency, retry/backoff, provider status mapping, fallback and audit for each notification.
- **Acceptance:** Every notification-producing action maps to a matrix row and test. Marketing and transactional purposes are separated. Provider failure does not falsify source workflow status.

### DOC-012 — Finance receipt and supplier-payment rules need full lifecycle contracts
- **Priority:** High
- **Owners:** A3 backend, A4 finance data, business/accounts owner, A8 QA
- **Affected documents:** SRS finance FR-070/071; finance ERD; finance screen; logical API; cross-app workflow; consistency decisions.
- **Problem:** No gateway is assumed and receipt vocabulary is clarified, but approval, reconciliation, allocation constraints, reversal/refund and supplier payment controls need complete testable detail.
- **Correction:** Define receipt states, evidence, verifier authority, segregation of duties, duplicate detection, allocation limits, over/underpayment, reversal/refund linkage, supplier bill matching and immutable audit.
- **Acceptance:** Customer-submitted screenshots/references cannot post receipts; only authorised verification can. Posted receipt allocations cannot exceed eligible balance. Corrections preserve history and pass negative tests.

### DOC-013 — Monitoring and telemetry exception handling needs a complete operational contract
- **Priority:** High
- **Owners:** A7 monitoring, A3 backend, A8 QA, business/service owner
- **Affected documents:** Device study; monitoring ERD; asset ERD; monitoring engine; staff monitoring screens; service workflow; notification engine.
- **Problem:** Vendor-neutral, read-only monitoring and missing-is-not-zero are sound principles, but freshness, clock skew, duplicate/out-of-order samples, device replacement, provider outage and alert suppression/recovery require exact rules.
- **Correction:** Specify provider/device identity, metric/unit mapping, sample timestamps, ingestion timestamps, quality flags, deduplication, ordering, freshness thresholds, outage states, alert debounce/clear, device replacement and service-case linkage.
- **Acceptance:** Missing/stale/invalid data never becomes zero generation. Duplicate/out-of-order payloads do not corrupt aggregates. Alert recovery does not silently resolve an open service case.

### DOC-014 — Technician online-first and future offline boundary needs screen-level behaviour
- **Priority:** High
- **Owners:** A2 mobile, A3 API, A8 QA
- **Affected documents:** SRS FR-064; technician app; cross-app workflows; implementation blueprint; consistency decisions.
- **Problem:** Full offline packs are Phase 2, but MVP connectivity-loss behaviour and data-loss prevention are not sufficiently precise.
- **Correction:** Define MVP handling for unsent form data during current session, submission status, retry, duplicate submission, media upload interruption and stale assignment. Separately specify Phase 2 encrypted durable job packs, conflict resolution, revocation and sync.
- **Acceptance:** MVP makes no full-offline claim; user sees pending/failed/synced state and cannot mistake local input for server commit. Phase 2 has independent acceptance criteria.

### DOC-015 — File/document security lifecycle is not fully traceable
- **Priority:** Medium
- **Owners:** A3 backend, A4 data, A8 security, A9 storage/operations
- **Affected documents:** Documents ERD; security architecture; screen docs; API blueprint; quality/operations runbooks.
- **Problem:** Private storage and authorization are stated, but upload scanning, file type/size limits, signed URL lifetime, quarantine, retention, deletion, versioning and download audit need a unified contract.
- **Correction:** Define upload protocol, malware scanning/quarantine, MIME/content validation, storage encryption, key handling, scoped download, short-lived links, versioning, legal hold and deletion workflow.
- **Acceptance:** Unauthorized file access is denied even with guessed IDs/URLs; uploaded content is scanned before availability; every sensitive download is authorized and audited.

### DOC-016 — Operational recovery and release evidence are not measurable yet
- **Priority:** Medium
- **Owners:** A9 DevOps, A8 QA/security, A0 release owner
- **Affected documents:** Architecture recovery section; deployment blueprint; runbooks; agent testing/release registers; project status.
- **Problem:** Proposed RPO/RTO and backup principles exist, but no verified restore drill, rollback procedure, monitoring threshold or release evidence exists.
- **Correction:** Define environments, backup schedule, WAL/PITR approach, restore test frequency, RPO/RTO owner/approval, deployment rollback, alert thresholds, incident roles and evidence location.
- **Acceptance:** A documented restore drill and rollback rehearsal pass in a non-production environment before production readiness. Targets are labelled proposed until measured.

### DOC-017 — Security source-of-truth hierarchy is ambiguous
- **Priority:** Medium
- **Owners:** A8 security, A0 documentation
- **Affected documents:** Short security overview; full platform security architecture; Stage 2 access ERD; Stage 3 physical dictionary; security implementation blueprint.
- **Problem:** A concise security document and a comprehensive architecture overlap without a sufficiently prominent authority statement in all navigation paths.
- **Correction:** Mark the full platform security architecture as the authoritative security design, the short document as a summary, Stage 2 as logical model and Stage 3 as physical model. Cross-link them.
- **Acceptance:** Each document states its authority and points to the source of truth for conflicting details; no contradictory duplicate policy remains.

### DOC-018 — Application-document count and status references need synchronisation
- **Priority:** Medium
- **Owners:** A0 documentation
- **Affected documents:** Master application programme; Documentation Register; INDEX; folder inventory.
- **Problem:** The programme previously had stale Planned statuses; the register describes 25 files (24 chapters plus programme). Future additions may reintroduce stale counts or inaccurate status.
- **Correction:** Use an explicit convention: 24 numbered chapters (00–23) plus one programme file. Update counts/status only from repository inventory and G1–G8 review evidence.
- **Acceptance:** INDEX, register and programme agree on count and status; file existence is never described as approval or implementation.

### DOC-019 — Regulatory/economic claims need an evidence ledger and effective-date control
- **Priority:** External verification
- **Owners:** Business/regulatory owner, qualified electrical engineer, accountant/tax adviser, A8 compliance
- **Affected documents:** Case study regulatory chapter; discovery register; rule engine; quotation/design specifications; compliance docs.
- **Problem:** Research snapshots and VERIFY notes are not production rule evidence. Subsidy, storage, metering, electrical, ALMM/DCR/BIS and GST rules can change by date/category.
- **Correction:** Maintain source, authority, clause/page, jurisdiction, publication/effective dates, date trigger, category/capacity band, formula/unit, exclusions, reviewer and approval. Keep estimate/submitted/sanctioned/credited amounts separate.
- **Acceptance:** No rule is activated in quotation/design automation without qualified review and recorded approval. Customer-facing estimates show source date and eligibility caveat.

### DOC-020 — DPDP, IT Rules and CERT-In applicability must be independently checked
- **Priority:** External verification
- **Owners:** Qualified legal/privacy adviser, security owner, A8
- **Affected documents:** Case study compliance; security architecture; privacy implementation blueprint; privacy notice and retention plan.
- **Problem:** A research snapshot cannot determine the organisation's final legal obligations, commencement dates, applicability or breach duties.
- **Correction:** Create an applicability register with legal entity/service role, processing purpose, data category, applicable provision, commencement/effective date, responsible owner and counsel evidence. Verify incident/logging duties before production.
- **Acceptance:** Qualified reviewer signs the applicability matrix and incident/privacy procedures are updated to the law/rules effective at launch.

### DOC-021 — Messaging and provider integrations are not verified
- **Priority:** External verification
- **Owners:** A5 integrations, A6 communications, A7 monitoring, A8 security, business owner
- **Affected documents:** Integrations overview; provider registers; notification/monitoring docs; case study; agent plan.
- **Problem:** OpenWA is an unofficial WhatsApp Web automation candidate; official WhatsApp provider access, templates, consent, price, inverter API access and government portal integrations remain unverified.
- **Correction:** For each provider record official documentation, account owner, terms, scopes, pricing, test credentials, webhook verification, consent/template approval, data handling, fallback and production sign-off. Keep adapters replaceable.
- **Acceptance:** No provider is labelled production-ready without representative successful tests and approval. Critical communications use an approved supported channel; OpenWA is not assumed to be a guaranteed failover.

### DOC-022 — PIN/post-office data source and refresh terms remain unverified
- **Priority:** External verification
- **Owners:** A4 reference data, A9 operations, A8 compliance
- **Affected documents:** Master geography ERD; postal provenance design; discovery register; integration blueprint.
- **Problem:** Postal reference data source/API access, licensing, refresh cadence and coverage are not confirmed.
- **Correction:** Verify official source, permitted use, access method, refresh process, provenance and correction workflow. Keep free-text address entry available if lookup is unavailable.
- **Acceptance:** Imported records carry source and import-run provenance; no invented coordinates or unsupported API dependency; lookup failure does not block enquiry capture.

### DOC-023 — GreenGrid business workflow facts and role ownership need stakeholder sign-off
- **Priority:** External verification
- **Owners:** GreenGrid business owner and department representatives; A0 facilitates
- **Affected documents:** Case study; business requirements; workflows; screen specs; role/group/access matrix; operating procedures.
- **Problem:** The platform study contains proposed workflows and departments, but actual agency hierarchy, handoffs, approval limits, SLA, service process and customer communication preferences must be confirmed.
- **Correction:** Conduct structured walkthroughs with sales, survey/engineering, project operations, procurement, accounts, technicians and support. Record current process, exceptions, owner, approval limit and future-state decision.
- **Acceptance:** Named business owners approve workflow diagrams, status transitions, required fields, notification rules and responsibility matrix. Unknowns remain explicitly open.

## 4. Remediation progress (22 November 2026)

The following repository changes have been authored and committed: canonical logical-to-physical mapping register; explicit authorization deny/allow evaluation semantics; typed customer-account link model; migration 0006 for customer/contact subject foundations and verified/revocable customer links; aligned Stage 2, Stage 3, security and migration documentation. These are documentation/schema-artifact corrections only. They do not implement the backend authorization resolver, customer invitation/verification UI, complete CRM, or cross-customer/site tests. DOC-001, DOC-002 and DOC-003 therefore remain OPEN.

## 5. Dependency-aware correction sequence

| Sequence | Issues | Work package | Exit condition |
|---|---|---|---|
| 1 | DOC-001, DOC-002, DOC-003 | Access, identity and data foundations | Approved policy, customer linkage and complete physical mapping |
| 2 | DOC-004, DOC-005 | Domain vocabulary and conversion | Canonical plant mapping and approved conversion workflow |
| 3 | DOC-006, DOC-009, DOC-010 | Requirements and application experience | Traceable SRS and reviewed MVP screen coverage |
| 4 | DOC-007, DOC-011, DOC-012, DOC-013, DOC-014, DOC-015 | API and domain contracts | Build-ready API/events/security/exception contracts |
| 5 | DOC-008, DOC-016, DOC-017, DOC-018 | Database, operations and document governance | Reproducible migration and operational/document controls |
| 6 | DOC-019–DOC-023 | External and stakeholder verification | Evidence and sign-offs recorded; unverified assumptions remain gated |

Dependencies can be worked in parallel only where they do not change the same source-of-truth documents. A0 coordinates edits and resolves conflicts before merge.

## 6. Agent ownership and work allocation

| Agent | Primary issues |
|---|---|
| A0 — Architecture/integration | DOC-004, DOC-005, DOC-006, DOC-009, DOC-010, DOC-018, cross-document coordination |
| A1 — Web/staff portal | DOC-009, DOC-010, screen/action and access traceability |
| A2 — Android | DOC-009, DOC-010, DOC-014 |
| A3 — Backend/IAM/API | DOC-001, DOC-002, DOC-005, DOC-006, DOC-007, DOC-011–DOC-015 |
| A4 — Database | DOC-001–DOC-004, DOC-008, DOC-012, DOC-015, DOC-022 |
| A5 — WhatsApp integration | DOC-011, DOC-021 |
| A6 — Notifications | DOC-011, DOC-021 |
| A7 — Monitoring | DOC-004, DOC-013, DOC-021 |
| A8 — QA/security/compliance | DOC-001, DOC-002, DOC-006–DOC-020, DOC-021 |
| A9 — DevOps/reliability | DOC-008, DOC-015, DOC-016, DOC-021, DOC-022 |

These are proposed document owners, not evidence that agents are running or work has started.

## 7. Change and closure record

Use this entry for every issue closure:

| Field | Required value |
|---|---|
| Issue ID | DOC-### |
| Resolution | Exact correction made or accepted alternative |
| Files changed | Repository paths |
| Decision reference | ADR/decision-log ID, if a business/architecture decision was needed |
| Approver | Name/role or “not required — editorial correction” |
| Commit | Git commit SHA |
| Verification | Post-commit fetch, link check, migration/test evidence where applicable |
| Status | Open / In progress / Blocked / Resolved / Accepted risk |
| Closed by/date | Responsible reviewer and date |

## 8. Current state and limitations

All issues in this initial register are **Open**. No correction is claimed by creating this register. The review was static and did not execute SQL, run application tests, validate OpenAPI, verify provider access, obtain business approval or provide legal/electrical/tax certification.

**Agent launch gate:** Do not mark implementation tasks READY where a Critical issue is an unresolved prerequisite. A0 must link the relevant issue IDs and approved acceptance criteria to each task before work begins.
