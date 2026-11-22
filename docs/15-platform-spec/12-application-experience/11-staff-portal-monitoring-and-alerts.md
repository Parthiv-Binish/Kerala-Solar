# Staff Portal — Monitoring Dashboard, Telemetry & Alerts

**Document ID:** UX-STAFF-011 · **Status:** Proposed; provider capability verification required

## 1. Purpose
Give operations a trustworthy view of plant/device status, production data freshness and actionable alerts. The portal consumes normalized monitoring data; it does not assume all inverter manufacturers expose compatible APIs.

## 2. Navigation
Monitoring → Fleet Overview, Plant Performance, Plant Detail, Device Health, Alert Inbox, Alert Detail, Integration Health, Data Gaps and Monitoring Configuration.

## 3. Fleet dashboard
Cards: monitored plants, reporting/healthy devices, stale data, active alerts by severity, unresolved cases and provider integration health. Charts show selected period, unit, aggregation and data completeness. Clearly distinguish live/near-real-time, delayed and historical data.

## 4. Plant monitoring detail
Show plant identity, expected reporting cadence, latest data timestamp, source/provider, data-quality state, energy/power metrics with units, comparison period, device list and active alerts. Missing telemetry displays “No recent data” or “Unavailable”, never zero generation by default.

## 5. Telemetry semantics
Keep raw provider payload separate from normalized readings. Record provider/device, event time, ingestion time, timezone interpretation, metric, unit, value, quality flag and mapping version. Handle duplicate, delayed, out-of-order, invalid and missing readings. Conversions require documented unit rules.

## 6. Alert lifecycle
Proposed states: Detected, Open, Acknowledged, Assigned, Investigating, Monitoring, Recovered, Closed, Suppressed, False Positive. Recovery is an observation; it does not automatically resolve an associated service case. Alert deduplication uses configured identity/window. Every state transition records actor/system, time and reason.

## 7. Alert detail
Show rule/version, plant/device, severity, first/last occurrence, latest evidence, telemetry context, history, related alerts, service case link, owner, acknowledgement and next action. Actions: acknowledge, assign, add note, suppress with expiry/reason, create/link case, mark false positive with reason and close under policy.

## 8. Integration health
Show provider, connection state, last success/failure, latency, rate-limit status, credential expiry indicator (never secret), queue backlog and supported device models. Admin-only configuration links are separate.

## 9. Permissions and tests
monitoring.view; telemetry.export; alert.acknowledge/assign/suppress/close; integration_health.view; monitoring_rule.manage. Tests: stale data is not zero; duplicate readings do not double count; provider outage visible; alert recovery does not close case; customer view is scoped; units and data timestamps are shown.

## 10. Decisions
Confirm alert severity, expected cadence per device, freshness thresholds, deduplication rules, customer alert policy, retention and provider-specific integrations. Do not define a universal threshold without evidence.
