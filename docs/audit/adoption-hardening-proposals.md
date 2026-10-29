# Proposed Adoption Audit & Hardening Checks

> **Status: proposals, not confirmed vulnerabilities.** These are test hypotheses for contributors to validate. Do not report any item as an established defect without reproduction evidence.

This document groups five independent audit work items. Each should be validated separately, with test evidence and a targeted follow-up fix only if needed.

## P1 — Approval Gates

### Description
Confirm explicit approval is required before writing files or installing dependencies.

### Reproduction / Test Scenarios
1. Run adoption with a fixture and decline a proposed file write.
2. Trigger a missing-tool path and decline installation.
3. Approve each operation and compare effects.

### Acceptance Criteria
- [ ] No write or install before explicit approval.
- [ ] Denial leaves project and environment unchanged.
- [ ] Prompts identify exact planned changes.
- [ ] Automated tests cover approve/deny/error paths.

## P1 — Secret Leakage

### Description
Evaluate exposure of synthetic secrets during project adoption.

### Reproduction / Test Scenarios
1. Plant fake secrets in .env, ignored config and source fixtures.
2. Run adoption and inspect generated docs, terminal output, logs and Git diffs.
3. Trigger errors and check diagnostic output.

### Acceptance Criteria
- [ ] Synthetic secrets never appear in outputs or artifacts.
- [ ] Sensitive inputs are skipped or redacted.
- [ ] Error paths preserve protections.
- [ ] Regression tests document boundaries.

## P1 — Non-destructive Adoption

### Description
Verify existing user files remain intact unless explicitly authorized.

### Reproduction / Test Scenarios
1. Create conflicting documentation and config files.
2. Run adoption with target path collisions.
3. Decline replacement and compare hashes; simulate partial failure.

### Acceptance Criteria
- [ ] Existing files preserved by default.
- [ ] Conflicts prompt safe skip/merge choices.
- [ ] Denied and failed operations do not destroy user content.
- [ ] Tests verify preservation.

## P2 — Idempotency & Edge Cases

### Description
Check repeatability and unusual repository states.

### Reproduction / Test Scenarios
1. Run adoption twice and compare diffs.
2. Exercise symlinks inside/outside repo.
3. Run with dirty worktree and untracked files.
4. Create task-number collisions and rerun.

### Acceptance Criteria
- [ ] Repeated runs produce no unintended changes or duplicates.
- [ ] No writes escape repository via symlinks.
- [ ] Dirty changes remain intact.
- [ ] Collisions resolve deterministically without loss.
- [ ] Tests cover each scenario.

## P2 — Git Commit Approval

### Description
Ensure Git commit requires independent explicit authorization.

### Reproduction / Test Scenarios
1. Approve file writes but decline commit.
2. Inspect Git history and index after denial.
3. Approve a separate commit prompt and inspect scope.
4. Test noninteractive/error paths.

### Acceptance Criteria
- [ ] Write approval does not imply commit approval.
- [ ] No commit without explicit authorization.
- [ ] Prompt shows proposed files and message.
- [ ] Tests cover independent consent and denial.
