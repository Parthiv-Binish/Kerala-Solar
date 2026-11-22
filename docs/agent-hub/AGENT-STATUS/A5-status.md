# A5 — WhatsApp Integration

**Status:** NOT STARTED  
**Assigned tasks:** AG-0009, AG-0021 (co-owner)  
**Owns:** WhatsApp provider adapter, templates, inbound/outbound messages, webhooks and provider operations.

## Required outputs
- OpenWA feasibility report and verified prerequisites.
- Provider-neutral interface and replaceable OpenWA adapter if approved.
- Template register, message correlation and delivery state mapping.
- Webhook verification/replay protection, deduplication and retry tests.
- Operational health and re-authentication runbook.

## Dependencies
A6 common notification envelope/queue; A3 recipient eligibility and domain events; provider account access.

## Important
OpenWA is a candidate, not an assumed official Meta API or guaranteed stable production service. Verify legal/terms, session persistence, QR re-auth, hosting, rate limits and operational risks before production use. No credentials in source control.
