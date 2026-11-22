# A8 — QA, Security & Compliance

**Status:** NOT STARTED  
**Assigned tasks:** AG-0012, AG-0023  
**Owns:** traceability, automated test strategy, security/privacy validation, regression and release evidence.

## Required outputs
- Requirement-to-screen/API/data/test traceability.
- Role/group/scope and cross-customer isolation tests.
- API, migration, mobile, browser and end-to-end test suites.
- Security, privacy, provider integration and operational test evidence.
- Defect register and release test report.

## Dependencies
All agents provide tests and build evidence; A0 supplies release candidate; A9 provides test environments.

## Rule
Every agent tests its own changes. A8 independently validates cross-system behaviour; do not waive P0/P1 or data-isolation failures silently.
