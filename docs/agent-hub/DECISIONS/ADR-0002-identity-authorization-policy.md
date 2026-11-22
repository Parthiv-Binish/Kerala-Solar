# ADR-0002: Identity and Authorization Policy

- **Status:** PROPOSED CANONICAL IMPLEMENTATION POLICY — business/security approval and test evidence required
- **Date:** 2026-11-22
- **Decision owner:** A0
- **Implementers:** A3 (resolver/API), A4 (physical data), A8 (independent tests)
- **Consumers:** A1, A2, A5, A6, A7, A9

## Context
The repository contains overlapping legacy terminology and logical/physical differences. Migration 0005 constrains scope vocabulary; migration 0006 adds a minimum customer/contact subject foundation. Neither migration implements the backend resolver or proves isolation.

## Decision
- Group membership is not a role. Groups are configurable membership/grant sources.
- Permissions are explicit capabilities; data scopes are separate record predicates.
- Canonical employee scope keys are `own`, `assigned`, `team`, `related`, `location`, `company`. No implicit all/branch/group/resource scope.
- Resolve each grant scope independently against authenticated actor and target resource. Do not infer team access from reporting hierarchy or trust client-supplied IDs.
- Any applicable explicit deny overrides every matching allow, including individual allow. No matching allow means deny. Unknown/unresolvable policy fails closed.
- Enforce record predicates before pagination, search, counts, aggregates, exports, files, realtime subscriptions and background jobs.
- Employee and customer account populations remain separate. Customer authorization uses verified, active customer-account/contact links and customer/site policy, not employee group grants. A phone/email match alone grants no authority.
- Preserve revocation actor/time and verification evidence; audit privileged access and relationship changes.

## Consequences
A3 owns executable policy resolver and endpoint enforcement. A4 owns schema constraints and migration correctness. A8 owns truth-table, IDOR, cross-customer/site and cross-group negative tests. A1/A2 only reflect server decisions and must not implement independent policy. The current physical schema is a foundation, not complete CRM/customer authorization.

## Open approvals
Customer/contact verification evidence, household/representative model, whether a human may hold both employee and customer contexts, approval authority for overrides/elevation, and final permission catalogue require business/security owner approval. Do not silently change the current separation model.

## Verification
Truth-table covers allow-only, deny-only, conflicting allow+deny, individual allow+deny, expired grants, inactive membership, unresolved scope, revoked customer link, mismatched contact/customer and cross-site access. Verify all protected query surfaces and worker/file/realtime paths.
