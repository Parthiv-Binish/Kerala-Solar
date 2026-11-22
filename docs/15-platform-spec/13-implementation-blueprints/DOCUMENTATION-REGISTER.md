# GreenGrid Solar — Master Documentation Register

**Document ID:** DOC-REGISTER-001  
**Status:** Working draft; living control register  
**Repository:** Parthiv-Binish/Kerala-Solar  
**Purpose:** Track authored documents, pending detail, dependencies, review and approval without confusing documentation with implemented capability.

## 1. Status definitions
- **Authored draft:** A document exists and has been committed; it may still need review or more detailed artefacts.
- **Review required:** Business/technical owner must validate the content.
- **Approved:** Named owner has accepted the specification and recorded approval.
- **Implemented:** Code/configuration exists.
- **Verified:** Automated/manual evidence confirms the implementation meets approved acceptance criteria.
- **Deferred:** Explicitly postponed with reason and owner.
- **Not started:** No corresponding document or implementation exists.

A file existing does not mean its contents are complete, approved, implemented or tested.

## 2. Application documentation
The 25-file application experience book (24 numbered chapters, 00–23, plus the master programme) is authored as draft. It covers the suite inventory; fourteen Staff Portal chapters; Technician Android; Customer Android; Customer Web; Monitoring Engine; Notification Engine; Platform Administration; cross-application workflows; API catalogue; quality/operations and programme governance.

Primary location: [Application experience book](../12-application-experience/00-application-suite-and-screen-inventory.md)

## 3. Pending-detail register

| ID range | Work package | Master document | Dependencies | Review owner | Status |
|---|---|---|---|---|---|
| APP-D01–D08 | Screen/action, forms, navigation, permissions, notifications and UI states | [Screen & Experience Implementation Specification](01-screen-and-experience-implementation-specification.md) | Application books, SRS, security and data dictionary | Product owner + UX + engineering | Authored draft; detailed per-screen register still to be populated |
| API-D01–D09 | Endpoint catalogue, schemas, auth, permissions, errors, idempotency, jobs, OpenAPI and realtime | [API & Backend Contracts](02-api-and-backend-contracts.md) | Screen register, domain workflows, data dictionary | Backend lead + security | Authored draft; exact OpenAPI contract pending |
| DB-D01–D10 | Schema reconciliation, DDL, relationships, indexes, migrations, backup, retention and imports | [Database Completion & Data Governance](03-database-completion-and-data-governance.md) | Stage 1–3 database documents and current SQL migrations | Database lead + business data owners | Authored draft; reconciliation and DDL backlog pending |
| INT-D01–D10 | PIN, DISCOM, subsidy, inverter, WhatsApp, email/SMS/push, storage and recovery | [External Integration Contracts](04-external-integration-contracts.md) | Provider access, official terms, privacy/security review | Integration owner + legal/security | Authored draft; provider verification pending |
| SEC-D01–D10 | DPDP, notices, consent, requests, retention, CERT-In, threat model, device security and tests | [Security, Privacy & Compliance](05-security-privacy-and-compliance-implementation.md) | Data inventory, legal review, security architecture | Security lead + qualified counsel | Authored draft; legal applicability and controls review pending |
| DEV-D01–D10 | Repo structure, backend/frontend/mobile, design system, state, files, auth, realtime and environments | [Application Engineering & Deployment](06-application-engineering-and-deployment.md) | Approved architecture and API contracts | Technical lead | Authored draft; implementation-specific decisions pending |
| OPS-D01–D10 | VPS, Docker, Nginx, CI/CD, release, rollback, observability, recovery and capacity | [Application Engineering & Deployment](06-application-engineering-and-deployment.md) | Workload estimates, hosting choice, security review | DevOps/operations owner | Authored draft; measured sizing and runbooks pending |
| QA-D01–D10 | Traceability, unit/API/web/mobile/E2E/offline/security/performance/UAT | [Testing, Traceability & Acceptance](07-testing-traceability-and-acceptance.md) | Approved requirements, screens, APIs and data mappings | QA lead + business owner | Authored draft; test cases/evidence pending |
| BIZ-D01–D09 | Staff, technician and customer manuals; onboarding, SOPs, support, document and KPI procedures | [Business User Manuals & SOPs](08-business-user-manuals-and-operating-procedures.md) | Implemented screens, approved policies and UAT | Operations/training owner | Authored framework; final manuals await verified product |

## 4. Canonical decision and audit documents
- [Full Documentation Consistency Review](09-full-documentation-consistency-review.md) — findings AUD-001 onward; static review only.
- [Consistency Resolution Decisions](10-consistency-resolution-decisions.md) — proposed canonical resolutions for access scopes, conversion, product boundaries, offline scope, retention, finance, API naming and regulatory applicability. Requires GreenGrid approval before treating decisions as approved.

## 5. Existing source documents that must be reconciled
- Project charter and business requirements.
- Business workflows and SRS.
- System architecture and technology stack.
- Stage 1 entity inventory, Stage 2 domain ER designs, Stage 3 PostgreSQL blueprint and canonical data dictionary.
- Bootstrap SQL migrations 0001–0004.
- Platform security and access-control specifications.
- Monitoring/device integration and notification specifications.
- Mobile application and delivery/governance documents.
- Application suite and all application experience chapters.

Do not create a competing source of truth. Where documents conflict, record a decision with owner, rationale, date and affected artefacts.

## 6. Dependency-aware delivery order
1. Populate the screen/action, field, navigation and permission registers.
2. Agree workflows and domain state transitions.
3. Reconcile ER designs and canonical data dictionary.
4. Finalise API schemas and OpenAPI.
5. Verify provider access and external integration contracts.
6. Complete privacy/security threat and control review.
7. Finalise migrations and migration-runner baseline.
8. Build implementation and deployment details against approved architecture.
9. Derive automated test cases and traceability.
10. Complete UAT, user manuals and operational SOPs after real product verification.

## 7. Required registers and evidence
Maintain:
- Screen/action register.
- Field/data dictionary and screen-to-API mapping.
- Navigation/deep-link register.
- Permission/capability/scope matrix.
- Event and notification matrix.
- API/OpenAPI contract.
- Database reconciliation and migration ledger.
- Integration verification register.
- Privacy processing/retention register.
- Threat/risk register.
- Requirements-to-test traceability matrix.
- UAT and approval evidence.
- Release and operational runbooks.

Each register entry has a stable ID, owner, source, status, last-reviewed date, decision reference and evidence link.

## 8. Governance rules
- No provider integration is called production-ready without access, terms, security review and successful representative tests.
- No migration is called executed until a target database run and verification evidence exist.
- No document is marked approved without a named approver and date.
- No requirement is marked verified without test evidence.
- No legal, regulatory, engineering, tax or subsidy claim is treated as final without qualified verification.
- No real customer personal data, credentials or production secrets are committed to this repository.

## 9. Current status summary
The application suite documentation, eight implementation work-package blueprints, consistency review and consistency resolution decision register have been authored as drafts. The next work is detailed register population, reconciliation, stakeholder review, exact API/DDL generation and evidence-based verification. The platform itself is not represented as implemented or deployed by this register.
