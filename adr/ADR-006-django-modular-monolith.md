# ADR-006: Django Modular Monolith for the Platform Backend

## Document Control

| Field            | Value                              |
|------------------|------------------------------------|
| Document ID      | ADR-006                            |
| Title            | Django Modular Monolith for the Platform Backend |
| Version          | 1.0.0                              |
| Classification   | Public                             |
| Owner (role)     | Platform Architect                 |
| Approver (role)  | JOL Governance Board               |
| Effective Date   | 2026-09-25                         |
| Next Review      | 2027-09-25                         |
| Review Cycle     | Annual, or upon material change    |

## Status

Accepted

## Context

The platform backend must model a rich, interrelated domain — users, tenants, organizations, CRM,
analytics, content, payments, financials, donations, integrations, and per-country configuration —
for 400,000 tenant websites. The team is small (currently a single owner-developer, scaling later).

Two extremes were rejected:

- **Premature microservices** — high operational overhead (service mesh, distributed tracing,
  per-service datastores, network-level tenancy) that a small team cannot staff, and which
  complicates GDPR data-flow mapping and transactional integrity across services.
- **Unstructured monolith** — fast initially but degrades into a big ball of mud with no module
  boundaries, making compliance scoping (e.g. isolating the payment cardholder-data environment)
  impossible.

## Decision

- We will build the backend as a **Django modular monolith**: a single deployable, internally
  partitioned into bounded Django apps with explicit ownership.
- Each domain is a separate app under `backend/django/apps/`:
  `core`, `users`, `tenants`, `organizations`, `crm`, `analytics`, `content`, `payment_events`,
  `financial`, `donations`, `integrations`, `countries`.
- Apps communicate through **service interfaces and signals**, not by reaching into each other's
  models; cross-app database access is discouraged and reviewed.
- The **payment-card data environment (CDE)** is scoped to the smallest possible set of apps
  (`payment_events`, `financial`) to keep PCI-DSS SAQ A eligibility (see
  [ADR-010](ADR-010-ecommerce-pci-saq-a.md)).
- A modular monolith does **not** preclude later extraction: app boundaries are the natural seams
  for future services (reserved as `jol-backend-platform`), and extraction happens only when scale
  or team size justifies it.

## Consequences

### Positive

- One deployable keeps operations, observability, and transactions simple for a small team.
- Explicit app boundaries make the system comprehensible and keep compliance scoping tractable.
- Django's mature ecosystem (ORM, admin, migrations, auth) accelerates delivery.
- The modular seams allow incremental extraction to services without a rewrite.

### Negative

- A single deployable means a defect in one app can affect the whole process (mitigated by tests
  and module boundaries).
- Shared database requires discipline to avoid cross-app coupling at the schema level.
- Horizontal scaling is coarse-grained until extraction occurs.

### Neutral / follow-ups

- Requires CODEOWNERS-style module ownership as the team grows.
- Tenant isolation is enforced at the data layer via RLS (see
  [ADR-007](ADR-007-multi-tenant-rls-isolation.md)), independent of app boundaries.

## Evidence

- Django app layout: `jol-hub/backend/django/apps/` contains `core`, `users`, `tenants`,
  `organizations`, `crm`, `analytics`, `content`, `payment_events`, `financial`, `donations`,
  `integrations`, `countries` (12 apps).
- Shared base models: `TimeStampedModel` / `UUIDModel` in
  `jol-hub/backend/django/apps/core/models.py`.
- Backend language/runtime: Python 3.12 + Django, per `jol-hub/README.md` (Overview, Prerequisites).
- Reserved extraction target: `jol-backend-platform` stub repository ("reserved for backend
  microservice extraction", `jol-hub/README.md`).

## Change History

| Version | Date | Author (role) | Change |
|---------|------|---------------|--------|
| 1.0.0 | 2026-09-25 | Platform Architect | Recorded retroactively from implemented architecture; status Accepted. |
