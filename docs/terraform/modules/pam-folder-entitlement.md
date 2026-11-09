# Folder PAM entitlement module

Creates one folder-scoped PAM entitlement granting the IAM roles the calling root supplies in `roles`. Folder access is inherited by descendant projects, including future projects. It always requires requester justification and one manual approval from the specified approver principals, with approver justification; callers cannot change these approval controls.

Renamed from `pam-folder-logs-viewer` on 2026-11-04, when the hardcoded `roles/logging.viewer` became the `roles` input. The deployed RD instance passes `roles/logging.viewer`; a second, proposed instance passes `roles/resourcemanager.folderAdmin` (local draft 2026-11-09; see the [RD guide](../pam/rd.md#proposed-folder-admin-access)). Logs Viewer does not automatically grant private Data Access logs or access to separate log destinations.

The module code is in [`terraform/modules/pam-folder-entitlement/`](../../../terraform/modules/pam-folder-entitlement/).

A calling root supplies a numeric folder ID, entitlement ID, one or more roles (`roles/...` or `organizations/<id>/roles/...`), maximum duration in seconds, eligible principals and approvers. The module derives both the entitlement parent and target from the same folder ID. See [the RD root](../../../terraform/pam/rd/) for a concrete, reviewable example. Principals are identity configuration, not credentials, but are confidential internal data.

## Naming entitlements

This summarizes the team-agreed [naming conventions](../../terraform-and-agents.md#layout-and-naming-conventions).

Name an entitlement after the access it grants, not the person who requests it: `pam-<scope>-<role>`, for example `pam-rd-folder-logs-viewer`. Add more people who need the same access to `eligible_principals` on the existing entitlement. Create a new entitlement only for a different role, folder, approver set or maximum duration. Entitlement IDs cannot be changed in place, so the existing `pam-rd-folder-logs-viewer-ait` keeps its contractor suffix as a known exception.

Grant the narrowest roles that meet the need. Review every new role, especially roles that can change IAM, read secrets or modify resources, with the approvers before adding it.

This module is deliberately narrow: it does not create an API, service agent, IAM grants for administrators, backend, credentials or a project-level entitlement. Validate effective access, existing policies and the folder scope independently. `prevent_destroy` protects the resource only while the lifecycle rule remains in configuration. Roots own state and provider locks; one resource must have one state owner.
