# Terraform guides

| Guide | Terraform files |
|---|---|
| [RD folder PAM](pam/rd.md) | [`terraform/pam/rd/`](../../terraform/pam/rd/); deployed Logs Viewer / Folder Admin; Monitoring/GKE viewer applied and live-verified 2026-11-13 |
| [QA desktop PAM](pam/qa-desktop.md) | [`terraform/pam/qa-desktop/`](../../terraform/pam/qa-desktop/); applied, `AVAILABLE` and settings verified from user-provided read-back 2026-11-13; access/expiry testing pending |
| [RD development Terraform-builder PAM](pam/rd-dev.md) | [`terraform/pam/rd-dev/`](../../terraform/pam/rd-dev/); IAP addition applied/verified 2026-11-16 16:57 UTC; AVAILABLE, seventeen roles, both users and all ten controls verified; grant/tunnel tests pending |
| [RD QA Terraform-builder PAM](pam/rd-qa.md) | [`terraform/pam/rd-qa/`](../../terraform/pam/rd-qa/); IAP addition applied/verified 2026-11-16 16:57 UTC; AVAILABLE, seventeen roles, both users and all ten controls verified; grant/tunnel tests pending |
| [State bucket bootstrap](bootstrap/state-bucket.md) | [`terraform/bootstrap/state-bucket/`](../../terraform/bootstrap/state-bucket/) |
| [Dedicated IAM-export bucket](storage/iam-export.md) | [`terraform/storage/iam-export/`](../../terraform/storage/iam-export/); bucket/reader applied 2026-11-06, export setup incomplete |
| [RD development environment-state bucket](storage/rd-dev-state.md) | [`terraform/storage/rd-dev-state/`](../../terraform/storage/rd-dev-state/); applied 2026-11-13; Storage API enabled and all fourteen bucket/status checks passed at 20:27 UTC |
| [RD development folder and project](organization/rd-dev.md) | [`terraform/organization/rd-dev/`](../../terraform/organization/rd-dev/); applied 2026-11-13: folder/project ACTIVE, parents and billing enabled verified |
| [RD QA folder and project](organization/rd-qa.md) | [`terraform/organization/rd-qa/`](../../terraform/organization/rd-qa/); applied 2026-11-16: two added/no changes/deletes; folder/project ACTIVE, parents, labels and billing verified at 14:36 UTC |
| [State bucket IAM review plan](bootstrap/state-bucket-iam.md) | Existing bucket and inherited project/folder/org IAM; review on hold |
| [Folder PAM entitlement module](modules/pam-folder-entitlement.md) | [`terraform/modules/pam-folder-entitlement/`](../../terraform/modules/pam-folder-entitlement/) |

New guides follow the [layout and naming conventions](../terraform-and-agents.md#layout-and-naming-conventions): mirror the Terraform path and add a row here.

See also the [Google Cloud and Terraform diagram](../google-cloud-diagram.md), [Terraform and agent working practices](../terraform-and-agents.md) and [tool versions](../../INSTALLS.md).
