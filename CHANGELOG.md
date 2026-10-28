# Changelog

Each release names two numbers: the release version (semver, in `.claude-plugin/plugin.json`)
and the project structure version that `project-kickoff` writes to
`.claude/skills/project-docs/KIT-VERSION` in a project, so a later release can tell which
structure a project was made with.

## 1.0.0 — unreleased (project structure 1)

First public release.

- `project-kickoff`: sets up a new project of any type (software, research, content, personal)
  with `AGENTS.md`, `docs/` (brief, roadmap, features, decisions, stack or methods), a task /
  issue / report store and a `project-docs` skill.
- `project-adopt`: maps an existing repo into `AGENTS.md` from evidence in the code, links it
  from existing `CLAUDE.md` / `GEMINI.md` without rewriting them, and optionally adds the same
  task store and `project-docs` skill.
