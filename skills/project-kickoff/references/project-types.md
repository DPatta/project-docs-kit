# Project Types

Pick exactly one type at kickoff. Each type defines: the type doc, its purpose line (for
AGENTS.md), extra gap questions, working rules (for AGENTS.md), typical project skills to
suggest, and typical phases to propose.

## Software

- **Type doc:** `docs/STACK.md` — template `templates/docs/STACK.md`
- **Purpose line:** languages, frameworks, infrastructure and tooling, with the reasons for each choice
- **Gap questions** (only if the brief does not answer them):
  - Main language / framework? — skip it when the brief names either one; the one it does not
    name is `Undecided` with a Decide task, without a question (Next.js stated → Language
    `Undecided`, not TypeScript)
  - Where will it run or be hosted?
  - Does it have a user interface (web, mobile or desktop screens)? — only if the brief does not say
- **Working rules:**
  - Run the project's tests and linters before moving a task to `review`.
  - Do not add a dependency or change the stack without a new entry in `docs/DECISIONS.md`.
  - Keep secrets out of the repository; document required environment variables in `docs/STACK.md`.
- **Typical skills:** `coding-conventions`, `testing-workflow`, `release-checklist`, `api-contract`
- **Typical phases:** Foundation → MVP → Hardening → Launch

## Research

- **Type doc:** `docs/METHODS.md` — template `templates/docs/METHODS.md`
- **Purpose line:** research questions, methodology, data sources and tools
- **Gap questions:**
  - What are the research questions?
  - Which methods (literature review, survey, interviews, experiment, data analysis)?
- **Working rules:**
  - Cite every source; never state a finding without one.
  - Keep findings (what the data says) separate from interpretation (what we think it means).
  - Never modify raw data; derived data goes in a separate file.
- **Typical skills:** `source-citation`, `literature-review`, `data-analysis-workflow`
- **Typical phases:** Scoping → Data collection → Analysis → Write-up

## Content / Writing

- **Type doc:** `docs/STYLE.md` — template `templates/docs/STYLE.md`
- **Purpose line:** audience, voice and tone, formats, channels and tools
- **Gap questions:**
  - Who is the audience?
  - Which channels and how often?
- **Working rules:**
  - Follow the voice and tone in `docs/STYLE.md` for every piece.
  - Each piece of content is its own task; publishing is part of its acceptance criteria.
  - Fact-check claims and record sources in the task's Notes.
- **Typical skills:** `writing-style`, `content-brief`, `publishing-checklist`
- **Typical phases:** Strategy → Production → Publishing → Review

## Other / Personal

Use when no other type fits (events, personal goals, learning plans, home projects, ...).

- **Type doc:** `docs/RESOURCES.md` — template `templates/docs/RESOURCES.md`
- **Purpose line:** tools, people, budget, time and constraints
- **Gap questions:**
  - Deadline or time available per week?
  - Budget, if any?
- **Working rules:**
  - Check budget and time limits in `docs/RESOURCES.md` before proposing new work.
- **Typical skills:** `weekly-review`, `checklist`
- **Typical phases:** Planning → Execution → Wrap-up
