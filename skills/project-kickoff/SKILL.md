---
name: project-kickoff
description: Use when starting a brand-new project of any type (software, research, content/writing, personal) and the user wants it set up so any AI can pick it up — project brief, roadmap and phases, stack/methods/style/resources doc, task/issue/report files with status, AGENTS.md (plus CLAUDE.md / GEMINI.md pointers) and project skills. Do NOT use on other projects that already have AGENTS.md, CLAUDE.md or docs/PROJECT.md (use project-adopt).
---

# Project Kickoff

Sets up a new project with a documentation set that lets any AI agent understand the project
from `AGENTS.md` alone. Templates are in `templates/` next to this file; per-type differences
are in `references/project-types.md`.

## Hard rules

- **Never overwrite.** Before writing any file, check that it does not exist. If it does, skip
  it and report it at handoff.
- **Never invent.** Anything the user did not provide or answer is written as `Undecided` and
  gets a `Decide <topic>` task. The only exceptions: the name and goal of each phase, phase-1
  included, when the brief does not state them (proposed from the type's typical phases and
  shown as proposed in step 5), the
  `ui-design-system` feature, optional fallbacks such as `Not designed yet`, and the one shared
  `Decide phase-1 features` task — see steps 3, 5 and 6. A common default is not an answer — see step 3.
- **English only** in every generated file — names, frontmatter and body. Talk with the user in
  whatever language they use.
- **No git commits** unless the user says yes at handoff.
- **No files before approval.** Nothing is written before the user confirms the summary in step 5.

## Workflow

### 1. Preflight

Target directory = the current working directory, unless the user names another one.

Stop immediately and write nothing if any of these exist in the target: `AGENTS.md`,
`CLAUDE.md`, `docs/PROJECT.md`. Tell the user that project-kickoff only sets up new projects
and never overwrites, then the first case that applies:
- `AGENTS.md` contains `managed-by: project-adopt` → it was already set up by project-adopt,
  which has no refresh mode yet.
- the target has `.claude/skills/project-docs/SKILL.md` → it was already set up by
  project-kickoff; there is nothing to set up.
- otherwise → the project already has documentation; use the project-adopt skill instead.

If `docs/` exists but `docs/PROJECT.md` does not, stop and ask whether `docs/` belongs to
something else and whether to continue. Continue only on an explicit yes.

Anything else (empty folder, `.git`, a short `README.md`, source files) → continue.

### 2. Receive the brief

Ask the user to give everything they have in one message: a description, notes, requirement
files, links, chat excerpts. Read any files or links they point to.

### 3. Gap analysis

Map the brief onto this checklist:

| # | Item | Goes to | If missing |
|---|---|---|---|
| 1 | Project type: Software / Research / Content / Other | PROJECT.md, picks the type doc | ask |
| 2 | Project name | everywhere | ask |
| 3 | Goals | PROJECT.md | ask |
| 4 | Success criteria | PROJECT.md | ask |
| 5 | Non-goals | PROJECT.md | ask |
| 6 | Phase 1 features | `docs/features/`, initial tasks | ask |
| 7 | Type-doc gap questions (see `references/project-types.md`) | type doc | ask |
| 8 | Users / beneficiaries | PROJECT.md | ask |
| 9 | Scope | PROJECT.md | derive from brief; ask only if unclear |
| 10 | Later phases | ROADMAP.md | propose from the type's typical phases; confirmed in step 5 |
| 11 | Problem / motivation | PROJECT.md | restate the need behind the brief's stated purpose, adding nothing; else `Undecided` |
| 12 | Constraints | PROJECT.md | `None stated` |

Rules:
- **Skip every item the brief already answers unambiguously** (e.g. "a web app in Next.js" →
  type Software, framework Next.js). Skipped items cost no question; show the derived value in
  the step-5 summary so the user can correct it.
- **Answered means stated.** An item or field counts as answered only when the brief states it
  or it follows necessarily from what is stated. A common default is not an answer: TypeScript
  for Next.js, CI from the hosting provider, an auth method, a coverage threshold, standard
  setup features. Such a value is `Undecided`, or an option offered in a question.
  Stated values are carried over without added detail — see "Filling templates" in step 6.
- **Goals (item 3)** are answered when the brief states what the project is for ("a web app
  for groups of friends to split travel expenses" → `Let groups of friends split travel
  expenses.`). Write only what it states, as few bullets as that gives. A feature or MVP list
  is scope, not a goal.
- One question per message; multiple choice when possible.
- **At most 7 questions in total.** Ask in table order. When the budget is used up, every
  remaining gap becomes `Undecided`.
- "I don't know" / "not decided yet" is a valid answer → `Undecided`. Do not push.
- Type-doc fields that are neither in the brief nor covered by a gap question (e.g. Testing
  in STACK.md) are written as `Undecided` without asking — they still get a Decide task.
- A template fallback other than `Undecided` (`None stated`, `Not stated`, `None yet`,
  `Not set up yet`) marks an optional field: write it as given, with no Decide task.
- Whenever the user rejects an alternative during the conversation, note it and the reason —
  it goes into D-0001 "Rejected".
- Phase 1 = the type's first typical phase, unless the brief clearly starts later (e.g. the
  setup is already done). Phase names may be adapted to the project.
- A **feature** is a unit of scope the project delivers: a product capability, or e.g.
  "Project setup" in a Foundation phase. Each item the brief or an answer lists becomes one
  feature, in its own words.
- Features the brief gives for a later phase (e.g. "MVP: …" when phase 1 is Foundation)
  belong to that phase and do not answer item 6. Item 6 is then still asked; offer your
  proposed phase-1 features as the options, plus "I don't know yet".
- **Has a UI:** a Software project has a user interface when the brief states a web, mobile
  or desktop app or a user-facing screen. Otherwise the UI gap question in
  `references/project-types.md` asks it.

### 4. Setup choices (not counted in the 7-question budget)

Ask these questions, one per message, even when the gap budget is used up:

1. **AI tools** (multi-select): Claude, Gemini, Codex, Cursor, none. Skip if the brief already
   says. Decides the pointer files in step 6.
2. **Project skills:** pick the 2–4 most relevant skills from the type's "Typical skills" and
   the brief (adapt names to the project if useful). For each: kebab-case name, one-line
   purpose, why this project needs it. The user picks any number, including none.
   `project-docs` is always installed and is not part of the suggestion.
3. **Stack tools:** per `references/stack-tools.md` — only for Software projects where Claude
   was selected and at least one STACK.md value comes from the brief or an answer. Up to 6
   installed or installable skills, agents, plugins and MCP servers matching those values;
   the user picks reference, install or skip for each.

### 5. Summary for approval

Show, in the user's language:
- the full file tree to be created
- PROJECT.md essentials: name, type, goals, non-goals, success criteria
- phases, with phase-1 marked active and every phase name or goal the brief does not state
  marked `(proposed)`, and the features of each phase
- the initial task list (number + title)
- design docs: `docs/design/ARCHITECTURE.md` (Software), and the UI set `DESIGN.md` +
  `design-ui/` with its `ui-design-system` feature (projects with a user interface)
- values derived from the brief without asking (so the user can correct them)
- all `Undecided` items
- pointer files and selected skills
- stack tools: each chosen tool with reference / install, and the exact command of every install

Revise until the user explicitly confirms. Do not write any file before that.

### 6. Generate

`DATE` = today, `YYYY-MM-DD`. Write in this order, checking first that each path does not exist:

1. `docs/PROJECT.md` ← `templates/docs/PROJECT.md`
2. `docs/ROADMAP.md` ← `templates/docs/ROADMAP.md` (phase-1 `active`, later phases `planned`).
   Each phase's name and goal come from the brief when it states them; otherwise they are
   proposed from the type's typical phase (confirmed in step 5). A label the brief puts on a
   list ("MVP: …") states that phase's name, not its goal. A proposed goal says what the
   phase is for, in general terms (e.g. Foundation: `Set up the project so features can be
   built.`); it never adds features or thresholds. Later phases' exit criteria come only from
   the brief or answers. Otherwise they are `Undecided` **without** a Decide task; they are
   settled when that phase becomes active.
3. `docs/<TYPE-DOC>.md` ← the type's template only
4. `docs/features/` ← `templates/skills/project-docs/templates/feature.md`:
   - one file per feature confirmed in step 5, numbered from `0001` in phase order
   - each has `status: approved`, its `phase:` and `ticket: none`
   - `WHY` = "Listed in the kickoff brief." or "Answer to a kickoff question.", plus the
     reason if one was given
   - `GOAL`, `IN` and `CRITERIA` use the brief's or the answer's own words (one criterion per
     stated outcome, e.g. `- [ ] Create a trip`); `OUT` = `Not stated` unless an exclusion
     applies to this feature
   - Impact → UI = `needs mockup` when the project has a UI and the feature is something a
     user does on screen, otherwise `none`; Impact → Architecture = `Undecided` (settled
     when its tasks are created) — neither gets a Decide task
   - `related` lists the feature's tasks, and each task's `related` lists its feature
   - if phase-1 features or phase-1 exit criteria are `Undecided`, they share one task,
     `Decide phase-1 features` (`feature: none`)
   - with a UI, `feature-0001` is `ui-design-system`, written exactly as in
     "The ui-design-system feature" below
   - no features at all → `docs/features/.gitkeep`
5. Software only: `docs/design/ARCHITECTURE.md` ← `templates/docs/design/ARCHITECTURE.md`,
   with `EMPTY` = `Not designed yet` (an optional field: no Decide task)
6. Projects with a user interface only. If `DESIGN.md` already exists, skip this whole item
   and the `ui-design-system` feature, and report it at handoff:
   - `DESIGN.md` ← `templates/DESIGN.md` (`EMPTY` = `Not designed yet`)
   - `design-ui/README.md` ← `templates/design-ui/README.md`
   - `design-ui/tokens.css` ← `templates/design-ui/tokens.css` (verbatim)
   - `design-ui/proposals/.gitkeep`
7. `docs/DECISIONS.md` ← `templates/docs/DECISIONS.md` (D-0001 records the kickoff decisions)
8. `docs/tasks/` ← `templates/skills/project-docs/templates/task.md`:
   - first, one `Decide <topic>` task per `Undecided` item (no cap; never merge them), each
     with `feature: none`, in this order: PROJECT.md items, then the type doc's areas in its
     table order, then `Decide phase-1 features`. `<topic>` is the item or area name as the
     doc writes it, lowercased (`Decide testing`, `Decide data / storage`)
   - then 2–6 tasks for the phase-1 features, each with `feature:` set to its feature.
     When the brief's phase-1 features are `Undecided`, only `ui-design-system` (if any)
     gets tasks — the `Decide phase-1 features` task covers the rest.
   - numbered from `0001`, all `status: todo`, `ticket: none`
   - acceptance criteria may say "add an entry to docs/DECISIONS.md" but never pre-assign a
     `D-NNNN` id
   - a `Decide …` task about a stack area also gets the criterion in `references/stack-tools.md` §10
9. `docs/issues/.gitkeep` and `docs/reports/.gitkeep` (empty files)
10. `.claude/skills/project-docs/` ← copy `templates/skills/project-docs/` **verbatim**
    (`SKILL.md`, `adding-a-feature.md`, `KIT-VERSION` and `templates/`). Do not fill its
    placeholders; they are for later use.
11. `.claude/skills/<name>/SKILL.md` for each selected skill ← `templates/skills/skill-skeleton.md`
12. `AGENTS.md` ← `templates/AGENTS.md` (`TOOL_ROWS` per `references/stack-tools.md` §9;
    `DESIGN_DOCS` lists the design docs written in items 5–6)
13. `CLAUDE.md` if Claude was selected, `GEMINI.md` if Gemini was selected — copy verbatim.
    Codex and Cursor read `AGENTS.md` directly and need no file.
14. **Stack tool installs**, if any were approved — per `references/stack-tools.md` §6–§8.
    This is the only step that writes outside the target directory.

**The ui-design-system feature** (projects with a user interface; the only feature not taken
from the brief):
- title `UI design system`, `phase: phase-1`
- Why: `The project has a user interface; project-kickoff adds this feature so screens are built from an agreed design.`
- Goal: `An agreed look and feel, recorded in DESIGN.md and design-ui/tokens.css, that every screen is built from.`
- Scope In: `Design proposals, the chosen look, design tokens.` Out: `Building screens.`
- Criteria:
  - `- [ ] 2–4 proposals in design-ui/proposals/, plus design-ui/proposals/index.html to compare them`
  - `- [ ] The human picks one; the others are marked superseded`
  - `- [ ] DESIGN.md and design-ui/tokens.css are filled from the chosen proposal`
  - `- [ ] The choice is recorded in docs/DECISIONS.md`
- Impact: UI `needs mockup`, Architecture `none`
- Its tasks (counted in the 2–6):
  - `Create UI design proposals` (file topic `create-ui-design-proposals`)
  - `Fill DESIGN.md and tokens.css from the chosen proposal` (file topic
    `fill-design-md-tokens-css`)

**Filling templates**
- `{{NAME}}` → the value. `{{NAME: instruction}}` → follow the instruction and write the result.
- **Content comes only from the brief and the answers.** Translate and reshape it, but add
  nothing: no fields, roles, flows, numbers or qualifiers the brief does not give.
  "MVP: create a trip, add expenses, see who owes whom" → `Create a trip`, `Add expenses`,
  `See who owes whom` — not "Create a trip with named participants" or "Add expenses with
  payer and amount". A template asking for "2–5 bullets" or "concrete" outcomes never
  justifies padding; write fewer bullets instead.
- Shared values: `{{DATE}}`, `{{PROJECT_NAME}}`, `{{TITLE}}`, `{{NUMBER}}` (4-digit, zero-padded).
- `EMPTY` (the empty-section fallback in DESIGN.md and ARCHITECTURE.md) → `Not designed yet`.
- If an instruction says to delete the line when there is no value, delete the whole line.
- No `{{` may remain in any generated file outside `.claude/skills/project-docs/`.

**File names** for features, tasks, issues and reports: `<kind>-<NNNN>-<kebab-topic>-<DATE>.md`.
`kebab-topic` = 2–5 lowercase English words from the title, joined by `-`, `[a-z0-9-]` only:
delete any other character without replacing it (`CI/CD` → `cicd`); a hyphenated word keeps
its hyphen and counts as one word (`Decide phase-1 features` → `decide-phase-1-features`).
Example: `docs/tasks/task-0001-decide-hosting-provider-2026-10-24.md`.

**Self-check before handoff**
- `grep -rl '{{' . --include='*.md'` lists only files under `.claude/skills/project-docs/`.
- Every `Undecided` in PROJECT.md, the type doc, phase-1 of ROADMAP.md and the phase-1
  features (their Impact excepted) has a matching `Decide …` task, and is listed under 'Open questions' in
  PROJECT.md.
- Every value in the type doc and phase-1 is either in the brief, in an answer, or `Undecided`.
- Re-read PROJECT.md (Summary, Goals, Scope) and every feature file against the brief:
  each specific detail (field, role, flow, number) appears in the brief or an answer. Remove
  any that do not.
- Exactly one phase in ROADMAP.md has `- **Status:** active`.
- Every feature comes from the brief or an answer, in its words — except `ui-design-system`.
- ROADMAP.md has no `Deliverables` line. Every task's `feature:` names a file in
  `docs/features/`, or is `none`.
- No token, key or other secret value appears in any file written or command run.

### 7. Handoff

Report:
- files created, and files skipped with the reason
- `Undecided` items and their tasks
- stack tools: installed / failed / referenced, with follow-ups (reload plugins, commands the
  user must run with their own key)
- next steps: (1) review PROJECT.md, ROADMAP.md, the type doc and any design docs, then set
  `status: approved`, and check that the features match what you want; (2) fill in the draft skill skeletons; (3) start with `task-0001`;
  (4) for any new feature, follow `.claude/skills/project-docs/adding-a-feature.md`

If the target is a git repository (`git rev-parse --is-inside-work-tree` succeeds), ask whether
to commit. Never commit without a yes.
