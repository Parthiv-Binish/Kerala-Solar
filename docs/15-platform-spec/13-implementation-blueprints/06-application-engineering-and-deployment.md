# Application Engineering, Infrastructure & Deployment Blueprint

**Covers:** DEV-D01–DEV-D10 and OPS-D01–OPS-D10 · Draft

## Proposed runtime
React/Vite web clients; Expo/React Native Android clients; FastAPI backend; PostgreSQL; Redis for cache/queue where appropriate; background workers; private object storage; Nginx; Docker Compose for initial VPS deployment; GitHub Actions CI/CD. Validate cost, workload and security before final sizing.

## Repository structure
Suggested areas: staff web, customer web, technician mobile, customer mobile, API service, worker service, shared API client/types/UI, infrastructure, monitoring, docs and tests. A monorepo is optional; avoid duplicated business logic and unversioned shared contracts.

## Backend and frontend
Backend modules: API routers, core config/security, domain rules, application services, repositories, schemas/DTOs, provider adapters, workers, events/outbox and audit. Routers remain thin. Frontends use feature-based modules, route registry, typed API client, accessible shared components and server-state cache. Client optimistic updates are never proof of commit.

## Mobile
Separate customer and technician capabilities. Technician app includes secure local persistence, upload queue, sync engine, connectivity awareness and operation IDs/entity versions. Customer app does not need technician job cache. Tokens use secure platform storage.

## Environments and secrets
Separate local/development/staging/production. Variables include API URL, DB/Redis endpoints, object storage, auth, CORS, provider references, logging and feature flags. Secrets live in secret manager/runtime environment, never Git. Commit placeholder-only environment examples.

## VPS, containers and network
Size only after estimating staff concurrency, customer sessions, plant count, telemetry cadence, file volume, notifications, database growth and backup size. Containers may include API, worker, scheduler, PostgreSQL, Redis and reverse proxy. Expose only HTTPS reverse proxy publicly; keep database and Redis private. Use non-root containers, pinned images, health checks, persistent volumes, resource limits and runtime secrets.

## Nginx and CI/CD
Configure TLS, renewal, secure headers, request limits, timeouts, rate limits and access-log redaction. CI runs format/lint, type checks, unit tests, security/dependency scans, migration validation, OpenAPI validation and builds. Staging deploy includes migrations and smoke tests. Production requires approval, backup readiness, monitored rollout and rollback plan.

## Observability and operations
Structured logs with correlation IDs; metrics for API latency/errors, DB pool/slow queries, queue lag, worker failures, storage, telemetry and message delivery. Alerts need owners/runbooks. Create runbooks for deployment/rollback, failed migration, DB saturation, queue outage, storage failure, credential compromise, provider outage, notification failure, telemetry gap, lost device, suspected breach and restore.

## Backup and disaster recovery
Define RPO/RTO with business owner. Back up PostgreSQL with tested restore/PITR, object storage with versioning, encryption, offsite copy and key recovery. Restore drills verify data, files and application startup. Code rollback may not reverse schema changes; use expand/contract migrations and forward fixes where needed.

## Release acceptance
Environments isolated; secrets external; DB/queue private; CI validates contracts; migrations reviewed/tested; backup restored in drill; monitoring alerts owned; staging rollback tested; capacity measured before production sizing.
