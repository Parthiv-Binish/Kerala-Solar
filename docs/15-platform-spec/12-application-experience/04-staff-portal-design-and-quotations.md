# Staff Portal — Solar Design, Bill of Materials & Quotation Management

**Document ID:** UX-STAFF-004  
**Application:** APP-01 Management and Staff Web Portal  
**Status:** Proposed — stakeholder validation required  
**Workflow:** Approved survey → technical design → component/BOM selection → cost build-up → internal review → quotation issue → customer response → revision/acceptance

[← Survey management](03-staff-portal-survey-management.md) · [← Application experience index](../00-application-suite-and-screen-inventory.md) · [← Project Book](../../../INDEX.md)

---

## 1. Purpose and boundaries

This module converts an approved survey and customer requirement into a documented technical proposal and commercial quotation.

It covers:
- Creating a design from an approved survey version.
- Recording system assumptions and sizing inputs.
- Selecting products/components from controlled product master data.
- Building and reviewing a bill of materials (BOM).
- Calculating item costs, selling prices, taxes and discounts using approved rules.
- Preparing, reviewing and issuing versioned quotations.
- Recording customer acceptance, rejection or requests for revision.
- Handing an accepted commercial version to project creation/conversion.

The platform may assist with calculations and consistency checks, but it must not represent an automated design as a certified engineering design. Final technical responsibility, electrical/structural checks, applicable standards, grid requirements and product compatibility must be reviewed by a qualified authorised person.

The platform must not hardcode product prices, tax rates, subsidy amounts, warranty claims, generation estimates or regulatory rules. These are controlled, dated data with sources and approval history.

## 2. Navigation

Staff Portal → Surveys & Design:
- Design Queue
- My Designs
- Designs Awaiting Review
- Returned Designs
- Approved Designs
- Design Templates (authorised configuration)

Staff Portal → Quotations:
- Quotation Overview
- Draft Quotations
- Awaiting Approval
- Ready to Send
- Sent Quotations
- Customer Responses
- Accepted
- Rejected / Expired
- Quotation Templates and Commercial Rules (authorised configuration)

Entry points:
- Approved Survey → Create Design
- Enquiry Details → Design/Quotation status
- Customer Profile → Quotations
- Project Workspace → Approved commercial basis
- My Work → assigned design/quotation task

## 3. Design Queue

### 3.1 Purpose

Show approved survey work that is ready for technical design and identify proposals blocked by missing information.

### 3.2 List columns

- Design reference
- Enquiry/customer reference
- Site locality
- Linked approved survey and version
- Proposed system category/capacity (if known)
- Assigned designer
- Design status
- Required-by date
- Last updated
- Blocker/next action

### 3.3 Filters

- Status
- Assigned designer/team
- Survey approval date
- Site locality
- System category
- Required-by date
- Blocked / ready for review

All list queries must be permission- and scope-filtered by the backend.

## 4. Create Design

### 4.1 Entry conditions

A design can be created only when:
- The user has design-create permission.
- A relevant enquiry/customer/site exists.
- An approved survey version suitable for design is linked, or a documented exception is authorised.
- Required survey limitations and specialist reviews are resolved or explicitly carried into the design as constraints.

The design must retain the exact survey version used. If a survey is later revised, the design must not silently change its source.

### 4.2 Design setup form

| Field | Required? | Behaviour / validation |
|---|---|---|
| Design title/reference | System-generated reference; title editable | Unique reference; clear customer/site context |
| Linked enquiry/customer | Yes | Pre-filled where launched from a record |
| Installation site | Yes | Must belong to the linked customer or be explicitly authorised |
| Source survey | Yes unless approved exception | Select an approved survey version; preserve version reference |
| Design purpose | Yes | New proposal, alternative option, revision or re-design |
| Assigned designer | Yes | Active employee with relevant capability |
| Target system category | Yes | Database-backed product/system category |
| Proposed capacity | Optional at initial draft; required before review | Numeric value with kW/kWp unit explicitly identified |
| Design assumptions | Required before review | Structured assumptions plus notes and source |
| Design due date | Optional | Valid date under organisation calendar |
| Internal notes | Optional | Not visible to customer unless deliberately copied to a customer-facing document |

### 4.3 Design status

Proposed states:
- Draft
- In preparation
- Awaiting technical review
- Returned for changes
- Approved
- Superseded
- Cancelled

Final states and transition permissions require stakeholder approval.

## 5. Design workspace

### 5.1 Header

Display:
- Design reference and status
- Customer and installation site
- Source survey reference/version
- Designer and reviewer
- Proposed system capacity
- Current version and last update
- Primary permitted action

### 5.2 Sections

**Survey basis**
- Approved survey snapshot
- Site/roof/electrical observations
- Constraints, risks and unresolved conditions
- Source evidence links

**System configuration**
- Proposed system category
- DC module capacity and count
- Inverter capacity/model
- AC/DC configuration details as approved by technical policy
- Mounting structure type
- Balance-of-system components
- Optional storage/backup components only if offered
- Proposed layout/orientation/tilt inputs where applicable
- Export/grid assumptions where applicable

**Engineering notes**
- Design assumptions and calculation references
- Compatibility checks
- Cable/protection/earthing considerations
- Structural/electrical specialist review
- Utility/interconnection constraints
- Open technical questions

**BOM**
- Product/component lines
- Quantity and unit
- Selected product/model
- Cost basis and selling-price basis
- Availability/lead-time information if maintained
- Substitution/alternative notes

**Documents**
- Layouts, drawings, datasheets, calculation sheets and supporting files
- Document version and reviewer state

**Review and history**
- Reviewer comments
- Approval decisions
- Version comparisons
- Change log

### 5.3 Design inputs and validation

The exact calculations depend on system type and technical standards. The application should capture, not invent, the approved design methodology.

Potential inputs:
- Customer load/consumption and source/period
- Surveyed usable area and shading observations
- Roof orientation and tilt, with measurement source
- Module make/model and electrical characteristics
- Inverter make/model and supported configuration
- String/MPPT configuration where applicable
- Cable lengths and routing assumptions
- Protection and earthing design references
- Mounting system and structural assumptions
- Grid/supply details
- Environmental/site constraints
- Battery/storage requirements, if offered
- Applicable approved design-rule version

Validation should identify:
- Missing required inputs.
- Unit mismatches.
- Incompatible module/inverter combinations according to verified manufacturer specifications.
- Capacity or configuration outside approved design-rule limits.
- Missing specialist sign-off.
- Conflicting survey constraints.
- Product/model no longer active for new proposals.

Do not silently auto-correct a technical value. Show the issue, source/rule and responsible reviewer.

## 6. Product and component catalogue

### 6.1 Purpose

Provide one controlled catalogue for products used in design, quotation, procurement and equipment registration.

### 6.2 Product record information

Potential fields:
- Product reference
- Category
- Manufacturer/brand
- Model
- Product description
- Electrical/technical specifications
- Unit of measure
- Supplier references
- Active/inactive state
- Datasheet/document references
- Warranty information with source and verification date
- Compatibility metadata
- Created/updated actor and timestamps

The exact schema follows the canonical data dictionary and ER review.

### 6.3 Catalogue rules

- Catalogue values are managed through authorised application screens.
- Frontend dropdowns and backend validation retrieve active records from database-backed APIs.
- Product identity is separate from supplier-specific purchase price.
- A product can have multiple supplier offers/price histories.
- Deactivating a product must not break historical quotations or installed equipment.
- Historical quotation lines retain a snapshot of the product description/specification and price basis used at issue time.
- Do not use unverified marketing claims as technical specifications.
- Product compatibility rules require a traceable source and technical approval.

### 6.4 Product selection

Designer searches by category, manufacturer, model or technical characteristic. Results should show enough specification to distinguish similar models. A selected product is added to the design BOM with quantity and relevant configuration.

If a product is not found, the designer may submit a catalogue-addition request. Do not create a new catalogue item automatically from free text without review.

## 7. Bill of Materials (BOM)

### 7.1 BOM purpose

The BOM is the technical and material list for one design version. It is not the purchase order and does not itself reserve or issue stock.

### 7.2 BOM line fields

- Product/component
- Description snapshot
- Quantity
- Unit of measure
- Technical role/category
- Optional configuration/specification
- Estimated procurement source
- Cost basis
- Notes
- Optional alternative/substitute
- Inclusion/exclusion state

### 7.3 BOM behaviour

- BOM belongs to a specific design version.
- Quantity must be positive unless a line is explicitly a non-quantity allowance.
- Unit of measure must match the product configuration.
- Required component categories are checked against the approved design template.
- Alternative products are clearly identified and cannot be treated as equivalent without compatibility review.
- Changes to an approved design create a new design version.
- Approved BOM can be handed to procurement as a planning input; purchasing still requires its own request/approval process.

### 7.4 Stock visibility

If inventory data is available, show:
- Available quantity
- Reserved quantity
- Already allocated quantity
- Expected incoming quantity
- Last stock update timestamp

Do not imply that stock is guaranteed until a valid reservation/confirmation workflow is completed. Stale or unavailable stock data must be labelled as such.

## 8. Design review and approval

### 8.1 Submit for review

Designer confirms:
- Correct approved survey version is linked.
- Required design inputs are present.
- BOM is complete for the proposal.
- Assumptions and exclusions are stated.
- Required technical documents are attached.
- Outstanding risks are disclosed.

Submission creates a review snapshot and places it in the authorised reviewer queue.

### 8.2 Reviewer screen

Show:
- Design summary and version
- Source survey and constraints
- Configuration and key calculations
- Product/model specifications
- BOM and alternatives
- Documents
- Compatibility/validation results
- Open risks and specialist reviews
- Previous reviewer comments

### 8.3 Reviewer actions

- Approve this version
- Return for changes with itemised comments
- Request specialist review
- Reject/cancel with reason where policy permits

Approval must apply to the exact submitted version. A user must not edit an approved snapshot in place.

### 8.4 Separation of duties

Whether the designer may approve their own design must be an explicit policy decision. High-risk configurations may require a separate technical approver. Approval capability and scope are enforced server-side.

## 9. Quotation Overview and List

### 9.1 List columns

- Quotation reference
- Customer/enquiry
- Site/project where applicable
- Quotation version
- Design reference/version
- Total amount and currency
- Status
- Prepared by
- Approval state
- Sent date
- Valid-until date
- Customer response

### 9.2 Filters

- Draft / review / approved / sent / accepted / rejected / expired
- Assigned employee
- Customer/site
- Date range
- Design reference
- Amount range (finance/commercial permission)
- Awaiting customer response
- Expiring soon

## 10. Create Quotation

### 10.1 Entry conditions

- User has quotation-create permission.
- Linked enquiry/customer exists.
- Technical design is approved where the proposal requires a design.
- Commercial price source and tax treatment are configured and current.
- Required internal approvals are defined.
- Customer-facing terms and document template are approved.

An authorised exception may allow a quotation without a formal design, but the exception and its reason must be recorded.

### 10.2 Quotation setup

Fields:
- Customer and contact recipient
- Installation site
- Linked enquiry/project, if applicable
- Approved design/version
- Quotation type
- Currency
- Issue date
- Valid-until date
- Prepared by
- Commercial owner
- Customer-facing notes
- Scope and exclusions
- Payment milestones/terms
- Delivery/installation assumptions
- Warranty terms and source
- Tax configuration/version
- Discount request, if applicable

### 10.3 Quotation line items

Each line may include:
- Product/service/charge
- Customer-facing description
- Quantity and unit
- Unit selling price
- Discount
- Tax category/rate reference
- Line total
- Optional cost/margin details restricted to commercial permissions

Support non-product service lines where approved. Do not represent a subsidy estimate as a guaranteed discount or payment.

### 10.4 Price calculation

The calculation engine must:
1. Load approved price inputs and effective dates.
2. Load the applicable tax configuration and version.
3. Calculate line values using defined rounding rules.
4. Apply authorised discounts.
5. Calculate subtotal, taxes and total.
6. Display the calculation breakdown.
7. Store a snapshot of all applied values/rules in the quotation version.

Price/tax changes after a quotation is issued must not rewrite the historical version.

The exact tax inclusion, rounding, discount order, tax jurisdiction and invoice treatment must be confirmed by the responsible finance/tax adviser. Mark unresolved treatment as a release blocker; do not guess.

### 10.5 Commercial safeguards

- A user cannot approve their own discount if policy requires separation of duties.
- Discounts beyond a configured threshold require approval.
- Manual price overrides require reason and audit.
- Margin/cost information is hidden from users without commercial permission.
- Quotation totals are calculated server-side; client-calculated totals are previews only.
- Do not issue a quotation with unresolved required fields or expired price/tax configuration.
- Changes after issue create a new version.

## 11. Quotation document preview

Before issue, show a customer-facing preview:
- GreenGrid business identity and approved contact details
- Customer and site
- Quotation reference/version/date/validity
- System scope and proposed configuration
- Itemised price or approved summary pricing
- Taxes and total
- Payment terms/milestones
- Included work and exclusions
- Warranty terms with clear source
- Estimated timeline with assumptions
- Customer acceptance instructions
- Approved legal/commercial terms

Internal cost, margin, reviewer comments, private notes and supplier prices must never appear in the customer document.

The generated PDF/document is an immutable output tied to the quotation version. Regeneration after a change requires a new version or controlled document revision.

## 12. Approval and issue workflow

### 12.1 Proposed states

Draft → Awaiting Internal Review → Changes Requested → Approved to Issue → Issued/Sent → Customer Responded → Accepted / Rejected / Expired / Superseded.

These are proposed states; the final transition model requires approval.

### 12.2 Internal review

Reviewer checks:
- Customer and site identity
- Design and BOM reference
- Price calculation
- Discount authority
- Tax configuration
- Payment terms
- Scope/exclusions
- Warranty claims and supporting terms
- Validity date
- Customer document preview

### 12.3 Issue/send

1. Authorised user selects the approved version.
2. System freezes the quotation content.
3. Generates the final document.
4. Records recipient and approved communication channel.
5. Queues delivery through configured email/WhatsApp or records manual delivery.
6. Tracks delivery attempts separately from quotation status.
7. Stores sent timestamp and document version.
8. Adds an activity event to enquiry/customer.

A failed message does not mean the quotation was rejected or never issued. Staff must be able to retry delivery without creating a new commercial version, provided the content is unchanged.

## 13. Customer response and acceptance

### 13.1 Response options

Depending on approved customer channel:
- Accept
- Reject
- Request revision
- Ask a question
- No response / follow-up required

### 13.2 Acceptance evidence

Acceptance must identify:
- Exact quotation reference and version
- Customer/account identity
- Responding person and authority/relationship where required
- Response timestamp
- Acceptance channel
- Evidence or confirmation reference
- Terms/conditions acknowledged

A staff member may record an acceptance received offline, but must record who received it, when, by which channel and the evidence/reference. Do not claim a legally valid electronic signature unless the selected process actually supports it.

### 13.3 Customer portal view

Customer sees:
- Quotation version and date
- Validity
- Proposed system and scope
- Customer-facing price breakdown
- Terms and exclusions
- Downloadable document
- Accept / Reject / Request Revision actions, if enabled

Customer must not see internal BOM cost, margins, supplier quotations, private notes or staff review comments.

### 13.4 Expiry

- Expiry is calculated from the stored validity date and configured timezone/business rules.
- Expired quotations remain in history.
- Extending validity requires an authorised action and history; whether it creates a new version must be defined by policy.
- A customer response received after expiry is flagged for review rather than silently accepted.

## 14. Revisions and version control

- Every issued quotation is immutable.
- A revision creates a new version linked to the previous one.
- Record reason for revision.
- Preserve prior PDF/document and delivery history.
- Show a comparison of changed scope, products, quantities, prices, terms and validity.
- Acceptance applies to one exact version.
- If the customer accepts an older version after a newer version exists, block automatic conversion and require authorised review.
- A design change that affects technical scope must reference the new approved design version.
- Never overwrite an accepted quotation; amendments follow a controlled process.

## 15. Accepted quotation hand-off

An accepted quotation may become the commercial basis for project creation/conversion, subject to GreenGrid's approved process.

Before hand-off:
- Confirm exact accepted version.
- Confirm customer and site.
- Confirm acceptance evidence.
- Confirm required contract/deposit/payment conditions.
- Confirm approval status.
- Confirm no unresolved revision supersedes the accepted version.

The project workflow receives references/snapshots; the quotation remains preserved. Project creation must be idempotent and must not create duplicate projects on retry.

Acceptance alone does not prove that a payment was received, utility approval was granted, materials are available or installation is authorised.

## 16. Data read, processing and write map

| Action | Data read | Processing | Data written / updated |
|---|---|---|---|
| Create design | Approved survey/version, customer/site, design templates, product catalogue | Eligibility and source-version validation | Design draft and source references |
| Configure design | Survey measurements, product specifications, design rules | Technical consistency checks | Design draft/version and configuration |
| Add BOM | Product catalogue, supplier offers, stock view if available | Quantity/unit/compatibility checks | BOM and BOM line records |
| Submit design | Draft, required inputs, documents, reviewer policy | Completeness checks and snapshot | Submitted design version and review event |
| Approve design | Exact submitted version, review comments, permission | Approval and version freeze | Approval event and approved-version pointer |
| Create quotation | Approved design, customer/site, commercial rules | Load effective price/tax inputs | Quotation draft/version |
| Edit quotation | Draft lines, price sources, tax configuration | Server-side totals, discount checks | Draft version and calculation snapshot |
| Submit quotation review | Draft and approval matrix | Resolve required approvers | Review request/history |
| Approve quotation | Exact submitted version, authority limits | Validate approval conditions | Approval event |
| Issue quotation | Approved version, recipient, channel preferences | Generate immutable document and delivery event | Issued version, document metadata, communication event |
| Record customer response | Quotation/version, response evidence | Validate version/expiry/identity | Response record and activity |
| Accept quotation | Exact version, acceptance evidence, policy | Confirm eligibility for hand-off | Acceptance record and status history |
| Revise quotation | Prior version and revision reason | Compare and snapshot changes | New version linked to prior version |
| Hand off to project | Accepted version, customer/site, project rules | Verify commercial readiness | Project-conversion request/reference |

Exact database columns and API contracts follow the canonical data dictionary and later API mapping. This chapter does not define a parallel schema.

## 17. Permissions

Proposed capabilities:
- design.view
- design.create
- design.update
- design.submit
- design.review
- design.approve
- design.return
- product_catalog.view
- product_catalog.manage
- bom.view
- bom.update
- quotation.view
- quotation.create
- quotation.update
- quotation.submit
- quotation.approve
- quotation.discount.override
- quotation.price.override
- quotation.issue
- quotation.response.record
- quotation.acceptance.record
- quotation.export
- commercial_cost.view
- quotation.template.manage

Use own/assigned/team/related-customer/project/location/company scopes as approved. Cost/margin visibility must be a separate capability from viewing a customer quotation. Backend must enforce every permission and record scope.

## 18. Notifications and activity events

Potential events:
- Design assigned
- Design submitted for review
- Design returned
- Design approved
- Quotation assigned/preparation due
- Quotation submitted for approval
- Discount approval required
- Quotation approved to issue
- Quotation issued/delivery failed
- Customer accepted/rejected/requested revision
- Quotation approaching expiry
- Accepted quotation ready for project hand-off

Notification previews must not expose internal costs or private review notes. Customer-facing messages use approved templates and consent-aware delivery.

## 19. Failure and exception handling

- **Survey version withdrawn/superseded:** block new approval and request a current technical basis.
- **Product inactive:** retain historical lines; prevent new selection unless an authorised exception exists.
- **Missing compatibility data:** show unknown/unverified, not compatible by assumption.
- **Stale stock:** show last update and do not promise availability.
- **Price source unavailable:** preserve draft; block issue if a required commercial value cannot be verified.
- **Tax configuration expired:** block issue pending authorised update.
- **Approval conflict:** show latest version and require review.
- **PDF generation failure:** retain draft/approved state as appropriate; do not mark delivery successful.
- **Message delivery failure:** preserve issued quotation and retry delivery separately.
- **Customer responds to old version:** flag for authorised review.
- **Concurrent edits:** use version checking; do not overwrite another user's changes.
- **Calculation mismatch:** server total is authoritative; prevent issue and log the exception.

## 20. Acceptance tests

- [ ] Design can be created from an approved survey version.
- [ ] Design retains the exact survey version used.
- [ ] Design inputs include units and traceable sources where required.
- [ ] Missing/unverified technical compatibility is not silently treated as valid.
- [ ] Product catalogue is database-backed and permission-managed.
- [ ] BOM is versioned and distinct from purchase order/stock issue.
- [ ] Stale stock is clearly identified.
- [ ] Design approval is tied to an immutable submitted version.
- [ ] Quotation cannot be issued without required technical/commercial checks.
- [ ] Price and tax calculations are server-side and reproducible.
- [ ] Historical quotation values do not change when catalogue prices/rules change.
- [ ] Discount and price overrides enforce approval limits and audit reasons.
- [ ] Customer PDF excludes internal cost, margin and notes.
- [ ] Delivery status is separate from quotation status.
- [ ] Customer acceptance identifies the exact version and evidence.
- [ ] Revision creates a new version and preserves previous documents.
- [ ] Acceptance of an old/superseded version requires review.
- [ ] Accepted quotation hand-off is idempotent.
- [ ] No payment, utility approval or stock availability is inferred from quotation acceptance.
- [ ] All critical actions are permission-checked and audited.

## 21. Decisions GreenGrid must confirm

- Approved solar system categories and product catalogue structure.
- Who is authorised to prepare, review and approve designs.
- Design calculation standards, tools and required specialist sign-offs.
- Required technical documents and customer-facing design detail.
- Product manufacturers/models and compatibility data sources.
- How supplier pricing and cost updates are maintained.
- Selling-price rules, margin visibility and discount approval limits.
- Tax treatment, rounding, invoice/quotation distinction and responsible approver.
- Quotation validity periods and extension rules.
- Required payment milestones and contract documents.
- Approved customer acceptance methods and evidence requirements.
- Whether customer portal acceptance is enabled in the first release.
- Whether quotations can be issued without an approved survey/design and who can approve exceptions.
- Whether a changed accepted quotation requires a formal amendment or a new acceptance.

**Next chapter:** Project Workspace, Milestones, Tasks & Scheduling — project setup, ownership, dependencies, progress tracking, blockers, rescheduling, approvals and project-level activity.
