# project-docs-kit

Two agent skills that give a project a documentation set any AI agent can pick up from
`AGENTS.md` alone — Claude Code, Codex, Gemini CLI, Cursor or the next one.

- **project-kickoff** — for a new, empty project. Asks a few questions, then writes the brief,
  roadmap, features, decisions, a task store and `AGENTS.md`. Run it again in a project it set
  up with an older release, and it upgrades that project to the current structure.
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
  DECISIONS.md                 decision index
  decisions/                   one file per decision
  STACK.md                     stack and conventions
  features/                    one file per feature
  design/ARCHITECTURE.md
  tasks/  issues/  reports/    work items with status
DESIGN.md, design-ui/          look and feel (projects with a UI)
.claude/skills/project-docs/   how agents add tasks, issues, reports and features
```

`project-adopt` writes `AGENTS.md` and adds only the parts you approve.

## What the skills read, run and fetch

The plugin has no hooks or MCP servers. It has one script,
`skills/project-kickoff/scripts/check-decisions.sh`, a read-only check that upgrade mode runs
on the split decision log (bash; on Windows the agent runs the same checks by reading the
files). Everything below is done by the agent following the skill text, with your approval
where noted.

- **Project files:** read the target folder (project-adopt scans code, manifests, docs and
  `git log`; project-kickoff reads existing design docs when you use them as part of the
  brief), write the docs listed above after you confirm a summary, and run read-only git
  commands such as `git status` and `git check-ignore` (at the end, to tell you which new
  files a `.gitignore` would keep out of a commit).
- **Stack tools (Claude Code only, optional):** to suggest skills, agents, plugins and MCP
  servers for your stack, and installed skills for the kinds of work the project does
  (testing, API security, database, user interface), the skills read the names and
  descriptions of what is installed (`~/.claude/skills`, `~/.claude/agents`, installed
  plugins, configured marketplaces, and MCP server names from `claude mcp list` — never their
  env values or headers). To leave out tools you turned off, they read only the
  `skillOverrides` and `enabledPlugins` keys of your Claude Code settings files, nothing else
  in them. If nothing installed matches your stack, they may run a web search limited to the
  vendor's or Anthropic's GitHub organisations and read the matching repositories.
- **Installs, only for the tools you choose and only after you approve the exact command:**
  `claude plugin install <name>@<marketplace>`, a vendor's documented `claude mcp add --scope
  user …` without any secret, or copying a skill or agent you reviewed from such a repository
  into `~/.claude/skills/` or `~/.claude/agents/`.
- Nothing is sent anywhere else, and no data is stored outside your project and those
  install locations.

## What the skills never do

- commit without your yes
- write tokens or secrets into files
- install tools or plugins without asking
- overwrite existing docs — the one edit project-kickoff may make to an existing file in a
  new project is adding front matter to an existing `docs/design/ARCHITECTURE.md` or
  `DESIGN.md`, shown as a diff and only after you say yes; the rest of the file is not changed.
  Upgrade mode changes only the lines its checklist names, after you confirm its plan, and
  keeps your own edits to `.claude/skills/project-docs/` (merged, shown as a diff)

## Updating

Claude Code plugin: `claude plugin marketplace update project-docs-kit`, then
`claude plugin update project-docs-kit@project-docs-kit`, then restart Claude Code.
Skills CLI: `npx skills update`.

Projects set up by an older `project-kickoff` keep working. To bring one up to the current
structure (for example, project structure 2 splits the decision log into one file per decision), run
`project-kickoff` in it: it shows a plan, waits for your yes, and changes nothing else.

See [CHANGELOG.md](CHANGELOG.md) for what each release changes.

## License

[MIT](LICENSE)
