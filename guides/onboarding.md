# Engineer Onboarding Guide

## Document Control

| Field            | Value                              |
|------------------|------------------------------------|
| Document ID      | GDE-ONB-001                        |
| Title            | Engineer Onboarding Guide          |
| Version          | 1.0.0                              |
| Classification   | Public                             |
| Owner (role)     | Platform Architect                 |
| Approver (role)  | JOL Governance Board               |
| Effective Date   | 2026-09-25                         |
| Next Review      | 2027-09-25                         |
| Review Cycle     | Annual, or upon material change    |

## Purpose

A structured reading path so a new engineer can understand the Journey of Life (JOL) platform —
its architecture, its governing decisions, and its compliance obligations — without reading source
code first.

## Day 1 — Understand the Shape of the Platform

1. Read the hub [`README`](../README.md) — what this repository is and how it is organised.
2. Read [`../architecture/system-landscape.md`](../architecture/system-landscape.md) — the platform
   in its environment (C4 Level 1): people, external systems, hosting boundary.
3. Read [`../architecture/repo-map.md`](../architecture/repo-map.md) — the 40 repositories and their
   five tiers (governance, platform, devops, site, template).

## Day 2 — Understand the Core Decisions

Read the ADRs in this order (each is short):

1. [ADR-006](../adr/ADR-006-django-modular-monolith.md) — why the backend is a Django modular
   monolith.
2. [ADR-005](../adr/ADR-005-postgresql-primary-datastore.md) — why PostgreSQL is the system of record.
3. [ADR-007](../adr/ADR-007-multi-tenant-rls-isolation.md) — how tenants are isolated (RLS).
4. [ADR-011](../adr/ADR-011-hub-and-spoke-monorepo-federation.md) — how the hub feeds the ten site
   spokes (the front-end topology).
5. [ADR-008](../adr/ADR-008-self-hosted-llm-air-gapped.md) and
   [ADR-009](../adr/ADR-009-mcp-tool-integration.md) — the AI tier.
6. [ADR-010](../adr/ADR-010-ecommerce-pci-saq-a.md) — payments and PCI scope.

Then read [`../architecture/container-diagram.md`](../architecture/container-diagram.md) (C4 Level 2)
and [`../architecture/hub-and-spoke.md`](../architecture/hub-and-spoke.md) to see the decisions drawn.

## Day 3 — Understand Tenancy & Data Flow

1. Read [`../architecture/multi-tenancy.md`](../architecture/multi-tenancy.md) — tenant resolution,
   the five isolation layers, and the session-tenant invariant.
2. Read [`../architecture/data-flow.md`](../architecture/data-flow.md) — the four principal flows
   (form submission, content management, AI generation, payment).

## Day 4 — Understand Compliance Obligations

1. Read [`../gdpr/README.md`](../gdpr/README.md) — controller vs processor, and why
   **special-category (Art. 9) religious data** makes this platform high-risk.
2. Skim [`../gdpr/ropa-processor.md`](../gdpr/ropa-processor.md) and
   [`../gdpr/data-inventory.md`](../gdpr/data-inventory.md) — what data exists and on whose behalf.
3. Read [`../compliance/control-matrix.md`](../compliance/control-matrix.md) — how architecture maps
   to SOC 2 / ISO 27001 / GDPR.

## Day 5 — Ways of Working

1. Read [`../CONTRIBUTING.md`](../CONTRIBUTING.md) — the documentation change lifecycle and the
   public-repo data-protection rules.
2. Read [`adding-an-adr.md`](adding-an-adr.md) — how to record a decision when you make one.
3. Read the ISMS policies in
   [`jol-policies`](https://github.com/journeyoflife-org/jol-policies) (access control, change
   management, acceptable use, data classification).
4. Review [`../../jol-repo-template`](https://github.com/journeyoflife-org/jol-repo-template) to see
   how a new repository is scaffolded and governed.

## Key Invariants to Remember

| Invariant | Source |
|-----------|--------|
| Tenant isolation is enforced at the **database** (RLS), not only in app code | [ADR-007](../adr/ADR-007-multi-tenant-rls-isolation.md) |
| The session tenant **must** be set on acquire and cleared on release | [`../architecture/multi-tenancy.md`](../architecture/multi-tenancy.md) |
| Card data **never** touches JOL systems | [ADR-010](../adr/ADR-010-ecommerce-pci-saq-a.md) |
| AI inference is **self-hosted and air-gapped**; tenant data never trains shared models | [ADR-008](../adr/ADR-008-self-hosted-llm-air-gapped.md) |
| Spokes consume the hub **only** via versioned `@journeyoflife-org/*` packages | [ADR-011](../adr/ADR-011-hub-and-spoke-monorepo-federation.md) |
| ADRs are **immutable once Accepted** — supersede, never rewrite | [`../adr/README.md`](../adr/README.md) |
| This is a **public** repo — never commit personal data, secrets, or internal hostnames | [`../CONTRIBUTING.md`](../CONTRIBUTING.md) |

## Change History

| Version | Date | Author (role) | Change |
|---------|------|---------------|--------|
| 1.0.0 | 2026-09-25 | Platform Architect | Initial onboarding reading path. |
