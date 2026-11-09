# Changelog

Each release names two numbers: the release version (semver, in `.claude-plugin/plugin.json`)
and the project structure version that `project-kickoff` writes to
`.claude/skills/project-docs/KIT-VERSION` in a project, so a later release can tell which
structure a project was made with.

## 2.1.0 — 2026-11-09 (project structure 2)

A feature's task count is a check, not a cap. Generated files keep the same structure.

- project-docs `adding-a-feature.md`: a feature gets as many tasks as the work needs, where a
  task is one piece of work that can be reviewed on its own. Above 6 tasks, the agent stops
  and asks the human to split the feature or keep it whole, and logs a `kept whole` choice in
  the feature. Adding tasks during work asks again only when the count passes that number.
  This replaces the fixed limit of 1–6 tasks per feature, which pushed agents to merge
  unrelated work into one task.
- project-kickoff keeps its limit of 2–6 tasks in total for phase 1 (a limit on planning
  ahead), gives each phase-1 feature at least one task while the limit allows, and names the
  features left without a task in the summary and at handoff.
- Projects already on structure 2 keep their copy of `adding-a-feature.md`; upgrade mode does
  not change it. To take the new rule, copy the file from
  `skills/project-kickoff/templates/skills/project-docs/` into
  `.claude/skills/project-docs/`.

## 2.0.0 — 2026-11-08 (project structure 2)

A new project structure, and upgrade mode to reach it. Projects made with structure 1 keep
working; run `project-kickoff` in one to upgrade it.

- **One file per decision.** Decisions live in `docs/decisions/D-NNNN-<slug>.md` (front matter
  `id`, `title`, `date`, `supersedes`, `superseded-by`), and `docs/DECISIONS.md` becomes a short
  index with a status per decision (`active`, `partly superseded by …`, `superseded by …`).
  Agents read the index and open only the decisions that touch their work. A change never
  rewrites an entry: a new decision lists the old id in `supersedes`, and the old file gains it
  in `superseded-by`. project-adopt uses the same layout when it creates a decision log; an
  existing ADR folder or log is kept.
- **Agents load matching skills and tools.** AGENTS.md Working rules tell every agent to load
  the Project skills and Recommended tools (skills and plugins) whose "Use when" matches the
  task, to read a project skill as plain markdown when it cannot load it, and to skip and
  report a tool that is not installed. The Recommended tools intro no longer says other agents
  can ignore it.
- **Related tools in project skills.** Each new project skill skeleton has a `## Related tools`
  section listing the chosen Recommended tools that apply when using it.
- **New libraries get tool rows.** project-docs: a decision that adds a dependency or changes
  the stack checks for matching Claude Code tools, following the new
  `.claude/skills/project-docs/finding-tools.md`, which works without the kit installed.
- **Upgrade mode (structure 1 → 2).** project-kickoff, run in a project it set up earlier,
  scans it, shows a plan and waits for a yes. It merges your own edits to
  `.claude/skills/project-docs/` with the new template (three-way, shown as a diff), splits the
  decision log with byte-identical bodies and a relation table you confirm, edits only the
  named AGENTS.md lines, adds `## Related tools` to project skills, and writes `KIT-VERSION`
  last. Without git it backs up every changed file to `.kickoff-backup/<date>/`. It never
  commits.
- **New script** `skills/project-kickoff/scripts/check-decisions.sh`: a read-only check of the
  split decision log that upgrade mode runs as its self-check (bash; on Windows the agent runs
  the same checks by reading the files).

## 1.2.0 — 2026-11-08 (project structure 1)

Better stack tool suggestions and a commit check. Generated files keep the same structure.

- Stack tools leave out skills and plugins you turned off in Claude Code (`skillOverrides`
  `"off"`, `enabledPlugins` `false`), and name them in one line under the question. Only those
  two keys of the settings files are read.
- Stack tools also suggest up to 4 installed skills or agents for the kinds of work the project
  does — testing, API security, database, user interface — when they name no technology the
  project does not use. These are never searched outside what is installed.
- At handoff, project-kickoff and project-adopt run `git check-ignore` on the files they wrote
  and list any that a `.gitignore` keeps out of a commit (for example a global ignore of
  `.claude/`), then ask separately whether to add them with `git add -f`.

## 1.1.0 — 2026-11-07 (project structure 1)

Design-first projects. Generated files keep the same structure.

- project-kickoff accepts a folder whose `docs/` holds only `docs/design/`, and can use the
  existing design docs (`docs/design/`, `DESIGN.md`, `design-ui/`) as part of the brief: without
  a question when the brief points at them (it then says in one line which files it uses),
  otherwise after asking. What they state is not asked again and gets no Decide task; D-0001
  names them.
- Existing design docs are never rewritten. `docs/design/ARCHITECTURE.md` or `DESIGN.md` without
  front matter gets a four-line front matter diff in the summary, applied only on a yes.
- AGENTS.md lists the design docs that exist after kickoff, including ones it did not write and
  other notes in `docs/design/`.
- project-adopt recommends project-kickoff for a folder that holds only design docs.
- README: what the skills read now names existing design docs, and "never overwrite existing
  docs" names the one approved front matter edit.
- When `docs/` holds other files, project-kickoff asks two separate questions — whether `docs/`
  belongs to something else, and whether to continue — instead of one combined question that
  a bare "no" answered ambiguously. It stops unless the second answer is yes.

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
