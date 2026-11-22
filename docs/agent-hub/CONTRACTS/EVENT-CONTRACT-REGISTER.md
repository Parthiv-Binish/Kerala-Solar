# Domain Event Contract Register

**Owner:** A3 for business events/outbox; A6 for notification envelope and delivery; A0 arbitrates.

| Event ID | Event | Producer | Consumers | Idempotency key | Status |
|---|---|---|---|---|---|
| EVT-001 | enquiry.created | A3 | A6, A1 | enquiry_id + event_version | PROPOSED |
| EVT-002 | appointment.confirmed/changed | A3 | A6, A1, A2 | appointment_id + event_version | PROPOSED |
| EVT-003 | quotation.issued/accepted | A3 | A6, A1, A2 | quotation_version_id + event_version | PROPOSED |
| EVT-004 | receipt.verified | A3 | A6, A1, A2 | receipt_id + event_version | PROPOSED |
| EVT-005 | project.milestone.changed | A3 | A6, A1, A2 | milestone_id + event_version | PROPOSED |
| EVT-006 | monitoring.alert.opened/recovered | A7 | A3, A6, A1, A2 | alert_id + transition_version | PROPOSED |
| EVT-007 | service_case.created/updated | A3 | A6, A1, A2 | case_id + event_version | PROPOSED |

Define schema, actor, occurred_at, correlation_id, payload version, privacy classification and retry semantics before implementation. Queue delivery is not proof of channel delivery.
