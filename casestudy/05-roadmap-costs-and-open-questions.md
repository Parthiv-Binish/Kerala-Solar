# 05 — Roadmap, Costs, Risks and Client Questions

## MoSCoW priorities

### MVP — Must have
- Staff login, multi-group access, scopes, permissions and audit.
- Leads, customers, sites and activities.
- Survey checklist and photos.
- Versioned quotations and basic BOM.
- Project lifecycle and milestones.
- Manual KSEB/E-Kiran and subsidy tracking.
- Secure document vault.
- Installation work orders and checklists.
- Cases, assignment, comments and SLA.
- WhatsApp Business API and email notification outbox.
- Customer project timeline and service requests.
- Owner dashboard for leads, active projects, pending utility stages and open cases.

MVP must be useful before inverter APIs are integrated.

### Phase 2 — Should have
- First one or two manufacturer integrations based on actual installed fleet.
- Telemetry dashboard and alert-to-case.
- Technician app with offline drafts.
- Inventory/procurement.
- Warranty/RMA and AMC.
- Push notifications.
- Payment gateway/payment links if requested.
- Customer generation/savings estimates.
- Automated escalation and scheduled maintenance.

### Phase 3 — Could have
- Advanced branch reporting.
- Forecasting/anomaly detection.
- Bill OCR and tariff analysis.
- Procurement forecasting.
- More manufacturer integrations.
- Fleet benchmarking/analytics warehouse.
- Document extraction with human review.
- Advanced multi-tenant SaaS.
- Group/virtual net-metering workflows where commercially relevant and operationally available.

### Not in initial release
Direct remote inverter control, unauthorised portal automation, automated electrical approval, automated legal eligibility guarantees, full ERP replacement and AI diagnosis without validated data/human review.

## Delivery roadmap

Planning estimate for one experienced full-stack developer with occasional design/QA support:

| Phase | Scope | Estimate |
|---|---|---:|
| 0 | Discovery, process mapping, regulatory/device validation | 1–2 weeks |
| 1 | Repo, CI/CD, auth, groups, audit, DB and storage | 2–3 weeks |
| 2 | CRM, sites, surveys, quotes and projects | 3–5 weeks |
| 3 | Utility tracking, documents, cases, work orders, notifications | 3–5 weeks |
| 4 | Customer app | 3–4 weeks |
| 5 | One manufacturer monitoring pilot | 3–6 weeks |
| 6 | Technician mobile/offline workflow | 3–5 weeks |
| 7 | Security, UAT, performance, restore tests and training | 2–3 weeks |

Indicative broad release: 20–33 weeks for one developer, with overlap possible. A smaller MVP can ship earlier by postponing device integrations and advanced mobile features.

## Cost model

These are planning estimates, not live vendor quotes. Verify region, taxes, usage and current provider pricing.

Suggested initial VPS: 4 vCPU, 8 GB RAM, 100–160 GB SSD/NVMe, off-server backups, firewall and SSH key-only access. A 2 vCPU/4 GB pilot may work at low usage but can become constrained.

| Component | Indicative INR/month |
|---|---:|
| VPS (4 vCPU / 8 GB class) | ₹800–₹2,000 |
| Object storage/egress | ₹100–₹500 |
| Off-site backup | ₹100–₹400 |
| Email | Free tier to ₹500+ |
| Monitoring/logging | Free tier to ₹500 |
| WhatsApp | Usage/category dependent |
| SMS | Provider/route/DLT dependent |
| Push | FCM generally no per-message charge; other costs may apply |
| Domain | Annual fee varies |
| App store accounts | Verify current fees |

Lean pilot planning range: roughly ₹1,500–₹3,500/month excluding significant WhatsApp/SMS volume, paid support and developer time. Resilient separate DB/backup infrastructure costs more.

Do not assume a flat WhatsApp conversation price. Calculate using current Meta India pricing by category/message type, including utility, authentication, marketing, service, retries and SMS fallback.

Storage example: 100 devices × 10 metrics × 288 samples/day at 5-minute intervals = 288,000 samples/day before indexes and metadata. Benchmark against actual fleet size.

## Reliability and disaster recovery

Minimum: automated daily DB backup, WAL archiving/frequent incremental backup where feasible, object storage versioning, off-site copy in separate provider/account, monthly restore test, backup failure alert and documented recovery.

Initial targets for client approval:
- RPO: 24 hours for MVP.
- RTO: 8 hours for MVP.

These are targets, not guarantees.

## SLA proposal

Suggested internal targets, subject to GreenGrid approval:
- Critical safety/system-wide issue: immediate acknowledgement and on-call escalation.
- High: response within 2 business hours.
- Normal: response within 1 business day.
- Low: response within 2 business days.

These are internal targets, not statutory response times. Store business calendar, pause conditions, first response and resolution targets separately.

## Risks and mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Wrong regulatory interpretation | Incorrect quote/non-compliance | Versioned rules and professional sign-off |
| No government API | Manual work | Status mirror and evidence checklist |
| Meter shortage | Delayed commissioning/CFA | Pending dashboard and proactive updates |
| OEM API unavailable | No telemetry | Local gateway/manual fallback |
| Model-specific registers | Incorrect readings | Tested, versioned adapters |
| WhatsApp failure | Missed notifications | Outbox and email/push/SMS fallback |
| OpenWA risk | Account loss/data exposure | No critical production dependency |
| Weak authorization | Data exposure | Server-side scope filters and tests |
| Offline conflicts | Lost field data | Local queue, versioning and conflict handling |
| VPS outage | Full outage | Off-site backup and recovery plan |
| Poor data quality | False alerts/reports | Validation and quality flags |
| Scope creep | Delayed release | MoSCoW and change control |

## Client discovery questions

### Company and staff
1. How many people work in the company?
2. Who reports to whom?
3. What teams/groups exist today?
4. Can one person belong to multiple groups?
5. Who can view all customers/projects?
6. Are there multiple offices/branches?

### Workflow
7. How does a new enquiry arrive?
8. Who contacts the customer first?
9. Who performs the survey?
10. Who prepares and approves quotations?
11. Who handles KSEB/E-Kiran applications?
12. Who coordinates inspection and meter installation?
13. Who confirms installation and commissioning?
14. Which tools are used today: Excel, WhatsApp, paper, CRM or accounting software?

### Products and devices
15. Which exact brands/models of modules, inverters and batteries are installed?
16. Which dataloggers and monitoring apps are used?
17. Which system types are common: on-grid, off-grid, hybrid, water heater?
18. How many installations are completed monthly?
19. Is stock tracked by serial number?
20. Who handles manufacturer warranty claims?

### Service and customers
21. How many service cases arrive monthly?
22. What are the most common faults?
23. Are AMC plans sold?
24. How often do technicians visit?
25. Do technicians need offline access?
26. Is after-hours emergency support required?
27. Should customers use app, website or both?
28. Should the app support Malayalam, English or both?
29. Is there an official WhatsApp Business account and recorded opt-in?
30. Should customers pay online or only view payment status?

### Management
31. Which reports does the owner check daily?
32. Are sales conversion and staff performance reports needed?
33. Is project profitability/outstanding payment reporting needed?
34. What response and resolution times should staff meet?

## Final recommendation

Build around the controllable operational journey:

**Lead → Survey → Quote → Project → Installation → Utility follow-up → Commissioning → Handover → Service.**

Prioritise group access/audit, CRM/projects, separate KSEB/subsidy milestones, document vault, cases/SLA/field work, consent-aware messaging and customer tracking. Integrate the one or two most common inverter models only after GreenGrid provides device inventory and API permissions.

**Feasibility verdict: proceed to client discovery and MVP design.** Do not lock regulatory calculations, GST logic, inverter compatibility or messaging costs until verification owners sign off.