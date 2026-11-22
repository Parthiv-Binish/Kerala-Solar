# Screen & Experience Implementation Specification

**Covers:** APP-D01–APP-D08 · Draft for review

## Purpose
Convert the application-suite inventory into buildable screen contracts. This supplements the application books, SRS, security specification and data dictionary. A screen is not ready for implementation until its actor, route, data, permission, validation, state behaviour and tests are defined.

## Screen register
For every screen and every action record:
- Stable screen/action ID, application, title and specification version.
- Persona, required capability, resource scope and permitted relationships.
- Route/deep link, parent, entry points, back/exit behaviour and unsaved-change handling.
- User goal, primary/secondary/destructive actions and confirmation behaviour.
- Layout regions, responsive behaviour and shared components.
- Displayed field, source entity/property, formatting, null behaviour, visibility and freshness.
- Input field, API property, type, requiredness, default, options source, unit and limits.
- Client hint, authoritative server validation, error code and recovery.
- Read/write entities, transaction, idempotency, entity version and audit event.
- Loading, empty, partial, stale, offline, forbidden, not-found, conflict and failure states.
- Accessibility, localisation and acceptance tests.

## Form and validation catalogue
Supported field types: text, multiline, integer, decimal, money, date, date-time, enum, reference selector, address, PIN/post-office, phone, email, file, image, serial/barcode, checkbox and consent. Each field defines format, limits, unit, requiredness, source and help text. Use controlled references when appropriate, but preserve manual address entry if an external lookup fails.

Validation layers: client hints; server-side authoritative validation; database integrity constraints; workflow/state-transition validation; permission and resource-scope checks. Client validation is never a security boundary. Preserve user input after recoverable errors. Never silently truncate, coerce or overwrite.

## Shared screen states
Design loading, first-use empty, filtered-empty, partial data, stale data, forbidden, not found, offline, pending sync, validation failure, concurrent-edit conflict and server failure. Errors show a safe message and correlation reference where useful.

## Navigation and deep links
Maintain a route registry with route ID, application, path pattern, required capability, scope, query parameters, canonical destination and fallback. Deep links fetch data through authorized APIs. Hiding a menu item is not authorization. Back navigation must not resubmit mutations. Destructive actions name the affected record and consequence.

## Permission-to-screen matrix
Each screen has a view capability; each action has a separate command capability. Define record scope using canonical keys own, assigned, team, related, location or company; the exact predicate and permitted relationship path are defined by the authorization contract and field restrictions. Deny by default. Group membership alone does not grant access. Temporary overrides require reason, approver, expiry and audit.

## Notification matrix
For each event define source, recipient relationship, channel, purpose, consent, preference/quiet-hour rule, template version, language, sensitivity, idempotency key, expiry and retry. Provider acceptance is not delivery/read. Delivery failure does not roll back business state.

## Data display and accessibility
Show units, currency and time period. Distinguish estimated, observed, confirmed, submitted and approved data. Missing telemetry is unavailable, not zero. Customer projections exclude internal notes, supplier pricing and restricted identifiers. Use semantic labels, keyboard access, visible focus, sufficient contrast, accessible chart alternatives and non-colour status cues.

## Required registers and acceptance
Maintain a screen/action register, field catalogue, navigation registry, permission-screen matrix and notification-event matrix. Every screen/action must map to an API, capability, data source/destination and test. All common states and direct-link authorization must be tested.
