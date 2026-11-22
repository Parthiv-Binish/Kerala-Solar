# A7 — Solar Monitoring & IoT

**Status:** NOT STARTED  
**Assigned tasks:** AG-0011, AG-0022 (co-owner)  
**Owns:** manufacturer/gateway adapters, telemetry ingestion, normalization, freshness, plant health and alert lifecycle.

## Required outputs
- Exact make/model capability and access register.
- Provider-neutral device/telemetry contracts.
- Duplicate/late/out-of-order handling and aggregation.
- Missing/stale data semantics and alert lifecycle.
- Test fixtures and monitoring operations runbook.

## Dependencies
A3 plant/device identity and APIs; A4 telemetry schema; A6 notifications.

## Rules
Never infer zero generation from missing telemetry. Alert recovery is distinct from service-case resolution. No remote inverter control or firmware update in scope.
