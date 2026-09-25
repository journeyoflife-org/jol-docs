# ADR-008: Self-Hosted, Air-Gapped LLM Platform

## Document Control

| Field            | Value                              |
|------------------|------------------------------------|
| Document ID      | ADR-008                            |
| Title            | Self-Hosted, Air-Gapped LLM Platform |
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

The platform uses AI for content generation, SEO tagging, lead scoring, chatbots, and
retrieval-augmented generation over tenant knowledge. These features process personal data and
tenant-confidential content. Sending prompts to a third-party hosted LLM API would:

- Transfer personal data to a non-EU sub-processor, triggering GDPR Art. 44–49 transfer
  obligations and a DPIA for every AI feature.
- Risk tenant-confidential content being used for third-party model training.
- Create an availability dependency outside JOL's control.

JOL runs its own Proxmox bare-metal infrastructure and requires ISO 27001 / GDPR compliance for the
AI layer.

## Decision

- We will run LLM inference **self-hosted on JOL bare metal** (Ollama), not via third-party hosted
  APIs, for any workload that touches personal or tenant-confidential data.
- The inference platform is **air-gapped** from the public internet; model weights are pulled
  through a controlled, logged egress path and scanned before use.
- Service-to-inference traffic is authenticated and encrypted with **mTLS**.
- Retrieval-augmented generation is served by a dedicated `jol-rag-server` that grounds responses
  in tenant-scoped knowledge only; retrieval is tenant-isolated per
  [ADR-007](ADR-007-multi-tenant-rls-isolation.md).
- Prompts and completions that contain personal data are treated as personal data: logged
  minimally, retained per the retention schedule, and never used to train shared models.
- A third-party hosted LLM may be used only for non-personal, non-confidential workloads, and only
  after a DPIA and a recorded transfer basis.

## Consequences

### Positive

- Personal and tenant-confidential data never leaves JOL's EU infrastructure for inference.
- No third-party training on tenant content; strong confidentiality (SOC 2 CC6, ISO 27001 A.8).
- Air-gapping reduces the attack surface and supply-chain exposure of the model tier.

### Negative

- JOL bears the full cost of GPU/CPU capacity, model updates, and patching.
- Air-gapping makes model weight updates a deliberate, logged supply-chain operation.
- Self-hosted models may trail frontier hosted models in capability.

### Neutral / follow-ups

- Requires a model-provenance and scanning procedure (supply chain, ISO 27001 A.8.28).
- DPIAs for AI features are maintained in `jol-privacy`.

## Evidence

- `jol-llm` repository: "Self-hosted, air-gapped LLM platform — Ollama on bare metal with mTLS,
  ISO 27001/GDPR compliant."
- `jol-rag-server` repository: "Retrieval-Augmented Generation server for knowledge-grounded AI
  responses."
- AI modules: `jol-hub/ai/` (content-generation, seo-tagging, lead-scoring, chatbot) and
  `jol-analytics-ai`; MCP tool layer in `jol-mcp-servers` (see
  [ADR-009](ADR-009-mcp-tool-integration.md)).

## Change History

| Version | Date | Author (role) | Change |
|---------|------|---------------|--------|
| 1.0.0 | 2026-09-25 | Platform Architect | Recorded retroactively from implemented architecture; status Accepted. |
