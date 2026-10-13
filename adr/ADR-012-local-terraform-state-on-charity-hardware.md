# ADR-012: Local Terraform State on Charity Hardware

## Document Control

| Field            | Value                              |
|------------------|------------------------------------|
| Document ID      | ADR-012                            |
| Title            | Local Terraform State on Charity Hardware |
| Version          | 0.1.0                              |
| Classification   | Public                             |
| Owner (role)     | Platform Architect                 |
| Approver (role)  | JOL Governance Board               |
| Effective Date   | Set on acceptance (not yet accepted) |
| Next Review      | Set on acceptance, one year later  |
| Review Cycle     | Annual, or upon material change    |

## Status

Proposed

<!-- Not accepted. Under the current solo-mode operating state the author and the approver are
the same person, so "Accepted" here would record an approval that has not independently happened
(AGENTS.md §6). Acceptance is an explicit act by the owner. -->

## Context

`jol-control` is the infrastructure-as-code control plane for the
[`journeyoflife-org`](https://github.com/journeyoflife-org) GitHub organisation. Its state lives in
a local `terraform.tfstate`. Measured on this host on 2026-10-13: 195,121 bytes, `serial = 306`,
`lineage = 25425c0f…`, file mode `0600`, four managed resource blocks holding 119 instances —
40 repositories, 40 vulnerability-alert configurations, and branch protection in two blocks of 11
and 28.

That file is not just configuration. It enumerates every repository name the charity operates,
which of them are private, their GitHub node and repository ids, and the protection posture of the
default branch of each. Assessed consequence: losing it means losing the map of what the charity
owns and can no longer plan changes safely; disclosing it hands an attacker an inventory of the
estate and tells them which repositories were meant to be hidden.

Controls already in place, each verified this session rather than quoted from documentation:

- `scripts/state_gate.py` (16 self-tests pass), `scripts/plan_gate.py` (11) and
  `scripts/drift_detect.py` (11), wired into `plan.yml`, `apply.yml` and `compliance-scan.yml`.
- `apply.yml` header: validation only, apply jobs disabled until remote state exists. Two recorded
  runs planned `120 to add` from an empty state and were stopped by HTTP 403, which is the failure
  mode the gates exist to catch.
- Local `drift_detect.py` reports `NO DRIFT — All 40 repos match` with `"evaluated": true`.
- Encrypted recovery copies exist in `/opt/jol/backup/tfstate` (`age`), and one was
  decrypt-verified back to `serial = 306`, `lineage = 25425c0f`.

Constraints outside this repository:

- **AWS S3 is not a charity option.** The only AWS identity measured here
  (`viavitae-terraform`, account `775093708742`) belongs to the commercial plane, and
  `s3:ListAllMyBuckets` plus `s3:CreateBucket` are denied by an explicit deny in a service control
  policy in organisation `o-omcubugbug` (`p-r9i2lq77`). Even if that carve-out were granted, it
  would place the charity's state in another entity's cloud.
- **HCP Terraform free tier has been tried next door.** In `jolarca-control` the entitlement set
  reports `audit-logging: false`, and a run on 2026-10-12 sat in the provider's queue for 33
  minutes while `terraform apply -auto-approve` waited behind it unattended — recorded in that
  repository's `scripts/check_workspace_execution_mode.sh`.
- **The host has no encryption at rest and one physical device.** `dmsetup ls --target crypt`
  returns zero devices, and every mount that holds charity data — `/`, `/home`, `/opt/jol`,
  `/opt/jol/backup`, `/opt/jol/data` — is a partition of `nvme1n1`. Two 14.6 GB `crypto_LUKS`
  volumes (`sda`, `sdb`) are attached; `/dev/mapper` contains only the commercial plane's logical
  volumes, so neither is unlocked. A directory created at `/media/jol/charity-vol` resolves to the
  root filesystem, not to a second medium.
- **No decision of ours says any of this.** No ADR in this registry mentions Terraform, `tfstate`,
  a backend, OpenTofu or Terragrunt (searched 2026-10-13 across `adr/`), and
  `docs/architecture.md:107` in `jol-control` delegates the question to "ADR-0006 in
  `jolarca-control`" — the decision record of a different legal entity. Per AGENTS.md §6, the
  absence is stated rather than back-filled.
- **One key currently opens three estates.** The `age` recipient used for the state archives of all
  three control planes is a single keypair, and the only committed copy of its public half is in
  `jolarca-control/.state-backup-pubkey.txt`. `jol-control` commits no recipient key.
- Terraform itself is under BUSL v1.1 (MPL-2.0 reversion expected around October 2027); OpenTofu is
  the MPL-2.0 fork. Internal use is permitted under BUSL.

## Decision

- We will keep the authoritative Terraform state for `journeyoflife-org` **on hardware the charity
  owns**, with the authoritative `apply` executed on the control-plane host. No third-party state
  service will hold this plane's state while it cannot offer, at once, an EU residency commitment,
  a signed Art. 28 data processing agreement, and audit logging of state access.
- We will **not** migrate this plane to HCP Terraform free tier, superseding the mitigation plan
  recorded at `docs/architecture.md:107`, and we will **not** use AWS S3, which is not our cloud.
- We will protect the copy rather than the disk. Each rule below is written so compliance can test
  it later:
  1. `umask 077` is set before any archive is created, and the archive directory carries no group
     or world read permission.
  2. Every archive is `age`-encrypted, and the recipient's public half is committed in
     `jol-control` as `.state-backup-pubkey.txt` so a future restorer is not dependent on a
     document in another entity's repository.
  3. Keypairs are per plane. The charity's backup key is not the marketplace's key, and not the
     commercial plane's key.
  4. The identity (private) key never lives on the same medium as the archives it decrypts.
  5. Before writing, the destination is asserted to be a different physical device: a copy whose
     `df --output=source` still reports `nvme1n1` is refused, because an archive on the same drive
     as its source is not a backup.
  6. Each backup run writes a manifest of `sha256`, `serial`, `lineage` and instance count, so a
     restored file can be identified rather than merely opened.
  7. RPO is one apply: a fresh archive is taken whenever state changes. RTO is 30 minutes, proven
     by a rehearsed drill, not asserted.
- We will keep the missing lock **compensated and declared** rather than bought. Until a second
  operator or CI-applies exists, the compensating controls are a single authoritative host, one
  apply at a time, and the `state_gate.py` / `plan_gate.py` pair in front of every apply. T-06 in
  `docs/threat-model.md` therefore remains an accepted risk of this design, not a closed control.
- We will cite this ADR from `jol-control`, not the reverse: `docs/architecture.md:107` will point
  at ADR-012 in this registry instead of another controller's decision record.
- We will treat the BUSL licence as a review input rather than a blocker, and note that a local
  state file keeps the eventual cost of switching to OpenTofu close to zero — which is itself an
  argument for not binding the charity to a hosted vendor now.

## Consequences

### Positive

- One controller end-to-end for the charity plane: the state, the key, the media and the operator
  are all within the charity, so no Art. 28 processor and no Chapter V transfer analysis is needed
  for state.
- No recurring cost, and no dependency on a vendor queue that has already stalled a sibling plane
  for 33 minutes with an auto-approve waiting behind it.
- Unlocking the existing LUKS volumes finally gives this plane encryption at rest, which the host
  does not have today.
- Change history stays where the charity can read it: git history for code, manifests for state.

### Negative

- T-06 stays open. There is still no locking and no server-side state versioning, so a torn write
  or a second concurrent apply is caught by convention and by the gates, not prevented by a service.
- Durability depends on a human action: plugging in, unlocking and mounting a volume. If that stops
  happening, the control silently decays into a same-disk copy.
- Off-site storage of the second volume is required by this decision and is **not yet verified**;
  until it is, a single fire or theft still takes both the host and the archive.
- Solo mode means author and approver are the same person, so this ADR cannot be presented to an
  auditor as evidence of independent review.
- A dead credential in `~/.terraformrc` (returns HTTP 401 to `GET /orgs/Via-Vitae`) shows that any
  non-interactive Terraform automation on this host will fail today, while the operator's login
  shell succeeds.

### Neutral / follow-ups

- ADR-013 candidate, to be opened only when a trigger fires: a self-hosted `backend "http"` with
  `lock_address` / `unlock_address` on charity hardware, which would buy locking and version history
  without a third party. Triggers: a second operator; more than about 400 managed instances (this
  plane is at 119); CI-gated applies; two consecutive failed restore drills; or an audit that
  requires state version history.
- Follow-up edits, deliberately kept out of this ADR so the diff stays reviewable:
  `jol-control/docs/architecture.md` lines 104 and 107, `jol-control/docs/threat-model.md` T-06,
  `jol-control/docs/runbooks.md` (backup and restore procedure), and a committed
  `.state-backup-pubkey.txt` in `jol-control`.
- The per-plane key split in rule 3 invalidates archives made under the shared key. They remain
  readable with the old identity, and that identity must be retained until each plane has fresh
  archives under its own key.

## Evidence

All measurements below were taken on the control-plane host on 2026-10-13 and are reproducible with
the commands shown.

- State contents and size: `jq -r '.serial, .lineage' /opt/jol/repos/jol-control/terraform.tfstate`,
  `jq '[.resources[].instances[]] | length'` → 119; `stat -c '%a %s'` → `600 195121`.
- Gate test suites: `bash tests/test_state_gate.sh` → 16 tests, 0 failures;
  `python3 tests/test_plan_gate.py` → 11 passed; `python3 tests/test_drift_gate.py` → 11 passed.
- Local drift verdict: `python3 scripts/drift_detect.py` → `NO DRIFT — All 40 repos match`.
- CI posture: `.github/workflows/apply.yml` line 4 states that apply jobs are DISABLED until
  remote state exists; `docs/architecture.md` lines 94–98 record the `120 to add` / HTTP 403 runs.
- Device topology: `lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT` shows `p3`, `p6`, `p7`, `p8`, `p9` all
  children of `nvme1n1`; `dmsetup ls --target crypt | wc -l` → 0; `findmnt /media/jol/charity-vol`
  returns nothing and `df --output=source` on it reports `/dev/nvme1n1p3`.
- LUKS availability: `lsblk -f /dev/sda /dev/sdb` → 14.6G `crypto_LUKS`, state `running`;
  `ls /dev/mapper` lists only `vgopt-lv_viavitae` and `vgopt-lv_jolarca`.
- External constraints: the SCP deny message naming
  `arn:aws:organizations::376896792604:policy/o-omcubugbug/service_control_policy/p-r9i2lq77`;
  `jolarca-control/docs/adr/0006-remote-state-backend.md` line 178 (`audit-logging: false`) and
  `jolarca-control/scripts/check_workspace_execution_mode.sh` lines 13–14 (33-minute stall).
- Key custody: `age-keygen -y ~/.config/age/state-backup-key.txt` derives the recipient recorded in
  `jolarca-control/.state-backup-pubkey.txt`; no equivalent file exists in `jol-control`.
- Standard clauses: GDPR Art. 5(1)(f), Art. 24, Art. 28(1), Art. 32(1)(b) and (c), Art. 35;
  ISO/IEC 27001:2022 A.5.14, A.5.19, A.5.20, A.8.10, A.8.13, A.8.15, A.8.24; SOC 2 CC6.1, CC6.6,
  CC7.1, CC8.1, A1.2.
- Related decision: [ADR-008](ADR-008-self-hosted-llm-air-gapped.md) already states that "JOL runs
  its own Proxmox bare-metal infrastructure and requires ISO 27001 / GDPR compliance" for the AI
  tier, and accepted self-hosting there on residency grounds. This ADR extends that principle to
  infrastructure-as-code state, which no earlier record in this registry covered.

## Change History

| Version | Date | Author (role) | Change |
|---------|------|---------------|--------|
| 0.1.0 | 2026-10-13 | Platform Architect (drafted with AI assistance, provenance tier `ai:top`) | Initial draft, status Proposed. Residency decision for `jol-control` state, recorded in this registry for the first time. |
