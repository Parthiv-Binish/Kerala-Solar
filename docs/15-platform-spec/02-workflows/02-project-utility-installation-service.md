# Workflow: Project, Utility, Installation and Service

## Project lifecycle
Enquiry qualification → pre-sales site survey → design → issued quotation → customer acceptance and commercial approval → Won conversion (customer + confirmed site + project) → payment/receipt milestones → utility application tracking → procurement → installation → inspection/agreement/meter → commissioning → handover → monitoring → O&M/AMC.

Survey/design/quotation work before acceptance remains linked to the enquiry and prospect site; it is not a delivery project. Survey approval alone does not create a project. Project creation occurs only through the idempotent Won conversion after acceptance of an exact issued quotation version, required commercial approvals and confirmation of one installation site. Ambiguous/incomplete site data blocks conversion. Project status is a summary. Each milestone has its own state, owner, due date, evidence and update history.

## Utility milestones
Track feasibility/application, vendor selection/reference, installation completion submission, inspection, agreement, meter request, meter availability, meter installation, commissioning and subsidy status independently. Store application reference, last checked date, updater, source and supporting document. Government completion requires evidence or a documented exception.

## Meter/subsidy delay
Provide pending queues, ageing buckets, next follow-up date, responsible employee, reason and customer communication. Media reports are not live KSEB inventory.

## Procurement
Project BOM → purchase request → approval → purchase order → goods receipt → serial capture → stock reservation → issue to installation → unused material return. Serialized equipment retains supplier, invoice, model, serial, warranty evidence and project association.

## Installation work order
Create work order, assign technician/team, reserve materials, provide checklist, record start/end, photographs, serial numbers, test readings, defects and customer acknowledgement. Completion evidence is reviewed by an authorised project manager. Installation completion is not grid commissioning.

## Handover
Activate plant record; link devices; store as-built details, manuals, certificates, warranty dates, customer acknowledgement and monitoring status.

## Service case
New → triaged → assigned → acknowledged → remote diagnosis → field visit if needed → parts/RMA if needed → resolved → customer confirmation → closed. Reopen with reason. Device alert is a signal; policy decides whether it creates a case.

## Warranty and AMC
Warranty stores device, serial, supplier, purchase evidence, terms and verified dates. RMA stores manufacturer reference, troubleshooting evidence, approval, dispatch and replacement serial. AMC stores coverage, exclusions, visits, renewal and payment. Cleaning intervals are configurable, not assumed statutory.

## SLA
Define priority, acknowledgement target, resolution target, business calendar, escalation and pause rules. Every pause requires reason and timestamps. Customer updates must not expose internal notes.
