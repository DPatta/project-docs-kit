# Upgrade mode

Brings a project set up by an older `project-kickoff` up to the current project structure.
Current structure: **2** (`templates/skills/project-docs/KIT-VERSION`). Entered from preflight
(SKILL.md step 1). Commands run in the target project. `<kickoff>` is the folder that holds
SKILL.md; paths that start with `templates/`, `references/` or `scripts/` are under
`<kickoff>`, all others are in the target project.

## Rules

- Change only what a failing checklist item names, and only after the human confirms the plan
  (step 4). Content the checklist does not name is never deleted or rewritten — including
  blocks other tools added (e.g. `<!-- BEGIN:nextjs-agent-rules -->` in AGENTS.md).
- Never commit, never change the `status:` of any document, never install anything.
- Never change a decision's text: the split (item 2) moves each entry into its own file with
  its body byte-identical.
- English only in every file; talk with the user in their language.

## Flow

### 1. Safety

- Git repo (`git rev-parse --is-inside-work-tree` succeeds): run
  `git status --porcelain -- AGENTS.md docs/DECISIONS.md docs/decisions .claude/skills`.
  If it prints anything, list those files and continue only on an explicit yes. Files it lists
  (and untracked files the plan changes) have no committed original: back them up as below.
  A global gitignore can hide untracked files from that command: also run
  `git ls-files --others --ignored --exclude-standard -- AGENTS.md docs .claude/skills`, and back
  up every file it lists that the plan changes.
  `docs/DECISIONS.md` must be committed and unchanged when item 2 runs: the self-check
  compares against `git show HEAD:docs/DECISIONS.md`. If it is not, back it up as below and
  compare against the backup.
- No git: right before step 5, copy every file that will be changed or replaced to
  `.kickoff-backup/<today>/<same relative path>` (the whole `.claude/skills/project-docs/`
  folder when item 1 changes it). Files that are only created need no backup. If that folder
  already exists, use `<today>-2`, `<today>-3`, … so an earlier backup is never overwritten.

### 2. Scan

Read-only. Run the check of every checklist item and collect the failing ones. The structure
is the number at the end of `.claude/skills/project-docs/KIT-VERSION` (`project-kickoff 1` →
1); without the file it is 1.

No failing item → tell the user the project is up to date (structure N) and write nothing.
A failing item whose only fix is "Fix by hand" (its anchor is not found) does not count: list
it again as "Fix by hand" and write nothing for it.

### 3. Questions

Ask only what the files cannot answer, one per message, at most 3:
- a merge conflict in project-docs that is not settled by the rules of item 1
- a relation between decisions that item 2 cannot settle
- which Recommended tools apply to a project skill whose purpose does not make it clear (item 4)

### 4. Plan

Show, then wait for an explicit confirmation:
- a table: file → create / change / replace, and which item
- item 1: the merged project-docs as a unified diff against the project's current folder, and
  the list of hand edits — kept, already covered by the template (dropped), or settled in
  step 3
- item 2: the decision relation table (below) and the number of decision files to write
- item 3: the AGENTS.md lines to replace and to insert, as a unified diff
- item 4: the `## Related tools` section to add to each project skill
- for each file in the table whose front matter has `status: approved`: "`<file>` is approved;
  confirming this plan allows editing it"
- the backup folder (no git)
- git: the files the plan creates that a gitignore excludes (`git check-ignore -v -- <file>`),
  with the rule and the file that holds it — they stay out of commits unless added with
  `git add -f`

The human may change any part. The plan is final once confirmed.

### 5. Apply

Make the backup (no git), then fix the failing items in checklist order.

### 6. Self-check

- item 2 ran or `docs/decisions/` exists: `bash <kickoff>/scripts/check-decisions.sh . <old log>`
  prints `PASS` (`<old log>`: `git show HEAD:docs/DECISIONS.md` saved to a temporary file, or
  the backup copy; leave it out when the project was already split). Each `WARN:` line names a
  relation the text hints at: it must be in the confirmed table, or be listed at handoff as
  not linked. Without bash (Windows), run the "Checks by hand" below instead.
- every changed file differs from its original (the backup, or `git diff`) only in the planned
  edits
- `grep -rl '{{' . --include='*.md' --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=.next --exclude-dir=dist --exclude-dir=build --exclude-dir=vendor --exclude-dir=.venv --exclude-dir=.kickoff-backup`
  lists nothing outside `.claude/skills/project-docs/`

A failure caused by content no checklist item changed is never fixed: report it under "Fix by
hand", and say at handoff that the upgrade is applied but that check still fails, quoting its
`FAIL:` lines.

### 7. Handoff

Report:
- the structure before and after, and what each applied item changed
- the backup folder (no git), and that it can be deleted once the result is reviewed; or that
  nothing was committed (git)
- the hand edits of project-docs: kept, dropped as covered by the template, or settled by the
  human
- "Fix by hand": every anchor items 3 and 4 could not place, with the exact lines to add
- relations the checker hinted at that the human chose not to link
- lines outside the checklist that still describe the old log, e.g. "entry in
  `docs/DECISIONS.md`" in a project skill or a task's criteria (`grep -rn 'DECISIONS.md'
  .claude/skills docs/tasks docs/features`, leaving out project-docs) — listed as a follow-up,
  not changed
- if the project is a git repo: `git check-ignore -v -- <every file written or changed>`, and
  for each ignored file the rule and the file that holds it (it stays out of commits unless
  added with `git add -f`)
- ask the user to `/clear` or restart any session that has this project open

## Checklist (structure 1 → 2)

Items run in this order; an item whose check passes is skipped. "Today" is the current date.

### Item 1 — project-docs

- **Check:** the project's structure is lower than the current one, and
  `diff -rq -x KIT-VERSION -x .DS_Store .claude/skills/project-docs <kickoff>/templates/skills/project-docs`
  prints anything. (After the upgrade the folder may still differ: the human's kept edits.)
- **Fix:**
  - Compare the project's folder the same way with each
    `<kickoff>/references/upgrade/project-docs-v<N>*/` (one per released template of an older
    structure). Identical to one → replace the folder with a copy of
    `templates/skills/project-docs/` without `KIT-VERSION` (item 5 writes it).
  - Identical to none → the human edited it. The base is the old copy with the fewest
    differing lines (`diff -r … | grep -c '^[<>]'`); on a tie, the newer copy. Merge each file three ways — the
    project's file, the base, the current template — with
    `git merge-file -p <project file> <base file> <template file>` (works outside a git repo;
    write its output to a temporary file outside the project; without git, merge by reading the
    three files the same way):
    - no conflict → the merged file keeps the human's edits and takes the template's changes
    - a conflict where every rule in the human's lines is also in the template's lines (e.g. a
      hand edit that applied this same structure change, in other words) → take the template's
      lines and list the human's lines as "covered by the template". In the `git merge-file`
      output that is the part between `=======` and `>>>>>>>`; drop the markers and the part
      between `<<<<<<<` and `=======`
    - any other conflict → ask (step 3): keep the human's lines, take the template's, or
      combine them as the human says
    - a file only in the template → add it; a file only in the project → keep it unchanged
  - Show the result in the plan (step 4); write it only after the confirmation.

### Item 2 — decisions

- **Check:** `docs/decisions/` does not exist, and `docs/DECISIONS.md` has an entry heading
  `## D-NNNN — <date> — <title>`. When `docs/decisions/` already exists, the item is done;
  the self-check still runs the checker, and a failure is reported under "Fix by hand".
- **Fix:** split the log into one file per entry, then turn `docs/DECISIONS.md` into the
  index.
  1. **Relations.** Build the relation table before writing anything:
     | Decision | Supersedes | Whole or part | Source |
     - **binding**: the ids in the leading clause of a `Supersedes:` bullet, up to its first
       `,`, `;` or `.` (`Supersedes: D-0010, only the hosting part` → D-0010, part;
       `Supersedes: D-0010 and D-0012; …` → both)
     - **candidate**: every other id in a `Supersedes:` bullet; every id in a bullet that
       records a change to older decisions under another label (e.g. `- **Changes:** D-0044,
       only …`); another id named with wording such as supersede, replace, amend, narrow,
       override, reverse, change or refine, in the newer entry's title or body; and a back-note
       in an older entry such as "Narrowed 2026-11-06 by D-0074" (the newer id supersedes the
       older entry). Propose a candidate as a relation only when the text says the newer entry
       changes part or all of the older one; wording that keeps it ("supersedes nothing",
       "D-0040's exceptions stand", "adds to D-0013") is no relation — list it in the table as
       "not linked" with the quote.
     - whole or part: whole only when the newer entry replaces the entire older decision;
       otherwise part ("only …", amends, narrows, replaces one rule or one sentence of it).
       Unsure → part, marked "(unsure)" in the table for the human to check in the plan; ask
       in step 3 only when the budget allows.
     Binding rows are shown; candidate rows are shown as proposals the human confirms or drops.
     Show also, quoted, the old file's text before its first entry, which the index replaces.
  2. **Files.** For each entry, oldest first, write
     `docs/decisions/D-NNNN-<slug>.md` from `templates/skills/project-docs/templates/decision.md`:
     - `<slug>`: the first 1–6 words of the title, lowercase, `[a-z0-9-]` only; delete any
       other character without replacing it (`CI/CD` → `cicd`, `D-0031's` → `d-0031s`); a
       hyphenated word counts as one; a word left empty (`—`) does not count
     - front matter: `id`, `title` in double quotes (a `"` inside written as `\"`), `date` from
       the heading, `supersedes` and `superseded-by` from the confirmed table, as
       `[D-0003, D-0007]` (ascending) or `[]`
     - `# D-NNNN — <title>`, a blank line, then the entry's body exactly as it was: every line
       after its heading up to the next entry heading, without blank lines (or lines of only
       spaces) at either end. Do
       not reword, reflow or fix anything in it.
  3. **Index.** Replace `docs/DECISIONS.md` with `templates/docs/DECISIONS.md`: `created` =
     the old file's `created`, `updated` = today, and in the table one row per file, oldest
     first: `| [D-NNNN](decisions/<file name>) | <date> | <title> | <status> |`, where status is
     `active`, `partly superseded by <ids>` or `superseded by <ids>` — `<ids>` exactly the
     file's `superseded-by`, comma-separated; partly or whole as the table says (whole when any
     superseding entry replaces it whole). A `|` in a title is written `\|`.

### Item 3 — AGENTS.md

- **Check:** any of these is true —
  - the `## Start here` item that names `docs/DECISIONS.md` does not say `decision index`
  - a `## Working rules` line says to record choices in `docs/DECISIONS.md` without
    `docs/decisions/`
  - a `## Working rules` line says `without a new entry in \`docs/DECISIONS.md\``
  - `## Working rules` lacks the line that starts `- Before a task, load every row of "Project skills"`
  - the Recommended tools intro says `Other agents can ignore this section`
- **Fix:** change only these lines, copying the new text from `templates/AGENTS.md` and
  `references/project-types.md`:
  - **Start here:** replace the text after `` `docs/DECISIONS.md` — `` on that item with the
    template's item-6 text; keep the item's number
  - **Working rules:** replace the record-choices line with the template's line
    `- Record every significant choice, and what was rejected, as a new file in \`docs/decisions/\` with a row in the index \`docs/DECISIONS.md\`.`;
    replace the dependency line with
    `- Do not add a dependency or change the stack without a new decision in \`docs/decisions/\` (and its index row).`;
    insert the template's `- Before a task, load every row …` rule (all its lines, as wrapped
    in the template) after the line
    that names `adding-a-feature.md` (else after the line that names
    `.claude/skills/project-docs/SKILL.md`)
  - **Recommended tools:** replace the intro line with
    `Installed per user — not part of this repo. Tools that are not installed are skipped (see Working rules).`
  - an anchor that is not found → leave that part as it is and list the line under
    "Fix by hand"

### Item 4 — Related tools

- **Check:** a skill in AGENTS.md → Project skills, other than `project-docs`, whose
  `SKILL.md` has no `## Related tools` heading.
- **Fix:** add the section to each listed skill. Change nothing else in the file.
  - place: before the heading that follows `## Rules`; no `## Rules` → at the end of the file
  - content: one bullet per AGENTS.md → Recommended tools row that applies when using the
    skill, ``- `<name>` — <when, in this skill's terms>`` (`<name>`: the row's Tool cell as
    written), from the row's "Use when" and the
    skill's purpose. A row applies when its "Use when" names work this skill describes; a tool
    for all code alike (a language server, a formatter) is not listed. `- None` when no row
    applies or AGENTS.md has no Recommended tools section
  - one blank line before and after the section

    ```
    ## Related tools

    - `<name>` — <when>
    ```

### Item 5 — KIT-VERSION

- **Check:** `.claude/skills/project-docs/KIT-VERSION` is missing, or its number is lower than
  the current structure.
- **Fix:** last of all, copy `templates/skills/project-docs/KIT-VERSION` there.

## Checks by hand (no bash)

When `scripts/check-decisions.sh` cannot run, check item 2's result by reading the files:
- every file is named `D-NNNN-<slug>.md`; ids run from D-0001 with no gap; each file's `id`
  matches its name; `date` is `YYYY-MM-DD`; `supersedes` and `superseded-by` are `[]` or
  `[D-NNNN, ...]`
- every heading is `# D-NNNN — <title>` with the front matter's title
- every old entry has a file with the same date and title, and its body is the same text,
  line for line
- every link is two-way: D-B in D-A's `supersedes` ⇔ D-A in D-B's `superseded-by`; a
  decision only supersedes older ids
- every `Supersedes:` bullet's binding ids (its leading clause) are in that file's `supersedes`
- the index header is `| Decision | Date | Title | Status |`; one row per file, oldest first;
  link, date and title match the file; the status ids equal the file's `superseded-by`

## Adding a structure (maintainers)

When a change to the templates changes the structure of generated projects:
1. copy each distinct released `templates/skills/project-docs/` of the previous structure to
   `references/upgrade/project-docs-v<N>…/` (from the release tags, without `KIT-VERSION`)
2. raise the number in `templates/skills/project-docs/KIT-VERSION` and in "Current structure"
   above
3. add a checklist section for the new step (check + fix per item) after the existing ones,
   and keep the earlier sections: a project runs every section from its own structure up
