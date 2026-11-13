# QA desktop PAM

**Status: applied; configuration verified from user-provided live read-back, 2026-11-13.** Prepared for [DOKB-984](https://ethosinsights.atlassian.net/browse/DOKB-984). The user supplied a successful exact saved-plan apply result: **1 added, 0 changed, 0 destroyed**, creating `projects/qa-virtual-machine/locations/global/entitlements/pam-qa-desktop-web-user`. Their subsequent live describe output reports `AVAILABLE` and matches the access settings below. The agent reviewed the supplied output without independently rerunning the cloud read. No grant request, approval, desktop access or expiry test has been reported. Eligibility alone does not activate Harikaran's access.

The root is [`terraform/pam/qa-desktop/`](../../../terraform/pam/qa-desktop/). It defines one project-scoped entitlement, separate from the [RD folder root](rd.md), for temporary IAP browser access to the existing QA desktop. The folder module cannot express the project target and hostname condition, so this root declares the single resource directly. No existing resource changes address or state owner.

## Configured access (user-provided live read-back, 2026-11-13)

| Setting | Value |
|---|---|
| Entitlement | `pam-qa-desktop-web-user` |
| Project | `qa-virtual-machine`, number `276877441561` |
| Project parent | `trekai-rd`, folder `653186815477` |
| IAP-protected Cloud Run service | `cap-qa-desktop`, `us-central1` |
| Desktop URL | `https://cap-qa-desktop-ywrfwy7rba-uc.a.run.app/vnc.html` |
| Eligible requester | `user:contractor-ait-harikarang@trekai.org` |
| Role | `roles/iap.httpsResourceAccessor` (IAP-Secured Web App User) |
| Additional IAM condition | `request.host == "cap-qa-desktop-ywrfwy7rba-uc.a.run.app"` |
| Maximum grant duration | `28800s` (eight hours); shorter requests allowed |
| Approval | One approval from either `smanley@trekai.org` or `pmossman@trekai.org` |
| Justifications | Required from requester and approver |
| Terraform address | `google_privileged_access_manager_entitlement.qa_desktop_web_user` |
| State | GCS `devops-hq-bucket`, prefix `pam/qa-desktop`, workspace `default`; user-reported initialization/apply |
| Entitlement owner / eligibility end date | Unconfirmed; outstanding owner follow-up |

Project-level IAP access ordinarily covers every IAP-protected application in the project. The additional hostname condition is intended to restrict this grant to the desktop hostname and allow the page's supporting HTTP/WebSocket paths. PAM supplies the grant's time restriction. Local Terraform validation does not verify CEL behavior, IAP authorization, desktop login, WebSocket reconnection or session expiry. Test these before accepting the access path as working.

This grants entry through IAP, not OS Login, SSH, VM administration, group membership, or an application account at `qa.trekfinder.org`. Separate desktop credentials or application-level controls, if present, remain to be checked. Existing access from other policies or groups is not revoked by PAM; avoid a parallel permanent access path if the requirement is approval-gated access.

## Evidence and implementation references

Targeted live reads on **2026-11-13**, as `smanley-adm@trekai.org` directly, confirmed the project number and RD parent, the desktop URL and enabled IAP, and the existing service-level IAP group grant. The account could not read the existing web/SSH groups' memberships, so Harikaran's membership and overall effective access remain unknown. These reads did not inspect desktop passwords, application data or guest OS configuration. Raw policies and membership lists are not copied here.

- [Google PAM entitlement guidance](https://docs.cloud.google.com/iam/docs/pam-create-entitlements): project targets, conditional role bindings and approval configuration.
- [IAP access hierarchy](https://docs.cloud.google.com/iap/docs/managing-access): project grants apply to all IAP-secured resources in that project.
- [IAP hostname conditions](https://docs.cloud.google.com/iap/docs/cloud-iap-context-aware-access-howto#use-hostname-and-path-conditions): exact hostname matching using `request.host`.
- [Google provider 7.22.0 resource reference](https://github.com/hashicorp/terraform-provider-google/blob/v7.22.0/website/docs/r/privileged_access_manager_entitlement.html.markdown): project target and `role_bindings.condition_expression` schema. Reviewed 2026-11-13.

## Local verification

Use Terraform **1.17.1** and the existing trusted `hashicorp/google` **7.22.0** package. This root's lock file is an unchanged copy of the RD root's existing lock for those exact provider constraints; no checksums are hand-edited. Local initialization must use fresh metadata, a disabled backend and the readonly lock file. The cached provider mirror avoids registry downloads:

```bash
cd terraform/pam/qa-desktop
TF_DATA_DIR=.terraform/local-check CHECKPOINT_DISABLE=1 \
  terraform init -backend=false -input=false -lockfile=readonly \
  -plugin-dir=../rd/.terraform/providers
TF_DATA_DIR=.terraform/local-check CHECKPOINT_DISABLE=1 terraform validate
```

Use an approved credential-free validation environment and no inherited Terraform CLI argument overrides. These commands are for local configuration checks only. The provider mirror must be trusted and match the lock. Do not substitute a live init or plan if a local check fails.

**Completed 2026-11-13:** repository-wide `terraform fmt -check -recursive` passed. Fresh backend-disabled init with `-lockfile=readonly` and the existing local provider mirror passed; the provider was checked against the copied lock, without a new registry download/signature verification. The initial sandboxed validation failed at the local provider handshake. An explicitly approved retry outside the sandbox passed (`Success! The configuration is valid.`), using a sanitized environment without inherited cloud credentials, Terraform argument overrides or a live backend. The source and copied lock remained unchanged. No state file or saved plan was created. These checks establish configuration/schema validity only.

## Deployment and access verification

The workflow below separates planning, apply and access verification. User-reported progress is recorded in the change record; remaining stages still require their applicable authorization/review.

1. Confirm the entitlement owner/end date, target identity, project ID/number, active RD parent, quota project and access scope. Review the exact hostname condition and current IAP configuration. Check whether PAM APIs/service-agent permissions are already set up; any missing API, identity or IAM setup needs its own reviewed scope. This draft creates none of those prerequisites.
2. Confirm the proposed entitlement name is unused, the new backend prefix has no conflicting state owner, and no other state owns the entitlement. Review project/ancestor authoritative IAM resources for possible conflict with PAM-managed bindings. The prior IAM lookup does not establish Terraform ownership.
3. Obtain the required human review and explicit live-plan authorization. Confirm the execution identity and the exact GCS bucket/prefix/default workspace. Do not infer plan/apply authority from the local-draft approval. Stop if initialization asks to migrate state. Never disable locking.
4. From the root, under that approved credential environment, run `terraform init -input=false -lockfile=readonly`, then `terraform plan -input=false -lock-timeout=60s -detailed-exitcode -out=qa-desktop.tfplan`. Keep the plan private and ignored. Review the exact saved plan; the expected change is **one entitlement create**, with no other managed resource changes. Stop for any unexpected scope or IAM change. Record the plan hash, identity, backend and review decision.
5. After separate authorization to apply the exact reviewed saved plan, run `terraform apply -input=false -lock-timeout=60s qa-desktop.tfplan` in the same root/environment. Record the result and read back the entitlement settings using an approved read-only identity. Do not request or approve a grant on Harikaran's behalf.
6. Harikaran signs in with his own account, selects project `qa-virtual-machine` in PAM, requests `pam-qa-desktop-web-user` for the required duration with DOKB-984 and a real justification, and waits for approval from either named approver. After the grant reaches `ACTIVE`, he opens the desktop URL under the same human identity.
7. Test denial before activation, successful IAP entry/desktop use while active, denial for another hostname if available, and new connection denial after expiry/revocation. Check existing sessions separately: do not assume expiry terminates every open desktop/WebSocket session immediately. Record propagation delays, audit evidence and any separate desktop login requirement. Verify the QA application separately for DOKB-984.

For an access problem, the immediate containment path is an authorized PAM grant revocation and confirmation that new connections are denied. Entitlement removal is a separate reviewed change; `prevent_destroy` must be deliberately addressed and does not protect a resource after its configuration is removed. Never hand-edit state. Retain the existing IAP service-agent invocation path and permanent group policies unless separately authorized to change them.

## Change record

**2026-11-13 — configuration verified from user-provided live read-back.** The user supplied a successful `gcloud pam entitlements describe` result as `smanley-adm@trekai.org` directly, with quota project `trekai-452018`. The reported entitlement is `AVAILABLE` at the exact project/name. The reviewed output matches the sole human requester `user:contractor-ait-harikarang@trekai.org`, only `roles/iap.httpsResourceAccessor`, exact desktop-host equality condition, project resource/type, `global` location, `28800s`, one approval from either `smanley@trekai.org` or `pmossman@trekai.org`, mandatory requester justification and mandatory approver justification. No independent live read or independent human review is claimed. No request/approval/access/expiry result has been supplied; actual hostname enforcement, guest desktop login, WebSocket/session behavior, separate QA application access, permanent-group bypass paths and owner/end date remain unverified. Updated the local guide/index status only; no cloud, IAM, grant or Jira action was performed by the agent.

**2026-11-13 — saved-plan apply succeeded, user-executed and user-reported.** The user ran `qa_tf apply -input=false -lock-timeout=60s qa-desktop.tfplan` after reporting the plan. They supplied SHA-256 `cf0f4ddd2786e8f5ff950c559ae56dcd02c043f068b349a515b247f9bfe9ddbc` for that saved plan and an apply result of **1 added, 0 changed, 0 destroyed**, with entitlement ID `projects/qa-virtual-machine/locations/global/entitlements/pam-qa-desktop-web-user`; creation completed after 17 seconds. This follows the previously supplied helper selecting the Terraform service-account impersonation path and `pam/qa-desktop` backend; the agent did not execute apply, inspect the plan/state or independently verify the underlying ADC source. The saved plan is consumed and must not be reused. No independent human review is recorded or claimed. Live entitlement read-back, request/approval/desktop access/expiry, owner/end date and the remaining ownership/IAM checks are still outstanding. No grant request/approval or Jira update was performed by the agent.

**2026-11-13 — step 2 completed, user-reported; saved plan ready, no apply.** The user supplied terminal output for live GCS backend initialization using fresh `.terraform/live-review` metadata, workspace `default`, validation and planning. The supplied helper selected per-command `terraform-org-admin@trekai-452018.iam.gserviceaccount.com` impersonation for provider/backend and quota project `trekai-452018`; the underlying ADC source identity was not independently verified by the agent. Initialization reused provider `7.22.0` from the local mirror with a readonly lock. Reported plan: **1 create, 0 updates, 0 deletes**, only `google_privileged_access_manager_entitlement.qa_desktop_web_user`, targeting `qa-virtual-machine`, Harikaran's exact human account, `roles/iap.httpsResourceAccessor`, exact desktop-host equality condition, `28800s`, one approval from either confirmed approver and both required justifications. The plan was saved locally as `terraform/pam/qa-desktop/qa-desktop.tfplan` (ignored); its hash and contents were not read by the agent. The displayed proposal matches the requested settings. No independent human review or apply authorization is claimed, and no apply/grant result has been reported. The agent performed only this local documentation update. Owner/end date, PAM prerequisites, cross-state/authoritative-IAM review and real access/expiry remain unverified.

**2026-11-13 — step 1 preflight, user-reported.** The user supplied terminal results showing ADC quota project set to `trekai-452018`; project describe as `smanley-adm@trekai.org` confirmed active `qa-virtual-machine`, number `276877441561`, under folder `653186815477`. The proposed project entitlement describe returned `NOT_FOUND`. State-object metadata lookup, impersonating `terraform-org-admin@trekai-452018.iam.gserviceaccount.com` from that admin account, returned `404` for `devops-hq-bucket` / `pam/qa-desktop/default.tfstate`. Both absence results match a new entitlement/root. The agent did not independently rerun these reads. The supplied quota-project output does not independently establish the ADC source identity; cross-state ownership, authoritative IAM compatibility, PAM prerequisites and owner/end date remain unverified. No Terraform init/plan/apply result has been reported yet.

**2026-11-13 — local draft authorized and validated.** The user said “okay proceed with the change” after the proposed PAM settings and local Terraform draft were described, and explicitly confirmed either `smanley@trekai.org` or `pmossman@trekai.org` as approver. Prepared one project-scoped entitlement for Harikaran with the exact desktop-host condition, eight-hour maximum, one approval and both justifications. Added the dedicated root/state-prefix proposal and this guide. No deployment identity was used; no live init/plan/apply, cloud/IAM/group change, grant action, commit, push or Jira update was performed. Independent human review is not claimed. Formatting, backend-disabled initialization and credential-free validation passed as recorded above. Owner/end date, prerequisites, state ownership, actual condition behavior and access/expiry remain follow-ups.
