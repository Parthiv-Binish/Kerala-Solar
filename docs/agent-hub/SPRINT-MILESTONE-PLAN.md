# A0 Sprint and Milestone Plan

**Owner:** A0  
**Status:** PROPOSED — relative sprint cadence pending team capacity and sponsor approval  
**Cadence assumption:** two-week planning increments; not a delivery-date commitment  
**Baseline:** 2026-11-22

## Planning rules

- Sprint dates are set only after agent capacity and business availability are confirmed.
- Each sprint has a single integrated goal and demonstrable exit evidence.
- Dependencies may be worked in parallel but cannot be waived at acceptance.
- Every sprint review updates TASK-BOARD, PROJECT-STATUS, agent status reports, blocker register and contract statuses.
- Scope changes require owner approval and an impact update to roadmap, requirements, schema, APIs, UI and tests.

## Sprint plan

| Sprint | Goal | Candidate tasks / owners | Exit criteria |
|---|---|---|---|
| S0 — Coordination baseline | Establish working governance | AG-0001, AG-0014 (A0) | Master roadmap, matrix, sprint plan, contract registers, ADRs, handoff/readiness records and branch/PR conventions published; all agent owners acknowledge |
| S1 — Engineering foundation | Prove the platform can be built and tested | AG-0002 (A3), AG-0003 (A3/A4), AG-0012 (A8), AG-0013 (A9) | FastAPI health/OpenAPI baseline; disposable PostgreSQL clean install for SQL 0001–0006; migration checksum ledger plan; CI/dev compose; test traceability; no seed data |
| S2 — Identity and access | Prove employee/customer isolation and deny precedence | AG-0004, AG-0025 (A3/A4/A8), A0 ADR reviews | Business-approved identity verification policy; employee/customer context separation; resolver truth table; own/assigned/team/related/location/company predicates; deny-overrides; cross-customer/site negative tests; audit evidence |
| S3 — CRM vertical slice | Deliver enquiry-to-customer through staff web | AG-0015/0016/0017 (A3/A4/A1) | Enquiry CRUD/activity/assignment/follow-up; customer/contact/site identity; exact quotation acceptance conversion; idempotent project creation; server authorization; E2E and migration upgrade tests |
| S4 — Field/customer vertical slice | Deliver survey, quotation, project and field work | AG-0018/0019 plus domain tasks (A1/A2/A3/A4) | API/UI/mobile journeys for survey evidence, quotation revisions, project milestones and assigned work orders; customer sees own authorized data only; online-first submission states |
| S5 — Notifications and service | Integrate events and messaging | AG-0010/0020/0021, A5/A6/A3/A4 | Event envelope and outbox; preferences/consent/recipient policy; retries/dedupe; verified sandbox channel; webhook replay/security tests; no production claim without proof |
| S6 — Monitoring and deployment hardening | Add verified monitoring and staging operations | AG-0011/0022/0024, A7/A3/A4/A9 | Supported device capability proven; normalized data quality/freshness; alerts debounced/deduplicated; staging deployment; encrypted backup and successful restore drill |
| S7 — Pilot acceptance | Prove integrated MVP and operational readiness | AG-0023 and release backlog (A8/A0/A9/all) | Requirement traceability closure; cross-app E2E; security/privacy review; critical findings closed/accepted; operational runbooks; sponsor acceptance and pilot rollback plan |

## Milestone gates

- **M0 Governance Ready:** ownership, branch/PR, contract and ADR process agreed.
- **M1 Foundation Ready:** backend, database bootstrap, CI and dev environment reproducible.
- **M2 Identity Safe:** authn/authz and customer isolation independently tested.
- **M3 CRM Ready:** enquiry-to-customer conversion integrated end-to-end.
- **M4 Operations Ready:** project, utility, field, documents and customer/technician experiences integrated.
- **M5 Communications Ready:** consent-aware notifications and verified adapters.
- **M6 Monitoring Ready:** verified data source, telemetry and alert quality.
- **M7 Pilot Ready:** security, recovery, business acceptance and operations evidence.

## Definition of Ready

- Requirements and DOC issue IDs linked.
- Relevant workflow, screen, ERD, API and security documents reviewed.
- Single owner and reviewer; dependencies resolved or explicitly accepted as non-blocking.
- Planned file paths and no-overlap plan agreed.
- API/database/event contracts reviewed.
- Acceptance criteria and automated/manual test IDs defined.
- Business decisions/provider assumptions labelled PROPOSED or VERIFY.

## Definition of Done

- Code/docs merged through reviewed PR; no direct unreviewed main changes.
- Migrations are repeatable and tested on disposable supported PostgreSQL; rollback/upgrade behaviour recorded.
- Unit, integration and relevant negative/security/E2E tests pass.
- OpenAPI, data dictionary, event and traceability registers updated.
- Loading/empty/validation/forbidden/failure/recovery states present.
- No secrets, fake production records or unsupported provider claims.
- Agent handoff and status report complete.
- A0 records integrated status only after evidence; A8 records test evidence.

## Sprint ceremony / reporting

- Kickoff: A0 confirms goal, owner, reviewers, dependencies and acceptance.
- Contract review: A3/A4/A5/A6/A7 submit proposed changes; A0 coordinates affected consumers.
- Mid-sprint: blockers and interface changes updated in the Hub.
- Review: demo only working functionality; separate authored docs/design from executed implementation.
- Close: A0 updates milestone status and handoff; no silent carry-over or inferred completion.
