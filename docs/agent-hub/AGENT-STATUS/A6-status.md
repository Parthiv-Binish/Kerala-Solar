# A6 — Notifications & Communications

**Status:** NOT STARTED  
**Assigned tasks:** AG-0010, AG-0020 (co-owner), AG-0021 (co-owner)  
**Owns:** unified notification orchestration, preferences, queue, delivery lifecycle and channel adapters.

## Required outputs
- Event-to-recipient/channel matrix and consent/preference model.
- Common notification envelope and channel interfaces.
- Idempotent queue, retry/backoff, dead-letter and delivery state.
- In-app centre and push/email/SMS contracts.
- Tests for duplicate events, outages, opt-outs and callback failures.

## Dependencies
A3 event/outbox and recipient eligibility; A5 WhatsApp adapter; A2 device tokens; A1 notification UI.
