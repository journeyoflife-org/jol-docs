# ADR-007: Multi-Tenant Isolation via Row-Level Security

## Document Control

| Field            | Value                              |
|------------------|------------------------------------|
| Document ID      | ADR-007                            |
| Title            | Multi-Tenant Isolation via Row-Level Security |
| Version          | 1.0.0                              |
| Classification   | Public                             |
| Owner (role)     | Platform Architect / Data Protection Officer |
| Approver (role)  | JOL Governance Board               |
| Effective Date   | 2026-09-25                         |
| Next Review      | 2027-09-25                         |
| Review Cycle     | Annual, or upon material change    |

## Status

Accepted

## Context

The platform hosts data for ~400,000 independent institutions (tenants) in a shared PostgreSQL
instance ([ADR-005](ADR-005-postgresql-primary-datastore.md)). Under GDPR, each tenant is a
separate controller of its own data subjects, and JOL is a processor. A defect that leaked one
tenant's data to another would be a reportable personal-data breach (GDPR Art. 33) and a
confidentiality failure under SOC 2 CC6 and ISO 27001 A.8.

Application-layer filtering alone (adding `WHERE tenant_id = ?` to every query) is necessary but
not sufficient: a single forgotten filter leaks data across tenants. Isolation must be enforced at
a layer that cannot be bypassed by an application bug.

The `jol-auth` service already defines the tenant boundary (service-local ADR-002): every tenant
has a UUID `tenant_id`, resolved from the `X-Tenant-ID` header by a `TenantResolutionMiddleware`,
and cross-tenant access raises `TenantIsolationError` and emits an audit event.

## Decision

- We will enforce tenant isolation with **PostgreSQL Row-Level Security (RLS)** on every
  tenant-scoped table, in addition to application-layer filtering (defence in depth).
- The database session will set the current tenant (e.g. `SET app.current_tenant = '<uuid>'`) at
  connection acquisition, derived from the authenticated request's `X-Tenant-ID`.
- RLS policies will restrict all `SELECT`/`INSERT`/`UPDATE`/`DELETE` to rows whose `tenant_id`
  matches the session tenant; no role used by the application bypasses RLS.
- The tenant is resolved **once** at the edge by the tenant-resolver (`X-Tenant-ID` header or
  subdomain) and propagated to every downstream call and database session.
- Any cross-tenant access attempt raises `TenantIsolationError` and emits an audit event.
- RLS behaviour is covered by **automated tests** at repository, service, and API level; a new
  tenant-scoped table without an RLS policy fails review.

## Consequences

### Positive

- Isolation survives application bugs — the database refuses cross-tenant rows regardless of query
  correctness.
- Strong GDPR Art. 5(1)(f) integrity/confidentiality and Art. 32 security-of-processing posture.
- Audit events on isolation failures provide detectable evidence for SOC 2 CC6/CC7.

### Negative

- Every tenant-scoped table requires an RLS policy and a test — additional authoring overhead.
- The session tenant must be correctly set on every connection; connection-pool reuse bugs could
  leak the wrong tenant, so pool reset hooks are mandatory.
- Cross-tenant analytics requires explicit, separately-authorised paths (no ambient access).

### Neutral / follow-ups

- Aligns with `jol-auth` service-local ADR-002 (tenant boundary) and ADR-004 (session storage).
- Tenant resolution is implemented by the `@journeyoflife-org/tenant-resolver` package.

## Evidence

- `jol-auth/docs/ADR/ADR-002-tenant-boundary.md` — tenant UUID, `X-Tenant-ID` header,
  `TenantResolutionMiddleware`, `TenantIsolationError`, audit event on cross-tenant access.
- Tenant resolver package: `jol-hub/frontend/packages/tenant-resolver`
  (`@journeyoflife-org/tenant-resolver`), "Tenant resolution (X-Tenant header / subdomain)".
- Tenant domain model: `jol-hub/backend/django/apps/tenants/models.py`.
- Cross-plane RLS contract work tracked in `jol-hub` branch `docs/cross-plane-rls-contract`.

## Change History

| Version | Date | Author (role) | Change |
|---------|------|---------------|--------|
| 1.0.0 | 2026-09-25 | Platform Architect | Recorded retroactively from implemented architecture; status Accepted. |
