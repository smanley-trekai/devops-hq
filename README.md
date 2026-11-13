# DevOps HQ

This repository holds Terraform configuration for Google Cloud infrastructure. Terraform reads the configuration, compares it with the resources it manages, and produces a **plan** showing proposed changes. An approved **apply** makes those changes in Google Cloud.

**Keep this repository private.** Its configuration includes internal project and account details. Never commit credentials, Terraform state, saved plans or raw audit data. Confirm that the chosen repository and collaborators are approved for TrekAI data before publishing.

## What exists today

The state-bucket/PAM entries reflect verification on **2026-11-03**; the IAM-export bucket was created and checked on **2026-11-06**. This is not a fresh inventory of every resource:

| Resource | What it does | Current documented state |
|---|---|---|
| Google Cloud project `smanley-experimental` | Houses the Terraform state and IAM-export buckets under TrekAI's development folder. | Created outside these Terraform roots; ACTIVE state and billing enabled rechecked 2026-11-06. |
| Storage bucket `devops-hq-bucket` | Stores Terraform state: the records Terraform uses to track managed resources. | Created by the [bootstrap Terraform root](terraform/bootstrap/state-bucket/). Versioning, uniform access and public-access prevention were verified. Effective bucket IAM review is **on hold**. |
| RD folder PAM entitlement `pam-rd-folder-logs-viewer-ait` | Lets the named contractor request temporary Logs Viewer access to the RD folder; one of two named approvers must approve. | Created by the [PAM Terraform root](terraform/pam/rd/), reported `AVAILABLE`; a follow-up plan showed no changes. A real request, approval, log access and expiry have **not** been tested. |
| Storage bucket `trekai-iam-export-smanley-experimental` | Dedicated destination for approved IAM export snapshots. | Created by the [storage root](terraform/storage/iam-export/) on 2026-11-06. Bucket settings/direct human reader verified. One organization-wide allow-policy snapshot at 2026-11-06 11:26 UTC was exported/downloaded and validated: 484 resource records, 1,431 bindings. Separate native source-agent/writer grants recorded; writer access expires 2026-11-07 11:22 UTC. No automatic data deletion. Effective-access/directory coverage remains unverified. |

The [RD PAM guide](docs/terraform/pam/rd.md) lists the access settings. Folder-level Logs Viewer can cover eligible logs in descendant projects, including future projects; it does not automatically cover every private or separately routed log. An older **project-level** entitlement was created separately and still exists; it is not managed by these Terraform roots.

**RD Folder Admin verified, 2026-11-09, 14:47 UTC:** `pam-rd-folder-admin` is `AVAILABLE` with `contractor-amplifi-jsilva@trekai.org` as the sole eligible requester, following the user-approved switch from the service account. Live read-back confirmed Folder Admin, an eight-hour maximum, one of the existing two approvers and both required justifications. The initial creation reported one added/zero changed/zero destroyed; the requester update reported zero added/one changed/zero destroyed. The requester/approval/access/expiry lifecycle remains untested, and no grant was requested or approved here. No independent human review is claimed. See the [access and request runbook](docs/terraform/pam/rd.md#proposed-folder-admin-access).

## How the Terraform files fit together

**Boopathi Folder Admin addition applied and verified, 2026-11-11, 14:19 UTC:** the user requested the same access as Jeferson and approved applying the exact saved plan under their review for this change. Terraform reported zero added, one changed and zero destroyed. A separate live read-back confirmed `pam-rd-folder-admin` is `AVAILABLE`, with both human requesters and the existing Folder Admin role, eight-hour maximum, one of the two existing approvers and both justifications required. No independent human review is claimed. No PAM grant was requested or approved; actual request/access/expiry tests remain outstanding. See the [RD change record](docs/terraform/pam/rd.md#change-record).

For a short explanation of how modules, roots and state work together, see [How the structure works](docs/terraform-and-agents.md#how-the-structure-works).

**Monitoring/GKE viewer applied and verified, 2026-11-13, 14:13 UTC:** `pam-rd-folder-observability-viewer` is `AVAILABLE` for Boopathi's three requested Monitoring/GKE roles. The exact saved-plan apply reported **1 added, 0 changed, 0 destroyed** under user-reviewed execution; no independent human review is claimed. Live read-back passed all eleven checks, including requester, folder, roles, eight-hour maximum and approval controls. No PAM grant was requested or approved here. The saved plan is consumed. See the [access settings and change record](docs/terraform/pam/rd.md#monitoring-and-gke-viewer-access).

1. **Bootstrap root:** `terraform/bootstrap/state-bucket/` manages the bucket. Its state is in the bucket under `bootstrap/state-bucket`. The bucket was initially created with temporary local state, then that state was migrated to GCS. [Bootstrap guide](docs/terraform/bootstrap/state-bucket.md).
2. **PAM root:** `terraform/pam/rd/` defines the RD folder's entitlement. Its `access-policy.tf` holds the reviewable folder and access settings, and `main.tf` passes them to the reusable module in `terraform/modules/pam-folder-entitlement/`. Its state is in the same bucket under a **different** prefix, `pam/rd-folder`. [PAM guide and runbook](docs/terraform/pam/rd.md).
3. **IAM-export storage root:** `terraform/storage/iam-export/` manages the dedicated bucket in `smanley-experimental / us-central1` and its direct human reader member. Applied 2026-11-06 after user review of the exact saved plan and a user-requested single-person-review exception for this change. Its state is under `storage/iam-export`; exported IAM data belongs in the dedicated export bucket, not in the state bucket. Exports remain until approved manual cleanup. [Storage guide and change record](docs/terraform/storage/iam-export.md).
4. **State vs. code:** Terraform code is the set of files in this repo; state is sensitive operational data stored in GCS. Different prefixes keep the three roots' state separate, but do **not** by themselves isolate who can read the state.

The repository's Terraform CLI and provider versions are pinned in [INSTALLS.md](INSTALLS.md). Local formatting and validation are useful checks; they don't prove the live resources or access work. Live backend initialization, plans and changes follow the approval process in [AGENTS.md](AGENTS.md).

**RD development folder/project created and verified, 2026-11-13:** [`terraform/organization/rd-dev/`](terraform/organization/rd-dev/) manages folder `trekai-rd-dev` (`561034768953`) directly under the organization and project `prj-trekai-rd-dev` (`413711767398`) inside it. After the initial service-account folder-permission failure, the user approved the revised provider split and a fresh exact-plan apply: **2 added, 0 changed, 0 destroyed**, completed at 19:03:18 UTC. Separate live reads confirmed both resources ACTIVE, the intended parents and billing enabled on the selected account. The folder/backend use the direct admin; the project provider impersonates the existing service account. State remains under `organization/rd-dev`. Full effective-access and network/API inventory, accountable ownership confirmation and a follow-up no-change plan remain outstanding. See the [scope and change record](docs/terraform/organization/rd-dev.md).

## What remains to do

- Test [QA desktop PAM](docs/terraform/pam/qa-desktop.md) for DOKB-984: the user reported a successful saved-plan apply on 2026-11-13 (one entitlement added); their subsequent live read-back confirms `AVAILABLE` and the intended settings for temporary, hostname-restricted IAP access in `qa-virtual-machine`. The root/state prefix is `terraform/pam/qa-desktop/` / `pam/qa-desktop`. Harikaran's request/approval/access/expiry tests remain outstanding.
- Test the contractor's request, approval, intended log access and expiration; confirm access end date and owner.
- Resume the [state-bucket IAM review](docs/terraform/bootstrap/state-bucket-iam.md) when requested, including inherited access and backup ownership.
- The [2026-11-06 IAM export](review/tl-trekai-terraform-review/iam-permission-org-wide/README.md) is saved in Cloud Storage and downloaded locally. Any new collection, group/effective-access analysis, IAM cleanup or data cleanup is separate work; the temporary writer condition expires on 2026-11-07 and retained exports continue to incur applicable storage charges.
- Decide separately whether to retire the older project-level entitlement after the folder access works.
- Establish repository ownership, independent reviews, protected branches and an approved CI/CD process. No CI/CD workflow has been implemented yet.

## Additional TrekAI context

The separate [TrekAI infrastructure and product review knowledge base](/Users/ron/Documents/trekai/sm-trekai-infrastructure-and-product-review/README.md) provides background on products, Google Cloud, GitHub, Terraform, architecture, deployment flows and previously answered questions. Its local path is `/Users/ron/Documents/trekai/sm-trekai-infrastructure-and-product-review`.

Start with its README and check `trekai-questions/` before repeating an investigation. For Terraform work, `reviews/terraform/` contains prior repository analyses, while `trekai-how-it-works/` explains architecture and environment relationships. Read its root and applicable folder `AGENTS.md` before exploring further.

Use this confidential repository read-only unless a change there is requested. Findings are dated snapshots: cite their dates and verify relevant assumptions before operational use. Link to relevant evidence rather than copying sensitive data. The [related knowledge-base rules](AGENTS.md#related-knowledge-base) apply to all agents.

## Guides

- [Diagram: Google Cloud and Terraform connections](docs/google-cloud-diagram.md)

- [Tool installation and versions](INSTALLS.md)
- [Run the RD PAM Terraform configuration](docs/terraform/pam/rd.md#how-to-run-the-pam-terraform-root)
- [Terraform and AI-agent working practices](docs/terraform-and-agents.md)
- [All Terraform guides](docs/terraform/README.md)
- [TrekAI repository reviews and inventory](review/README.md)
- [Agent instructions](AGENTS.md)
