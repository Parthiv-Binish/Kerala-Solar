# GreenGrid Solar PostgreSQL Bootstrap Migrations

These are the first physical PostgreSQL migration scripts for the GreenGrid platform.

## Files and order

Run exactly in this order on a new, empty GreenGrid database:

1. `0001_create_platform_schemas.sql` — creates domain namespaces.
2. `0002_create_reference_and_geography.sql` — creates empty geography, postal-source, provenance and unit tables.
3. `0003_create_organization.sql` — creates company locations, departments, employees, contacts, addresses and configurable employee groups.
4. `0004_create_identity_and_access.sql` — creates accounts, credentials, sessions, MFA, permission sets, group grants and individual overrides.\n5. `0005_align_authorization_scopes.sql` — maps legacy scope aliases to the canonical scope vocabulary and constrains future values.

Each script uses a transaction. Stop on the first error; do not continue with later scripts after a failed migration.

## Requirements

- PostgreSQL 13 or newer because the scripts use the built-in `gen_random_uuid()`.
- Run with a dedicated migration-owner database role.
- Apply only over a secured connection to the intended database.
- Take a backup before applying to any database containing data.
- Keep PostgreSQL private; never expose the database port publicly.
- Use the same migration files in development, staging and production.

Example:

```bash
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f database/migrations/0001_create_platform_schemas.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f database/migrations/0002_create_reference_and_geography.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f database/migrations/0003_create_organization.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f database/migrations/0004_create_identity_and_access.sql\npsql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f database/migrations/0005_align_authorization_scopes.sql
```

Do not place a real production URL, password or secret in shell history, CI logs or repository files. Use the deployment platform's secret manager.

## Data policy

- These migrations create schema only. They insert no business or sample data.
- Countries, states, districts, post offices, PIN codes, address types, units, departments, employees, groups, accounts and permissions remain empty until entered through authorized application screens or populated by a separately approved and audited official reference-data import.
- India PIN format validation belongs in the backend validation layer for the selected country. A PostgreSQL CHECK constraint cannot safely query the countries table; do not add a cross-table subquery to a CHECK constraint.
- Imported postal data must record source, import run, source record key and retrieval/verification timestamps.
- No CEPT/OGD API credentials or tokens belong in SQL files or Git.

## Important implementation notes

- Internal primary keys use BIGINT identity; public-facing identifiers use UUIDs. Do not expose sequential IDs in public URLs.
- Group names are not roles. Permissions and scope grants are separate.
- Employee manager relationships do not automatically grant access.
- Identity accounts are linked to employees through a dedicated link table. Customer account linking will be added with the CRM/customer migration.
- The reference provenance table uses an entity table name and record ID because it tracks several reference tables. This is an audit/import association, not a replacement for ordinary business foreign keys.
- The SQL scripts are the bootstrap source for this initial batch. Before application release, register them in the project's formal migration runner (recommended: Alembic) so deployed schema versions are tracked and upgrades are repeatable. Do not also apply the same changes through a second migration path.

## Validation after applying

Run these checks:

```sql
SELECT schema_name
FROM information_schema.schemata
WHERE schema_name IN ('ref', 'org', 'iam', 'crm', 'platform', 'audit')
ORDER BY schema_name;

SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_schema IN ('ref', 'org', 'iam')
  AND table_type = 'BASE TABLE'
ORDER BY table_schema, table_name;

SELECT COUNT(*) AS country_rows FROM ref.countries;
SELECT COUNT(*) AS employee_rows FROM org.employees;
SELECT COUNT(*) AS employee_group_rows FROM org.employee_groups;
SELECT COUNT(*) AS account_rows FROM iam.identity_accounts;
```

On a fresh database, the four counts should be zero. This confirms the no-seed-data rule; it is not a substitute for migration, constraint, authorization or application integration tests.

## Not yet included

CRM/customer tables, customer identity links, product catalogue, survey/quotation, projects, finance, inventory, installation, assets, telemetry, service, notifications, documents and integration workers are later migration batches. Do not create these tables manually outside the approved migration sequence.


## Migration 0005 — authorization scope alignment

Canonical scope values are `own`, `assigned`, `team`, `related`, `location` and `company`. The migration maps legacy `group` to `team`, `resource` to `related`, `branch` to `location`, and `all` to `company` (within the single GreenGrid company boundary only). Review existing grant rows and export a backup before applying this migration to any populated database. The SQL change does not implement the authorization resolver or prove deny-precedence correctness; those require backend policy code and automated tests.

The canonical resolver and precedence are specified in [Consistency Resolution Decisions](../../docs/15-platform-spec/13-implementation-blueprints/10-consistency-resolution-decisions.md). The migration has not been executed against a live database as part of this documentation change.
