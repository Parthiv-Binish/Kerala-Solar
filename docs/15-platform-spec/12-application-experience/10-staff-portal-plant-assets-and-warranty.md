# Staff Portal — Plant Registry, Equipment, Warranty & Maintenance Plans

**Document ID:** UX-STAFF-010 · **Status:** Proposed

## 1. Purpose
Maintain the operational identity of each commissioned solar plant and its installed equipment. A customer, site, project, plant, device and service case are distinct linked records.

## 2. Navigation
Assets → Plant Register, Plant Details, Equipment Register, Device Register, Serial Search, Warranty Register, Maintenance Plans, Asset Changes and Decommissioned Assets.

## 3. Plant registration
Create/activate plant only through an approved installation/commissioning workflow. Fields: plant reference, customer, site, originating project, commissioned date, system category/capacity, grid/utility metadata, status, monitoring eligibility, handover reference and responsible team. Preserve design and as-built snapshots separately.

## 4. Plant detail
Tabs: Overview, Equipment, Technical Documents, Monitoring, Warranty, Maintenance, Service History, Changes and Audit. Display identity, installed capacity as recorded, current operational state and data freshness. Do not show estimated generation as measured production.

## 5. Equipment register
Equipment types include modules, inverter, meter, gateway, battery/storage, protection equipment and mounting/BOS items as relevant. Capture manufacturer, model, serial, batch, supplier, purchase/receipt, installation date/location, parent/child relation, warranty terms/source and status. Serial uniqueness policy must be defined by equipment category/manufacturer.

## 6. Warranty
Warranty record identifies covered product/serial, provider, start/end dates, coverage type, exclusions, source document, registration reference, claim contact and verification status. Never infer warranty duration from product category. Distinguish manufacturer warranty, installer workmanship commitment and service contract.

## 7. Maintenance plans
Plan fields: plant/equipment scope, task/checklist version, cadence, next due, responsible team, customer notification policy and status. Plans generate tasks/jobs; they do not imply that a visit occurred. Record completed maintenance with evidence and findings.

## 8. Asset changes
Replacement, relocation, upgrade, removal and decommissioning are controlled events. Record reason, old/new equipment, effective time, authorisation, evidence, inventory movement and monitoring mapping update. Preserve full historical timeline.

## 9. Data movement
Reads: project handover, commissioning, catalogue, supplier receipt, serial records and customer/site. Writes: plant, asset, equipment relationships, warranty, maintenance plan, asset event and audit. Monitoring device registry references assets without merging device identity into plant identity.

## 10. Permissions and tests
asset.view/register/update/replace/decommission; warranty.view/manage; maintenance_plan.manage; serial.search; sensitive_document.view. Tests: plant activation requires commissioning; serial links trace to receipt; warranty source is retained; replacement preserves old record; maintenance completion requires evidence; decommissioned assets are excluded from active monitoring.

## 11. Decisions
Confirm plant activation gate, equipment categories, serial uniqueness, warranty verification responsibility, maintenance schedules, decommission approval and customer-visible asset information.
