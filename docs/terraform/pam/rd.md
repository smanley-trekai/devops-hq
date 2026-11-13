# RD folder PAM

**Deployed 2026-11-03.** This root manages entitlement `pam-rd-folder-logs-viewer-ait` on Google Cloud folder `653186815477`, with Terraform state in the dedicated GCS prefix `pam/rd-folder`. Google Cloud reported the entitlement `AVAILABLE` and a subsequent Terraform plan showed no changes. End-to-end requester/approval/log-access testing remains outstanding.

**Initial service-account deployment and settings verified 2026-11-09 (requester since replaced):** a second entitlement, `pam-rd-folder-admin`, for Jeferson's impersonated service account. The user approved its Folder Admin role, service-account requester and existing approvers, then authorized the exact saved-plan apply. Terraform reported one added, zero changed and zero destroyed. A separately approved read-back confirmed `AVAILABLE` and all approved settings. No independent human review is claimed; the requester/approval/access/expiry lifecycle remains untested. See [the proposed access and CLI runbook](#proposed-folder-admin-access).

**Human requester verified 2026-11-09, 14:47 UTC:** `pam-rd-folder-admin` is `AVAILABLE`, with `user:contractor-amplifi-jsilva@trekai.org` as its sole eligible requester. A separately approved read-back confirmed the eight-hour maximum, Folder Admin role, existing two approvers with one approval required, and both justification requirements. The service account is no longer in this entitlement's eligible requester list. Terraform's approved update reported zero added, one changed, zero destroyed. Jeferson's actual request/approval/access/expiry flow remains untested; no grant was requested or approved here. The earlier creation plan is consumed and must not be reused.

The entitlement lets `contractor-ait-boopathin@trekai.org` request `roles/logging.viewer` for up to eight hours. One approval from either `smanley@trekai.org` or `pmossman@trekai.org` is required, with requester and approver justifications. A folder-level role is inherited by descendant projects, including future projects; Logs Viewer covers more than bastion logs and does not automatically include private Data Access audit logs or all custom log destinations.

The existing `rd-bastion-logs-contractor` entitlement is **project-scoped** in `trekai-prj-rd-app-mgmt`. This separate folder-scoped entitlement does not import, alter, or delete the existing one. Check active grants, approval history and dependencies before deciding whether to retire the old entitlement separately.

The Terraform root for this guide is [`terraform/pam/rd/`](../../../terraform/pam/rd/).

**Boopathi addition applied and live-verified 2026-11-11, 14:19 UTC.** The user confirmed "proceed with admin same as jeferson" after the distinction between Folder Admin and VM administration was explained, requested the Terraform commands one by one and approved the exact saved-plan apply under their review for this change. Terraform reported zero added, one changed and zero destroyed. A separate read-back confirmed `pam-rd-folder-admin` is `AVAILABLE` with `user:contractor-ait-boopathin@trekai.org` and `user:contractor-amplifi-jsilva@trekai.org` as exactly its two eligible requesters. Folder, role, eight-hour maximum, approvers and justification requirements match the approved settings. No independent human review is claimed. No PAM grant request or approval ran; the requester/access/expiry lifecycle remains untested.

## Monitoring and GKE viewer access

**Applied 2026-11-13, 14:11 UTC; live-verified at 14:13 UTC.** The user approved step 3 after the exact saved-plan result and review requirement were presented. Execution approval explicitly disclosed that no independent human review was recorded and authorized proceeding under the user's review for this change; no independent review is claimed. Terraform reported **1 added, 0 changed, 0 destroyed**. A separate read-back confirmed `AVAILABLE` and passed all eleven checks for the exact folder, human requester, three roles, duration and approval controls below. The saved plan is consumed; no PAM grant was requested or approved here. See the [change record](#change-record) for identity, backend, plan hash and receipts.

**Earlier review findings, 2026-11-13, 13:58–13:59 UTC, before this addition.** The user requested a review of Boopathi's RD PAM access against Logs Viewer and the three named Monitoring/GKE roles. At that time he was directly eligible for Logs Viewer and Folder Admin, both `AVAILABLE`; none of the folder's three entitlements contained the requested Monitoring/GKE roles and no group eligibility was present. His four Logs Viewer grants and one Folder Admin grant were all `ENDED`. Those findings led to the now-deployed entitlement below. This was a folder PAM review, not an assessment of overall effective access.

| Requested role | Current RD PAM configuration, verified 2026-11-13 |
|---|---|
| `roles/logging.viewer` | Live-confirmed in `pam-rd-folder-logs-viewer-ait` on 2026-11-13, `AVAILABLE`, with Boopathi directly eligible. Keep the separate request path. |
| `roles/monitoring.viewer` | Live-confirmed in `pam-rd-folder-observability-viewer`, `AVAILABLE`. |
| `roles/monitoring.dashboardViewer` | Live-confirmed in `pam-rd-folder-observability-viewer`; retained as explicitly requested, although its current permissions are included in Monitoring Viewer. |
| `roles/container.viewer` | Live-confirmed in `pam-rd-folder-observability-viewer`, `AVAILABLE`. |

[Google's Monitoring role reference](https://docs.cloud.google.com/iam/docs/roles-permissions/monitoring), checked 2026-11-13, lists all four Dashboard Viewer permissions in Monitoring Viewer. [Folder Admin](https://docs.cloud.google.com/resource-manager/docs/access-control-folders) administers folders and IAM; it does not itself provide these Monitoring or GKE service permissions. [GKE Viewer](https://docs.cloud.google.com/iam/docs/roles-permissions/container) is the requested Kubernetes Engine read role. These role definitions do not establish the user's effective access through other bindings or groups.

| Live-verified setting, 2026-11-13 | Value |
|---|---|
| Entitlement | `pam-rd-folder-observability-viewer` |
| Parent and access target | RD folder `653186815477`, inherited by descendant projects |
| Eligible requester | `user:contractor-ait-boopathin@trekai.org` |
| Roles | Exactly the three Monitoring/GKE roles above |
| Maximum duration | `28800s` (eight hours), matching existing entitlements |
| Approval | One of the existing two approvers, `smanley@trekai.org` or `pmossman@trekai.org` |
| Justifications | Required from requester and approver by the existing module |
| Terraform address | `module.rd_folder_observability_viewer.google_privileged_access_manager_entitlement.this` |
| Root and state | Existing `terraform/pam/rd/`; GCS `devops-hq-bucket` / `pam/rd-folder` |

Boopathi can now sign in as `contractor-ait-boopathin@trekai.org`, select RD (`653186815477`) in Privileged Access Manager, open **My entitlements**, and click **Request grant** beside `pam-rd-folder-observability-viewer`. Enter the task justification and required duration (up to eight hours), then click **Request grant**. Access activates only after approval. These service permissions apply to his human Console/CLI identity without service-account impersonation. When he also needs logs, he must separately request `pam-rd-folder-logs-viewer-ait`; this entitlement does not bundle Logs Viewer. No grant was submitted or approved by this operation. Actual requester/approval/access/expiry testing remains outstanding.

Alternatively, Boopathi runs these commands on his own workstation or Cloud Shell, using his human account. Replace the justification with the actual task/ticket. Ensure the active gcloud configuration is not implicitly impersonating a service account.

```bash
gcloud auth login --account=contractor-ait-boopathin@trekai.org

gcloud pam grants create \
  --entitlement=folders/653186815477/locations/global/entitlements/pam-rd-folder-observability-viewer \
  --requested-duration=28800s \
  --justification='REPLACE WITH task or ticket and reason for RD monitoring access' \
  --account=contractor-ait-boopathin@trekai.org
```

One of `smanley@trekai.org` or `pmossman@trekai.org` must approve; verify the request reaches `ACTIVE` before testing access. `28800s` is eight hours; he can request less. For logs, make a separate request using entitlement `pam-rd-folder-logs-viewer-ait`. Commands were checked against local gcloud help and [Google's request lifecycle documentation](https://docs.cloud.google.com/iam/docs/pam-request-temporary-elevated-access) on 2026-11-13; the contractor request flow has not been executed here.

The live read-back verifies the entitlement settings, not actual resource access. Entitlement ownership/end date, organization/project entitlements, group membership, direct/inherited effective IAM, private/custom log destinations and cross-project Monitoring metrics scopes remain unverified. Folder-level grants cover descendant projects; they do not guarantee access to resources outside RD. Future changes require a fresh reviewed plan under the agreed authorization process. Do not reuse the consumed saved plan.

## How the configuration is organized

[`access-policy.tf`](../../../terraform/pam/rd/access-policy.tf) is the reviewable source of the RD folder ID and each entitlement's requester, approvers, role, duration and name. [`main.tf`](../../../terraform/pam/rd/main.tf) passes those values into instances of the narrow [folder PAM entitlement module](../../../terraform/modules/pam-folder-entitlement/), which derives both the entitlement parent and resource from the same ID and enforces the approval settings; the root chooses each role (deployed Logs Viewer and Folder Admin). The file uses a Terraform `locals` block: “local” means the names are scoped to this Terraform root; it does not mean the file stays on this computer or is excluded from Git. Naming the folder once keeps the parent and access target consistent. These values describe a confidential access policy rather than credentials. Keep the repository private and approved for TrekAI data, and allow only authorized reviewers and maintainers to read or change it. Never put passwords, tokens or keys here. The GCS backend holds Terraform state; it does not automatically store or protect this source file. Do not move access rules to ignored variable files merely to hide them from reviewers.

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

The initial 2026-11-09 deployment made Jeferson's service account eligible, followed by an applied and verified switch to his human console account `contractor-amplifi-jsilva@trekai.org`. On 2026-11-11, Terraform added Boopathi's human account to the same entitlement, and a separate live read-back verified both requesters and all approved controls. The earlier deployment and verification records below remain historical evidence. Requester/approval/access/expiry tests remain outstanding.

| Setting | Approved access setting / execution scope |
|---|---|
| Entitlement | `pam-rd-folder-admin` |
| Parent and access target | RD folder `653186815477` |
| Verified eligible requesters (2026-11-11) | `user:contractor-amplifi-jsilva@trekai.org`, `user:contractor-ait-boopathin@trekai.org` |
| Previous requester (removed from eligibility) | `serviceAccount:sa-jeferson-amplifi01@trekai-ws-app-mgmt-452018.iam.gserviceaccount.com` |
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

The initial entitlement made the **service account** eligible. The applied and live-verified Terraform update replaces it with Jeferson's **human user account**. After that update is applied, he can request and use elevated access while signed into the Google Cloud console as `contractor-amplifi-jsilva@trekai.org`, or use `gcloud` directly as that account. The documented impersonation bindings are separate IAM configuration and are unchanged by this request. No grant revocation or service-account IAM change is included. Existing grants and current effective access have not been rechecked for this switch.

### Console and CLI requests after the requester switch

**Boopathi, after the verified 2026-11-11 addition:** sign into the console as `contractor-ait-boopathin@trekai.org`, select `trekai-rd` (`653186815477`), open Privileged Access Manager and request `pam-rd-folder-admin` with a task justification for up to eight hours. One of the designated approvers must approve before access activates. Use the human account directly, without service-account impersonation. The CLI examples below illustrate Jeferson's identity; Boopathi uses his own account in each command. These request/approval/access/expiry steps have not been executed or tested here.

With the human-requester update now verified, Jeferson signs into the Google Cloud console as `contractor-amplifi-jsilva@trekai.org`, selects folder `trekai-rd` (`653186815477`), opens Privileged Access Manager, and requests `pam-rd-folder-admin` for eight hours with his task justification. One designated approver reviews the request. Elevated permissions apply to his human identity.

Alternatively, these direct CLI commands are for **Jeferson** after that update. They have not been executed here:

```bash
gcloud auth login --account=contractor-amplifi-jsilva@trekai.org
```

First confirm eligibility using a read-only search as his user account:

```bash
gcloud pam entitlements search \
  --folder=653186815477 \
  --location=global \
  --caller-access-type=grant-requester \
  --account=contractor-amplifi-jsilva@trekai.org
```

Submit the eight-hour request with a real task/ticket justification:

```bash
gcloud pam grants create \
  --entitlement=folders/653186815477/locations/global/entitlements/pam-rd-folder-admin \
  --requested-duration=28800s \
  --justification='REPLACE WITH task or ticket and reason for folder administration' \
  --account=contractor-amplifi-jsilva@trekai.org
```

One designated approver must approve before access activates. For subsequent administrative CLI commands, use `--account=contractor-amplifi-jsilva@trekai.org` without service-account impersonation. Check that the active configuration is not implicitly impersonating a service account. Quota-project/API permissions may also be needed; do not grant them automatically if a command fails. Verify the grant reaches `ACTIVE`, test the intended access while signed in as the user, then verify expiry or early revocation. Terraform ADC is separate from gcloud login; these examples do not configure Terraform credentials.

References checked 2026-11-09: [CLI grant creation](https://docs.cloud.google.com/sdk/gcloud/reference/pam/grants/create), [eligibility search](https://docs.cloud.google.com/sdk/gcloud/reference/pam/entitlements/search), and [PAM request lifecycle](https://docs.cloud.google.com/iam/docs/pam-request-temporary-elevated-access).

## Offline checks

`terraform fmt -check -recursive` checks formatting. `terraform init -backend=false` and `terraform validate` require the specified provider to be available locally or downloaded from a trusted registry; they do not verify live state or effective access. Provider version `7.22.0` is an initial explicit pin, subject to team review. The lock file records hashes for the installed provider; add other supported platforms through the normal provider-lock workflow before using it elsewhere.

## Change record

**2026-11-13: exact saved-plan apply succeeded, 14:11:35–14:11:54 UTC; live settings verified at 14:13:28 UTC.** The user replied "approved" after step 3 and the exact saved-plan scope were presented. Execution approval explicitly disclosed that no independent human review was recorded and authorized applying under the user's review for this change; no independent review is claimed. The runner rechecked Terraform `1.17.1`, the exact saved-plan SHA-256 below, all root/module/lock hashes, the active RD folder identity, unchanged backend-state object generation, existing GCS backend and `default` workspace before applying. It selected `smanley-adm@trekai.org` impersonating `terraform-org-admin@trekai-452018.iam.gserviceaccount.com`, provider project `trekai-prj-rd-app-mgmt` and quota project `trekai-452018`, with short-lived credentials only in child-process memory. No login/ADC configuration was changed.

`terraform apply` used the exact saved plan without a new plan, migration, import or lock override. Native exit `0`; native summary **1 added, 0 changed, 0 destroyed**. A separate authorized read-only `gcloud pam entitlements describe` under the same identity returned `AVAILABLE` and passed all eleven checks: exact name/folder and IAM resource, exactly the three requested roles without conditions, only Boopathi's human requester, `28800s`, one approval from the exact existing two approvers, and both justification requirements. No PAM grant request/approval/revocation or separate direct IAM change ran; no commit/push ran. Actual contractor sign-in/request/approval/access/expiry testing and entitlement owner/end date remain follow-ups.

Consumed plan SHA-256: `dbde1b5ed46d077a86405d74e64eff5d9f927d38a1143969fb205fc537e2b65b`. **Do not reapply this plan.** Private ignored summary receipts are `terraform/pam/rd/.terraform/observability-plan-20261113/apply-execution.json`, `verification.json` and `completion.json`; raw output and credentials were suppressed. Source comments and current-status documentation were updated only after apply and live verification, so future work requires a fresh plan. The entries below are historical pre-deployment checkpoints.

**2026-11-13: authorized step 2 completed, 14:07:21–14:07:38 UTC; exact saved plan ready, no apply.** The user explicitly requested "can you run the step 2" after the commands, identity, backend and plan-only scope were presented. Execution selected the reauthenticated gcloud source account `smanley-adm@trekai.org`, impersonated `terraform-org-admin@trekai-452018.iam.gserviceaccount.com`, provider project `trekai-prj-rd-app-mgmt` and quota project `trekai-452018`. As in prior RD planning runs, a short-lived impersonated credential was captured into child-process memory; no ADC/login configuration was changed and no credential was printed or saved. Read-only checks confirmed active `trekai-rd` folder `653186815477` under organization `470598084059`, and metadata for the existing `devops-hq-bucket` / `pam/rd-folder/default.tfstate` object.

Fresh private Terraform metadata initialized the existing GCS backend without migration, import or lock override, reusing Terraform `1.17.1`, cached provider `7.22.0` and the unchanged lock file; no provider download ran. Workspace check confirmed `default`. Init, workspace, formatting, validation and saved-plan rendering exited `0`; plan exited `2` (changes). The JSON plan review confirmed exactly **1 create, 0 updates, 0 deletes**, only `module.rd_folder_observability_viewer.google_privileged_access_manager_entitlement.this`, with no resource drift. Both existing entitlements are no-ops. The new entitlement targets RD folder `653186815477`, only Boopathi's human requester, exactly `roles/monitoring.viewer`, `roles/monitoring.dashboardViewer` and `roles/container.viewer`, maximum `28800s`, one approval from the existing approver set and mandatory requester/approver justifications. Root/module/lock hashes were checked before and after planning and remained unchanged.

Saved-plan SHA-256: `dbde1b5ed46d077a86405d74e64eff5d9f927d38a1143969fb205fc537e2b65b`. Artifacts are owner-only and Git-ignored under `terraform/pam/rd/.terraform/observability-plan-20261113/`: `rd-observability.tfplan` (mode `0600`), `manifest.json`, `execution.json`, `plan-review-summary.json` and isolated `data/` metadata (directory mode `0700`). Raw cloud and Terraform output were processed in memory and suppressed; summary receipts contain no credentials. No apply, direct IAM change, PAM request/approval/revocation, commit or push ran. Independent human review and authorization of this exact saved-plan apply remain pending; entitlement owner/end date and actual requester/approval/access/expiry tests remain follow-ups. Recheck plan/source hashes and backend before any approved apply; stale plans must be regenerated and reviewed.

**2026-11-13: live RD PAM review completed; observability addition remains a local draft.** Authorization: the user requested review of Boopathi's current PAM access on RD folder `653186815477` against Logs Viewer and the three named Monitoring/GKE roles, to prepare another request path. Added the proposed `rd_observability_entitlement` local and `rd_folder_observability_viewer` module call for the three named service roles, retaining the existing requester/approver pattern and eight-hour maximum as proposed settings. Existing entitlement settings, module implementation, backend prefix, provider pins and lock file are unchanged. No new root or state is proposed.

The targeted read-only `gcloud pam entitlements list` selected source `smanley-adm@trekai.org`, impersonated caller `terraform-org-admin@trekai-452018.iam.gserviceaccount.com`, quota project `trekai-452018`, folder `653186815477`, location `global`. The sandbox attempt failed; the approved retry required reauthentication. After the user completed login and said "done", the read succeeded at **13:58 UTC**. A follow-up authorized list and `gcloud pam grants list` for his two eligible entitlements succeeded at **13:59 UTC**. Summarized results: both existing entitlements `AVAILABLE`, exact folder target, Logs Viewer / Folder Admin roles only, eight-hour maximum, existing approvers, one required approval and both justifications; zero of the folder's three entitlements contains a requested Monitoring/GKE role; proposed name unused; his four log grants and one admin grant all `ENDED`. These reads do not prove actual resource access or successful expiry enforcement.

Checks passed: repository-wide `terraform fmt -check -recursive`, `git diff --check`, and isolated `init -backend=false -input=false -lockfile=readonly` plus `validate`, using Terraform `1.17.1` and the cached Google provider `7.22.0` without downloads. Validation initially hit the sandbox provider-handshake restriction; the approved backend-disabled retry outside the sandbox passed. Temporary metadata was removed, cloud credential environment settings were stripped from the validation process, and the lock file remained unchanged. Raw cloud output and credentials were suppressed. No live backend init, Terraform plan/state operation, apply, direct IAM change, PAM grant request/approval, commit or push ran. Independent review, owner/end date, state/conflict checks and an authorized fresh live plan/apply/read-back remain pending. This draft is not an entitlement the contractor can request yet.

**2026-11-11: exact saved-plan update applied and live settings verified, 14:19 UTC.** The user requested "can you run the commands one by one" after the exact saved-plan commands and independent-review requirement were shown. Commands ran sequentially, with results checked between them: live backend init at **14:18:00–14:18:03 UTC**, local saved-plan show at **14:18:18 UTC**, then exact-plan apply at **14:18:46–14:19:06 UTC**. Before apply, the execution approval explicitly disclosed that independent review was not recorded and asked to proceed under the user's review for this change; execution was approved. No independent human review is claimed. The reviewed plan hash, all root/module/lock hashes and existing GCS backend/default workspace were checked before execution. The same explicit `smanley-adm@trekai.org` → `terraform-org-admin@trekai-452018.iam.gserviceaccount.com` identity and provider/quota projects recorded in the plan were used. All three commands exited `0`; apply reported **0 added, 1 changed, 0 destroyed**.

A separately approved read-only `gcloud pam entitlements describe` under the same identity confirmed `AVAILABLE` and passed all ten setting checks: exact folder/name and access target, exactly Jeferson and Boopathi as human requesters, only Folder Admin, `28800s`, one approval from the existing two approvers, and mandatory requester/approver justifications. Summarized private receipts are in `terraform/pam/rd/.terraform/boopathi-plan-20261111/step-init/`, `step-show/`, `step-apply/` and `verification.json`. No credentials were printed or persisted. No PAM grant request, approval, revocation, separate IAM change, migration, import or lock override ran.

Consumed plan SHA-256: `4e6f09495c2ab1d9f0edf4def8091fe8619827ac07da48950cdc194094d7e3fa`. **Do not reapply this consumed plan.** Following verification, source comments and current-status documentation were updated; any future change requires a fresh reviewed plan. Eligibility is deployed and verified; actual sign-in/request/approval/access/expiry testing, contractor end date and entitlement ownership remain follow-ups. The prior planning and local-draft entries below are historical checkpoints.

**2026-11-11: Boopathi saved plan ready; no apply.** The user confirmed the Folder Admin scope, and the execution approval authorized the explicitly described live plan using the existing admin execution identity and RD backend. Planning ran **2026-11-11T14:12:07.702938+00:00–2026-11-11T14:12:25.226433+00:00**, selecting `smanley-adm@trekai.org` impersonating `terraform-org-admin@trekai-452018.iam.gserviceaccount.com`, provider project `trekai-prj-rd-app-mgmt`, quota project `trekai-452018` and default workspace. Read-only checks confirmed the active `trekai-rd` folder `653186815477` under organization `470598084059` and the existing state object in `devops-hq-bucket` / `pam/rd-folder`. Fresh private Terraform metadata reused pinned provider `7.22.0` and the unchanged lock file. Init, validate and show exited `0`; plan exited `2` for changes. No migration, import or lock override ran.

The plan contains **0 creates, 1 in-place update, 0 deletes**, only at `module.rd_folder_admin.google_privileged_access_manager_entitlement.this`. It adds Boopathi's human principal while retaining Jeferson. Local comparison verified the existing sole requester before the change, exactly the two expected human requesters after it, and every other entitlement setting unchanged, including the Folder Admin role, eight-hour maximum, approvers, both justifications and notification settings. The Logs Viewer entitlement is unchanged. All root/module/lock source hashes remained unchanged during planning.

Saved-plan SHA-256: `4e6f09495c2ab1d9f0edf4def8091fe8619827ac07da48950cdc194094d7e3fa`. Owner-only ignored artifacts are in `terraform/pam/rd/.terraform/boopathi-plan-20261111/`: `boopathi.tfplan`, `manifest.json`, `execution.json` and `plan-review-summary.json`. No credentials were printed or persisted; short-lived credentials remained in child-process memory. **No apply, PAM grant request/approval/revocation or separate IAM change ran. Independent human review and approval of this exact saved-plan apply remain pending.** Recheck plan/source hashes and backend before any approved apply; do not reuse the consumed November 9 plans. A subsequent live read-back and real requester/approval/access/expiry test remain separate verification steps.

**2026-11-11: local checks passed.** `terraform fmt -check -recursive` and `git diff --check` passed. The root's older local module metadata lacked `rd_folder_admin`, so validation used fresh temporary `TF_DATA_DIR` metadata with `init -backend=false -lockfile=readonly` and the cached pinned provider. Initialization succeeded without a live backend or provider download. The sandbox blocked the provider handshake; the separately approved offline validation outside the sandbox passed. The lock file was unchanged. These checks establish configuration validity, not effective access.

**2026-11-11: Boopathi Folder Admin eligibility requested; local draft.** Authorization: the user requested PAM admin access on RD for `contractor-ait-boopathin@trekai.org`, then confirmed "proceed with admin same as jeferson" after the role's limitations were explained. Added that human principal to `rd_folder_admin_entitlement.eligible_principals`, retaining Jeferson. Scope: existing `pam-rd-folder-admin`, folder `653186815477`, Terraform address `module.rd_folder_admin.google_privileged_access_manager_entitlement.this`, GCS backend `devops-hq-bucket` / `pam/rd-folder`. The shared module, provider/CLI pins, state address and other entitlement settings are unchanged. No new entitlement, direct IAM grant or PAM grant request/approval is included.

The subsequent check and live-plan records above supersede this local-draft checkpoint. Apply requires review of a fresh exact saved plan under the repository's agreed execution process. Independent human review, contractor end date and entitlement owner remain unconfirmed. Rollback, if later authorized: remove only Boopathi from eligibility, review a fresh plan and apply it; removal does not establish that existing grants or separately created IAM access have been revoked. Real request/approval/access/expiry testing remains outstanding.

**2026-11-09: human-requester update live-verified at 2026-11-09T14:47:33.774609+00:00.** The user said "proceed" after the exact read-only describe command was shown. `gcloud pam entitlements describe pam-rd-folder-admin --folder=653186815477 --location=global` ran under the same explicitly selected `smanley-adm@trekai.org` → `terraform-org-admin@trekai-452018.iam.gserviceaccount.com` path and quota project `trekai-452018`; native exit `0`. The entitlement was **`AVAILABLE`**, and all ten local setting checks passed: exact name/folder resource, sole eligible requester `user:contractor-amplifi-jsilva@trekai.org`, only `roles/resourcemanager.folderAdmin`, `28800s`, one approval from the approved two human approvers, and mandatory requester/approver justifications. The service-account principal is absent from the verified eligibility list.

The owner-only ignored summarized receipt is `terraform/pam/rd/.terraform/human-requester-plan-20261109T144149Z/verification.json`. No grant request, approval, revocation, separate IAM change or further Terraform operation ran during this read-back. The requested requester switch is complete; Jeferson's user sign-in, actual grant workflow, intended administrative access and expiry remain separate end-to-end tests. He uses his own console session or direct user CLI commands without service-account impersonation. The earlier service-account eligibility records below are historical.

**2026-11-09: human-requester exact-plan update applied; read-back pending.** The user said "approved" after the saved plan's sole requester replacement was summarized and apply approval was requested. The user-approved execution path remains one operation at a time; separate live verification was explicitly deferred. No independent human review is claimed. The approved plan hash, all source/lock hashes and existing backend configuration were checked before execution. Apply ran **2026-11-09T14:44:18.908686+00:00–2026-11-09T14:44:39.235631+00:00**, native exit `0`, **0 added, 1 changed, 0 destroyed**, using the same explicitly selected admin-to-service-account execution path, RD backend/default workspace and project/quota settings recorded for the new plan. The only planned update replaced the service-account eligibility with `user:contractor-amplifi-jsilva@trekai.org`; all other reviewed entitlement controls were unchanged.

Consumed update-plan SHA-256: `fc57cd56af4fe35dfcead23bc7c36d5b92f4aaf31ed098207f19919e60735a2f`. Private native output and the apply receipt are under `terraform/pam/rd/.terraform/human-requester-plan-20261109T144149Z/apply-run/`. **Do not reapply this consumed plan.** No new plan, migration, import, lock override, grant request/approval/revocation or service-account IAM change ran. Terraform reported the requester update as complete; direct live verification of the new requester and settings has not yet run and awaits the user's next approval. The prior service-account read-back remains historical evidence only.

**2026-11-09: human-requester saved plan ready; no apply.** Under the user's request to switch the entitlement to the human console identity and the execution approval for a new live plan, backend initialization, local validation and saved planning ran at **2026-11-09T14:42:34.281701+00:00–2026-11-09T14:42:46.961633+00:00**. Execution selected `smanley-adm@trekai.org` impersonating `terraform-org-admin@trekai-452018.iam.gserviceaccount.com`, provider project `trekai-prj-rd-app-mgmt`, quota project `trekai-452018`, default workspace and the unchanged `devops-hq-bucket` / `pam/rd-folder` backend. The existing provider `7.22.0` and lock file were reused; no migration, import or lock override occurred. Init/validate/show exited `0`; plan exited `2` for changes.

The saved plan contains **0 creates, 1 in-place update, 0 deletes**, only at `module.rd_folder_admin.google_privileged_access_manager_entitlement.this`. It replaces the sole eligible principal `serviceAccount:sa-jeferson-amplifi01@trekai-ws-app-mgmt-452018.iam.gserviceaccount.com` with `user:contractor-amplifi-jsilva@trekai.org`. Local comparison confirmed all other access settings unchanged, including folder/ID, role, eight-hour duration, approvers, both justification requirements and notification settings. The existing Logs Viewer entitlement is unchanged. All nine local plan checks passed; source/lock hashes remained unchanged.

Plan SHA-256: `fc57cd56af4fe35dfcead23bc7c36d5b92f4aaf31ed098207f19919e60735a2f`. Private owner-only ignored artifacts are under `terraform/pam/rd/.terraform/human-requester-plan-20261109T144149Z/`: `human-requester.tfplan`, `manifest.json`, `execution.json`, and `plan-review-summary.json`. No credentials were printed or persisted; short-lived token use was confined to child-process environment memory. **Awaiting user approval to apply this exact update, following the requested one-operation-at-a-time path.** No independent human review is claimed. No requester update, PAM grant request/approval/revocation or service-account IAM change has run. The initial creation plan is consumed; it must not be reused for this update. The new plan requires separate apply approval and subsequent live verification.

**2026-11-09: human console requester switch requested; local draft.** After the initial service-account entitlement deployment, the user requested: "let's switch it to his console account instead of service account" and supplied `contractor-amplifi-jsilva@TrekAI.org`. The reviewed member identifier uses the existing lowercase domain form, `user:contractor-amplifi-jsilva@trekai.org`. Replaced the sole eligible service-account principal with this user in `access-policy.tf`; no second eligible principal is added. Folder, entitlement ID, role, eight-hour maximum, approvers, justification controls, state address, backend, provider lock and shared module are unchanged. Updated the request runbook for the human console/direct CLI flow. No user sign-in, grant request/approval/revocation or service-account IAM change ran. The last verified live requester remains the service account until a fresh plan is reviewed, applied and read back. The prior creation plan is consumed and cannot authorize this change. Continue with the established one-operation-at-a-time review path using the same explicitly selected execution identity and backend.

**2026-11-09: command 3, live entitlement settings verified at 2026-11-09T14:36:02.221626+00:00.** The user separately said "proceed" for command 3. `gcloud pam entitlements describe` ran read-only on folder `653186815477`, using `smanley-adm@trekai.org` impersonating `terraform-org-admin@trekai-452018.iam.gserviceaccount.com`, quota project `trekai-452018`; native exit `0`. The entitlement was **`AVAILABLE`**. Local comparison confirmed the exact entitlement name and folder resource, sole named Jeferson service-account requester, only `roles/resourcemanager.folderAdmin`, `28800s` maximum, one approval from either approved human approver, and mandatory requester/approver justifications. All ten setting checks passed. A summarized verification receipt is owner-only and ignored at `terraform/pam/rd/.terraform/admin-plan-20261109T142126Z/step-3-verification.json`; no raw live policy was added to the guide.

Commands 1–3 are complete. This verifies entitlement deployment and settings, not Jeferson's ability to mint a token, request a grant, receive approval, administer the intended resources or lose elevated access at expiry. **No PAM grant was requested or approved.** Next, Jeferson uses the CLI request instructions above under his own login, a designated human approver reviews the request, and the relevant people test access and expiry. Contractor end date, entitlement ownership and effective service-account access-path review remain follow-ups. No further live operation is authorized by this completion record.

**2026-11-09: command 2, exact saved-plan apply succeeded (command 3 was pending at this checkpoint).** The user requested commands 1–3 one at a time with approval. Command 1 re-rendered the saved plan locally and confirmed the plan hash, source hashes and one-create summary. The user then said "proceed" after the exact-plan apply and independent-review requirement were described. The agent stated it was treating that direction as user-reviewed execution for this specific change; no independent human review is claimed. Source account, caller, provider/quota projects and existing GCS backend remained as recorded for planning. Apply ran **2026-11-09T14:33:36.726569+00:00–2026-11-09T14:33:57.242235+00:00**, native exit `0`, **1 added, 0 changed, 0 destroyed**. No new plan, migration, import, lock override, extra IAM grant or PAM request/approval was run.

Consumed plan SHA-256: `7dd82a51a43071960d9bc5ff6e87800a27ed321fc38599b5a1a079d4bdb29d6e`. The plan/source hashes and backend configuration were checked before execution; short-lived credentials stayed in child-process memory. Private native output and execution metadata are in `terraform/pam/rd/.terraform/admin-plan-20261109T142126Z/apply-run/`. **Do not reapply the consumed plan.** Terraform reported creation of the approved entitlement; its separate `gcloud pam entitlements describe` read-back (command 3) has not run and awaits the user's approval. Availability, exact live settings and the contractor's grant lifecycle remain unverified until those checks complete.

**2026-11-09: authorized live initialization and saved plan completed, 14:22:58–14:23:12 UTC; no apply.** The user said "proceed" after the plan-only scope was restated. Execution used gcloud credentials explicitly selected as `smanley-adm@trekai.org` impersonating `terraform-org-admin@trekai-452018.iam.gserviceaccount.com`, quota project `trekai-452018`, and provider project `trekai-prj-rd-app-mgmt`. Short-lived credentials were held in child-process environment memory; no ADC/login configuration was changed. Metadata-only access verified the existing `pam/rd-folder/default.tfstate` object in `devops-hq-bucket`. Fresh private Terraform metadata initialized that existing GCS backend in the default workspace; initialization exited `0`. The local Google provider `7.22.0` and unchanged lock file were reused, with Terraform `1.17.1`. No migration, import or lock override was used.

The saved plan exited `2` (changes present), and local JSON inspection exited `0`: **1 create, 0 updates, 0 deletes**. The only create is `module.rd_folder_admin.google_privileged_access_manager_entitlement.this`; `module.rd_folder_logs_viewer.google_privileged_access_manager_entitlement.this` is unchanged. Local checks matched folder `653186815477`, entitlement `pam-rd-folder-admin`, `roles/resourcemanager.folderAdmin`, the sole named Jeferson service-account requester, `28800s`, one of the two approved human approvers, and mandatory requester/approver justifications. All seven root/module/lock source hashes remained unchanged during planning.

Saved plan SHA-256: `7dd82a51a43071960d9bc5ff6e87800a27ed321fc38599b5a1a079d4bdb29d6e`. Sensitive plan and diagnostics are owner-only, local and ignored under `terraform/pam/rd/.terraform/admin-plan-20261109T142126Z/`; plan file `pam-rd-admin.tfplan`, authorization/source manifest `manifest.json`, native execution record `execution.json`, and corrected local inspection `plan-review-summary.json`. The initial wrapper's local checker rejected an empty optional `not_mandatory` field rendered alongside `unstructured`; Terraform's native operations had succeeded. A separate local inspection confirmed `not_mandatory` is empty and requester justification is mandatory. All setting checks passed; no cloud operation was repeated for this correction. The original execution record is preserved.

**Historical checkpoint before command 2 (superseded by the apply record above):** independent human review was not recorded; no review exception was requested for this change. The saved plan has not been applied. No entitlement, separate IAM grant, PAM request/approval, API or service-agent change was made by this operation. Applying the exact plan would create the approved entitlement and update only this root's state. Stop if the saved plan hash, reviewed Terraform inputs, identity, backend or proposed scope changes; obtain a fresh plan when required rather than applying an unreviewed replacement.

**2026-11-09: access-settings approval.** In response to the review summary asking to confirm Folder Admin and the existing approvers, the user replied "approved". Recorded approval of `roles/resourcemanager.folderAdmin`, the named Jeferson service-account requester, eight-hour maximum and one of the existing two approvers. This is user review of the access settings, not independent human review or authorization of an unseen Terraform plan. No live backend initialization, plan or apply has run for this addition. The earlier local validation remains applicable because only comments and documentation changed.

### Authorized operation: live initialization and plan only

The user authorized this operation by saying "proceed" on 2026-11-09 after its identity, backend and plan-only scope were described. It completed as recorded below; these bullets preserve the authorized scope:

- Source login: `smanley-adm@trekai.org`; caller: `terraform-org-admin@trekai-452018.iam.gserviceaccount.com`, selected explicitly per operation using short-lived impersonated credentials. This follows the prior RD execution path; it is highly privileged and is not a new standing access grant. Keep tokens only in child-process environment memory; do not print or persist them, and do not assume the current Terraform ADC identity matches the gcloud login.
- Terraform root: `terraform/pam/rd`; project: `trekai-prj-rd-app-mgmt`; quota project: `trekai-452018`; workspace: `default`; backend: `devops-hq-bucket` / `pam/rd-folder`.
- Use fresh owner-only temporary Terraform metadata and plan storage, the existing provider installation and unchanged lock file. Initialize the existing backend with `init -input=false -lockfile=readonly` and the local provider directory. Stop on migration prompts, state conflicts, authentication/permission failures or unexpected state ownership; no forced migration or imports.
- Run `plan -input=false -detailed-exitcode -lock-timeout=60s -out=<private-plan-path>` with locking enabled. This reads live state and cloud metadata and may use normal backend lock objects. Save sensitive output privately and summarize the exact saved plan without copying raw state or plan data into chat or docs.
- Expected result: exactly one create at `module.rd_folder_admin.google_privileged_access_manager_entitlement.this` with the approved settings above, and no change to `module.rd_folder_logs_viewer`. Stop on any other create, update, replacement or delete. Inspect the saved plan locally, record its hash and checked settings for review.
- No apply, PAM request/approval, API enablement, service-agent changes or separate IAM grants. A future apply needs review of that exact plan, the repository's independent human review requirement (or an explicit user-directed exception for this change), and separate exact-plan apply authorization.


**2026-11-09: proposed Jeferson folder-admin entitlement (local only).** Authorized preparation and targeted read-only impersonation lookup by the user's request in conversation; user supplied the workstation service-account email and completed admin reauthentication. Added a second module instance in the existing RD root, reusing its folder, backend, pinned versions and approval module. The candidate grants Folder Admin to the impersonated service account for up to eight hours with one existing approver and both justifications. Role scope, service-account requester and approvers were subsequently approved by the user on 2026-11-09; no broader service roles or new impersonation bindings are included. The existing Logs Viewer entitlement and shared module are unchanged. Execution identity for a future Terraform plan/apply remains to be approved separately; the lookup used the human admin directly, without `terraform-org-admin` impersonation. Before deployment: confirm role/approvers, administrative identity suitability, owner/end date, independent human review, state ownership and absence of conflicting IAM management; authorize a live backend/plan operation, review the exact plan, then separately authorize applying that plan. No backend init, live plan, state operation, apply, PAM request or PAM approval ran. Local checks on 2026-11-09: repository-wide `terraform fmt -check -recursive` passed; `init -backend=false -input=false -lockfile=readonly` in an isolated temporary data directory reused the installed Google provider `7.22.0` with the existing lock file and no provider download; `validate -no-color` passed. The first validation could not start the provider inside the sandbox; the same backend-disabled validation succeeded after execution approval outside the sandbox. Terraform CLI `1.17.1` was used; gcloud `592.0.0` was observed (the documented workstation baseline remains `591.0.0`). Local validation does not verify live IAM or the grant lifecycle.

**2026-11-04: rename and `roles` input (committed in `72aa46b`; plan verified 2026-11-04).** Renamed `terraform/PAM/` to `terraform/pam/` and `terraform/modules/pam-folder-logs-viewer/` to `terraform/modules/pam-folder-entitlement/`; the matching docs moved too. The module's hardcoded `roles/logging.viewer` became a required `roles` input, and this root passes `["roles/logging.viewer"]`. Unchanged: module label `rd_folder_logs_viewer` (same state address, no `moved` block), backend prefix `pam/rd-folder`, entitlement ID and lock file. Authorized by the repository owner in conversation. Verified locally: `terraform fmt -check -recursive` and `init -backend=false -lockfile=readonly` + `validate` passed. **Live verification (2026-11-04):** with the user's explicit authorization in conversation, `terraform init -input=false -lockfile=readonly` against `devops-hq-bucket`/`pam/rd-folder` and `terraform plan -input=false -detailed-exitcode` (no saved plan) were run from commit `72aa46b`, using ADC as `smanley-adm@trekai.org` impersonating `terraform-org-admin`. Init resolved the module at the new path; the plan reported "No changes" (exit code 0) for `module.rd_folder_logs_viewer.google_privileged_access_manager_entitlement.this`. Nothing was applied.
