# QA desktop PAM

**Status: applied; configuration verified from user-provided live read-back, 2026-11-13.** Prepared for [DOKB-984](https://ethosinsights.atlassian.net/browse/DOKB-984). The user supplied a successful exact saved-plan apply result: **1 added, 0 changed, 0 destroyed**, creating `projects/qa-virtual-machine/locations/global/entitlements/pam-qa-desktop-web-user`. Their subsequent live describe output reports `AVAILABLE` and matches the access settings below. The agent reviewed the supplied output without independently rerunning the cloud read. No grant request, approval, desktop access or expiry test has been reported. Eligibility alone does not activate Harikaran's access.

The root is [`terraform/pam/qa-desktop/`](../../../terraform/pam/qa-desktop/). It defines one project-scoped entitlement, separate from the [RD folder root](rd.md), for temporary IAP browser access to the existing QA desktop. The folder module cannot express the project target and hostname condition, so this root declares the single resource directly. No existing resource changes address or state owner.

**Browser onboarding applied and activated, 2026-11-17:** the user-approved CAP
saved-plan apply added Harikaran's mapping to the VM startup payload and
preserved `n2-standard-4`. After authorized guest inspection, the user approved
the narrow account/configuration activation and gateway restart. His isolated
desktop account/home and lingering are provisioned, the guest configuration
matches source, and the restarted gateway passes its health check. The VM was
not rebooted and the broad bootstrap was not rerun. Harikaran's real browser
access, WebSocket session and expiry tests remain outstanding; these checks do
not substitute for his own active-PAM-grant test.

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

**2026-11-17 — guest inspected, narrow activation authorized and completed; requester test pending.**
The user authorized proceeding after the metadata apply. Guest inspection as
direct `smanley-adm@trekai.org` through IAP SSH found the gateway healthy with
the exact pre-onboarding map, no Harikaran account/group/home, root-owned
mode-0600 configuration and gateway/desktop code and service units matching
the reviewed source. No established gateway TCP connections were observed.
No guest configuration change was made during that inspection. A local source
parser guard initially stopped before connection; after correction, inspection
completed successfully.

The user then said "okay" and "proceed" after the narrow activation was
described: create the desktop account, enable lingering, add the guest mapping
and restart only `qa-desktop-gateway.service`. The prepared procedure passed
local syntax and mapping-preservation/fail-closed checks. Execution rechecked
target metadata identity, exact guest config hash, source-matching code/units,
healthy gateway and absence of account/group/home collisions. It held the
existing bootstrap lock during the change and preserved all existing mappings,
audience, origin and root-owned mode-0600 config permissions.

Activation succeeded: created `qa_harikaran` and its owned home/private group,
confirmed only its own group and no new administrator/operator group grant,
enabled lingering, atomically installed the source-matching mapping, and
restarted the gateway. All six postchecks passed: unprivileged account/home,
source-matching config, root/mode-0600 config, lingering, active gateway with a
new process and successful localhost `/healthz`. There were zero established
gateway connections at the activation check. No rollback was needed. No VM
reboot, full bootstrap, package install, PAM grant action or IAM role change
was performed. No independent human review is claimed.

Inspection and activation used separate temporary admin OS Login public keys
with 15-minute expiration requested; their temporary local private key files
were removed after each connection. These were operator authentication keys,
not new SSH access for Harikaran. No credentials, config contents, user lists or
application data were printed/logged; private structural summaries are under
`review/qa-desktop-harikaran-2026-11-17/execution/`. The next acceptance check is
Harikaran's own browser/desktop/WebSocket use with an active approved PAM grant,
followed by new-connection expiry behavior. No actual user-access success is
claimed yet.

**2026-11-17 — exact merged-main plan approved, applied and metadata verified; guest activation pending.**
After reviewing the mapping-only plan summary, the user explicitly said
"approved" to applying that exact saved plan. The guarded execution rechecked
clean `main` at `7aa063f548b84edf86104531342a4607cff3525e`, the approved SHA-256
`63fdffbc804450a3a1f036d6b69c53b70330db50b52273b1be4282c090cede58`, the existing
CAP backend/default workspace and direct `smanley-adm@trekai.org` identity.
Pre-apply live metadata matched the plan's starting payload; the target was
RUNNING as `n2-standard-4`. No impersonation was configured. Short-lived tokens
remained in process memory and state locking was retained.

The single saved-plan apply completed successfully with no diagnostics:
**0 added, 1 changed, 0 imported, 0 destroyed**. No IAM changes were included.
Independent direct read-back passed all four checks: expected running target
and `n2-standard-4`, startup metadata exactly matching the approved result,
Harikaran mapped to `qa_harikaran`, and unchanged last-start timestamp. Only
structural summaries were saved; no decoded state/plan, raw startup payload or
credential was printed or logged. The applied saved plan is consumed and must
not be reused; earlier plans remain superseded. No independent human review is
claimed; execution was under the user's exact-plan approval.

No guest command, desktop account/configuration inspection, reboot, gateway
restart or PAM grant action was performed. The next step is authorized guest
inspection and preparation of a narrow activation procedure, followed by the
approved account/configuration update and gateway restart. The existing broad
bootstrap must not be rerun without its own reviewed scope. Actual requester
desktop/WebSocket access and expiry tests remain outstanding.

**2026-11-17 — size correction merged; clean-main plan ready for exact-plan apply approval.**
The user reported the correction merged. Fast-forwarded the local CAP checkout
to clean `main` at `7aa063f548b84edf86104531342a4607cff3525e` (PR #71). Its only
change from the previous merge is the reviewed `n2-standard-4` correction;
`compute.tf` matches the previously validated file byte for byte, and formatting
checks passed for both changed HCL files. No commit, push or PR was performed
by the agent.

Created a fresh locked plan from that clean merged source as direct
`smanley-adm@trekai.org`, retaining quota project `trekai-452018`, the confirmed
CAP GCS backend and default workspace. The complete plan has no diagnostics:
**0 added, 1 changed in place, 0 destroyed**, no imports, output changes or IAM
changes. The only planned update is the target VM's startup metadata. In-memory
comparison again confirmed only Harikaran's mapping is added; all other startup
content is identical. Current and planned machine types are both
`n2-standard-4`.

The private saved plan is
`review/qa-desktop-harikaran-2026-11-17/execution/qa-desktop-harikaran-merged-main.tfplan`,
SHA-256 `63fdffbc804450a3a1f036d6b69c53b70330db50b52273b1be4282c090cede58`.
Earlier plans are superseded and must remain unused. This plan awaits explicit
approval to apply; no independent human review is claimed. No apply, guest
operation, reboot, gateway restart, PAM grant action or cloud configuration
change was performed. Guest activation and requester/expiry tests remain
separate follow-ups after the approved metadata apply.

**2026-11-17 — user confirmed preserving `n2-standard-4`; corrected draft and fresh plan, no apply.**
The user explicitly chose to retain the current VM size. Prepared one local
line changing `machine_type` from `n2-standard-2` to `n2-standard-4` in the CAP
root's `compute.tf`, on branch `fix/DOKB-984-preserve-qa-machine-size`, based on
merged commit `600926385acb424a67ae92d1fc0f0d642f852979`. The correction is
uncommitted; no push or PR was performed. Formatting, whitespace checks and
credential-free provider validation passed with zero errors/warnings. The
source guard confirmed this is the only change from the merged source.

A fresh locked plan as direct `smanley-adm@trekai.org`, with the same confirmed
CAP backend/default workspace and quota project, completed with no diagnostics:
**0 added, 1 changed in place, 0 destroyed**, no imports and no IAM changes.
The only planned change is `google_compute_instance.qa` startup metadata.
In-memory comparison confirmed current and planned machine type are both
`n2-standard-4`; the only startup-script difference is Harikaran's mapping,
with all existing mappings and other script content preserved. The machine-size
drift and IAM etag metadata remain observations, not planned changes.

The fresh private plan is at
`review/qa-desktop-harikaran-2026-11-17/execution/qa-desktop-harikaran-preserve-n2-standard-4.tfplan`,
SHA-256 `b594187e3d8485ca6ee9d6988cf3b2cddcccd00b00e9e58743b35576a0a44f84`.
The rejected resize plan remains unused and must not be applied. This fresh
plan is review evidence for the local correction, not an apply approval.
Next: user-created review/merge of the size correction, fresh verification and
plan against the merged source, explicit exact-plan apply approval, then
separately authorized guest activation and requester/expiry testing. No
independent human review is claimed. No apply, state import, guest operation,
gateway restart, PAM grant action or cloud configuration change was performed.

**2026-11-17 — merged browser onboarding change planned; unexpected VM resize, no apply.**
The user reported PR #70 merged and then authorized proceeding step by step
through the previously described identity/backend checks, initialization and
live plan. The local CAP checkout is clean on `main` at
`600926385acb424a67ae92d1fc0f0d642f852979`. Direct reads as
`smanley-adm@trekai.org`, with quota project `trekai-452018`, confirmed ACTIVE
project `qa-virtual-machine` (`276877441561`) under the documented RD folder,
the RUNNING target VM in `us-central1-a`, and the existing default-workspace
state object under `trekai-452015-org-cap-tfstate` /
`environments/rd/qa-workstation`. No impersonation was used.

Backend-disabled initialization installed HashiCorp-signed Google `5.45.2` and
Google Beta `7.36.0`, matching this CAP root's existing constraints; no source
constraints were changed. Credential-free local validation passed with zero
errors/warnings after the approved outside-sandbox provider retry. Live
initialization then confirmed the expected backend/default workspace, using a
short-lived admin token in process memory; no credential values were persisted
in backend configuration. The locked saved plan completed without diagnostics,
with no imports, additions or deletions and one in-place VM update.

In-memory inspection found the startup-script change adds only Harikaran's
email-to-`qa_harikaran` mapping, preserving existing users and the rest of the
script. However, the same update would resize the current `n2-standard-4` VM to
the source-configured `n2-standard-2`. Other reported drift was IAM etag metadata,
with no planned IAM changes. **The plan is not approved for apply:** preserve
the current VM until the user resolves the machine-size discrepancy. The
recommended next step is to confirm the larger size is intended, reconcile
Terraform source through review and create a fresh mapping-only plan. Do not
apply this saved plan for the browser-onboarding change.

The private saved plan is at local
`review/qa-desktop-harikaran-2026-11-17/execution/qa-desktop-harikaran.tfplan`,
SHA-256 `8aba1a33d84ab4fadf62f0f2753745a9d20c7863eaa8c3c45e39789d7c52f7bd`;
only a structural summary was retained alongside it. No independent human
review is claimed. No apply, state import, grant action, guest command, reboot,
gateway restart or cloud configuration change was performed. Guest activation,
actual requester access and expiry testing remain outstanding.

**2026-11-13 — workstation constraint clarified; browser mapping evidence found.** The user stated AIT normally accesses GCP through their own Cloud Workstations, then confirmed Harikaran has no GCP workstation. A targeted read of this VM's IAP tunnel policy as `smanley-adm@trekai.org` confirmed the contractor SSH group requires both port 22 and the `CloudWorkstationsQaSsh` access level. This cannot be treated as a laptop SSH grant. The staff group's port-22-only path is a different access boundary and was not granted to Harikaran. No firewall, access level, group, workstation or IAM change was made. The pending OS Admin Login request still needs its grant mechanism/duration and usable connection route resolved; adding that role alone does not satisfy these prerequisites.

The previously searched gateway code was found in the saved `tl-trekcap-terraform` snapshot, commit `28f2daa0754b3e91de485ccb651ecdbab0d35da3` (2026-11-02), under `environment/development/qa-workstation/`. Its `browser.tf` defines desktop email mappings, and `gateway/server.mjs` rejects email identities absent from that map with the exact displayed error. A separate read of current VM startup metadata decoded only the known gateway JSON/server payloads in memory, without executing them or saving/printing the full payloads: Aravind is mapped, Harikaran is absent, the embedded server checks that map and emits the reported error, and its hash matches the saved source server. This identifies a missing browser-onboarding entry in the configured startup payload; current guest files/processes were not inspected, so runtime drift remains possible. OS Admin Login does not add that browser mapping. The saved root also declares the VM, runtime service account, group-based SSH prerequisites and IAP tunnel policies in a separate CAP backend; refresh and verify current source/state ownership before proposing changes there. No external clone, guest configuration, browser mapping or live state was changed.

**2026-11-13 — OS Admin Login requested; read-only preparation, grant mechanism awaiting user choice.** The user requested the same OS Admin Login role for Harikaran as Aravind. The agent asked whether the new grant should follow the existing eight-hour PAM approval pattern or match Aravind's permanent VM-level binding, because these have different persistence. No answer or role change is recorded at this point. Targeted read-only checks as `smanley-adm@trekai.org` at `2026-11-13T17:48:46Z` confirmed VM `instance-20261030-190831` in `us-central1-a`, OS Login enabled, project SSH keys blocked, an attached `qa-workstation-runtime` service account, and an unconditional VM-level `roles/compute.osAdminLogin` binding for Aravind. No direct Harikaran OS Login binding was found in the inspected VM/project policies. A separate read of the attached service account confirmed direct `roles/iam.serviceAccountUser` for Aravind plus the existing SSH groups, with no direct Harikaran binding in that policy. The existing SSH groups have project Compute Viewer. Their membership remains unavailable, so these results do not establish Harikaran's effective access or absence of all inherited paths. Google's [OS Login setup guidance](https://docs.cloud.google.com/compute/docs/oslogin/set-up-oslogin), checked 2026-11-13, requires project-read permission for CLI login when the OS Login role is instance-scoped, Service Account User when a VM has a service account, and IAP tunnel permission if that route is used. These are separate prerequisites, not extra roles already authorized or granted. No guest command, SSH/key upload, Terraform live init/plan/apply, IAM change or PAM grant action ran during this preparation. The browser-access issue remains unresolved.

**2026-11-13 — Aravind comparison and targeted live diagnostics.** The user identified `contractor-ait-aravinds@trekai.org` as an existing user with desktop access (owner-reported comparison; not independently tested). A targeted grant list as `smanley-adm@trekai.org` confirmed one grant for `contractor-ait-harikarang@trekai.org` is `ACTIVE`, created at `2026-11-13T15:49:43.391985172Z`. Thus grant activation is not the observed blocker. Metadata reads identified the desktop entry service as Nginx, revision `cap-qa-desktop-00001-ch5`, with `qa-desktop-nginx-config` version `1` mounted at `/etc/nginx/conf.d/default.conf`. The user-approved diagnostic read inspected that config only in process memory and returned structural findings: neither named identity nor the reported error text was present. No full config, credential or secret payload was printed or saved. No matching error or named identity was found in the inspected VM startup-script metadata either; this does not inspect current guest files or prove where the error originates. Existing group memberships remain unreadable to the current identity. Correct browser identity, the exact working access route used by Aravind, and downstream desktop authentication remain to be confirmed. No SSH/guest command, configuration/IAM/group change or grant action was performed. Harikaran's desktop access remains unsuccessful based on the supplied screenshot, and no expiry test is claimed.

**2026-11-13 — first desktop access attempt unsuccessful, user-reported.** The user reported that the access request was approved and supplied a browser screenshot at the desktop `/vnc.html` URL showing “Authorized Google account required”. No grant resource/state or browser account identity accompanied the report. Approval-to-activation state, propagation, browser identity and whether the message originated in IAP or the desktop proxy/application remain unverified. An exact-text search of the existing local source clones did not locate this message or the service implementation. Configuration read-back remains valid evidence of settings only; successful desktop access and expiry are not established. Next diagnostic: inspect the specific grant's state/requester and retry in a browser session signed in only as the eligible human account, then investigate the application's auth configuration if the failure persists. No IAM, entitlement, application or grant change was made by the agent.

**2026-11-13 — configuration verified from user-provided live read-back.** The user supplied a successful `gcloud pam entitlements describe` result as `smanley-adm@trekai.org` directly, with quota project `trekai-452018`. The reported entitlement is `AVAILABLE` at the exact project/name. The reviewed output matches the sole human requester `user:contractor-ait-harikarang@trekai.org`, only `roles/iap.httpsResourceAccessor`, exact desktop-host equality condition, project resource/type, `global` location, `28800s`, one approval from either `smanley@trekai.org` or `pmossman@trekai.org`, mandatory requester justification and mandatory approver justification. No independent live read or independent human review is claimed. No request/approval/access/expiry result has been supplied; actual hostname enforcement, guest desktop login, WebSocket/session behavior, separate QA application access, permanent-group bypass paths and owner/end date remain unverified. Updated the local guide/index status only; no cloud, IAM, grant or Jira action was performed by the agent.

**2026-11-13 — saved-plan apply succeeded, user-executed and user-reported.** The user ran `qa_tf apply -input=false -lock-timeout=60s qa-desktop.tfplan` after reporting the plan. They supplied SHA-256 `cf0f4ddd2786e8f5ff950c559ae56dcd02c043f068b349a515b247f9bfe9ddbc` for that saved plan and an apply result of **1 added, 0 changed, 0 destroyed**, with entitlement ID `projects/qa-virtual-machine/locations/global/entitlements/pam-qa-desktop-web-user`; creation completed after 17 seconds. This follows the previously supplied helper selecting the Terraform service-account impersonation path and `pam/qa-desktop` backend; the agent did not execute apply, inspect the plan/state or independently verify the underlying ADC source. The saved plan is consumed and must not be reused. No independent human review is recorded or claimed. Live entitlement read-back, request/approval/desktop access/expiry, owner/end date and the remaining ownership/IAM checks are still outstanding. No grant request/approval or Jira update was performed by the agent.

**2026-11-13 — step 2 completed, user-reported; saved plan ready, no apply.** The user supplied terminal output for live GCS backend initialization using fresh `.terraform/live-review` metadata, workspace `default`, validation and planning. The supplied helper selected per-command `terraform-org-admin@trekai-452018.iam.gserviceaccount.com` impersonation for provider/backend and quota project `trekai-452018`; the underlying ADC source identity was not independently verified by the agent. Initialization reused provider `7.22.0` from the local mirror with a readonly lock. Reported plan: **1 create, 0 updates, 0 deletes**, only `google_privileged_access_manager_entitlement.qa_desktop_web_user`, targeting `qa-virtual-machine`, Harikaran's exact human account, `roles/iap.httpsResourceAccessor`, exact desktop-host equality condition, `28800s`, one approval from either confirmed approver and both required justifications. The plan was saved locally as `terraform/pam/qa-desktop/qa-desktop.tfplan` (ignored); its hash and contents were not read by the agent. The displayed proposal matches the requested settings. No independent human review or apply authorization is claimed, and no apply/grant result has been reported. The agent performed only this local documentation update. Owner/end date, PAM prerequisites, cross-state/authoritative-IAM review and real access/expiry remain unverified.

**2026-11-13 — step 1 preflight, user-reported.** The user supplied terminal results showing ADC quota project set to `trekai-452018`; project describe as `smanley-adm@trekai.org` confirmed active `qa-virtual-machine`, number `276877441561`, under folder `653186815477`. The proposed project entitlement describe returned `NOT_FOUND`. State-object metadata lookup, impersonating `terraform-org-admin@trekai-452018.iam.gserviceaccount.com` from that admin account, returned `404` for `devops-hq-bucket` / `pam/qa-desktop/default.tfstate`. Both absence results match a new entitlement/root. The agent did not independently rerun these reads. The supplied quota-project output does not independently establish the ADC source identity; cross-state ownership, authoritative IAM compatibility, PAM prerequisites and owner/end date remain unverified. No Terraform init/plan/apply result has been reported yet.

**2026-11-13 — local draft authorized and validated.** The user said “okay proceed with the change” after the proposed PAM settings and local Terraform draft were described, and explicitly confirmed either `smanley@trekai.org` or `pmossman@trekai.org` as approver. Prepared one project-scoped entitlement for Harikaran with the exact desktop-host condition, eight-hour maximum, one approval and both justifications. Added the dedicated root/state-prefix proposal and this guide. No deployment identity was used; no live init/plan/apply, cloud/IAM/group change, grant action, commit, push or Jira update was performed. Independent human review is not claimed. Formatting, backend-disabled initialization and credential-free validation passed as recorded above. Owner/end date, prerequisites, state ownership, actual condition behavior and access/expiry remain follow-ups.
