# Tools and version policy

This file is the proposed baseline for local development and future CI. Versions are deliberately reviewed and changed together; do not automatically upgrade during unrelated work. Last reviewed 2026-11-03.

## Required for the current Terraform roots

| Tool | Version | Enforcement / purpose |
|---|---|---|
| Terraform CLI | **1.17.1** | Exact `required_version` in the PAM, bootstrap and IAM-export storage `versions.tf` files. Root `.terraform-version` is a version-manager hint; it does not install or enforce a version by itself. |
| Google Terraform provider | **7.22.0** | Exact provider constraint and per-root `.terraform.lock.hcl` files. Terraform installs the provider; it is not a separate CLI installation. |
| Git | **2.54.0** observed on the initial macOS workstation | Working baseline only, not enforced; select and pin a team/CI version when CI is designed. |
| Google Cloud CLI (`gcloud`) | **591.0.0** observed on the initial workstation | Baseline for authenticated cloud operations and troubleshooting; not enforced and not required for offline `fmt` / `validate`. Pin the CI image/tool version once a runner and deployment workflow are approved. |

The provider lock contains signed registry checksums for `darwin_arm64` and `linux_amd64`. Review platform coverage before introducing other operating systems. Never commit `.terraform/`, state, credentials, or saved plan files. Terraform provider lock files **are** committed: each root owns its own `.terraform.lock.hcl`. The lock file doesn't pin Terraform CLI or remote modules; pin module versions or immutable Git commits explicitly. [HashiCorp dependency locking](https://developer.hashicorp.com/terraform/language/files/dependency-lock).

## Install and check

1. Install Terraform **1.17.1** from [HashiCorp's official distribution](https://developer.hashicorp.com/terraform/install), using your organization's approved version manager or verified release. If using a version manager, select the root `.terraform-version`; don't assume every tool reads it. The exact Terraform configuration constraint rejects a different CLI version.
2. Install [Git](https://git-scm.com/install/) through an approved channel. Install the [Google Cloud CLI](https://docs.cloud.google.com/sdk/docs/install) only when you need an approved Google Cloud operation. Use a separately authenticated human account or approved federation/impersonation; never put credentials in this repo.
3. Check versions with `terraform version`, `git --version`, and `gcloud --version` (if installed). Compare Terraform against `.terraform-version` and the root's `required_version`; compare the provider constraint with that root's lock file.
4. For local syntax validation, run `terraform fmt -check -recursive` from the repo root. In the applicable root, `terraform init -backend=false -lockfile=readonly` followed by `terraform validate` checks configuration without configuring the remote backend, but may download provider plugins and executes them locally. Use trusted providers and the approved network policy. These checks do not test live resources, IAM or state.

The deployed roots are `terraform/pam/rd`, `terraform/bootstrap/state-bucket` and `terraform/storage/iam-export`. The IAM-export bucket/reader apply completed on 2026-11-06 using the same pinned Terraform/provider versions; actual IAM export remains outstanding. CI runners, Terraform lint/security scanners, GitHub CLI and any version manager are **not yet required or pinned**. Before adopting any, record its exact version, trusted source, execution permissions, supported platforms and how it is upgraded; avoid inventing pins for tools that are not in use.

## Version upgrades

- Change `.terraform-version` and each affected root's `required_version` together. Verify formatting and backend-disabled validation using the candidate CLI. Propose CLI upgrades in a dedicated reviewed change; roll out the same version to CI and developers.
- Change each affected provider constraint and regenerate that root's lock file from trusted, signed releases; inspect version and checksum changes in review. Include all actual supported CI/developer platforms. Do not run `terraform init -upgrade` as a routine setup step. [Provider lock guidance](https://developer.hashicorp.com/terraform/cli/commands/providers/lock).
- Pin remote modules by exact published version or immutable commit. Review their sources as code; provider lock files do not lock them.
- For `gcloud`, Git, optional tools and CI images/actions, establish exact approved versions or immutable digests once selected; update this inventory with upgrade/testing dates. Prefer official installation sources and verify release provenance.
- Treat version constraints as compatibility controls, not proof a release is free of vulnerabilities. Review release notes and security advisories during upgrades.
