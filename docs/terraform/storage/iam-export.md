# Dedicated IAM-export bucket

**Bucket status, 2026-11-06 10:48 UTC: bucket and direct reader deployed and verified.** The user approved the exact saved two-create plan after a scoped single-person-review exception. Apply completed with **2 added, 0 changed, 0 destroyed**. Native metadata and IAM reads verified the bucket in `smanley-experimental / us-central1`, manual cleanup/no automatic expiry, Standard storage, uniform access, public access prevention, seven-day soft delete and `smanley-adm@trekai.org` as direct Object Viewer. The bucket apply included no service-agent, API or project-wide IAM change. [Apply record](../../../review/tl-trekai-terraform-review/iam-permission-org-wide/RUN_LOG.md#approved-exact-saved-plan-apply--2026-11-06).

**Consumer service-identity status, 2026-11-06 11:08 UTC:** under separate user authorization, native Service Usage identity generation completed and returned the expected Cloud Asset agent email/uniqueId in `trekai-452018`. A separate IAM metadata GET returned `403`; before/after source-project allow-policy member rows were unchanged, and no direct unconditional `roles/cloudasset.serviceAgent` member was observed. No IAM grant/API enablement ran. Source-role and destination writer configuration, complete effective/inherited access, and actual export/download remain outstanding. [Provisioning record](../../../review/tl-trekai-terraform-review/iam-permission-org-wide/RUN_LOG.md#authorized-consumer-cloud-asset-service-identity-provisioning--2026-11-06).

**Export completed, 2026-11-06 11:27 UTC:** the user authorized the remaining minimal setup/export/download workflow. The native source-agent role and bucket-only temporary Storage Admin membership were added and verified with exact additive IAM comparisons. One organization-wide `IAM_POLICY` export completed at read time **2026-11-06T11:26:04.615230Z**, was downloaded by exact object generation, and passed size/CRC32C/SHA-256/JSON-policy validation. **484 resources, 1,431 bindings, 2,377 assignment rows**; 225 bindings conditional. [Cloud/local provenance and summary](../../../review/tl-trekai-terraform-review/iam-permission-org-wide/README.md). Temporary bucket writer access expires **2026-11-07T11:22:47.170159Z**; data remains until approved manual cleanup. No cleanup or additional live operation is authorized. Earlier dated checkpoints above are historical and superseded by this result where applicable.

Root: [`terraform/storage/iam-export/`](../../../terraform/storage/iam-export/). Export workflow and dated access checks: [bulk IAM export runbook](../../../review/tl-trekai-terraform-review/iam-permission-org-wide/README.md).

## Scope and ownership

| Setting | Value / status |
|---|---|
| Purpose | Store confidential organization-wide IAM export snapshots for local audit analysis |
| Project | `smanley-experimental`, user-selected; ACTIVE/billing enabled verified 2026-11-06 09:54 UTC; seven targeted effective policies checked, other/custom constraints unverified |
| Location | `us-central1`, user-selected; targeted effective location-policy review on 2026-11-06 found an allowed value/group covering it |
| Bucket name | `trekai-iam-export-smanley-experimental`, created and read back 2026-11-06 10:48 UTC |
| Resource address | `google_storage_bucket.iam_export` |
| State | `gs://devops-hq-bucket/storage/iam-export`, default workspace; init/plan/apply used this prefix; no migration of existing roots |
| Resource boundary | This root owns the created bucket and direct reader member; no pre-existing bucket, state address or IAM binding adopted/moved |
| Accountable/cost owner | `smanley-adm@trekai.org`; accountability only, no IAM Owner role implied; charges use the project's existing billing account |
| Review for this bucket/reader change | User requested a scoped single-person-review exception, reviewed the plan summary and explicitly approved its apply. No independent review claimed. Exception does not cover service-agent/writer or other changes. |
| Explicit human downloader | `user:smanley-adm@trekai.org`, `roles/storage.objectViewer` on this bucket only; membership verified. Actual download succeeded through the approved admin-to-service-account execution path; direct human-only download not separately tested. |
| Export writer | Verified generated Cloud Asset identity; standard consumer-project service role plus bucket-only Storage Admin with a condition expiring 2026-11-07T11:22:47.170159Z. Native grants, outside this root's state; successful export confirms the observed write operation. Separate IAM-account metadata GET remains unavailable (403). |
| Effective readers | Not established; inherited access and other paths remain to be reviewed |
| Initial deployment path | `smanley-adm@trekai.org` impersonating `terraform-org-admin@trekai-452018.iam.gserviceaccount.com`; successful exact-plan apply and bucket metadata/IAM read-back; short-lived token path, no ADC login change |

**Read-only destination preflight, 2026-11-06 09:54 UTC:** project/billing reads passed. The existing admin-to-`terraform-org-admin` gcloud path received `storage.buckets.create` and `serviceusage.services.use` in the destination-project permission test; `storage.buckets.get` and `storage.buckets.update` were not returned. The sequence stopped there, leaving the proposed bucket-name lookup unattempted. No conclusion of complete bucket-management access is supported; resolve the intended execution identity/access before a live Terraform plan. No grant or bucket was created. [Execution record](../../../review/tl-trekai-terraform-review/iam-permission-org-wide/RUN_LOG.md#dedicated-bucket-destination-preflight--2026-11-06).

**Follow-up diagnosis, 2026-11-06 10:05 UTC:** the selected execution service account has an unconditional basic Owner binding in the native project policy. The expanded project permission test omitted bucket get/update/getIamPolicy/setIamPolicy, but these omissions do not establish that an extra project-wide role is needed. Google documents that basic-role users acquire additional bucket access through convenience-value bindings created with the bucket; this explains why a project-level test is insufficient to assess the future bucket. Do not add a project Storage Admin grant based only on the earlier test. Exact bucket access still needs verification after an approved creation, together with relevant deny/condition/restriction checks. [Storage basic-role behavior](https://docs.cloud.google.com/storage/docs/access-control/iam-roles#basic-roles).

The proposed-name GET returned `404 / NOT_FOUND`. All seven targeted effective policies were retrieved: location values include the target region/group without a matching deny; non-CMEK, bucket-retention-duration, soft-delete-duration and legacy allowed-domain policies allow all; uniform access is enforced; public access prevention is not required by that policy, while the draft explicitly enables it. No incompatibility was found in this targeted set. Custom constraints, other managed constraints, tags, native service controls and complete effective IAM are not covered. This is not a deployment success claim. [Diagnostic record](../../../review/tl-trekai-terraform-review/iam-permission-org-wide/RUN_LOG.md#deployment-access-name-and-effective-policy-diagnosis--2026-11-06).

The original state-bucket root continues to own `devops-hq-bucket`. Its effective IAM review remains on hold; this draft does not resume it. The new prefix separates Terraform state ownership, not access to objects within the state bucket. Backend access and ownership must be approved before live initialization. No export payload belongs in that backend bucket.

## Bucket behavior

The deployed bucket uses Standard storage, uniform bucket-level access and enforced public access prevention. Google-managed encryption applies; no CMEK key or bucket retention policy is configured because the Cloud Asset Storage export route does not support those destination settings. [Export requirements](https://docs.cloud.google.com/asset-inventory/docs/export-cloud-storage).

There is **no automatic object deletion rule**. Exports remain until an explicitly approved manual cleanup. Object versioning is disabled; each approved export must use a fresh object name. Seven-day soft delete is explicitly configured as a recovery period after deletion, not an expiry for live exports. Storage charges continue for retained live data and applicable soft-deleted data; cleanup does not imply immediate permanent removal. [Soft delete](https://docs.cloud.google.com/storage/docs/soft-delete), [Storage pricing](https://cloud.google.com/storage/pricing).

`force_destroy = false` prevents Terraform from emptying the bucket during a destroy, and `prevent_destroy = true` rejects bucket destruction/replacement while the resource/lifecycle block remains in configuration. These are Terraform safeguards, not protection against every permitted manual object deletion or a removed resource block.

The root manages one non-authoritative `google_storage_bucket_iam_member.export_reader["user:smanley-adm@trekai.org"]`, scoped to this bucket. `access-policy.tf` holds the reviewed principal set and role, verified in live bucket IAM. `roles/storage.objectViewer` permits listing and reading/downloading objects; this grant does not confer upload/delete, bucket administration or IAM administration. A direct bucket/object URI or CLI can be used without adding broader console-navigation roles. [Cloud Storage roles](https://docs.cloud.google.com/storage/docs/access-control/iam-roles).

This is the sole explicitly configured human downloader, not proof of exclusive effective access. Public access prevention and member-level IAM do not remove inherited project/folder/organization grants; complete effective reader analysis remains outstanding. Owner/cost-owner accountability is not an IAM role; no human `roles/owner` or Storage Admin grant was added. The Google-managed export writer received a separate time-limited bucket-only Storage Admin grant for the completed operation. Cleanup is still a separately authorized action. Future additional grants require their own reviewed scope/change; no automatic removal/cleanup is configured.

No service-agent provisioning, API enablement, notification triggers, Cloud Asset export job, BigQuery dataset or new reusable module is managed by this Terraform root. Separate native identity generation, source-role and temporary writer grants, one export and its download subsequently completed under user authorization. Those two IAM member changes are recorded as native task-owned grants outside this root's state; do not add duplicate Terraform ownership or import them without explicit approval/design. The existing non-authoritative reader resource preserves the writer binding. [Execution record](../../../review/tl-trekai-terraform-review/iam-permission-org-wide/RUN_LOG.md#authorized-minimal-access-setup-organization-export-and-download--2026-11-06).

## Service-agent and writer proposal for review

**Separate native work, now completed.** The current Terraform root owns the bucket and its direct human reader member. The source-project role, temporary bucket writer and export were explicitly authorized and executed separately, with no state import or new Terraform owner. The original beta role-combination candidate was not used; Google's documented bucket-only Storage Admin setup was used with a 24-hour request-time condition.

| Proposed action | Exact scope | Review status |
|---|---|---|
| Provision Cloud Asset's service identity | Consumer project `trekai-452018`, service `cloudasset.googleapis.com`; principal `service-196473512005@gcp-sa-cloudasset.iam.gserviceaccount.com` | Native generation completed 11:08 UTC, expected email/uniqueId returned; IAM metadata read-back 403; no repeated provisioning authorized |
| Configure the service agent's Google-managed service role | Consumer project `trekai-452018` | Added/verified unconditional `roles/cloudasset.serviceAgent` for the generated agent; exactly one member addition, no removals or unrelated audit/binding edits |
| Grant export-writer access | Only `gs://trekai-iam-export-smanley-experimental`; only the verified Cloud Asset service-agent principal | Added/verified `roles/storage.admin` with request-time expiry 2026-11-07T11:22:47.170159Z; exactly one member addition, no removals; outside Terraform state |
| Run IAM export | Organization `470598084059` and descendants, supported allow policies | One export completed, downloaded and validated; object retained; no new export/cleanup authorized |

The native CLI equivalent of the completed identity-provisioning request is recorded below for reference; **do not repeat it** under the consumed approval:

```bash
# Proposed cloud change only. Not a read-only identity lookup.
gcloud beta services identity create \
  --service=cloudasset.googleapis.com \
  --project=trekai-452018 \
  --account=smanley-adm@trekai.org \
  --impersonate-service-account=terraform-org-admin@trekai-452018.iam.gserviceaccount.com \
  --billing-project=trekai-452018 \
  --format=json --quiet
```

Before proposing execution, settle resource/state ownership and record a fresh exact private output/error destination, expected effects and independent reviewer. Verify returned identity metadata; stop if it differs from the expected agent. The command is beta and its current behavior must be checked for execution. Do not enable APIs or add source-project IAM as an unreviewed side effect. An agreed Terraform ownership path may be selected instead; never create a second state owner. [Service identity command](https://docs.cloud.google.com/sdk/gcloud/reference/beta/services/identity/create), [Google's cross-project setup](https://docs.cloud.google.com/asset-inventory/docs/multiple-projects).

The source-role CLI equivalent below is historical/reference only. The corresponding etag-protected native API member edit completed under the final workflow authorization; **do not repeat it** under that consumed approval:

```bash
# Reference for the completed member grant, not a new authorization to run it.
gcloud projects add-iam-policy-binding trekai-452018 \
  --member=serviceAccount:service-196473512005@gcp-sa-cloudasset.iam.gserviceaccount.com \
  --role=roles/cloudasset.serviceAgent \
  --condition=None \
  --account=smanley-adm@trekai.org \
  --impersonate-service-account=terraform-org-admin@trekai-452018.iam.gserviceaccount.com \
  --billing-project=trekai-452018 \
  --format=json --quiet
```

The completed native member edit preserved current policy etag, conditions, other bindings and audit configuration; before/after policies remain private. It added one unconditional source service-role member, not human access or destination-project-wide storage access. Native provisioning alone did not authorize that grant; the subsequent explicit remaining-workflow instruction and execution approval did. The native generation/member edit introduced no Terraform state ownership. Future adoption/removal needs a separate ownership/change decision.

The original narrower beta-role candidate was not deployed or tested. For the user-requested one-time workflow, the approved grant followed Google's documented `roles/storage.admin` export setup, **scoped only to the dedicated bucket** and restricted by `request.time < timestamp("2026-11-07T11:22:47.170159Z")`. The agent had full bucket control during that window; it received no Storage Admin grant on a project or on the state bucket. Expiry makes the binding ineffective for subsequent requests but does not remove it or delete data. Successful export, generation-pinned download and integrity validation are recorded; no automatic retry, privilege escalation, cleanup or further collection is authorized. [Role contents](https://docs.cloud.google.com/storage/docs/access-control/iam-roles), [documented export setup](https://docs.cloud.google.com/asset-inventory/docs/multiple-projects#export_across_projects).

## Cloud scope of future operations

The read-only checks changed no Google Cloud configuration. The separately approved apply created the new bucket and its bucket-scoped human reader membership, with no resource updates/deletes in the saved plan. No workloads, networking, existing bucket configuration, project-wide IAM, service identities or API configuration were changed by this Terraform root.

The wider export workflow is not strictly bucket-only: an approved live Terraform operation would write this root's state/lock objects under the new `storage/iam-export` prefix in the existing state bucket; service-agent provisioning would change the consumer project; any service-agent role there is a separate project-level IAM operation; and an approved export writes new destination objects. These scopes require explicit review/authorization. No existing state prefix is to be migrated, overwritten or shared by this root. The exact live plan is still required to verify intended Terraform resource changes before apply; existing backend access remains unverified and its IAM review remains on hold.

## Versions and local checks

Terraform `1.17.1`, Google provider `7.22.0`, matching [INSTALLS.md](../../../INSTALLS.md). This root's lock file is copied byte-for-byte from the existing bootstrap root's reviewed lock for the same provider/version; no checksum or version is hand-edited or regenerated. It remains an independently owned per-root file.

Formatting is local and does not load the backend or contact GCP:

```bash
terraform fmt -check -recursive
```

For backend-disabled validation with an approved trusted installed provider, from the repository root:

```bash
CHECKPOINT_DISABLE=1 terraform -chdir=terraform/storage/iam-export init \
  -backend=false -get=false -lockfile=readonly \
  -plugin-dir=../../pam/rd/.terraform/providers
CHECKPOINT_DISABLE=1 terraform -chdir=terraform/storage/iam-export validate
```

The plugin path uses the existing local `hashicorp/google` installation; it is not a download/upgrade instruction. If that installation is absent or fails lock verification, stop and agree a trusted installation process. Provider plugins execute locally; these checks are not a live permission or org-policy test. No Terraform plan is part of local validation.

## Initial deployment review gates and future-change boundaries

The initial bucket/reader apply is complete; these gates record its review model and requirements for proposing future changes. The consumed saved plan must not be applied again. Changes need a fresh reviewed plan and their own authorization; the one-time reviewer exception is not a standing deployment policy.

**Single-person-review exception, 2026-11-06:** the user asked to skip the independent reviewer for the initial bucket-and-human-reader change. User instructions take precedence over the repository workflow, so that named-reviewer gate is waived for this one scope. Record user review of the exact saved plan and separate apply authorization; do not label it independent review or use another account controlled by the same person to simulate it. Service-agent provisioning, source-project IAM, writer access and other future work retain their separate review/approval requirements. This exception does not authorize live backend initialization or a plan/apply by itself.

1. Confirm the recorded owner/cost-owner/downloader design and the scope of the single-person-review exception above. Confirm the proposed bucket name, one authoritative state owner, backend scope and exact execution identity. When using ADC, confirm source ADC separately from the earlier gcloud CLI sign-in; alternatively use the prepared short-lived-token path below, which explicitly selects the human source and impersonated caller. Never print tokens or reauthenticate automatically. The initial project-scope permission omissions do not establish missing future bucket-specific grants; verify actual bucket/IAM access under the reviewed execution path.
2. Separately authorize exact read-only checks of project identity/lifecycle/billing, applicable organization policies, bucket-name ownership/availability and effective inherited access. Do not interpret an inaccessible existing bucket as an available name. The earlier quota/API checks concerned `trekai-452018`, not this destination project's deployment permissions.
3. Resolve the source consumer project's missing/unconfirmed Cloud Asset service agent and design its access to this destination. Any service-agent provisioning, API enablement or IAM change requires its own reviewed scope and authorization. Confirm storage/API prerequisites for the destination project. Agree readers, cleanup operator and evidence retention before any payload is written.
4. Review the exact code and existing provider lock. Obtain explicit authorization for the backend initialization and live plan; use the agreed backend/identity with state locking enabled. Store sensitive outputs and plans only in approved ignored private storage.
5. The current draft's plan must contain exactly two intended creates: `google_storage_bucket.iam_export` and `google_storage_bucket_iam_member.export_reader["user:smanley-adm@trekai.org"]`. The member must be `roles/storage.objectViewer` on the new export bucket only. No project/folder/org grants, authoritative IAM policy/binding replacement, API/service-agent operations or changes/replacements/deletions of existing resources are expected. Stop on any deviation, existing-resource ownership ambiguity, import request or unexpected backend state. Do not use this root to adopt an existing bucket or IAM binding without a separately approved ownership/import design. This expected plan is a review criterion, not a claim a live plan has run.

After those gates and only under exact live-operation approval, the proposed commands are:

```bash
# First approve initialization separately; this contacts the live state backend.
GOOGLE_IMPERSONATE_SERVICE_ACCOUNT="${APPROVED_TERRAFORM_CALLER:?Set the exact approved caller}" \
  terraform -chdir=terraform/storage/iam-export init -lockfile=readonly

# Approve this live plan separately and use a fresh absolute path in private storage.
GOOGLE_IMPERSONATE_SERVICE_ACCOUNT="${APPROVED_TERRAFORM_CALLER:?Set the exact approved caller}" \
  terraform -chdir=terraform/storage/iam-export plan \
  -out="${APPROVED_PRIVATE_PLAN_PATH:?Set a fresh approved absolute plan path}"

# Only after the recorded reviewer reviews it and apply is separately approved.
GOOGLE_IMPERSONATE_SERVICE_ACCOUNT="${APPROVED_TERRAFORM_CALLER:?Set the exact approved caller}" \
  terraform -chdir=terraform/storage/iam-export apply \
  "${APPROVED_PRIVATE_PLAN_PATH:?Set the reviewed approved absolute plan path}"
```

The placeholders must be filled with exact approved values before proposing execution. No blanket authorization for these commands is present. Never disable locking or put credential material in backend/provider configuration.

### Prepared initial backend and plan operation

**Executed under explicit init/plan authorization, 2026-11-06 10:36:48–10:37:00 UTC; no apply.** [Manifest](../../../review/tl-trekai-terraform-review/iam-permission-org-wide/output/2026-11-06T101536.346530-0000-bucket-plan-review/manifest.json), SHA-256 `bd4f7a76769e703c9239de5656d8af62526771c7952bb029c7e2e2e3d1790ebd`. The [runner](../../../review/tl-trekai-terraform-review/iam-permission-org-wide/prepare_bucket_plan.py) snapshots the four root HCL files and unchanged provider lock into private ignored storage, verifies the reviewed hashes before execution, and has no apply path.

The historical [private plan-review summary](../../../review/tl-trekai-terraform-review/iam-permission-org-wide/output/2026-11-06T101536.346530-0000-bucket-plan-review/plan-review-summary.json) describes the exact two-create result before approval. Saved plan SHA-256: `9385f2492fc5c937f5c9df74bcd3e357a477ee15017ddbaf678bbd67bfca1dd9`. Init exited `0`; plan exited `2` (changes present); local show exited `0`. Expected resource actions and all bucket/reader settings were checked, with private evidence modes verified. Backend access worked for this operation; no token/credentials were persisted in backend configuration. These local checks are not independent human review. The user subsequently approved the plan's apply, which completed at 10:48 UTC. The plan is consumed; do not reuse it.

The proposed live operation would obtain one token with the exact existing admin-to-service-account gcloud command, then pass that token only in the child-process `GOOGLE_OAUTH_ACCESS_TOKEN` environment to both backend and provider. Inherited Google/TF credential, CLI-argument and debug settings are removed from the child environment; it uses default workspace and the verified local provider installation. It does not depend on an unverified ADC login or change credentials/configuration. Token environment support was checked against Terraform 1.17.1 GCS backend source and Google provider 7.22.0 documentation.

Before initialization, GET metadata only for `gs://devops-hq-bucket/storage/iam-export/default.tfstate`: stop if it exists or is inaccessible; only a native 404 permits this new-root operation to continue. Live init uses the configured `devops-hq-bucket` / `storage/iam-export` backend, with provider lock read-only. State/lock handling under that new prefix is in scope; existing root prefixes and bucket IAM are not. No migration, import or disabled locking. The saved plan is private, followed by a local JSON inspection requiring exactly the reviewed two creates and expected project/bucket/region/reader values. Any failure or mismatch stops without retry or apply. A completed plan still awaits user review and separate apply approval.

The exact runner invocation approved and executed once was:

```bash
/usr/bin/python3 -B review/tl-trekai-terraform-review/iam-permission-org-wide/prepare_bucket_plan.py \
  --execute review/tl-trekai-terraform-review/iam-permission-org-wide/output/2026-11-06T101536.346530-0000-bucket-plan-review/manifest.json \
  --manifest-sha256 bd4f7a76769e703c9239de5656d8af62526771c7952bb029c7e2e2e3d1790ebd
```

This was a live backend/state/data operation under explicit approval; that approval is consumed. It created no bucket or IAM grant. Exact token/init/plan/show argv, state metadata URL, snapshot hashes and private output path are in the manifest; no secrets are in the manifest or argv. Do not repeat this operation or apply the saved plan without new authorization. Each attempt gets its own execution record, and this prepared operation cannot silently retry a prior attempt.

### Completed exact-plan apply

The user approved the two-create summary and exact-plan apply, then said “continue” after an interrupted preparation turn. Local evidence confirmed no apply had started during that interruption. The separately approved [apply runner](../../../review/tl-trekai-terraform-review/iam-permission-org-wide/apply_bucket_plan.py) verified the approved plan/source/snapshot hashes and settings, rendered the exact saved plan locally again, obtained the same explicit source-account/impersonated-caller token and applied that binary plan once, with locking enabled. It did not generate a new plan or change the service agent.

Apply ran **2026-11-06 10:47:48–10:48:06 UTC**, native exit `0`, **2 added, 0 changed, 0 destroyed**. Two subsequent GETs on the new bucket returned HTTP `200`: metadata and version-3 IAM policy. Project number/name/location/Standard/UBLA/public prevention/no expiry/versioning disabled/seven-day soft delete/no bucket retention/CMEK and the exact unconditional Object Viewer membership were verified. Evidence/plan/diagnostics remain owner-only and ignored; response and plan hashes checked locally. [Private execution record](../../../review/tl-trekai-terraform-review/iam-permission-org-wide/output/2026-11-06T101536.346530-0000-bucket-plan-review/apply-execution.json).

These observations do not prove exclusive effective human access or actual downloader/export-writer behavior. No follow-up no-change live plan, service-agent setup, export or download was run under this approval. The apply approval and initial reviewer exception are consumed. Source comments were updated after the apply to reflect deployment; original reviewed code/plan snapshots remain unchanged. Future source changes require a fresh plan, not reuse of the consumed initial plan.

## Verification and recovery

After an approved creation, inspect bucket metadata and direct/inherited access under separately approved reads. Confirm exact project/location, Standard storage, uniform access, public access prevention, seven-day soft delete, no lifecycle deletion, no bucket retention policy/CMEK, and the intended reader membership. Verify the downloader's read access separately after an approved export, and do not infer exclusivity without inherited-access analysis. Confirm only this root owns the bucket and this member binding. A reviewed follow-up plan and later approved export/download are distinct operations; local checks do not establish either result.

Writer/reader access, full export-operation success, local download integrity and evidence retention must be verified before calling the route operational. The [export runbook](../../../review/tl-trekai-terraform-review/iam-permission-org-wide/README.md) covers fresh object naming, snapshot timestamps, private polling/downloads and coverage limits. No cleanup is automatic.

Before deployment, recovery is to revise or abandon the local draft. After deployment, stop exports and preserve data/state when an issue appears; do not automatically destroy the bucket. Removing payloads, revoking access or removing the protected bucket requires a separately reviewed cleanup/change plan and approval. Changing the bucket name/location can imply replacement and is blocked by the lifecycle safeguard while present.

## Change record

| Date | Authorization and result | Verification / follow-up |
|---|---|---|
| 2026-11-06 | User approved a local dedicated IAM-export bucket draft and selected `smanley-experimental / us-central1`, retaining exports until approved manual cleanup. Proposed one new bucket and distinct state prefix; no IAM/service-agent/API/cloud/state operation authorized or executed. | Repository-wide formatting and backend-disabled local initialization passed. Existing cached Google 7.22.0 provider content matched a locked `h1` checksum; copied lock unchanged. Sandbox validation could not start the plugin; separately approved local retry passed with zero errors/warnings. Local document links/fences checked. Bucket name, accountable owners/reviewer, backend authorization, inherited access, writer/readers and service-agent resolution remain open. |
| 2026-11-06 | User approved read-only destination preflight; project ACTIVE/billing enabled confirmed. No resource, IAM or state change. | Project permission test returned create/quota usage, omitted bucket get/update; stopped before name lookup. Execution access, name, org policy, effective inherited access and ownership decisions remain open. |
| 2026-11-06 | User approved the proposed admin-only human access design. Added one local bucket-scoped Object Viewer member for `smanley-adm@trekai.org`; recorded that account as accountable/cost owner and kept the proposed impersonated deployment path. No live IAM/state/resource operation. | Formatting and backend-disabled local validation passed, zero errors/warnings. Independent reviewer, effective inherited access, deployment/reader/writer checks and service agent remain open. Expected plan now two creates; no live plan executed. |
| 2026-11-06 | User approved read-only deployment/name/policy diagnosis and a local service-agent/writer proposal; all live requests were reads/tests. User asked to confirm scope; source-project service identity/IAM and backend writes were explicitly separated from the current bucket-only resource draft. | Native project policy/basic-role behavior explains earlier project-test omissions; no extra project role justified by that test alone. Proposed name GET 404; seven targeted policies retrieved and no draft conflict found. Writer role candidate remains unverified/ungranted; service-agent changes, independent reviewer, complete access/custom constraints/backend/ADC and exact live plan remain pending. |
| 2026-11-06 | User requested skipping the independent reviewer for the initial bucket/reader change; recorded a scoped single-person-review exception. Prepared exact backend-init/plan manifest and runner locally. | No live command executed. User plan review and separate apply approval remain required; service-agent/writer and other changes are excluded from the exception. |
| 2026-11-06 | User explicitly approved live backend init and plan only. Completed new-prefix backend initialization and saved exact two-create plan; no apply. | Hash `9385f2492fc5c937f5c9df74bcd3e357a477ee15017ddbaf678bbd67bfca1dd9`; bucket/reader settings, backend scope, private modes and no stored backend auth material checked. Await user review and explicit apply approval; source-project/service-agent/writer/export remain excluded. |
| 2026-11-06 | User approved exact saved-plan apply and resumed after an interruption. Applied once through the explicit admin-to-service-account path; native exit `0`, 2 added/0 changed/0 destroyed. No service-agent/API/project-wide IAM/export action. | Metadata and direct reader membership verified via two HTTP-200 reads; hashes/private modes checked. Full effective IAM, service-agent/writer setup, actual export/download and a follow-up no-change plan remain unverified/unexecuted. No automatic cleanup or further live action authorized. |
| 2026-11-06 | User separately authorized consumer Cloud Asset service-identity provisioning. Native operation completed with expected email/uniqueId; no separate IAM grant or API enablement. | IAM metadata GET 403 preserved; source-project allow-policy member rows unchanged and direct default service role absent. Source-role proposal prepared, writer grants/export/download unexecuted; no independent human review claimed. |
| 2026-11-06 | User authorized the minimal remaining workflow: source service role, dedicated bucket writer, one organization-wide export and download. Added source role and temporary bucket-only Storage Admin with exact additive policy checks, then completed the export/download. | Snapshot 11:26:04.615230 UTC; 484 resource records, 1,431 bindings; 480,666-byte local file verified against cloud generation/size/CRC32C and SHA-256. Corrected local summary for native snake_case field names without changing/recollecting raw data. Data retained; writer expires 2026-11-07 11:22:47 UTC. No cleanup or further cloud action authorized. |
