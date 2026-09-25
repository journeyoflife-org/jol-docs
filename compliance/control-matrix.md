# Control-Mapping Matrix (SOC 2 ↔ ISO 27001 ↔ GDPR)

## Document Control

| Field            | Value                              |
|------------------|------------------------------------|
| Document ID      | CMP-MAP-001                        |
| Title            | Control-Mapping Matrix             |
| Version          | 1.0.0                              |
| Classification   | Public                             |
| Owner (role)     | Chief Information Security Officer |
| Approver (role)  | JOL Governance Board               |
| Effective Date   | 2026-09-25                         |
| Next Review      | 2027-09-25                         |
| Review Cycle     | Annual, or upon material change    |

## Purpose

This matrix crosswalks the three governing frameworks and points each control to the **artefact in
this hub** that documents it, and onward to the **evidence repository**. It lets an auditor trace a
control to its implementation without reading source code.

> The authoritative policy crosswalk for the ISMS suite lives in
> [`jol-policies/docs/control-mapping-matrix.md`](https://github.com/journeyoflife-org/jol-policies/blob/main/docs/control-mapping-matrix.md).
> This matrix is **architecture- and data-focused** (the jol-docs complement).

## Crosswalk

| Control area | SOC 2 (TSC) | ISO/IEC 27001:2022 | GDPR | Artefact in this hub | Evidence |
|--------------|-------------|--------------------|------|----------------------|----------|
| Governance & documented information | CC1.1, CC2.1 | cl. 7.5, A.5.1 | Art. 24 | [`../adr/README.md`](../adr/README.md), Document-Control blocks | `jol-policies` |
| Risk assessment | CC3.1–CC3.4 | cl. 6.1, A.5.9 | Art. 35 (DPIA) | [`../gdpr/README.md`](../gdpr/README.md) (Art. 9 risk) | `jol-privacy` |
| Tenant isolation / logical access | CC6.1, CC6.3 | A.5.15, A.8.3 | Art. 5(1)(f), Art. 32 | [ADR-007](../adr/ADR-007-multi-tenant-rls-isolation.md), [`../architecture/multi-tenancy.md`](../architecture/multi-tenancy.md) | `jol-compliance-evidence` |
| Identity & authentication | CC6.1, CC6.2, CC6.3 | A.5.16, A.8.5 | Art. 32 | [`../architecture/container-diagram.md`](../architecture/container-diagram.md) (jol-auth) | `jol-auth` |
| Encryption / confidentiality | CC6.1, CC6.7 | A.8.24 | Art. 32(1)(a) | [ADR-005](../adr/ADR-005-postgresql-primary-datastore.md), [ADR-008](../adr/ADR-008-self-hosted-llm-air-gapped.md) | `jol-secrets` |
| Secrets management | CC6.1, CC6.7 | A.5.17, A.8.24 | Art. 32 | [ADR-009](../adr/ADR-009-mcp-tool-integration.md) (privileged tools) | `jol-secrets` |
| Change management | CC8.1 | A.8.32 | Art. 25 | ADR immutability rule, [`../guides/adding-an-adr.md`](../guides/adding-an-adr.md) | `jol-control` |
| Secure development lifecycle | CC7.1, CC8.1 | A.8.25, A.8.28 | Art. 25 | [ADR-011](../adr/ADR-011-hub-and-spoke-monorepo-federation.md), [`../architecture/hub-and-spoke.md`](../architecture/hub-and-spoke.md) | `jol-control` |
| Data inventory / records of processing | CC2.1 | A.5.12 | Art. 30(1)/(2) | [`../gdpr/ropa-controller.md`](../gdpr/ropa-controller.md), [`../gdpr/ropa-processor.md`](../gdpr/ropa-processor.md), [`../gdpr/data-inventory.md`](../gdpr/data-inventory.md) | `jol-privacy` |
| Lawful basis | CC2.1 | A.5.12 | Art. 6, Art. 9 | [`../gdpr/lawful-basis-register.md`](../gdpr/lawful-basis-register.md) | `jol-privacy` |
| Data minimisation & purpose limitation | CC6.1 | A.5.12 | Art. 5(1)(b),(c) | [`../gdpr/data-inventory.md`](../gdpr/data-inventory.md), [`../gdpr/data-flow-maps.md`](../gdpr/data-flow-maps.md) | `jol-privacy` |
| Retention / storage limitation | CC6.5 | A.5.33 | Art. 5(1)(e), Art. 17 | [`../gdpr/retention-schedule.md`](../gdpr/retention-schedule.md) | `jol-privacy` |
| International transfers | CC6.7 (confidentiality) | A.5.34 | Art. 44–49 | [`../gdpr/international-transfers.md`](../gdpr/international-transfers.md) | `jol-privacy` |
| Third-party / supplier management | CC3.4, CC9.2 | A.5.19–A.5.22 | Art. 28 | [`../gdpr/ropa-processor.md`](../gdpr/ropa-processor.md) (sub-processors) | `jol-policies` |
| Payment-card scope | CC6.1, CC9.2 | A.5.18 | Art. 32 | [ADR-010](../adr/ADR-010-ecommerce-pci-saq-a.md) | `jol-payments-scope` |
| AI governance | CC2.1, CC3.2 | A.5.8, A.8.28 | Art. 22, Art. 35 | [ADR-008](../adr/ADR-008-self-hosted-llm-air-gapped.md), [ADR-009](../adr/ADR-009-mcp-tool-integration.md) | `jol-privacy` |
| Data flows / architecture | CC2.1 | A.5.9 | Art. 30 | [`../architecture/data-flow.md`](../architecture/data-flow.md), [`../gdpr/data-flow-maps.md`](../gdpr/data-flow-maps.md) | `jol-compliance-evidence` |
| Monitoring & anomaly detection | CC7.1–CC7.4 | A.8.16 | Art. 32 | [`../architecture/multi-tenancy.md`](../architecture/multi-tenancy.md) (isolation audit events) | `jol-compliance-evidence` |
| Incident management | CC7.3–CC7.5 | A.5.24–A.5.28 | Art. 33, Art. 34 | (linked) | `jol-incident-response` |
| Resilience / DR / RTO-RPO | A1.1, A1.2 | A.5.29, A.8.14 | Art. 32(1)(b),(c) | (linked) | `jol-dr` |
| Repo-level enforced controls | CC7.1, CC8.1 | A.8.32 | Art. 25 | [`../architecture/repo-map.md`](../architecture/repo-map.md) | `jol-control` |

## Framework Reference Versions

| Framework | Version / reference |
|-----------|---------------------|
| SOC 2 | Trust Services Criteria (2017, with 2022 revisions) |
| ISO/IEC 27001 | 2022 (Annex A control set) |
| GDPR | Regulation (EU) 2016/679 |
| PCI-DSS | 4.0 (see [ADR-010](../adr/ADR-010-ecommerce-pci-saq-a.md), `jol-payments-scope`) |

## Reading Guide for Auditors

1. **Start** at the relevant framework column above.
2. **Open** the linked artefact in this hub (the architectural/data description).
3. **Follow** to the evidence repository for implementation proof (logs, configs, test results).
4. **Verify** the Document-Control block on each artefact for version, owner (role), and review date.

## Change History

| Version | Date | Author (role) | Change |
|---------|------|---------------|--------|
| 1.0.0 | 2026-09-25 | Chief Information Security Officer | Initial SOC 2 ↔ ISO 27001 ↔ GDPR architecture/data crosswalk. |
