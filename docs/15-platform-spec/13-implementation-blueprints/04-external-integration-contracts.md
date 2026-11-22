# External Integration Contracts & Verification Register

**Covers:** INT-D01–INT-D10 · Draft; no unverified provider is assumed live

## Integration register
For each provider record purpose, data categories, direction, official docs, account owner, API availability, authentication/scopes, IP allowlisting, rate limits, webhook support, terms/licence, privacy assessment, test environment, supported models/entities, last verified date, status, failure fallback and support contact. Status values: unverified, testing, approved, production or retired.

## PIN/post-office lookup
Use a local PostgreSQL reference cache with provenance-aware refresh. Investigate OGD All India Pincode Directory and CEPT facility endpoint. CEPT access may require IP whitelisting; do not assume anonymous public access. Verify current endpoint, terms, fields, refresh rights and support. A PIN may map to multiple post offices; user selects the correct one. Keep manually entered address and allow free-text fallback. Do not derive coordinates from PIN without a source.

## KSEB/DISCOM and subsidy
External portal remains authoritative. Track internal checklist, submission, acknowledgement, external reference, last observed status, source and evidence. Automated integration requires official API/access authorization. Do not scrape portals or store portal credentials without written approval/security review. Scheme eligibility and benefit are version-specific; estimated, sanctioned and credited values are separate.

## Inverter manufacturers
For each brand/model verify API/protocol, firmware, metrics/units, sample cadence, authentication, rate limits, webhook signatures, retention, data rights and commercial access. Normalize identity, metrics, timestamps and quality while preserving raw payload reference. Distinguish instantaneous power from interval energy. If no API exists, document manual/approved alternative without promising automatic monitoring.

## WhatsApp Business
Select approved provider after business verification, template rules, pricing, webhook signatures, opt-in/opt-out, inbound support, rate limits, data processing and ownership review. Separate service messages from marketing. Store consent and template version. Provider acceptance is not delivery. Manual follow-up remains possible.

## Email, SMS, push and storage
Email requires domain authentication and bounce/complaint handling. SMS sender/template and applicable Indian requirements need provider/legal verification. Push tokens require lifecycle and revocation handling; payloads minimise personal data. File storage must be private, encrypted, scanned where available, checksummed and access-audited; verify region, terms, backup and deletion.

## Failure and production gate
Classify timeout, rate limit, authentication failure, schema change, outage and revoked consent. Use bounded retry, jitter, circuit breaker and dead-letter review. Production approval requires evidence of access/terms, security/privacy review, representative test payloads, failure tests, monitoring, credential rotation, named owner and manual fallback. This document does not claim integrations are active.
