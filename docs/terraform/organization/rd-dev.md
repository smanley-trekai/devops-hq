# RD development folder and project

**Status, 2026-11-13: applied and live-verified.** The initial service-account-only apply failed at folder creation. After user-approved permission checks, reconciliation and a local provider split, a fresh reviewed exact-plan apply completed at **19:03:18 UTC: 2 added, 0 changed, 0 destroyed**. Separately approved live reads confirmed folder `561034768953` and project `prj-trekai-rd-dev` / `413711767398` are ACTIVE, correctly parented and billing-enabled. No separate IAM grant, import, state migration or automatic retry ran. Both saved plans belong to completed attempts and must not be reused. Future operations need fresh scoped approval.

## Purpose and scope

Manage a folder directly under the TrekAI organization and a billing-linked project inside that folder. The project references the folder's generated ID, so Terraform ordered creation automatically. The folder is not inside the existing RD folder.

```text
trekai.org (470598084059)
└── trekai-rd-dev (561034768953)
    └── prj-trekai-rd-dev (413711767398)
```

| Setting | Applied / documented value |
|---|---|
| Terraform root | [`terraform/organization/rd-dev/`](../../../terraform/organization/rd-dev/) |
| Organization | `470598084059`, supplied by the user |
| Folder display name | `trekai-rd-dev` |
| Folder ID and parent | `561034768953`, directly under `organizations/470598084059`; live-verified |
| Project name and ID | `prj-trekai-rd-dev` |
| Project number and parent | `413711767398`, under folder `561034768953`; live-verified |
| Billing account | `018378-808B11-17982B`; account open and project billing enabled/linkage live-verified on 2026-11-13 |
| State backend | Existing `devops-hq-bucket`, prefix `organization/rd-dev`; already initialized, preserve existing state |
| Terraform owner | This root/state manages `google_folder.rd_dev` and `google_project.rd_dev`; do not manage them from another state |
| Accountable infrastructure and cost owners | Not formally designated in this record; follow-up confirmation required |
| Folder identity | `smanley-adm@trekai.org` directly, via default Google provider |
| Project identity | `terraform-org-admin@trekai-452018.iam.gserviceaccount.com`, via `google.project_creator`, impersonated from the direct admin source |
| Backend identity and quota project | Direct `smanley-adm@trekai.org`; tested object permissions and successful init/plan/apply. Quota project `trekai-452018` |
| Reviewer | Both exact plans reviewed/approved by the user; no independent human review claimed |

The billing ID matches the local `tl-trekai-terraform` checkout's `organization/project/terraform.tfvars` and `organization/billing/terraform.tfvars` inspected on 2026-11-13. The [second brain's 2026-11-03 project record](/Users/ron/Documents/trekai/sm-trekai-infrastructure-and-product-review/reviews/google-cloud/workspace/codex/2026-11-03-experimental-project/README.md) also records its successful historical use as “My Billing Account.” The user approved the billing linkage in both exact-plan reviews. The revised apply succeeded, and the subsequent billing read confirmed `billingEnabled: true` and the selected account.

A local search before creation on 2026-11-13 found neither proposed name in this repository's existing Terraform nor the other checkout's `organization/` HCL/tfvars. That limited search was not a complete cross-state inventory. This root subsequently created both resources; preserve its ownership boundary with `tl-trekai-terraform`, which also manages organization resources. Accountable maintainer confirmation remains a follow-up. Never add these resources to both repositories/states.

## Behavior and protection

- The project is created under the new folder and linked to the selected existing billing account. Billing remains managed by `google_project`; it is not also managed by a billing-association resource.
- The default Google provider uses direct admin credentials for `google_folder.rd_dev`. The project explicitly selects `google.project_creator`, which impersonates the existing service account from those source credentials. Resource addresses and the state prefix were preserved; no resource move, import or separate IAM grant ran. Direct admin backend access and the combined provider path worked for the successful apply; these observations are not a full effective-access review.
- Folder `deletion_protection = true`, project `deletion_policy = "PREVENT"`, and both Terraform `prevent_destroy` blocks guard against Terraform deletion/replacement. They do not prevent deletion through other tools, and removing resource blocks removes Terraform lifecycle protection. Retirement or ownership migration requires a separately reviewed change.
- The root declares no IAM or PAM grant resources, workloads, custom networks or explicit API-enablement resources. Google-managed project/folder creation behavior is separate from those declarations. The new folder is a sibling of existing top-level folders: grants on the existing RD folder do not inherit into it. Full inherited/effective access and policy coverage remain unverified.
- `auto_create_network = true` retains the provider's default behavior. On 2026-11-13 the effective organization policy `constraints/compute.skipDefaultNetworkCreation` returned `enforce: false`; the user subsequently approved the initial plan with default-network creation allowed. This is not a guarantee of a network-free project. Do not switch this flag casually: in provider 7.22.0, `false` enables `compute.googleapis.com`, deletes Google's generated default network and leaves the API enabled.

Provider references: [folder](https://registry.terraform.io/providers/hashicorp/google/7.22.0/docs/resources/google_folder), [project](https://registry.terraform.io/providers/hashicorp/google/7.22.0/docs/resources/google_project). Existing Google organization policies may affect project creation and default services/resources independently of the two declared resources.

## Versions and local review

Terraform **1.17.1**, Google provider **7.22.0**, matching [INSTALLS.md](../../../INSTALLS.md). The root owns a byte-for-byte copy of the bootstrap root's existing reviewed provider lock; no versions or checksums are regenerated or hand-edited.

From the repository root, formatting needs no backend, credentials or provider execution:

```bash
CHECKPOINT_DISABLE=1 terraform fmt -check -recursive
```

For backend-disabled checks, reuse the approved installed provider and a fresh local data directory. The following commands are local checks only; the plugin path is not a download instruction:

```bash
export TF_DATA_DIR="$(mktemp -d /private/tmp/devops-hq-rd-dev-validation.XXXXXX)"
CHECKPOINT_DISABLE=1 terraform -chdir=terraform/organization/rd-dev init \
  -backend=false -get=false -lockfile=readonly \
  -plugin-dir=../../pam/rd/.terraform/providers
CHECKPOINT_DISABLE=1 terraform -chdir=terraform/organization/rd-dev validate
unset TF_DATA_DIR
```

Stop if the trusted cached provider is unavailable or fails checksum verification. Do not download/upgrade providers, configure credentials or initialize the live backend as a workaround. Local validation does not prove cloud access, billing, organization-policy compliance, resource availability or state ownership.

**Local results, 2026-11-13:** repository-wide formatting passed. Backend-disabled initialization succeeded using the existing cached Google 7.22.0 package and the read-only lock; the lock matched the bootstrap copy byte-for-byte. The sandbox prevented the provider process from starting for validation. A separately approved local retry outside the sandbox passed with no errors or warnings, using the same isolated temporary data directory, disabled CLI configuration/checkpoint checks and no inherited Google/Cloud SDK or Terraform environment settings. No provider download, cloud authentication or live backend access was used.

After the provider revision, separately approved repository-wide formatting and backend-disabled validation both passed again. The latter reused the isolated validation directory and cached provider outside the sandbox with cloud credential overrides removed; no live backend access was used for that check. Final deployment-record edits change documentation/comments only; the authorized `git diff --check` result is reported separately after execution.

## Approved initial attempt and permission findings

All live commands below were individually presented and approved by the user on 2026-11-13. These approvals are historical and do not authorize repetition.

- Source login was `smanley-adm@trekai.org`, impersonating `terraform-org-admin@trekai-452018.iam.gserviceaccount.com`, quota project `trekai-452018`. The organization read returned `trekai.org`, `ACTIVE`, and the expected organization ID. Billing account `018378-808B11-17982B` returned open and named “My Billing Account.” The direct-child folder-name lookup returned no match. Initial project describe returned permission-denied-or-missing, so ID availability was unconfirmed at that point; the later successful creation resolved it for this project.
- The existing state object generation `1794594270121578` was 269 bytes. Its limited in-memory inspection returned Terraform 1.17.1, serial 2, zero resource entries and one `project_id` output matching the intended project. Local backend metadata matched GCS / `devops-hq-bucket` / `organization/rd-dev`. This was not an unused prefix. The later approved post-failure reconciliation still found serial 2, zero resource entries, the matching output and no matching direct-child folder.
- A private directory, `/private/tmp/devops-hq-rd-dev.SbYdBt`, holds the saved plan, private logs, execution receipt and isolated Terraform metadata. Backend initialization reused the existing Google 7.22.0 provider and lock. Short-lived credentials were passed in child-process environment memory; tokens and raw state were not printed.
- Saved planning exited 2. Local filtered review confirmed exactly `google_folder.rd_dev` and `google_project.rd_dev` creates, zero updates/deletes, the expected names/organization/billing, deletion guards, default-network setting, labels and the project's dependency on the folder. Plan SHA-256: `6de3e4831789fbddbf8a61ec884404c605c7c99e08f514fc5c1d6d573f3429f9`; plan mode 0600. The user reviewed and approved that exact plan; no independent human review is claimed.
- The hash/backend-guarded apply ran once at **2026-11-13 18:44:32–18:44:38 UTC**, exited 1 and reported `resourcemanager.folders.create` denied on the organization. It did not report a successful create. No automatic retry, rollback, resource deletion or IAM mutation followed. Treat that plan as belonging to the failed attempt: do not reuse it for the revised configuration.
- The service account's direct organization-role lookup included Project Creator but no Folder Creator/Admin. This alone does not establish all effective access; the folder-create denial is the actual execution result. Separately approved direct-account `testIamPermissions` calls confirmed `smanley-adm` has organization-level `resourcemanager.folders.create` and lacks organization-level `resourcemanager.projects.create`. These tests say nothing definitive about permissions on a future folder. The revised provider split avoids relying on the admin account's organization-level project-creation permission.

## Successful revised apply and verification

Each command in this sequence was separately approved by the user. These consumed approvals are not standing authorization for another operation.

1. Direct admin bucket `testIamPermissions` returned all four requested permissions: `storage.objects.get`, `list`, `create` and `delete`. The test itself wrote/deleted nothing. Post-failure reconciliation found no matching folder and the unchanged empty-resource state described above.
2. Fresh private local metadata under `/private/tmp/devops-hq-rd-dev.SbYdBt/admin-source/terraform-data` initialized the same GCS backend with a direct admin token held only in child-process environment memory. No global or cached backend impersonation was used, and the unchanged provider lock/cache was reused.
3. Fresh planning exited 2. Local filtered review confirmed two creates, zero updates/deletes, `google_folder.rd_dev` on default provider `google`, and `google_project.rd_dev` on `google.project_creator` with the expected impersonation target. All target, billing, label, deletion-guard, default-network and dependency settings matched the approved scope. The mode-0600 plan's SHA-256 was `e04adcb26e7fc7b6e2f659fe18a92fd4093218a4f10e540d1b75400a725de22f`.
4. The user reviewed and separately approved that exact plan. After hash/backend/workspace/private-permission guards, apply ran once at **2026-11-13 19:02:26–19:03:18 UTC**, exited 0 and reported **2 added, 0 changed, 0 destroyed**. Source/backend/folder caller: direct `smanley-adm@trekai.org`. Project caller: the configured service-account impersonation provider. Locking stayed enabled. No independent human review is claimed.
5. Separately approved live reads confirmed the results below. Project and billing reads used the service account impersonated from the explicit admin source; the folder read used the direct admin. No configuration or state changes ran during verification.

| Verified item, 2026-11-13 | Result |
|---|---|
| Folder name / ID / lifecycle | `trekai-rd-dev` / `561034768953` / `ACTIVE` |
| Folder parent | `organizations/470598084059` |
| Project name / ID / number / lifecycle | `prj-trekai-rd-dev` / `prj-trekai-rd-dev` / `413711767398` / `ACTIVE` |
| Project parent | Folder `561034768953` |
| Project labels | `environment=dev`, `managed_by=terraform`, provider-added `goog-terraform-provisioned=true` |
| Billing linkage | `billingEnabled: true`, account `018378-808B11-17982B` |

Private evidence is retained under `/private/tmp/devops-hq-rd-dev.SbYdBt/admin-source/`: `create.tfplan`, `plan.log`, `apply.log`, `apply-started.json`, `apply-execution.json` and isolated Terraform metadata. Tokens and raw state were not printed or copied into the repository. The apply receipt records the exact plan hash, selected identities, backend, timestamps, exit code and counts. The saved plan is consumed and must not be applied again. These temporary local files are not a durable evidence-retention guarantee; any move or cleanup needs its own approved handling.

## Future operations require separate authorization

1. Preserve this root as the sole state owner for the recorded folder/project IDs. Confirm accountable infrastructure/cost owners and maintainer coordination with `tl-trekai-terraform`; this guide does not claim that organizational decision is complete.
2. Review the exact proposed scope, identity, backend, code and lock. Obtain approval for any new live inventory/permission/policy checks. Full inherited/effective IAM, current enabled APIs and actual default-network inventory have not been reviewed here; the effective skip-default-network policy and creation setting alone do not establish their final contents.
3. Use the direct-admin/default-provider and project-only impersonation design, default Terraform workspace and state locking. Verify source credentials and backend configuration before any approved initialization. Preserve the existing state/prefix; do not migrate, overwrite, import or adopt resources without separate approval.
4. A new no-change plan would be a separate live operation and has not been run after apply. The initial two-create criterion is historical; do not expect another creation plan for these existing resources. Future changes need their own expected actions and review. Stop for unexpected creates, replacements, deletes, IAM changes or state ownership ambiguity.
5. Obtain review and separate approval for any future saved-plan apply. Never reuse either plan from this creation session. Keep sensitive plans and operational output only in approved private ignored storage.

The live commands below are an execution template, **not authorized commands**. Use verified direct `smanley-adm@trekai.org` source credentials; the project provider handles its own impersonation. Do not set global `GOOGLE_IMPERSONATE_SERVICE_ACCOUNT` or cached backend impersonation: the folder/backend caller must remain the direct admin. The reviewed wrapper captures a direct admin token in memory, clears inherited Google/Cloud SDK/Terraform overrides, selects quota project `trekai-452018`, and passes credentials only to the Terraform child process with fresh private local metadata. Verify that path before future live use. Never print tokens or persist credentials in Terraform files, plans or backend configuration. Plain CLI use requires separately verified equivalent direct admin ADC and environment settings.

```bash
# Requires approval for backend initialization with the revised identity path.
terraform -chdir=terraform/organization/rd-dev init -lockfile=readonly

# Requires approval for this live plan and its private output location.
terraform -chdir=terraform/organization/rd-dev plan \
  -out="${APPROVED_PRIVATE_PLAN_PATH:?Set a fresh absolute private plan path}"

# Requires review and separate approval of this exact saved plan.
terraform -chdir=terraform/organization/rd-dev apply \
  "${APPROVED_PRIVATE_PLAN_PATH:?Set the reviewed absolute private plan path}"
```

## Verification and recovery

The approved creation verification confirmed folder/project IDs, names, parents, ACTIVE status, project labels and billing linkage. Actual default-network/API inventory, full inherited/effective access and other policy coverage remain unverified. No follow-up live no-change plan ran. Any such follow-up requires its own scoped approval; the state-bucket IAM review remains on hold outside the narrow execution-permission checks recorded here.

For future problems, preserve state and the created resources, stop and inspect through approved reads; do not automatically delete the folder/project or retry under broader credentials. A project ID can remain unavailable after deletion, so deletion is not an interchangeable rollback for creation. Any retry, billing unlink, resource deletion, state repair/import or ownership migration needs a separately reviewed scope and authorization.

## Change record

| Date | Authorization / scope / identity | Result and verification | Follow-up |
|---|---|---|---|
| 2026-11-13 | User requested local Terraform files for `trekai-rd-dev` / `prj-trekai-rd-dev`, supplied organization `470598084059`, and requested the billing lookup. Local agent only; no cloud execution identity selected or used. Separately approved local validation retry outside the sandbox after the cached provider could not start inside it. | Drafted one root, a distinct backend prefix, deletion guards, outputs and this guide. Copied the provider lock unchanged; formatting and backend-disabled init/validation passed with the cached pinned provider. No live resource, IAM, billing or state operation. | Confirm owners/reviewer, exclusive ownership, billing use, current access/availability/policies/default-network behavior, then separately authorize live checks and plan/apply. |
| 2026-11-13 | User individually approved source-account, organization, billing, name, default-network and limited state/backend checks; then backend init, saved plan and local filtered review. Admin-to-service-account path, quota project `trekai-452018`, existing state prefix, locking enabled. | Organization ACTIVE; billing open; no matching direct-child folder; project ID unresolved. Existing state serial 2 had zero resource entries and the expected project output. Saved plan: two creates, no updates/deletes; hash recorded above. | Exact-plan apply was separately approved; no independent human review claimed. |
| 2026-11-13 | User approved applying the exact saved plan. One guarded apply at 18:44:32–18:44:38 UTC, using the same identity/backend. | Exit 1: folder-create permission denied. No successful resource creation reported. Private log/receipt retained; no retry or IAM change. | Reconcile current state/live status and create a fresh plan after an approved correction; never reuse the failed-attempt plan. |
| 2026-11-13 | User approved service-account direct-role lookup and direct admin permission tests, then the local provider split and documentation updates. | Admin folder-create permission true; organization-level project-create false. Added `google.project_creator` impersonation alias and selected it only on the project. No resource address/state-prefix change, IAM grant or live retry. Revised local checks pending. | Approve local checks, direct admin backend/billing and combined provider-path verification, reconciliation, then new plan/review/apply one operation at a time. |
| 2026-11-13 | User separately approved revised formatting/validation, direct admin bucket permission test, post-failure reconciliation, backend init, fresh plan and local filtered review. | Local checks passed; all four bucket permissions returned; state serial 2 still had zero resources and expected output; no matching folder. Same backend initialized with direct admin source. Fresh plan: two creates/no updates/deletes, correct provider assignments; hash `e04adcb26e7fc7b6e2f659fe18a92fd4093218a4f10e540d1b75400a725de22f`. | Exact fresh-plan apply separately requested/approved; no independent human review claimed. |
| 2026-11-13 | User approved that exact fresh-plan apply once. Direct admin backend/folder; service-account project provider; quota `trekai-452018`, same state prefix and locking enabled. | Apply 19:02:26–19:03:18 UTC exited 0: **2 added, 0 changed, 0 destroyed**. Hash/backend/workspace/permissions guards passed. Private receipt/log retained. No separate IAM grant, migration, import, deletion or automatic retry. | Saved plan consumed; no reuse. Separate verification approved next. |
| 2026-11-13 | User approved live read-only project, parent-folder and billing verification, then final local documentation/comment updates and `git diff --check`. | Folder `561034768953` and project `prj-trekai-rd-dev` / `413711767398` ACTIVE; intended parent chain, labels and billing enabled on `018378-808B11-17982B` confirmed. Updated current status and retained initial failure history. | Accountable ownership confirmation, full inherited/effective IAM, actual network/API inventory and any no-change plan remain separate follow-ups; no standing authorization. |
