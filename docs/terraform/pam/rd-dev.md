# RD development Terraform-builder PAM

**Status, 2026-11-13: applied; AVAILABLE and settings live-verified at 20:03:18 UTC.** The user approved the exact project-scoped entitlement for both contractors: sixteen reviewed roles, no approver, required requester justification and an eight-hour per-grant maximum. A separately reviewed API-only bootstrap plan enabled PAM, then the full non-targeted plan created the entitlement. Each apply reported **1 added, 0 changed, 0 destroyed**. All ten live read-back checks passed. The separate dedicated environment-state bucket was subsequently applied and all fourteen controls/status checks passed at 20:27:06 UTC. No contractor grant was requested by the agent, and actual contractor Terraform access/expiry has not been tested. No independent human review is claimed.

## Scope and identity

| Setting | Applied / verified value |
|---|---|
| Root / state | [`terraform/pam/rd-dev/`](../../../terraform/pam/rd-dev/) / `devops-hq-bucket`, prefix `pam/rd-dev`, default workspace |
| Target | Existing project `prj-trekai-rd-dev`, number `413711767398` |
| Parent context | Folder `trekai-rd-dev`, ID `561034768953`; project/parent verified earlier in this session on 2026-11-13, not re-queried for this draft |
| Entitlement | `pam-rd-dev-terraform-builder` |
| Eligible human requesters | `user:contractor-ait-boopathin@trekai.org`, `user:contractor-amplifi-jsilva@trekai.org` |
| Approval | No approver; omit `approval_workflow` |
| Maximum grant | `28800s` / eight hours; shorter grants allowed |
| Requester justification | Required, unstructured |
| Accountable owner / eligibility end date | Unconfirmed; resolve before deployment |
| Administrative caller used | `smanley-adm@trekai.org` impersonating `terraform-org-admin@trekai-452018.iam.gserviceaccount.com`, quota project `trekai-452018`; explicit short-lived token in child-process memory |
| API resource owner | This root manages `google_project_service.pam_api` for the enabled `privilegedaccessmanager.googleapis.com` API |
| Entitlement state | `AVAILABLE`; full resource name `projects/prj-trekai-rd-dev/locations/global/entitlements/pam-rd-dev-terraform-builder` |

The user supplied Jeferson's domain as `TrekAI.org`; the applied configuration uses the existing lowercase email identity already present in this repository's RD access configuration. The API read-back matched both exact eligible principal identifiers. Directory/account status and full effective access were not independently verified. Each person requests their own grant; creating an entitlement does not itself activate either user's access. The eight-hour limit is per grant; eligibility continues until the entitlement is changed/removed, with no calendar eligibility end date configured.

The root declares the project resource directly. The existing folder module hard-codes manual approval and remains unchanged, as do all existing RD and QA entitlements. Provider 7.22.0 documents that a null/omitted approval workflow needs no approval; this implements immediate activation after an eligible justified request, not an approval bot or permanent membership.

The entitlement depends explicitly on the PAM API resource. `disable_on_destroy = false` keeps the API enabled if Terraform later removes its tracking resource; future API disablement is a separately authorized action. No project-level service agent is created: PAM uses the organization-level service agent, whose existing role prerequisite is recorded below. Enabling a Google API can also trigger its normal dependent-service setup; this does not authorize unrelated workload APIs or IAM changes.

## Configured role bundle

All sixteen roles below are configured and live-verified **on this project only**. They are service administration roles for building the saved CAP component set, not a claim of minimal individual permissions or a verified complete production inventory. The IAM roles make this a powerful project-administration entitlement.

| Component / operation | Configured role |
|---|---|
| Artifact Registry repositories and policies | `roles/artifactregistry.admin` |
| Cloud SQL PostgreSQL instances, databases and users | `roles/cloudsql.admin` |
| VPCs, subnets, routes, firewall, NAT, addresses and VMs | `roles/compute.admin` |
| GKE clusters/node pools and Kubernetes administration | `roles/container.admin` |
| Cloud DNS private zones, records and response policies | `roles/dns.admin` |
| Project custom IAM role definitions | `roles/iam.roleAdmin` |
| Create/manage service accounts and their policies | `roles/iam.serviceAccountAdmin` |
| Attach/use this project's service accounts for workloads | `roles/iam.serviceAccountUser` |
| Workload identity pools/providers for CI federation | `roles/iam.workloadIdentityPoolAdmin` |
| Project notification-channel resources | `roles/monitoring.notificationChannelEditor` |
| Memorystore Redis | `roles/redis.admin` |
| Project IAM allow-policy membership | `roles/resourcemanager.projectIamAdmin` |
| New environment secrets and versions | `roles/secretmanager.admin` |
| Private Service Access connections | `roles/servicenetworking.networksAdmin` |
| Enable/inspect project APIs and consume quota | `roles/serviceusage.serviceUsageAdmin` |
| Application buckets, objects and dedicated state bucket | `roles/storage.admin` |

Service Account User is project-scoped so Terraform can attach newly created runtime accounts. It is not limited to a predefined runtime-account list; the user reviewed and approved that breadth before apply. Narrower account conditions would require an explicit reviewed account set and a new change. It does not grant access to the organization Terraform account in another project. The normal contractor execution path is their own PAM-elevated human identity, not impersonation of that organization account.

Because bucket provisioning/administration is in scope, Storage Admin includes object/state access; no redundant permanent Object Admin membership is added. Their [dedicated environment-state bucket](../storage/rd-dev-state.md), `prj-trekai-rd-dev-tfstate`, is created and metadata-verified in this same project. The PAM entitlement's own state, bucket-bootstrap state and existing folder/project state stay in the administrative bucket; this entitlement grants no access to that external bucket. Keep the platform-owned PAM API, Storage API and state-bucket resources out of contractor environment states to avoid duplicate Terraform ownership.

**Expiry limitation:** project IAM, custom-role and service-account-policy administration can be used to create access that persists beyond a PAM grant. Automatic approval means either eligible user can self-activate this project-administration power. PAM expiry removes the PAM-managed temporary binding; it does not undo IAM changes, delete resources, roll back Terraform or guarantee revocation of already issued sessions/tokens. The user was informed of the persistent-access risk before approving the proposal; do not describe this as an enforced expiry of every resulting access path. Prefer additive `*_iam_member` resources so contractor Terraform does not overwrite PAM-managed role bindings.

## CAP evidence and boundaries

Reference: saved `tl-trekcap-terraform` checkout, commit `28f2daa0754b3e91de485ccb651ecdbab0d35da3`, **2026-11-02**. Its README calls the reference CAP-RD and its roots live under `environment/development/`; no separate production root was found in that snapshot. The [second brain's CAP release explanation](/Users/ron/Documents/trekai/sm-trekai-infrastructure-and-product-review/trekai-how-it-works/path-to-production/03-trekcap.md) is based on that dated Terraform snapshot and GitHub evidence from 2026-11-03. It cannot establish today's production inventory. The local checkout was read as data; no clone scripts, plans, state or secrets were executed/read or copied.

The component mapping uses the saved [CAP Terraform inventory](/Users/ron/Documents/trekai/sm-trekai-infrastructure-and-product-review/reviews/terraform/reports/inventory/tl-trekcap-terraform.inventory.json), module resource types and README: GKE, PostgreSQL, Redis, network/private connectivity/DNS, bastion VM, registries, buckets, secrets, IAM/accounts/federation and notification channels.

The old roots also contain Shared VPC host/service-project operations, cross-project bindings, organization custom roles/grants and billing-account work. Those cannot be copied unchanged into a project-only grant. The user selected one existing project: adapt networking to project-local VPC/private connectivity unless a separate platform-owned Shared VPC design is approved. Organization/folder/project creation, Shared VPC administration, billing-account IAM/budgets, external projects, production secret/data access, GitHub, Cloudflare and GitOps deployment permissions are outside this entitlement. The separate QA-workstation tool stack is not included in the core CAP replica role mapping. Additional service needs must be confirmed from the actual replica code before deployment; update/review the bundle if the production baseline differs.

## Versions and review references

Use Terraform **1.17.1** and `hashicorp/google` **7.22.0** from [INSTALLS.md](../../../INSTALLS.md). This root gets an unchanged copy of the bootstrap provider lock, with the same reviewed checksums and platform coverage. No provider upgrade or checksum edit is proposed.

- [Pinned provider entitlement schema](https://github.com/hashicorp/terraform-provider-google/blob/v7.22.0/website/docs/r/privileged_access_manager_entitlement.html.markdown): `approval_workflow` is optional and omitted/null means no approvals.
- [Google PAM setup and cautions](https://docs.cloud.google.com/iam/docs/pam-create-entitlements): project scope, automatic activation, supported roles and the IAM persistence limitation.
- Role references: [IAM](https://docs.cloud.google.com/iam/docs/roles-permissions/iam), [Resource Manager](https://docs.cloud.google.com/iam/docs/roles-permissions/resourcemanager), [Compute](https://docs.cloud.google.com/iam/docs/roles-permissions/compute), [GKE](https://docs.cloud.google.com/iam/docs/roles-permissions/container), [Cloud SQL](https://docs.cloud.google.com/iam/docs/roles-permissions/cloudsql), [Redis](https://docs.cloud.google.com/iam/docs/roles-permissions/redis), [DNS](https://docs.cloud.google.com/iam/docs/roles-permissions/dns), [Service Networking](https://docs.cloud.google.com/iam/docs/roles-permissions/servicenetworking), [Artifact Registry](https://docs.cloud.google.com/iam/docs/roles-permissions/artifactregistry), [Secret Manager](https://docs.cloud.google.com/iam/docs/roles-permissions/secretmanager), [Storage](https://docs.cloud.google.com/iam/docs/roles-permissions/storage), [Service Usage](https://docs.cloud.google.com/iam/docs/roles-permissions/serviceusage), [Monitoring](https://docs.cloud.google.com/iam/docs/roles-permissions/monitoring). Reviewed publicly on 2026-11-13 without private search inputs.

## Local checks and deployment path

The initial single-resource draft and the revised API-resource/dependency configuration both passed repository-wide formatting and backend-disabled validation with the existing Google 7.22.0 package and unchanged copied lock. Initial local initialization used fresh private metadata. Validation ran outside the sandbox under explicit approval because the cached provider needs to execute locally. No credentials or live backend were used for these local checks. The later deployment-status comment changes no access settings. For future local review, use the trusted installed provider and a fresh private `TF_DATA_DIR`, with cloud credential/CLI overrides cleared, `TF_CLI_CONFIG_FILE=/dev/null` and `CHECKPOINT_DISABLE=1`:

```bash
terraform fmt -check -recursive
terraform -chdir=terraform/pam/rd-dev init \
  -backend=false -get=false -input=false -lockfile=readonly \
  -plugin-dir=../rd/.terraform/providers
terraform -chdir=terraform/pam/rd-dev validate -no-color
```

The init/validate commands must share the same isolated `TF_DATA_DIR`. Local checks do not use the live backend or establish IAM/CEL/service support, principal eligibility or functioning PAM access. No provider download or live-operation fallback is authorized if the cached package/checksum check fails.

Before future changes, review the exact delta, broad IAM/Service Account User scope, owner/eligibility lifecycle, production-baseline differences and administration path. Existing approvals are consumed, not standing permission for more live reads or writes. Full requester effective-access review, eligibility-end/owner confirmation, access/expiry testing and any follow-up no-change plan remain separate work. No service-agent IAM resource is added; the inherited prerequisite was verified as recorded below. Never treat permission-denied as proof that a resource/name is absent.

The initial creation is complete: this state manages the PAM API and entitlement. Do not generate or apply another two-create plan for these existing resources. Future scoped changes need a new reviewed saved plan and separate exact-plan approval; use this same backend/default workspace and state locking. The API must remain `disable_on_destroy = false` unless API disablement is explicitly approved. Stop for unexpected creates/replacements/deletes, policy changes or ownership/migration/import requests. The [bucket root](../storage/rd-dev-state.md) also completed its independent two-create plan/apply. Keep plans private and never reuse the consumed creation plans.

The entitlement configuration and dedicated backend bucket have been verified. After the new environment roots and their project/backend settings are reviewed, each contractor signs in as their own human identity, requests this entitlement with a real justification for up to eight hours, waits for the grant to become `ACTIVE`, and runs their separate environment Terraform roots. Use the requester's own Terraform ADC/quota setup and a distinct state prefix per root in `prj-trekai-rd-dev-tfstate`; the active gcloud account alone does not select Terraform ADC. They must not use the administrative bootstrap wrapper, operate the PAM/folder/project/bootstrap roots or duplicate platform-owned API/bucket resources in their states. Both users' activation, intended resource/state operations, outside-project denial and expiry/revocation/propagation remain untested. Do not create grants or run contractor Terraform on their behalf without separate authorization.

For containment, an authorized grant revocation and review of persistent IAM changes may be needed. Entitlement deletion, role cleanup, IAM rollback, API changes and state operations require their own reviewed scope. `prevent_destroy` is a Terraform guard, not protection after removing the resource block or against other tools.

## Approved read-only preflight, 2026-11-13

- The explicitly selected admin-to-service-account caller's project `testIamPermissions` returned both `privilegedaccessmanager.entitlements.create` and `storage.buckets.create`; none of those two requested permissions were missing. This did not test API enablement, all PAM setup permissions or the contractors' effective access.
- A filtered enabled-service listing returned no rows and a filter warning, so it was not used as status evidence. A separately approved direct Service Usage GET for each exact API returned **DISABLED** for both `privilegedaccessmanager.googleapis.com` and `storage.googleapis.com` in project number `413711767398`.
- Google documents that PAM uses only the organization-level agent, `service-org-470598084059@gcp-sa-pam.iam.gserviceaccount.com`, even for project entitlements. Approved in-memory IAM-policy reads found **one unconditional** `roles/privilegedaccessmanager.serviceAgent` binding for that exact agent at organization `470598084059`, and no matching bindings at the target folder/project. The organization grant is inherited; no new service-agent IAM grant is proposed. This limited role lookup is not a complete deny-policy, perimeter or effective-access analysis. Raw policies/member lists were not printed or copied.
- Reference: [PAM permissions and setup](https://docs.cloud.google.com/iam/docs/pam-permissions-and-setup), reviewed publicly on 2026-11-13. No folder/project PAM service agent should be generated as a substitute for the organization agent.
- The user approved adding the PAM API to this root and Storage API to the bucket root locally, with explicit dependencies and APIs left enabled on removal. At that preflight stage neither API had been enabled by the agent. Subsequent reads confirmed `serviceusage.services.enable` and `resourcemanager.projects.setIamPolicy` for the caller. The proposed bucket lookup returned a native 404, and metadata-only prefix listings found `pam/rd-dev/` and `storage/rd-dev-state/` empty before this root's live initialization. The PAM prefix is now populated by this root; do not treat it as unused.
- Initial entitlement lookup was blocked by the disabled PAM API; no CLI auto-enable was accepted. The approved API-only bootstrap described below enabled PAM, after which direct reads confirmed `ENABLED` and a genuine entitlement-name 404. Subsequently approved bucket-policy checks, the storage root's exact plan/apply and metadata/API verification completed independently as recorded in its guide. The Storage API is now confirmed ENABLED. These later steps did not modify this entitlement or request contractor grants.

## Deployment and live verification, 2026-11-13

All steps were separately presented and approved by the user. No independent human review is claimed.

1. Live backend initialization used fresh private metadata under `/private/tmp/devops-hq-rd-dev-pam-live-bf32c1d4/terraform-data`, the existing trusted provider/unchanged lock and `devops-hq-bucket` / `pam/rd-dev`, default workspace. The source admin and impersonated service account were selected explicitly; tokens stayed in child-process memory, inherited Google/Cloud SDK/Terraform overrides were removed and quota project was `trekai-452018`. No state migration/import or disabled locking occurred.
2. A deliberately targeted bootstrap plan included only `google_project_service.pam_api`, because the disabled API prevented the entitlement-name preflight. Local filtered review confirmed one create, no updates/deletes, the exact API/project and `disable_on_destroy = false`. Mode-0600 plan SHA-256: `377479da144a62e82f058b5188f814b05e18b3cb64825eb186d3c2dfcbf44c82`. The guarded exact-plan apply ran once at **19:53:31–19:53:59 UTC**, exited 0 and reported **1 added, 0 changed, 0 destroyed**. No entitlement/grant was included. This targeted phase was only API bootstrap, not the normal management workflow.
3. Approved direct GETs then confirmed the PAM API `ENABLED` and the proposed entitlement absent with HTTP 404. A subsequent **full non-targeted plan** confirmed only the entitlement create, with the existing API resource `no-op` and no updates/deletes. Local review covered both exact eligible users, all sixteen roles, project-only resource/type, global location, no approval workflow, mandatory requester justification, `28800s` and no additional role conditions. Mode-0600 plan SHA-256: `0c6d8b216bc3ec25641c5d6fef8b2df8bb4e7371a8bdc7d39dc039cdf9d7d7e7`.
4. The user reviewed that complete bundle, including project-wide Service Account User and the IAM persistence caveat, and approved the exact saved-plan apply once. The guarded apply ran at **20:01:14–20:01:34 UTC**, exited 0 and reported **1 added, 0 changed, 0 destroyed**. It created the entitlement only; no contractor grant was requested.
5. Separately approved API read-back at **20:03:18 UTC** passed all ten checks: `AVAILABLE`, exact name, exact project resource/type, exactly two users, exactly sixteen roles, no extra role conditions, `28800s`, no approval workflow and required unstructured justification. This verifies configuration, not successful requester activation, environment Terraform access, absence of other access paths or expiry behavior. No current grant list was queried.

Private plans, logs and receipts remain under `/private/tmp/devops-hq-rd-dev-pam-live-bf32c1d4/`: `enable-pam-api.tfplan`, `api-plan.log`, `api-apply.log`, `api-apply-execution.json`, `entitlement.tfplan`, `entitlement-plan.log`, `entitlement-apply.log` and `entitlement-apply-execution.json`, plus start markers and isolated metadata. Both plans are consumed; do not reapply them. Sensitive state/plan payloads and tokens were not copied into the repository. Temporary local retention is not a durable evidence-backup guarantee; any move/cleanup needs approved handling.

## Change record

| Date | Authorization / scope / identity | Result / verification | Follow-up |
|---|---|---|---|
| 2026-11-13 | User requested PAM for the two named contractors, automatic approval, Terraform inside the existing project and probable IAM/service-account management; then approved the proposed project/eight-hour/justification design. Clarified full TrekCAP replica services and a dedicated state bucket in this project. Local drafting only; no live execution identity selected. | Prepared a candidate sixteen-role project entitlement with no approval workflow, an unchanged provider lock, this guide and index entry. Used dated CAP source and public provider/role docs; no live cloud/IAM/PAM/state or grant operation. Local checks pending. | Review exact bundle, production-baseline differences, account scope, bucket name/location and owner/end date. Approve local checks, then scoped preflight/plan/apply separately, one operation at a time. |
| 2026-11-13 | User individually approved formatting, each root's backend-disabled init/validation, the administrative caller's creation-permission test, API-status reads and filtered service-agent role lookup. | Initial local checks passed; both creation permissions returned. Direct API GETs showed Storage/PAM disabled. Required service-agent role found unconditionally at the organization and inherited by the project; no IAM change. | Scope future API resources explicitly; check name/prefix ownership and remaining permissions before a live plan. |
| 2026-11-13 | User approved local API-resource/dependency additions and guide updates. | Added `google_project_service.pam_api`, `disable_on_destroy = false` and entitlement dependency. Initial intended plan changes from one create to two; no API enablement or other live mutation. Provider lock unchanged. Revised checks pending. | Approve revised local checks, remaining preflight and separate exact saved-plan review/apply. |
| 2026-11-13 | User individually approved revised formatting/validation, remaining permission checks, bucket-name lookup, prefix listings, entitlement lookup and live PAM backend initialization. | Revised checks passed. API-enable/project IAM permissions present; bucket returned 404; both administrative prefixes empty. Entitlement lookup was API-blocked without accepting enablement. Backend initialized with the exact caller/quota/prefix above. | Stage API bootstrap before entitlement-name verification; no implicit live approval. |
| 2026-11-13 | User approved API-only targeted plan, local filtered review and exact hash-guarded apply once. | API apply at 19:53:31–19:53:59 UTC exited 0, one added/no changes/deletes. Later direct read confirmed ENABLED and entitlement-name 404. No contractor grant. | Consumed API plan; proceed only with separately approved full non-targeted plan. |
| 2026-11-13 | User approved full non-targeted plan, exact access review and saved-plan apply once. | Entitlement apply at 20:01:14–20:01:34 UTC exited 0, one added/no changes/deletes; API unchanged. Both users, sixteen roles, automatic activation, justification and eight-hour limit reviewed. Hash and private receipt recorded above. | Consumed entitlement plan; verify live settings separately. |
| 2026-11-13 | User approved live read-back; records/status comments updated within the authorized guide-maintenance scope. | At 20:03:18 UTC, AVAILABLE and all ten exact setting checks passed. No user grant requested or access/expiry test claimed. | Complete separate state-bucket work. Confirm operational owner/eligibility lifecycle, requester use and expiry; any future live plan/grant/cleanup requires its own scope. |
| 2026-11-13 | User separately approved storage-root policy checks, initialization, plan/review/apply, live bucket/API verification and final record updates. | Dedicated bucket `prj-trekai-rd-dev-tfstate` created in the same project; Storage API enabled. At 20:27:06 UTC all fourteen metadata/status checks passed. This entitlement and its API resources were not changed by that root; no user grants requested. | Contractors request their own grants and use unique backend prefixes. Actual Terraform/state I/O and expiry remain untested; operational ownership/eligibility lifecycle remain follow-ups. |
