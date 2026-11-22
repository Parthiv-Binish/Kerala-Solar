# Testing, Traceability & Business Acceptance Plan

**Covers:** QA-D01–QA-D10 · Draft

## Traceability
Each requirement maps to business workflow, screen/action, API operation, database entity/constraint, permission, event, test case and evidence. Status: not designed, designed, implemented, tested, accepted, deferred or rejected. A screen existing is not proof that its requirement is verified.

## Test layers
Unit tests for domain rules/calculations; integration tests for PostgreSQL, Redis, storage and adapters; API contract tests; end-to-end user journeys; security, accessibility, load, resilience and backup/restore tests; GreenGrid UAT.

## Critical end-to-end scenarios
1. Enquiry, duplicate detection, follow-up and conversion.
2. Survey appointment, technician offline capture, sync and review.
3. Design from exact survey version, BOM and quotation.
4. Discount/technical approval and customer response to exact quote version.
5. Idempotent project conversion and milestone generation.
6. Purchase request, approval, PO, partial receipt, stock reservation and issue.
7. Verified receipt, allocation, reversal and customer visibility.
8. Installation readiness, safety block, test failure, rework and handover.
9. Plant activation, device mapping, telemetry gap and stale display.
10. Alert recovery without automatic service-case closure.
11. Customer/staff service report, duplicate linking and technician resolution.
12. Notification consent, provider failure, retry and duplicate suppression.
13. Permission change, scope isolation and session revocation.
14. Document upload, scan, version, secure download and retention hold.

## Edge cases
Test expired contacts, duplicate site, concurrent conversion, stale survey, changed catalogue price, quote expiry, partial payment, over-allocation, PO discrepancy, duplicate serial, stock shortage, duplicate offline upload, wrong site, provider outage, late telemetry, invalid unit, out-of-order event, revoked customer access, opt-out and failed backup.

## Authorization and offline
Use test personas with multiple groups and scopes (own, assigned, team, related, location, company). Attempt cross-customer IDs and hidden-field mutation. Offline tests include app restart, device reboot, duplicate retry, partial upload, stale server version, assignment revocation and low storage. Assert no silent data loss and no false synced state.

## Performance and accessibility
Define workloads before targets: concurrency, plants, telemetry cadence, file and notification rates. Test search, dashboards, ingestion, workers and recovery. Test keyboard/screen reader, contrast, zoom, chart alternatives, mobile font scaling, touch targets, Malayalam/English layout and low bandwidth.

## UAT and release gate
Each UAT case has persona, preconditions, synthetic data, steps, expected/actual result, evidence, build, severity, tester and sign-off. Release requires critical/high defects resolved or risk-accepted; tests pass; privacy/security review; migration/restore tested; providers verified; support/runbooks ready; monitoring active; training complete and business owner sign-off.
