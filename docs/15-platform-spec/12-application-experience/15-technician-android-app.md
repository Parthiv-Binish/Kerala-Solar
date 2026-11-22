# Technician Android App — Complete Screen & Field Workflow Specification

**Document ID:** UX-TECH-001 · **Status:** Proposed

## 1. Product purpose
A field-first Android application for assigned survey, installation, commissioning and service work. It must minimise typing, make the next action obvious, support poor connectivity and prevent unreviewed/incomplete work from appearing complete.

## 2. Users and access
Roles/capabilities are granted independently of group names: technician.job.view_assigned, job.accept, job.start, survey.submit, installation.record, commissioning.record, service_visit.record, evidence.upload, customer_acknowledgement.capture and sync.resolve. Enforce assigned job, project, site and time scopes. Technician sees only minimum customer contact/site data needed for the job.

## 3. Navigation
Bottom navigation: Today, My Jobs, Calendar, Updates, Profile. Job detail tabs: Overview, Checklist, Evidence, Materials, Notes and History. Deep links open a job only after server authorization.

## 4. Screens
**T01 Splash/session restore:** checks secure session, app version and pending sync. Never expose tokens in logs.

**T02 Sign in:** approved identity provider/password/OTP policy; MFA if required; account recovery; device registration. Show clear offline sign-in limitations.

**T03 Today:** assigned jobs, due times, priority, site locality, sync status and quick actions. Empty state explains no assignment and support route.

**T04 My Jobs:** filters by date/status/type; search by reference; list shows only assigned/permitted jobs. Pull-to-refresh does not erase offline work.

**T05 Calendar:** day/week schedule, appointment window, route/address launch with consent and device capability. Conflicts flagged; user cannot silently reschedule customer appointment.

**T06 Job Detail:** job reference, project/site, task objective, appointment, customer contact, access instructions, safety notices, required checklist and documents. Start action validates assignment and prerequisites.

**T07 Start/Pause/Resume:** capture timestamp and optional arrival evidence; pause requires reason; resume creates event. Device clock is not sole authority; server reconciliation policy applies.

**T08 Survey checklist:** sections for site identity, roof/mounting, shading, electrical observations, consumption evidence, access/logistics and customer requirements. Each answer supports required/optional, not-applicable reason, unit and notes. No engineering approval inferred from technician entry.

**T09 Measurement entry:** typed numeric fields with unit, validation range from configured form, instrument/source, capture time and optional note. Out-of-range values require review, not silent clamp.

**T10 Photo/document capture:** category, description, consent prompt, capture/import, preview, retake, upload queue and deletion policy. Metadata and file checksum retained. Avoid unnecessary personal imagery.

**T11 Installation checklist:** approved task sequence, pass/fail/NA, mandatory evidence, blocker and supervisor escalation. Critical safety failure blocks completion.

**T12 Material/equipment capture:** scan barcode/QR or enter serial manually; validate product, issue record, duplicate serial and job allocation. Offline capture marked pending server verification.

**T13 Commissioning:** versioned approved checklist; record readings, units, instrument, test outcome and evidence. Numeric thresholds supplied by approved technical configuration only.

**T14 Service visit:** issue diagnosis, tests, action, part usage, old/new serial, result, follow-up and unresolved condition. Alert recovery does not close the service case.

**T15 Customer acknowledgement:** show work summary and exact evidence/statement acknowledged. Record person, relationship, time and method. Acknowledgement is not a digital signature unless supported by a verified signing process.

**T16 Submit Work:** validation summary, missing fields/evidence, draft preview and submit confirmation. Submitted record becomes reviewable; correction creates an amended submission/version rather than erasing history.

**T17 Job History:** completed/returned jobs, reviewer feedback and allowed evidence. **T18 Updates:** assignments, schedule changes, return requests and system messages. **T19 Profile:** work contact, language/accessibility preferences, app version, device/session management and support.

## 5. Offline and synchronisation model — Phase 2
Full encrypted local job packs, durable drafts across restart, media queueing, conflict resolution and reliable background sync are Phase 2 (Should), not MVP acceptance. MVP is online-first; it must show connection state, preserve current unsent input where practical and never claim a submission synced before server acknowledgement. If offline capability is promoted into MVP, the scope and delivery estimate must be formally changed.


Local encrypted storage contains only assigned job payload and necessary drafts. Each mutation has client-generated operation ID, entity version, device timestamp and pending state. Queue states: Pending, Uploading, Synced, Needs Attention, Failed. Retry is idempotent. Server timestamps and version checks govern authoritative order.

Conflict rules:
- Append-only evidence/events can usually merge if operation IDs are unique.
- Conflicting edits to same checklist field require user/reviewer resolution.
- Revoked assignment blocks new submissions; unsent drafts are retained securely and clearly flagged for support.
- Never silently discard data or claim synced before server acknowledgement.
- Upload retry uses backoff and resumable transfer where supported.

## 6. Data and API contract
Reads: assigned jobs, site/customer minimum data, approved design/job pack, checklist version, inventory allocation, schedules and notifications. Writes: job events, form answers, measurements, evidence metadata/files, serial captures, tests, visit reports, acknowledgement and submission. Every command includes idempotency key and entity version.

## 7. Safety, privacy and UX
Prominent stop-work/escalation action; do not encourage work in unsafe conditions. Collect location only when needed and disclosed. App lock/session expiry, encrypted local storage, secure file cache and remote session revocation. Large tap targets, readable contrast, low-bandwidth mode, clear units and Malayalam/English localisation readiness.

## 8. Acceptance tests
- [ ] Technician cannot access unassigned jobs.
- [ ] Offline draft survives app restart.
- [ ] Duplicate sync does not duplicate records.
- [ ] Conflicting edits are surfaced.
- [ ] Critical safety/test failures block submission.
- [ ] Serial conflict is flagged.
- [ ] Reviewer return is visible with actionable comments.
- [ ] Customer acknowledgement records exact content.
- [ ] No false “synced” state before server confirmation.
