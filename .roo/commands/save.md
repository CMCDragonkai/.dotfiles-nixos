---
description: Save progress into plans/*/STATE.md (durable snapshot for resuming later)
argument-hint: [<epic-slug>|<state-path>]
mode: orchestrator
---

Interpret the argument after /save:

- If no argument: target file is plans/STATE.md
- If argument contains "/" or ends with ".md": treat it as a file path (relative to repo root)
- Else: treat it as an epic slug and target file is plans/<slug>/STATE.md

Git policy (hard rules):

- Any git inspection MUST be done via EXACTLY ONE shell command, using `&&` to chain.
- Prefer git-only (no grep/sed/awk/echo) so it plays nicely with allowlists.
- Run the git snapshot at most ONCE, BEFORE writing STATE.md. Do NOT re-run after modifying plans/**.

Default repo snapshot command (code reality excluding plans/**):

git rev-parse --abbrev-ref HEAD \
&& git status --porcelain=v1 -- . ':(exclude)plans/**' \
&& git diff --stat -- . ':(exclude)plans/**' \
&& git diff --staged --stat -- . ':(exclude)plans/**'

Log/time policy (hard rules):

- Every save MUST append a log entry with a stable ordering key for same-day multiple saves.
- Log prefix format:
  - `YYYY-MM-DD (n=NN)` where NN is 01, 02, 03… for that date in that file
  - Optionally include RFC3339 utc timestamp with offset: `YYYY-MM-DDTHH:MM:SS+08:00`
- If a precise time is unavailable, OMIT the time but still include `(n=NN)` so ordering remains unambiguous.

How to compute NN:
- Let `today = YYYY-MM-DD` (UTC).
- Count existing log entries that start with `- {today}` in the `## Log` section.
- NN = count + 1, zero-padded to 2 digits.

Workflow:
1) Create a Code-mode subtask to "materialize state".
2) In the Code subtask:
   - Ensure the target directory exists.
   - Create the STATE file if missing.
   - Determine:
     - `today` = YYYY-MM-DD (UTC)
     - `seq` = NN (as computed above)
     - `timestamp` = RFC3339 utc time (if available; else empty)
   - Run EXACTLY ONE git snapshot command (above) and capture its output verbatim.
   - Update/overwrite only the block between markers:

<!-- ROO_STATE_BEGIN -->
## Current state
- Updated: <RFC3339 utc time if available, else "{today} (n={seq})">
- Save-id: {today} (n={seq})
- Objective:
- Repo reality (excluding plans/**):
  - (paste the git snapshot output verbatim; keep as-is)
- What changed since last save (files + 1 line each; focus on non-plans changes):
- Verification (commands + results; write NOT RUN if not run):
  - <the git snapshot command> => <PASTE OUTPUT OR NOT RUN>
- Risks / unknowns:
- Next actions (max 5):
  1.
  2.
  3.
<!-- ROO_STATE_END -->

   - Append (or create) a "## Log" section with a short entry in this format:

     - {timestamp if available else today} (n={seq}) — <what happened>; next: <next action>

   - IMPORTANT: /save must NOT perform git add/commit. If a checkpoint is desired, recommend running /commit next.

3) Return to Orchestrator with:
   - 5–10 bullet summary
   - the single next action you recommend doing first (concrete file/command; often "/commit")
