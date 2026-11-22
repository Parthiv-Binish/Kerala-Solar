# ADR-0004: Web Frontend Workspace and Safe Task Sequencing

- **Status:** PROPOSED — A0 architecture decision for A1 kickoff; A1 may raise a concrete implementation-level change before scaffold merge
- **Date:** 2026-11-22
- **Decision owner:** A0
- **Implementation owner:** A1
- **Reviewers:** A3 (API/auth boundary), A8 (quality/accessibility/security), A2 (shared design-token impact)

## Context
A1 issue #2 reports that the repository has no package.json/Vite workspace or application source tree and requests a definitive workspace and task sequence. The architecture documents select React + TypeScript + Vite but do not specify a concrete repository path. Backend OpenAPI and authorization contracts are not yet ready; DOC-001–DOC-003 remain critical.

## Decision

### Workspace
- Use a monorepo layout with **`apps/web/` as the single initial React + TypeScript + Vite web application**. A1 owns all files under `apps/web/**`.
- The initial web app contains two route areas: public website routes at `/` and protected staff workspace routes under `/staff/*`. Keep their layouts/navigation logically separated while sharing approved web UI primitives and design tokens.
- Customer Web Portal remains Phase 2 by default. Do not add customer portal routes, customer auth flows or duplicate identity context in this increment.
- Do not create a second public-site or staff-portal frontend deployment unless a later ADR establishes a need.
- A1 may propose a small `packages/ui` or shared-token package only when A2/A0 approve concrete cross-app reuse; avoid premature shared packages. A2 owns mobile app files and does not edit A1's `apps/web/**`.
- API types/client are generated or maintained against A3's reviewed OpenAPI. Until that exists, use a clearly isolated typed adapter/interface with no fabricated endpoints or production payloads.

### Task sequence and allowed scope
1. **AG-0005 — READY:** A1 may scaffold `apps/web`, configure React/Vite/TypeScript, apply the approved UI/UX tokens, implement responsive public page structure and static navigation/content shells. Use only approved factual content; no fabricated testimonials, customer counts, savings, certifications or live-service claims. No production API integration is required for this static shell.
2. **AG-0006 — READY FOR SHELL ONLY:** A1 may scaffold the staff portal frame, navigation placeholders and route layout. Authentication, session handling, route authorization, permission-aware navigation and protected data views are not enabled until A3 publishes reviewed API-001/API-002 and A8 reviews the security behavior. A visual shell is not a security boundary.
3. **AG-0017 — BACKLOG / BLOCKED ON CONTRACTS:** CRM, customer, survey and quotation screens with real data remain blocked until A3/A4 publish reviewed API/schema/authorization contracts and DOC-001–DOC-003 critical prerequisites are resolved or formally accepted by the business/security owner.

### Design and engineering standards
- The normative visual source is `docs/15-platform-spec/12-application-experience/24-ui-ux-design-system-and-interaction-standards.md`; A1 must record the exact token set and component references in its PR.
- Follow the screen/action implementation spec and include responsive, keyboard, contrast, focus and loading/empty/error visual states where applicable.
- Route library and CSS/build tooling details not specified in product docs are A1 implementation proposals. A1 documents the choice in its PR and avoids introducing heavy dependencies without rationale.
- The web app never connects directly to PostgreSQL, Redis or object storage; no provider credentials in browser bundles.
- No endpoint, permission key, data field or business rule is inferred from a screen label.

## Branch and file ownership
- A1 branch: `agent/A1/AG-0005-public-web-shell` (or task-specific branch following this pattern).
- A1 owns `apps/web/**`; A0 owns Agent Hub/ADR files; A3 owns backend/OpenAPI; A4 owns database; A8 owns QA/security evidence. Shared CI/root workspace files require A0/A9 coordination before edit.
- Separate PRs per task or tightly coupled shell increment; use task ID in branch, PR title and commits.
- No concurrent agent edits to the same file. If a root package/workspace file is required, A1 proposes it and A0/A9 agree one file owner.

## Handoff contract to A1
A1 may proceed with AG-0005 and shell-only AG-0006 after acknowledging this ADR. PR must include workspace layout, route map, token provenance, dependencies, run/build commands, tests (unit/component/accessibility/responsive where practical), screenshots or review evidence, and an explicit list of features intentionally not wired pending API/auth contracts.

## Consequences and blockers
This unblocks non-integrated web shell work only. It does not unblock protected business workflows, customer portal, authentication implementation, CRM screens or API integration. DOC-001, DOC-002, DOC-003, DOC-007 and DOC-009 remain tracked prerequisites for affected feature work.

## Reconsideration
Revisit if the repository gains independently deployed customer web, shared packages become necessary for A2, a separate marketing-site deployment is required, or deployment/security constraints justify multiple web applications.
