# Folder Logs Viewer PAM module

Creates one folder-scoped PAM entitlement granting `roles/logging.viewer`. Folder access is inherited by descendant projects, including future projects. It requires requester justification and one manual approval from the specified approver principals, with approver justification. It does not automatically grant private Data Access logs or access to separate log destinations.

The module code is in [`terraform/modules/pam-folder-logs-viewer/`](../../../terraform/modules/pam-folder-logs-viewer/).

A calling root supplies a numeric folder ID, entitlement ID, maximum duration in seconds, eligible principals and approvers. The module derives both the entitlement parent and target from the same folder ID. See [the RD root](../../../terraform/PAM/rd/) for a concrete, reviewable example. Principals are identity configuration, not credentials, but are confidential internal data.

This module is deliberately narrow: it does not create an API, service agent, IAM grants for administrators, backend, credentials or a project-level entitlement. Validate effective access, existing policies and the folder scope independently. `prevent_destroy` protects the resource only while the lifecycle rule remains in configuration. Roots own state and provider locks; one resource must have one state owner.
