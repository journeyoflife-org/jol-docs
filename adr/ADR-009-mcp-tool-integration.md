# ADR-009: MCP Servers for Tool-Augmented AI

## Document Control

| Field            | Value                              |
|------------------|------------------------------------|
| Document ID      | ADR-009                            |
| Title            | MCP Servers for Tool-Augmented AI  |
| Version          | 1.0.0                              |
| Classification   | Public                             |
| Owner (role)     | Platform Architect                 |
| Approver (role)  | JOL Governance Board               |
| Effective Date   | 2026-09-25                         |
| Next Review      | 2027-09-25                         |
| Review Cycle     | Annual, or upon material change    |

## Status

Accepted

## Context

AI agents on the platform need to act on real systems — query the CRM, read tenant knowledge,
run compliance checks, access the database — rather than only generate text. Each integration
built ad hoc would duplicate authentication, authorisation, logging, and tenant-scoping logic, and
would be hard to audit.

The platform is self-hosted and air-gapped for AI (see
[ADR-008](ADR-008-self-hosted-llm-air-gapped.md)), so tool integrations must run inside JOL's
boundary and respect tenant isolation (see
[ADR-007](ADR-007-multi-tenant-rls-isolation.md)).

## Decision

- We will integrate AI agents with tools through the **Model Context Protocol (MCP)**, using a set
  of dedicated MCP servers rather than bespoke per-agent integrations.
- Each MCP server owns one capability domain and is independently deployable and testable. The
  initial servers are: `bitrix24` (CRM), `compliance`, `filesystem`, `git`, `postgres`, `shared`,
  and `web`.
- MCP servers run **inside the JOL boundary**; any server that reaches an external system does so
  through a controlled, logged egress path.
- Every MCP server **propagates the tenant context** and is subject to the same RLS isolation as
  the rest of the platform; a tool call can never access another tenant's data.
- Tool invocations are **authorised and logged**: the `compliance` MCP server enforces audit
  trails for regulated data operations.
- MCP servers are orchestrated and documented in the `jol-mcp-servers` repository; local
  development runs them via a dedicated compose stack.

## Consequences

### Positive

- One consistent, auditable integration surface for all AI tool access.
- Tenant isolation and authorisation are enforced uniformly, not re-implemented per agent.
- New capabilities are added by shipping a new MCP server, without touching agents.

### Negative

- MCP adds an indirection layer and a runtime dependency for AI features.
- Each server must be individually secured, scanned, and kept patched.
- The `postgres` and `filesystem` servers are high-privilege and require tight scoping and review.

### Neutral / follow-ups

- High-privilege servers (`postgres`, `filesystem`, `git`) need least-privilege credentials and
  are candidates for the secret-management design in `jol-secrets`.
- Tool-call audit logs feed the compliance evidence in `jol-compliance-evidence`.

## Evidence

- `jol-mcp-servers` repository: "Model Context Protocol servers for tool-augmented AI agent
  interactions."
- `jol-hub/README.md` (MCP Servers): servers `bitrix24`, `compliance`, `filesystem`, `git`,
  `postgres`, `shared`, `web`; stack at `/opt/jol/mcp-servers` via `docker-compose.mcp.yml`.
- Compliance audit trail: "The `compliance/` MCP server enforces audit trails for regulated data
  operations" (`jol-hub/README.md`, Compliance).

## Change History

| Version | Date | Author (role) | Change |
|---------|------|---------------|--------|
| 1.0.0 | 2026-09-25 | Platform Architect | Recorded retroactively from implemented architecture; status Accepted. |
