# Business Requirements Document

## Context
GreenGrid needs a connected workflow from first enquiry to installation and long-term maintenance, joining sales, project execution, utility tracking, equipment and customer support.

## Requirements
| ID | Requirement | Priority |
|---|---|---|
| BR-001 | Capture enquiries from phone, WhatsApp, website, referral and walk-in | Must |
| BR-002 | Assign enquiries and manage follow-ups | Must |
| BR-003 | Convert a won enquiry into a customer and project | Must |
| BR-004 | Support multiple sites/projects per customer | Must |
| BR-005 | Record surveys, observations and photographs | Must |
| BR-006 | Create versioned quotations and record acceptance | Must |
| BR-007 | Track contracts, payment and project milestones | Must |
| BR-008 | Mirror utility stages with evidence and update history | Must |
| BR-009 | Schedule installation work and assign technicians | Must |
| BR-010 | Maintain plant and device registers | Must |
| BR-011 | Manage manual and automated service cases | Must |
| BR-012 | Send consent-aware customer notifications | Must |
| BR-013 | Restrict customers to their own authorised records | Must |
| BR-014 | Provide full encrypted offline technician job packs, durable drafts, media queueing and conflict-aware synchronisation | Should (Phase 2; not MVP acceptance) |
| BR-015 | Integrate approved manufacturer APIs | Should |
| BR-016 | Manage inventory, warranty, AMC and RMA | Should |
| BR-017 | Provide operational and management reports | Should |

## Enquiry conversion
An enquiry is a potential sale, not automatically a customer. Won conversion requires acceptance of one exact issued quotation version and configured commercial/contract approvals. Staff must resolve the customer and confirm one valid site before project creation; incomplete or ambiguous site data blocks conversion. The idempotent transaction links/creates customer, confirmed site and project, retains survey/quotation references, creates initial milestones and writes an audit event. One customer may have multiple enquiries, sites and projects. Duplicate candidates must be reviewed rather than silently merged.

## Roles
Owner/admin; sales; surveyor; designer/engineer; project manager; procurement; technician; accounts; support; customer. Actual headcount and hierarchy are VERIFY items.

## Finance boundary\nMVP finance records and verifies funds actually received, then allocates posted receipts. Customer-submitted screenshots/references are not proof of settlement. No online payment gateway is assumed.\n\n## Constraints
Government portal status remains authoritative. Generation and savings must show timestamps and limitations. Authorization is server-side. Important status changes retain actor and timestamp.

## Open decisions
Confirm departments, approval limits, branch structure, products, project volume, service volume, accounting practices, payment methods and existing tools.
