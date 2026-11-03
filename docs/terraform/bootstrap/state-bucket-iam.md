# State bucket IAM: review and implementation plan

**Status: on hold, 2026-11-03.** This is a plan, not a completed IAM review. No IAM permissions or policies were changed by creating this guide. Resume inspection or implementation only when specifically authorized.

## Scope and what is known

- Bucket: `gs://devops-hq-bucket`; project: `smanley-experimental`; parent folder: `1045034779579`; organization: `trekai.org`.
- Bootstrap state is in `bootstrap/state-bucket`; RD PAM state is in `pam/rd-folder`. Both are in **the same bucket**. A prefix is an organizational path, not automatically a security boundary; don't assume different prefixes isolate access.
- Bucket creation used `smanley-adm` impersonating `terraform-org-admin`. The bucket was verified with uniform bucket-level access, public access prevention and object versioning on 2026-11-03. Effective inherited IAM, identity ownership and backup access were not verified. [Bootstrap guide](state-bucket.md).
- Terraform state is sensitive. Anyone who can read state may learn confidential configuration; anyone who can write or delete state can affect Terraform operations. Protect state, plans, logs and policy exports. Never print or share state contents or credentials.

## 1. Establish ownership and access requirements

Before querying or changing IAM, document the accountable resource owner, independent change reviewer, authorized Terraform operators, any CI service account, backup/recovery owner, required environments, and how onboarding/offboarding and emergency access work. Record who actually needs state **read**, state **write**, bucket configuration administration, and IAM administration. Do not assume the requester, PAM approver, repository reader or `smanley` daily account needs state access.

Verify whether bootstrap and PAM need different people or trust boundaries. If yes, assess **separate buckets** or tested managed-folder/IAM design; different plain prefixes alone do not guarantee isolation. Google notes `storage.objects.list` is a bucket-level permission and cannot be restricted to a subset with the `resource.name` condition. [Cloud Storage IAM](https://docs.cloud.google.com/storage/docs/access-control/iam).

## 2. Inspect current access — read-only, after authorization

Use an approved identity. The initial administrative operations used `smanley-adm` impersonating the highly privileged `terraform-org-admin`; prefer a suitably scoped read-only identity where possible. Check identity and ADC separately, and do not change the default account or print access tokens. Run these commands only within the approved inspection scope:

```bash
# Bucket-level allow policy only; does not include inherited project or folder roles.
gcloud storage buckets get-iam-policy gs://devops-hq-bucket

# Parent-level policies that may grant access to the bucket.
gcloud projects get-iam-policy smanley-experimental
gcloud resource-manager folders get-iam-policy 1045034779579
gcloud organizations get-iam-policy 470598084059

# Bucket configuration metadata; do not read state object contents.
gcloud storage buckets describe gs://devops-hq-bucket
```

For an explicitly approved read-only operation that requires the existing admin service account, add `--impersonate-service-account=terraform-org-admin@trekai-452018.iam.gserviceaccount.com` to each `gcloud` command. Do not set it as the permanent default; use the narrower identity if available. Policy output includes internal identities and must not be pasted into tickets or external tools. `get-iam-policy` gives direct allow bindings at that resource, not a complete effective-access answer. Inspect project, parent folder and organization inheritance; identify group membership, conditions, deny policies, principal access boundaries and service-account impersonation paths. Use authorized [Policy Analyzer](https://docs.cloud.google.com/policy-intelligence/docs/analyze-iam-policies) or [effective IAM policy analysis](https://docs.cloud.google.com/asset-inventory/docs/view-effective-policies) where available. Lack of permission to expand groups or see inherited policy is an **unknown**, not proof of no access. [Inheritance requirements](https://docs.cloud.google.com/iam/docs/resource-hierarchy-access-control).

Make a restricted access matrix without raw policy exports: principal or group, access source (bucket/project/folder/org), role or permissions, condition/expiry, purpose, confirmed owner and proposed action. Check whether any inherited access is broader than intended, but don't remove inherited administrative access without assessing its wider impact.

## 3. Design a least-privilege target

- **Terraform executor:** Choose an explicitly approved service account or human execution identity. It needs the state-object permissions required by the GCS backend, including lock operations; test against the actual workflow. HashiCorp documents `roles/storage.objectAdmin` on the bucket as an option. That role includes object deletion and is broad: consider a tested custom role if a narrower set is required. State access does not itself grant permission to create PAM or other Google Cloud resources. [Terraform GCS backend](https://developer.hashicorp.com/terraform/language/backend/gcs).
- **Read-only inspection:** Grant state read access only when there is a real need; even read-only state access exposes sensitive infrastructure metadata. A Terraform plan may also need locking and should not be assumed to work with only object-viewer permissions.
- **Bucket and IAM administration:** Separate bucket configuration/IAM administrators from routine Terraform execution where practical. Identify a backup administrator and a documented recovery path; avoid removing the only functioning access path.
- **Human and CI authentication:** Keep daily and administrative accounts separate. Prefer short-lived credentials, service-account impersonation or approved CI Workload Identity Federation, rather than exported service-account keys. Scope impersonation and state access separately. [Account and agent guide](../../terraform-and-agents.md#google-cloud-accounts-and-impersonation).
- **Recovery and retention:** Verify object versioning, soft-delete/retention settings, lifecycle costs and recovery procedures. Avoid adding bucket retention locks that prevent Terraform from replacing state or releasing lock objects; locking a retention policy can be irreversible. [Bucket Lock](https://docs.cloud.google.com/storage/docs/bucket-lock).

Specify the actual named principals, roles, scope and approver only after the access matrix and owner decisions. `terraform-org-admin` is currently a highly privileged bootstrap identity, not an approved long-term least-privilege design.

## 4. Review and implement — only after authorization

1. Confirm the authoritative Terraform state and owner for bucket IAM, project IAM and folder/organization IAM. A new repository or state must not duplicate ownership of an existing binding.
2. Draft the smallest reviewed change, including each member, role, resource, condition, expected effective access and a recovery path. Prefer non-authoritative member-level Terraform resources where appropriate. Whole-policy or role-authoritative resources can overwrite other access or interfere with PAM-managed bindings; inspect the actual code first. [Google PAM IAM guidance](https://docs.cloud.google.com/iam/docs/pam-overview).
3. Obtain independent review and explicit authorization for the exact live plan and any apply. Do not perform access removals, policy replacement or service-account impersonation changes based on this document alone.
4. Review the plan for unintended changes, especially inherited-policy changes, loss of state access and replacement/deletion. Preserve a verified emergency path; stop for unexpected changes or uncertain ownership.
5. Apply only the approved plan, using the agreed execution identity. Record authorizer, actor, date, scope, policy-change reference and results in the task/change log without copying raw IAM output or state.

## 5. Verify and close

- Re-check direct and inherited policies, group membership/conditions, denies and effective permissions with appropriately scoped read-only checks. Record visibility gaps rather than concluding access is absent.
- With explicit test authorization, verify that the designated executor can initialize, lock, read and update its **approved** state; check an intended non-authorized identity cannot access state where feasible. Avoid destructive tests against production state or arbitrary force-unlocks.
- Verify the backup administrator/recovery process and a safe version recovery procedure without overwriting live state. Confirm no unexpected public access and that object versioning/soft-delete controls remain appropriate.
- Record the outcome, owners, next review date, any unresolved access and the approved IAM implementation/PR reference. If an issue is identified, follow the owning review's evidence and risk-register process; don't mark it resolved without verification.

## Decisions still open

- Who owns the bucket and who is the independent backup administrator?
- Which human, service account and CI identities need read/write state access, and for which roots?
- Is one shared bucket acceptable for bootstrap and PAM, or are separate security boundaries required?
- How should IAM itself be managed, reviewed and tested without disrupting current Terraform state access?
