-- GreenGrid Solar | Migration 0005
-- Aligns legacy authorization scope labels to the canonical vocabulary.
-- Canonical keys: own, assigned, team, related, location, company.
-- Review any unexpected legacy values before applying.

BEGIN;

-- Migrate known legacy aliases. "all" is narrowed to the single-company boundary;
-- it never means cross-company/global access.
UPDATE iam.group_permission_set_grants
SET scope_type = CASE scope_type
    WHEN 'group' THEN 'team'
    WHEN 'resource' THEN 'related'
    WHEN 'branch' THEN 'location'
    WHEN 'all' THEN 'company'
    ELSE scope_type
END
WHERE scope_type IN ('group', 'resource', 'branch', 'all');

UPDATE iam.account_permission_overrides
SET scope_type = CASE scope_type
    WHEN 'group' THEN 'team'
    WHEN 'resource' THEN 'related'
    WHEN 'branch' THEN 'location'
    WHEN 'all' THEN 'company'
    ELSE scope_type
END
WHERE scope_type IN ('group', 'resource', 'branch', 'all');

ALTER TABLE iam.group_permission_set_grants
    DROP CONSTRAINT IF EXISTS ck_group_grant_scope;
ALTER TABLE iam.group_permission_set_grants
    ADD CONSTRAINT ck_group_grant_scope
    CHECK (scope_type IN ('own', 'assigned', 'team', 'related', 'location', 'company'));

ALTER TABLE iam.account_permission_overrides
    DROP CONSTRAINT IF EXISTS ck_account_override_scope;
ALTER TABLE iam.account_permission_overrides
    ADD CONSTRAINT ck_account_override_scope
    CHECK (scope_type IN ('own', 'assigned', 'team', 'related', 'location', 'company'));

COMMIT;
