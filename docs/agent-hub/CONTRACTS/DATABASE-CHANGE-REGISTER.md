# Database Change Register

**Owner:** A4; A3 confirms domain/transaction semantics; A0 approves cross-domain changes.

| Change ID | Schema/table | Purpose | Consumers | Migration | Tests | Status |
|---|---|---|---|---|---|---|
| DB-001 | platform bootstrap | Reconcile existing SQL bootstrap with one formal migration runner | All backend modules | TBD | Clean install + upgrade | PROPOSED |
| DB-002 | iam access model | Groups, memberships, permissions, scopes and overrides | A1/A2/A3 | TBD | AUTH suite | PROPOSED |
| DB-003 | crm enquiry/customer/site | Enquiry intake and identity lifecycle | A1/A2/A3 | TBD | CRM suite | PROPOSED |
| DB-004 | comms notification | Outbox, notification and delivery records | A3/A5/A6 | TBD | NOTIF/WA suite | PROPOSED |
| DB-005 | monitor telemetry | Device readings, aggregates and alert lifecycle | A3/A7 | TBD | MON suite | PROPOSED |

All schema changes need dictionary updates, migration tests, indexes/constraints review and retention classification. No fabricated production seed records.
