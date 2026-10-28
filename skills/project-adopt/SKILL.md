---
name: project-adopt
description: Use when an EXISTING project (a repo or folder that already has code, docs or git history) should become understandable to any AI agent — scans it, writes an evidence-backed AGENTS.md map, adds @AGENTS.md to existing CLAUDE.md / GEMINI.md without rewriting them, and optionally adds an agent task store, decision log, reports and a project-docs skill that follow the project's own conventions. Do NOT use for empty or brand-new folders (use project-kickoff) or for projects already set up by project-kickoff or project-adopt.
---

# Project Adopt

Makes an existing project readable for any AI agent through `AGENTS.md`, following the
project's own conventions. Templates are in `templates/` next to this file; what to read and
how to judge it is in `references/scan-checklist.md`.

## Hard rules

- **Additive only.** Existing files may only gain lines. Never delete, reorder or reword an
  existing line. Every change to an existing file is shown as a diff and approved first.
- **No files before approval.** Nothing is written before the user confirms in step 5.
- **Evidence or Unknown.** Everything written comes from a file, git history or a user answer.
  Anything else is `Unknown`.
- **No secrets.** Never copy values from `.env*` files, keys, tokens or connection strings.
- **Nothing outside the repo** is written, except the backup copies of step 6 and the
  stack-tool installs (with their scratch downloads) the user chose in step 4 and approved in
  step 5 (`references/stack-tools.md`). Reading outside the repo, e.g. `~/.claude/` when
  searching for tools, is fine.
- **English only** in every generated or appended text. Talk with the user in their language.
- **Never change the tracker** (tickets, statuses, fields).
- **No git commits** unless the user says yes at handoff.

## Workflow

### 1. Preflight

Target = the current working directory, unless the user names another one.

Stop and write nothing if:
- `AGENTS.md` contains `managed-by: project-adopt`, or the target has all of `AGENTS.md`,
  `docs/PROJECT.md` and `.claude/skills/project-docs/SKILL.md` (set up by project-kickoff).
  Say the project is already set up. For one set up by project-adopt, say that a refresh mode
  does not exist yet.
- The target has no README, no source or config files, and no git commits. Recommend
  the project-kickoff skill.

In a git repo, run `git status --porcelain -- AGENTS.md CLAUDE.md GEMINI.md .gitignore`. If it
prints anything, say those files have uncommitted changes and continue only on an explicit yes.

### 2. Scan

Follow `references/scan-checklist.md`. Write nothing. Build the findings table
(`Topic | Finding | Evidence | State`, states `clear` / `unclear` / `conflict` / `missing`).
Steps 3–6 all work from this table.

### 3. Questions (at most 7)

- Ask only about `unclear` and `conflict` findings, in this order: purpose, build/test/run,
  stack, tracker, conventions, doc locations, related repos. One question per message; show
  the evidence; multiple choice when possible. Findings with the same root cause (e.g. install,
  test and stack all depend on npm vs pnpm) are asked as one question.
- Apply each answer to every finding it resolves (e.g. "pnpm" → `pnpm install`, `pnpm test`,
  `pnpm start`), not only to the row the question came from.
- `missing` findings are not asked. They become gap-fill offers (step 4) or `Unknown`, as
  `references/scan-checklist.md` §2 says.
- "Don't know" → `Unknown`. Do not push.
- Then ask one optional closing question: "Is there anything the team does that isn't
  written down?" Each answer becomes a Working rules bullet in AGENTS.md.

### 4. Setup choices (not counted in the 7)

One per message:
1. **AI tools** (multi-select): Claude, Gemini, Codex, Cursor, none. Existing `CLAUDE.md` /
   `GEMINI.md` get `@AGENTS.md` whatever the answer; this only decides which new pointer files
   are created. Codex and Cursor read `AGENTS.md` directly.
2. **Agent task store:**
   - `docs/tasks/`: committed. Best for solo projects, because parallel branches can produce
     duplicate numbers.
   - `.agents/tasks/`: local and gitignored. Best for team repos.
   - none.

   Skip this question if the project already has its own task folder; its convention is used.
3. **Gap fills** (multi-select). Offer only items with no equivalent, per
   `references/scan-checklist.md` §3: `docs/DECISIONS.md` (no decision records), `docs/reports/`
   (no reports folder), `docs/PROJECT.md` (the README does not say what the project does),
   `docs/ROADMAP.md` (no roadmap), `docs/issues/` (no tracker), `docs/features/` (no spec
   folder; only with a task store, since features are built through tasks), `docs/design/ARCHITECTURE.md` (no architecture doc), and `DESIGN.md` +
   `design-ui/` (the project has a UI and no design system).
4. **Project skills:** 0–3 suggestions drawn from workflows that repeat in the project (e.g. a
   release checklist in CONTRIBUTING), skipping skills that already exist under
   `.claude/skills/`. Give each a kebab-case name, a one-line purpose and the reason. The user
   picks any number, including none.
5. **Stack tools:** per `references/stack-tools.md` — only when Claude was selected and at
   least one stack finding is `clear` after applying the step-3 answers. Up to 6 installed or installable skills, agents,
   plugins and MCP servers matching those findings; the user picks reference, install or skip
   for each.

`project-docs` is installed automatically whenever a task store, `docs/features/`, `docs/issues/`, `docs/reports/` or `docs/DECISIONS.md` is created, or the project has its own task or spec folder.

### 5. Summary for approval

Show, in the user's language:
- the final findings table
- every new file, as a tree
- a unified diff for every existing file that will change
- every `Unknown` and the `Decide …` task it gets
- pointer files, task store, gap fills and skills
- stack tools: each chosen tool with reference / install, and the exact command of every install

Revise until the user explicitly confirms. Write nothing before that.

### 6. Generate

`DATE` = today, `YYYY-MM-DD`. Before editing an existing file, copy it to
`<scratchpad>/adopt-originals/<same relative path>`, or to a temporary folder outside the
target if there is no scratchpad.

Write in this order:
1. **Task store:** `<store>/.gitkeep`. For `.agents/tasks/` in a git repo, append the line
   `.agents/` to `.gitignore`, creating the file if it does not exist.
2. **Gap-fill docs** from `templates/docs/`:
   - `PROJECT.md`
   - `ROADMAP.md`, with phase-1 `active`
   - `DECISIONS.md`, with D-0001 recording this adoption
   - `docs/issues/.gitkeep` and `docs/reports/.gitkeep`, when selected
   - `docs/features/.gitkeep`, when selected
   - `docs/design/ARCHITECTURE.md` ← `templates/docs/design/ARCHITECTURE.md`, filled from
     `clear` findings only, `EMPTY` = `Not documented yet`
   - `DESIGN.md` ← `templates/DESIGN.md` (`EMPTY` = `Not documented yet`), `design-ui/README.md`,
     `design-ui/tokens.css` (verbatim) and `design-ui/proposals/.gitkeep`, when selected
3. **`Decide <topic>` tasks**, one per `Unknown`, only if a task store exists:
   - template: `templates/skills/project-docs/templates/task.md`
   - numbered from the next free number
   - `status: todo`, `feature: none`, `ticket: none`
   - a task about a stack `Unknown` also gets the criterion in `references/stack-tools.md` §10
   - when `DESIGN.md` was created, one more task: `Document the existing UI design in DESIGN.md` (`feature: none`), whose criteria fill each section from the code and ask the human whether the current look is the approved one
4. **`.claude/skills/project-docs/`**, when needed (step 4):
   - Copy `templates/skills/project-docs/` including `adding-a-feature.md` and fill only the named placeholders in `SKILL.md`:
     `{{TASKS_DIR}}`, `{{DECISIONS_PATH}}`, `{{OTHER_LOCATIONS: …}}`, `{{TRACKER_RULES: …}}`,
     `{{PROJECT_CONVENTIONS: …}}`, `{{FEATURES_DIR}}`.
   - `FEATURES_DIR` = the repo's own spec folder (scan-checklist §3), else `docs/features/` if created — written in backticks — else the plain words `not used`.
   - Leave the prose `{{...}}` and the `templates/` folder untouched.
   - If the project has its own task convention, rewrite "File naming" and "Next number" to
     describe that convention instead.
   - If `FEATURES_DIR` is the repo's own spec folder, do the same for features: describe that
     folder's naming, numbering and fields (or "no frontmatter"), and replace the feature row
     of "Required frontmatter" and the **Feature** status block with "Features follow the
     existing format in `<folder>`; ask the human before changing a spec's status".
5. **Project skill skeletons** from `templates/skills/skill-skeleton.md`, into
   `.claude/skills/<name>/SKILL.md`.
6. **`AGENTS.md`:**
   - missing → create it from `templates/AGENTS.md`
   - exists → append, in this order:
     - a blank line
     - the heading `## Project map (project-adopt)` (not in the template; write it as given)
     - the marker line (line 1 of the template)
     - the template from `## Start here` to the end (skip its title and summary), with every
       `##` demoted to `###`
   - in both cases fill `TOOL_ROWS` per `references/stack-tools.md` §9
7. **Pointer files:**
   - An existing `CLAUDE.md` / `GEMINI.md` that is not a symlink and has no `@AGENTS.md` line:
     insert `@AGENTS.md` and a blank line at the top.
   - A missing pointer file for a selected AI: copy it from `templates/`.
8. **Stack tool installs**, if any were approved — per `references/stack-tools.md` §6–§8.

**Filling templates.** `{{NAME}}` → the value. `{{NAME: instruction}}` → follow the instruction
and write the result. If an instruction says to delete a line or section, delete it whole.
`EMPTY` (the empty-section fallback in DESIGN.md and ARCHITECTURE.md) → `Not documented yet`.

**Paths in backticks must exist.** A path in backticks is written from the repo root
(`design-ui/tokens.css`, not `tokens.css`), in every column of every table. When a source
mentions a path that does not exist yet (e.g. "put SQL in `src/db/` once it exists"), write it
without backticks and add "(planned)".

**File names** for tasks, issues and reports: `<kind>-<NNNN>-<kebab-topic>-<DATE>.md`, where
`kebab-topic` is 2–5 lowercase English words, `[a-z0-9-]` only.

**Self-check before handoff:**
- For every saved original, `diff <original> <file>` prints no line starting with `<`.
- Every path in backticks in the adopt part of `AGENTS.md` exists.
- `grep -rl '{{' . --include='*.md'` lists no file you wrote outside
  `.claude/skills/project-docs/`, and the named project-docs placeholders are all filled.
- `AGENTS.md` contains the marker exactly once, and the part from the marker to the end is at
  most 150 lines.
- No value from any `.env*` file appears in anything you wrote.
- No token, key or other secret value appears in any file written or command run.

### 7. Handoff

Report:
- the files created
- the files edited, with the number of lines added to each
- every `Unknown` and its task
- stack tools: installed / failed / referenced, with follow-ups (reload plugins, commands the
  user must run with their own key)
- next steps:
  1. review the AGENTS.md map
  2. fill in the draft skill skeletons
  3. if `docs/tasks/` was chosen in a team repo, tell teammates about the renumber-on-collision
     rule in project-docs
  4. for any new feature, follow `.claude/skills/project-docs/adding-a-feature.md` when
     project-docs was installed

If the target is a git repository, ask whether to commit. Never commit without a yes.
