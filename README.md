# JOL Docs — Platform Knowledge & Architecture Hub

The **documentation hub** for the **Journey of Life (JOL)** platform. It is the single,
authoritative source for architecture decision records (ADRs), architecture diagrams, and the
GDPR Article 30 records of processing (RoPA) and data-flow maps that describe how JOL processes
personal data across approximately **400,000 religious-institution websites in 27 EU member
states**.

This repository exists to **de-silo knowledge that currently lives only in code**. Every
architectural decision, data flow, and processing activity is documented here so that engineers,
auditors, and regulators can understand the platform without reading the source first.

## Why This Repository

| Problem | How jol-docs solves it |
|---------|------------------------|
| Decisions buried in code and commit messages | Canonical **ADR registry** with status, context, and consequences |
| No single architecture view across 40 repos | **C4-model diagrams** (landscape → container) and a repo tier map |
| GDPR Art. 30 records scattered or missing | Central **RoPA** (controller + processor) and **data-flow maps** |
| Compliance evidence hard to locate | **Control matrix** crosswalking SOC 2 ↔ ISO 27001 ↔ GDPR |

## Compliance Coverage

| Framework | Scope in this repository |
|-----------|--------------------------|
| **GDPR (EU 2016/679)** | Art. 30 records of processing, Art. 6 lawful basis, Art. 5 principles, data-flow mapping, retention, international transfers |
| **ISO/IEC 27001:2022** | Annex A controls A.5.x (organisational), A.8.x (technological); documented-information requirements (cl. 7.5) |
| **SOC 2 (TSC)** | CC2 (Communication & Information), CC3 (Risk Assessment), CC5 (Control Activities), CC8 (Change Management) |

## Documentation Index

### Architecture Decision Records — [`adr/`](adr/README.md)

The canonical platform-wide ADR register. Service-local ADRs (e.g. `jol-auth/docs/ADR/`) remain in
their repositories and are indexed here.

| ADR | Title | Status |
|-----|-------|--------|
| [ADR-005](adr/ADR-005-postgresql-primary-datastore.md) | PostgreSQL as Primary Datastore | Accepted |
| [ADR-006](adr/ADR-006-django-modular-monolith.md) | Django Modular Monolith for the Platform Backend | Accepted |
| [ADR-007](adr/ADR-007-multi-tenant-rls-isolation.md) | Multi-Tenant Isolation via Row-Level Security | Accepted |
| [ADR-008](adr/ADR-008-self-hosted-llm-air-gapped.md) | Self-Hosted, Air-Gapped LLM Platform | Accepted |
| [ADR-009](adr/ADR-009-mcp-tool-integration.md) | MCP Servers for Tool-Augmented AI | Accepted |
| [ADR-010](adr/ADR-010-ecommerce-pci-saq-a.md) | E-Commerce Payments Scoped to PCI-DSS SAQ A | Accepted |
| [ADR-011](adr/ADR-011-hub-and-spoke-monorepo-federation.md) | Hub-and-Spoke Monorepo Federation | Accepted |

### Architecture — [`architecture/`](architecture/README.md)

| Document | Purpose |
|----------|---------|
| [`system-landscape.md`](architecture/system-landscape.md) | C4 Level 1 — the platform in its environment |
| [`container-diagram.md`](architecture/container-diagram.md) | C4 Level 2 — deployable containers inside jol-hub |
| [`hub-and-spoke.md`](architecture/hub-and-spoke.md) | ADR-011 visualised — hub ↔ 10 site spokes |
| [`multi-tenancy.md`](architecture/multi-tenancy.md) | Tenant isolation and RLS model |
| [`data-flow.md`](architecture/data-flow.md) | End-to-end request and data flows |
| [`repo-map.md`](architecture/repo-map.md) | The 40-repository tier map |

### GDPR / Privacy — [`gdpr/`](gdpr/README.md)

| Document | Purpose |
|----------|---------|
| [`ropa-controller.md`](gdpr/ropa-controller.md) | Art. 30(1) record of processing (controller) |
| [`ropa-processor.md`](gdpr/ropa-processor.md) | Art. 30(2) record of processing (processor) |
| [`data-inventory.md`](gdpr/data-inventory.md) | Personal-data categories and sources |
| [`lawful-basis-register.md`](gdpr/lawful-basis-register.md) | Art. 6 lawful basis per activity |
| [`data-flow-maps.md`](gdpr/data-flow-maps.md) | Data-flow diagrams per processing activity |
| [`retention-schedule.md`](gdpr/retention-schedule.md) | Retention periods and erasure |
| [`international-transfers.md`](gdpr/international-transfers.md) | Art. 44–49 transfers and SCCs |

### Compliance & Guides

| Document | Purpose |
|----------|---------|
| [`compliance/control-matrix.md`](compliance/control-matrix.md) | SOC 2 ↔ ISO 27001 ↔ GDPR crosswalk |
| [`guides/onboarding.md`](guides/onboarding.md) | New-engineer onboarding path |
| [`guides/adding-an-adr.md`](guides/adding-an-adr.md) | How to author and register an ADR |

## Document Control

Every document carries a Document-Control block stating its ID, version, classification, owner
(by **role**, never by personal name), approver, effective date, and next-review date. Documents
are classified **Public**, **Internal**, or **Confidential** per the
[JOL Data Classification & Handling Policy](https://github.com/journeyoflife-org/jol-policies/blob/main/policies/data-classification-and-handling.md).

## Related JOL Repositories

| Repository | Relationship |
|------------|--------------|
| [`jol-policies`](https://github.com/journeyoflife-org/jol-policies) | ISMS policy suite — this repo links to, does not duplicate, policies |
| [`jol-privacy`](https://github.com/journeyoflife-org/jol-privacy) | DPIAs and data-subject rights — operational privacy artefacts |
| [`jol-control`](https://github.com/journeyoflife-org/jol-control) | Terraform control plane managing all 40 repositories |
| [`jol-hub`](https://github.com/journeyoflife-org/jol-hub) | The integration monorepo (the "hub" in ADR-011) |
| [`jol-compliance-evidence`](https://github.com/journeyoflife-org/jol-compliance-evidence) | Control evidence collection |

## Reporting a Security Vulnerability

**Do not open a public issue for security vulnerabilities.** See [`SECURITY.md`](SECURITY.md) for
the private disclosure channel, response SLAs, and severity classification.

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for the documentation change lifecycle, ADR authoring
workflow, and data-protection rules for this public repository.

## Licence

The documentation in this repository is licensed under
[CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/). See [`LICENSE`](LICENSE).
