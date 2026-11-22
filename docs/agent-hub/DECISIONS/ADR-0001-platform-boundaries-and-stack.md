# ADR-0001: Platform Boundaries and Stack

- **Status:** PROPOSED — aligns with current architecture specification; sponsor/technical owner approval required for implementation baseline
- **Date:** 2026-11-22
- **Decision owner:** A0
- **Reviewers:** A1–A9; sponsor for scope/cost implications

## Context
The product requires staff, customer and technician experiences to share one authoritative business record set while retaining different access contexts. Independent application backends or client-to-database access would create conflicting identities, policy and data.

## Decision
Adopt one modular FastAPI backend and one PostgreSQL database. Use React + TypeScript + Vite for web; React Native + Expo + TypeScript for Android; Redis + ARQ for justified background jobs; private S3-compatible object storage; authenticated WebSockets only where needed; Docker-based deployment behind Nginx/TLS. Begin as a modular monolith with explicit domain modules and interfaces.

Staff Portal is the MVP internal workspace. Customer and technician Android apps are separate experiences. Customer Web Portal is Phase 2 by default. Monitoring and Notification Engines are backend modules/workers, not separate customer-facing products.

## Consequences
- One API and system of record; no direct DB/Redis/storage access from clients.
- Domain modules own schemas/services/repositories/routes/tests; avoid circular dependencies.
- Provider integrations remain replaceable adapters.
- Microservices, TimescaleDB and extra infrastructure require measured need and a separate ADR.
- Deployment sizing and RPO/RTO remain planning targets until tested.

## Rejected alternatives
- Microservices from day one: unnecessary operational and integration complexity for the current scope.
- Separate backend/database per app: creates duplicate records and inconsistent authorization.
- Client-side business logic as authority: insecure and non-auditable.

## Verification
- FastAPI/OpenAPI baseline; PostgreSQL migration/transaction tests; Docker dev/staging; cross-app integration tests; load/reliability evidence before scaling decisions.
