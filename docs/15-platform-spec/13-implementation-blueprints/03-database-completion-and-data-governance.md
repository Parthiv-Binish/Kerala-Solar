# Database Completion & Data Governance

**Covers:** DB-D01–DB-D10 · Draft; reconcile before execution

## Scope
Complete the path from domain ER designs and canonical dictionary to executable PostgreSQL schema. Existing bootstrap migrations 0001–0004 are source files; they have not been verified as executed on a live database.

## Reconciliation
For each entity compare Stage 1 inventory, Stage 2 ER design and Stage 3 dictionary. Resolve naming, type and cardinality differences; define lifecycle, immutable snapshots, ownership, delete behaviour, uniqueness scope, indexes, API mapping and tests. Record conflicts and decision owner; do not silently choose between inconsistent sources.

## Schema conventions
Use snake_case. Every table defines purpose, owner, primary/foreign keys, nullability, uniqueness, check constraints, indexes, audit policy, retention and classification. Use timestamptz for instants, date for calendar dates, numeric or integer minor units for money with explicit currency, and documented units for measurements. JSONB is for versioned provider payload/configuration, not core relational facts. Use foreign keys and database constraints for integrity.

## Lifecycle and integrity
Protect issued quotations, posted receipts, audit events and submitted survey versions from in-place edits. Corrections create versions or compensating records. Avoid cascades that erase finance, service or audit history. Define serial uniqueness by equipment category and policy.

## Indexing
Index foreign keys used in joins, scoped filters, unique business references and high-volume time-series queries. Composite/partial indexes follow measured predicates. Verify with EXPLAIN ANALYZE on representative synthetic data and consider write overhead.

## Migration backlog and Alembic
Build migrations by domain dependency, not screen. Each revision includes preconditions, upgrade, downgrade or irreversible rationale, backfill, lock/downtime assessment, validation and recovery plan. Reconcile raw SQL 0001–0004 with Alembic using an explicit baseline/stamp strategy; never execute duplicate schema paths. Test on disposable PostgreSQL before staging.

## Reference data and provenance
Imports record source, licence/terms, dataset version, retrieval time, checksum, row counts, transformations, errors, approver and run ID. No fake customer/business data in migration seeds. PIN/post-office imports are separate from schema migrations. Do not infer coordinates from PIN. Preserve manual address entry and user-entered values.

## Backup, restore and retention
Define RPO/RTO with business owner; document frequency, PITR/WAL, encryption, key recovery, offsite copies, retention and object-storage versioning. Restore drills verify relational integrity, files and application startup. Retention schedules for identity, finance, communications, telemetry, files, logs and audit require legal/business approval. Automated deletion checks legal holds and records evidence.

## Acceptance
ER, dictionary, DDL and API fields reconcile; each table has owner/integrity rules; migration baseline avoids duplicate execution; migrations tested; imports have provenance; no fake business records are seeded; restore drill is evidenced; retention is approved before deletion automation.
