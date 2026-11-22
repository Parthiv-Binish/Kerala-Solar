# GreenGrid Solar PostgreSQL Bootstrap Migrations

These are the first physical PostgreSQL migration scripts for the GreenGrid platform.

## Files and order

Run exactly in this order on a new, empty GreenGrid database:

1. `0001_create_platform_schemas.sql` — creates domain namespaces.
2. `0002_create_reference_and_geography.sql` — creates empty geography, postal-source, provenance and unit tables.
3. `0003_create_organization.sql` — creates company locations, departments, employees, contacts, addresses and configurable employee groups.
4. `0004_create_identity_and_access.sql` — creates accounts, credentials, sessions, MFA, permission sets, group grants and individual overrides.
5. `0005_align_authorization_scopes.sql` — maps legacy scope aliases to the canonical scope vocabulary and constrains future values.
6. `0006_create_customer_identity_links.sql` — creates the minimal customer/contact subject tables and verified, revocable customer-account links.

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
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f database/migrations/0004_create_identity_and_access.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f database/migrations/0005_align_authorization_scopes.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f database/migrations/0006_create_customer_identity_links.sql
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
- Employee accounts link through `iam.employee_account_links`; customer accounts link through `iam.customer_account_links`. Migration 0006 creates only the minimum `crm.customers` and `crm.customer_contacts` subject tables needed for this typed relationship. Remaining CRM tables are later migrations. Customer links require a customer account type, employee-account verification and revocation actors, timestamps before activation/revocation, and a customer/contact match enforced by a composite foreign key.
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
SELECT COUNT(*) AS customer_rows FROM crm.customers;
SELECT COUNT(*) AS customer_contact_rows FROM crm.customer_contacts;
SELECT COUNT(*) AS customer_account_link_rows FROM iam.customer_account_links;
```

On a fresh database, all listed counts should be zero. This confirms the no-seed-data rule; it is not a substitute for migration, constraint, authorization or application integration tests.

## Not yet included

Remaining CRM tables (contact methods, addresses, consent, enquiries, activities, conversions and related masters), product catalogue, survey/quotation, projects, finance, inventory, installation, assets, telemetry, service, notifications, documents and integration workers are later migration batches. Migration 0006 is only the minimum customer identity foundation, not full CRM. Do not create these tables manually outside the approved migration sequence.


## Migration 0005 — authorization scope alignment

Canonical scope values are `own`, `assigned`, `team`, `related`, `location` and `company`. The migration maps legacy `group` to `team`, `resource` to `related`, `branch` to `location`, and `all` to `company` (within the single GreenGrid company boundary only). Review existing grant rows and export a backup before applying this migration to any populated database. The SQL change does not implement the authorization resolver or prove deny-precedence correctness; those require backend policy code and automated tests.

The canonical resolver and precedence are specified in [Consistency Resolution Decisions](../../docs/15-platform-spec/13-implementation-blueprints/10-consistency-resolution-decisions.md). The migration has not been executed against a live database as part of this documentation change.


## Migration 0006 — customer identity foundation

Migration 0006 adds the minimum customer and contact subject tables plus `iam.customer_account_links`. Customer links are per customer, may optionally identify a contact belonging to that customer, and retain verification/revocation state. The trigger rejects employee/service accounts; the FK ensures an optional contact belongs to the same customer. This does not prove the application-level authorization resolver or account verification workflow. Customer accounts remain separate from employee accounts in the initial design.


## Single migration authority

For the current foundation, ordered SQL files `0001`–`0006` are the only canonical schema-change source. Apply them in numeric order and record each successful file/checksum in the deployment migration ledger. Do not duplicate these changes in Alembic or apply an alternate bootstrap to the same database. Alembic adoption is deferred until backend implementation; before adoption, convert the complete SQL history into reviewed schema-equivalent revisions, verify clean install and upgrade equivalence in disposable PostgreSQL, then retire direct SQL application for Alembic-managed environments. Never stamp an unverified database. No live or disposable PostgreSQL execution is claimed by this documentation update.
