# Source

- Upstream: https://github.com/hashicorp/agent-skills (path `plugins/terraform/skills/refactor-module`)
- Pinned commit: `5e30fa5c867ba6777c37e4206babfd08049c396f` (fetched 2026-11-04 from raw.githubusercontent.com; not installed via `npx skills`)
- License: Mozilla Public License 2.0 (`LICENSE`). Modified files stay under MPL-2.0.
- Upstream SHA-256:
  - da0b9f3599ed0e513a92b57f0c0ff3fad3168ba461215a9197ebbffe4e0d538f  SKILL.md

## Local modifications

- `SKILL.md`: replaced the frontmatter description with repo-specific guidance on when to use the skill, added `metadata.upstream`/`license` (dropping upstream `lifecycle-status`/`copyright`/`version` metadata; the copyright is IBM Corp. 2026, version 0.0.1), and inserted the "DevOps HQ overrides" section. The upstream body is unchanged below it.

To update: fetch a new pinned commit, diff it against the upstream hash above, review it, then reapply the overrides.
