# Customer Android App — Complete Screen & Journey Specification

**Document ID:** UX-CUST-ANDROID-001 · **Status:** Proposed

## 1. Purpose
A simple self-service app for customers to follow enquiries, projects, quotations, solar plants, documents, payments and service. It must be useful to non-technical users and must never expose internal business notes or another customer's records.

## 2. Identity and household access
A customer account may have approved contacts. Account invitation and verification bind a user identity to customer/site access. Do not infer access from phone number alone. Shared household access requires explicit authorisation, revocation and audit. Customer identity is distinct from the customer business record.

## 3. Navigation
Bottom tabs: Home, My Solar, Service, Notifications, Profile. My Solar contains Properties, Projects, Quotations, Documents and Payments. Navigation is permission- and relationship-aware.

## 4. Screen catalogue
**C01 Welcome:** explain benefits, supported language and sign-in.
**C02 Sign in:** approved authentication, OTP/MFA policy, recovery and privacy links.
**C03 Verify Invitation:** validate one-time invitation token server-side; expired/revoked link gives safe recovery.
**C04 Home:** next appointment, project status, active service requests, plant summary and latest notifications. Empty states guide next step.
**C05 Profile:** name/contact, language, notification preferences, linked customer account and privacy options.
**C06 Properties:** list authorised sites with locality and plant/project count.
**C07 Property Detail:** address, site contact, linked projects/plants and authorised documents.
**C08 Enquiry:** submit interest, contact preference, site location/PIN, requirement and consent. Duplicate detection returns existing request safely without exposing another user's data.
**C09 Enquiry Detail:** status, assigned follow-up channel where permitted, next expected action and message history safe for customer.
**C10 Survey Appointment:** proposed/confirmed appointment, date window, reschedule request and visit instructions. Customer request is not confirmed until staff confirms.
**C11 Project Timeline:** customer-visible milestones, dates, status and approved update. No internal task notes or supplier delays beyond approved summary.
**C12 Quotation List/Detail:** issued immutable version, amount, validity, PDF, included scope, exclusions and terms. Accept/reject/request revision only if enabled.
**C13 Documents:** category, date, version and secure download. Expired links can be renewed after authorization.
**C14 Payments:** instructions, due milestones, confirmed receipts and allocation. Never show a payment as received solely from a screenshot or submitted claim.
**C15 My Solar/Plant List:** plants associated with authorised sites.
**C16 Plant Detail:** system details, equipment summary, data freshness, performance chart and service history.
**C17 Performance:** energy/power metric definitions, period, units, aggregation and missing-data state. No telemetry means “data unavailable”, not zero.
**C18 Alerts:** customer-safe explanation, timestamp and recommended next step. Avoid technical alarm codes unless useful.
**C19 Raise Service Request:** choose plant/site, category, description, urgency, contact availability, optional photo and consent. Show possible existing case before create.
**C20 Service Request Detail:** case reference, state, appointment, updates and customer actions.
**C21 Notifications:** inbox, read state and linked record.
**C22 Help/Contact:** approved contact methods and support hours.
**C23 Privacy & Account:** consent, data request, account closure request, linked contacts and session logout.

## 5. Customer-safe content rules
Never expose internal cost/margin, supplier quotations, staff-only comments, internal risk notes, private documents, employee personal contacts, access tokens or another customer/site. Customer-facing statuses are curated projections.

## 6. Notifications
Appointment confirmation/change, quotation issued/expiring, project milestone update, receipt confirmed, plant alert (only when customer notification policy says so), service case update and account security event. Consent, language and delivery preferences apply.

## 7. Data and processing
Reads: own identity links, permitted customer/site/project/quotation/receipt/plant/case/document and customer-safe telemetry. Writes: enquiry, appointment request, quotation response, service case/report, profile preference, consent and acknowledgement. Server validates ownership and exact version.

## 8. Accessibility and reliability
Plain-language explanations, large controls, screen-reader labels, accessible charts with text summaries, low bandwidth, retryable uploads, clear loading/empty/error states and localised dates/currency. Push notifications contain minimal sensitive information.

## 9. Acceptance tests
- [ ] User sees only explicitly linked customer/site records.
- [ ] Invitation cannot be reused after expiry/revocation.
- [ ] Quote response identifies exact version.
- [ ] Receipt is shown only after staff/system confirmation.
- [ ] Missing telemetry is not shown as zero.
- [ ] Service duplicate flow preserves user's report.
- [ ] Account closure request does not bypass retention/legal hold.
- [ ] Push previews do not disclose sensitive details.
