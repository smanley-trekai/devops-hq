# Source

- Upstream: https://github.com/hashicorp/agent-skills (path `plugins/terraform/skills/terraform-style-guide`)
- Pinned commit: `5e30fa5c867ba6777c37e4206babfd08049c396f` (fetched 2026-11-04 from raw.githubusercontent.com; not installed via `npx skills`)
- License: Mozilla Public License 2.0 (`LICENSE`). Modified files stay under MPL-2.0.
- Upstream SHA-256:
  - 3a5c2e06a1daa07600d03f48328d1479284e7a9d59d66b2663693ca972080e22  SKILL.md
  - 3dc8ffa10139e9772c5c102fee6377f66f5167bd043a7c43e6e5df682dc75f92  SECURITY.md

## Local modifications

- `SKILL.md`: replaced the frontmatter description with repo-specific guidance on when to use the skill, added `metadata.upstream`/`license`, and inserted the "DevOps HQ overrides" section. The upstream body is unchanged below it.
- `SECURITY.md`: unchanged.

To update: fetch a new pinned commit, diff it against the upstream hashes above, review it, then reapply the overrides.
