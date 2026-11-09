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

**Local proposal, 2026-11-09:** the RD root also contains a draft `pam-rd-folder-admin` entitlement for Jeferson's impersonated service account, with an eight-hour maximum. The user approved Folder Admin and the existing approvers on 2026-11-09; live plan and deployment remain outstanding. See the [proposal and CLI runbook](docs/terraform/pam/rd.md#proposed-folder-admin-access).

## How the Terraform files fit together

For a short explanation of how modules, roots and state work together, see [How the structure works](docs/terraform-and-agents.md#how-the-structure-works).

1. **Bootstrap root:** `terraform/bootstrap/state-bucket/` manages the bucket. Its state is in the bucket under `bootstrap/state-bucket`. The bucket was initially created with temporary local state, then that state was migrated to GCS. [Bootstrap guide](docs/terraform/bootstrap/state-bucket.md).
2. **PAM root:** `terraform/pam/rd/` defines the RD folder's entitlement. Its `access-policy.tf` holds the reviewable folder and access settings, and `main.tf` passes them to the reusable module in `terraform/modules/pam-folder-entitlement/`. Its state is in the same bucket under a **different** prefix, `pam/rd-folder`. [PAM guide and runbook](docs/terraform/pam/rd.md).
3. **IAM-export storage root:** `terraform/storage/iam-export/` manages the dedicated bucket in `smanley-experimental / us-central1` and its direct human reader member. Applied 2026-11-06 after user review of the exact saved plan and a user-requested single-person-review exception for this change. Its state is under `storage/iam-export`; exported IAM data belongs in the dedicated export bucket, not in the state bucket. Exports remain until approved manual cleanup. [Storage guide and change record](docs/terraform/storage/iam-export.md).
4. **State vs. code:** Terraform code is the set of files in this repo; state is sensitive operational data stored in GCS. Different prefixes keep the three roots' state separate, but do **not** by themselves isolate who can read the state.

The repository's Terraform CLI and provider versions are pinned in [INSTALLS.md](INSTALLS.md). Local formatting and validation are useful checks; they don't prove the live resources or access work. Live backend initialization, plans and changes follow the approval process in [AGENTS.md](AGENTS.md).

## What remains to do

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
