# RD QA Terraform-builder PAM

**IAP addition applied and verified, 2026-11-16, 16:57 UTC.** The user approved the exact Dev and QA saved plans under their own review. QA's guarded apply at 16:57:03–16:57:23 UTC exited 0: **0 added, 1 changed in place, 0 destroyed**, adding only `roles/iap.tunnelResourceAccessor`, API unchanged. At 16:57:24 UTC direct read-back confirmed AVAILABLE, exactly seventeen roles including IAP, both human users and preserved project scope, automatic activation, required justification and eight-hour maximum; all ten checks passed. No independent human review is claimed and no grants were requested/revoked. The IAP update plan is consumed. Updated privileges apply to grants requested after this update.

**Initial deployment, 2026-11-16: applied; AVAILABLE and all settings live-verified at 14:51:30 UTC.** The user separately approved the exact API-only and full entitlement plans under their own review. API bootstrap at 14:47:31–14:47:59 UTC and entitlement apply at 14:51:08–14:51:28 UTC each exited 0 and reported **1 added, 0 changed, 0 destroyed**; the entitlement apply left the API unchanged. Direct read-back passed all ten checks: exact QA project/name/type, both users, sixteen roles, no extra role conditions, eight-hour maximum, automatic activation and required justification. Both creation plans are consumed. No independent human review is claimed, and no contractor grant was requested. Actual requester access/expiry testing remains outstanding.

## Confirmed design and ownership

| Setting | Applied / verified value |
|---|---|
| Root / administrative state | `terraform/pam/rd-qa/` / existing `devops-hq-bucket`, prefix `pam/rd-qa`, default workspace; initialized 2026-11-16 |
| Target | Project `prj-trekai-rd-qa`, number `1034076260256` |
| Parent context | Folder `trekai-rd-qa`, ID `674133939280`; project/folder/parents verified in this conversation on 2026-11-16 at 14:36 UTC |
| Entitlement | `pam-rd-qa-terraform-builder` |
| Live state / full name | AVAILABLE / `projects/prj-trekai-rd-qa/locations/global/entitlements/pam-rd-qa-terraform-builder` |
| Eligible human requesters | `user:contractor-ait-boopathin@trekai.org`, `user:contractor-amplifi-jsilva@trekai.org` |
| Approval | No approver; omit `approval_workflow`, matching Dev |
| Maximum grant | `28800s` / eight hours; shorter grants allowed |
| Requester justification | Required, unstructured |
| Selected administrative caller/backend identity | `smanley-adm@trekai.org` explicitly impersonating `terraform-org-admin@trekai-452018.iam.gserviceaccount.com`; quota `trekai-452018`; same path used for preflight/init/plan/apply/verification |
| Resource ownership | This root/state manages enabled `google_project_service.pam_api` and `google_privileged_access_manager_entitlement.terraform_builder`; preserve existing ownership |
| Accountable owner / eligibility end date / independent reviewer | Unconfirmed; no independent human review claimed |

The user confirmed the same project-only pattern as [RD Dev](rd-dev.md), rather than granting across the QA folder and future descendant projects. Creating eligibility does not activate a user's access. Each person requests their own grant using their human identity. Eight hours limits each grant; no calendar eligibility end date is configured. No service-account requester, new impersonation binding, organization/folder admin grant or contractor grant is proposed.

The project entitlement is declared directly because the shared folder module always requires manual approval. Existing modules and entitlements stay unchanged. The API resource is applied, with an explicit entitlement dependency and `disable_on_destroy=false`; API disablement is not part of removal. There is no separate IAM-policy or service-agent grant resource. QA-specific preflight verified the existing organization PAM service-agent prerequisite; the subsequently approved bootstrap enabled the API without adding an IAM binding.

## Configured seventeen-role bundle

The reviewable policy is [`access-policy.tf`](../../../terraform/pam/rd-qa/access-policy.tf). All seventeen roles below apply only to the QA project and were live-verified on 2026-11-16 at 16:57 UTC. The original sixteen-role bundle and subsequent IAP addition match Dev:

| Role | Operation |
|---|---|
| `roles/artifactregistry.admin` | Registry repositories and policies |
| `roles/cloudsql.admin` | SQL instances/databases/users |
| `roles/compute.admin` | Project networking, VMs and related Compute resources |
| `roles/container.admin` | GKE clusters and Kubernetes administration |
| `roles/dns.admin` | DNS zones/records |
| `roles/iam.roleAdmin` | Project custom IAM roles |
| `roles/iam.serviceAccountAdmin` | Project service accounts and their policies |
| `roles/iam.serviceAccountUser` | Attach/use this project's service accounts |
| `roles/iam.workloadIdentityPoolAdmin` | Project identity federation pools/providers |
| `roles/iap.tunnelResourceAccessor` | IAP tunnel authorization; applied/verified 2026-11-16 |
| `roles/monitoring.notificationChannelEditor` | Notification channels |
| `roles/redis.admin` | Redis resources |
| `roles/resourcemanager.projectIamAdmin` | Project IAM allow policies |
| `roles/secretmanager.admin` | QA secrets/versions |
| `roles/servicenetworking.networksAdmin` | Private Service Access |
| `roles/serviceusage.serviceUsageAdmin` | Project API enablement and quota consumption |
| `roles/storage.admin` | QA buckets and objects |

**Persistence limitation:** IAM, custom-role and service-account-policy administration can create access that survives PAM grant expiry. Automatic activation lets either eligible user self-activate this power. Expiry removes the PAM-managed temporary bindings; it does not undo IAM changes, issued credentials, created resources or Terraform operations. Project-wide Service Account User is not restricted to a reviewed runtime-account list. This is a powerful administration bundle copied from Dev, not a claim of minimal permissions. Prefer additive IAM member resources so contractor Terraform does not overwrite PAM bindings.

The [IAP-secured Tunnel User role](https://docs.cloud.google.com/iam/docs/roles-permissions/iap#iap.tunnelResourceAccessor), verified in public Google documentation on 2026-11-16, grants `iap.tunnelInstances.accessViaIAP` and `iap.tunnelDestGroups.accessViaIAP`. This adds tunnel authorization at the existing project scope; it does not configure or verify firewall/VM/login/API prerequisites. [Google's entitlement-update guidance](https://docs.cloud.google.com/iam/docs/pam-view-update-delete-entitlements) says privilege changes apply only to grants requested after the update. Existing grants do not acquire this added role, and this change requests/revokes no grants.

The entitlement does not include Folder Admin, organization/project creation, billing-account IAM, external-project/production access or Shared VPC administration. The existing folder/project are owned by `terraform/organization/rd-qa/`. A dedicated QA workload-state bucket has not been created; the Dev bucket is not a QA backend. This entitlement grants no access to administrative `devops-hq-bucket` in another project. If a dedicated QA backend is required, scope it separately with its own root/state before contractor Terraform use. Keep platform-owned APIs and bootstrap resources out of contractor states.

## Local checks and future execution path

Terraform **1.17.1**, Google provider **7.22.0**, matching [INSTALLS.md](../../../INSTALLS.md). The root owns a byte-for-byte copy of Dev PAM's existing lock file; no provider/checksum changes.

1. Format locally. Use an isolated temporary `TF_DATA_DIR`, trusted cached provider and backend-disabled initialization/validation, with credential/CLI overrides cleared. No live backend, credentials or provider download is needed. Local checks cannot establish IAM/API readiness or functioning grants.
2. The initial creation is complete; prior approvals are consumed. Obtain new explicit authorization for scoped live preflight and select the admin-to-service-account path explicitly. Preserve entitlement/API ownership and `pam/rd-qa` state. Filter any approved role-presence results in memory; never print raw IAM policies or principal lists. A denied/disabled-API lookup does not prove absence; do not accept auto-enable prompts.
3. If backend initialization is needed, obtain scoped authorization and use only the QA PAM backend/default workspace with read-only lock and state locking. Preserve the existing state. Stop for ownership conflicts or migration requests. Folder/project and other environments' states remain outside this root.
4. Preserve `disable_on_destroy=false`; no API disablement or new prerequisite IAM grant is authorized by this record. The API bootstrap below is historical, not a template to repeat against the now-managed resources. Investigate unexpected API disablement under fresh scope rather than replaying its consumed plan or creating service agents/broad IAM grants.
5. Obtain authorization for a fresh full private saved plan and review the exact intended delta and access settings. Do not approve another creation plan for these existing API/entitlement resources. Stop for unexpected creates/replacements/deletes, IAM changes or ownership ambiguity. No post-apply no-change plan has run.
6. Obtain human review and approval of the exact plan before apply, agreeing any alternate review path explicitly. Check hash/source/lock/backend/workspace/identities and private plan permissions, keep locking enabled and run once. Preserve evidence and reconcile any partial failure under new authorization instead of automatically retrying or hand-editing state.
7. Verify AVAILABLE and the full approved settings through scoped direct reads, then record IDs, identities, timestamps and outcome. Each contractor should later test their own justified request, ACTIVE grant, intended QA Terraform access and expiry. Do not request their grants or run workload Terraform on their behalf. Any cleanup/revocation/state change needs its own scope.

## Requester handoff

Boopathi signs in as `contractor-ait-boopathin@trekai.org`; Jeferson signs in as `contractor-amplifi-jsilva@trekai.org`. Each person selects **project `prj-trekai-rd-qa`** in Privileged Access Manager, opens **My entitlements**, and requests a grant from **`pam-rd-qa-terraform-builder`** with the task/ticket justification and required duration, up to eight hours. There is no human approver; wait for the grant to become ACTIVE before testing project access. The [Google request guide](https://docs.cloud.google.com/iam/docs/pam-request-temporary-elevated-access) also documents console/CLI request and status steps. No grant was requested by this deployment.

Use each requester's own human credentials for QA work. The active gcloud account does not select Terraform ADC; review the contractor roots, project, ADC/quota identity and approved backend/unique prefixes before Terraform use. Do not use the administrative bootstrap identity or manage the platform-owned PAM API, folder/project or their state from contractor roots. Request activation, intended resource/state operations, outside-project denial and expiry/propagation remain untested. Eligibility end date and accountable owner remain follow-ups; no permanent requester membership was added by this root.

## Change record

| Date | Authorization / scope | Result | Follow-up |
|---|---|---|---|
| 2026-11-16 | User said "approved" to both exact IAP update plans under their review and result verification; outside-sandbox execution allowed for that exact scope. | QA apply 16:57:03–16:57:23 UTC exited 0: **0 added, 1 changed in place, 0 destroyed**, only IAP added; API unchanged. Direct read-back 16:57:24 UTC: AVAILABLE, exact seventeen roles and all ten settings checks passed. Explicit admin-to-service-account caller/backend, quota `trekai-452018`, same state/default workspace, locking and all guards. No grant operation or automatic retry; no independent human review claimed. | IAP plan consumed. Users need grants requested after update to receive IAP. Actual tunnel/access/expiry tests and owner/eligibility lifecycle remain follow-ups; new changes need new authorization. |
| 2026-11-16 | User requested the IAP tunnel role for this QA PAM entitlement, then included Dev's entitlement. Local preparation only for the role addition. | Added only `roles/iap.tunnelResourceAccessor` to the existing sixteen-role policy, proposed seventeen total. Same root/state/entitlement addresses, human users and grant controls. No live mutation or grant operation. | Validate both drafts and prepare separately authorized update-only plans; exact-plan apply approval and live read-back remain required. |
| 2026-11-16 | Outside-sandbox local validation and scoped preflight/existing-backend initialization/full saved plans for both IAP additions approved through execution prompts. Explicit admin-to-service-account caller/backend, quota `trekai-452018`, default workspace and state locking. | QA preflight confirmed AVAILABLE, exact existing sixteen-role/control baseline, update/read permissions and existing state-object metadata. Init 16:52:38–16:52:40 UTC exited 0; full plan 16:52:41–16:52:51 UTC exited 2. Only entitlement update to add IAP; API no-op; **0 added, 1 changed, 0 destroyed**. Full controlled configuration comparison passed, no grant operation. | Apply of this exact plan and Dev's separate plan awaits user review/approval, then scoped read-back. No independent human review claimed. |
| 2026-11-16 | User requested QA PAM for both named contractors and confirmed Dev's project-only pattern after scope clarification. Local drafting only; no live QA PAM execution identity selected. | Prepared the same sixteen-role, automatic-activation, eight-hour, required-justification bundle; separate `pam/rd-qa` state, unchanged provider lock, API dependency and mirrored guide/index. No live PAM operation or user grant. | Local validation, then authorized preflight/API bootstrap if needed, private saved plan and separate exact-plan approval. Confirm owner/eligibility lifecycle and independent review path. |
| 2026-11-16 | Outside-sandbox local validation and scoped read-only live preflight approved through execution prompts for this QA PAM request. Explicit admin-to-service-account caller and quota `trekai-452018`. | Formatting/backend-disabled validation passed; unchanged lock and exact Dev roles/requesters/resource controls checked. Preflight 14:42:29–14:42:42 UTC confirmed the active QA project/parent, all six project permissions, all four backend permissions, exact existing unconditional organization PAM agent binding and empty prefix. PAM API DISABLED; no entitlement-name lookup or API enablement. | Prepare separately authorized API-only bootstrap plan; enable only after exact-plan approval. |
| 2026-11-16 | Execution prompt approved separate QA PAM backend initialization and private API-only saved plan; no apply approval. Same explicit caller/quota, default workspace and locking enabled. | Prefix guard empty; init 14:44:06–14:44:10 UTC exited 0. Targeted plan 14:44:10–14:44:14 UTC exited 2: only `google_project_service.pam_api` create, no updates/deletes, exact QA project/API and `disable_on_destroy=false`. Exact hash/private evidence below. | Obtain exact API-plan apply approval and agreed human-review path; then verify API ENABLED and entitlement absence before a separately authorized full entitlement plan. |
| 2026-11-16 | User said "approved" to the exact API-only apply under their review, followed by read-back and full entitlement planning. Outside-sandbox execution allowed for that scope; no independent human review claimed. | Exact hash/source/lock/backend/workspace/private-permission guards passed. One API apply at 14:47:31–14:47:59 UTC exited 0: **1 added, 0 changed, 0 destroyed**. API read-back ENABLED and exact entitlement-name GET 404 at 14:48:02 UTC. No entitlement/grant created and no retry. | API creation plan consumed. Proceed only with the authorized full non-targeted entitlement plan; no implicit entitlement apply approval. |
| 2026-11-16 | Same explicit authorization included the full saved entitlement plan after API/name verification. Caller/backend is the explicitly impersonated service account, quota `trekai-452018`, same backend/default workspace and locking enabled. | Full plan at 14:48:02–14:48:11 UTC exited 2: one entitlement create, API no-op, no updates/deletes. Exact two principal IDs, all sixteen roles, project-only target/type, global, eight hours, required justification, no approval workflow or role conditions verified. Exact hash/private evidence below. | Obtain review/approval of this exact entitlement plan before apply, then verify live settings and hand off requester tests. |
| 2026-11-16 | User said "proceed" to the exact entitlement-plan apply under their review and settings verification. Outside-sandbox execution allowed for that exact scope; no independent human review claimed. | Hash/source/lock/backend/workspace/private-permission guards passed, same explicit identity/quota and locking. One apply at 14:51:08–14:51:28 UTC exited 0: **1 added, 0 changed, 0 destroyed**; API unchanged. Direct entitlement read at 14:51:30 UTC confirmed AVAILABLE and all ten checks passed. No user grant, automatic retry, import, migration or separate IAM mutation. | Both creation plans consumed. Actual requester/access/expiry tests, owner/eligibility lifecycle and any workload-state bucket remain separate follow-ups. Future live changes require fresh review/authorization. |

## Preflight and local evidence

Local backend-disabled validation passed on 2026-11-16 after the sandbox prevented the provider from starting and an outside-sandbox retry was explicitly approved. It used isolated metadata `/private/tmp/devops-hq-rd-qa-pam-validation-awn7fo_r`, the trusted cached Google 7.22.0 package, read-only lock, cleared cloud credential overrides and no live backend/download. Formatting and lock-copy comparison passed. A filtered local comparison verified exactly the same sixteen roles, two principal identifiers and resource controls as Dev.

Live preflight metadata: `/private/tmp/devops-hq-rd-qa-pam-preflight-1s_n5b1v/preflight.json`. It records these limited findings at **14:42:42 UTC**, not a full effective-access assessment:

- QA project ID/number `prj-trekai-rd-qa` / `1034076260256`, parent `folders/674133939280`, ACTIVE.
- The selected impersonated caller returned all requested project permissions: `privilegedaccessmanager.entitlements.create`, `privilegedaccessmanager.entitlements.get`, `serviceusage.services.enable`, `serviceusage.services.get`, `resourcemanager.projects.getIamPolicy`, `resourcemanager.projects.setIamPolicy`.
- Service Usage direct GET returned PAM API DISABLED. Entitlement-name GET was deliberately skipped; disabled service does not prove entitlement absence. No auto-enable was accepted.
- In-memory organization IAM inspection found exactly one unconditional `roles/privilegedaccessmanager.serviceAgent` binding for the expected organization PAM agent. No matching conditional binding was found; no IAM grant was added. Raw policy/member lists were neither printed nor saved. This does not analyze every deny/perimeter/effective-access path.
- The selected impersonated backend caller returned `storage.objects.get`, `list`, `create`, `delete`; permission tests themselves wrote/deleted nothing. Metadata-only listing of `pam/rd-qa/` was empty before init; no state contents were read by preflight. This prefix is now initialized and must not be treated as a fresh empty ownership boundary in future operations.

## Consumed API-only bootstrap plan

- Private plan: `/private/tmp/devops-hq-rd-qa-pam-live-nzryj88y/enable-pam-api.tfplan`.
- SHA-256: `f6901f616144b0ded9b027671217f0203c9cc8f9bb8ae329a10349f4f609c76f`.
- Applied action: create only `google_project_service.pam_api` for `prj-trekai-rd-qa` / `privilegedaccessmanager.googleapis.com`, with `disable_on_destroy=false`. Actual counts: **1 added, 0 changed, 0 destroyed**. No entitlement, IAM binding, bucket or contractor grant was included.
- This deliberately targeted API bootstrap enabled entitlement-name verification. The subsequent entitlement plan was full and non-targeted, as required for normal review.
- Backend: GCS `devops-hq-bucket`, prefix `pam/rd-qa`, default workspace. The same explicit service-account token selected from the admin source was used for backend/provider, held only in child-process environment memory; inherited credential/CLI overrides were cleared. Quota `trekai-452018`, provider project `prj-trekai-rd-qa`, no global impersonation or persisted backend credential.
- Private directory mode 0700, plan/log/metadata files mode 0600. Evidence: `init.log`, `api-plan.log`, `api-plan-execution.json`, `api-apply.log`, `api-apply-started.json`, `api-apply-execution.json`, `api-verification.json` and isolated `terraform-data/` under the same directory. Metadata includes source/lock hashes, backend, identities, timestamps and filtered plan/apply/verification outcomes; no token or raw state/plan JSON was saved in that metadata. Temporary local evidence is not durable archival storage.

**The API creation plan is consumed; never apply it again.** It was applied once under the user's explicit review, with hash/source/lock/backend/workspace/private-permission guards, an exclusive start marker and state locking. No independent human review is claimed. API/name read-back passed: PAM ENABLED and entitlement HTTP 404 at 14:48:02 UTC. This verifies API bootstrap, not functioning requester access.

## Consumed entitlement creation plan

| Reviewed setting | Exact planned value |
|---|---|
| Private plan | `/private/tmp/devops-hq-rd-qa-pam-live-nzryj88y/entitlement.tfplan` |
| SHA-256 | `ecad97703f8baac8dfada35b07632a87f68e2fdee7a336b99dc3c9757088b75a` |
| Resource actions | `google_privileged_access_manager_entitlement.terraform_builder`: create; `google_project_service.pam_api`: no-op; **1 added, 0 changed, 0 destroyed** |
| Entitlement name | `projects/prj-trekai-rd-qa/locations/global/entitlements/pam-rd-qa-terraform-builder` |
| Parent / resource / type | QA project only; `projects/prj-trekai-rd-qa` / `//cloudresourcemanager.googleapis.com/projects/prj-trekai-rd-qa` / `cloudresourcemanager.googleapis.com/Project` |
| Eligible users | Exactly Boopathi and Jeferson's two principal IDs above |
| Roles | Exactly the sixteen roles listed above; no extra role conditions |
| Location / maximum duration | `global` / `28800s` |
| Justification / approval | Required unstructured requester justification / no approval workflow |
| Backend / workspace / identity | Same initialized `devops-hq-bucket` / `pam/rd-qa` / default; explicit admin-to-service-account caller/backend; quota `trekai-452018` |

The full non-targeted plan ran at **14:48:02–14:48:11 UTC**, exited 2, and passed all filtered checks above. Source/lock hashes matched the bootstrap record and were rechecked before apply. Plan mode 0600; private evidence in the same mode-0700 directory includes `entitlement-plan.log`, `entitlement-plan-execution.json`, `entitlement-apply.log`, `entitlement-apply-started.json`, `entitlement-apply-execution.json`, and `entitlement-verification.json`. Neither raw plan/state/API JSON nor tokens were printed or saved in those metadata records. Temporary local evidence is not durable archival storage.

**This entitlement creation plan is consumed; never apply it again.** The user approved it under their own review; it was applied once with all guards and state locking, and an exclusive start marker prevents automatic repeat execution. No independent human review is claimed. The following status-comment edit changes no resource/access setting. Eligibility is verified; no grant was requested and functioning requester access/expiry is not claimed. Automatic eight-hour grants retain the IAM persistence limitation above. Future changes need fresh scoped review and authorization, not reuse of either creation approval or plan.

## Live entitlement verification

The explicit admin-to-service-account caller's direct entitlement GET at **2026-11-16 14:51:30 UTC** passed all ten checks, saved as booleans in `entitlement-verification.json`:

1. State AVAILABLE.
2. Exact name, QA project parent and global location.
3. Exact QA project resource and resource type.
4. Exactly both eligible human principals, no additional requester block/member.
5. Exactly the sixteen reviewed roles.
6. No additional role condition expressions.
7. Maximum duration `28800s`.
8. No approval workflow.
9. Unstructured requester justification configured.
10. Justification required, with no not-mandatory configuration.

The read-back did not query current grants or test either contractor's actual access, scope denial, ADC, workloads or expiry. No raw API response was saved or printed. Final documentation/status-comment edits passed formatting/whitespace checks; provider/backend validation need not be repeated for those edits.


## Consumed IAP role update

| Reviewed setting | Exact value |
|---|---|
| Project / entitlement | `prj-trekai-rd-qa` / `pam-rd-qa-terraform-builder` |
| Private plan | `/private/tmp/devops-hq-pam-iap-update-nte_lhre/rd-qa/add-iap-tunnel.tfplan` |
| SHA-256 | `258d8c3cd9cac9a0b077e40e1d5094cfdbf29b874c223adf8f0ff2ca203f3920` |
| Full plan result | **0 added, 1 changed in place, 0 destroyed**; entitlement update only; PAM API no-op |
| Configuration delta | Add only `roles/iap.tunnelResourceAccessor`; sixteen roles become seventeen |
| Preserved controls | Exactly Boopathi/Jeferson's existing principals; project-only resource/type; `global`; `28800s`; no approval workflow; mandatory unstructured justification; no extra role conditions |
| Backend / workspace | `devops-hq-bucket` / `pam/rd-qa` / default; existing state preserved, locking enabled |
| Source / caller / quota | Explicit `smanley-adm@trekai.org` to `terraform-org-admin@trekai-452018.iam.gserviceaccount.com`; provider/backend use the impersonated token; quota `trekai-452018` |

The full non-targeted plan ran **2026-11-16 16:52:41–16:52:51 UTC** and exited 2. Preflight checked only the target entitlement, project update/read permissions and exact existing state-object metadata; it did not list grants or read state contents directly. The Terraform plan itself used the approved live backend. Before/after configuration was compared with role bindings removed, ignoring only computed create/update timestamps, etag and state: all remaining properties matched. The role sets were separately verified as the exact original sixteen plus only IAP. API action is no-op. No apply or grant operation has run for this update.

Local backend-disabled init/validation passed using `/private/tmp/devops-hq-iap-rd-qa-validation-mhk6x34l`, the existing trusted Google 7.22.0 package, unchanged read-only lock and cleared cloud credential/CLI overrides. The sandbox could not start the provider; the explicitly approved outside-sandbox retry passed. No provider download, credential or live backend was used for that local check. Formatting/whitespace checks passed.

Private plan/log/receipt files are mode 0600 inside mode-0700 directories. Evidence under `/private/tmp/devops-hq-pam-iap-update-nte_lhre/rd-qa/`: `init.log`, `plan.log`, `plan-execution.json`, `apply.log`, `apply-started.json`, `apply-execution.json`, `verification.json` and isolated `terraform-data/`. The batch manifest is `/private/tmp/devops-hq-pam-iap-update-nte_lhre/plans.json`. Receipts contain source/lock hashes, identities, backend/workspace, timestamps and filtered outcomes; no tokens, raw state or plan JSON were printed or saved in those receipts. Tokens stayed in child-process environment memory; no global impersonation or persisted backend credential was used. Temporary local evidence is not durable archival storage.

**This IAP update plan is consumed; never apply it again.** The user explicitly approved both exact saved plans under their own review, and QA's plan ran once at **16:57:03–16:57:23 UTC**, exiting 0 with **0 added, 1 changed, 0 destroyed**. Plan/source/lock hashes, private permissions, backend, default workspace and caller path were checked before apply; an exclusive start marker prevents a repeat attempt and state locking stayed enabled. No independent human review is claimed. Direct read-back at **16:57:24 UTC** passed all ten checks: AVAILABLE, exact name/project/global location, exact project resource/type, exactly both human principals, exactly seventeen roles including IAP, no extra role conditions, `28800s`, no approval workflow, unstructured justification and mandatory justification. No grants were requested/revoked, no API/firewall/VM/login configuration was changed, and actual IAP connectivity was not tested. Updated privileges apply to grants requested after the update; existing grants do not acquire IAP automatically. Final status-comment edits change no resource/access setting. Future changes require fresh review/authorization; neither this nor the other project's consumed plan is standing permission for another operation.
