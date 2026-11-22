# A0 Baseline Handoff — Coordination Package

**From:** A0  
**To:** A1–A9  
**Date:** 2026-11-22  
**Status:** PUBLISHED IN COORDINATION BRANCH; not yet merged or acknowledged

## Delivered
- Master implementation roadmap and MVP/Phase 2 boundary.
- Agent dependency matrix and file ownership proposal.
- Relative sprint/milestone plan and Definition of Ready/Done.
- Integration readiness checklist with evidence gates.
- ADR-0001 platform boundaries, ADR-0002 identity/authorization, ADR-0003 migration authority, ADR-0004 web frontend workspace/task sequence.
- Shared API/data contract baseline and expanded API contract register.
- A1 issue #2 answered with a safe start: AG-0005 public static shell and AG-0006 staff shell/navigation placeholders; protected behavior remains gated.
- Coordination branch, task board, status and PR #3.

## Not delivered / not claimed
- No application code or database migrations were executed.
- No agent has been launched, assigned externally, or verified as having started/completed implementation.
- No provider integration, CI pipeline, staging/production environment or live monitoring is verified.
- No business/security/legal/provider policy is approved by this handoff.

## Required acknowledgements
Each agent replies in its status report with: accepted ownership or proposed correction; branch/worktree; planned files; dependencies; contract changes; test plan; blockers; estimated capacity. Agents must not begin overlapping edits until path ownership is agreed.

## Agent-specific next actions
- **A1:** acknowledge ADR-0004; start AG-0005 public static shell and shell-only AG-0006 under `apps/web/**`; use UI/UX tokens; no fabricated claims or API wiring; keep AG-0017 blocked.
- **A2:** confirm distinct customer/technician app identities, secure storage and online-first MVP boundary; map device/push token lifecycle.
- **A3:** publish FastAPI/OpenAPI skeleton plan; own executable authorization resolver, error/idempotency/outbox contract; coordinate schema impact with A4.
- **A4:** audit SQL 0001–0006 and test clean install; publish remaining schema batches and migration ledger; reconcile physical map with Stage 3.
- **A5:** evaluate OpenWA and official alternative feasibility, terms, account/session lifecycle, webhook security and fallback; do not claim official API status.
- **A6:** define channel-neutral notification event/delivery schemas, preferences/consent and recipient eligibility; coordinate outbox with A3 and push token with A2.
- **A7:** inventory actual target inverter makes/models and authorized data access; define telemetry units/freshness/quality/alert contract with A3/A4.
- **A8:** establish requirement traceability, test IDs, authz truth table, security threat model and cross-app regression gates.
- **A9:** establish reproducible Docker dev/CI baseline, secret handling, private data stores, backup/restore and observability plan.

## Handoff acceptance
A0 accepts an agent handoff only when it contains task IDs, PR/commit, changed files, contract/schema versions, requirements/DOC issues, tests and environment, security notes, known gaps, rollback/deployment notes and next owner.
