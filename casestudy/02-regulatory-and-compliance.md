# 02 — Kerala and National Regulatory Study

**Research snapshot:** 22 November 2026  
**Status:** Research baseline, not legal/tax/electrical engineering advice.

Recheck official notifications and procedures in force on the date of each application. Items marked **VERIFY** must not be hardcoded until reviewed by a qualified professional.

## PM Surya Ghar

PM Surya Ghar: Muft Bijli Yojana is a central residential rooftop PV CFA programme, not a universal subsidy for all commercial, industrial, standalone off-grid or solar-water-heater installations.

Indicative Kerala residential CFA:
| Eligible capacity | CFA |
|---:|---:|
| 1 kW | ₹30,000 |
| 2 kW | ₹60,000 |
| 3 kW and above | Maximum ₹78,000 |

The scheme period was stated through FY 2026–27, with 31 March 2027 appearing as the end date in a referenced MNRE memorandum. **VERIFY** extension/amendment before quoting a deadline.

Indicative process:
1. Consumer registers on National Portal.
2. Selects DISCOM and applies.
3. Feasibility assessed or deemed accepted where applicable.
4. Consumer selects registered vendor.
5. Vendor surveys, designs and installs.
6. Vendor uploads plant details, serials and photographs.
7. DISCOM inspection/commissioning.
8. Metering/connectivity agreement and meter.
9. Commissioning approval.
10. Consumer submits bank details/evidence.
11. CFA processing and credit.

MNRE guidance has specified processing within 15 days after DISCOM approval; this is not an end-to-end installation-to-subsidy guarantee. Commercial/industrial installations do not receive residential CFA simply because they are rooftop solar. Standalone off-grid and solar water heater installations are not covered by this grid-connected residential PV CFA component. Hybrid eligibility depends on configuration and scheme rules. **VERIFY each case.**

## Deemed feasibility

The Electricity (Rights of Consumers) Amendment Rules, 2024 introduced deemed acceptance for complete rooftop applications up to 10 kW without technical feasibility study and time-bound assessment for larger systems. MNRE guidance notes state/DISCOM implementation must be considered.

Software must store deemed-feasibility eligibility separately from official portal status. Never mark an application officially approved solely because capacity is 10 kW or less. Record actual status, evidence, date and staff member. **VERIFY KSEB's current operational implementation and later amendments.**

## KSEB Soura and E-Kiran

Soura is associated with KSEB's rooftop solar programme/facilitation. PM Surya Ghar is the central CFA scheme; do not describe Soura as a separate universal state subsidy without official evidence.

E-Kiran is KSEB's rooftop solar portal for relevant consumer/developer application and tracking. Public third-party API availability was not confirmed in this study.

Track portal/application reference, application date, feasibility, vendor selection, completion submission, inspection/report/defects, agreement, meter request/availability/installation, commissioning and CFA status. Keep the last official-status verification timestamp and evidence.

**Integration stance:** authorised manual entry, checklist, document vault, reminders and SLA tracking. Do not scrape, bypass CAPTCHA, share credentials or reverse-engineer authenticated portals. If an official API is offered, require written permission, documentation, credentials and a data-sharing agreement.

## Meter shortage

September 2026 media reports cited over 2,000 domestic installations stalled in Kannur and around 50,000 applicants reportedly waiting statewide for meters. These are reported figures, not live official KSEB inventory statistics. **VERIFY with KSEB before external use.**

Build a meter-pending dashboard with installation completion date, meter type/phase, application date, inspection/agreement state, meter availability/installation, follow-up owner/date, age buckets (0–7, 8–15, 16–30, 31–60, over 60 days), customer notifications and subsidy status.

## KSERC Renewable Energy and Related Matters Regulations, 2025

Use the final Gazette, not draft consultation material:
- Kerala Gazette Extraordinary No. 3944, 6 November 2025.
- Final PDF: https://dev.erckerala.org/api/storage/final-regulations/BDm5OZBLIuAbHoyTX0xoploDz82DbFy1O6klxxfS.pdf

The final regulations cover net metering, gross metering, net billing, group net metering, virtual net metering, behind-the-meter and other renewable arrangements.

Research reading of final-regulation capacity ranges:
| Category | Net-metering range |
|---|---:|
| Domestic | 1–20 kW, subject to connected load/conditions |
| Industrial | 1–500 kW, subject to conditions |
| Agriculture | 1–3,000 kW, subject to conditions |

These are not unconditional entitlements. Check connected load, voltage, phase, eligibility and procedure.

### Storage provisions — VERIFY exact clauses
Research reading indicates:
- Domestic above 10 kW and up to 15 kW: 10% storage.
- Domestic above 15 kW and up to 20 kW: 20% storage.
- Domestic above 5 kW and up to 10 kW seeking feasibility from 1 April 2027: hybrid inverter and at least 10% storage.
- Industrial systems have storage provisions for specified higher-capacity bands.
- Relevant calculation refers to a 19% capacity utilisation factor.

**VERIFY exact clauses, formula, rounding, category, application-date trigger and KSEB implementation before quotation automation.** Do not hardcode this summary as law.

Other items to verify: single-phase inverter capacity generally limited to 3 kW, with a transitional exception up to 5 kW where three-phase network infrastructure is unavailable through 31 March 2027; grid-support charges/exemptions; existing prosumer transition; group/virtual net-metering eligibility; virtual power plant, peer-to-peer and vehicle-to-grid pilots.

Do not use a draft's proposed 3 kW (or 5 kW with storage) cap as the final rule. Final Gazette prevails.

### Rule-engine design
Version rules by jurisdiction, consumer category, capacity band, valid-from/until, storage requirement, metering options, connected-load conditions, source clause, verification date and reviewer. Preserve the rule version used by each quote/project. Never silently recalculate an existing installation using new rules.

## ANERT, KSEB and Electrical Inspectorate

ANERT is Kerala's renewable-energy agency and may have programme/coordination roles. KSEB is the distribution utility for relevant grid connection and metering. Electrical Inspectorate has statutory safety/inspection responsibilities where applicable.

A Kerala Gazette amendment dated 10 July 2023 was reported to require solar generating units above 50 kWp to be inspected by the Electrical Inspector or appointed officer before commissioning. **VERIFY** exact current scope and amendments. Smaller systems still have applicable safety obligations.

Maintain licensed contractor details, SLDs/revisions, protection-device details, earthing/test records, inspection certificate where required, KSEB interconnection records and authorised signatory/date. Software stores evidence; it does not issue statutory certificates.

## ALMM, DCR and BIS

ALMM List-I concerns eligible module models/manufacturers; List-II concerns cell models/manufacturers. 2026 MNRE memoranda changed applicability for certain net-metering/open-access and residential cases. Research indicates List-I remained relevant while certain List-II exemptions were time-bounded and conditional.

PM Surya Ghar CFA installations have DCR conditions. ALMM and DCR are separate checks.

Procurement evidence should include module make/model/wattage, List-I status, cell/List-II status or exemption evidence, DCR status/reference, BIS certificate/standard where applicable, supplier invoice and applicable date.

**VERIFY** current MNRE lists, dates, exemptions, DCR and BIS requirements for each product/project.

## GST

CBIC rate schedule lists solar water heaters under HSN 8419 12 at 12%. Qualifying solar EPC composite-supply treatment may use a 70% goods / 30% services valuation rule under applicable notifications. Do not use one universal solar GST rate. Tax depends on actual goods/services, HSN/SAC, contract and current notifications. Require accountant/GST practitioner approval.

## DPDP Act and Rules

The DPDP Act, 2023 and Rules have phased commencement. The research snapshot indicates different commencement dates in November 2025, November 2026 and May 2027. Recheck Gazette commencement notifications and latest Rules; do not assume all obligations began simultaneously.

Build privacy controls now:
- Clear notices and purposes.
- Consent/lawful-use records where required.
- Data minimisation.
- Access/correction/grievance workflow.
- Retention/deletion schedule.
- Processor contracts.
- Secure storage and restricted access.
- Breach response.
- Children's data handling if applicable.

Aadhaar should not be a default lead field. Collect identity documents only where necessary and restrict access.

## CERT-In

CERT-In's 28 April 2022 directions include covered-entity requirements such as secure retention of ICT logs for 180 days within Indian jurisdiction, a point of contact and reporting specified incidents within six hours. Confirm applicability and incident categories with security/legal advisers.

## WhatsApp, SMS and TRAI/DLT

WhatsApp Business Platform requires opt-in and approved templates for business-initiated messages outside the applicable customer-service window. Keep separate consent categories for project updates, service/warranty, payment reminders and marketing. Recheck current Meta policy and pricing.

For SMS, India's TCCCPR/DLT framework requires relevant Principal Entity registration, headers, registered templates and consent compliance through an access provider.

OpenWA is unofficial WhatsApp Web automation and should not be production failover for critical communications. Session fragility, policy risk, account restrictions and data exposure are concerns. Prefer official WhatsApp, then email, push and compliant SMS.

## API availability conclusion

No public third-party API was confirmed for E-Kiran or PM Surya Ghar in this study. This does not prove no partner/internal integration exists. Use manual evidence-based tracking until an authorised integration is documented.

## Source register
- KSERC final regulation: https://dev.erckerala.org/api/storage/final-regulations/BDm5OZBLIuAbHoyTX0xoploDz82DbFy1O6klxxfS.pdf
- KSEB E-Kiran: https://ekiran.kseb.in/
- PM Surya Ghar: https://pmsuryaghar.gov.in/
- MNRE: https://mnre.gov.in/
- PIB: https://pib.gov.in/
- Ministry of Power: https://powermin.gov.in/
- CEA: https://cea.nic.in/
- ANERT: https://anert.gov.in/
- Kerala Electrical Inspectorate: https://dei.kerala.gov.in/
- CBIC: https://cbic-gst.gov.in/
- MeitY: https://www.meity.gov.in/
- TRAI: https://www.trai.gov.in/
- Operational reporting: https://keralakaumudi.com/ ; https://www.onmanorama.com/ ; https://mercomindia.com/ ; https://www.downtoearth.org.in/

## Sign-off checklist
- [ ] PM Surya Ghar period/CFA and vendor requirements.
- [ ] KSEB E-Kiran workflow and deemed-feasibility implementation.
- [ ] Final KSERC storage formula/effective dates and grandfathering.
- [ ] Meter availability and current utility timelines.
- [ ] Electrical Inspectorate requirements.
- [ ] ALMM/DCR/BIS applicability.
- [ ] GST classification and composite-supply treatment.
- [ ] DPDP commencement and launch obligations.
- [ ] CERT-In applicability and incident process.
- [ ] WhatsApp policy/pricing and TRAI DLT onboarding.