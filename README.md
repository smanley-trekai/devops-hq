# DevOps HQ

This repository holds Terraform configuration for Google Cloud infrastructure. Terraform reads the configuration, compares it with the resources it manages, and produces a **plan** showing proposed changes. An approved **apply** makes those changes in Google Cloud.

**Keep this repository private.** Its configuration includes internal project and account details. Never commit credentials, Terraform state, saved plans or raw audit data. Confirm that the chosen repository and collaborators are approved for TrekAI data before publishing.

## What exists today

The following reflects the work verified on **2026-11-03**, not a fresh live inventory:

| Resource | What it does | Current documented state |
|---|---|---|
| Google Cloud project `smanley-experimental` | Houses the Terraform state bucket under TrekAI's development folder. | Created and billing linked; the project itself was created outside this Terraform configuration. |
| Storage bucket `devops-hq-bucket` | Stores Terraform state: the records Terraform uses to track managed resources. | Created by the [bootstrap Terraform root](terraform/bootstrap/state-bucket/). Versioning, uniform access and public-access prevention were verified. Effective bucket IAM review is **on hold**. |
| RD folder PAM entitlement `pam-rd-folder-logs-viewer-ait` | Lets the named contractor request temporary Logs Viewer access to the RD folder; one of two named approvers must approve. | Created by the [PAM Terraform root](terraform/pam/rd/), reported `AVAILABLE`; a follow-up plan showed no changes. A real request, approval, log access and expiry have **not** been tested. |

The [RD PAM guide](docs/terraform/pam/rd.md) lists the access settings. Folder-level Logs Viewer can cover eligible logs in descendant projects, including future projects; it does not automatically cover every private or separately routed log. An older **project-level** entitlement was created separately and still exists; it is not managed by these Terraform roots.

## How the Terraform files fit together

1. **Bootstrap root:** `terraform/bootstrap/state-bucket/` manages the bucket. Its state is in the bucket under `bootstrap/state-bucket`. The bucket was initially created with temporary local state, then that state was migrated to GCS. [Bootstrap guide](docs/terraform/bootstrap/state-bucket.md).
2. **PAM root:** `terraform/pam/rd/` defines the RD folder's entitlement. Its `access-policy.tf` holds the reviewable folder and access settings, and `main.tf` passes them to the reusable module in `terraform/modules/pam-folder-entitlement/`. Its state is in the same bucket under a **different** prefix, `pam/rd-folder`. [PAM guide and runbook](docs/terraform/pam/rd.md).
3. **State vs. code:** Terraform code is the set of files in this repo; state is sensitive operational data stored in GCS. Different prefixes keep the two roots' state separate, but do **not** by themselves isolate who can read the state.

The repository's Terraform CLI and provider versions are pinned in [INSTALLS.md](INSTALLS.md). Local formatting and validation are useful checks; they don't prove the live resources or access work. Live backend initialization, plans and changes follow the approval process in [AGENTS.md](AGENTS.md).

## What remains to do

- Test the contractor's request, approval, intended log access and expiration; confirm access end date and owner.
- Resume the [state-bucket IAM review](docs/terraform/bootstrap/state-bucket-iam.md) when requested, including inherited access and backup ownership.
- Decide separately whether to retire the older project-level entitlement after the folder access works.
- Establish repository ownership, independent reviews, protected branches and an approved CI/CD process. No CI/CD workflow has been implemented yet.

## Guides

- [Diagram: Google Cloud and Terraform connections](docs/google-cloud-diagram.md)

- [Tool installation and versions](INSTALLS.md)
- [Run the RD PAM Terraform configuration](docs/terraform/pam/rd.md#how-to-run-the-pam-terraform-root)
- [Terraform and AI-agent working practices](docs/terraform-and-agents.md)
- [All Terraform guides](docs/terraform/README.md)
- [Agent instructions](AGENTS.md)
