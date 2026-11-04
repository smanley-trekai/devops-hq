# Terraform state bucket bootstrap

**Status: bootstrap completed 2026-11-03.** Terraform created `devops-hq-bucket` in `smanley-experimental` using temporary local state, then migrated bootstrap state to `gs://devops-hq-bucket/bootstrap/state-bucket/`. A follow-up plan reported no changes. The PAM root uses a separate state prefix and has been applied; end-to-end access testing remains outstanding.

The Terraform root for this guide is [`terraform/bootstrap/state-bucket/`](../../../terraform/bootstrap/state-bucket/).

For the pending access work, see the [state bucket IAM review plan](state-bucket-iam.md).

## Configuration

- Terraform `1.17.1`, Google provider `7.22.0`; [installation and version policy](../../../INSTALLS.md).
- Inputs: `project_id` and `bucket_name` are required; `location` defaults to `us-central1`, subject to verifying effective org policy.
- Bucket: uniform bucket-level access, public access prevention, object versioning, `force_destroy = false`, and `prevent_destroy` while the lifecycle block remains present. Existing project/organization inherited permissions still apply; this does not itself configure least-privilege IAM or prevent all access. It does not set a bucket retention policy that could interfere with state locking; review soft-delete and retention behavior separately.
- This root now uses the GCS backend with bucket `devops-hq-bucket` and prefix `bootstrap/state-bucket`. The initial local bootstrap was a one-time procedure. Effective inherited IAM, backup owner and recovery procedures still need review.

## Historical bootstrap and migration sequence

The bucket was created and state migrated on 2026-11-03. The sequence below records the completed bootstrap process and remaining follow-up; do not repeat the creation or migration steps for the existing state. Effective IAM and recovery checks remain open.

1. Confirm `smanley-experimental` exists in folder `1045034779579`, billing is enabled via an explicitly chosen account, the bucket name is available, and the administrator/approved execution identity has the required permissions. Select a backup owner and restricted state access; do not assume the caller's identity is the Terraform ADC identity.
2. Work on a trusted machine with the pinned versions, a protected working directory and approved credentials. Never print or commit state, credential files or saved plans. Run offline `terraform fmt -check` and backend-disabled `terraform init` / `terraform validate` first.
3. With authorization, create a reviewed **local-backend** Terraform plan using the approved project and bucket name. Inspect every planned change, then apply the reviewed plan. The resulting `terraform.tfstate` is local and sensitive; `.gitignore` excludes it, but protect filesystem permissions and backups independently.
4. Verify the bucket, project, location, public access prevention, uniform access, versioning, effective IAM and ability to recover the state. Don't publish state or secrets. Confirm any lifecycle/soft-delete policies and implications for costs and locks.
5. Prepare and review a change adding a `backend "gcs"` block to this root with the approved bucket and a unique bootstrap prefix, such as `bootstrap/state-bucket`. Use standard ADC or approved impersonation; **never put credentials in backend settings**. After specific authorization and a secure recovery backup, run the Terraform backend migration and verify its reported success and remote state identity without displaying state. Follow [HashiCorp backend migration guidance](https://developer.hashicorp.com/terraform/cli/commands/init) and [Google's state tutorial](https://docs.cloud.google.com/docs/terraform/resource-management/store-state).
6. Securely handle any leftover local state and backup files according to the organization's retention and recovery policy after verifying migration. Do not blindly delete the only recovery copy. Never commit them.
7. The PAM root now uses its **own** `pam/rd-folder` prefix. Do not use the bootstrap root's state or import the old project entitlement into the folder root.

## Important limitations

The initial local backend was a bootstrap exception. Bucket creation alone does not establish least-privilege IAM, approved backup access, a CI identity or an active PAM entitlement. `prevent_destroy` does not protect a resource if the lifecycle block is removed from configuration. Bucket naming, inherited IAM, billing, location policies, identity and live service-agent permissions must be verified before use.

## Current operation

The bucket and state were verified on 2026-11-03. The bootstrap root still requires `project_id=smanley-experimental` and `bucket_name=devops-hq-bucket` inputs for a future plan; a backend is not the same as provider inputs. Use the approved execution identity and normal review process for any future live plan or change. Do not run migration again against an existing state. A restricted local recovery backup exists outside this repository; agree a retention and secure disposal procedure before removing it.
