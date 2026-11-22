# Project Charter and Scope

## Vision
Give GreenGrid one connected operating platform for sales, project execution, customer communication, equipment monitoring and after-sales service.

## Outcomes
- Reduce enquiry leakage and missed follow-ups.
- Convert accepted enquiries into customer/project records without re-keying.
- Show project milestones, owners and blockers.
- Track utility, meter and subsidy delays.
- Trace equipment from procurement through warranty and service.
- Improve customer self-service and service transparency.
- Turn actionable device alerts into managed work.

## Applications and deployment boundaries
1. Staff Portal: responsive internal web workspace; MVP primary interface.
2. Customer Android app: MVP foundation for customer status, documents, notifications and service.
3. Technician Android app: MVP online-first foundation for assigned work, checklists, evidence and equipment records.
4. Customer Web Portal: Phase 2 by default; shares customer identity, APIs, records and authorization with Customer Android. Pull into MVP only through signed scope change.
5. Monitoring and Notification Engines: backend modules/workers, not separate customer-facing products.
6. Platform Administration: protected area of the Staff Portal, not a separate deployment by default.

Customer and technician apps may share React Native packages/code, but remain separate user experiences and separately releasable app identities where distribution requires it. Shared code does not imply shared navigation, permissions or data visibility.

## MVP scope
Authentication; group access; enquiry CRM; customer conversion; customer/site/project records; surveys; quotation revisions; project milestones; manual KSEB/PM Surya Ghar tracking; document vault; installation work orders; basic service cases; notifications; basic invoices/payment records; customer and technician app foundations (online-first; full offline sync is Phase 2).

## Later scope
Full encrypted technician offline job packs, durable offline drafts, media queueing and conflict-aware synchronisation; Customer Web Portal unless promoted by signed scope change.
Inventory depth; procurement; AMC and warranty/RMA; manufacturer telemetry connectors; automated alerts; advanced analytics; local Modbus gateways; advanced yield prediction; multi-branch and multi-company support.

## Not assumed
No confirmed public E-Kiran or National Portal API. No automatic government submissions. No remote inverter control in the first monitoring release. No assumption that all installations qualify for PM Surya Ghar subsidy. No assumption about GreenGrid actual brands or workflows until discovery.

## Stakeholders
Owner/sponsor, sales, survey/engineering, project management, technicians, accounts, support, customers, KSEB/utility counterparts, manufacturers and platform operator.

## Success measures
Enquiry response time, enquiry-to-survey conversion, survey-to-quotation time, quotation win rate, project cycle time, overdue milestones, meter-pending ageing, open cases, SLA attainment, repeat faults, AMC renewal and app adoption. Set targets only after measuring baseline.

## Approval gates
Discovery sign-off → SRS sign-off → UX approval → MVP acceptance → pilot approval → production readiness.
