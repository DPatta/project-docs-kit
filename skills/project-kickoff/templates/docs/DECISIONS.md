---
title: Decision Log
created: {{DATE}}
updated: {{DATE}}
---

# Decision Log

One file per decision in `docs/decisions/`, named `D-NNNN-<slug>.md`. This file is the index:
read it, then open only the decisions that touch your work.

Rules:

- Next id = highest `D-NNNN` in the table + 1, assigned when the file is written.
- Never rewrite an entry. A change is a new entry whose `supersedes` lists the old id; then add
  the new id to the old file's `superseded-by` (the only edit allowed in an old file) and update
  the old row's status here.
- Every new decision adds one row to the table below, oldest first. Adding or changing a
  row sets `updated:` above to today.

Decision file format (template: `.claude/skills/project-docs/templates/decision.md`):

```markdown
---
id: D-NNNN
title: "<title>"
date: YYYY-MM-DD
supersedes: []        # ids this entry replaces in whole or in part
superseded-by: []     # ids of later entries that replace this one
---

# D-NNNN — <title>

- **Decision:** what was chosen
- **Why:** the reason
- **Rejected:** alternatives considered and why not
- **Supersedes:** D-xxxx, only <the part> (optional)
```

Status: `active`; `partly superseded by D-yyyy` when the later entry replaces only a part (its
Supersedes line says "only …", or it amends or narrows a part); `superseded by D-yyyy` when it
replaces the whole entry. With several ids, list them as in `superseded-by`, comma-separated.

| Decision | Date | Title | Status |
|---|---|---|---|
| [D-0001](decisions/D-0001-project-kickoff.md) | {{DATE}} | Project kickoff | active |
