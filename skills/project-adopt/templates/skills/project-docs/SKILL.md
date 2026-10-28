---
name: project-docs
description: Use whenever creating or updating features, agent tasks, issues, reports or decisions in this project, or changing their status. Defines locations, file naming, numbering, required frontmatter, allowed status transitions, and how agent tasks relate to the team tracker; new feature requests follow adding-a-feature.md.
---

# Project Docs

Rules for agent tasks, issues, reports and decisions in this project. Templates are in
`templates/` next to this file. All documents are written in English.

## Locations

- Agent tasks: `{{TASKS_DIR}}`
- Features: {{FEATURES_DIR}}
- Decisions: `{{DECISIONS_PATH}}`
{{OTHER_LOCATIONS: issues — "- Issues: `docs/issues/`" if that folder exists, else "- Issues: the tracker (see Tracker)" if there is a tracker, else "- Issues: not used"; reports — "- Reports: `docs/reports/`" if that folder exists, else "- Reports: not used"}}

## File naming

`<folder>/<kind>-<NNNN>-<kebab-topic>-<YYYY-MM-DD>.md`

- `<kind>`: `feature`, `task`, `issue` or `report`
- `<NNNN>`: 4-digit zero-padded run number, starting at `0001`
- `<kebab-topic>`: 2–5 lowercase English words, characters `[a-z0-9-]` only; delete any other character without replacing it (`CI/CD` → `cicd`); a hyphenated word keeps its hyphen and counts as one word (`Decide phase-1 features` → `decide-phase-1-features`)
- `<YYYY-MM-DD>`: creation date — never changes, even when the file is updated

Example: `{{TASKS_DIR}}task-0007-add-login-form-2026-11-02.md`

## Next number

1. List the kind's folder.
2. Take the highest `NNNN` among the `.md` files (ignore `.gitkeep` and anything else) and
   add 1. No `.md` files → `0001`.
3. Each kind has its own sequence. Numbers are never reused and files are never deleted —
   use `cancelled` / `wont-fix` instead.
4. **Collision after a merge** (two files with the same number): renumber the one created
   later to the next free number, rename its file, and update its `id` and every `related`
   list that points to it.

## Creating a document

1. Copy the matching template from `templates/`.
2. Replace every `{{...}}`. For `{{NAME: instruction}}`, follow the instruction and write the
   result. No `{{` may remain.
3. `created` and `updated` = today. `id` = `<kind>-<NNNN>`, matching the file name.
4. The first `## Log` line is `- <date> created (<initial status>)`.

## Adding a feature

When the human asks for a new feature or more scope, at any time, follow
`adding-a-feature.md` next to this file. Never turn a feature request straight into tasks.

## Required frontmatter

| Kind | Keys |
|---|---|
| feature | id, title, status, phase, ticket, created, updated, related |
| task | id, title, status, feature, ticket, created, updated, related |
| issue | id, title, status, created, updated, related |
| report | id, title, status, period, created, updated |

- `phase` (feature): a phase id from `docs/ROADMAP.md`, `backlog`, or `none` when the project has no roadmap.
- `feature` (task): the id of the feature the task belongs to, or `none`.
- `ticket`: a tracker ticket id (e.g. `FBTB-123`), or `none` when the task is not linked.
- `related`: a list of ids, e.g. `[task-0003, issue-0001]`. Link both directions.

## Tracker

{{TRACKER_RULES: bullets — tracker name and project key, how to read a ticket (MCP tool name or URL pattern), how branches and commits name a ticket (with an example); "- No tracker — this project tracks work in markdown only." if none}}

- An agent task links its ticket with `ticket: <ID>`. Several tasks may share one ticket.
- A task's `status` is the agent's own progress. Never copy it from the ticket, and never
  change a ticket's status, assignee or fields without asking the human.

## Status transitions

Change status only along these arrows. On every change: set `updated:` to today and append
`- <date> <old> → <new> — <short reason>` to the file's `## Log`.

**Feature**
- `proposed` → `approved` / `rejected` — **only the human decides**; say why when rejected
- `approved` → `in-progress` — when its first task leaves `todo`
- `in-progress` → `done` — only when every task with this `feature:` is `done` or
  `cancelled` and every acceptance box is ticked
- any status except `done` → `cancelled` — say why

Phases (when `docs/ROADMAP.md` exists): a phase is `done` only when all its features are `done` or `cancelled`.

**Task**
- `todo` → `in-progress`
- `in-progress` → `review`
- `review` → `done` — only when every acceptance-criteria box is ticked
- `review` → `in-progress` — changes needed
- `todo` / `in-progress` / `review` → `blocked` — say what blocks it; link the issue or ticket
- `blocked` → the status it had before
- any status except `done` → `cancelled` — say why

**Issue**
- `open` → `investigating` → `resolved`
- `open` / `investigating` → `wont-fix` — say why
- `resolved` → `open` — reopened

**Report**
- `draft` → `final`

## Reports

A report covers the period since the previous report (or since adoption). Collect: features and tasks moved
to `done`, tasks in progress, issues opened and resolved, decisions recorded, and next steps.
Set `period: <start> to <end>`.

## Decisions

Whenever you choose between real alternatives, record it in `{{DECISIONS_PATH}}`.
- If that is an ADR folder, copy the format and numbering of its newest file.
- If it is `docs/DECISIONS.md`, append a `D-NNNN` entry (next id = highest + 1, assigned when
  you write the entry).
- Never pre-assign an id in a task — write "record the decision in `{{DECISIONS_PATH}}`" instead.
  Never edit old entries; supersede them with a new one that names the old id.

## Project conventions

{{PROJECT_CONVENTIONS: bullets summarising the findings agents must follow when writing these documents and doing the work — branch and commit format, ticket references, review rules, the team's unwritten conventions}}
