# Changelog

Each release names two numbers: the release version (semver, in `.claude-plugin/plugin.json`)
and the project structure version that `project-kickoff` writes to
`.claude/skills/project-docs/KIT-VERSION` in a project, so a later release can tell which
structure a project was made with.

## 1.0.1 — 2026-10-29 (project structure 1)

Clarifies rules the skills left open to more than one reading. Generated files keep the same
structure.

- project-kickoff stops with a clear message when the project was already set up by
  project-kickoff, instead of pointing to project-adopt.
- Phases: every phase name or goal the brief does not state is proposed and marked
  `(proposed)` in the summary, phase-1 included; a list label such as "MVP:" names its phase.
- Goals and problem come only from the brief's stated purpose; a feature list is scope.
- "Main language / framework?" is skipped when the brief names either one; the other is
  `Undecided`.
- A tool named without a role goes in STACK.md's Other row (`Role not stated`) and in
  ARCHITECTURE.md's External services without a role.
- Decide tasks have a fixed order and topic wording.
- File names: the `kebab-topic` rule covers features and says how punctuation is handled
  (`CI/CD` → `cicd`, `phase-1` stays one word).
- Stack tools: alphabetical order ignores a `<plugin>:` prefix; only an item's full name is a
  name match; installing a `plugin + MCP` tool runs only `claude plugin install`.

## 1.0.0 — 2026-10-29 (project structure 1)

First public release.

- `project-kickoff`: sets up a new project of any type (software, research, content, personal)
  with `AGENTS.md`, `docs/` (brief, roadmap, features, decisions, stack or methods), a task /
  issue / report store and a `project-docs` skill.
- `project-adopt`: maps an existing repo into `AGENTS.md` from evidence in the code, links it
  from existing `CLAUDE.md` / `GEMINI.md` without rewriting them, and optionally adds the same
  task store and `project-docs` skill.
