# A3 — Backend & Business Logic

**Status:** NOT STARTED  
**Assigned tasks:** AG-0002, AG-0004, AG-0015, AG-0020 (co-owner)  
**Owns:** FastAPI, business workflows, authorization, APIs, domain events and OpenAPI.

## Required outputs
- Modular backend, API/error conventions and OpenAPI.
- Transaction-safe, idempotent business workflows.
- Server-side permission and record-scope enforcement.
- Domain event/outbox and integration interfaces.
- Unit, API and integration tests.

## Dependencies
A4 migration/data model; A0 ADRs; A5/A6/A7 provider/channel contracts.

## Current report
No implementation claimed. Preserve canonical conversion, finance, access-control and notification decisions. No direct client-to-database access.
