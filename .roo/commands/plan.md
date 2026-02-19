---
description: Create/refresh a PLAN. With no args: portfolio plan. With <epic>: epic plan.
argument-hint: [<epic-slug> [objective...]] | [<path>.md]
mode: orchestrator
---

Interpret the text after /plan:

A) If there are NO args:
   - Operate on the portfolio plan: plans/PLAN.md

B) If there IS an arg:
   - If the first arg contains "/" OR ends with ".md": treat it as an explicit plan file path
   - Else: treat first arg as epic slug and epic folder is plans/<slug>/
     - Epic plan path: plans/<slug>/PLAN.md
     - Epic state path: plans/<slug>/STATE.md
   - Any remaining text after the first arg is the optional "objective" string.

Hard rules:
- /plan MUST NOT run any git commands (no status, no diff, no branch checks).
- /plan MUST ONLY read/write markdown under plans/** (plus read directory listings).
- Minimize churn: do not rewrite existing PLAN content except for clearly-marked stub sections or top-of-file metadata.
- Never move/rename legacy files automatically.

Workflow (always):
1) Create a Code-mode subtask to write files.

Code-mode subtask behavior:

CASE A: Portfolio plan (no args)
- Ensure plans/ exists and plans/PLAN.md exists.
- Discover epics:
  - All subdirectories under plans/ (ignore hidden dirs, _* dirs if any)
  - Also detect legacy top-level epic files like plans/<name>.md (exclude PLAN.md and STATE.md)
- For each epic directory:
  - Ensure it has PLAN.md; if missing, create a minimal stub PLAN.md that links to STATE.md and lists existing docs in the folder.
  - Read plans/<epic>/STATE.md if present; extract up to 3 "Next actions" bullets if available.
- Rewrite plans/PLAN.md as a compact index:
  - List epics with links to their PLAN.md + STATE.md
  - For each epic include 1-line status + next 1–3 actions (if available)
  - Include a "Legacy plans" section listing any top-level plans/<name>.md that aren’t migrated yet, with a suggested migration target folder.

CASE B: Epic plan (slug)
- Ensure plans/<slug>/ exists.
- Ensure plans/<slug>/STATE.md exists (create stub if missing).
- Ensure plans/<slug>/PLAN.md exists:
  - If it exists: do NOT “regenerate”; only refresh clearly-stubbed header fields (Objective/Non-goals/Constraints) if they are empty/TODO.
  - If it does NOT exist: create it with:
    - Objective (use the provided objective text if present; otherwise put TODO)
    - Non-goals (TODO)
    - Constraints / invariants (TODO)
    - Docs map: list all *.md in this folder excluding PLAN.md and STATE.md
    - Decomposition rule: "If this PLAN grows > ~200 lines, split into numbered module docs and keep PLAN as the index."
    - Pointer: "Current reality lives in STATE.md"
- If a legacy file plans/<slug>.md exists:
  - Do NOT move it automatically.
  - Add a section in plans/<slug>/PLAN.md:
    - "Legacy overview: ../<slug>.md"
    - and suggest whether it should be migrated into this folder as 00-overview.md.

CASE C: Explicit plan path
- Ensure the parent directory exists.
- Create/refresh that plan file using the same "Epic plan" skeleton above, and if it lives under plans/<slug>/, ensure sibling STATE.md exists.

Return to Orchestrator with:
- What files were created/updated
- A brief summary of the plan index
- One suggested next action (usually: /resume <epic> if you’re about to work, or /save <epic> if you’re marking a checkpoint later)
