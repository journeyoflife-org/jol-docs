# ADR-010: E-Commerce Payments Scoped to PCI-DSS SAQ A

## Document Control

| Field            | Value                              |
|------------------|------------------------------------|
| Document ID      | ADR-010                            |
| Title            | E-Commerce Payments Scoped to PCI-DSS SAQ A |
| Version          | 1.0.0                              |
| Classification   | Public                             |
| Owner (role)     | Platform Architect / Chief Information Security Officer |
| Approver (role)  | JOL Governance Board               |
| Effective Date   | 2026-09-25                         |
| Next Review      | 2027-09-25                         |
| Review Cycle     | Annual, or upon material change    |

## Status

Accepted

## Context

The platform sells products, service offerings, and accepts donations across 27 EU countries, with
VAT handling. Accepting card payments brings the platform into PCI-DSS scope. Full PCI-DSS
compliance (SAQ D / on-premise) is extremely costly for a small team, and any system that stores,
processes, or transmits cardholder data (the CDE) must be tightly bounded.

The goal is to **minimise the CDE** so that JOL systems never touch raw primary account numbers
(PAN), keeping eligibility for the lightest merchant questionnaire, **SAQ A** (cardholder data
entirely outsourced to a PCI-validated third party via iframe/redirect/hosted fields).

## Decision

- We will keep JOL systems **out of the cardholder-data path**: no PAN, no card data on JOL
  servers, logs, databases, or backups.
- Card entry is handled by a **PCI-validated third-party payment provider** via hosted fields /
  redirect / iframe, so the buyer's browser talks to the provider, not to JOL.
- JOL stores only **payment events and tokens/references** (e.g. provider charge IDs, status,
  amounts, VAT) in the `payment_events` and `financial` apps — never card data.
- The CDE boundary is documented and maintained in the `jol-payments-scope` repository; anything
  inside the boundary is minimal and explicitly justified.
- The e-commerce engine (`jol-ecommerce-engine`) handles catalog, offerings, VAT, and order
  lifecycle, and integrates with the payment provider only through tokens/webhooks.
- Any future change that would bring JOL into the card-data path requires a new ADR and a
  re-assessment of SAQ eligibility.

## Consequences

### Positive

- SAQ A eligibility drastically reduces PCI-DSS burden versus SAQ D.
- No cardholder data in JOL systems reduces breach impact and simplifies GDPR/PCI interaction.
- A small, documented CDE is easy to audit and defend.

### Negative

- Dependency on a third-party payment provider (a sub-processor that must be tracked under GDPR
  Art. 28 and the transfer register).
- Less control over the checkout UX (hosted fields/redirect constraints).
- Webhook-based reconciliation must be idempotent and securely authenticated.

### Neutral / follow-ups

- The payment provider must be listed in [`../gdpr/ropa-processor.md`](../gdpr/ropa-processor.md)
  and [`../gdpr/international-transfers.md`](../gdpr/international-transfers.md) if it transfers
  data outside the EU.
- CDE boundary diagrams and SAQ evidence live in `jol-payments-scope`.

## Evidence

- `jol-payments-scope` repository: "PCI-DSS scope definition, CDE boundaries, and payment-card
  data-flow documentation."
- `jol-ecommerce-engine` repository: "product catalogs, service offerings, payments, VAT"
  (PCI-DSS SAQ A noted in `jol-hub/README.md`).
- Backend apps `payment_events` and `financial` store payment events/records, not card data
  (`jol-hub/backend/django/apps/payment_events`, `.../financial`).
- Card-provider residue removal tracked in `jol-hub` branch `step-18-stripe-residue-purge`
  (keeping raw provider/card handling out of the codebase).

## Change History

| Version | Date | Author (role) | Change |
|---------|------|---------------|--------|
| 1.0.0 | 2026-09-25 | Platform Architect | Recorded retroactively from implemented architecture; status Accepted. |
