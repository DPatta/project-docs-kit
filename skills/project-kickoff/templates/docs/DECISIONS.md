---
title: Decision Log
created: {{DATE}}
updated: {{DATE}}
---

# Decision Log

Append-only, newest at the bottom. Never rewrite an entry — add a new one that supersedes it
and write `Supersedes: D-NNNN` in it. Next id = highest `D-NNNN` + 1.

Entry format:

- **Decision:** what was chosen
- **Why:** the reason
- **Rejected:** alternatives considered and why not

## D-0001 — {{DATE}} — Project kickoff

- **Decision:** {{KICKOFF_DECISION: one or two sentences — project type, main tools/stack, AI tools used}}
- **Why:** {{KICKOFF_WHY: reasons the user gave; "Not stated" if none}}
- **Rejected:** {{KICKOFF_REJECTED: alternatives mentioned during kickoff and why they were dropped; "None discussed" if none}}
