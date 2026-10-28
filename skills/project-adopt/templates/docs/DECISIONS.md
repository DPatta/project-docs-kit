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

## D-0001 — {{DATE}} — Adopted AI-readable project docs

- **Decision:** {{ADOPT_DECISION: one or two sentences — AGENTS.md map added, the agent task store chosen, gap fills created, AI pointer files}}
- **Why:** {{ADOPT_WHY: reasons the user gave; "Not stated" if none}}
- **Rejected:** {{ADOPT_REJECTED: options declined in steps 3–4 and why; "None discussed" if none}}
