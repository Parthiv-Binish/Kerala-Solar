# Staff Portal — Documents, Reports & Management Analytics

**Document ID:** UX-STAFF-013 · **Status:** Proposed

## 1. Purpose
Provide secure access to business documents and reliable operational reporting. A document is a managed record with metadata and access rules, not simply a public file URL.

## 2. Navigation
Workspace → Documents, Templates, Generated Documents, Reports, Saved Views, Management Dashboard, Export Jobs and Data Quality.

## 3. Document library
Metadata: document ID, title, category, linked customer/site/project/plant/case, owner, uploader, created time, version, classification, retention class, approval state, checksum, storage key and access scope. Store file bytes in private object storage; database holds metadata and relationships. Use short-lived authorised download links, not public buckets.

## 4. Upload and versioning
Validate file type/size, malware scan where available, content signature, filename sanitisation and permissions. Preserve original; revisions create new versions. Record uploader, source, timestamp and checksum. Prevent overwriting signed/issued documents. Retention/deletion follows approved policy and legal holds.

## 5. Generated documents
Quotation, receipt, survey report, commissioning report, handover pack and service report are generated from versioned templates and source snapshots. Record template version, source record/version, generation time and output checksum. Re-generation must not silently replace an issued artifact.

## 6. Reports
Operational reports: enquiry pipeline, survey queue, quotation conversion, project delays, milestone completion, utility follow-ups, stock shortages, installation quality, customer receipts, expenses, plant health, service cases and SLA. Every report states filters, period, timezone, refresh time, definitions and data completeness.

## 7. Analytics definitions
Metric definitions have owner, formula, source records, exclusions, refresh cadence and effective date. Avoid mixing estimated and actual values. Denominators and date boundaries must be explicit. Dashboard totals should drill into permitted source records.

## 8. Export controls
Exports are asynchronous for large datasets, scoped to user's permissions, logged and expire. Mask personal/contact/bank identifiers by default. Prevent formula injection in spreadsheet exports. Record export requester, filters, row count and download event.

## 9. Data movement
Reads: domain records, document metadata, approved templates and metric definitions. Writes: document metadata/versions, generated artifacts, report definitions, export jobs and audit events. Analytics read models must not become an alternate source of truth.

## 10. Permissions and tests
document.view/upload/version/approve/download/delete_request; template.manage; report.view/create/export; analytics.view. Tests: private storage inaccessible without authorization; old versions remain; export respects row scope; metrics have definitions; sensitive fields masked; deletion follows retention/hold policy.

## 11. Decisions
Confirm retention schedule, classification labels, document categories, approval/signature rules, malware scanning, report ownership and export limits.
