# A9 — DevOps, Infrastructure & Reliability

**Status:** NOT STARTED  
**Assigned tasks:** AG-0013, AG-0024  
**Owns:** dev/staging/prod environments, VPS hardening, Docker, Nginx, CI/CD, secrets, backups and observability.

## Required outputs
- Environment and network architecture.
- Docker/Compose and health checks.
- CI for lint, typecheck, tests, build and migration validation.
- Secure deployment, rollback and secret rotation runbooks.
- Encrypted backup and verified restore drill.
- Logs, metrics, alerts and incident runbooks.

## Dependencies
A0 deployment ADRs; A3/A4 application and migration requirements; A8 release gates.

## Rules
Never commit secrets or expose PostgreSQL/Redis/private storage publicly. No production deployment or restore success claim without execution evidence.
