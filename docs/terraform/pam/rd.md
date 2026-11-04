# RD folder PAM

**Deployed 2026-11-03.** This root manages entitlement `pam-rd-folder-logs-viewer-ait` on Google Cloud folder `653186815477`, with Terraform state in the dedicated GCS prefix `pam/rd-folder`. Google Cloud reported the entitlement `AVAILABLE` and a subsequent Terraform plan showed no changes. End-to-end requester/approval/log-access testing remains outstanding.

The entitlement lets `contractor-ait-boopathin@trekai.org` request `roles/logging.viewer` for up to eight hours. One approval from either `smanley@trekai.org` or `pmossman@trekai.org` is required, with requester and approver justifications. A folder-level role is inherited by descendant projects, including future projects; Logs Viewer covers more than bastion logs and does not automatically include private Data Access audit logs or all custom log destinations.

The existing `rd-bastion-logs-contractor` entitlement is **project-scoped** in `trekai-prj-rd-app-mgmt`. This separate folder-scoped entitlement does not import, alter, or delete the existing one. Check active grants, approval history and dependencies before deciding whether to retire the old entitlement separately.

The Terraform root for this guide is [`terraform/pam/rd/`](../../../terraform/pam/rd/).

## How the configuration is organized

[`access-policy.tf`](../../../terraform/pam/rd/access-policy.tf) is the reviewable source of the RD folder ID, requester, approvers, role, duration and entitlement name. [`main.tf`](../../../terraform/pam/rd/main.tf) passes those values into the narrow [folder PAM entitlement module](../../../terraform/modules/pam-folder-entitlement/), which derives both the entitlement parent and resource from the same ID and enforces the approval settings; the root chooses the role (`roles/logging.viewer`). The file uses a Terraform `locals` block: “local” means the names are scoped to this Terraform root; it does not mean the file stays on this computer or is excluded from Git. Naming the folder once keeps the parent and access target consistent. These values describe a confidential access policy rather than credentials. Keep the repository private and approved for TrekAI data, and allow only authorized reviewers and maintainers to read or change it. Never put passwords, tokens or keys here. The GCS backend holds Terraform state; it does not automatically store or protect this source file. Do not move access rules to ignored variable files merely to hide them from reviewers.

## Before future changes

1. Confirm the repository owner, access policy, independent reviewers, state owner, execution identity and contractor end date. The repository must remain private.
2. Inspect existing entitlement and Terraform state ownership, folder IAM and PAM service-agent/API readiness. Ensure no existing state or authoritative IAM policy conflicts. Do not add broad service-agent permissions by assumption.
3. The GCS backend uses `devops-hq-bucket` and prefix `pam/rd-folder`, separate from bootstrap state. This root was initialized and applied against it in a staging working directory. The bucket IAM review is on hold at the user's request; effective access and backup ownership remain unverified. Do not commit state, backend credentials or plans.
4. Confirm and review the naming convention, scope and log sources, then review the code and exact live Terraform plan. A plan or apply needs the appropriate explicit authorization and change process.
5. The folder entitlement has been created and its settings verified. Test a real request, approval, log visibility and expiry with the relevant people, and record results. Only then decide separately whether to remove the old entitlement.

The distinction between `smanley` (daily account and PAM approver), `smanley-adm` (administrative login), and the impersonated Terraform service account is documented in [Google Cloud accounts and impersonation](../../terraform-and-agents.md#google-cloud-accounts-and-impersonation).

## How to run the PAM Terraform root

This is Terraform infrastructure configuration, not an application server. The entitlement already exists. Use this workflow when you need to inspect a proposed change or, after approval, apply one. The bucket's effective IAM review is on hold; the commands below use the identity previously approved for the initial PAM change, not a claim that it is the long-term least-privilege identity.

1. From the repository root, check that Terraform `1.17.1` is installed and inspect the access policy and code:

   ```bash
   cd terraform/pam/rd
   terraform version
   terraform fmt -check -recursive ../..
   ```

2. For a **local-only configuration check**, initialize without the live backend and validate. This downloads and runs pinned provider plugins when not already present, but does not check the live entitlement or state:

   ```bash
   terraform init -backend=false -lockfile=readonly
   terraform validate
   ```

3. For a **live plan**, first obtain explicit authorization and authenticate Application Default Credentials as the approved administrator. The normal `gcloud auth login` account and Terraform ADC are separate; do not paste tokens or use a service-account key:

   ```bash
   gcloud auth application-default login --account=smanley-adm@trekai.org
   ```

   The commands below impersonate `terraform-org-admin` **per command**, using `trekai-prj-rd-app-mgmt` as the provider project used for the initial deployment. The GCS backend uses `devops-hq-bucket` and the `pam/rd-folder` prefix. The admin account must have permission to impersonate that service account; actual current access and quota/API permissions must be verified. `terraform-org-admin` has broad privileges, so use it only when explicitly authorized and move to a narrower approved execution identity when available.

   ```bash
   env GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=terraform-org-admin@trekai-452018.iam.gserviceaccount.com \
     GOOGLE_CLOUD_PROJECT=trekai-prj-rd-app-mgmt \
     terraform init -input=false -lockfile=readonly
   ```

   If Terraform reports a backend change, existing-state conflict or asks to migrate state, stop and review. Do not force migration or disable locking.

4. Generate and review a plan. `umask 077` restricts new files; the saved plan may contain sensitive values and is ignored by Git. Keep it local and protected; don't paste it into public tools or commit it.

   ```bash
   umask 077
   env GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=terraform-org-admin@trekai-452018.iam.gserviceaccount.com \
     GOOGLE_CLOUD_PROJECT=trekai-prj-rd-app-mgmt \
     terraform plan -input=false -out=pam.tfplan
   terraform show -no-color pam.tfplan
   ```

   Check the target folder, principals, roles, duration and any creates, changes or deletions. If the plan has no changes, there is nothing to apply. Stop and investigate any unexpected change or replacement. A plan doesn't prove a requester can access logs.

5. Only after an independent reviewer and the user authorize the exact plan, apply that **same** plan using the approved identity:

   ```bash
   env GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=terraform-org-admin@trekai-452018.iam.gserviceaccount.com \
     GOOGLE_CLOUD_PROJECT=trekai-prj-rd-app-mgmt \
     terraform apply pam.tfplan
   ```

   If the plan has become stale or the configuration changed, generate and review a fresh plan; don't blindly retry or apply a different one. Verify the entitlement and requested behavior, record the result in the task change log, and handle the sensitive local plan according to the agreed retention policy. Do not run this command just to start an app.

To actually use PAM, the eligible contractor requests a grant through Google Cloud Privileged Access Manager; one of the named approvers reviews it. Grant request, approval, log visibility and expiry have not yet been tested.

## Offline checks

`terraform fmt -check -recursive` checks formatting. `terraform init -backend=false` and `terraform validate` require the specified provider to be available locally or downloaded from a trusted registry; they do not verify live state or effective access. Provider version `7.22.0` is an initial explicit pin, subject to team review. The lock file records hashes for the installed provider; add other supported platforms through the normal provider-lock workflow before using it elsewhere.

## Change record

**2026-11-04: rename and `roles` input (local only, not committed or planned).** Renamed `terraform/PAM/` to `terraform/pam/` and `terraform/modules/pam-folder-logs-viewer/` to `terraform/modules/pam-folder-entitlement/`; the matching docs moved too. The module's hardcoded `roles/logging.viewer` became a required `roles` input, and this root passes `["roles/logging.viewer"]`. Unchanged: module label `rd_folder_logs_viewer` (same state address, no `moved` block), backend prefix `pam/rd-folder`, entitlement ID and lock file. Authorized by the repository owner in conversation. Verified locally: `terraform fmt -check -recursive` and `init -backend=false -lockfile=readonly` + `validate` passed. **Follow-up:** after approval, re-initialize against the live backend and confirm a plan shows no changes (a `dynamic` `role_bindings` block with one role is expected to match the existing entitlement, but this is not yet verified).
