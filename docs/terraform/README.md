# Terraform guides

| Guide | Terraform files |
|---|---|
| [RD folder PAM](pam/rd.md) | [`terraform/pam/rd/`](../../terraform/pam/rd/); deployed Logs Viewer / Folder Admin; Monitoring/GKE viewer applied and live-verified 2026-11-13 |
| [QA desktop PAM](pam/qa-desktop.md) | [`terraform/pam/qa-desktop/`](../../terraform/pam/qa-desktop/); applied, `AVAILABLE` and settings verified from user-provided read-back 2026-11-13; access/expiry testing pending |
| [State bucket bootstrap](bootstrap/state-bucket.md) | [`terraform/bootstrap/state-bucket/`](../../terraform/bootstrap/state-bucket/) |
| [Dedicated IAM-export bucket](storage/iam-export.md) | [`terraform/storage/iam-export/`](../../terraform/storage/iam-export/); bucket/reader applied 2026-11-06, export setup incomplete |
| [RD development folder and project](organization/rd-dev.md) | [`terraform/organization/rd-dev/`](../../terraform/organization/rd-dev/); applied 2026-11-13: folder/project ACTIVE, parents and billing enabled verified |
| [State bucket IAM review plan](bootstrap/state-bucket-iam.md) | Existing bucket and inherited project/folder/org IAM; review on hold |
| [Folder PAM entitlement module](modules/pam-folder-entitlement.md) | [`terraform/modules/pam-folder-entitlement/`](../../terraform/modules/pam-folder-entitlement/) |

New guides follow the [layout and naming conventions](../terraform-and-agents.md#layout-and-naming-conventions): mirror the Terraform path and add a row here.

See also the [Google Cloud and Terraform diagram](../google-cloud-diagram.md), [Terraform and agent working practices](../terraform-and-agents.md) and [tool versions](../../INSTALLS.md).
