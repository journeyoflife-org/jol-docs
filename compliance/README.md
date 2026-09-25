# Compliance Documentation

## Document Control

| Field            | Value                              |
|------------------|------------------------------------|
| Document ID      | CMP-IDX-001                        |
| Title            | Compliance Documentation Index     |
| Version          | 1.0.0                              |
| Classification   | Public                             |
| Owner (role)     | Chief Information Security Officer |
| Approver (role)  | JOL Governance Board               |
| Effective Date   | 2026-09-25                         |
| Next Review      | 2027-09-25                         |
| Review Cycle     | Annual, or upon material change    |

This directory maps the platform's architecture and data-processing documentation to the three
governing frameworks — **SOC 2 (Trust Services Criteria)**, **ISO/IEC 27001:2022**, and **GDPR** —
so that an auditor can trace from a control to the artefact that evidences it.

## Scope & Sources of Truth

This hub **documents and links**; it does not duplicate the authoritative artefacts, which live in
dedicated repositories:

| Concern | Authoritative repository |
|---------|--------------------------|
| ISMS policies | [`jol-policies`](https://github.com/journeyoflife-org/jol-policies) |
| Control evidence | [`jol-compliance-evidence`](https://github.com/journeyoflife-org/jol-compliance-evidence) |
| DPIAs, DSRs, breaches | [`jol-privacy`](https://github.com/journeyoflife-org/jol-privacy) |
| PCI-DSS scope / CDE | [`jol-payments-scope`](https://github.com/journeyoflife-org/jol-payments-scope) |
| Repo-level enforced controls | [`jol-control`](https://github.com/journeyoflife-org/jol-control) |
| Disaster recovery / RTO-RPO | [`jol-dr`](https://github.com/journeyoflife-org/jol-dr) |
| Incident response | [`jol-incident-response`](https://github.com/journeyoflife-org/jol-incident-response) |

## Documents

| Document | Purpose |
|----------|---------|
| [`control-matrix.md`](control-matrix.md) | SOC 2 ↔ ISO 27001 ↔ GDPR crosswalk, mapped to this hub's ADRs and records |

## How to Use the Matrix

1. Find the control your audit asks about (SOC 2 CC, ISO 27001 A.x, or GDPR Article).
2. Follow the link to the **artefact** in this hub (ADR, architecture view, or GDPR record).
3. From there, follow to the **evidence** repository for implementation proof.

## Change History

| Version | Date | Author (role) | Change |
|---------|------|---------------|--------|
| 1.0.0 | 2026-09-25 | Chief Information Security Officer | Initial compliance index. |
