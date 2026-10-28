---
title: Roadmap
status: draft
created: {{DATE}}
updated: {{DATE}}
---

# Roadmap

Each phase has a status: `planned` → `active` → `done`. Exactly one phase is `active` at a time.
A phase's scope is its features: `grep -l "phase: <phase id>" docs/features/*.md`.
Features not placed in a phase yet have `phase: backlog`. A phase is `done` only when all its
features are `done` or `cancelled`.

## phase-1: {{PHASE_1_NAME: short name, e.g. Foundation}}

- **Status:** active
- **Goal:** {{PHASE_1_GOAL: one sentence}}
- **Exit criteria:** {{PHASE_1_EXIT: how we know this phase is done; Undecided if not known}}

{{FURTHER_PHASES: repeat the phase block above for phase-2, phase-3, … with "- **Status:** planned"; delete this line if there are no further phases}}
