# UI Component Contract

**Owner:** A1 for web design system; A2 for native mobile adaptations; A0 coordinates shared semantics; A8 reviews accessibility.

- Source of truth: UI/UX design system document in platform specification.
- Preserve semantic tokens and status vocabulary across products.
- Shared behaviour may be consistent while navigation and layouts remain audience-specific.
- Components must expose loading, empty, validation, disabled, forbidden, failure and recovery states as relevant.
- Forms validate on client for usability and on server for authority.
- Never show protected data before authorization is established.
- Toasts are for transient feedback; durable events belong in notification centre/activity history.
- Responsive layouts, keyboard/focus, screen reader labels and WCAG 2.2 AA target are required.

| Component/contract | Owner | Consumers | Status |
|---|---|---|---|
| Web tokens/components | A1 | Public site, staff portal | PROPOSED |
| Native mobile primitives | A2 | Technician/customer apps | PROPOSED |
| Status/notification vocabulary | A1/A2/A6 | All clients | PROPOSED |
| Form validation/error presentation | A1/A2 | All clients | PROPOSED |
