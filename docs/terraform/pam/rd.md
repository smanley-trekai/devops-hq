# RD folder PAM

**Deployed 2026-11-03.** This root manages entitlement `pam-rd-folder-logs-viewer-ait` on Google Cloud folder `653186815477`, with Terraform state in the dedicated GCS prefix `pam/rd-folder`. Google Cloud reported the entitlement `AVAILABLE` and a subsequent Terraform plan showed no changes. End-to-end requester/approval/log-access testing remains outstanding.

**Proposed 2026-11-09; not deployed:** a second entitlement, `pam-rd-folder-admin`, for Jeferson's impersonated service account. The user approved its Folder Admin role, service-account requester and reuse of the existing approvers on 2026-11-09. Live Terraform planning and deployment remain outstanding. See [the proposed access and CLI runbook](#proposed-folder-admin-access).

The entitlement lets `contractor-ait-boopathin@trekai.org` request `roles/logging.viewer` for up to eight hours. One approval from either `smanley@trekai.org` or `pmossman@trekai.org` is required, with requester and approver justifications. A folder-level role is inherited by descendant projects, including future projects; Logs Viewer covers more than bastion logs and does not automatically include private Data Access audit logs or all custom log destinations.

The existing `rd-bastion-logs-contractor` entitlement is **project-scoped** in `trekai-prj-rd-app-mgmt`. This separate folder-scoped entitlement does not import, alter, or delete the existing one. Check active grants, approval history and dependencies before deciding whether to retire the old entitlement separately.

The Terraform root for this guide is [`terraform/pam/rd/`](../../../terraform/pam/rd/).

## How the configuration is organized

[`access-policy.tf`](../../../terraform/pam/rd/access-policy.tf) is the reviewable source of the RD folder ID and each entitlement's requester, approvers, role, duration and name. [`main.tf`](../../../terraform/pam/rd/main.tf) passes those values into instances of the narrow [folder PAM entitlement module](../../../terraform/modules/pam-folder-entitlement/), which derives both the entitlement parent and resource from the same ID and enforces the approval settings; the root chooses each role (deployed Logs Viewer and proposed Folder Admin). The file uses a Terraform `locals` block: “local” means the names are scoped to this Terraform root; it does not mean the file stays on this computer or is excluded from Git. Naming the folder once keeps the parent and access target consistent. These values describe a confidential access policy rather than credentials. Keep the repository private and approved for TrekAI data, and allow only authorized reviewers and maintainers to read or change it. Never put passwords, tokens or keys here. The GCS backend holds Terraform state; it does not automatically store or protect this source file. Do not move access rules to ignored variable files merely to hide them from reviewers.

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

## Proposed folder admin access

The 2026-11-09 request is to prepare PAM for `contractor-amplifi-jsilva@trekai.org` on folder `653186815477` with an eight-hour duration, including CLI use through an impersonated service account. The user identified the account below. The user approved the access settings on 2026-11-09. The configuration is **local on `main` and not deployed**; a live backend initialization/plan and an exact-plan apply require their own authorization.

| Setting | Approved access setting / execution scope |
|---|---|
| Entitlement | `pam-rd-folder-admin` |
| Parent and access target | RD folder `653186815477` |
| Eligible requester | `serviceAccount:sa-jeferson-amplifi01@trekai-ws-app-mgmt-452018.iam.gserviceaccount.com` |
| Role | `roles/resourcemanager.folderAdmin` |
| Maximum duration per grant | `28800s` (eight hours); shorter requests allowed |
| Approvers | One of `smanley@trekai.org` or `pmossman@trekai.org` |
| Justifications | Required for requester and approver |
| Terraform address | `module.rd_folder_admin.google_privileged_access_manager_entitlement.this` |
| Backend | Existing `devops-hq-bucket` / `pam/rd-folder` |

[Folder Admin](https://docs.cloud.google.com/resource-manager/docs/access-control-folders) administers folders and IAM; it does not provide general administration of every service in descendant projects. Confirm the intended tasks before selecting additional service roles. This role can change IAM and therefore create access that survives the PAM grant. Review that consequence explicitly: [Google's PAM role guidance](https://docs.cloud.google.com/iam/docs/pam-create-entitlements) warns about roles containing `setIamPolicy`. Eight hours limits each PAM grant, not the lifetime of the entitlement or any access separately created while elevated. The contractor's end date and entitlement owner remain unconfirmed.

### Impersonation lookup

Read-only checks on **2026-11-09, 14:10–14:11 UTC**, using `smanley-adm@trekai.org` directly with quota project `trekai-452018`, confirmed:

- Folder `653186815477` is `trekai-rd`, active, under organization `470598084059`.
- The named workstation service account exists. Its direct IAM policy includes an unconditional Token Creator binding for the named contractor.
- The older RD contractor infrastructure service account's direct Token Creator binding for this contractor has an October 2 expiry; that binding cannot establish current access.
- The folder's entitlement list contained no `pam-rd-folder-admin`; the existing Logs Viewer entitlement was present. This checks the live name, not ownership in other Terraform states.

The first lookup failed because the admin login required reauthentication. The user completed sign-in, then the reads above succeeded. No token values, raw policies or member lists are retained in this guide. The existing November 6 IAM export and November 5 indexed IAM snapshot supplied historical context; effective permissions, inherited/group paths, deny policies and the contractor's actual token minting were not tested. No contractor credentials were used and no IAM binding was changed. [Google's service-account authentication guidance](https://docs.cloud.google.com/iam/docs/service-account-permissions) distinguishes Token Creator from Service Account User: the latter alone does not allow CLI impersonation.

The draft makes the **service account** eligible. A request made with impersonation elevates that service account; the human account does not receive the role directly. Other principals that can impersonate or run workloads as this service account could use its active privileges. Its direct policy showed one distinct Token Creator member, but inherited permissions, other token-minting roles, service-account attachment and workload use were not exhaustively assessed. Confirm that this is an appropriate administrative identity before deployment. Do not add the human identity or a shared service account as another requester without reviewing that access change.

### CLI requests after deployment

These commands are instructions for **Jeferson**, after the entitlement has been reviewed, deployed and verified. They have not been executed here. Use the contractor's own interactive login, with no downloaded service-account key:

```bash
gcloud auth login --account=contractor-amplifi-jsilva@trekai.org
```

First confirm eligibility using a read-only search as the service account:

```bash
gcloud pam entitlements search \
  --folder=653186815477 \
  --location=global \
  --caller-access-type=grant-requester \
  --account=contractor-amplifi-jsilva@trekai.org \
  --impersonate-service-account=sa-jeferson-amplifi01@trekai-ws-app-mgmt-452018.iam.gserviceaccount.com
```

Submit the eight-hour request with a real task/ticket justification:

```bash
gcloud pam grants create \
  --entitlement=folders/653186815477/locations/global/entitlements/pam-rd-folder-admin \
  --requested-duration=28800s \
  --justification='REPLACE WITH task or ticket and reason for folder administration' \
  --account=contractor-amplifi-jsilva@trekai.org \
  --impersonate-service-account=sa-jeferson-amplifi01@trekai-ws-app-mgmt-452018.iam.gserviceaccount.com
```

One designated approver must approve before access activates. Use the same impersonation flag on subsequent administrative `gcloud` commands; an unimpersonated command still uses the human's permissions. The eight-hour PAM grant is separate from the short-lived credential lifetime: normal CLI impersonation can refresh credentials without requesting an eight-hour access token. Quota-project/API permissions may also be needed; do not grant them automatically if a command fails. Verify the grant reaches `ACTIVE`, test a relevant read operation, then verify expiry or early revocation and absence of unintended standing access. Terraform ADC is separate from gcloud login; these examples do not configure Terraform credentials.

References checked 2026-11-09: [CLI grant creation](https://docs.cloud.google.com/sdk/gcloud/reference/pam/grants/create), [eligibility search](https://docs.cloud.google.com/sdk/gcloud/reference/pam/entitlements/search), and [PAM request lifecycle](https://docs.cloud.google.com/iam/docs/pam-request-temporary-elevated-access).

## Offline checks

`terraform fmt -check -recursive` checks formatting. `terraform init -backend=false` and `terraform validate` require the specified provider to be available locally or downloaded from a trusted registry; they do not verify live state or effective access. Provider version `7.22.0` is an initial explicit pin, subject to team review. The lock file records hashes for the installed provider; add other supported platforms through the normal provider-lock workflow before using it elsewhere.

## Change record

**2026-11-09: access-settings approval.** In response to the review summary asking to confirm Folder Admin and the existing approvers, the user replied "approved". Recorded approval of `roles/resourcemanager.folderAdmin`, the named Jeferson service-account requester, eight-hour maximum and one of the existing two approvers. This is user review of the access settings, not independent human review or authorization of an unseen Terraform plan. No live backend initialization, plan or apply has run for this addition. The earlier local validation remains applicable because only comments and documentation changed.

### Prepared next operation: live initialization and plan only

This proposal is ready for separate live-operation authorization:

- Source login: `smanley-adm@trekai.org`; caller: `terraform-org-admin@trekai-452018.iam.gserviceaccount.com`, selected explicitly per operation using short-lived impersonated credentials. This follows the prior RD execution path; it is highly privileged and is not a new standing access grant. Keep tokens only in child-process environment memory; do not print or persist them, and do not assume the current Terraform ADC identity matches the gcloud login.
- Terraform root: `terraform/pam/rd`; project: `trekai-prj-rd-app-mgmt`; quota project: `trekai-452018`; workspace: `default`; backend: `devops-hq-bucket` / `pam/rd-folder`.
- Use fresh owner-only temporary Terraform metadata and plan storage, the existing provider installation and unchanged lock file. Initialize the existing backend with `init -input=false -lockfile=readonly` and the local provider directory. Stop on migration prompts, state conflicts, authentication/permission failures or unexpected state ownership; no forced migration or imports.
- Run `plan -input=false -detailed-exitcode -lock-timeout=60s -out=<private-plan-path>` with locking enabled. This reads live state and cloud metadata and may use normal backend lock objects. Save sensitive output privately and summarize the exact saved plan without copying raw state or plan data into chat or docs.
- Expected result: exactly one create at `module.rd_folder_admin.google_privileged_access_manager_entitlement.this` with the approved settings above, and no change to `module.rd_folder_logs_viewer`. Stop on any other create, update, replacement or delete. Inspect the saved plan locally, record its hash and checked settings for review.
- No apply, PAM request/approval, API enablement, service-agent changes or separate IAM grants. A future apply needs review of that exact plan, the repository's independent human review requirement (or an explicit user-directed exception for this change), and separate exact-plan apply authorization.


**2026-11-09: proposed Jeferson folder-admin entitlement (local only).** Authorized preparation and targeted read-only impersonation lookup by the user's request in conversation; user supplied the workstation service-account email and completed admin reauthentication. Added a second module instance in the existing RD root, reusing its folder, backend, pinned versions and approval module. The candidate grants Folder Admin to the impersonated service account for up to eight hours with one existing approver and both justifications. Role scope, service-account requester and approvers were subsequently approved by the user on 2026-11-09; no broader service roles or new impersonation bindings are included. The existing Logs Viewer entitlement and shared module are unchanged. Execution identity for a future Terraform plan/apply remains to be approved separately; the lookup used the human admin directly, without `terraform-org-admin` impersonation. Before deployment: confirm role/approvers, administrative identity suitability, owner/end date, independent human review, state ownership and absence of conflicting IAM management; authorize a live backend/plan operation, review the exact plan, then separately authorize applying that plan. No backend init, live plan, state operation, apply, PAM request or PAM approval ran. Local checks on 2026-11-09: repository-wide `terraform fmt -check -recursive` passed; `init -backend=false -input=false -lockfile=readonly` in an isolated temporary data directory reused the installed Google provider `7.22.0` with the existing lock file and no provider download; `validate -no-color` passed. The first validation could not start the provider inside the sandbox; the same backend-disabled validation succeeded after execution approval outside the sandbox. Terraform CLI `1.17.1` was used; gcloud `592.0.0` was observed (the documented workstation baseline remains `591.0.0`). Local validation does not verify live IAM or the grant lifecycle.

**2026-11-04: rename and `roles` input (committed in `72aa46b`; plan verified 2026-11-04).** Renamed `terraform/PAM/` to `terraform/pam/` and `terraform/modules/pam-folder-logs-viewer/` to `terraform/modules/pam-folder-entitlement/`; the matching docs moved too. The module's hardcoded `roles/logging.viewer` became a required `roles` input, and this root passes `["roles/logging.viewer"]`. Unchanged: module label `rd_folder_logs_viewer` (same state address, no `moved` block), backend prefix `pam/rd-folder`, entitlement ID and lock file. Authorized by the repository owner in conversation. Verified locally: `terraform fmt -check -recursive` and `init -backend=false -lockfile=readonly` + `validate` passed. **Live verification (2026-11-04):** with the user's explicit authorization in conversation, `terraform init -input=false -lockfile=readonly` against `devops-hq-bucket`/`pam/rd-folder` and `terraform plan -input=false -detailed-exitcode` (no saved plan) were run from commit `72aa46b`, using ADC as `smanley-adm@trekai.org` impersonating `terraform-org-admin`. Init resolved the module at the new path; the plan reported "No changes" (exit code 0) for `module.rd_folder_logs_viewer.google_privileged_access_manager_entitlement.this`. Nothing was applied.
