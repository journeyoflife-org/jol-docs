# ADR-013: Declarative Protection and Approval Capacity

## Document Control

| Field            | Value                              |
|------------------|------------------------------------|
| Document ID      | ADR-013                            |
| Title            | Declarative Protection and Approval Capacity |
| Version          | 0.2.0                              |
| Classification   | Public                             |
| Owner (role)     | Platform Architect                 |
| Approver (role)  | JOL Governance Board               |
| Effective Date   | — (not yet Accepted)               |
| Next Review      | — (one year after Acceptance)      |
| Review Cycle     | Annual, or upon material change    |

## Status

Proposed

<!-- Once Accepted, never rewrite Decision/Consequences — supersede with a new ADR instead. -->

## Context

Two independent enforcement systems configure the same branches, and only one of them is
declared.

**Declared by `jol-control`.** `terraform.tfstate` holds 40 `github_repository` instances and
39 `github_branch_protection` instances (governance 11 + standard 28); private repositories are
excluded from both tiers, so `jol-dr` has no managed protection. `solo_mode = true`
(`terraform.tfvars`) deliberately omits `required_pull_request_reviews` and
`required_status_checks` while retaining `require_signed_commits`, `required_linear_history`,
force-push and deletion blocks, `enforce_admins`, and `prevent_destroy`.

**Installed by hand.** A scan of all 40 public repositories on 2026-10-16 found **21 rulesets
across 19 repositories that require at least one approving review, code-owner approval, or
both** — precisely the gates `solo_mode` removes. The organization has one member, and GitHub
does not accept an author's approval of their own change, so **these requirements cannot be
satisfied by anyone**. Affected: jol-compliance (two rulesets, one named `Protect main branch`),
jol-hub (two, one named `~master` whose include pattern is `~DEFAULT_BRANCH`), jol-deploy,
jol-domain-taxonomy, jol-ecommerce-engine, jol-hermes-agents, jol-infrastructure, jol-llm,
jol-rag-server and the ten `jol-site-*` spokes.

Observed effects, all measured rather than inferred:

- `jol-hub#151` (dependabot, `21 / 21 checks OK`, `reviewDecision=REVIEW_REQUIRED`) is
  `mergeable_state=blocked` and will never merge on its own merits.
- Three pull requests in `journeyoflife-org/.github` each merged only via administrator bypass,
  while that repository's own changelog has stated since 2026-09-12 that code-owner review is
  "declarative, not substantive" and that the bypass "is not an approved merge path".
- **13 of the 24 repositories still publishing an undeliverable contact address also carry an
  unsatisfiable ruleset**, so the outstanding remediation (S1-003) would deliver pull requests
  mergeable only by the same bypass.
- `make drift` reports NO DRIFT while this is happening: `scripts/drift_detect.py` reads only
  `name,visibility` (`grep -c ruleset` returns `0`), and no `github_repository_ruleset` resource
  exists in the baseline, so `terraform apply` can neither revert nor converge any of it.

Constraints that rule out the simple answers:

- **Private repositories cannot use rulesets on this plan.** `jol-dr` returns
  `403 Upgrade to GitHub Pro or make this repository public to enable this feature`, so "make
  rulesets the single enforcement layer" cannot cover 1 of 40 repositories.
- **Organization-level rulesets cannot be read here.**
  `GET /orgs/journeyoflife-org/rulesets` returns `403 Upgrade to GitHub Team`, so this host
  cannot enumerate or exclude an org-wide ruleset.
- **The two APIs are mutually blind.** `GET /repos/{o}/{r}/branches/main/protection` answers
  `404 Branch not protected` for a ruleset-guarded branch, which reads as "unprotected" and is
  not; where both exist the stricter silently wins (`jol-hub`: classic `count=0`, ruleset
  `count=1`).
- **Tag protection needs rulesets.** The baseline defers `v*` tag protection to rulesets
  (`branch-protection.tf:119-122`, and `policy/repo-defaults.yml` declares
  `tag_protection.pattern: v*`), so rulesets cannot be abolished wholesale.
- The provider is capable: `integrations/github` `~> 6.0`, locked at 6.13.0, which exposes
  `github_repository_ruleset`.

The compliance force is SOC 2 CC8.1 (change control) and ISO 27001 A.8.32; the governing
principle is that an asserted control which cannot be exercised is an audit failure, and worse
than an absent one, because it conditions operators on bypassing it.

## Decision

- We will treat **enforcement capacity as a design constraint**: no repository may carry an
  approving-review or code-owner requirement that exceeds the number of members able to satisfy
  it. With one compliant member, that number is zero.
- We will **not weaken the intended posture to unblock work.** The review requirements found on
  19 repositories are undeclared drift, not a decision, and are recorded as such. Deleting an
  unsatisfiable control removes no protection; it removes a fiction.
- We will make **`jol-control` the single declarative source for branch protection**, expressed
  through `github_branch_protection` as today, and **declare rulesets only where classic
  protection cannot express the rule** — namely `v*` tag protection — as
  `github_repository_ruleset` resources. Every repository's branch protection is then
  plan-visible; nothing that matters is configured only in the UI.
- We will **bring `journeyoflife-org/.github` inside the allow-list**, closing the 41-live /
  40-declared gap, and add its ruleset to the same declarative model.
- We will **extend drift detection to protection state**, so this class of divergence cannot
  silently return: `scripts/drift_detect.py` compares, per repository, both protection APIs and
  fails with a distinct exit code when it cannot enumerate them. UNEVALUATED is never a pass.
- We will **encode the capacity invariant as a test**, not a remark: if any repository requires
  ≥1 approval while the organization cannot supply an eligible approver, the check fails — and
  when `solo_mode` is later retired, that same check is what proves the posture became real
  rather than nominal.
- We will **exit `solo_mode` only on the pre-existing criteria** in `docs/solo-mode-exit.md`,
  which requires inviting a second identity and bringing it into compliance with the
  organization's secure-2FA requirement. Approvals become re-enabled declaratively at that
  point. Until then the declared posture is honestly "single maintainer, integrity controls
  only": signed commits, linear history, no force-push, no deletion, admin enforcement.
- Ordering: **accept this ADR first**, then relax the 19 undeclared review requirements under
  `docs/runbooks.md` RB-06 with a snapshot taken before each write, then declare the rulesets
  that must remain (`v*` tag protection) as managed resources, then extend `drift_detect.py`.
  An earlier draft of this document put the relaxation before acceptance, on the argument that
  relaxing is a drift correction against the already-declared `solo_mode` posture and so needs
  no new decision. That ordering is withdrawn: the relaxation still removes a control, and
  `required_approving_review_count` is on `jol-control` AGENTS.md's list of values requiring
  explicit in-session human approval. A decision record written after a change documents it;
  written before, it authorises one.

## Consequences

### Positive

- What is enforced and what is declared become the same thing, so `terraform plan` and
  `make drift` describe the fleet a reviewer would inspect.
- Work stops requiring routine policy bypass; a bypass used three times a day is an absent
  control with paperwork, and it erodes the evidence pack.
- The unsatisfiable requirement is retired before, not after, the contact-address sweep, so the
  sweep's pull requests can merge on merit.
- When `solo_mode` ends, approvals are re-introduced deliberately and testably rather than
  inherited from an untracked UI setting.

### Negative

- Until the exit criteria are met, there is **no independent human review** of any change to the
  governance plane or the 19 repositories. Mitigations are the retained integrity controls plus
  `enforce_admins`, signed commits, and the findings register — this ADR does not pretend they
  are equivalent to review.
- Relaxing 19 rulesets is an out-of-band enforcement mutation and must be snapshotted and
  recorded per `docs/runbooks.md` RB-06 before it is applied; `required_approving_review_count`
  is on AGENTS.md's list of values requiring explicit in-session human approval.
- Comparing both protection APIs across 41 repositories adds runtime and pagination cost to the
  weekly scan and needs a token that can read private repositories, which the built-in
  `GITHUB_TOKEN` is not.
- Any ruleset on `jol-dr` is unknowable on this plan, so that one repository must stay an
  explicitly documented blind spot rather than an assumed-compliant one.

### Neutral / follow-ups

- Registry: `docs/solo-mode-exit.md` becomes the gate for re-enabling approvals; this ADR does
  not restate its criteria.
- S1-003 (24 repositories with undeliverable contact addresses) is sequenced after the
  relaxation, of which 13 are otherwise unmergeable.
- The unresolved `journeyoflife-org/.github` merge block (S1-007) is separate: it persists with
  every visible requirement satisfied. If it survives this ADR's changes, its cause lies outside
  the ruleset and protection APIs.
- Whether the organization should pay for GitHub Team or Enterprise is a distinct decision: it
  would restore org-level ruleset visibility and private-repository rulesets, but the declarative
  principle in this ADR does not depend on it.

## Evidence

- Repository / path: `journeyoflife-org/jol-control` — `branch-protection.tf`,
  `terraform.tfstate`, `scripts/drift_detect.py`, `policy/repo-defaults.yml`, `AGENTS.md` §2,
  `docs/drift-findings.md` S1-005 / S1-006 / S1-007 / S1-008, `docs/runbooks.md` RB-06,
  `docs/solo-mode-exit.md`
- Commands, run 2026-10-16/17 against the live organization:
  - `gh api "orgs/journeyoflife-org/repos?per_page=100" --jq 'length'` → `41`;
    `ls repos/*.yml | wc -l` → `40`; the difference is `.github`
  - per repository `GET /repos/{owner}/{repo}/rulesets`, then each
    `GET /repos/{owner}/{repo}/rulesets/{id}` → 21 rulesets on 19 repositories with
    `required_approving_review_count > 0` or `require_code_owner_review`
  - `GET /repos/journeyoflife-org/jol-dr/rulesets` →
    `403 Upgrade to GitHub Pro or make this repository public to enable this feature`
  - `GET /orgs/journeyoflife-org/rulesets` → `403 Upgrade to GitHub Team`
  - `gh api repos/journeyoflife-org/jol-hub/pulls/151` → `mergeable_state=blocked`,
    GraphQL `reviewDecision=REVIEW_REQUIRED`, four check suites all `SUCCESS`
  - `GET /repos/journeyoflife-org/.github/branches/main/protection` →
    `404 Branch not protected` while ruleset `protect-main` (id 22978013) is `active`
  - `grep -c ruleset scripts/drift_detect.py` → `0`
  - state inventory: 40 `github_repository`, 39 `github_branch_protection` (11 + 28)
- Standard clause: SOC 2 CC8.1 (change control); ISO/IEC 27001:2022 A.8.32 (change management);
  segregation-of-duties expectation that informs the approval-capacity invariant.
- Ticket / discussion: `journeyoflife-org/.github` PR #7 (bypass recorded in-thread);
  `journeyoflife-org/jol-hub#151`; findings S1-003, S1-007, S1-008, S2-006.

## Change History

| Version | Date | Author (role) | Change |
|---------|------|---------------|--------|
| 0.1.0 | 2026-10-17 | Platform Architect | Initial draft. Records the measured divergence between declared and enforced protection, the approval-capacity invariant, and the ruleset constraints that rule out a single-mechanism answer. Status Proposed: the relaxation of 19 rulesets and the import of rulesets into the baseline both await owner approval. |
| 0.2.0 | 2026-10-17 | Platform Architect | Pre-acceptance revision, both corrections found by verification rather than by review. (1) The heading conformed to the registry's short-title style: CI run 39028870034 failed `markdownlint` MD013 on the 123-character sentence heading, which local checks had not caught because they verified size and link resolution only. (2) The Ordering decision reversed from relax-then-accept to **accept-then-relax**, removing a contradiction with `jol-control` `docs/drift-findings.md` S1-008 and ensuring the removal of a review control is authorised by this record instead of documented after it. |
