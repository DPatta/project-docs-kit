# {{PROJECT_NAME}}

{{SUMMARY: same 2–3 sentence summary as docs/PROJECT.md}}

Full detail: [docs/PROJECT.md](docs/PROJECT.md)

## Start here (read in order)

1. `docs/PROJECT.md` — goals, scope, non-goals, success criteria
2. `docs/ROADMAP.md` — the phase with `- **Status:** active` is the current phase
3. `docs/features/` — the features of the active phase (`grep -l "phase: <id>" docs/features/*.md`); `approved` and `in-progress` ones are the current scope
4. `docs/tasks/` — tasks with `status: in-progress` first, then `status: todo` (lowest number first)
5. `docs/issues/` — issues with `status: open` or `investigating` may block tasks
6. `docs/DECISIONS.md` — check before proposing an alternative to something already decided
7. `docs/{{TYPE_DOC: STACK.md, METHODS.md, STYLE.md or RESOURCES.md}}` — {{TYPE_DOC_PURPOSE: purpose line from references/project-types.md}}
{{DESIGN_DOCS: "8. `docs/design/ARCHITECTURE.md` — how the system fits together" if it was created; then "<next number>. `DESIGN.md` — the UI look and feel; build screens only from its approved mockups" if it was created; delete this line if neither}}

## Current state

This file deliberately does not record progress — it would go stale. Derive it:

```bash
grep -l "status: in-progress" docs/tasks/*.md   # work in progress
grep -l "status: proposed" docs/features/*.md   # features waiting for the human
grep -l "status: in-progress" docs/features/*.md # features being built
grep -l "status: todo" docs/tasks/*.md          # next up
grep -l "status: open" docs/issues/*.md         # open issues
```

## Working rules

- All project documents are written in English.
- Creating or editing anything in `docs/` → follow `.claude/skills/project-docs/SKILL.md`.
- A request for a new feature or more scope → follow `.claude/skills/project-docs/adding-a-feature.md`.
- Record every significant choice, and what was rejected, in `docs/DECISIONS.md`.
- Never edit a document with `status: approved` without asking the human first.
- Work may start while core docs are `draft`; only the human (project owner) sets `approved`.
- Values marked `Undecided` are open questions — ask the human; do not assume.
{{TYPE_RULES: the "Working rules" bullets for this type from references/project-types.md, one per line}}

## Project skills

| Skill | Use when | Path |
|---|---|---|
| project-docs | creating or updating tasks, issues, reports, or any status | `.claude/skills/project-docs/SKILL.md` |
{{SKILL_ROWS: one table row per selected project skill; delete this line if none were selected}}

Skills are plain markdown. Agents without native skill support should open the file and follow it.

## Recommended tools (Claude Code)

Optional, installed per user — not part of this repo. Other agents can ignore this section.

| Tool | Kind | Use when | Source / install |
|---|---|---|---|
{{TOOL_ROWS: one row per tool the user chose, per references/stack-tools.md §9; if none were chosen, delete the whole section including its heading}}

## Status reference

| Kind | Flow |
|---|---|
| Feature | `proposed` → `approved` → `in-progress` → `done` (also `rejected`, `cancelled`) |
| Task | `todo` → `in-progress` → `review` → `done` (also `blocked`, `cancelled`) |
| Issue | `open` → `investigating` → `resolved` (also `wont-fix`) |
| Core doc | `draft` → `approved` → `outdated` |
| Phase | `planned` → `active` → `done` |
| Report | `draft` → `final` |
