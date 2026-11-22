# Solar Monitoring Engine — Architecture, Data Lifecycle & Operational Specification

**Document ID:** SVC-MON-001 · **Status:** Proposed; provider integrations VERIFY

## 1. Responsibilities
Collect, normalize, validate and store telemetry; maintain device connectivity/freshness; calculate approved aggregates; evaluate alert rules; publish events for portal/customer/service workflows. It does not control inverter hardware, firmware or grid equipment.

## 2. Components
Provider adapter registry; credential vault; scheduler/webhook ingress; ingestion queue; raw payload store; normalizer; quality validator; time-series persistence/read model; aggregation worker; alert evaluator; event publisher; health/metrics and replay tooling.

## 3. Device onboarding
Plant and equipment records must exist before linking a provider device. Record manufacturer/provider, model, serial/device ID, plant association, supported metrics, timezone, expected reporting interval, connection method, credentials reference and verification state. Credential secrets remain in protected secret storage, never database plaintext or source control.

## 4. Provider capability review
For each provider document API availability, supported models/firmware, authentication, scopes, rate limits, pagination, timestamps, webhook signature, retention, data rights, service availability and production approval. No adapter is declared supported until a test connection and representative data validation pass.

## 5. Ingestion
Support polling, signed webhooks and controlled file import only where provider supports them. Ingress records source, received time, event time, request ID, provider event ID and payload checksum. Verify webhook signatures and replay windows. Queue ingestion asynchronously; return acknowledgement only after durable receipt.

## 6. Normalized telemetry
Canonical observation: plant/device, metric code, value, unit, event timestamp, ingestion timestamp, quality, source adapter/version, raw reference and mapping version. Preserve raw source payload under retention policy. Normalize units with tested conversion. Distinguish instantaneous power from interval energy and cumulative meter reading.

## 7. Quality and time handling
Handle duplicates, out-of-order events, late data, clock skew, daylight/timezone interpretation, invalid units, impossible values and gaps. Keep provider event time separate from ingestion time. Quality flags include valid, estimated, stale, invalid, corrected and unavailable. Missing observation is not a zero reading.

## 8. Aggregation
Daily/monthly aggregates use explicit timezone and interval-boundary rules. Recomputations are versioned/idempotent. Do not sum instantaneous power as energy. Distinguish cumulative meter delta from interval production. Backfill changes update derived aggregates with traceability.

## 9. Freshness and health
Expected cadence is device/provider-specific. Calculate freshness from last valid observation and configured tolerance. Health states: Reporting, Delayed, Stale, Disconnected, Provider Error, Not Configured, Unknown. Unknown is a valid state when evidence is insufficient.

## 10. Alert evaluation
Rules have ID/version, scope, metric, condition, threshold/source, duration, severity, deduplication key/window, suppression and notification policy. Thresholds require approved technical/operational evidence. Alert states are separate from service case states. Recovery observation may update alert but cannot close service work automatically.

## 11. Resilience
Rate limiting, retries with jitter/backoff, circuit breaker, provider outage queueing, dead-letter queue, poison message quarantine, replay/backfill and idempotent processing. Protect against duplicate webhook/poll overlap. Credential expiry and API schema changes trigger integration health alert.

## 12. Security and privacy
Encrypt secrets and sensitive payloads, restrict operator access, audit credential access and export, rotate credentials, minimize customer identifiers and redact logs. Provider data terms and customer consent must be reviewed.

## 13. APIs/events
Internal commands: register device, test connection, sync now, replay range, update mapping, acknowledge integration issue. Events: telemetry.observed, telemetry.quality_changed, device.freshness_changed, alert.opened, alert.updated, alert.recovered, integration.failed/recovered. Use schema version, event ID and idempotency.

## 14. Retention baseline
Use the provisional planning baseline: raw observations/provider payloads 90 days; 15-minute aggregates 12 months; daily aggregates 5 years. Alert/fault events, service evidence, customer documents and security/audit logs require separate schedules. This is not a legally approved retention period; no deletion automation is enabled until the data owner and qualified reviewer approve purpose, basis, retention and evidence.

## 15. Operations and tests
Metrics: poll success, ingest lag, queue depth, provider latency/rate limit, invalid payload, freshness distribution, alert volume and processing delay. Tests cover signature verification, duplicates, gaps, units, timezone, late data, provider outage, replay and no-data-not-zero.
