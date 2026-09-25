# Record of Processing — Controller (GDPR Art. 30(1))

## Document Control

| Field            | Value                              |
|------------------|------------------------------------|
| Document ID      | ROPA-C-001                         |
| Title            | Record of Processing — Controller  |
| Version          | 1.0.0                              |
| Classification   | Public                             |
| Owner (role)     | Data Protection Officer            |
| Approver (role)  | JOL Governance Board               |
| Effective Date   | 2026-09-25                         |
| Next Review      | 2027-09-25                         |
| Review Cycle     | Annual, or upon material change    |

## Purpose

This is the record of processing activities required by GDPR **Article 30(1)** for which
**Journey of Life (JOL) acts as the controller** — i.e. JOL determines the purposes and means.
This covers JOL's **own** processing: platform user accounts (tenant administrators), JOL's
commercial relationship with tenant institutions, security logging, and platform analytics.
Processing carried out **on behalf of** tenants is recorded separately in
[`ropa-processor.md`](ropa-processor.md).

> This record uses **categories**, never real individuals. Synthetic identifiers only.

## (a) Controller & Contact Details

| Field | Value |
|-------|-------|
| Controller | Journey of Life (JOL) — `journeyoflife-org` |
| Representative | (Art. 27) Not applicable — JOL is established in the EU |
| Data Protection Officer | Role: **Data Protection Officer** — contact `privacy@journeyoflife.org` |
| Security contact | Role: **Chief Information Security Officer** — `security@journeyoflife.org` |

## (b) Purposes of Processing

| # | Purpose | Lawful basis (Art. 6) | Special category (Art. 9)? |
|---|---------|-----------------------|----------------------------|
| C1 | Platform account provisioning & authentication for tenant administrators | Art. 6(1)(b) contract | No |
| C2 | Account security, MFA, fraud and abuse prevention | Art. 6(1)(f) legitimate interests | No |
| C3 | Billing, subscription, and commercial relationship with tenant institutions | Art. 6(1)(b) contract | No |
| C4 | Platform-level operational analytics (aggregate, minimised) | Art. 6(1)(f) legitimate interests | No |
| C5 | Transactional notifications (account, billing, security) | Art. 6(1)(b) contract | No |
| C6 | Marketing communications (only where opted in) | Art. 6(1)(a) consent | No |
| C7 | Legal obligation & compliance (tax, audit, law-enforcement) | Art. 6(1)(c) legal obligation | No |

> **Note on special-category data.** JOL-as-controller activities (C1–C7) do **not** intentionally
> process Art. 9 special-category data. Religious-belief data arises in **tenant content** processed
> as **processor** (see [`ropa-processor.md`](ropa-processor.md)), where the Art. 9 condition is
> determined by the tenant controller. The user account model itself stores no religious-belief field.

## (c) Categories of Data Subjects & Personal Data

| Data-subject class | Personal-data categories | Source |
|--------------------|--------------------------|--------|
| **Platform users** (tenant administrators, editors, viewers) | Identity (email, first/last name), Contact (phone), Authentication (password hash, MFA secret/flag), Profile (avatar, date of birth, preferred language, timezone, country), Role & permissions, Usage (last login IP, login count), Consent records (`gdpr_consent`, `marketing_consent` + timestamps), Lifecycle (soft-delete `is_deleted`/`deleted_at`) | Directly from the data subject at registration; from tenant institution on invitation |
| **Tenant-institution contacts** (billing/administrative) | Organization contact name, business email, business phone, billing address, VAT/tax ID | From the tenant institution (commercial relationship) |
| **Job applicants / correspondents** (if any) | Name, contact details, message content | Directly from the data subject |

The authoritative field-level inventory is [`data-inventory.md`](data-inventory.md), derived from the
platform `users` data model.

## (d) Categories of Recipients

| Recipient category | Purpose | Type |
|--------------------|---------|------|
| JOL platform operators (under instruction, least privilege) | Operation & support | Internal |
| Email/SMS provider | Transactional & marketing notifications | Processor (sub-processor) |
| Payment provider | Billing/payments | Controller/processor for its own PCI scope |
| CRM (Bitrix24) | Commercial relationship management | Processor (sub-processor) |
| Accounting/tax advisors, auditors | Legal & compliance | Independent recipients |
| Law enforcement / regulators | Legal obligation (Art. 6(1)(c)) | Independent recipients |

Sub-processors and their safeguards are listed in [`ropa-processor.md`](ropa-processor.md) and
[`international-transfers.md`](international-transfers.md).

## (e) Third-Country Transfers

Transfers outside the EU/EEA occur only via documented sub-processors (e.g. email, CRM, payment)
under Art. 46 safeguards (SCCs) or an adequacy decision. See
[`international-transfers.md`](international-transfers.md). Primary personal data is stored in
self-hosted EU PostgreSQL ([ADR-005](../adr/ADR-005-postgresql-primary-datastore.md)).

## (f) Envisaged Retention Periods

| Data category | Retention |
|---------------|-----------|
| Platform user account (active) | Duration of account + contract |
| Platform user account (erased) | Soft-delete immediately; hard purge per schedule |
| Billing/financial records | Statutory retention (e.g. tax: up to 10 years, per country) |
| Security logs (login IP, events) | Limited period per [`retention-schedule.md`](retention-schedule.md) |
| Marketing consent records | Duration of consent + proof-of-withdrawal period |

Full schedule: [`retention-schedule.md`](retention-schedule.md).

## (g) Security Measures (Art. 32) — General Description

- **Encryption**: TLS in transit; encryption at rest for PostgreSQL; mTLS for the AI tier
  ([ADR-008](../adr/ADR-008-self-hosted-llm-air-gapped.md)).
- **Access control**: OIDC authentication, RBAC, MFA support, least-privilege operator access.
- **Tenant isolation**: PostgreSQL Row-Level Security ([ADR-007](../adr/ADR-007-multi-tenant-rls-isolation.md)).
- **Secrets management**: no secrets in source; managed via `jol-secrets` (SOPS/vault design).
- **Vulnerability management**: secret scanning, dependency scanning, SAST across repos (`jol-control`).
- **Auditability**: signed commits, branch protection, audit events on isolation failures.
- **Resilience**: backup, DR, and RTO/RPO per `jol-dr`.

## Change History

| Version | Date | Author (role) | Change |
|---------|------|---------------|--------|
| 1.0.0 | 2026-09-25 | Data Protection Officer | Initial Art. 30(1) controller record. |
