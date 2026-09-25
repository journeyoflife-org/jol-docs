# Changelog

All notable changes to the JOL platform documentation hub are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this repository
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html). Individual document
versions are tracked in each document's Document-Control block; this changelog records releases of
the hub as a whole.

## [1.0.0] - 2026-09-25

### Added

- Initial release of the JOL platform documentation hub (`jol-docs`).
- **ADR registry** (`adr/`): canonical platform-wide architecture decision records, including the
  previously-referenced-but-undocumented `ADR-011` Hub-and-Spoke Monorepo Federation, plus
  `ADR-005` (PostgreSQL), `ADR-006` (Django modular monolith), `ADR-007` (multi-tenant RLS),
  `ADR-008` (self-hosted air-gapped LLM), `ADR-009` (MCP tool integration), and `ADR-010`
  (PCI-DSS SAQ A e-commerce scope). Service-local ADRs are indexed, not duplicated.
- **Architecture** (`architecture/`): C4 Level-1 system landscape, C4 Level-2 container diagram,
  hub-and-spoke federation view, multi-tenancy/RLS model, end-to-end data-flow, and the
  40-repository tier map — all rendered as Mermaid.
- **GDPR / Privacy** (`gdpr/`): Art. 30(1) controller and Art. 30(2) processor records of
  processing, personal-data inventory, Art. 6 lawful-basis register, per-activity data-flow maps,
  retention & erasure schedule, and Art. 44–49 international-transfer register.
- **Compliance** (`compliance/`): SOC 2 ↔ ISO/IEC 27001:2022 ↔ GDPR control-mapping matrix.
- **Guides** (`guides/`): engineer onboarding path and ADR authoring workflow.
- Repository governance: `README`, `SECURITY`, `CONTRIBUTING`, `CODE_OF_CONDUCT`, and `LICENSE`
  (CC-BY-4.0).
- Documentation CI (`docs-ci.yml`) and documentation-control CI (`compliance-check.yml`).
- Pre-commit configuration (markdown linting, secret detection, whitespace/tab/CRLF hygiene).

[1.0.0]: https://github.com/journeyoflife-org/jol-docs/releases/tag/v1.0.0
