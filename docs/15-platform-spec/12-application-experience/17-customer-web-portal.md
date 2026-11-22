# Customer Web Portal — Complete Page, Navigation & Responsive Specification

**Document ID:** UX-CUST-WEB-001 · **Status:** Proposed

## 1. Purpose
Provide the same core customer services as the Android app in a browser. Both channels use the same identity, API, records, permissions and business rules. The web portal is not a separate customer database.

## 2. Responsive shell
Desktop: top header with brand, account switcher, notification centre and profile; left navigation for Overview, Properties, Enquiries, Projects, Quotations, Documents, Payments, Solar Plants, Service and Help. Tablet collapses navigation. Mobile uses compact menu and stacked content. Every page supports direct link with server-side authorization.

## 3. Page catalogue
**W01 Public landing/sign-in:** clear customer entry, privacy notice and help.
**W02 Authentication/recovery:** approved identity flow, MFA where required, safe error messages.
**W03 Invitation verification:** one-time token validation and account linking.
**W04 Overview:** next action, project status, outstanding response, service updates and plant summary.
**W05 Profile/contact preferences:** verified contacts, language and channel preferences.
**W06 Properties:** authorised site list and details.
**W07 Enquiries:** create, list, detail and follow-up visibility.
**W08 Survey schedule:** appointment details, request change and visit preparation.
**W09 Project workspace:** customer-facing timeline, milestone detail and approved files.
**W10 Quotations:** immutable version list, document preview/download, accept/reject/request revision and response history.
**W11 Documents:** searchable categories, secure downloads and expiry handling.
**W12 Payments/receipts:** payment instructions, milestones, confirmed receipt history and clarification route.
**W13 Plant list/detail:** equipment summary, performance and freshness.
**W14 Performance charts:** metric/unit/period definitions, accessible table alternative and no-data state.
**W15 Alerts:** safe customer explanations and recommended actions.
**W16 Service:** create request, duplicate suggestion, case detail, visit schedule and feedback.
**W17 Notifications:** inbox, read/unread and preferences.
**W18 Help:** support contacts, FAQs and escalation path.
**W19 Privacy/account:** consent, data requests, linked contacts and closure request.

## 4. Shared page behaviour
Every list includes loading, empty, error, filter, sort and pagination states. Every form has field-level errors plus summary, preserved input after recoverable failure, confirmation before irreversible action and server validation. Browser back/forward must not resubmit mutations. Downloads use short-lived authorized URLs.

## 5. Responsive and accessibility requirements
Keyboard navigation, visible focus, semantic headings, labels, table headers, contrast, zoom/reflow, accessible chart summaries, reduced-motion support and form errors announced to assistive technology. Do not rely on colour alone for status. Test phone, tablet and desktop widths.

## 6. Security
HttpOnly/Secure/SameSite session strategy where applicable, CSRF protections for cookie-based mutation, content security policy, safe external links, output encoding, rate limiting and server-side record scope. No customer secrets in URLs, analytics events or client logs.

## 7. Data and API
Uses same customer APIs and record identifiers as Android. Mutations are idempotent where retry is possible. Web and mobile must show consistent state after refresh. Customer responses are tied to exact quotation version and logged.

## 8. Acceptance tests
- [ ] Responsive navigation works at supported widths.
- [ ] Mobile and web display same authorised record state.
- [ ] Direct deep links enforce access.
- [ ] Form errors preserve valid user input.
- [ ] Browser refresh does not duplicate submissions.
- [ ] Accessible table alternative exists for charts.
- [ ] Downloads expire and require authorization.
- [ ] Internal staff-only fields never appear in API response.
