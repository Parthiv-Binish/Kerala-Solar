# GreenGrid Solar — UI/UX Design System & Interaction Standards

**Document ID:** UX-DS-001  
**Document type:** Cross-application design system and product interaction standard  
**Status:** Proposed baseline — stakeholder review required  
**Applies to:** Staff Portal, Platform Administration, Technician Android App, Customer Android App, Customer Web Portal and notification templates  
**Version:** 1.0-draft

[← Application suite and screen inventory](00-application-suite-and-screen-inventory.md) · [← Project book](../../../INDEX.md)

## 1. Purpose and design principles

This document defines how every GreenGrid Solar screen should look, behave and communicate. It is the shared standard for product design, frontend development, QA and future design-system maintenance.

1. Clarity before decoration; users must understand the current state and next action.
2. Task-first layouts; show relevant information, not every available data point.
3. Consistent labels, status meanings, actions and navigation across products.
4. Responsive layouts designed for each form factor, not merely shrunk.
5. Accessible controls, readable contrast, keyboard and screen-reader support.
6. Honest feedback; distinguish saved, submitted, queued, delivered, failed, stale, estimated and verified.
7. Field-friendly technician workflows with large controls and visible connectivity.
8. Plain language for customers; avoid internal codes and unexplained technical terms.
9. No success message until the server confirms the relevant action.
10. Visual hiding never replaces backend authorization.

## 2. Visual identity and design direction

The product should feel like dependable energy-management software: modern, calm, clean, practical and trustworthy. Use warm neutral surfaces, deep evergreen for primary actions, restrained solar amber for highlights, and semantic colours for information and status. Avoid neon effects, excessive gradients, decorative glass panels, heavy shadows, excessive animation and generic dashboard clutter.

### 2.1 Colour palette

Proposed tokens; validate pairings with contrast testing before release.

| Token | Hex | Purpose |
|---|---|---|
| brand-900 | #123B2A | Deep brand, selected navigation |
| brand-800 | #18543A | Hover and strong brand emphasis |
| brand-700 | #216B49 | Primary buttons and links |
| brand-100 | #E5F2EA | Soft brand background |
| brand-50 | #F3F8F4 | Subtle positive/selected surface |
| solar-600 | #C78316 | Energy accent and highlights |
| solar-100 | #FFF1D6 | Soft amber surface |
| ink-900 | #17231D | Main text |
| ink-700 | #3F4D45 | Secondary text |
| ink-500 | #68766E | Muted metadata |
| surface-0 | #FFFFFF | Cards and form surfaces |
| surface-50 | #F7F9F7 | Main page background |
| surface-100 | #EEF2EF | Subtle panels |
| border-200 | #DCE4DE | Default borders |
| border-300 | #C7D2CA | Strong borders |
| info-700 | #245E9B | Informational status |
| info-50 | #EAF3FC | Informational background |
| success-700 | #237447 | Success/verified status |
| success-50 | #EAF6EE | Success background |
| warning-700 | #94600B | Warning status |
| warning-50 | #FFF5DF | Warning background |
| danger-700 | #B42318 | Error/destructive/critical status |
| danger-50 | #FDEDEC | Error background |
| neutral-700 | #526057 | Neutral/inactive status |
| neutral-100 | #EEF1EF | Neutral background |

Colour rules:
- White text on brand-700 is the proposed primary-button pairing; verify WCAG contrast.
- Never communicate status by colour alone. Include text and, where useful, an icon.
- Do not use amber for small body text on white. Use it for accents or dark text on pale amber.
- Red means error, destructive action or genuinely critical condition; not ordinary pending work.
- Charts need labels, units, legends and a colour-blind-safe palette.
- Use semantic tokens, not arbitrary per-screen hex values.
- Dark mode is not part of the initial baseline. If introduced, design a complete tested palette rather than inverting colours.

## 3. Typography

### 3.1 Font family
- Primary: Inter, subject to licensing and reliable delivery.
- Fallback: system-ui, -apple-system, Segoe UI, Roboto, sans-serif.
- Android may use its native system font if bundling Inter harms performance or licensing.
- Do not use decorative display fonts in operational software.
- Use tabular numerals for money, energy, capacity, dates and metrics where available.

### 3.2 Type scale

| Token | Size | Line height | Weight | Use |
|---|---:|---:|---:|---|
| display | 32 px | 40 px | 700 | Rare customer headline |
| h1 | 28 px | 36 px | 700 | Page title |
| h2 | 22 px | 30 px | 600 | Main section |
| h3 | 18 px | 26 px | 600 | Card/section title |
| h4 | 16 px | 24 px | 600 | Subsection |
| body-lg | 16 px | 24 px | 400 | Prominent body |
| body | 14 px | 21 px | 400 | Default interface text |
| body-sm | 13 px | 19 px | 400 | Supporting text |
| label | 12 px | 16 px | 600 | Field labels/table headings |
| caption | 11 px | 16 px | 400 | Non-critical metadata only |

Use sentence case. Body text should normally be at least 14 px. Do not use caption text for instructions, consent, validation or critical information. Keep a logical heading hierarchy and use boldness sparingly.

## 4. Spacing, dimensions and responsive layout

### 4.1 Spacing scale

Use a 4 px base scale: 4, 8, 12, 16, 20, 24, 32, 40, 48 and 64 px. Use shared tokens rather than arbitrary margins. Default card padding: 20–24 px desktop and 16 px mobile.

### 4.2 Breakpoints

| Range | Layout |
|---|---|
| 320–359 px | Small mobile; single column |
| 360–599 px | Mobile; single column |
| 600–767 px | Large mobile; limited two-column short fields |
| 768–1023 px | Tablet; compact sidebar or drawer |
| 1024–1439 px | Desktop; full workspace navigation |
| 1440 px+ | Wide desktop; constrain content width |

Breakpoints respond to available width, not device labels.

### 4.3 Page geometry
- Staff desktop sidebar: 240–264 px expanded, approximately 72 px collapsed.
- Desktop top bar: approximately 64 px.
- Desktop content padding: 24–32 px; mobile: 16 px.
- Main content max width: approximately 1200–1440 px for operational views; narrower for forms and reading.
- Keep the primary page action near the title or in a clearly defined sticky action area.
- Avoid nested scrolling unless needed for a table or side panel.
- Respect mobile safe-area insets.

## 5. Navigation rules

### 5.1 Staff Portal desktop

Persistent left sidebar, with brand at top, grouped navigation, clear active state, and account controls at bottom. Recommended groups:

1. Workspace: Overview, My Work, Calendar.
2. Sales: Enquiries, Customers, Surveys, Designs & Quotations.
3. Delivery: Projects, Tasks, Utility & Subsidy, Procurement, Inventory, Installation.
4. After-sales: Solar Plants, Monitoring, Service Cases, Work Orders, Warranty.
5. Business: Finance, Documents, Reports.
6. Administration: People & Access, Settings, Platform Administration (authorised users only).

Do not show every route as a flat menu. Do not show inaccessible modules as dead ends.

### 5.2 Staff tablet/mobile
Use a compact drawer with a visible current-page title. Do not squeeze the desktop sidebar onto a phone. Keep primary actions near the current task.

### 5.3 Technician Android
Bottom navigation, maximum five primary destinations:
- Today
- Jobs
- Calendar
- Updates
- Profile

A job opens a focused workflow with progress, customer/site details, checklist, evidence and a clear submit action. Technicians should not navigate office-only modules.

### 5.4 Customer app and web
Primary destinations:
- Home
- My Solar
- Projects
- Support
- Account

Documents, payments and notifications may be contextual sections. Use the same labels on Android and web. Show the latest verified update and the next expected action.

### 5.5 Shared navigation behaviour
- Preserve filters and list position when returning from detail.
- Use breadcrumbs for deep desktop workflows, never as the only back control.
- Deep links must verify access before rendering record data.
- Browser back must not silently resubmit forms.
- Warn before leaving with unsaved changes.
- No hover-only essential actions or navigation.

## 6. Buttons and action hierarchy

| Variant | Use |
|---|---|
| Primary solid brand | One main action per decision area: Save, Assign, Submit |
| Secondary bordered | Supporting action: Preview, Export |
| Tertiary/ghost | Low-emphasis action: Cancel, View details |
| Destructive | Delete, revoke, reverse, irreversible cancellation |
| Icon-only | Compact toolbar action with tooltip and accessible name |

Use specific verbs, not vague “Proceed” or “OK”. Buttons need hover, focus, pressed, disabled and loading states. Explain why an action is disabled. Prevent double submissions; use backend idempotency for consequential operations. Destructive actions require a confirmation naming the record and consequence. Prefer reversible archive/deactivate actions where policy allows.

## 7. Forms and validation

- Put visible labels above fields; placeholders are examples, not labels.
- Use one column by default; two columns only for short related fields on wide screens.
- Full width for address, notes and long text.
- Mark required fields; explain optional fields where unclear.
- Show units beside numeric values (kW, kWh, ₹, %, V, A).
- Use searchable selectors for long lists.
- Validate on blur and submit, not aggressively before entry.
- Put errors directly below fields and preserve valid input.
- Long forms need an error summary linked to invalid fields.
- Explain how to fix an error, not just “Invalid input”.
- Client validation improves usability; server validation is authoritative.
- Warn before losing drafts. Autosave only where safe.
- High-risk forms (receipts, approvals, quotation acceptance, project conversion, stock issue, commissioning, access changes and service closure) must show the affected record, key values, consequences and final server-confirmed result. Audit consequential actions.

## 8. Tables, lists, cards and dashboards

### Tables
Use tables for comparison and operational scanning. Default row height 48–56 px. Left-align text; right-align money and numeric values; align dates consistently. Keep key identity columns visible. Include sorting, filters, pagination and empty states where useful. Do not expose every database field. On mobile, transform wide tables into prioritised cards or lists rather than shrinking many columns.

### Cards
Cards group related information; they are not decoration. Use clear title, content and optional action. Avoid nested cards, excessive shadows and inconsistent padding.

### Dashboards
Prioritise actionable exceptions, work due and decisions over vanity metrics. Each metric needs definition, period, unit, source and last-updated time where relevant. Distinguish live, delayed, stale and unavailable data. Link metrics to underlying records. Missing data must never be displayed as zero.

## 9. Dialogs, popups, drawers and overlays

### 9.1 Choose the right pattern

| Pattern | Use |
|---|---|
| Tooltip | Short explanation for a labelled control |
| Popover | Small contextual menu or compact filter |
| Modal | Focused confirmation or short self-contained task |
| Side drawer | Inspect/edit a related record while retaining list context |
| Bottom sheet | Mobile contextual action or short selection |
| Toast/snackbar | Brief non-blocking feedback |
| Banner | Persistent page-level warning or outage |
| Full page | Complex form or multi-step workflow |

Do not use a modal for a long, complex workflow.

### 9.2 Dimensions and placement
- Small desktop dialog: 400–480 px wide.
- Standard: 520–640 px.
- Wide: 720–880 px only when genuinely needed.
- Maximum height: 80–85% of viewport; content scrolls while title and action footer remain visible.
- Centre desktop dialogs. On mobile use near-full width with 16 px side margins or a full-screen page for complex work.
- Bottom sheets respect safe areas and keep actions above gesture navigation.
- Never stack multiple modals.
- Move focus into an opened dialog, trap focus while open, and return focus to the trigger on close.
- Escape/outside click may close lightweight overlays; protect unsaved or consequential work.
- Popovers sit near their trigger (8 px nominal gap), align to its edge, and flip/shift to remain visible. Never cover the trigger.
- Menus open toward available space. On mobile use a bottom sheet or safe anchored menu.
- Essential actions must not depend on hover.
- Define a shared layer order: page, sticky elements, popovers/menus, drawer, modal backdrop, modal, critical system overlay. Avoid arbitrary z-index values.

## 10. Notifications and in-product messaging

Notifications are a product capability, not decoration. Keep notification meaning consistent across staff web, technician app, customer app, email, SMS and WhatsApp.

### 10.1 Categories

| Category | Example | Treatment |
|---|---|---|
| Critical | Confirmed critical plant or security event | Persistent critical item, danger treatment, owner/escalation |
| Action required | Survey assigned, approval pending | Prominent task item with owner and due date |
| Warning | Device stale/offline threshold, deadline approaching | Warning treatment and recommended next step |
| Information | Milestone updated, document available | Non-blocking information |
| Success | Receipt verified, survey submitted | Confirm exact completed action |
| Reminder | Appointment or follow-up due | Neutral reminder |

A monitoring alert is a domain event with its own lifecycle. A notification is a message about an event or task. Do not confuse them.

### 10.2 Notification centre
- Provide a notification inbox/bell with unread count and accessible label.
- Group by Today, Yesterday and Earlier.
- Show title, plain-language summary, event time and related context.
- Support mark read, mark all read and open related record when authorised.
- Keep action-required work in task/work queues too; inbox messages are not a task-management system.
- Deep links re-check permissions. If access has changed, show a safe explanation without leaking record details.
- Do not hide critical information behind read/unread state.

### 10.3 Toasts, banners and inline feedback
- Non-critical success toast: approximately 3–5 seconds.
- Critical errors must not auto-dismiss; use inline error or persistent banner with safe retry.
- Warning banners remain until resolved or acknowledged where appropriate.
- Put field errors beside fields and record status beside the record.
- Avoid stacking toasts; group repeated updates and rate-limit noisy events.

### 10.4 Notification template contract

Every template defines:
1. Event and trigger.
2. Eligible recipient and recipient scope.
3. Priority/severity.
4. Channels and user preferences/fallback.
5. Short title and plain-language body.
6. Entity reference and safe deep link.
7. Event time and expiry, if applicable.
8. Required action and due date.
9. Deduplication key and suppression rules.
10. Retry/delivery policy and delivery status.
11. Template version, language and audit metadata.

Message structure: **What happened → what it means → what the recipient can do → when it matters.**

Example: “Technician visit scheduled — Your site visit is scheduled for 24 November at 10:00 AM. Open the appointment to view details or contact GreenGrid if this time does not work.”

Never expose internal notes, private contact data, sensitive financial details or another customer's information in push previews, SMS or WhatsApp. Sensitive details belong behind authenticated screens.

### 10.5 Delivery reliability
- Use a transactionally reliable event-to-notification mechanism, such as an outbox.
- Distinguish queued, sent, delivered, failed and read only where the provider supports those states.
- Provider acceptance is not proof that a person read a message.
- Retry transient failures with bounded backoff; do not retry permanent failures forever.
- Use deduplication keys.
- Respect consent, opt-out, quiet hours and channel policy; verify applicable legal/provider rules.
- Do not promise WhatsApp delivery until provider, templates, opt-in and account configuration are confirmed.
- A notification failure must not roll back an already committed business action; report delivery failure separately.

## 11. Status labels and domain language

Use controlled domain vocabularies. Illustrative examples:
- Enquiry: New, Contacting, Survey to arrange, Quotation sent, Won, Lost.
- Project: Planned, In progress, On hold, Completed, Cancelled.
- Receipt: Recorded, Verification required, Verified, Allocated, Reversed, Refunded.
- Monitoring: Online, Delayed, Stale, Offline, Unavailable.
- Service case: New, Triaged, Assigned, Visit scheduled, In progress, Waiting, Resolved, Closed.

The approved domain state machine remains authoritative; do not invent per-screen statuses. Pair labels with text and optional icon/semantic colour. Distinguish not started, blocked, unknown and failed. Show timestamps and source/verification state for external statuses. A UI label must reflect server state, not an optimistic assumption after a failed request.

## 12. Icons, imagery and motion

Use one consistent line-icon family. Icons need labels or accessible names when meaning is not universal. Do not use emoji as interface icons. Use photographs only when they identify a site, equipment or real task. Use contextual skeletons for loading; do not shimmer indefinitely. Motion should clarify feedback, usually 120–200 ms, and respect reduced-motion preferences. No looping decorative animation in operational screens.

## 13. Accessibility and inclusive design

Target WCAG 2.2 AA for web and equivalent Android accessibility practices:
- Normal text contrast at least 4.5:1; large text at least 3:1.
- Meaningful controls, focus indicators and graphics at least 3:1 against adjacent colours.
- Full keyboard operation and visible focus on web.
- Aim for 44 × 44 CSS px web targets and 48 × 48 dp Android primary touch targets.
- Associate labels and instructions programmatically with fields.
- Announce errors to assistive technology and describe them in text.
- Provide alt text for meaningful images; hide decorative images from assistive technology.
- Never rely on colour alone.
- Support text resizing and Android font scaling without clipping.
- Charts need a text/table alternative for key values.
- Test keyboard, screen reader, zoom, high contrast and reduced motion.

## 14. Loading, empty, error, offline and success states

Every screen/component defines applicable states:

| State | Required behaviour |
|---|---|
| Loading | Contextual skeleton/progress; no blank screen |
| Empty | Explain why no data and the next valid action |
| No results | Preserve filters and offer clear-filter |
| Permission denied | Explain access unavailable without revealing protected details |
| Validation error | Preserve input and show actionable field errors |
| Network failure | Explain whether data was saved; offer safe retry |
| Stale data | Show last-updated time and warn that values may be outdated |
| Offline | Show connection state and which actions are unavailable/queued |
| Partial failure | Identify what succeeded and what failed |
| Success | Confirm server-accepted action and next step |
| Session expired | Preserve safe draft where possible and guide re-authentication |

Technician MVP is online-first. Full durable offline job packs and conflict resolution remain Phase 2 unless formally approved otherwise. Never imply an offline submission reached the server.

## 15. Domain-specific data presentation

- Money: use ₹ and Indian digit grouping. Label estimates, due, received, verified, allocated and refunded distinctly.
- Energy: distinguish kW (power) from kWh (energy); show period and timezone.
- Capacity: use kW/kWp correctly; do not mix AC and DC capacity.
- Dates: use a consistent Indian-friendly form, e.g. 24 Nov 2026; show timezone when needed.
- Monitoring: missing telemetry is unknown, not zero; show freshness and source.
- Government/subsidy: distinguish estimate, submitted, acknowledged, sanctioned and credited. External portals remain authoritative unless integration is verified.
- Finance: receipt recorded is not the same as receipt verified.
- Documents: show type, name, upload date, owner/context and access permission; do not expose public storage URLs.
- Customer addresses and private details must not appear in public notification previews.

## 16. Search, filters and bulk actions

Global search must return only entities the user is authorised to discover. Label result type and useful context to avoid wrong customer/site/project selection. Show active filter chips and clear-all. Preserve safe filters in web URLs. Do not silently hide records due to stale filters. Bulk actions show selected count, eligibility and confirmation; report partial success/failure per record.

## 17. Security and privacy in the interface

Hide sensitive values unless needed; provide deliberate reveal controls. Never expose passwords, tokens or secrets in UI or notifications. Re-authenticate for sensitive actions where policy requires. Warn before sharing/downloading customer documents. Use neutral access-denied messages that do not reveal whether a protected record exists. Revoked permissions must be handled safely. Do not store sensitive drafts in insecure browser or mobile storage.

## 18. Shared design-system components

Build shared tokens and reusable components for:
- App shell, sidebar, top bar, mobile navigation, breadcrumbs.
- Page/section headers, tabs and segmented navigation.
- Button variants, icon button, link and action menu.
- Text/number inputs, textarea, select/searchable select, date/time picker, checkbox, radio and switch.
- Form field wrapper, helper text, validation and error summary.
- Status badge, alert banner, toast, notification item and notification centre.
- Card, metric card, data table, mobile record card, pagination and filter bar.
- Modal, popover, drawer, bottom sheet and confirmation dialog.
- Skeleton, spinner, empty/error states, offline and freshness indicators.
- File uploader/viewer, timeline, stepper and audit history.
- Chart wrappers with units, legend and accessible summary.

Tokens define colour, typography, spacing, radius, border, shadow, breakpoints, motion and overlay layers. Components document variants and states. Avoid duplicate components. Keep business logic out of presentational components. Version the shared tokens and component library.

## 19. Content and language

Use plain English and familiar business language. Explain terms such as DISCOM, inverter and kWp to customers. Use active voice and sentence case. Button labels start with verbs. Error copy explains what happened, what was saved and what to do. Avoid blaming users. Make English and Malayalam localisation possible; notification translations require review and must not be improvised at send time.

## 20. UX performance expectations

Proposed targets for validation:
- Common local interactions should respond visibly within 200 ms where practical.
- Operations longer than one second show progress or pending state.
- Background refreshes must not block the whole app.
- Optimise site photos and avoid full-resolution images in lists.
- Paginate/virtualise large tables and activity feeds.
- Upload retries should not force users to restart a workflow.
- Test on low/mid-range Android devices and typical mobile networks.

## 21. Screen design handoff requirements

Before implementation, each screen design/spec must include:
1. Screen ID, product, persona and permission.
2. Desktop/tablet/mobile layout as applicable.
3. Navigation entry, exit and deep-link behaviour.
4. Primary, secondary and destructive actions.
5. Fields, labels, formats, units, defaults and validation.
6. Loading, empty, error, offline, stale, success and denied states.
7. Dialog/drawer/popover dimensions and dismissal rules.
8. Notification events and message templates triggered.
9. Accessibility, keyboard and screen-reader behaviour.
10. Responsive behaviour and touch-target checks.
11. Data/API dependencies and server-confirmed transitions.
12. Acceptance criteria and test cases.

### Design review checklist
- [ ] Purpose and next action are clear.
- [ ] Navigation and status vocabulary match the standard.
- [ ] Mobile, tablet and desktop layouts work.
- [ ] Contrast and typography pass accessibility checks.
- [ ] Tokens are used consistently.
- [ ] Buttons have all interaction states.
- [ ] Forms have labels, units and actionable validation.
- [ ] Dialogs/popovers follow focus and placement rules.
- [ ] Empty/loading/error/offline/stale/success states exist.
- [ ] Notifications are actionable, private and deduplicated.
- [ ] Missing data is not displayed as zero.
- [ ] Sensitive actions have permission checks, confirmation and audit.
- [ ] Keyboard, screen-reader, zoom and touch are tested.
- [ ] Representative staff, technicians and customers review the design.

## 22. Governance

This is a proposed default, not a claim that the palette, font, dimensions, accessibility conformance or notification providers are approved or implemented. Changes to shared tokens, navigation, status colours, notification priority, overlay behaviour or accessibility rules require a documented reason, impact review, product-owner approval, versioned update and regression testing.

Do not mark a screen design-complete until its screen specification, responsive states, accessibility and notification behaviour have been reviewed. Do not claim WCAG conformance until tested.

## Appendix A — Quick reference

| Element | Proposed default |
|---|---|
| Desktop sidebar | 240–264 px expanded; ~72 px collapsed |
| Desktop top bar | ~64 px |
| Desktop page padding | 24–32 px |
| Mobile page padding | 16 px |
| Web button height | 40–44 px |
| Android primary control | 48 dp |
| Web input height | 44–48 px |
| Table row | 48–56 px |
| Card padding | 20–24 px desktop; 16 px mobile |
| Popover gap | ~8 px |
| Standard modal | 520–640 px wide |
| Modal max height | 80–85% viewport |
| Success toast | 3–5 seconds |
| Base spacing | 4 px |
| Body text | 14–16 px |
| Page title | 28 px |
| Touch target | 44 × 44 CSS px web; 48 × 48 dp Android |
