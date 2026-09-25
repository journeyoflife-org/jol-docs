# Architecture Documentation

## Document Control

| Field            | Value                              |
|------------------|------------------------------------|
| Document ID      | ARC-IDX-001                        |
| Title            | Architecture Documentation Index   |
| Version          | 1.0.0                              |
| Classification   | Public                             |
| Owner (role)     | Platform Architect                 |
| Approver (role)  | JOL Governance Board               |
| Effective Date   | 2026-09-25                         |
| Next Review      | 2027-09-25                         |
| Review Cycle     | Annual, or upon material change    |

This directory describes the architecture of the Journey of Life (JOL) platform using the
**C4 model** (Context → Container → Component) plus focused views for tenancy, data flow, and the
repository topology. All diagrams are authored in **Mermaid** so they render natively on GitHub and
stay reviewable in pull requests.

> **Diagrams are derived, code is truth.** Every diagram here is grounded in the repositories it
> describes. When architecture and diagram disagree, the diagram is stale — fix it via a PR
> (see [`../CONTRIBUTING.md`](../CONTRIBUTING.md)).

## Reading Order

| # | Audience | Read |
|---|----------|------|
| 1 | Everyone | [`system-landscape.md`](system-landscape.md) — the platform in its environment (C4 L1) |
| 2 | Engineers | [`container-diagram.md`](container-diagram.md) — deployable containers in the hub (C4 L2) |
| 3 | Engineers | [`hub-and-spoke.md`](hub-and-spoke.md) — how 10 verticals share one hub ([ADR-011](../adr/ADR-011-hub-and-spoke-monorepo-federation.md)) |
| 4 | Security / DPO | [`multi-tenancy.md`](multi-tenancy.md) — tenant isolation and RLS |
| 5 | Security / DPO | [`data-flow.md`](data-flow.md) — end-to-end request and data flows |
| 6 | Platform / governance | [`repo-map.md`](repo-map.md) — the 40-repository tier map |

## Document Map

| Document | C4 level | Purpose |
|----------|----------|---------|
| [`system-landscape.md`](system-landscape.md) | L1 Context | People, the platform, and external systems |
| [`container-diagram.md`](container-diagram.md) | L2 Container | Applications, datastores, and services inside the platform |
| [`hub-and-spoke.md`](hub-and-spoke.md) | L2 detail | The federation topology of ADR-011 |
| [`multi-tenancy.md`](multi-tenancy.md) | Cross-cutting | Tenant resolution, isolation, and RLS enforcement |
| [`data-flow.md`](data-flow.md) | Cross-cutting | Request lifecycle and personal-data flows |
| [`repo-map.md`](repo-map.md) | Cross-cutting | Repository tiers and ownership across the org |

## Related

- Decisions behind this architecture: [`../adr/README.md`](../adr/README.md)
- GDPR records of processing and data-flow maps: [`../gdpr/README.md`](../gdpr/README.md)
- Control mapping: [`../compliance/control-matrix.md`](../compliance/control-matrix.md)

## Change History

| Version | Date | Author (role) | Change |
|---------|------|---------------|--------|
| 1.0.0 | 2026-09-25 | Platform Architect | Initial architecture documentation set. |
