# Stack Tools

Shared by project-kickoff and project-adopt; the two copies are byte-identical. Suggests
Claude Code skills, agents, plugins and MCP servers that match the project's known stack, and
installs the ones the user picks.

## 1. When to run

Run only when both hold; otherwise skip silently — no question, no AGENTS.md section:
- the user selected **Claude** as an AI tool;
- there is at least one **stack item** (§2).

## 2. Stack items

A stack item is one technology the project states, e.g. `Next.js`, `Supabase`, `Vercel`.
- project-kickoff: STACK.md values that come from the brief or an answer. `Undecided` areas
  are not items.
- project-adopt: findings of the scan topic **Stack** (languages, frameworks, package
  manager, versions) in state `clear` after the step-3 answers are applied (an answered
  conflict becomes `clear`). Findings still `unclear`, `conflict` or `missing` are not items.
  Other topics — tracker, CI, conventions — are never items.

Never expand an item into related technologies: `Next.js` does not add `React` or
`TypeScript`, and `Supabase` does not add `PostgreSQL`.

## 3. Search

Tools come in two groups, decided by the tool's own kind, not by where it comes from:
- **knowledge** — skills and agents (how to work with the technology), including skills and
  agents that ship inside a plugin;
- **integration** — a plugin offered as a whole (kind `plugin` or `plugin + MCP`) and MCP
  servers (tools that act on the technology's service).

Search each stack item once per group, tier by tier, and keep every match (§4) as a
candidate. For each item and group, stop at the first tier that yields a **name match**; with
no match or only description matches, go on to the next tier. An installed knowledge skill
therefore never hides the vendor's integration plugin, and vice versa. Then rank all
candidates together (§4).

**Tier 1 — installed**
- Configured MCP servers: names from `claude mcp list` (read the names only; never print or
  copy their env values or headers).
- `~/.claude/skills/*/SKILL.md` — frontmatter `name` and `description`.
- `~/.claude/agents/*.md` — frontmatter `name` and `description`.
- Installed plugins: each key `<plugin>@<marketplace>` in
  `~/.claude/plugins/installed_plugins.json` → its `installPath` → `skills/*/SKILL.md` and
  `agents/*.md` under it. Name these `<plugin>:<name>`.

**Tier 2 — configured marketplaces**
- `~/.claude/plugins/marketplaces/<marketplace>/.claude-plugin/marketplace.json` —
  `plugins[].name` and `plugins[].description`.
- Skip plugins that are already installed.

**Tier 3 — official repos**
- Web search, keeping only `github.com/<org>/…` results where `<org>` belongs to the item's
  vendor (e.g. `vercel`, `vercel-labs`, `supabase`) or is `anthropics`.
- An org belongs to the vendor only if the vendor's own website or docs link to it.
- The repo must contain a `SKILL.md`, an agent `.md`, or an MCP server whose README documents
  a `claude mcp add` command.
- No other source: no community repos, gists, registries or blog posts.

## 4. Matching

- A tool matches an item when the item's name appears in the tool's name or description,
  case-insensitive (`Next.js` also matches `nextjs` and `next-js`), **and** the tool is about
  that technology as the project uses it. Another product of the same vendor is not a match:
  a Vercel AI SDK skill does not match `Vercel` used as hosting.
- Choose in this order:
  1. Per item and group, sort candidates by: name match before description-only match; then
     installed before installable; then alphabetical. Keep the first **2**.
  2. A tool kept for several items counts once, under the item where it ranks highest.
  3. Per group, merge the kept tools of all items and sort them the same way (name match
     first — an installable name match outranks an installed description-only match). Keep
     at most **4 knowledge** and **2 integration** tools (6 in total).
- Zero is fine — never pad with loosely related tools.
- Example (Next.js + Supabase + Vercel): knowledge `nextjs-app-router-patterns`,
  `nextjs-best-practices` (Next.js), `nextjs-supabase-auth` (Supabase), `vercel-deployment`
  (Vercel); integration `supabase` and `vercel` plugins. A third Next.js skill is cut by
  the 2-per-item limit, and a database agent that only mentions Supabase in its description
  is cut by the 4-knowledge limit.
- Kind is exactly one of `skill`, `agent`, `plugin`, `plugin + MCP` (a plugin whose
  description mentions MCP) or `MCP`.

## 5. The question

A setup choice, asked after the other setup questions; it does not count toward the question
budget. Show one line per suggestion:

`<n>. <name> — <kind> — <source> — <installed | installable> — <reason naming the item>`

One answer per tool: **reference**, **install** (only for `installable`) or **skip**. The
user may answer several tools in one message; "None" skips all. Choosing **install** for an
`MCP` or `plugin + MCP` tool is the explicit request to set up that MCP server; **reference**
puts its install command in the table instead.

## 6. Install

Only after the user approves the summary (SKILL.md step 5). That summary lists every chosen
tool and, for each install, the exact command; approving it approves that list. Installs are the last
generation sub-step, run one at a time in list order.

| Source | Do |
|---|---|
| Tier 1 | Nothing — reference only. |
| Tier 2 plugin | Show its marketplace entry: name, description, `source` and `homepage` (`claude plugin details` works only on installed plugins). Then run `claude plugin install <name>@<marketplace>`, and afterwards `claude plugin details <name>@<marketplace>` to show what was installed. Tell the user to run `/reload-plugins` or restart Claude Code. |
| Tier 3 skill / agent | 1. Download the repo folder into a new, empty scratch directory. 2. Show the full file list and the whole `SKILL.md` (or agent file). 3. If any other file is a script or executable, show it and ask for a second explicit yes. 4. Copy the skill folder to `~/.claude/skills/<name>/`, or the agent file to `~/.claude/agents/<name>.md`. |
| MCP server | Run the vendor's documented command as `claude mcp add --scope user …` **without any secret**. Prefer the vendor's OAuth / HTTP variant. If a secret is unavoidable, do not run the command: give the user the exact command with a `<your value>` slot to run themselves. |

`claude mcp add` stores `-e` and `--header` values literally, so a secret passed there ends up
in the config file. When a plugin declares a secret `userConfig` option, never pass it through
`--config`; tell the user to run `/plugin configure <name>` themselves.

## 7. Never

- Never write, echo, log or store a token, API key, password or other secret value. Never ask
  the user to paste one. If one is pasted anyway, use it nowhere and tell the user to rotate
  it.
- Never overwrite an existing skill or agent with the same name, and never add an MCP server
  whose name is already configured: stop that item and report it.
- Never install from outside the three tiers, or anything the user did not choose.
- Never uninstall, update or edit existing tools.
- Install at user scope only. Never edit the project's `.claude/settings.json` or `.mcp.json`
  (committed files that affect the whole team).

## 8. Failure

A failed install does not stop the run. Its row stays in the table with `(not installed)`
appended to the Source / install cell. The handoff lists each tool as installed, failed or
referenced, with follow-ups such as "run `/reload-plugins`" or "run this command with your
key: …".

## 9. AGENTS.md rows

`{{TOOL_ROWS}}`: one row per tool the user chose (reference or install):

`| <name> | <kind> | <use when — from the tool's own description, naming the stack item> | <source / install> |`

"Use when" adds nothing the description does not say (do not name a tool or version the
description does not mention).

Source / install:
- tier 1, from a plugin → `from plugin <plugin>@<marketplace>: claude plugin install <plugin>@<marketplace>`
- tier 1, standalone skill or agent → `local only (no public source found)`
- tier 2 → `claude plugin install <name>@<marketplace>`
- tier 3 → `<repo URL> → ~/.claude/skills/<name>/` (or `~/.claude/agents/<name>.md`)
- tier 1, configured MCP server → `configured locally (claude mcp list)` — never copy its
  command, arguments, env or headers from the local config
- MCP from tier 2 or 3 → the vendor's documented `claude mcp add …` command, then
  `needs <SECRET_NAME>` for each secret — the name only, never a value

## 10. Decide-task criterion

When Claude is among the AI tools, every `Decide …` task about a stack area gets this
acceptance criterion:

`- [ ] Check for matching stack tools (see AGENTS.md → Recommended tools); add the rows the user picks`

The stack areas are Language, Framework, Data / Storage, Hosting / Infra, Testing, CI/CD and
Other in project-kickoff, and in project-adopt any `Unknown` of the scan topic "Stack"
(languages, frameworks, package manager, versions). If AGENTS.md has no
Recommended tools section yet, completing the task may add it, with the heading and table
header exactly as in the template.
