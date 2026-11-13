# RD development environment-state bucket

**Status, 2026-11-13: applied and live-verified at 20:27:06 UTC.** The user reviewed and approved the exact two-create plan for the Storage API and dedicated bucket. Apply completed at **20:23:56 UTC: 2 added, 0 changed, 0 destroyed**. Separate metadata/API reads passed all fourteen checks, including the intended project/name/location, enabled API, public-access controls, versioning, seven-day soft delete and encryption/retention settings. The separately owned PAM entitlement is also AVAILABLE and settings-verified. No contractor grant or state-object I/O/expiry test was performed by the agent, and no independent human review is claimed. The saved creation plan is consumed and must not be reused.

## Purpose, ownership and scope

| Setting | Applied / verified value |
|---|---|
| Root | [`terraform/storage/rd-dev-state/`](../../../terraform/storage/rd-dev-state/) |
| Target project | `prj-trekai-rd-dev`, number `413711767398`; project verified earlier in this session on 2026-11-13 |
| Bucket name / URL | `prj-trekai-rd-dev-tfstate` / `gs://prj-trekai-rd-dev-tfstate` |
| Location / class | `US-CENTRAL1` / Standard; live-verified |
| Bootstrap root's backend | Existing `devops-hq-bucket`, prefix `storage/rd-dev-state`, default workspace |
| Bucket resource owner | This root alone manages `google_storage_bucket.environment_state` |
| API resource owner | This root manages `google_project_service.storage_api`; `storage.googleapis.com` verified ENABLED |
| Environment state writers | Contractors while a grant from their [AVAILABLE project entitlement](../pam/rd-dev.md) is ACTIVE; no grant requested by the agent and actual I/O/expiry untested |
| Administrative caller used | `smanley-adm@trekai.org` impersonating `terraform-org-admin@trekai-452018.iam.gserviceaccount.com`, quota `trekai-452018`; explicit short-lived token in child-process memory |
| Review / accountable owner | User reviewed/approved the exact saved plan; no independent human review claimed. Formal infrastructure/cost ownership remains a follow-up |

This bucket is for the new environment's state objects, not for the PAM entitlement, the folder/project root, this bucket's own bootstrap state or existing production state. The three administrative roots retain their own prefixes in `devops-hq-bucket`. Keep this bucket under one Terraform owner; contractor roots consume its name as a backend input and do not declare/adopt the bucket resource. Different environment roots need distinct agreed state prefixes; never share a prefix for separate state owners.

The user chose a bucket in the new project and approved the exact name/location in the saved-plan review. This root bootstrapped it using the existing administrative backend, without a self-hosted initial state migration. It adds no permanent user IAM binding. The configured PAM Storage Admin role on the new project supplies bucket/object/state access during a grant and is intentionally broader than object-only access because application bucket provisioning is also in scope. It grants nothing on the external administrative bucket. Broader existing access is unverified and is not revoked by this configuration. Contractor environment states must not also manage this bucket or the platform-owned Storage/PAM API service resources.

The bucket depends explicitly on `google_project_service.storage_api`. That resource enables only `storage.googleapis.com` in this project, with `disable_on_destroy = false` so later removal of Terraform's service resource does not disable the API. API disablement would need a separately authorized scope. Google can perform normal dependent-service setup when an API is enabled; unrelated workload APIs are not declared here.

## Bucket settings

- Uniform bucket-level access and enforced public-access prevention.
- Object versioning and seven-day soft delete for recovery. No automatic lifecycle/old-version deletion is configured; retained versions and soft-deleted objects can incur storage charges.
- Google-managed encryption at rest; no customer-managed key or key-management privileges are introduced.
- `force_destroy = false` and Terraform `prevent_destroy = true`. These guard Terraform operations; they do not prevent an authorized project administrator from modifying/deleting resources through other tools.
- No retention lock, payload copy, production data/secret access or additional IAM grant resource is included. The root declares the Storage API and bucket; the environment's later Terraform operations will create state/lock objects.

## Local checks and future operations

Terraform **1.17.1**, `hashicorp/google` **7.22.0**, and an unchanged copy of the existing bootstrap lock match [INSTALLS.md](../../../INSTALLS.md). No version/checksum change is proposed. The initial single-resource draft and the revised API-resource/dependency configuration both passed repository-wide formatting and backend-disabled validation using the cached provider and credential-free private local metadata. Validation outside the sandbox was explicitly approved. The API addition required no provider/lock change.

With an approved credential-free environment and a fresh private `TF_DATA_DIR`, reuse the trusted installed provider:

```bash
terraform fmt -check -recursive
terraform -chdir=terraform/storage/rd-dev-state init \
  -backend=false -get=false -input=false -lockfile=readonly \
  -plugin-dir=../../pam/rd/.terraform/providers
terraform -chdir=terraform/storage/rd-dev-state validate -no-color
```

Init and validate must use the same isolated local metadata. Clear inherited Google/Cloud SDK/Terraform overrides and disable CLI config/checkpoint checks. Stop for missing/untrusted plugins or lock mismatches; do not initialize the live backend or download/upgrade as a workaround.

Initial deployment is complete. Before any future change, review its exact delta, accountable owner, cost/recovery/retention implications, caller and state ownership. The existing plan/apply/read approvals are consumed and do not authorize repetition. Any new live inventory, effective-access analysis, no-change plan or recovery exercise needs its own scoped approval. A denied lookup must never be used to infer absence or justify adopting/recreating an existing resource.

This root now manages `google_project_service.storage_api` and `google_storage_bucket.environment_state`; do not expect or apply another two-create plan for them. Future changes require separately approved live initialization/planning, exact saved-plan review and apply. Preserve the existing backend/default workspace and locking, API `disable_on_destroy = false`, the bucket's deletion guards and one state owner. Stop for unexpected creates/replacements/deletes, IAM changes, state migration/import or ownership conflicts. Keep future plans/logs private and never reuse the consumed creation plan.

The bucket's metadata and API status are verified below. Contractor state read/write/locking, denial outside the project and behavior after grant expiry/revocation remain untested; perform those only through an agreed safe operation with their own human identities. The [GCS backend](https://developer.hashicorp.com/terraform/language/backend/gcs) supports state locking; never disable it to work around permission issues. Keep state/plan payloads and tokens out of responses and Git. The earlier narrow permission checks do not resume the separate administrative state-bucket IAM review, which remains on hold.

After the requester activates their own PAM grant and their new environment root's target/ownership is reviewed, that root can use an agreed unique prefix, for example for networking:

```hcl
backend "gcs" {
  bucket = "prj-trekai-rd-dev-tfstate"
  prefix = "environment/trekcap-dev/networking"
}
```

This is an illustrative backend input, not a state migration instruction or an implemented environment root. Multiple roots need separate prefixes, such as networking, GKE and Cloud SQL; never reuse one prefix across roots. Contractor Terraform must target `prj-trekai-rd-dev`, authenticate as the requester's own PAM-elevated human identity and use an appropriate quota project, not the administrative bootstrap service-account wrapper. A gcloud sign-in and Terraform ADC are separate credentials. Review these and the backend before `init`, rather than running the saved CAP roots with their original project IDs or production backends. Repository access, GitOps, source-image access and external-project dependencies are separate from this project PAM grant.

For recovery, preserve state and versions when problems occur. Bucket/object deletion, version recovery, IAM changes, retention changes, cleanup and state migration/import need their own reviewed approval. No automatic cleanup or destroy is authorized.

## Approved read-only preflight, 2026-11-13

The user-approved administrative permission tests returned `storage.buckets.create`, `privilegedaccessmanager.entitlements.create`, `serviceusage.services.enable` and `resourcemanager.projects.setIamPolicy` on the project. A filtered API listing was inconclusive; subsequent approved direct Service Usage GETs returned **DISABLED** for both Storage and PAM APIs at that time. PAM was later enabled through its own reviewed root, then Storage through this root's exact saved-plan apply. The inherited PAM service-agent role is recorded in the [PAM guide](../pam/rd-dev.md#approved-read-only-preflight-2026-11-13).

Before creation, the proposed bucket metadata lookup returned a genuine HTTP 404, and a metadata-only listing limited to one result confirmed `storage/rd-dev-state/` was empty. These were point-in-time checks, not a name reservation or permission to adopt another owner's resources. This prefix is now populated by the approved root and must be preserved. The separate PAM entitlement was created and all ten access-setting checks passed; no contractor grant was requested by the agent.

Approved effective-policy reads for this exact project found `gcp.resourceLocations` explicitly allows `us-central1`, with no condition on that rule. `gcp.restrictNonCmekServices` and `gcp.restrictServiceUsage` both returned unconditional `allowAll: true`. These three checks support the reviewed region/default-encryption/API design; they do not constitute a complete custom-policy or effective-access audit. Only the selected rule values/flags were reported, not raw policies or IAM member lists.

## Completed saved-plan apply and verification

The user separately approved live initialization, planning, local filtered review, the exact apply and metadata/API verification. The explicit admin-to-service-account caller and quota project are recorded above; no independent human review is claimed.

1. Fresh private metadata under `/private/tmp/devops-hq-rd-dev-state-live-ywvxy1j2/terraform-data` initialized the exact existing GCS backend / `devops-hq-bucket` / `storage/rd-dev-state`, default workspace, using the trusted cached provider and unchanged lock. No import, migration or disabled locking occurred. Credentials were short-lived and passed only in child-process environment memory; inherited credential/CLI overrides were cleared.
2. The saved plan exited 2. Local filtered review passed all twelve checks: exactly the Storage API and bucket creates, no updates/deletes, correct target/name/region/class, API left enabled on removal, uniform access/public prevention, `force_destroy = false`, versioning, seven-day soft delete, expected labels and no extra CMEK/retention/lifecycle configuration. Mode-0600 plan SHA-256: `9ce8a40038b8f89483eeac370d2708e3cd45413c157da268f468bc00c3142351`.
3. After the user reviewed and approved those exact settings and hash, a guarded single apply ran at **2026-11-13 20:23:25–20:23:56 UTC**, exited 0 and reported **2 added, 0 changed, 0 destroyed**. No separate IAM grant, project/folder change, requester grant, automatic retry or cleanup ran.
4. Separately approved direct metadata/API reads at **20:27:06 UTC** passed all fourteen live checks below. They did not read state/object payloads, write/delete objects or activate contractor access.

| Verified item, 2026-11-13 20:27:06 UTC | Result |
|---|---|
| Storage API | `ENABLED` |
| Bucket / project number | `prj-trekai-rd-dev-tfstate` / `413711767398` |
| Location / class | `US-CENTRAL1` / `STANDARD` |
| Uniform bucket-level access | Enabled |
| Public-access prevention | Enforced |
| Object versioning | Enabled |
| Soft-delete retention | `604800` seconds / seven days |
| User labels | Exact expected values: application `trekcap`, environment `dev`, managed_by `terraform`, purpose `terraform-state` |
| Encryption / retention / lifecycle | No customer-managed key, bucket retention policy, lifecycle rules or default event hold |

Terraform `force_destroy = false` and `prevent_destroy = true` are configuration guards confirmed in the reviewed source/plan; they are not separate Cloud Storage API protection switches. No follow-up live no-change plan or contractor I/O/expiry test has run.

Private evidence remains in `/private/tmp/devops-hq-rd-dev-state-live-ywvxy1j2/`: consumed `create.tfplan`, `plan.log`, `apply.log`, `apply-started.json`, `apply-execution.json` and isolated Terraform metadata. The receipt records hash, identity, backend, authorization, timestamps, exit code and counts. Raw state/plan payloads and credentials were not copied into the repository. Temporary local retention is not a durable evidence-backup guarantee; moving or deleting these artifacts needs approved handling.

## Change record

| Date | Authorization / scope / identity | Result / verification | Follow-up |
|---|---|---|---|
| 2026-11-13 | User selected a dedicated contractor environment-state bucket inside `prj-trekai-rd-dev` while approving preparation of the project PAM access design. Local agent only; no live caller selected. | Drafted one bucket with proposed name/location, recovery/public-access controls and its own administrative backend prefix. Added guide/index and unchanged provider lock. No live cloud/IAM/backend/state operation; local checks pending. | Review name/location/owner/cost design and exact PAM access; approve local checks, scoped preflight and independent saved-plan review/apply. |
| 2026-11-13 | User individually approved formatting, backend-disabled init/validation and narrow permission/API/PAM-role reads with the administrative caller described above. | Initial local checks passed; bucket-create permission returned; Storage API confirmed disabled. No bucket/IAM/API or state mutation. | Add exact API prerequisite to the draft and verify remaining preflight/ownership before a live plan. |
| 2026-11-13 | User approved local API-resource/dependency additions and guide updates. | Added `google_project_service.storage_api`, `disable_on_destroy = false` and the bucket dependency. Intended plan is now two creates. Lock unchanged; no live enablement or bucket operation. Revised checks pending. | Approve revised local checks, scoped preflight and separate exact saved-plan review/apply. |
| 2026-11-13 | User approved revised formatting/validation, remaining caller-permission tests, bucket metadata lookup and metadata-only state-prefix checks. | Revised checks passed; API-enable/project IAM permissions present. Bucket lookup 404; `storage/rd-dev-state/` empty. No storage-root mutation or state read/write. The independently owned PAM API/entitlement were subsequently applied and verified in their own root. | Approve effective bucket-policy reads, then this storage root's own backend initialization and saved-plan review/apply. |
| 2026-11-13 | User approved three effective-policy reads, then this root's live backend initialization and plan. Exact caller/quota/backend described above; locking enabled. | Region `us-central1` allowed; checked non-CMEK/service-usage rules allow all, without conditions. Fresh backend initialized with cached provider/unchanged lock. Plan exited 2. | Local review and exact apply were separately approved next; no independent human review claimed. |
| 2026-11-13 | User approved filtered plan review and the exact two-create saved-plan apply once, including bucket name/location, controls, retained old versions and hash. | Twelve plan checks passed. Guarded apply at 20:23:25–20:23:56 UTC exited 0: **2 added, 0 changed, 0 destroyed**. Storage API and bucket are owned by this root. No separate IAM/grant operation or automatic retry. | Creation plan consumed; verify metadata/API separately and never reuse the plan. |
| 2026-11-13 | User approved live metadata/API verification, then final guide/index/status-comment updates and `git diff --check`. | At 20:27:06 UTC, all fourteen live checks passed; project/name/location/class, enabled API, public/access/recovery controls, labels and default encryption/retention settings confirmed. No object contents or I/O test. | Contractor activation/state I/O/expiry, formal owner/eligibility lifecycle, full effective IAM and any no-change plan remain separately scoped follow-ups; no standing live authorization. |
