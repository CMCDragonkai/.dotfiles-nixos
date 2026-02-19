---
description: Quick mid-session situation report into plans/*/STATE.md
argument-hint: [<epic-slug>|<state-path>]
mode: orchestrator
---

Same argument rules as /save for choosing the target STATE file.

Git policy (hard rules):

- Any git inspection MUST be done via EXACTLY ONE shell command, using `&&` to chain.
- Prefer git-only (no grep/sed/awk/echo) so it plays nicely with allowlists.
- Run the git snapshot at most ONCE, BEFORE writing STATE.md. Do NOT re-run after modifying plans/**.

Default repo snapshot command (code reality excluding plans/**):

git rev-parse --abbrev-ref HEAD \
&& git status --porcelain=v1 -- . ':(exclude)plans/**' \
&& git diff --stat -- . ':(exclude)plans/**' \
&& git diff --staged --stat -- . ':(exclude)plans/**'

Time/order policy:

- Sitrep does NOT append to the Log by default.
- It MUST stamp the ROO_STATE block with:
  - Updated: <RFC3339 local time if available, else YYYY-MM-DD>
  - Save-id: YYYY-MM-DD (n=NN) OPTIONAL; only if you already computed NN for the day, otherwise omit.

Do a Code-mode subtask that updates only the ROO_STATE block with:
- Updated
- What I just did (<= 5 bullets)
- What’s pending / blocked (<= 5 bullets)
- Repo reality (excluding plans/**): paste the git snapshot output verbatim
- Verification (commands + results / NOT RUN)
- Next 3 actions (max)

Keep it short; prefer git status + diffstat over large excerpts.
