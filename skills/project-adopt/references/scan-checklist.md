# Scan Checklist

Read-only. Read files in this order and stop each item at the limit given. Never read
`node_modules/`, `vendor/`, build output, `.git/` internals, or the source tree in full.

## 1. What to read

| # | Read | Limit | Feeds topic |
|---|---|---|---|
| 1 | Top-level tree: `ls -a`, then one level into each non-hidden folder | 2 levels | structure |
| 2 | `README*` | whole file | purpose, build/test/run |
| 3 | Manifests: `package.json`, `pnpm-workspace.yaml`, `pyproject.toml`, `requirements*.txt`, `go.mod`, `go.work`, `Cargo.toml`, `pubspec.yaml`, `melos.yaml`, `Gemfile`, `pom.xml`, `build.gradle*`, `composer.json`, `Makefile`, `justfile`, `Taskfile.yml` | whole file | stack, build/test/run, structure |
| 4 | Lockfiles: presence only (`pnpm-lock.yaml`, `yarn.lock`, `package-lock.json`, `bun.lockb`, `poetry.lock`, `uv.lock`, `Cargo.lock`) | name only | stack (package manager) |
| 5 | Version pins: `.nvmrc`, `.node-version`, `.tool-versions`, `.python-version`, `engines` in `package.json` | whole file | stack |
| 6 | Lint / format / test config: `.eslintrc*`, `eslint.config.*`, `.prettierrc*`, `biome.json`, `ruff.toml`, `.editorconfig`, `analysis_options.yaml`, `jest.config.*`, `vitest.config.*`, `pytest.ini` | name + key settings | code conventions, build/test/run |
| 7 | CI: `.github/workflows/*`, `.gitlab-ci.yml`, `bitbucket-pipelines.yml` | the run steps | build/test/run |
| 8 | `CONTRIBUTING*`, `.github/PULL_REQUEST_TEMPLATE*`, `.github/ISSUE_TEMPLATE/` | whole file | git conventions, tracker |
| 9 | `docs/` tree, plus the first 20 lines of each top-level doc | 20 lines each | doc locations, purpose |
| 10 | Decision records: `docs/adr/`, `docs/decisions/`, `adr/`, `architecture/decisions/`, `ADR-*.md`, `DECISIONS.md` | names + newest file | decision records |
| 11 | AI config: `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.cursorrules`, `.cursor/rules/`, `.github/copilot-instructions.md`, `.claude/skills/*/SKILL.md` (frontmatter), `.mcp.json` | whole file | existing AI config, tracker |
| 12 | Git: `git log -50 --format='%s'`, `git branch -a --format='%(refname:short)'` (first 50) | as given | git conventions, tracker |
| 13 | Env: names of `.env*` files only; for `.env.example`, the variable names | names only — **never values** | build/test/run |
| 14 | Design docs: feature/spec folders (`docs/features/`, `docs/specs/`, `docs/rfcs/`, `docs/superpowers/specs/`, `specs/`), `ARCHITECTURE.md`, `docs/architecture*`, `docs/design/`, `DESIGN.md`, `design-ui/`, `design-system/` | names + first 20 lines | feature specs, architecture, UI design |

## 2. Topics and states

Each topic gets one row: `Topic | Finding | Evidence | State`.

| Topic | Required in AGENTS.md | If missing |
|---|---|---|
| Purpose | yes | ask (counts as `unclear`) |
| Stack (languages, frameworks, package manager, versions) | yes | `Unknown` |
| Structure (main folders; packages in a monorepo) | yes | — (always findable) |
| Build / test / run commands | yes | `Unknown` per command |
| Code conventions | no | leave out |
| Git conventions | no | leave out |
| Doc locations | no | leave out |
| Decision records | no | gap-fill offer `docs/DECISIONS.md` |
| Tracker | yes | "No tracker — markdown only"; gap-fill offer `docs/issues/` |
| Existing AI config | no | leave out |
| Related repos | no | leave out (section deleted) |
| Feature specs | no | gap-fill offer `docs/features/` |
| Architecture doc | no | gap-fill offer `docs/design/ARCHITECTURE.md` |
| User interface (has one or not; its design system) | no | with a UI and no design system: gap-fill offer `DESIGN.md` + `design-ui/` |

States:
- `clear`: one consistent source, or several that agree.
- `unclear`: a hint without confirmation (e.g. ticket-like ids in branches but no tracker
  named anywhere).
- `conflict`: sources disagree (e.g. README says `npm install` but `pnpm-lock.yaml` exists;
  `.nvmrc` says 20 while `engines` says `18.x`).
- `missing`: nothing found.

Evidence format: `path:line` for files, `git log (N/50)` or `git branch (N/50)` for git.
A finding without evidence is not `clear`.

## 3. Detection rules

**Conventional commits:** count subjects matching
`^(feat|fix|chore|docs|refactor|test|ci|build|perf|style|revert)(\(.+\))?!?: `.
≥ 70 % → `clear`; 30–70 % → `unclear`; < 30 % → no convention (leave out).

**Branch naming:** a common prefix pattern (`feature/`, `fix/`, …) in ≥ 70 % of branches →
`clear`, written as a pattern such as `feature/<KEY>-<n>-<topic>`.

**Tracker:**
| Evidence | Likely tracker | State |
|---|---|---|
| `[A-Z][A-Z0-9]+-[0-9]+` in branches or commits | Jira or Linear (same key format) | `unclear` — ask which, and confirm the key |
| Jira / Atlassian server in `.mcp.json`, or a Jira URL in docs | Jira | `clear` |
| `#[0-9]+` in commits + `.github/ISSUE_TEMPLATE/` | GitHub Issues | `clear` |
| `CU-[a-z0-9]+` in branches or commits, or a ClickUp URL | ClickUp | `clear` |
| none of these | none | `missing` |

**Monorepo:** `pnpm-workspace.yaml`, `workspaces` in `package.json`, `turbo.json`, `nx.json`,
`lerna.json`, `melos.yaml`, `go.work`, or `[workspace]` in `Cargo.toml`. Then list each package
with its path and a one-line role in the Project map.

**Existing task store:** a folder with ≥ 2 markdown files that have a status-like field or
checkbox lists (`tasks/`, `todo/`, `docs/tasks/`, `.agents/tasks/`, `backlog/`). If found, no
new store is offered; project-docs describes the existing convention.

**Overview exists:** the README has at least one sentence that says what the project does.
Then `docs/PROJECT.md` is not offered.

**Reports exist:** `docs/reports/`, `reports/`, or dated status notes in `docs/`. Then
`docs/reports/` is not offered.

**Roadmap exists:** `ROADMAP*`, `docs/roadmap*`, or a "Roadmap" heading in the README.

**Pointer state of `CLAUDE.md` / `GEMINI.md`:** a symlink to `AGENTS.md` (`ls -l`) → same file,
nothing to add. Already has an `@AGENTS.md` line → nothing to add. Otherwise → prepend.

**Spec folder exists:** one of the feature/spec folders in §1 row 14 with ≥ 1 markdown file.
Then `docs/features/` is not offered, and project-docs uses that folder (`FEATURES_DIR`).

**Architecture doc exists:** `ARCHITECTURE.md`, `docs/architecture*`, or a file in
`docs/design/`. Then `docs/design/ARCHITECTURE.md` is not offered.

**Has a UI:** a frontend dependency in a manifest (`react`, `vue`, `svelte`, `@angular/core`,
`solid-js`, `next`, `nuxt`, `flutter`, `react-native`, `expo`) or an `app/`, `pages/`,
`screens/` or `src/components/` folder with source files. `clear` only with a manifest
entry.

**Design system exists:** `DESIGN.md`, `design-ui/`, `design-system/`, or a tokens file
(`tokens.css`, `tokens.json`). Then `DESIGN.md` is not offered.

**Limits reached:** when a limit stops you from reading something that looked relevant (e.g. a
`docs/` tree with 200 files), add a findings row `Not read | <what> | <why> | missing`.

## 4. Never

- Never write values from `.env*` files, keys, tokens, passwords or connection strings.
- Never guess a command that no file shows. A missing command is `Unknown`.
- Never mark a topic `clear` from the directory name alone.
