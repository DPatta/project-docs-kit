# Adding a feature

Use when the human asks for a new capability or more scope — in the middle of a phase or after
every phase is done. A feature is a unit of scope the project delivers: a product capability,
or for example a literature review (research) or an article series (content).

The features folder is `docs/features/`, unless `SKILL.md` has a Locations section that names
another one. If that folder has its own format, follow it instead of `templates/feature.md`.
If Locations says features are not used, ask the human whether to create `docs/features/`
first. Otherwise, if the folder does not exist yet, create it before writing the first feature.

**Never invent.** Write only what the human said. Anything else is `Undecided`: ask about it,
and do not assume.

1. **Duplicate check.** Search the features folder for the same capability. If one exists,
   offer to change that feature instead. If the human agrees, go to step 8. If the request is
   to schedule or approve an existing `proposed` or `backlog` feature, go to step 4.
2. **Scope check.** Compare the request with Scope and Non-goals in `docs/PROJECT.md` (or the
   README when there is no PROJECT.md). If it conflicts, quote the conflicting line and write
   nothing until the human confirms. If they confirm:
   - record the decision (see Decisions in `SKILL.md`), saying what changed and why
   - update the Scope or Non-goals line — if `PROJECT.md` has `status: approved`, ask before
     editing it

   If they do not confirm, stop: nothing is written.
3. **Write the feature** from `templates/feature.md`, following "Creating a document" in
   `SKILL.md`:
   - `status: proposed`
   - `phase: backlog`, or `none` when there is no `docs/ROADMAP.md`
   - Impact → UI: `needs mockup` when it adds or changes a screen that has no mockup in
     `design-ui/proposals/`; the mockup path when one exists; otherwise `none`
   - Impact → Architecture: the section of `docs/design/ARCHITECTURE.md` it changes, only when
     the request makes that clear; otherwise ask, and write `Undecided` if the human does not
     know. Never guess a section.
4. **Propose a placement** and let the human choose. Skip this step when there is no
   roadmap. Offer:
   - the active phase — say how it changes that phase's exit criteria
   - the next `planned` phase
   - staying in `backlog`
   - when every phase is `done`: a new phase at the end of `docs/ROADMAP.md`, with
     `- **Status:** planned`. Propose its name and goal from the features it will hold; its exit
     criteria come only from the human, otherwise `Undecided`. The human confirms all three. Ask before editing a ROADMAP with
     `status: approved`. The new phase becomes `active` only when the human says so.
5. **The human decides.**
   - Approved → `status: approved` and the chosen `phase`.
   - Rejected → `status: rejected` and the reason.
   - Every change follows Status transitions in `SKILL.md`: set `updated:` and add a Log line.
6. **Tasks**, created only when the feature is `approved` and its phase is `active` (or there
   is no roadmap):
   - 1–6 tasks from `templates/task.md`, each with `feature: <feature id>`. If the feature's
     acceptance criteria are `Undecided`, the first task is `Decide <feature title> acceptance
     criteria`. Add the task ids
     to the feature's `related`, and the feature id to each task's `related`.
   - UI `needs mockup` → the first task designs the screen. It adds a mockup in
     `design-ui/proposals/` and an entry under Screens in `DESIGN.md`. Each build task says
     `Starts after task-NNNN` in its Notes.
   - Architecture not `none` → the matching task gets the criterion
     `- [ ] Update the <section> section of docs/design/ARCHITECTURE.md`.
7. **A phase becomes active** → ask the human before creating tasks for its `approved`
   features.
8. **Change during work.**
   - Edit the feature's Scope or Acceptance criteria, set `updated:`, and log
     `- <date> scope changed — <reason>`.
   - Add or cancel tasks to match.
   - If an alternative was rejected, record the decision.
