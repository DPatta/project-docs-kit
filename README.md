# project-docs-kit

Two agent skills that give a project a documentation set any AI agent can pick up from
`AGENTS.md` alone — Claude Code, Codex, Gemini CLI, Cursor or the next one.

- **project-kickoff** — for a new, empty project. Asks a few questions, then writes the brief,
  roadmap, features, decisions, a task store and `AGENTS.md`.
- **project-adopt** — for an existing repo. Scans the code, writes an evidence-backed
  `AGENTS.md`, links it from your existing `CLAUDE.md` / `GEMINI.md`, and can add the same task
  store following the project's own conventions.

## Install

### Claude Code (plugin)

```
/plugin marketplace add DPatta/project-docs-kit
/plugin install project-docs-kit@project-docs-kit
```

Then run `/project-docs-kit:project-kickoff` in a new project or
`/project-docs-kit:project-adopt` in an existing one — or just ask Claude to set up the project
docs.

### Any agent supported by the skills CLI

```
npx skills add DPatta/project-docs-kit
```

### Manual

Clone this repo and copy `skills/project-kickoff` and `skills/project-adopt` into your agent's
skills folder (for Claude Code: `~/.claude/skills/`).

## What gets created

`project-kickoff` in a software project (other project types get `METHODS.md`, `STYLE.md` or
`RESOURCES.md` instead of `STACK.md`, and no design files):

```
AGENTS.md                      map of the project for any agent
CLAUDE.md, GEMINI.md           one-line pointers to AGENTS.md (for the agents you pick)
docs/
  PROJECT.md                   brief: goal, users, scope
  ROADMAP.md                   phases and the features in each
  DECISIONS.md                 decision log
  STACK.md                     stack and conventions
  features/                    one file per feature
  design/ARCHITECTURE.md
  tasks/  issues/  reports/    work items with status
DESIGN.md, design-ui/          look and feel (projects with a UI)
.claude/skills/project-docs/   how agents add tasks, issues, reports and features
```

`project-adopt` writes `AGENTS.md` and adds only the parts you approve.

## What the skills never do

- commit without your yes
- write tokens or secrets into files
- install tools or plugins without asking
- overwrite existing docs

## Updating

Claude Code plugin: `claude plugin marketplace update project-docs-kit`, then
`claude plugin update project-docs-kit@project-docs-kit`, then restart Claude Code.
Skills CLI: `npx skills update`.

See [CHANGELOG.md](CHANGELOG.md) for what each release changes.

## License

[MIT](LICENSE)
