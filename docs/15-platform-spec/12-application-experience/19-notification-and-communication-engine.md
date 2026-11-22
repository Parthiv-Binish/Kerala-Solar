# Notification & Communication Engine — Channels, Consent, Templates & Delivery

**Document ID:** SVC-COMMS-001 · **Status:** Proposed; provider approval VERIFY

## 1. Purpose
Deliver approved transactional messages across in-app, push, email, SMS and WhatsApp where configured. Source business services create events; this engine applies recipient, consent, template and retry policy.

## 2. Components
Event intake; preference/consent resolver; recipient resolver; template renderer; channel router; provider adapters; durable queue; delivery worker; webhook receiver; retry/dead-letter manager; delivery log; inbound reply router.

## 3. Event catalogue
Examples: enquiry acknowledgement, follow-up reminder, survey appointment, quotation issued/expiring, project milestone published, payment receipt confirmed, service case created/updated, technician assignment, monitoring alert and account security. Each event defines source, recipient, channel eligibility, template, priority, data minimisation and idempotency key.

## 4. Recipient and consent
Resolve recipient from verified contact and explicit relationship. Record channel, purpose, consent state, source, timestamp, policy version and opt-out. Transactional/service messages and promotional messages must be distinguished. Respect applicable law, provider policy and customer preferences. No marketing campaign is implied by a transactional opt-in.

## 5. Templates
Template metadata: key, channel, language, version, approval state, provider template ID, variables schema, sample, purpose and effective dates. Missing variables block send. Escape untrusted content. WhatsApp template approval and provider constraints are verified before activation.

## 6. Delivery lifecycle
Queued, Eligible, Rendering, Sending, Accepted by Provider, Delivered, Read (only if provider reports), Failed, Retry Scheduled, Suppressed, Expired, Dead Letter. Provider acceptance is not proof of human reading. Store provider message ID and timestamps. Do not equate delivery failure with business workflow failure.

## 7. Retry and idempotency
Use durable outbox/event pattern, unique event/message idempotency key, bounded exponential backoff, provider rate-limit handling and dead-letter review. Retrying same event must not create duplicate customer actions. Manual resend records actor/reason and links to original delivery.

## 8. Inbound replies
Where provider supports inbound replies, verify signatures, map sender to verified contact cautiously and route to staff inbox or supported workflow. Unknown senders are not automatically linked to customer accounts. Do not execute high-impact commands from free-text replies.

## 9. In-app and push
In-app inbox stores title, body, event, target route, created/read time and expiry. Push payload contains minimal sensitive data; app fetches authorized details after opening. Respect device token lifecycle and user notification preferences.

## 10. Privacy and security
Mask contact data in logs; encrypt provider credentials; verify webhooks; restrict template editing and export; enforce retention and opt-out; avoid exposing quotation amounts, payment details or fault data on lock-screen previews unless policy permits.

## 11. Administration and metrics
Metrics: queued, sent, accepted, delivered, failed, suppressed, retry count, provider latency and template rejection. Admin configures providers, channel priorities, quiet hours and retry policy with audit and staged testing.

## 12. Acceptance tests
- [ ] Consent and preferences checked at send time.
- [ ] Duplicate event does not create duplicate send.
- [ ] Provider acceptance is distinct from delivered/read.
- [ ] Failed delivery does not change quotation/case state.
- [ ] Opt-out suppresses applicable future messages.
- [ ] Webhook signatures are verified.
- [ ] Template variables are validated and escaped.
- [ ] Sensitive data is absent from logs and push payloads.
