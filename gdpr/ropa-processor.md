# Record of Processing — Processor (GDPR Art. 30(2))

## Document Control

| Field            | Value                              |
|------------------|------------------------------------|
| Document ID      | ROPA-P-001                         |
| Title            | Record of Processing — Processor   |
| Version          | 1.0.0                              |
| Classification   | Public                             |
| Owner (role)     | Data Protection Officer            |
| Approver (role)  | JOL Governance Board               |
| Effective Date   | 2026-09-25                         |
| Next Review      | 2027-09-25                         |
| Review Cycle     | Annual, or upon material change    |

## Purpose

This is the record of processing activities JOL performs **on behalf of tenant controllers**
(GDPR Art. 30(2)). For this data the **tenant institution is the controller** and determines the
purpose; **JOL is the processor** and acts only on documented instructions (Art. 28(3)). This is the
majority of personal data on the platform — the content and submissions flowing through ~400,000
tenant websites.

> Because JOL processes on behalf of a very large number of controllers, this record describes
> **categories** of controllers and processing rather than enumerating each. The register of
> individual controller relationships is maintained operationally in `jol-privacy`.

## (a) Processor & Controller Details

| Field | Value |
|-------|-------|
| Processor | Journey of Life (JOL) — `journeyoflife-org` |
| Controllers on whose behalf JOL acts | Tenant religious institutions and related organisations (parish, diocese, funeral, cemetery-care, memorial, etc.) established mainly in the EU |
| Data Protection Officer (processor) | Role: **Data Protection Officer** — `privacy@journeyoflife.org` |
| Processing agreement | Art. 28(3) Data Processing Agreement (DPA) executed with each tenant controller |

## (b) Categories of Processing on Behalf of Controllers

| # | Processing activity | Description | Special category (Art. 9)? |
|---|---------------------|-------------|----------------------------|
| P1 | Website hosting & content delivery | Serve tenant sites (10 verticals) to public visitors | Possibly — content may reveal religious belief |
| P2 | Form & submission handling | Capture visitor submissions (contact, funeral notices, service requests, memorial entries) | **Yes** — may reveal religious belief; may concern deceased/families |
| P3 | Donation & payment handling | Record donations/orders (tokens/events only; card data excluded per [ADR-010](../adr/ADR-010-ecommerce-pci-saq-a.md)) | Possibly (donations to religious bodies) |
| P4 | CRM synchronisation | Sync tenant contacts/leads/orders to Bitrix24 on tenant instruction | Possibly |
| P5 | AI content generation & retrieval | Generate/ground tenant content via air-gapped LLM + RAG ([ADR-008](../adr/ADR-008-self-hosted-llm-air-gapped.md), [ADR-009](../adr/ADR-009-mcp-tool-integration.md)) | Possibly — tenant-scoped, minimised |
| P6 | Tenant analytics | Per-tenant usage analytics on tenant instruction | No (minimised) |
| P7 | Tenant user administration | Manage tenant's own staff accounts and roles | No |
| P8 | Notification dispatch | Send tenant-initiated transactional notifications | No |

## Special-Category Data (Art. 9) — Processor Obligations

Processing of data revealing **religious belief** (and funeral/memorial data concerning deceased
persons and their families) occurs in tenant content and submissions (P1–P5). As **processor**, JOL:

- Acts **only on documented instruction** of the tenant controller (Art. 28(3)(a)), including for
  transfers; the **Art. 9(2) condition** (e.g. explicit consent, not-for-profit-body, or
  substantial-public-interest) is determined and recorded by the **controller**.
- Applies **heightened technical measures**: encryption at rest/in transit, strict RLS tenant
  isolation ([ADR-007](../adr/ADR-007-multi-tenant-rls-isolation.md)), least-privilege access, and
  data minimisation.
- **Does not** use tenant content (including special-category data) for JOL's own purposes, model
  training, or cross-tenant analytics.
- Assists the controller with DPIAs, DSARs, breach notification, and deletion (Art. 28(3)(e)–(f)).
- Ensures persons authorised to process are under **confidentiality obligations** (Art. 28(3)(b)).

> **Deceased persons.** GDPR does not apply to the data of the deceased as such, but (i) records
> about the deceased frequently contain **personal data of living relatives**, and (ii) some member
> states extend protections. Funeral/memorial processing is therefore handled with special-category
> care and is in scope of tenant DPIAs.

## (c) Third-Country Transfers (on Instruction)

JOL transfers personal data outside the EU/EEA **only** where necessary for a documented
sub-processor and only under Art. 46 safeguards (SCCs) or an adequacy decision, and only on
controller instruction (with advance notice of sub-processor changes per Art. 28(2)). See
[`international-transfers.md`](international-transfers.md).

## (d) Security Measures (Art. 32) — General Description

- **Encryption**: TLS in transit, encryption at rest (PostgreSQL), mTLS for AI tier.
- **Tenant isolation**: PostgreSQL RLS; tenant resolved at edge and propagated end-to-end
  ([`../architecture/multi-tenancy.md`](../architecture/multi-tenancy.md)).
- **Access control**: OIDC + RBAC, MFA, least-privilege, confidentiality obligations on personnel.
- **Air-gapped AI**: self-hosted inference; tenant content never trains shared models
  ([ADR-008](../adr/ADR-008-self-hosted-llm-air-gapped.md)).
- **Secrets & scanning**: managed secrets (`jol-secrets`), secret/dependency/SAST scanning
  (`jol-control`).
- **Auditability**: signed commits, branch protection, audit events on isolation failures and
  regulated tool calls (compliance MCP server).
- **Resilience**: backup/DR with RTO/RPO (`jol-dr`); erasure support via soft-delete + purge.

## Sub-Processors (Art. 28(2)/(4))

| Sub-processor | Function | Data | Safeguard |
|---------------|----------|------|-----------|
| Email/SMS provider | Notification dispatch | Minimised contact data | DPA + SCCs/adequacy |
| Bitrix24 (CRM) | Contact/lead/order sync | Tenant-scoped CRM data | DPA + SCCs/adequacy |
| Payment provider | Payment processing | Tokens/events (no PAN) | PCI-DSS + DPA |
| Object-storage / CDN (if used) | Media delivery | Tenant media | DPA + SCCs/adequacy |

The authoritative, current sub-processor list with transfer mechanics is
[`international-transfers.md`](international-transfers.md); operational notification of changes is
handled under each DPA.

## Change History

| Version | Date | Author (role) | Change |
|---------|------|---------------|--------|
| 1.0.0 | 2026-09-25 | Data Protection Officer | Initial Art. 30(2) processor record, including Art. 9 special-category obligations. |
