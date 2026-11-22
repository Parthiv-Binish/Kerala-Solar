# 03 — Device Monitoring and IoT Architecture

**Status:** Proposed design. Model/API support must be verified against GreenGrid's actual fleet.

## Required device inventory
Obtain inverter make/model/firmware, datalogger, battery/BMS, meter model, communication method, current monitoring app, API access/installer permissions, site counts by model and customer authorisation. A consumer monitoring app does not prove a public developer API exists.

## Candidate integrations

| Manufacturer | Candidate route | Verify |
|---|---|---|
| Growatt | Shine platform/API, supported local interfaces | API entitlement, models, limits |
| Solis | SolisCloud API, Modbus on supported models | Credentials, permissions, rate limits |
| Sungrow | iSolarCloud API, supported Modbus | Approval, model/data coverage |
| Huawei | FusionSolar Northbound API, supported Modbus | Admin enablement, licence, model scope |
| GoodWe | SEMS/API, local Modbus where supported | API access and compatibility |
| Luminous | Model-specific cloud/gateway | Exact OEM and API |
| Waaree | Model-specific platform/OEM | Exact inverter OEM/API |
| Havells | Model-specific monitoring | Exact model/API |
| Delta | Monitoring platform and Modbus | Model/gateway support |

Treat all vendor API claims as **VERIFY** until official documentation and credentials are obtained. Do not scrape consumer portals.

## Recommended hybrid approach
1. Manufacturer cloud API for supported authorised sites.
2. Local Modbus TCP/RTU gateway where supported.
3. MQTT over TLS between GreenGrid-owned gateway and backend.
4. Manual readings/import for unsupported legacy devices.

Do not assume every inverter speaks MQTT. Never expose Modbus directly to the public internet. Use VPN or outbound secure gateway, allowlists, read-only polling and model-specific register maps. No remote inverter control in MVP.

~~~mermaid
flowchart LR
 A[Inverters / meters / batteries] --> B[Manufacturer cloud]
 A --> C[Site edge gateway]
 C --> D[Modbus TCP/RTU adapter]
 D --> E[MQTT over TLS]
 B --> F[Vendor API connector]
 E --> G[Telemetry ingestion]
 F --> G
 G --> H[Validation / normalisation]
 H --> I[(PostgreSQL / TimescaleDB)]
 H --> J[Redis Streams / queue]
 J --> K[Alert worker]
 K --> L[Cases and notifications]
 I --> M[WebSocket / SSE]
 M --> N[Operations and customer UI]
~~~

## Canonical telemetry schema
Each point: device ID, site ID, metric key, value, unit, quality, source timestamp, ingestion timestamp, source and optional raw-payload reference.

Candidate metrics: AC/DC power, daily/lifetime energy, grid voltage/current/frequency, PV string voltage/current, inverter temperature, battery SOC/voltage/current/power/energy, operating state, fault code, meter import/export and communications health.

Preserve source timestamp separately from ingestion timestamp. Normalise units and flag stale/invalid values.

## Ingestion reliability
- One adapter per vendor/API family.
- Secrets encrypted or stored in secrets manager.
- Respect provider rate limits and terms.
- Back off on 429/5xx with jitter.
- Deduplicate by device + metric + source timestamp.
- Track connector health and last successful poll.
- Buffer edge data locally during outages.
- Version Modbus maps by model/firmware.
- Authenticate gateway identity and rotate credentials.

## Storage decision

| Option | Benefits | Trade-off | Recommendation |
|---|---|---|---|
| PostgreSQL | Transactions, joins, JSONB | Needs partitioning/tuning at scale | Start here |
| TimescaleDB | Hypertables, compression, retention, aggregates | Extension/hosting compatibility | Add when justified |
| ClickHouse | Fast analytical scans | Another system to operate | Later |

Initial engineering retention proposal: raw points 30–90 days; 5-minute aggregates 12–24 months; daily aggregates while justified; fault/service history according to warranty and legal retention. These are not statutory retention periods.

Example: 100 devices × 10 metrics × 288 samples/day at 5-minute sampling = 288,000 samples/day before indexes and metadata.

## Alert engine
Alert categories: device offline, under-generation, inverter fault, grid voltage/frequency, battery/BMS, meter anomaly, datalogger failure and repeated trips.

Processing:
1. Validate data/timestamp.
2. Evaluate rule over a window.
3. Apply debounce/hysteresis.
4. Deduplicate active alert.
5. Set severity and visibility.
6. Create/update case.
7. Notify responsible people.
8. Resolve after stable recovery or authorised closure.

An initial offline rule could be 15 minutes without valid telemetry; configurable, not universal. Compare generation to a site-specific baseline accounting for season, weather, capacity, shading, availability and data quality. Do not use one fixed kWh threshold for every site.

## Real-time delivery
- WebSocket for bidirectional screens.
- SSE for one-way live dashboards.
- Redis Pub/Sub for ephemeral fan-out.
- Redis Streams or durable queue for events that must not be lost.
- PostgreSQL remains source of truth.

Do not rely on Pub/Sub alone for case creation or notification dispatch.

## UI requirements
Show site status, last update, current power when available, energy history, battery state where supported, device fault, data freshness, alert/case link and explicit stale/unavailable state. Never display false live readings.

## Pilot
Choose the most common installed model; obtain written authorisation and API access; integrate one test site; compare readings to manufacturer app; test units, timestamps, missing data, faults, retries, duplicates, stale readings and alert-to-case; only then roll out.

## References
- Solis: https://www.soliscloud.com/
- Sungrow: https://en.sungrowpower.com/
- Huawei FusionSolar: https://solar.huawei.com/
- Growatt: https://www.growatt.com/
- GoodWe: https://www.goodwe.com/
- Modbus: https://www.modbus.org/
- SunSpec: https://sunspec.org/