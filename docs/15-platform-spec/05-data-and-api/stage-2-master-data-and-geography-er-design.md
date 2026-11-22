# Stage 2 — Master Data & Geography ER Design

**Project:** GreenGrid Solar Solutions — Solar Agency Management Platform  
**Stage:** 2 — Logical relationship design  
**Status:** Proposed design for stakeholder validation  
**Date:** 22 November 2026

## 1. Purpose and design boundary

This document defines the first Stage 2 domain: Master Data & Geography. It identifies database entities, key attributes, relationships, constraints, and application-management rules before PostgreSQL implementation.

This is a logical design, not a migration or production SQL script. Physical types and indexes will be finalized during Stage 3.

### Non-negotiable master-data rule

Business master data is **entered manually by authorized users through the application and saved in PostgreSQL**. It must not be hardcoded in frontend/backend code, UI dropdown arrays, application enums, or hidden seed scripts.

- The application fetches master values from database-backed APIs.
- Initial business master tables may be empty.
- No mock/sample geography, customers, employees, suppliers, products, or other operational records are to be inserted.
- Database migrations may create schema, constraints, indexes, and essential technical metadata; they must not silently populate business master lists.
- Any unavoidable technical bootstrap record must be documented separately and must not be used as a substitute for manually maintained business master data.

## 2. Scope

This domain provides reusable reference records for countries, states/Union Territories, districts, local bodies, post offices, postal codes, and address types.

The design supports India and other countries without assuming every country's administrative hierarchy is identical. It also preserves address text as entered, because official geography mappings may be incomplete, change over time, or not precisely represent a locality.

## 3. Proposed entities

### 3.1 countries

| Column | Key | Meaning |
|---|---|---|
| country_id | PK | Stable internal identifier |
| country_code | UQ | ISO 3166-1 alpha-2 code, stored as text |
| country_name | UQ | Display name maintained by authorized user |
| phone_calling_code |  | Optional international calling code |
| is_active |  | Selectable status |
| created_at, created_by |  | Creation audit fields |
| updated_at, updated_by |  | Update audit fields |

### 3.2 states

| Column | Key | Meaning |
|---|---|---|
| state_id | PK | Stable internal identifier |
| country_id | FK | Parent country |
| state_code |  | Optional official code |
| state_name |  | State / Union Territory name |
| is_active |  | Selectable status |
| created_at, created_by, updated_at, updated_by |  | Audit fields |

Suggested uniqueness: (country_id, normalized_state_name).

### 3.3 districts

| Column | Key | Meaning |
|---|---|---|
| district_id | PK | Stable internal identifier |
| state_id | FK | Parent state |
| district_code |  | Optional official code |
| district_name |  | District name |
| is_active |  | Selectable status |
| created_at, created_by, updated_at, updated_by |  | Audit fields |

Suggested uniqueness: (state_id, normalized_district_name).

### 3.4 local_bodies

| Column | Key | Meaning |
|---|---|---|
| local_body_id | PK | Stable internal identifier |
| district_id | FK | Parent district |
| local_body_type_id | FK | Type of local body |
| local_body_name |  | Official/common name |
| local_body_code |  | Optional official code |
| is_active |  | Selectable status |
| created_at, created_by, updated_at, updated_by |  | Audit fields |

### 3.5 local_body_types

| Column | Key | Meaning |
|---|---|---|
| local_body_type_id | PK | Stable internal identifier |
| type_name | UQ | Type label maintained in the database |
| description |  | Optional explanation |
| is_active |  | Selectable status |

Examples include Grama Panchayat, Block Panchayat, District Panchayat, Municipality, and Corporation. These are examples only; actual values must be entered by an authorized administrator. Do not hardcode them.

### 3.6 post_offices

| Column | Key | Meaning |
|---|---|---|
| post_office_id | PK | Stable internal identifier |
| district_id | FK | District association, where known |
| post_office_name |  | Post office name |
| post_office_code |  | Optional official postal identifier |
| is_active |  | Selectable status |
| created_at, created_by, updated_at, updated_by |  | Audit fields |

A post office may serve multiple localities. Do not force a post office to belong to exactly one village/local body unless verified by authoritative source data and business rules.

### 3.7 postal_codes

| Column | Key | Meaning |
|---|---|---|
| postal_code_id | PK | Stable internal identifier |
| country_id | FK | Country |
| postal_code |  | Postal code stored as text |
| is_active |  | Selectable status |
| created_at, created_by, updated_at, updated_by |  | Audit fields |

For Indian PIN codes, validate six digits at the application boundary and store as VARCHAR(6). A PIN is an identifier, not a quantity.

### 3.8 postal_code_post_offices

| Column | Key | Meaning |
|---|---|---|
| postal_code_id | PK, FK | Postal code |
| post_office_id | PK, FK | Post office |
| is_primary |  | Optional primary association |
| is_active |  | Association status |

This junction table supports many-to-many postal-code/post-office associations. Do not assume a one-to-one mapping.

### 3.9 address_types

| Column | Key | Meaning |
|---|---|---|
| address_type_id | PK | Stable internal identifier |
| type_name | UQ | Address type label |
| description |  | Optional explanation |
| is_active |  | Selectable status |

Possible labels include Residential, Permanent, Billing, Office, Supplier, Warehouse, and Installation Site. These values are entered and maintained in the database by authorized users.

## 4. Address records that consume geography masters

Geography masters are reference data. They do not replace the actual address records owned by business domains.

Address-owning entities:
- customer_addresses
- enquiry_addresses
- employee_addresses
- supplier_addresses
- company_locations (or a dedicated company address entity)
- installation_sites (with site address fields or a linked site-address entity)

Recommended address attributes:
- address_line_1
- address_line_2
- place_or_locality
- landmark
- country_id
- state_id
- district_id
- local_body_id (nullable)
- post_office_id (nullable)
- postal_code_id (nullable)
- postal_code_text (retained as entered / snapshot)
- latitude and longitude (nullable)
- address_type_id (where multiple address types are supported)
- is_primary
- created_at, created_by, updated_at, updated_by

Keep postal_code_text (or an equivalent address snapshot) so that an address remains readable and historically accurate if a master record is renamed or deactivated. If a postal-code master is unavailable, the address may retain entered postal-code text subject to validation and permissions; users should not be blocked from capturing a legitimate address solely because the reference list is incomplete.

An installation site is a distinct business record. It must not be treated as the customer's residential address.

## 5. Entity relationship diagram

The following Mermaid ER diagram shows the proposed geography master relationships. Other address-owning entities follow the same reference pattern.

~~~mermaid
erDiagram
    COUNTRIES ||--o{ STATES : contains
    COUNTRIES ||--o{ POSTAL_CODES : defines
    STATES ||--o{ DISTRICTS : contains
    DISTRICTS ||--o{ LOCAL_BODIES : contains
    DISTRICTS ||--o{ POST_OFFICES : associates
    LOCAL_BODY_TYPES ||--o{ LOCAL_BODIES : classifies
    POSTAL_CODES ||--o{ POSTAL_CODE_POST_OFFICES : maps
    POST_OFFICES ||--o{ POSTAL_CODE_POST_OFFICES : maps
    ADDRESS_TYPES ||--o{ CUSTOMER_ADDRESSES : classifies
    COUNTRIES ||--o{ CUSTOMER_ADDRESSES : referenced_by
    STATES ||--o{ CUSTOMER_ADDRESSES : referenced_by
    DISTRICTS ||--o{ CUSTOMER_ADDRESSES : referenced_by
    LOCAL_BODIES ||--o{ CUSTOMER_ADDRESSES : referenced_by
    POST_OFFICES ||--o{ CUSTOMER_ADDRESSES : referenced_by
    POSTAL_CODES ||--o{ CUSTOMER_ADDRESSES : referenced_by
~~~

## 6. Relationship and integrity rules

1. One country may have many states and postal-code records.
2. One state belongs to one country and may have many districts.
3. One district belongs to one state and may have many local bodies and post offices.
4. One local body has one local-body type; a type may classify many local bodies.
5. Postal codes and post offices use a many-to-many association table; the real mapping must be verified.
6. Address records may reference geography masters, but free-text address components remain available.
7. Geography foreign keys must be checked for hierarchy consistency (for example, selected district must belong to selected state).
8. Master records already referenced by addresses must not be physically deleted. Use deactivation and preserve historical references.
9. Unique constraints must be scoped to the parent geography where names can legitimately repeat.
10. Do not use a PIN code as the sole determinant of district, locality, or local body.
11. Coordinates are optional and must not be fabricated from a postal code.
12. Do not infer or overwrite a user's entered address from a master-data lookup without confirmation.

## 7. Manual master-data administration workflow

1. An authorized administrator opens Administration → Master Data → Geography.
2. The administrator chooses the master category.
3. The application loads existing records from the database API.
4. The administrator creates or edits a record using validated fields.
5. The backend checks required fields, parent-child consistency, duplicate rules, and permission scope.
6. The backend stores the record and audit metadata in PostgreSQL.
7. Other application modules retrieve active options from the database API.
8. Deactivation checks whether the record is referenced and warns about the impact; existing transactions retain their references.

There is no hardcoded fallback list. If a master list is empty, the UI should show a clear empty state and direct an authorized user to add the required records.

## 8. API expectations (logical, not final endpoint contract)

The backend should expose permission-protected endpoints for listing/searching active master records with pagination, viewing one record, creating, updating, activating/deactivating, retrieving dependent options (such as districts for a selected state), and validating address geography combinations.

Clients must not connect directly to PostgreSQL. The API must enforce authorization and validation. Final URL paths, request/response schemas, and error codes are deferred to API design.

## 9. Open decisions for stakeholder validation

- Which countries must be supported at launch?
- Should the system maintain the full Kerala geography list, or should administrators add only locations needed for business operations?
- Which authoritative source will GreenGrid use to verify PIN-code/post-office mappings?
- Should all local-body levels be represented, or only the level needed for customer/site addresses?
- Who is authorized to create, edit, approve, and deactivate geography records?
- Should address entry permit a postal code not yet present in master data, with a pending-review flag?
- Which address fields are mandatory for customers versus installation sites?

Do not silently decide these items in code. Record approved decisions before physical schema implementation.

## 10. Stage 2 acceptance checklist

- [ ] Stakeholders approve the geography hierarchy and supported countries.
- [ ] Master-data manual-entry and no-hardcoding rule is accepted.
- [ ] Table ownership, primary keys, foreign keys, and uniqueness rules are reviewed.
- [ ] PIN-code/post-office many-to-many mapping is validated against an authoritative source.
- [ ] Address snapshot and installation-site separation are approved.
- [ ] Authorization, audit, activation/deactivation, and empty-state behaviour are approved.
- [ ] Open questions are answered or explicitly deferred.

**Next domain:** Organization, Employees & Access Control ER Design.
