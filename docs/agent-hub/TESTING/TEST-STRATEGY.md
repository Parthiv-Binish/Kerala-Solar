# Test Strategy

Every agent tests its own work. A8 owns cross-system strategy, traceability, regression, security review and release evidence.

## Required layers
Static checks; unit; component; API/contract; database migration/integrity; integration; end-to-end; security; operational; user acceptance.

## Mandatory rules
- Map requirements and screen/API operations to test IDs.
- Include positive, negative, boundary, permission, retry, duplicate and failure/recovery cases.
- Test server-side authorization, including list/count/search/export/file paths and cross-customer isolation.
- Use synthetic fixtures only; never put fake business records into production.
- Identify build/commit, environment, date, actual result and evidence.
- Fix flaky tests; do not silently skip them.
- P0/P1 or data-isolation failures block release absent documented exceptional approval.

## Release gates
Use the mandatory baseline in the multi-agent development plan §14.2. A8 maintains the expanded register and publishes release test reports. A0 records release decision; A9 deploys only after approval.