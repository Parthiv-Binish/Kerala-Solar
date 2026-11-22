# SRS Requirement Traceability Matrix

**Document ID:** SRS-TRACE-001  
**Status:** Draft engineering baseline; not stakeholder-approved  
**Date:** 22 November 2026  
**Authority:** Supplements the SRS. It does not claim that any listed capability is implemented.

## 1. Purpose and rules

This matrix decomposes high-risk MVP requirements into verifiable outcomes. The SRS remains the source of requirement intent; this matrix supplies proposed acceptance criteria and cross-layer traceability. API operation names below are stable proposed identifiers, not deployed routes or a validated OpenAPI document.

Requirement status must be one of: `proposed`, `approved`, `implemented`, `verified`, `deferred`, or `rejected`. Do not mark a requirement implemented from documentation alone. A requirement is verified only when its linked automated tests and required business evidence pass on a recorded build.

## 2. Enquiry, quotation and conversion

| Requirement ID | Testable requirement / acceptance criteria | Screen/action | Proposed API operation | Data / constraints | Permission | Test IDs |
|---|---|---|---|---|---|---|
| FR-CRM-001 | Staff can create an enquiry with source, contact channel and minimum contact/site details. Server rejects malformed phone/email and invalid enum values; optional sensitive data is not requested by default. | CRM-ENQ-01 create | `createEnquiry` | `crm.enquiries`, contact methods, source reference | `crm.enquiry.create` | CRM-T001, CRM-T002 |
| FR-CRM-002 | Staff can assign/reassign an enquiry; each change records actor, time, previous owner and new owner. | CRM-ENQ-02 assign | `assignEnquiry` | Enquiry assignment history | `crm.enquiry.assign` | CRM-T003 |
| FR-CRM-003 | Follow-up has owner, due time, channel and outcome. Overdue queue is derived from due time and completion state, not manually maintained. | CRM-ENQ-03 follow-up | `createFollowUp`, `completeFollowUp` | Follow-up, activity | `crm.follow_up.manage` | CRM-T004, CRM-T005 |
| FR-CRM-004 | Duplicate customer/site candidates are surfaced using configured matching signals; candidate matches never merge automatically. Staff decision and rationale are audited. | CRM-DUP-01 review | `reviewDuplicateCandidate` | Customer, contact, site, duplicate review | `crm.duplicate.review` | CRM-T006, SEC-T010 |
| FR-SALES-001 | Survey scheduling creates a linked survey with a responsible person and appointment window. Survey completion records findings and evidence; approval is a separate state transition. | SUR-01 schedule/review | `scheduleSurvey`, `submitSurvey`, `approveSurvey` | Survey, survey version, files | `survey.manage`, `survey.approve` | SALES-T001, SALES-T002 |
| FR-SALES-002 | Design and quotation reference an exact approved survey/design revision. Changes create revisions and do not silently mutate issued quotations. | DES-01, QUO-01 | `createDesignRevision`, `issueQuotation` | Design revision, quotation/version, line items | `design.manage`, `quotation.issue` | SALES-T003, SALES-T004 |
| FR-SALES-003 | Customer acceptance records the exact quotation version, response channel, timestamp and evidence. Acceptance of an obsolete, withdrawn or expired version is rejected unless an authorised exception is recorded. | QUO-02 response | `recordQuotationResponse` | Immutable issued quotation version, acceptance evidence | `quotation.response.record` | SALES-T005, SALES-T006 |
| FR-PROJ-001 | Won conversion is permitted only after exact issued-version acceptance, required commercial approvals, confirmed customer identity and exactly one confirmed installation site. Survey approval alone is insufficient. | CRM-ENQ-04 convert | `convertWonEnquiry` | Enquiry, customer, site, project, quote, survey | `crm.enquiry.convert` | PROJ-T001–T004 |
| FR-PROJ-002 | Conversion is atomic and idempotent. Concurrent/retried requests produce one project; failed transactions leave no partial customer/site/project linkage. | CRM-ENQ-04 convert | `convertWonEnquiry` | Unique conversion key; transaction constraints | `crm.enquiry.convert` | PROJ-T005, PROJ-T006 |
| FR-PROJ-003 | Project links to the accepted quotation, approved survey, confirmed site and source enquiry; initial milestones and audit record are created in the same transaction. Customer invitation/notification occurs only after commit. | PRJ-01 overview | `getProject`, outbox event `project.converted` | Project links, milestone, audit, outbox | `project.view`, `project.create` | PROJ-T007, INT-T001 |

## 3. Identity, access and customer isolation

| Requirement ID | Testable requirement / acceptance criteria | Screen/action | Proposed API operation | Data / constraints | Permission | Test IDs |
|---|---|---|---|---|---|---|
| FR-IAM-001 | Employee account resolves only through an active verified employee-account link. Disabled account, revoked link or expired session denies access. | IAM-LOGIN-01 | `resolveEmployeeSession` | `iam.identity_accounts`, employee link | Authentication policy | IAM-T001–T003 |
| FR-IAM-002 | Employee access is group-grant based with canonical scopes `own`, `assigned`, `team`, `related`, `location`, `company`; matching deny wins. | IAM-ACCESS-01 | `authorizeEmployeeAction` | Group grants, permission rules, overrides | Permission under evaluation | IAM-T004–T010 |
| FR-IAM-003 | Record predicates are applied before pagination, counts, aggregates, search results, export, file access, realtime subscriptions and background jobs. | All protected views/actions | Shared authorization middleware/policy | Domain relationship resolvers | Permission under evaluation | IAM-T011–T018 |
| FR-CUST-001 | Customer account activation requires an active verified customer-account link. Phone/email match or invitation delivery alone grants no access. | CUST-AUTH-01 | `verifyCustomerAccountLink` | `iam.customer_account_links`, customer/contact | Customer verification policy | CUST-T001–T004 |
| FR-CUST-002 | Customer can read only explicitly linked customer/site/project data; revocation takes effect on subsequent requests and active sessions/subscriptions are revalidated. | Customer home/details | `listCustomerProjects`, `getCustomerProject` | Customer/site/project links | Customer-specific policy | CUST-T005–T009 |

## 4. Finance, field operations and monitoring

| Requirement ID | Testable requirement / acceptance criteria | Screen/action | Proposed API operation | Data / constraints | Permission | Test IDs |
|---|---|---|---|---|---|---|
| FR-FIN-001 | Receipt can be posted only after authorised staff verify funds actually received. Customer screenshots/references remain unverified evidence until staff action. | FIN-REC-01 verify/post | `verifyAndPostReceipt` | Receipt status, verifier, evidence, ledger allocation | `finance.receipt.verify` | FIN-T001–T004 |
| FR-FIN-002 | Receipt allocation cannot exceed available posted receipt amount or eligible outstanding amount; reversals are explicit, audited transactions. | FIN-ALLOC-01 | `allocateReceipt`, `reverseReceiptAllocation` | Receipt allocations, invoice/due | `finance.receipt.allocate` | FIN-T005–T008 |
| FR-FIELD-001 | Work order assignment and technician evidence are limited to authorised jobs; required checklist items and evidence rules are validated server-side before completion. | TECH-JOB-01 | `assignWorkOrder`, `submitWorkOrderEvidence` | Work order, assignment, checklist, files | `work_order.assign`, `work_order.submit` | FIELD-T001–T006 |
| FR-MON-001 | Telemetry stores source timestamp, ingestion timestamp, unit and quality. Missing/stale telemetry is shown as unavailable/stale, never converted to zero. | MON-PLANT-01 | `ingestTelemetry`, `getPlantTelemetry` | Plant/device mapping, observation, quality | Monitoring service identity / view permission | MON-T001–T006 |
| FR-MON-002 | Alert recovery does not automatically close a service case; case resolution requires its own authorised workflow and evidence. | MON-ALERT-01, SVC-CASE-01 | `evaluateAlert`, `resolveServiceCase` | Alert lifecycle, service case lifecycle | `monitor.alert.manage`, `service.case.resolve` | MON-T007–T010 |

## 5. Communication, files and reliability

| Requirement ID | Testable requirement / acceptance criteria | Screen/action | Proposed API operation | Data / constraints | Permission | Test IDs |
|---|---|---|---|---|---|---|
| FR-COM-001 | Outbound customer communication checks purpose, channel consent, approved template/provider and suppression state before dispatch. | COMMS-PREF-01 / event worker | `enqueueNotification`, `dispatchNotification` | Consent, template version, outbox, attempt/delivery | `comms.dispatch` service permission | COM-T001–T007 |
| FR-COM-002 | Retry is bounded and idempotent; provider timeout does not create duplicate customer-visible messages where provider idempotency is available. Delivery status distinguishes queued, submitted, delivered, failed and unknown. | Notification history | `retryNotification` | Notification, attempts, provider message ID | `comms.retry` | COM-T008–T012 |
| FR-FILE-001 | File upload validates size, type, ownership, malware scan status and access policy. Download rechecks record authorization and never exposes public object paths. | DOC-FILE-01 | `uploadDocument`, `downloadDocument` | File metadata, scan status, storage key, access links | `files.upload`, `files.download` | FILE-T001–T007 |
| FR-REL-001 | Background jobs use durable outbox/queue state, bounded retry, dead-letter visibility and idempotent handlers; failures are observable and recoverable. | Admin job monitor | `processOutboxEvent` | Outbox, job attempt, dead-letter | Service identity and admin read permission | REL-T001–T006 |

## 6. Non-functional acceptance requirements

| Requirement ID | Acceptance criteria | Verification |
|---|---|---|
| NFR-SEC-001 | No protected endpoint trusts client-supplied role, group, scope or record ownership; all access decisions are server-side and deny by default. | Static review, API negative tests, penetration test |
| NFR-PRIV-001 | Personal data fields have documented purpose, access class, retention and deletion/hold behaviour before production collection. | Data inventory and privacy review |
| NFR-REL-001 | Critical write operations are transaction-safe and retry-safe; no duplicate project, receipt posting or customer notification from replay. | Concurrency and fault-injection tests |
| NFR-OBS-001 | Logs correlate request, actor/service identity, trace and job IDs without logging secrets or unnecessary personal data. | Log inspection and security tests |
| NFR-BACKUP-001 | Backup restore is demonstrated against a documented RPO/RTO target approved by the business owner. | Restore exercise evidence |
| NFR-MOB-001 | MVP apps are online-first and visibly distinguish saved, submitting, submitted and failed states; full durable offline packs remain Phase 2. | Device/network interruption tests |

## 7. Test case catalogue ownership

The IDs in this matrix are proposed stable test identifiers. A8 owns the canonical test case catalogue and evidence. A3/A4 provide API/database fixtures; A1/A2 provide screen and device test coverage; A0 resolves cross-domain dependencies. Add exact test steps, synthetic fixture identifiers, expected status/error codes, build SHA, execution date, tester and evidence link before marking any case passed.

## 8. Release gate

No MVP requirement is release-ready until all of the following are recorded:
1. Business owner approval of requirement wording and workflow preconditions.
2. Reviewed screen/action and API operation with versioned request/response schema.
3. Physical entity/constraint and migration mapping.
4. Permission and scope decision, including negative isolation tests.
5. Automated test implementation and passing evidence.
6. Operational logging, retry/recovery and support ownership where applicable.
7. UAT sign-off for business-critical workflows.

**Current state:** This is a proposed traceability baseline only. It is not a complete endpoint inventory, OpenAPI specification, test execution report, UAT sign-off or implementation status.
