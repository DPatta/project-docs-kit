<!-- managed-by: project-adopt -->
# {{PROJECT_NAME}}

{{SUMMARY: 2–3 sentences from the README or the user's answers — what the project is and who it is for}}

## Start here (read in order)

{{START_HERE: numbered list of 3–9 real paths, most important first, each with a one-line reason, e.g. "1. `README.md` — what the project is and how to run it"; if a task store exists, include it as "`<store>` — tasks with `status: in-progress` first, then `status: todo` (lowest number first)", and `docs/issues/` with "issues with `status: open` may block tasks" if it exists; include the features folder (FEATURES_DIR, if used) as "<folder> — features (scope)", adding "; approved and in-progress ones are current" only for docs/features/, and docs/design/ARCHITECTURE.md and DESIGN.md when they exist}}

## Project map

| Topic | Where | Notes |
|---|---|---|
{{MAP_ROWS: one row per topic the scan found (docs, ADRs, API specs, configs; packages for a monorepo); Where = a real path in backticks}}

## Build / test / run

{{COMMANDS: bullets "- <purpose>: `<command>` (from `<file>`)"; write "- <purpose>: Unknown → task-NNNN" (or just "Unknown" when there is no task store) for any that could not be determined}}

## Conventions

{{CONVENTIONS: bullets for code style (with lint/format config paths), branch naming, commit messages and file naming, each with its evidence in parentheses; leave out topics with no finding; "None found" if nothing was found}}

## Work tracking

{{TRACKING: bullets — the tracker and project key, or "No tracker — work is tracked in markdown only"; how to read a ticket (MCP tool or filter); where agent tasks live, or "No agent task store"}}

## Current state

This file does not record progress — it would go stale. Derive it:

```bash
{{STATE_COMMANDS: grep commands for the chosen task folder, e.g. grep -l "status: in-progress" .agents/tasks/*.md and grep -l "status: todo" .agents/tasks/*.md; add docs/issues/*.md with "status: open" if docs/issues/ exists; add <features folder>/*.md with "status: proposed" and "status: in-progress" if docs/features/ was created; if there is no task store, replace the whole code block, fences included, with "No agent task store." and keep the sentence above it}}
```

## Working rules

- All project documents and agent tasks are written in English.
{{DOCS_RULE: "- Creating or editing agent tasks, issues, reports or decisions → follow `.claude/skills/project-docs/SKILL.md`." if project-docs is installed; delete this line otherwise}}
{{FEATURE_RULE: "- A request for a new feature or more scope → follow `.claude/skills/project-docs/adding-a-feature.md`." if project-docs is installed; delete this line otherwise}}
- Record significant choices, and what was rejected, in {{DECISIONS_PATH: the ADR folder or docs/DECISIONS.md in backticks; "the pull request description" if neither exists}}.
- Never change a ticket's status in the tracker without asking the human.
- Values marked `Unknown` are open questions — ask the human; do not assume.
{{EXTRA_RULES: one bullet per existing rule file with content, e.g. "- Additional rules live in `CLAUDE.md` — read it whatever agent you are." (same for GEMINI.md, .cursorrules, .cursor/rules/; skip a file that is a symlink to AGENTS.md); then one bullet per answer to the closing "unwritten conventions" question; delete this line if none}}

## Related repos

{{RELATED_REPOS: bullets "- <repo name> — how it connects (API, shared library, …)"; if none, delete this section including its heading}}

## Project skills

| Skill | Use when | Path |
|---|---|---|
{{SKILL_ROWS: one row per skill under .claude/skills/ (existing and new, project-docs included); if there are none, delete the whole section including its heading}}

Skills are plain markdown. Agents without native skill support should open the file and follow it.

## Recommended tools (Claude Code)

Optional, installed per user — not part of this repo. Other agents can ignore this section.

| Tool | Kind | Use when | Source / install |
|---|---|---|---|
{{TOOL_ROWS: one row per tool the user chose, per references/stack-tools.md §9; if none were chosen, delete the whole section including its heading}}

## Unknowns

{{UNKNOWNS: one bullet per Unknown value with its task id, e.g. "- Node.js version → task-0001", or "- Node.js version: Unknown" when there is no task store; "None" if there are none}}

## Status reference

| Kind | Flow |
|---|---|
| Feature | `proposed` → `approved` → `in-progress` → `done` (also `rejected`, `cancelled`) |
| Task | `todo` → `in-progress` → `review` → `done` (also `blocked`, `cancelled`) |
| Issue | `open` → `investigating` → `resolved` (also `wont-fix`) |
| Core doc | `draft` → `approved` → `outdated` |
| Report | `draft` → `final` |
