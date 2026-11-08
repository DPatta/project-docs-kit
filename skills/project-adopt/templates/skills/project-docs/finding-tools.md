# Finding tools

How to find Claude Code tools (skills, agents, plugins, MCP servers) for a technology the
project adds after setup. Used by the Decisions rules in `SKILL.md`. Skip this whole file when
the project does not use Claude Code (`AGENTS.md` has no "Recommended tools" section and no
`CLAUDE.md` exists).

## 1. Items

An item is one technology the decision adds or changes, by its own name (`Supabase`,
`Playwright`). Never expand it into related technologies: `Next.js` does not add `React`.

## 2. Search, tier by tier

Search each item once for **knowledge** tools (skills and agents) and once for
**integration** tools (a plugin as a whole, MCP servers). Per item and group, stop at the
first tier with a name match (§3).

1. **Installed**
   - MCP servers: the names from `claude mcp list` only — never print or copy their env values
     or headers.
   - `~/.claude/skills/*/SKILL.md` and `~/.claude/agents/*.md` — frontmatter `name` and
     `description`.
   - Installed plugins: each `<plugin>@<marketplace>` key in
     `~/.claude/plugins/installed_plugins.json` → its `installPath` → `skills/*/SKILL.md` and
     `agents/*.md`. Name these `<plugin>:<name>`.
   - Leave out turned-off tools. Read only the keys `skillOverrides` and `enabledPlugins` of
     `~/.claude/settings.json`, then `.claude/settings.json` and `.claude/settings.local.json`
     of this project (a later file wins), with a command that parses the JSON and prints just
     those two keys. Never open a whole settings file: it can hold secrets. A skill is off when
     its `skillOverrides` value is `"off"`; every tool of a plugin is off when its
     `enabledPlugins` value is `false`.
   - Leave out a tool made for another project or team (its description names it, or says
     another skill dispatches it).
2. **Configured marketplaces** — `plugins[].name` and `plugins[].description` in
   `~/.claude/plugins/marketplaces/<marketplace>/.claude-plugin/marketplace.json`, skipping
   plugins already installed.
3. **Official repos** — `github.com/<org>/…` only, where `<org>` is the vendor's (linked from
   the vendor's own site or docs) or `anthropics`, and the repo has a `SKILL.md`, an agent
   `.md`, or an MCP server whose README documents a `claude mcp add` command. No other source.

## 3. Matching

- A tool matches when the item's name is in its name or description (case-insensitive;
  `Next.js` also matches `nextjs`; a part of the name such as `next` does not) **and** it is
  about that technology as this project uses it. Another product of the same vendor is no
  match.
- Rank: name match before description-only match, installed before installable, then by name.
  Keep at most 2 per item and group. Zero is fine; never pad.
- Skip a tool that already has a row in `AGENTS.md` → Recommended tools.

## 4. Ask, then write

Show one line per tool: `<name> — <kind> — <source> — <installed | installable> — <reason>`.
Kind is `skill`, `agent`, `plugin`, `plugin + MCP` or `MCP`. The user answers **reference**,
**install** (only for installable) or **skip** per tool.

- **Install** only on that explicit answer, one at a time: a marketplace plugin with
  `claude plugin install <name>@<marketplace>`; an MCP server with the vendor's documented
  `claude mcp add --scope user …` command, never with a secret in it — if one is needed, give
  the user the command with a `<your value>` slot to run themselves. A skill or agent from an
  official repo: download into a new empty folder, show its files, and copy it to
  `~/.claude/skills/<name>/` or `~/.claude/agents/<name>.md`. Never overwrite a tool with the
  same name, and never edit the project's `.claude/settings.json` or `.mcp.json`.
- **Rows** for every tool answered reference or install, in `AGENTS.md` → Recommended tools:
  `| <name> | <kind> | <use when — from the tool's own description> | <source / install> |`.
  Source / install: an installed plugin's tool → `from plugin <plugin>@<marketplace>: claude
  plugin install <plugin>@<marketplace>`; a standalone installed skill or agent → `local only
  (no public source found)`; a marketplace plugin → `claude plugin install
  <name>@<marketplace>`; an official repo → `<repo URL> → ~/.claude/skills/<name>/`; a
  configured MCP server → `configured locally (claude mcp list)`; another MCP server → its
  `claude mcp add …` command, then `needs <SECRET_NAME>` per secret (the name only). If
  `AGENTS.md` has no Recommended tools section, add it with this heading and table header:

  ```
  ## Recommended tools (Claude Code)

  Installed per user — not part of this repo. Tools that are not installed are skipped (see Working rules).

  | Tool | Kind | Use when | Source / install |
  |---|---|---|---|
  ```
- **Related tools**: in each project skill the tool applies to, add a bullet with the tool's
  name in backticks, a dash and when to use it with that skill to its `## Related tools`
  section, replacing a `- None` line; add the section after `## Rules` if the skill has none.
- Never write, echo or store a token, key or password. If the user pastes one, use it nowhere
  and tell them to rotate it.
