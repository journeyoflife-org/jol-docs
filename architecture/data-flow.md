# End-to-End Data Flow

## Document Control

| Field            | Value                              |
|------------------|------------------------------------|
| Document ID      | ARC-DF-001                         |
| Title            | End-to-End Data Flow               |
| Version          | 1.0.0                              |
| Classification   | Public                             |
| Owner (role)     | Platform Architect / Data Protection Officer |
| Approver (role)  | JOL Governance Board               |
| Effective Date   | 2026-09-25                         |
| Next Review      | 2027-09-25                         |
| Review Cycle     | Annual, or upon material change    |

## Purpose

This view traces how data moves through the platform for the principal processing activities. It is
the architectural counterpart to the GDPR data-flow maps in
[`../gdpr/data-flow-maps.md`](../gdpr/data-flow-maps.md); together they satisfy GDPR Art. 30 and
support DPIAs.

## Flow 1 — Public Visitor Submits a Form (e.g. funeral notice, contact)

```mermaid
sequenceDiagram
  participant V as Visitor (data subject)
  participant S as Site spoke (Next.js)
  participant A as jol-auth
  participant API as Platform API
  participant DB as PostgreSQL (RLS)
  participant CRM as Bitrix24 (via integration)
  participant M as Email provider

  V->>S: submit form (personal data)
  S->>S: resolve tenant (subdomain/X-Tenant-ID)
  S->>API: POST submission (tenant-scoped)
  API->>DB: INSERT (RLS: tenant_id = current)
  API->>CRM: sync contact/lead (minimised fields)
  API->>M: transactional confirmation (minimised)
  API-->>S: 201 accepted
  S-->>V: confirmation
  Note over API,DB: lawful basis + retention recorded in RoPA
```

| Step | Data | GDPR note |
|------|------|-----------|
| Form submit | Name, email, message, (optional) special-category | Lawful basis recorded per activity ([`../gdpr/lawful-basis-register.md`](../gdpr/lawful-basis-register.md)) |
| DB insert | Stored tenant-scoped | RLS isolation ([`multi-tenancy.md`](multi-tenancy.md)) |
| CRM sync | Minimised contact fields | Bitrix24 is a sub-processor ([`../gdpr/ropa-processor.md`](../gdpr/ropa-processor.md)) |
| Email | Minimised content | Email provider is a sub-processor |

## Flow 2 — Tenant Administrator Manages Content

```mermaid
sequenceDiagram
  participant TA as Tenant admin
  participant AD as admin-dashboard
  participant A as jol-auth
  participant API as Platform API
  participant DB as PostgreSQL (RLS)

  TA->>AD: sign in
  AD->>A: OIDC authentication
  A-->>AD: id_token (+ tenant claim, role)
  TA->>AD: edit/publish content
  AD->>API: request + Authorization + X-Tenant-ID
  API->>API: verify tenant membership + role (RBAC)
  API->>DB: SET app.current_tenant; write (RLS)
  DB-->>API: ok
  API-->>AD: 200
```

## Flow 3 — AI-Assisted Content Generation (air-gapped)

```mermaid
sequenceDiagram
  participant TA as Tenant admin
  participant API as Platform API
  participant RAG as jol-rag-server
  participant LLM as jol-llm (Ollama, mTLS)
  participant MCP as jol-mcp-servers
  participant DB as PostgreSQL (RLS)

  TA->>API: request AI draft
  API->>RAG: retrieve tenant-scoped context (RLS)
  RAG->>DB: grounded query (tenant only)
  DB-->>RAG: tenant knowledge
  API->>LLM: prompt (minimised, tenant-scoped) over mTLS
  LLM-->>API: completion
  API->>MCP: optional tool call (tenant-propagated)
  MCP->>DB: authorised, logged access
  API-->>TA: draft (no personal data in shared model training)
```

> Prompts/completions containing personal data are treated as personal data: minimised, logged
> sparingly, retained per schedule, and **never** used to train shared models
> ([ADR-008](../adr/ADR-008-self-hosted-llm-air-gapped.md)).

## Flow 4 — Payment / Donation (PCI SAQ A)

```mermaid
sequenceDiagram
  participant V as Donor/buyer
  participant S as Site spoke
  participant PAY as Payment provider (hosted fields)
  participant API as Platform API
  participant DB as PostgreSQL

  V->>S: checkout / donate
  S->>PAY: browser submits card to provider (hosted fields)
  PAY-->>S: token / charge reference
  S->>API: confirm order (token only)
  API->>DB: store payment_event (token, amount, VAT, status)
  API-->>S: confirmation
  Note over S,DB: card data never touches JOL systems (ADR-010)
```

## Data Stores & Personal Data

| Store | Personal data? | Isolation | Retention |
|-------|----------------|-----------|-----------|
| PostgreSQL | Yes (users, contacts, submissions, orders) | RLS per tenant | [`../gdpr/retention-schedule.md`](../gdpr/retention-schedule.md) |
| Redis | Ephemeral (sessions, cache) | TTL + tenant-scoped keys | Short-lived; not a system of record |
| Object storage (media) | Possibly (avatars, uploads) | Tenant-scoped paths | Per retention schedule |
| Logs / telemetry | Minimised; no special-category | Tenant tag where applicable | Per retention schedule |

## Trust Boundaries

```mermaid
graph LR
  subgraph EU["JOL EU boundary (Proxmox, self-hosted)"]
    FE["Frontends"]
    API["API"]
    AI["AI tier (air-gapped)"]
    DB[("PostgreSQL")]
  end
  PAY["Payment provider"]
  CRM["Bitrix24"]
  MAIL["Email/SMS"]

  FE --> API --> DB
  API --> AI
  API -. sub-processor .-> CRM
  API -. sub-processor .-> MAIL
  FE -. browser->hosted fields .-> PAY
```

Cross-boundary flows to sub-processors are recorded in
[`../gdpr/ropa-processor.md`](../gdpr/ropa-processor.md) and
[`../gdpr/international-transfers.md`](../gdpr/international-transfers.md).

## Compliance Anchors

| Framework | Relevance |
|-----------|-----------|
| GDPR Art. 30 | Each flow is a processing activity in the RoPA |
| GDPR Art. 35 | Flows inform DPIAs (held in `jol-privacy`) |
| SOC 2 CC6 | Data flow crosses defined trust boundaries with access control |
| PCI-DSS | Card data excluded from JOL systems ([ADR-010](../adr/ADR-010-ecommerce-pci-saq-a.md)) |

## Change History

| Version | Date | Author (role) | Change |
|---------|------|---------------|--------|
| 1.0.0 | 2026-09-25 | Platform Architect | Initial end-to-end data-flow view. |
