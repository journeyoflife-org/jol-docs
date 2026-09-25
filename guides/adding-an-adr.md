# Adding an Architecture Decision Record (ADR)

## Document Control

| Field            | Value                              |
|------------------|------------------------------------|
| Document ID      | GDE-ADR-001                        |
| Title            | Adding an ADR                      |
| Version          | 1.0.0                              |
| Classification   | Public                             |
| Owner (role)     | Platform Architect                 |
| Approver (role)  | JOL Governance Board               |
| Effective Date   | 2026-09-25                         |
| Next Review      | 2027-09-25                         |
| Review Cycle     | Annual, or upon material change    |

## When to Write an ADR

Write an ADR when a decision is **hard to reverse** and **affects the platform broadly** — for
example a change to the data model, tenancy, security posture, the AI tier, payment scope, or the
repository topology. Do **not** write an ADR for routine implementation choices that are easily
changed and local to one module.

| Decision is... | Record it as |
|----------------|--------------|
| Platform-wide, hard to reverse | **ADR in this registry** (`jol-docs/adr/`) |
| Local to one service's internals | Service-local ADR in that repo, **indexed** in [`../adr/README.md`](../adr/README.md) |
| A policy or standard (not a decision) | Policy in [`jol-policies`](https://github.com/journeyoflife-org/jol-policies) |
| A runbook or procedure | Procedure in the relevant operational repo |

## Step-by-Step

### 1. Check for an existing decision

Search [`../adr/README.md`](../adr/README.md). If the decision already exists, **supersede** it
rather than writing a duplicate.

### 2. Create the file

Copy [`../adr/template.md`](../adr/template.md) to `../adr/ADR-NNN-short-kebab-title.md`, where
`NNN` is the **next free number** in the platform-wide sequence. Numbers are never reused.

```bash
cp adr/template.md adr/ADR-012-your-decision-title.md
```

### 3. Fill in the sections

| Section | What to write |
|---------|---------------|
| **Document Control** | ID, version `0.1.0`, classification, owner/approver **by role**, dates |
| **Status** | Start as `Proposed` |
| **Context** | The problem and the forces (technical, compliance, scale, cost). Facts + links |
| **Decision** | Active voice ("We will ..."); concrete, **testable** rules |
| **Consequences** | Positive, negative, and neutral/follow-ups — be honest about trade-offs |
| **Evidence** | Links to code, config, benchmarks, tickets, standard clauses |
| **Change History** | Add the initial row |

### 4. Open a pull request

- Branch name: `adr/ADR-NNN-short-summary`.
- The Platform Architect reviews via CODEOWNERS; GDPR-relevant decisions also require the Data
  Protection Officer.
- Use the [*ADR Proposal*](../.github/ISSUE_TEMPLATE/adr-proposal.yml) issue to socialise a big
  decision first if useful.

### 5. On approval

- Set **Status** to `Accepted`, set the **Effective Date**, bump version to `1.0.0`.
- Add the row to the index in [`../adr/README.md`](../adr/README.md).
- Add an entry to [`../CHANGELOG.md`](../CHANGELOG.md).
- Update any architecture diagram the decision changes
  ([`../architecture/`](../architecture/README.md)).
- Merge only after CI passes and the commit is **signed**.

## Superseding an ADR

ADRs are **immutable once Accepted**. To change course:

1. Write a **new** ADR (`ADR-MMM`) describing the new decision and referencing the old one.
2. In the **old** ADR, change Status to `Superseded by ADR-MMM` and add a Change-History row.
   Do **not** rewrite its Decision or Consequences.
3. Update both rows in the [`../adr/README.md`](../adr/README.md) index.

## Promoting a Service-Local ADR

When a service-local decision acquires platform-wide impact:

1. Write a new **platform-wide** ADR in this registry that references the originating local ADR.
2. In the service repo, mark the local ADR as superseded by the platform ADR.
3. Index the local ADR under "Service-Local ADR Index" in [`../adr/README.md`](../adr/README.md).

## Quality Bar (review checklist)

- [ ] Context states the **problem**, not just the chosen solution.
- [ ] Decision rules are **testable** (a reviewer can verify compliance later).
- [ ] Consequences include **negative** trade-offs, not just benefits.
- [ ] Evidence links to **real** code/config/tickets (this is what makes it auditable).
- [ ] Compliance impact considered (GDPR / SOC 2 / ISO 27001 / PCI-DSS) and noted.
- [ ] Owners/approvers by **role**, no personal names.
- [ ] `make lint` passes; Mermaid diagrams render.

## Change History

| Version | Date | Author (role) | Change |
|---------|------|---------------|--------|
| 1.0.0 | 2026-09-25 | Platform Architect | Initial ADR authoring guide. |
