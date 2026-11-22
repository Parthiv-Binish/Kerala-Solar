# A0 Cross-Agent Blocker Register

**Owner:** A0  
**Status:** OPEN — coordination snapshot, 2026-11-22  
**Rule:** A0 tracks routing and resolution evidence; domain owners resolve technical/business blockers. A blocker is closed only after acceptance evidence is linked.

| Blocker | Severity | Affected tasks/agents | Impact | Accountable owner(s) | Required next action | Exit evidence |
|---|---|---|---|---|---|---|
| BLK-A0-001 / DOC-001 | Critical | AG-0004; A3/A4/A8; A1/A2 protected access | Authorization scopes and deny-overrides are not proven in executable backend policy | A3 resolver; A4 schema; A8 tests; business/security approval | Implement resolver for six scopes; deny-overrides; fail-closed behavior; audit and all protected query surfaces | Reviewed policy contract, truth-table tests, IDOR/cross-scope tests and merged implementation |
| BLK-A0-002 / DOC-002 | Critical | AG-0015/0025; A3/A4/A8; customer app/web | Customer/contact identity verification and customer/site authorization are incomplete | A3/A4/A8; business owner | Approve household/representative/contact verification policy; implement invite/verify/revoke lifecycle and isolation | Approved policy, schema/API/screens and cross-customer/site negative tests |
| BLK-A0-003 / DOC-003 | Critical | AG-0016; A3/A4; downstream domains | Full logical-to-physical mapping and DDL coverage are incomplete | A4; A3 review; A0 coordination | Reconcile all Stage 2 domains to Stage 3 dictionary, migration IDs, PK/FK/cardinality/delete rules | Complete mapping ledger and reviewed domain migration backlog |
| BLK-A0-004 / DOC-008 | High | AG-0003; A3/A4/A8/A9 | Bootstrap execution/runner strategy lacks disposable DB evidence | A4; A3; A8; A9 | Run SQL 0001–0006 on disposable supported PostgreSQL; record checksums, failure/rollback/clean-install tests; retain one migration authority | Test logs, schema checks, migration ledger; no-seed-data evidence |
| BLK-A0-005 / DOC-007 | High | API contracts; A3/A0/A8; A1/A2 consumers | Screen/API catalogue is not an executable OpenAPI contract | A3; A0; A8 | Publish versioned OpenAPI DTOs/errors/auth/idempotency/pagination/event definitions; collect consumer review | Merged OpenAPI plus contract tests and consumer sign-off |
| BLK-A0-006 / DOC-021 | External verification | AG-0009/0021; A5/A6/A8 | WhatsApp provider/account/terms/template/webhook reliability not verified | A5; business/legal/security | Evaluate candidate and supported alternatives; verify account, terms, templates, security, sandbox and fallback | Provider evidence pack and approved representative tests |
| BLK-A0-007 / DOC-013, DOC-021 | High/external | AG-0011/0022; A7/A3/A4/A8 | Target inverter models, data rights and telemetry semantics unknown | A7; business/device owner | Inventory exact makes/models/firmware and access rights; define units, freshness, quality, rate limits | Verified capability matrix and representative test payloads |
| BLK-A0-008 / DOC-016 | High | AG-0013/0024; A9/A8/A0 | Staging, observability, backup/restore and RPO/RTO not evidenced | A9; A8; sponsor | Establish reproducible environments and perform encrypted backup/restore drill; obtain RPO/RTO approval | Deployment evidence, restore logs, monitored SLO/alert/runbook and approved objectives |
| BLK-A0-009 / DOC-023 | Business decision | A0; all agents | GreenGrid actual roles, volumes, approval limits, customer representation and operating workflows require validation | Sponsor/business process owners | Hold discovery and record named decisions; do not invent defaults | Signed discovery/acceptance decisions linked to affected requirements |
| BLK-A0-010 / PR-3 | Coordination | A0; reviewers; A1–A9 | Coordination baseline not yet merged or agent-acknowledged | A0 + repository reviewers; each agent | Review PR #3; A1–A9 acknowledge ownership/dependencies and report capacity | Merged PR, agent status acknowledgements and updated task board |

## Immediate sequencing
1. Keep AG-0004, AG-0015 and AG-0025 blocked until BLK-A0-001/002 evidence exists.
2. Keep domain schema work beyond planning gated by BLK-A0-003/004.
3. A1 may proceed only with static AG-0005 and shell-only AG-0006 under ADR-0004; AG-0017 stays blocked.
4. A5/A7 may perform feasibility and capability discovery, not claim live integrations.
5. A8 and A9 may build test/infrastructure foundations in parallel; production/pilot gates remain closed.
