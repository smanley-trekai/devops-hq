# Hub staging API-administration PAM

**Applied and settings live-verified, 2026-11-20, 15:58 UTC.** The user approved the exact saved plan under their review for this change. One guarded apply reported **one entitlement added, zero changed, zero destroyed**. A separate direct read-back confirmed **AVAILABLE** and all eleven target/access-setting checks passed. Jeferson can request the staging API-administration entitlement for up to eight hours, with a simple description and one approval from either existing RD approver. No independent human review is claimed. No PAM grant was requested/approved and real requester/access/expiry tests remain outstanding. The saved plan is consumed and must never be replayed.

## Access and ownership

| Setting | Applied / verified value |
|---|---|
| Root | [`terraform/pam/hub-staging/`](../../../terraform/pam/hub-staging/) |
| Folder | `777554202891`, live-confirmed ACTIVE with display name `trekai-staging` on 2026-11-20 |
| Entitlement | `pam-hub-staging-service-usage-admin` |
| Role | `roles/serviceusage.serviceUsageAdmin` |
| Eligible requester | `user:contractor-amplifi-jsilva@trekai.org` |
| Approval | One approval from `user:smanley@trekai.org` or `user:pmossman@trekai.org`, matching RD |
| Requester justification | Required simple description; no ticket requirement or format validation |
| Approver justification | Required by the existing shared module |
| Maximum grant | `28800s` / eight hours; shorter requests permitted |
| Backend / workspace | `devops-hq-bucket` / `pam/hub-staging` / `default` |
| Terraform / Google provider | `1.17.1` / `7.22.0`; unchanged copy of the RD provider lock |
| Administrative execution path | Preflight, plan, apply and verification used `smanley-adm@trekai.org` impersonating `terraform-org-admin@trekai-452018.iam.gserviceaccount.com`; quota project `trekai-452018` |
| Accountable owner / eligibility end | Unconfirmed; record the responsible owner and eligibility-removal process |

The role allows enabling, disabling and inspecting project APIs, plus its other predefined Service Usage permissions. It is not an enable-only custom role and is not limited to Speech APIs. Folder inheritance covers all descendant projects, including future descendants. Changes made during a grant, including API enablement or disablement, remain after the temporary binding expires. The grant maximum does not set an end date on requester eligibility.

The user confirmed folder `777554202891`. [PR #232](https://github.com/ethos-insights/tl-trekai-terraform/pull/232), head `5f1d8fa239d954d0809cbaaa2bdedbc3670b0d19`, declares staging app project `trekai-prj-stage-app-mgmt` and staging network-host project `trekai-prj-stage-net-host` under that folder. Scoped live preflight on 2026-11-20 confirmed both projects ACTIVE and direct children of the target folder; this was not a complete descendant inventory. The PR adds Speech and Text-to-Speech APIs to staging and production; its proposed four additions were not a verified plan.

That PR's `organization/project` root also manages projects, billing and IAM beyond staging. Its backend is `trekai-452015-org-tfstate`, prefix `organization/projects`; its provider uses runtime credentials without specifying Jeferson's execution identity. This entitlement adds no access to that shared state, no impersonation rights and no general Terraform-builder roles. It does not establish that Jeferson can plan or apply that root. Keep the existing authorized execution path for the PR unless a separate reviewed delegation is agreed. Dev and production PAM are outside this root.

The shared [folder entitlement module](../modules/pam-folder-entitlement.md) supplies manual approval, both justifications and `prevent_destroy`. It does not create APIs, service agents or prerequisite IAM. Do not add duplicate ownership of APIs already managed in the application-infrastructure repository. No direct IAM policy resource is introduced here. Review any existing authoritative bindings for conflicts with PAM before deployment.

## Preparation and execution

1. Inspect this root and its shared module; preserve unrelated local work. Confirm exact role breadth, requester, approvers and target. Reuse the reviewed lock without checksum edits or upgrades.
2. Run `terraform fmt -check -recursive`. Validate in a private isolated copy using `terraform init -backend=false -input=false -lockfile=readonly` and the existing trusted provider cache, then `terraform validate -no-color`. Clear cloud credential/CLI overrides for local checks. These checks do not verify cloud access.
3. Under the user's scoped creation authorization, verify the administrative source/caller identities, ACTIVE folder/parent, staging target projects' parent, PAM readiness and grantability of the role. Check the new entitlement name and backend prefix are unused. Inspect relevant folder IAM in memory for PAM's service-agent prerequisite and conflicting role bindings without publishing raw IAM or state. Stop for authentication/permission failures, existing ownership, unexpected targets or required prerequisite changes.
4. After the preflight, initialize only `devops-hq-bucket` / `pam/hub-staging` in the default workspace with locking enabled and the pinned read-only lock. Stop on state migration/conflicts. Use a private execution copy with credentials only in child-process memory; do not write tokens into source, backend configuration or logs.
5. Produce a full saved plan. Expected scope is exactly **one entitlement added, zero changed, zero destroyed** at `module.hub_staging_api_admin.google_privileged_access_manager_entitlement.this`. Compare its complete settings with the table, record plan/source/lock hashes and check ownership again. No apply is authorized by local validation alone.
6. Seek independent human review and obtain approval of the exact plan under the agreed review path before applying it once. If the user explicitly chooses their own review for this change, record that and do not claim independent review. Check all hashes, caller, backend, workspace and scope immediately before apply. No import, migration, API enablement, grant request or approval is included.
7. Read back the entitlement and compare its exact folder/access target, name, AVAILABLE state, sole requester/role, eight-hour maximum, two approvers/one approval and both justification requirements. Record the result separately from request/access/expiry tests. Do not activate a grant for Jeferson.

### Preparation checkpoint, 2026-11-20

`terraform fmt -check -recursive terraform` and whitespace checks passed. The broader repository-root formatting check also traverses the ignored `review/` area and flags pre-existing files there; they were left unchanged. Backend-disabled initialization reused the existing Google `7.22.0` installation and unchanged RD lock. Initial sandbox validation could not start the provider; the approved credential-free, backend-disabled retry outside the sandbox returned **Success! The configuration is valid.** The private validation copy is under `/private/var/folders/ph/7b1hm9hs3bld8tmrfdz635c80000gn/T/devops-hq-hub-staging-fxopry9e/`. These checks prove local configuration validity only.

The execution approval authorized scoped preflight and a saved plan using the proposed admin-to-service-account path and new backend prefix, without apply. The active local gcloud account matched `smanley-adm@trekai.org`, but obtaining the impersonated access token failed because the source login requires human reauthentication. The diagnostic retry confirmed that cause without printing/persisting credentials. No Google resource read, live backend initialization, plan, apply, API enablement, IAM mutation or grant operation ran. Filtered failure receipts are private under `/private/var/folders/ph/7b1hm9hs3bld8tmrfdz635c80000gn/T/devops-hq-hub-staging-plan-jk1sfzu2/` and `devops-hq-hub-staging-plan-mykw6jzp/` in the same temporary parent. No current folder, IAM, API, name-availability or backend-ownership fact was established.

The scoped preparation helper is local and ignored at `review/hub-staging-pam-2026-11-20/prepare_plan.py`; syntax parsing passed. It stopped for authentication at this checkpoint, before the successful authorized retry recorded below. The helper stops for prerequisite/ownership mismatches, freezes the root and shared module into a private execution copy, and adds an operator-only provider override selecting project/billing project `trekai-452018` with `user_project_override = true`. Tokens remain in child-process memory; no token is written into provider/backend configuration. Source and execution hashes were captured for exact-plan review. The subsequent separately approved apply is now complete; do not rerun this preparation helper to replace the consumed plan.

### Consumed creation plan, 2026-11-20

The user reported completing `gcloud auth login` and said "proceed to next". The execution approval authorized the previously scoped preflight and saved plan, with no apply. Preflight completed at **15:52:59 UTC** and confirmed the target folder ACTIVE under the expected organization, both staging projects ACTIVE/direct children, PAM enabled in the quota project, the organization PAM service-agent prerequisite and required administrative permissions. The Service Usage Admin role was confirmed grantable at the folder and to include both enable and disable permissions. The folder had no existing PAM entitlements, no direct binding for this role, and the proposed backend prefix was empty. These bounded checks do not prove all inherited/effective access or ownership across every repository/state.

| Plan setting | Reviewed value |
|---|---|
| Result | **1 added, 0 changed, 0 destroyed** |
| Sole resource action | Create `module.hub_staging_api_admin.google_privileged_access_manager_entitlement.this` |
| Target/access | Folder `777554202891`, global location; exact folder resource and type |
| Entitlement | `pam-hub-staging-service-usage-admin` |
| Role/requester | Only Service Usage Admin; only Jeferson's human principal |
| Controls | `28800s`; required unstructured requester description; one of the two named approvers; required approver justification |
| Backend/workspace | `devops-hq-bucket` / `pam/hub-staging` / `default`; locking enabled |
| Operator | Explicit admin-to-service-account path above, quota project `trekai-452018` |
| Saved plan | `/private/var/folders/ph/7b1hm9hs3bld8tmrfdz635c80000gn/T/devops-hq-hub-staging-plan-s7vcppf_/hub-staging-api-admin.tfplan` |
| SHA-256 | `1dae5e2ee0e63c9451feed2dd86d80dbf0494d35330690c6e4fbfe73ed77a976` |

Backend initialization and validation exited 0. The full non-targeted plan began at **15:53:04 UTC** and exited 2 for the expected addition. An in-memory plan comparison passed every configured target/access-setting check and confirmed repository source unchanged. Private plan/log/receipt files are mode 0600 under the mode-0700 execution directory above; `receipt.json` records source, module and execution hashes. Backend metadata was checked for the exact type/bucket/prefix and absence of persisted credentials. No tokens, raw IAM policies or state were printed or copied into documentation. No API enablement, import, state migration, entitlement creation or grant operation ran.

At this historical checkpoint the plan awaited exact-plan approval; no independent human review was recorded. The user subsequently said "approved" to applying this exact plan under their review for this change. Execution and verification are recorded below. The plan is now **consumed**; do not replay it or silently replace it.

### Approved apply and verification, 2026-11-20

The first guarded execution stopped **before any apply** because its prefix-empty check found Terraform's initial state object. Read-only metadata inspection and `terraform show -json` filtered in memory confirmed one `default.tfstate` object, **zero resources and zero outputs**, created at **15:53:03 UTC** during the reviewed backend-initialization window after the empty-prefix preflight and before planning. Its creation/update times matched and generation was `1795189983279313`. The helper was corrected to require this exact unchanged generation and empty resource/output inventory. No state edits, migration, new plan or changes to approved entitlement settings were made. `apply-guard-stop.json` and `backend-check.json` retain this checkpoint privately.

After execution approval, all saved-plan/source/module/lock/execution hashes, CLI version, source/caller identities, backend/default workspace, folder/organization, entitlement-name absence, caller permissions and empty-state generation guards passed. The helper created an exclusive `apply-started.json` marker, retained permanently to prevent replay. One apply ran at **15:58:21–15:58:41 UTC**, exited 0 and reported **1 added, 0 changed, 0 destroyed**, with locking enabled. No independent human review is claimed. Short-lived impersonated credentials stayed in child-process memory, and no token was persisted in provider/backend configuration.

At **15:58:42 UTC**, a separate direct entitlement GET confirmed **AVAILABLE** and passed all eleven checks: exact full name/folder/global location, folder access resource, folder resource type, sole Jeferson human requester, sole unconditional Service Usage Admin role, `28800s`, required unstructured requester description, exactly one approval step requiring one approval, exactly the two named approvers, and required approver justification. This verifies configuration, not real request/approval/API-use/expiry behavior. No grant was requested, approved or revoked, and this operation did not enable any workload APIs or run PR #232.

Private `apply-execution.json`, `apply.log`, `apply-started.json` and `verification.json` alongside the consumed plan record the outcome. The original plan receipt remains historical; the apply and verification receipts record final status. The source status comment was updated only after successful execution, so the original source hashes remain evidence of the exact applied snapshot. Future changes need fresh review and authorization. Accountable ownership, requester eligibility lifecycle, actual access and expiry testing remain follow-ups; nothing was committed or pushed.

## Requester handoff

Deployment and settings verification are complete. Jeferson signs in as `contractor-amplifi-jsilva@trekai.org`, selects folder `777554202891` (`trekai-staging`) in Privileged Access Manager and requests `pam-hub-staging-service-usage-admin`. He provides a brief description and a duration of up to eight hours. One of the two named humans reviews and approves with justification. He confirms the grant is ACTIVE before using his own identity for the approved staging API work. No ticket reference is required.

Test intended project/API access and expiry with the requester and approver. Directory/account status, complete effective access, console usability, real grant lifecycle and API behavior remain unverified until tested. Temporary access expiry removes the PAM binding, not resources or API changes made during access.

## Rollback

Any later change or removal needs its own review and authorization. Review active grants before removing eligibility or the entitlement. The module's `prevent_destroy` requires an explicitly reviewed configuration change for deletion. Removing the entitlement is separate from reversing APIs enabled or disabled during a grant; do not disable workload APIs as an automatic rollback. Never hand-edit state.

## Change record

| Date | Authorization and scope | Outcome | Follow-ups |
|---|---|---|---|
| 2026-11-20 | User said "approved" to the exact one-create saved plan under their review for this change. Execution approvals allowed guarded apply and read-back through the reviewed caller/backend. | Initial prefix guard stopped before apply; read-only inspection proved Terraform's unchanged empty initial state. Revised guard confirmed its exact generation and every plan/source/identity/backend check. One apply at 15:58:21–15:58:41 UTC exited 0: one added, zero changed/deleted. Direct read-back at 15:58:42 UTC confirmed AVAILABLE and all eleven settings. No independent review claimed; no grant operation or workload API change. | Plan consumed; retain replay-prevention marker. Jeferson and an approver test actual request/access/expiry. Confirm accountable owner and eligibility-removal process. No commit/push authorized or performed. |
| 2026-11-20 | User confirmed admin reauthentication and directed proceeding to the next step; execution approval allowed the scoped preflight and saved plan only. | Preflight passed at 15:52:59 UTC. Exact backend initialized, pinned configuration validated and full saved plan produced: one entitlement added, zero changed/deleted. All access-setting/source checks passed; credentials absent from persisted backend configuration. No apply or grant operation; no independent human review recorded. | Review the exact saved plan and agree the human review path before apply. Then guarded single execution and separate live settings verification; real requester/access/expiry tests remain outstanding. |
| 2026-11-20 | User clarified that a simple description is sufficient, with no ticket requirement. Execution approvals allowed cached-provider local validation and scoped live preflight/saved planning without apply. | Formatting, whitespace and backend-disabled validation passed. Active local admin account matched. Both preflight attempts stopped at impersonated-token acquisition; diagnostic retry confirmed human reauthentication required. No Google resource reads, backend initialization, live plan or cloud changes occurred. No independent human review claimed. | User reauthenticates the admin source account, then resume the authorized preflight and saved plan. Review exact plan and agree human review path before apply; requester lifecycle tests remain separate. |
| 2026-11-20 | User requested PAM creation on folder `777554202891`, after narrowing initial work to API administration, staging only, one of the existing two human approvers and eight-hour maximum. Latest correction: simple requester description is sufficient; no ticket required. | Prepared separate root and mirrored guide using the unchanged folder module and pinned versions. Deployment, checks and live status are not yet claimed. Existing unrelated QA desktop guide edit preserved. | Local validation; scoped live preflight and exact plan; agreed human review and exact-plan approval; apply/read-back; requester lifecycle tests and ownership/eligibility lifecycle. |
