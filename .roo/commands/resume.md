---
description: Resume an epic from plans/*/PLAN.md + STATE.md and propose next subtasks
argument-hint: [<epic-slug>|<plan-path>]
mode: orchestrator
---

Interpret the argument after /resume:

- If no argument: plan = plans/PLAN.md, state = plans/STATE.md
- If argument contains "/" or ends with ".md": treat it as a plan file path
- Else: treat it as an epic slug and plan = plans/<slug>/PLAN.md, state = plans/<slug>/STATE.md

Git policy (hard rules):

- Any git inspection MUST be done via EXACTLY ONE shell command, using `&&` to chain.
- Prefer git-only (no grep/sed/awk/echo) so it plays nicely with allowlists.

Repo snapshot command (reports code vs plans/** in one shot):

git rev-parse --abbrev-ref HEAD \
&& git status --porcelain=v1 -- . ':(exclude)plans/**' \
&& git status --porcelain=v1 -- plans/** \
&& git diff --stat -- . ':(exclude)plans/**' \
&& git diff --staged --stat -- . ':(exclude)plans/**' \
&& git diff --stat -- plans/** \
&& git diff --staged --stat -- plans/**

Workflow:
1) Create a Code-mode subtask.
2) In the subtask:
   - Read the plan + state files (if state missing, say so and proceed).
   - Identify the most recent saved checkpoint by:
     - Prefer the ROO_STATE block's "Save-id" / "Updated" fields if present.
     - Otherwise: use the LAST entry in the `## Log` section (file order is canonical).
   - Run EXACTLY ONE repo snapshot command (above) and capture its output verbatim.
   - Output:
     - "Where we left off" (<=10 bullets; prefer STATE over guessing)
     - "Last save marker" (Save-id + Updated + last log line if present)
     - "Repo reality" with two explicit lines:
       - Code reality (excluding plans/**): clean/dirty + key paths
       - Plans reality (plans/**): clean/dirty + key paths
     - Next 2–4 subtasks as a checklist, each with:
       - mode (Code / Debug / Architect)
       - exact scope (paths/commands)
       - success criteria

Return and wait for the user to pick a subtask.
