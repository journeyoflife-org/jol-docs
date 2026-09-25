# Contributing to JOL Docs

This repository is the **Journey of Life (JOL) platform documentation hub** — a public repository
holding architecture decision records (ADRs), architecture diagrams, and GDPR Article 30 records of
processing. Contributions here change the authoritative description of how the platform is built
and how it processes personal data, so they follow a controlled, auditable lifecycle.

Please read [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md) and [`SECURITY.md`](SECURITY.md) before
contributing.

## Types of Contribution

| Type | Channel |
|------|---------|
| Propose or amend an ADR | See [`guides/adding-an-adr.md`](guides/adding-an-adr.md), then a pull request |
| Report a documentation gap, stale diagram, or missing record | [*Documentation Gap or Finding*](.github/ISSUE_TEMPLATE/documentation-gap-or-finding.yml) issue |
| Correct a record of processing or data-flow map | Pull request, with DPO review (CODEOWNERS) |
| Report a security vulnerability | **Private** channel only — see [`SECURITY.md`](SECURITY.md) |
| Fix typos, links, or formatting | Pull request directly |

## Documentation Change Lifecycle

1. **Raise an issue** describing the change and its driver (new decision, audit finding,
   regulatory change, or incident lesson).
2. **Open a draft pull request** against `main` from a branch named `docs/<doc-id>-<summary>`,
   `adr/<adr-id>-<summary>`, or `fix/<summary>`.
3. **Update the Document-Control block**: bump the version, set the new effective date, and add a
   Change-History row.
4. **Update the indexes**: if you add an ADR, update [`adr/README.md`](adr/README.md); if you add a
   document, update the root [`README.md`](README.md) index.
5. **Record the release** in [`CHANGELOG.md`](CHANGELOG.md).
6. **Review**: the document owner (via CODEOWNERS) reviews first; ADRs additionally require
   Platform Architect sign-off, and GDPR records require Data Protection Officer sign-off.
7. **Merge**: only after CI passes, reviews are complete, and commits are signed.

## ADR Conventions

- ADRs are **immutable once Accepted**: to change a decision, write a new ADR that supersedes the
  old one and set the old one's status to `Superseded by ADR-NNN`. Never rewrite history.
- Use the template at [`adr/template.md`](adr/template.md).
- Platform-wide ADRs are numbered in the central register; service-local ADRs stay in their own
  repository and are linked from [`adr/README.md`](adr/README.md).
- Every ADR states its **Status**, **Context**, **Decision**, **Consequences**, and **Evidence**
  (the code, config, or ticket that grounds it).

## Documentation Standards

- **Markdown lint clean** — run `make lint` (or `make check`) before pushing.
- **Document-Control block required** on every governance document (ADR, architecture doc, GDPR
  record).
- **Diagrams as Mermaid** — diagrams render natively on GitHub; keep the Mermaid source inline in
  the Markdown so it stays reviewable and diffable.
- **Roles, not names** — refer to owners and approvers by role (e.g. "Platform Architect", "Data
  Protection Officer"), never by personal name.
- **Traceability** — link decisions to the code/config that implements them, and link GDPR records
  to the lawful basis and retention rule that govern them.
- **Conventional Commits** — e.g. `docs(ADR-011): record hub-and-spoke federation decision`.

## Data Protection (GDPR)

This is a **public** repository. Never commit:

- Personal data or real institution/tenant identifiers.
- Credentials, keys, tokens, or other secrets (enforced by `detect-secrets` and GitHub secret
  scanning).
- Internal hostnames, IP addresses, network topology, or vendor contract terms.
- Real incident details or real data-subject requests.

Use synthetic examples only. The records of processing in [`gdpr/`](gdpr/README.md) describe
**categories** of data and **classes** of data subject, never individual records. Operational
privacy artefacts (DPIAs, data-subject-request logs) belong in the `jol-privacy` repository and
are **linked**, not duplicated.

## Local Quality Checks

```bash
make install   # install pre-commit + detect-secrets into .venv
make check     # run the full pre-commit suite against all files
make lint      # markdown lint only
make links     # link check only
make secrets   # secret scan against the baseline
```

## Licence

By contributing, you agree that your contributions will be licensed under
[CC-BY-4.0](LICENSE), consistent with the rest of the documentation hub.
