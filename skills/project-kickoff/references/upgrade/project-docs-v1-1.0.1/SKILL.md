---
name: project-docs
description: Use whenever creating or updating anything in docs/ of this project — a new feature, task, issue or report, changing any status, finishing a phase, or logging a decision. Defines file naming, numbering, required frontmatter and allowed status transitions; new feature requests follow adding-a-feature.md.
---

# Project Docs

Rules for every document under `docs/`. Templates are in `templates/` next to this file.
All documents are written in English.

## File naming

`docs/<kind>s/<kind>-<NNNN>-<kebab-topic>-<YYYY-MM-DD>.md`

- `<kind>`: `feature`, `task`, `issue` or `report`
- `<NNNN>`: 4-digit zero-padded run number, starting at `0001`
- `<kebab-topic>`: 2–5 lowercase English words, characters `[a-z0-9-]` only; delete any other character without replacing it (`CI/CD` → `cicd`); a hyphenated word keeps its hyphen and counts as one word (`Decide phase-1 features` → `decide-phase-1-features`)
- `<YYYY-MM-DD>`: creation date — never changes, even when the file is updated

Example: `docs/tasks/task-0007-add-login-form-2026-11-02.md`

## Next number

1. List the kind's folder: `ls docs/tasks/` (or `docs/features/`, `docs/issues/`, `docs/reports/`).
2. Take the highest `NNNN` among the `.md` files (ignore `.gitkeep` and anything else) and
   add 1. No `.md` files → `0001`.
3. Each kind has its own sequence. Numbers are never reused and files are never deleted —
   use `cancelled` / `wont-fix` instead.

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
| core doc (PROJECT, ROADMAP, STACK / METHODS / STYLE / RESOURCES, docs/design/ARCHITECTURE, DESIGN) | title, status, created, updated |

`phase` (feature): a phase id from `docs/ROADMAP.md`, `backlog` when not placed yet, or `none`
when the project has no roadmap.

`feature` (task): the id of the feature the task belongs to, or `none` (decisions, chores,
bug fixes). A task's phase is its feature's phase.

`related` is a list of ids, e.g. `[task-0003, issue-0001]`. Link both directions.

`ticket` is a tracker ticket id (e.g. `FBTB-123`), or `none` when the task is not linked.

## Status transitions

Change status only along these arrows. On every change: set `updated:` to today and append
`- <date> <old> → <new> — <short reason>` to the file's `## Log`.

**Feature**
- `proposed` → `approved` / `rejected` — **only the human decides**; say why when rejected
- `approved` → `in-progress` — when its first task leaves `todo`
- `in-progress` → `done` — only when every task with this `feature:` is `done` or
  `cancelled` and every acceptance box is ticked
- any status except `done` → `cancelled` — say why

**Task**
- `todo` → `in-progress`
- `in-progress` → `review`
- `review` → `done` — only when every acceptance-criteria box is ticked
- `review` → `in-progress` — changes needed
- `todo` / `in-progress` / `review` → `blocked` — say what blocks it; link the issue if any
- `blocked` → the status it had before
- any status except `done` → `cancelled` — say why

**Issue**
- `open` → `investigating` → `resolved`
- `open` / `investigating` → `wont-fix` — say why
- `resolved` → `open` — reopened

**Core doc**
- `draft` → `approved` — **only the human approves**
- `approved` → `outdated` — when reality no longer matches the doc
- `outdated` → `draft` — rewrite in progress
- Never edit a doc with `status: approved` without asking the human first.

**Phase** (the `- **Status:**` line of each phase in `docs/ROADMAP.md`)
- `planned` → `active` → `done`. Exactly one phase is `active`.
- Before marking a phase `done`, all its features must be `done` or `cancelled`. Then set
  the next phase to `active` and ask the human before creating tasks for its `approved`
  features.

**Report**
- `draft` → `final`

## Reports

A report covers the period since the previous report (or since kickoff). Collect: features and tasks moved
to `done`, tasks in progress, issues opened and resolved, decisions added to
`docs/DECISIONS.md`, and next steps. Set `period: <start> to <end>`.

## Decisions

Whenever you choose between real alternatives, append a `D-NNNN` entry to `docs/DECISIONS.md`
(next id = highest + 1, assigned at the moment you write the entry). Never pre-assign a
`D-NNNN` id in a task or elsewhere — write "add an entry to docs/DECISIONS.md" instead. Never
edit old entries — supersede them with a new entry that names the old id.
