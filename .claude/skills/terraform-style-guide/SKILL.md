---
name: terraform-style-guide
description: HashiCorp Terraform style conventions (formatting, naming, file layout, variables, outputs, for_each vs count, security defaults). Use when writing, generating or reviewing Terraform HCL in this repo, such as a new root, new resource or variable, or a style/consistency review. Not for moving resources between addresses or modules; use refactor-module for that.
metadata:
  upstream: https://github.com/hashicorp/agent-skills/tree/5e30fa5c867ba6777c37e4206babfd08049c396f/plugins/terraform/skills/terraform-style-guide
  license: MPL-2.0 (see LICENSE). Modified by DevOps HQ; see SOURCE.md.
---

## DevOps HQ overrides (read first; these win over the upstream text below)

`AGENTS.md` and `docs/terraform-and-agents.md` take precedence over this skill. The upstream guide is generic and AWS-flavored; apply it with these repository conventions:

- **Versions:** roots pin exact versions (`required_version = "= x.y.z"`, provider `version = "= x.y.z"`) from `INSTALLS.md`; reusable modules declare minimums (`>=`). Do not apply the upstream "latest major / `~>`" advice, bump versions or regenerate `.terraform.lock.hcl` unless the user asks.
- **Reviewed access settings stay in code:** keep identities, folders and grant settings for access control in a committed `locals` block (for example `terraform/pam/rd/access-policy.tf`), not in variables or tfvars. "Use variables for all configurable values" applies to reusable modules and genuinely per-operator inputs.
- **File layout and naming:** follow the team-agreed [layout and naming conventions](../../../docs/terraform-and-agents.md#layout-and-naming-conventions). Roots go in `terraform/<domain>/<scope>/`, and `versions.tf` holds the `terraform`, backend and provider blocks. Access-control values go in `access-policy.tf`. Do not use the upstream `providers.tf`/`backend.tf`/`locals.tf` split, and don't change the convention unless the user approves.
- **Google Cloud, not AWS:** ignore `default_tags` and AWS examples; use `labels` where the Google resource supports them. Prefer non-authoritative IAM resources (`*_iam_member`), never authoritative `*_iam_policy` that could overwrite PAM bindings.
- **Checks:** use `terraform fmt -check -recursive` to review (run `terraform fmt` to rewrite only for files you are editing) and backend-disabled `terraform init -backend=false` plus `terraform validate` when providers and network access are approved. `tflint`, `checkov` and `tfsec` are not in `INSTALLS.md`; do not install or run them without approval. Never plan, apply or use credentials as part of this skill.
- **Sensitive data:** `sensitive = true` does not keep values out of state. Never put secrets in variables, outputs, tfvars or docs.

---


# Terraform Style Guide

Generate and maintain Terraform code following HashiCorp's official style conventions and best practices.

**Reference:** [HashiCorp Terraform Style Guide](https://developer.hashicorp.com/terraform/language/style)

## Code Generation Strategy

When generating Terraform code:

1. Start with provider configuration and version constraints
2. Create data sources before dependent resources
3. Build resources in dependency order
4. Add outputs for key resource attributes
5. Use variables for all configurable values

## File Organization

| File | Purpose |
|------|---------|
| `terraform.tf` | Terraform and provider version requirements |
| `providers.tf` | Provider configurations |
| `main.tf` | Primary resources and data sources |
| `variables.tf` | Input variable declarations (alphabetical) |
| `outputs.tf` | Output value declarations (alphabetical) |
| `locals.tf` | Local value declarations |

### Example Structure

```hcl
# terraform.tf
terraform {
  required_version = ">= 1.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# variables.tf
variable "environment" {
  description = "Target deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

# locals.tf
locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# main.tf
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-vpc"
  })
}

# outputs.tf
output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}
```

## Code Formatting

### Indentation and Alignment

- Use **two spaces** per nesting level (no tabs)
- Align equals signs for consecutive arguments

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = "subnet-12345678"

  tags = {
    Name        = "web-server"
    Environment = "production"
  }
}
```

### Block Organization

Arguments precede blocks, with meta-arguments first:

```hcl
resource "aws_instance" "example" {
  # Meta-arguments
  count = 3

  # Arguments
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  # Blocks
  root_block_device {
    volume_size = 20
  }

  # Lifecycle last
  lifecycle {
    create_before_destroy = true
  }
}
```

## Naming Conventions

- Use **lowercase with underscores** for all names
- Use **descriptive nouns** excluding the resource type
- Be specific and meaningful
- Resource names must be singular, not plural
- Default to `main` for resources where a specific descriptive name is redundant or unavailable, provided only one instance exists

```hcl
# Bad
resource "aws_instance" "webAPI-aws-instance" {}
resource "aws_instance" "web_apis" {}
variable "name" {}

# Good
resource "aws_instance" "web_api" {}
resource "aws_vpc" "main" {}
variable "application_name" {}
```

## Variables

Every variable must include `type` and `description`:

```hcl
variable "instance_type" {
  description = "EC2 instance type for the web server"
  type        = string
  default     = "t2.micro"

  validation {
    condition     = contains(["t2.micro", "t2.small", "t2.medium"], var.instance_type)
    error_message = "Instance type must be t2.micro, t2.small, or t2.medium."
  }
}

variable "database_password" {
  description = "Password for the database admin user"
  type        = string
  sensitive   = true
}
```

## Outputs

Every output must include `description`:

```hcl
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "database_password" {
  description = "Database administrator password"
  value       = aws_db_instance.main.password
  sensitive   = true
}
```

## Dynamic Resource Creation

### Prefer for_each over count

```hcl
# Bad - count for multiple resources
resource "aws_instance" "web" {
  count = var.instance_count
  tags  = { Name = "web-${count.index}" }
}

# Good - for_each with named instances
variable "instance_names" {
  type    = set(string)
  default = ["web-1", "web-2", "web-3"]
}

resource "aws_instance" "web" {
  for_each = var.instance_names
  tags     = { Name = each.key }
}
```

### count for Conditional Creation

```hcl
resource "aws_cloudwatch_metric_alarm" "cpu" {
  count = var.enable_monitoring ? 1 : 0

  alarm_name = "high-cpu-usage"
  threshold  = 80
}
```

## Security Best Practices

Refer to SECURITY.md. It includes guidance on encrypting resources,
preventing sensitive data in state, and secure configurations.

## Version Pinning

```hcl
terraform {
  required_version = ">= 1.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
```

Use the latest major version of each provider and the latest minor version of
Terraform, unless otherwise constrained by a dependency lock file or by other
modules used by the configuration.

**Version constraint operators:**
- `= 1.0.0` - Exact version
- `>= 1.0.0` - Greater than or equal
- `~> 1.0` - Allow rightmost component to increment
- `>= 1.0, < 2.0` - Version range

## Provider Configuration

```hcl
provider "aws" {
  region = "us-west-2"

  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Project   = var.project_name
    }
  }
}

# Aliased provider for multi-region
provider "aws" {
  alias  = "east"
  region = "us-east-1"
}
```

## Version Control

**Never commit:**
- `terraform.tfstate`, `terraform.tfstate.backup`
- `.terraform/` directory
- `*.tfplan`
- `.tfvars` files with sensitive data

**Always commit:**
- All `.tf` configuration files
- `.terraform.lock.hcl` (dependency lock file)

## Validation Tools

Run before committing:

```bash
terraform fmt -recursive
terraform validate
```

Additional tools:
- `tflint` - Linting and best practices
- `checkov` / `tfsec` - Security scanning

## Code Review Checklist

- [ ] Code formatted with `terraform fmt`
- [ ] Configuration validated with `terraform validate`
- [ ] Files organized according to standard structure
- [ ] All variables have type and description
- [ ] All outputs have descriptions
- [ ] Resource names use descriptive nouns with underscores
- [ ] Version constraints pinned explicitly
- [ ] Sensitive values marked with `sensitive = true`
- [ ] No hardcoded credentials or secrets
- [ ] Security best practices applied

---

*Based on: [HashiCorp Terraform Style Guide](https://developer.hashicorp.com/terraform/language/style)*
