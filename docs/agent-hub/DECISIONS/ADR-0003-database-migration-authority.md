# ADR-0003: Database Migration Authority

- **Status:** PROPOSED — current repository documentation baseline; A3/A4 approval required before formal runner transition
- **Date:** 2026-11-22
- **Decision owner:** A0
- **Owners:** A4 (DDL/migration), A3 (application/ORM), A8 (verification)

## Context
The repository contains ordered SQL bootstrap migrations 0001–0006. The migration README states these scripts are the only canonical schema-change source for the current foundation and explicitly defers Alembic adoption until the full history can be converted and equivalence-tested. Migration execution has not been verified.

## Decision
1. Treat SQL 0001–0006, in numeric order, as the sole current bootstrap authority.
2. Do not apply duplicate changes through Alembic or another migration path.
3. A4 maintains a migration ledger with file checksum, applied timestamp, environment and execution result.
4. A3/A4 define the backend migration command and application startup must not silently mutate schema.
5. Run clean-install, repeat/upgrade, failure-stop, rollback, constraints, trigger, index and no-seed-data tests against disposable supported PostgreSQL.
6. If Alembic is later adopted, convert the complete SQL history into reviewed schema-equivalent revisions, prove clean-install and upgrade equivalence on disposable databases, then retire direct SQL application for Alembic-managed environments. Never stamp an unverified database.

## Consequences
All later domain DDL is authored by A4, reviewed by A3 and A0 for API/domain impact, and tested by A8. Update the canonical dictionary and logical-to-physical map with every migration. No migration is called executed without logs/test evidence.

## Verification
Fresh PostgreSQL install of 0001–0006; checksum/ledger verification; repeat and partial-failure tests; no business/sample rows; schema diff and application integration tests.
