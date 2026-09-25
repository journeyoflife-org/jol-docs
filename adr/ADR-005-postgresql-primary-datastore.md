# ADR-005: PostgreSQL as Primary Datastore

## Document Control

| Field            | Value                              |
|------------------|------------------------------------|
| Document ID      | ADR-005                            |
| Title            | PostgreSQL as Primary Datastore    |
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

The JOL platform serves approximately 400,000 tenant websites across 27 EU member states. The
primary datastore must:

- Guarantee **strong transactional integrity** for multi-tenant data, payments, donations, and
  financial records.
- Support **hard tenant isolation** enforceable at the database layer, not only in application
  code, to satisfy GDPR (see [ADR-007](ADR-007-multi-tenant-rls-isolation.md)).
- Run **self-hosted** on JOL's own Proxmox infrastructure to keep personal data inside the EU and
  avoid third-party cloud sub-processors for primary storage.
- Scale to hundreds of thousands of tenants with mature, well-understood operational tooling.

A document store or managed cloud database was considered but rejected: the former weakens
relational integrity for financial data, and the latter introduces a non-EU sub-processor and
data-residency risk.

## Decision

- We will use **PostgreSQL** as the single primary system of record for all transactional and
  personal data.
- We will enforce tenant isolation with **PostgreSQL Row-Level Security (RLS)** policies, not
  application-layer filtering alone (see [ADR-007](ADR-007-multi-tenant-rls-isolation.md)).
- We will identify rows by **UUID** primary keys to avoid cross-tenant enumeration via sequential
  IDs.
- We will run PostgreSQL **self-hosted** on the Proxmox platform, with encryption at rest and in
  transit, and no primary personal data stored in third-party clouds.
- We will use **Alembic/Django migrations** for all schema changes; no manual DDL in any
  environment.
- Redis is used only for cache, queues, and ephemeral session state — never as a system of record.

## Consequences

### Positive

- Relational integrity and ACID transactions protect financial and donation data.
- RLS provides defence-in-depth tenant isolation that survives application bugs.
- Self-hosting keeps primary personal data in the EU, simplifying GDPR Art. 44–49 transfer analysis.
- Mature tooling (pg_dump, PITR, logical replication) supports the RTO/RPO targets in `jol-dr`.

### Negative

- RLS policies add complexity and must be tested explicitly for every tenant-scoped table.
- Self-hosting places the full backup, patching, and failover burden on JOL operations.
- Vertical scaling limits eventually require read replicas and partitioning.

### Neutral / follow-ups

- Forces [ADR-007](ADR-007-multi-tenant-rls-isolation.md) (RLS isolation model).
- Backup/restore strategy and RTO/RPO are specified in the `jol-dr` repository.

## Evidence

- `jol-hub` environment contract: `DATABASE_URL` (PostgreSQL connection string) and `REDIS_URL`
  are required variables — see `jol-hub/README.md` (Environment Variables).
- Django models derive from `UUIDModel` and `TimeStampedModel`
  (`jol-hub/backend/django/apps/core/models.py`), confirming UUID primary keys.
- Migration tooling: Alembic/Django migrations documented in `jol-hub/README.md`
  (Database & Migrations).
- Infrastructure: PostgreSQL provisioning role exists at
  `jol-infrastructure` / `jol-deploy` Ansible (`ansible/roles/postgresql`).

## Change History

| Version | Date | Author (role) | Change |
|---------|------|---------------|--------|
| 1.0.0 | 2026-09-25 | Platform Architect | Recorded retroactively from implemented architecture; status Accepted. |
