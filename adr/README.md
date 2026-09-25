# Architecture Decision Records (ADR) Registry

## Document Control

| Field            | Value                              |
|------------------|------------------------------------|
| Document ID      | ADR-REG-001                        |
| Title            | ADR Registry                       |
| Version          | 1.0.0                              |
| Classification   | Public                             |
| Owner (role)     | Platform Architect                 |
| Approver (role)  | JOL Governance Board               |
| Effective Date   | 2026-09-25                         |
| Next Review      | 2027-09-25                         |
| Review Cycle     | Annual, or upon material change    |

This is the **canonical register** of architecture decisions for the Journey of Life (JOL)
platform. An Architecture Decision Record captures a decision that is hard to reverse and affects
the platform broadly, together with the context that forced it and the consequences it creates.

The registry exists to **de-silo knowledge that otherwise lives only in code and commit messages**.
If a decision is referenced from a repository (for example the `adr-011` topic on the ten
`jol-site-*` spokes), the authoritative record lives or is indexed here.

## What Belongs Here

| Decision type | Where it lives |
|---------------|----------------|
| **Platform-wide** — affects multiple services, the data model, tenancy, security posture, or the repository topology | This registry (`jol-docs/adr/`) |
| **Service-local** — affects only one service's internals | The service repository (e.g. `jol-auth/docs/ADR/`), **indexed** here |

Platform-wide ADRs are numbered in a single global sequence maintained in this file. Service-local
ADRs keep their own local numbering inside their repository; they are listed in the
[Service-Local ADR Index](#service-local-adr-index) so there is one place to look.

## ADR Lifecycle

```text
Proposed ──▶ Accepted ──▶ (Deprecated ──▶ Superseded by ADR-NNN)
                │
                └──▶ Rejected (recorded, never deleted)
```

| Status | Meaning |
|--------|---------|
| **Proposed** | Under consideration; not yet approved. Must not be relied upon. |
| **Accepted** | Approved by the Platform Architect and, where required, the Governance Board. Current and authoritative. |
| **Deprecated** | No longer the preferred approach but not yet replaced. |
| **Superseded** | Replaced by a later ADR, which is linked. The superseded ADR is retained for history. |
| **Rejected** | Considered and declined. Retained so the rationale is not re-litigated. |

**Immutability rule.** Once an ADR is `Accepted`, its Decision and Consequences are never rewritten.
To change course, author a **new** ADR, set the old ADR's status to `Superseded by ADR-NNN`, and add
a Change-History row. Numbers are never reused.

## Platform-Wide ADR Index

| ADR | Title | Status | Owner (role) | Primary driver |
|-----|-------|--------|--------------|----------------|
| [ADR-005](ADR-005-postgresql-primary-datastore.md) | PostgreSQL as Primary Datastore | Accepted | Platform Architect | Data integrity, RLS tenancy |
| [ADR-006](ADR-006-django-modular-monolith.md) | Django Modular Monolith for the Platform Backend | Accepted | Platform Architect | Delivery speed, 400K-tenant scale |
| [ADR-007](ADR-007-multi-tenant-rls-isolation.md) | Multi-Tenant Isolation via Row-Level Security | Accepted | Platform Architect / DPO | GDPR tenant isolation |
| [ADR-008](ADR-008-self-hosted-llm-air-gapped.md) | Self-Hosted, Air-Gapped LLM Platform | Accepted | Platform Architect / CISO | GDPR / data-residency |
| [ADR-009](ADR-009-mcp-tool-integration.md) | MCP Servers for Tool-Augmented AI | Accepted | Platform Architect | AI tool integration |
| [ADR-010](ADR-010-ecommerce-pci-saq-a.md) | E-Commerce Payments Scoped to PCI-DSS SAQ A | Accepted | Platform Architect / CISO | PCI-DSS scope reduction |
| [ADR-011](ADR-011-hub-and-spoke-monorepo-federation.md) | Hub-and-Spoke Monorepo Federation | Accepted | Platform Architect | 400K sites, shared packages |

> **Note on numbering.** ADR-001 through ADR-004 were assigned inside the `jol-auth` service before
> this central registry existed. They remain valid as **service-local** ADRs and are indexed below;
> the platform-wide sequence in this registry therefore begins at ADR-005. No number is ever reused.

## Service-Local ADR Index

These ADRs live in their service repositories and are indexed here for discoverability. The owning
repository is the source of truth for their content.

| ADR | Title | Repository | Path |
|-----|-------|------------|------|
| ADR-001 | Issuer and Discovery Configuration | `jol-auth` | [`docs/ADR/ADR-001-issuer-and-discovery.md`](https://github.com/journeyoflife-org/jol-auth/blob/main/docs/ADR/ADR-001-issuer-and-discovery.md) |
| ADR-002 | Tenant Boundary Definition | `jol-auth` | [`docs/ADR/ADR-002-tenant-boundary.md`](https://github.com/journeyoflife-org/jol-auth/blob/main/docs/ADR/ADR-002-tenant-boundary.md) |
| ADR-003 | Token Signing and JWKS Strategy | `jol-auth` | [`docs/ADR/ADR-003-token-signing-and-jwks.md`](https://github.com/journeyoflife-org/jol-auth/blob/main/docs/ADR/ADR-003-token-signing-and-jwks.md) |
| ADR-004 | Session Storage Strategy | `jol-auth` | [`docs/ADR/ADR-004-session-storage.md`](https://github.com/journeyoflife-org/jol-auth/blob/main/docs/ADR/ADR-004-session-storage.md) |

When a service-local decision acquires platform-wide impact, it is **promoted**: a new
platform-wide ADR is written in this registry that references the originating local ADR, and the
local ADR is marked as superseded by the platform record.

## Authoring an ADR

1. Copy [`template.md`](template.md) to `ADR-NNN-short-kebab-title.md` (next free number).
2. Fill in Document Control, Status (`Proposed`), Context, Decision, Consequences, and Evidence.
3. Open a pull request; the Platform Architect reviews (CODEOWNERS).
4. On approval, set Status to `Accepted`, add the row to the index above, and record the change in
   [`../CHANGELOG.md`](../CHANGELOG.md).

See [`../guides/adding-an-adr.md`](../guides/adding-an-adr.md) for the full workflow.

## Change History

| Version | Date | Author (role) | Change |
|---------|------|---------------|--------|
| 1.0.0 | 2026-09-25 | Platform Architect | Initial registry: platform ADR-005…011 recorded; service-local ADR-001…004 indexed. |
