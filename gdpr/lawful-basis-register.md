# Lawful-Basis Register (GDPR Art. 6 & Art. 9)

## Document Control

| Field            | Value                              |
|------------------|------------------------------------|
| Document ID      | GDPR-LB-001                        |
| Title            | Lawful-Basis Register              |
| Version          | 1.0.0                              |
| Classification   | Public                             |
| Owner (role)     | Data Protection Officer            |
| Approver (role)  | JOL Governance Board               |
| Effective Date   | 2026-09-25                         |
| Next Review      | 2027-09-25                         |
| Review Cycle     | Annual, or upon material change    |

## Purpose

Every processing activity must have a documented lawful basis under **Art. 6**, and where
special-category data is involved, an additional condition under **Art. 9**. This register maps each
activity to its basis. As a rule:

- Where **JOL is controller** (platform accounts, billing, security), JOL determines the basis below.
- Where **JOL is processor** (tenant content/submissions), the **tenant controller** determines the
  basis; JOL records the typical basis and processes only on instruction (Art. 28(3)).

## Art. 6 Lawful Bases (reference)

| Code | Basis | Typical use on the platform |
|------|-------|------------------------------|
| 6(1)(a) | **Consent** | Marketing communications; optional cookies/analytics |
| 6(1)(b) | **Contract** | Account provisioning, delivering the service to the tenant, billing |
| 6(1)(c) | **Legal obligation** | Tax/financial retention, lawful requests |
| 6(1)(d) | **Vital interests** | Rare (e.g. emergency) |
| 6(1)(e) | **Public task** | Not relied upon by JOL |
| 6(1)(f) | **Legitimate interests** | Security, fraud prevention, platform analytics |

## Controller Activities (JOL determines basis)

| ID | Activity | Art. 6 basis | Rationale / LIA |
|----|----------|--------------|-----------------|
| C1 | Platform account provisioning & authentication | 6(1)(b) contract | Necessary to provide the service to the user/tenant |
| C2 | Account security, MFA, fraud/abuse prevention | 6(1)(f) legitimate interests | LIA: security of the platform; minimal intrusion; expected by users |
| C3 | Billing & commercial relationship | 6(1)(b) contract | Necessary for performance of the contract |
| C4 | Platform-level operational analytics (aggregate) | 6(1)(f) legitimate interests | LIA: service improvement; minimised/aggregated; opt-out where feasible |
| C5 | Transactional notifications | 6(1)(b) contract | Necessary for service operation |
| C6 | Marketing communications | 6(1)(a) consent | Explicit opt-in (`marketing_consent`); withdrawable at any time |
| C7 | Legal & compliance (tax, audit, law enforcement) | 6(1)(c) legal obligation | Statutory retention and disclosure duties |

## Processor Activities (tenant controller determines basis)

| ID | Activity | Typical Art. 6 basis (controller) | Art. 9 condition (if special category) |
|----|----------|-----------------------------------|----------------------------------------|
| P1 | Website hosting & content delivery | 6(1)(b) / 6(1)(f) (controller) | If religious content: 9(2)(a) consent / 9(2)(d) not-for-profit body / 9(2)(g) substantial public interest |
| P2 | Form & submission handling (funeral notices, memorials, service requests) | 6(1)(b) / 6(1)(a) (controller) | **Likely 9(2)(a) explicit consent** or 9(2)(d); controller-recorded |
| P3 | Donation & payment handling | 6(1)(b) (controller) | 9(2)(d) where donation reveals belief |
| P4 | CRM synchronisation | 6(1)(b) / 6(1)(f) (controller) | As per underlying record |
| P5 | AI content generation & retrieval | 6(1)(f) (controller) | 9(2)(a)/(d) where belief data used; minimised |
| P6 | Tenant analytics | 6(1)(f) (controller) | n/a (minimised) |
| P7 | Tenant user administration | 6(1)(b) (controller) | n/a |
| P8 | Notification dispatch | 6(1)(b) (controller) | n/a |

> **Processor obligation.** JOL does **not** choose or change the basis for tenant processing. It
> processes only on documented instruction (Art. 28(3)(a)) and must immediately inform the controller
> if an instruction would infringe GDPR (Art. 28(3)(h)).

## Art. 9 Special-Category Conditions (reference)

| Code | Condition | Applicability |
|------|-----------|---------------|
| 9(2)(a) | Explicit consent | Primary basis for belief-revealing submissions |
| 9(2)(d) | Not-for-profit body with a political/philosophical/religious aim | Religious institutions processing members' data |
| 9(2)(g) | Substantial public interest (with EU/member-state law) | Where applicable per country |
| 9(2)(e) | Data manifestly made public | Public memorial/notice content, case-by-case |

## Consent Management (Art. 7)

- Consent is **recorded with a timestamp** (`gdpr_consent_at`, `marketing_consent_at`) to evidence
  when and what was agreed (Art. 7(1)).
- Consent is **separate** for marketing vs. terms, **granular**, and **withdrawable** as easily as
  given (Art. 7(3)); withdrawal is logged.
- Where consent is the basis, a **DPIA** is typically required for special-category processing —
  maintained in `jol-privacy`.

## Legitimate-Interests Assessments (LIA)

For 6(1)(f) activities (C2, C4), a three-part test is documented in `jol-privacy`:
(i) **purpose test** (is there a legitimate interest?), (ii) **necessity test** (is processing
necessary?), (iii) **balancing test** (do the data subject's rights override?). Security (C2) and
minimised aggregate analytics (C4) pass with safeguards (least privilege, minimisation, opt-out).

## Change History

| Version | Date | Author (role) | Change |
|---------|------|---------------|--------|
| 1.0.0 | 2026-09-25 | Data Protection Officer | Initial lawful-basis register (Art. 6 + Art. 9). |
