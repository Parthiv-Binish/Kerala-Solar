-- GreenGrid Solar | Migration 0001
-- Requires PostgreSQL 13+ (gen_random_uuid is built in).
-- Schema-only migration. No business or sample records are inserted.
-- Apply with psql in a controlled deployment after taking a backup.

BEGIN;

CREATE SCHEMA IF NOT EXISTS ref;
CREATE SCHEMA IF NOT EXISTS org;
CREATE SCHEMA IF NOT EXISTS iam;
CREATE SCHEMA IF NOT EXISTS crm;
CREATE SCHEMA IF NOT EXISTS catalog;
CREATE SCHEMA IF NOT EXISTS sales;
CREATE SCHEMA IF NOT EXISTS project;
CREATE SCHEMA IF NOT EXISTS gov;
CREATE SCHEMA IF NOT EXISTS supply;
CREATE SCHEMA IF NOT EXISTS finance;
CREATE SCHEMA IF NOT EXISTS install;
CREATE SCHEMA IF NOT EXISTS asset;
CREATE SCHEMA IF NOT EXISTS monitor;
CREATE SCHEMA IF NOT EXISTS service;
CREATE SCHEMA IF NOT EXISTS comms;
CREATE SCHEMA IF NOT EXISTS files;
CREATE SCHEMA IF NOT EXISTS platform;
CREATE SCHEMA IF NOT EXISTS audit;

COMMENT ON SCHEMA ref IS 'Shared reference data and geography; business values are administered through the application or approved imports.';
COMMENT ON SCHEMA org IS 'Company organization, employees, departments and configurable employee groups.';
COMMENT ON SCHEMA iam IS 'Identity, authentication and authorization; separate from employee group labels.';
COMMENT ON SCHEMA audit IS 'Restricted audit and security evidence.';
COMMENT ON SCHEMA platform IS 'Integration, background job and platform operations.';

COMMIT;
