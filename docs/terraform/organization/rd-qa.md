# RD QA folder and project

**Status, 2026-11-16: applied and live-verified.** The user approved the exact saved plan under their own review; no independent human review is claimed. One guarded apply completed at **14:35:48 UTC**, exited 0 and reported **2 added, 0 changed, 0 destroyed**. Direct live read-back at **14:36:07 UTC** passed all fourteen checks: folder `674133939280` and project `prj-trekai-rd-qa` / `1034076260256` are ACTIVE, with the intended parent chain, QA/Terraform labels and billing enabled on the confirmed account. The successful creation resolves the earlier project-ID availability uncertainty. The creation plan is consumed and must not be reused.

## Scope and ownership

```text
trekai.org (470598084059)
├── trekai-rd-dev (561034768953; verified 2026-11-13)
│   └── prj-trekai-rd-dev (existing)
└── trekai-rd-qa (674133939280; verified 2026-11-16)
    └── prj-trekai-rd-qa (1034076260256)
```

| Setting | Applied / documented value |
|---|---|
| Root | `terraform/organization/rd-qa/` |
| Folder parent | `organizations/470598084059`, sibling of RD Dev; user confirmed |
| Folder display name | `trekai-rd-qa` |
| Folder ID / lifecycle | `674133939280` / ACTIVE; live-verified |
| Project name and ID | `prj-trekai-rd-qa`, inside the new QA folder |
| Project number / lifecycle | `1034076260256` / ACTIVE; live-verified |
| Billing account | `018378-808B11-17982B`, same as RD Dev; project linkage and billing enabled live-verified |
| Backend | Existing `devops-hq-bucket`, separate prefix `organization/rd-qa`; initialized 2026-11-16, default workspace |
| Resource owner in Terraform | This new root/state only: `google_folder.rd_qa`, `google_project.rd_qa` |
| Accountable infrastructure/cost owner | Formal designation remains a follow-up |
| Reviewer | User approved exact-plan execution under their review; no independent human review claimed |
| Folder and backend identity | Direct `smanley-adm@trekai.org` |
| Project identity | `google.project_creator` impersonates `terraform-org-admin@trekai-452018.iam.gserviceaccount.com` from the direct admin source |
| Quota project for execution | `trekai-452018`, selected explicitly for preflight API calls |

This deployment reused the successful provider split documented in the [RD Dev guide](rd-dev.md), verified there on 2026-11-13 and exercised successfully for QA on 2026-11-16. RD Dev's initial service-account-only attempt was denied folder creation. Historical approvals are consumed and do not authorize future operations. Do not set global impersonation: it would also affect the folder provider and possibly the backend.

This root declares two resources and no PAM, IAM, workload, custom-network, API-enablement or workload-state-bucket resources. The QA project depends on the folder's generated ID. Labels use `environment=qa` and `managed_by=terraform`. Folder deletion protection, project deletion policy `PREVENT`, and both Terraform `prevent_destroy` guards match RD Dev. Removing resource blocks or using other tools can bypass some of these guards.

`auto_create_network = true` retains the RD Dev setting. The effective organization policy `constraints/compute.skipDefaultNetworkCreation` returned `enforced: false` on 2026-11-16 at 14:28 UTC, so default-network creation is allowed. This does not guarantee a network-free project or establish what Google will create. Do not casually switch to `false`; the pinned provider's documented behavior includes enabling Compute and deleting the generated default network. No QA network/API inventory has been queried.

As a sibling folder, QA does not inherit grants from RD Dev or the existing RD folder. Organization-level inheritance still applies. [QA project Terraform-builder PAM](../pam/rd-qa.md) was subsequently created in its own root/state and verified AVAILABLE on 2026-11-16 at 14:51 UTC; it is not managed by this folder/project root. A dedicated QA workload backend remains separate scope. The backend here stores this platform root's state, not contractor workload state. Leave existing Dev resources, root and state prefix unchanged.

## Review and execution path

Terraform **1.17.1** and Google provider **7.22.0** match [INSTALLS.md](../../../INSTALLS.md). The root owns a byte-for-byte copy of RD Dev's reviewed provider lock; no versions/checksums were regenerated or hand-edited.

1. Preserve this root/state as the owner of the recorded QA folder/project; do not recreate them or manage them from another state. Confirm accountable owners and coordinate other organization-management roots before proposing changes. Review the exact local diff, identity and state boundary.
2. Run local formatting from the repository root: `CHECKPOINT_DISABLE=1 terraform fmt -check -recursive`. Backend-disabled initialization/validation requires an approved trusted provider execution path, an isolated temporary `TF_DATA_DIR`, no cloud credentials and no live backend; follow the [RD Dev local review instructions](rd-dev.md#versions-and-local-review), substituting the QA root. Formatting alone does not validate the provider schema or cloud behavior.
3. Obtain explicit approval for any new scoped live preflight. Preserve existing resource/state ownership. A permission-denied lookup does not prove absence; stop for unclear results or conflicts. Never import or migrate state automatically.
4. If backend initialization is needed, obtain scoped authorization and use verified direct-admin credentials, the default workspace, read-only lock and state locking. The QA prefix is now in use: preserve its existing state. Use private local metadata and clear inherited credential/impersonation overrides as in the RD Dev runbook. Stop for migration requests or unexpected state.
5. With explicit plan authorization, save a fresh private plan and review identities, backend and the exact intended delta. The initial **two-create** result below is historical: do not expect or approve another creation plan for these existing resources. Stop for unexpected creates, replacements, deletes, IAM changes or ownership ambiguity. A plan reads live cloud/state data; it is not a local check. No follow-up no-change plan has run.
6. Obtain the required independent human review and explicit approval of that exact saved plan before apply, unless the user explicitly agrees to another execution path. Verify the plan hash, source/configuration, backend, identities and workspace; keep locking enabled. Run the approved plan once and record actual results. Never reuse a consumed plan or blindly retry a partial failure.
7. With scoped verification authorization, check the generated folder/project IDs, ACTIVE lifecycle, parent chain, labels and billing linkage; record the identities, timestamps, outcome and remaining access/network/API/ownership follow-ups. Do not claim QA exists before verification. Following a partial failure, reconcile cloud and state under new authorization before any retry. Deletion, rollback or migration needs separate review and scope.

## Change record

| Date | Authorization and scope | Result | Follow-up |
|---|---|---|---|
| 2026-11-16 | User requested a QA folder/project following RD Dev; local preparation only. No live execution identity selected or live operation authorized by this record. | Prepared a separate QA root, copied provider lock, mirrored guide and index entry. Organization, billing and provider split are proposed reuse of dated RD Dev evidence. Local check results are recorded below. | Confirm proposed scope/owners, approve trusted local provider checks if needed, then separately authorize live preflight, backend initialization, plan and exact-plan apply. |
| 2026-11-16 | User said "proceed" after the same organization/billing scope was presented. Agent stated local validation and read-only preflight scope. Provider execution outside the sandbox and read-only cloud preflight separately approved through execution prompts. | Backend-disabled validation passed with Google 7.22.0 and unchanged lock. At 14:28 UTC, selected direct-admin/service-account path, organization ACTIVE, billing open, checked permissions and empty QA state prefix confirmed; zero matching direct-child folders. Project GET 403, so availability unresolved. Default-network creation allowed. No backend init, plan, state write, IAM change or resource creation. | Obtain authorization for QA backend initialization and a fresh private saved plan; review the exact result before separately authorizing apply. Accountable owners/independent reviewer and cross-state ownership coordination remain follow-ups. |
| 2026-11-16 | User said "proceed" to the explicit QA backend-initialization/private-saved-plan request; outside-sandbox execution separately approved. Direct admin source/backend/folder, project-only service-account impersonation, quota `trekai-452018`, default workspace and locking enabled. | Prefix recheck empty. Init 14:31:46–14:31:50 UTC exited 0; plan 14:31:50–14:31:55 UTC exited 2. Exactly two creates, no updates/deletes; all filtered target/provider/dependency checks passed. Plan hash and private evidence below. No apply or independent human review claimed. | User/exact-plan review and explicit apply authorization required; do not re-plan or apply a different file under this approval. Project ID availability and accountable ownership remain unresolved. |
| 2026-11-16 | User said "approved" to applying the exact saved plan under their review, explicitly with no independent human review recorded. Exact-plan execution outside the sandbox was approved. | Hash/source/lock/backend/workspace/private-permission guards passed; same direct-admin/project-service-account split and state locking. One apply at 14:34:56–14:35:48 UTC exited 0: **2 added, 0 changed, 0 destroyed**. Declared outputs returned folder `674133939280` and project `prj-trekai-rd-qa` / `1034076260256`. No automatic retry, import, migration or separate IAM mutation ran. | Plan consumed. Verify the created resources; future changes need fresh review and scoped authorization. |
| 2026-11-16 | Read-only verification of the approved creation, limited to the new QA folder, project and billing, was allowed through the execution prompt. Folder read used the direct admin; project/billing reads used explicit service-account impersonation. | At 14:36:07 UTC all fourteen read-back checks passed. Names/IDs, ACTIVE lifecycle, parent chain, QA/Terraform labels and billing enabled/account linkage confirmed. Updated guide/index/status comment and README. Raw API responses were not saved or printed. | Accountable ownership, full effective IAM/policy/network/API inventory and any follow-up no-change plan remain separate follow-ups. QA PAM/workload backend are outside this creation scope. |

## Consumed creation plan

- Private plan: `/private/tmp/devops-hq-rd-qa-plan-epx44llk/create.tfplan`, mode 0600, in a mode-0700 directory.
- SHA-256: `c5a1932e8964d9449c2a21f0f8b0a221738e9b574d9db89dc75ef9b3db30af3d`.
- Private logs and metadata: `init.log`, `plan.log`, `execution.json`, `apply.log`, `apply-started.json`, `apply-execution.json`, `created-resource-ids.json`, `verification.json`, plus isolated `terraform-data/`, under that same directory. The metadata records contain source/lock hashes, identities, timestamps, backend/workspace, actual counts and filtered review/verification outcomes; they contain no tokens or raw state/plan JSON. Temporary local evidence is not durable archival storage.
- Planned actions: create `google_folder.rd_qa` (`trekai-rd-qa`, parent `organizations/470598084059`) and `google_project.rd_qa` (`prj-trekai-rd-qa` inside the generated folder). Billing account `018378-808B11-17982B`; labels `environment=qa`, `managed_by=terraform`; folder deletion protection and project deletion policy `PREVENT`; `auto_create_network=true`. Both source lifecycle guards remain `prevent_destroy=true`.
- Reviewed provider configuration: folder on default direct-admin `google`; project on `google.project_creator`, configured for the existing service account. Project `folder_id` references `google_folder.rd_qa.folder_id`.
- The wrapper selected a direct admin token in memory and passed it only in the Terraform child environment. Inherited Google/Cloud SDK/Terraform overrides were cleared; there was no global impersonation or persisted backend credential. Quota/provider project was explicitly `trekai-452018`. The unchanged trusted Google 7.22.0 provider/cache and read-only lock were reused without downloads. Backend metadata was checked for GCS / `devops-hq-bucket` / `organization/rd-qa`, no persisted credential/impersonation and the default workspace; source hashes stayed unchanged during initialization/planning. State locking remained enabled.

The user approved this exact plan under their own review and it was applied once successfully. **It is consumed: never apply it again.** No independent human review is claimed. The wrapper checked the plan/source/lock hashes, backend/default workspace, private permissions and caller path before execution; it wrote an exclusive apply-started marker to prevent a second attempt. The following status-comment edit changes no access or resource setting. Future plans/changes require new review and scoped authorization; keep state locking enabled. Creation resolved the earlier ID-availability uncertainty, while actual network/API contents remain unreviewed.

## Creation verification

Direct GETs at **2026-11-16 14:36:07 UTC** passed all fourteen checks, including agreement with the declared Terraform outputs:

| Verified item | Result |
|---|---|
| Folder display name / resource name / state | `trekai-rd-qa` / `folders/674133939280` / ACTIVE |
| Folder parent | `organizations/470598084059` |
| Project display name / ID / number / state | `prj-trekai-rd-qa` / `prj-trekai-rd-qa` / `1034076260256` / ACTIVE |
| Project parent | `folders/674133939280` |
| Project labels | `environment=qa`, `managed_by=terraform` verified |
| Billing | Expected project, `billingEnabled=true`, `billingAccounts/018378-808B11-17982B` |

This verifies creation/configuration, not contractor access, complete inherited/effective IAM, deny policies, network/API inventory or workloads. No PAM entitlement or dedicated workload-state bucket was created by this root; the subsequent separately authorized [QA PAM deployment](../pam/rd-qa.md) has its own record/state. Future operations require a new scoped authorization; neither the consumed plan nor prior permission checks are standing approval. Keep existing state/resources intact; deletion, billing unlink, migration, import or ownership transfer needs its own reviewed change.

## Read-only preflight evidence

Checks ran at **2026-11-16 14:28:01–14:28:19 UTC**, selecting `smanley-adm@trekai.org` explicitly from its named gcloud credential and obtaining the project token with an explicit impersonation target of `terraform-org-admin@trekai-452018.iam.gserviceaccount.com`. The wrapper cleared inherited credential/CLI overrides and checked that gcloud configuration contained no credential-file, token-file, disabled-credential or global-impersonation override. Tokens remained in subprocess/parent memory and were not printed or saved. This confirms the selected credential path, not a separate token-subject introspection result: an earlier auxiliary user-info request returned 403 and was abandoned; no IAM or API changes were attempted.

| Scoped check | Result |
|---|---|
| Organization | Expected ID, ACTIVE |
| Direct admin permissions on organization | `resourcemanager.folders.create` and `resourcemanager.folders.list` both returned |
| Project service-account permissions on organization | `resourcemanager.projects.create` and `resourcemanager.projects.get` both returned; permissions on a future folder remain to be exercised |
| Billing account, project service account | Expected account open; `billing.accounts.get` and `billing.resourceAssociations.create` both returned |
| QA direct-child folder lookup | Zero matching display names in paginated organization-child listing |
| QA project GET, project service account | HTTP 403 / IAM_PERMISSION_DENIED; does not establish absence or global ID availability |
| Direct admin backend permissions | `storage.objects.get`, `list`, `create`, `delete` all returned by permission test; test itself wrote/deleted nothing |
| QA backend prefix | Metadata-only listing of `organization/rd-qa/` in `devops-hq-bucket` empty; no state contents read |
| Effective default-network policy | `constraints/compute.skipDefaultNetworkCreation`: `enforced: false` |

These are limited scope checks, not a complete effective IAM, deny-policy, organization-policy or cross-state ownership audit. No current project/folder is adopted. Stop for unexpected resources or state in any later approved operation. A 403 must not be interpreted as project-name availability; even an empty accessible-project search would not prove global availability.

Local checks, 2026-11-16: repository-wide formatting, diff whitespace checks and backend-disabled initialization/validation passed. The first sandboxed validation could not start the provider; the explicitly approved outside-sandbox retry passed. It used isolated metadata at `/private/tmp/devops-hq-rd-qa-validation-xgjeji1w`, the existing Google 7.22.0 cache, disabled CLI configuration/checkpoint checks and cleared cloud credential overrides; no provider download, live backend or cloud credentials were used for validation. The provider lock matches RD Dev byte-for-byte. The local review wrapper is `/private/tmp/devops-hq-rd-qa-review.py`; it contains scope constants and code, no credentials. No independent human review is claimed. Final documentation/status-comment changes require only formatting/whitespace checks; they change no resource setting.
