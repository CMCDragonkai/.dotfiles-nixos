---
description: Propose a Conventional Commit message and a single paste-ready git command you can copy/execute on ANY branch.
argument-hint: optional "type=feat scope=orchestrator" or "no-add" or "skip-cmd" or "no-preview"
---

Always output TWO fenced blocks:

1) Commit message (always)
- Conventional Commit: `type(scope): summary` (scope optional)
- Subject imperative, <= ~72 chars
- Optional body bullets: what/why; mention files as `path/to/file`
- Keep wording shell-quoting-safe: avoid unescaped `'` and `"`; rewrite if needed.

2) Command (optional)
- The user may skip running any command and do git manually.
- If "skip-cmd" is provided: output ONLY `# (skip)`.
- Otherwise output EXACTLY ONE command that chains with `&&`.
- Must not open editor: ALWAYS pass message via `-m`.
- Must not invoke pager: use `git -c core.pager=cat ...` for previews.
- Must not use heredocs.
- Prefer git-only (no sed/awk/grep/echo/printf), to play nicely with allowlists.

Terminology:
- "staged" means "in the git index", NOT a branch named staging.
- "no-add" means do NOT run `git add -A` (assumes user staged what they want).

Command construction:
- Always print current branch first (so commits are branch-agnostic but explicit):
  - `git rev-parse --abbrev-ref HEAD`
- Previews are OPTIONAL:
  - If "no-preview" is NOT provided, include:
    - `git -c core.pager=cat diff --stat`
    - `git -c core.pager=cat diff --staged --stat`
- If "no-add" is NOT provided, include `git add -A` and then show staged stat again (unless no-preview).
- Then commit:
  - Subject: `git commit -m "<subject>"`
  - If body exists: add additional `-m "<paragraph>"` flags (one paragraph per flag; keep paragraphs short)

Single-command templates:

Default (preview + add + commit):
git rev-parse --abbrev-ref HEAD \
&& git -c core.pager=cat diff --stat \
&& git -c core.pager=cat diff --staged --stat \
&& git add -A \
&& git -c core.pager=cat diff --staged --stat \
&& git commit -m "<subject>" [ -m "<body paragraph 1>" ... ]

No-add (preview + commit only):
git rev-parse --abbrev-ref HEAD \
&& git -c core.pager=cat diff --stat \
&& git -c core.pager=cat diff --staged --stat \
&& git commit -m "<subject>" [ -m "<body paragraph 1>" ... ]

No-preview (fast path):
- With add:
  git rev-parse --abbrev-ref HEAD && git add -A && git commit -m "<subject>" [ -m "<body paragraph 1>" ... ]
- No-add:
  git rev-parse --abbrev-ref HEAD && git commit -m "<subject>" [ -m "<body paragraph 1>" ... ]

Type inference:
- type in {feat, fix, docs, refactor, perf, test, build, ci, chore}
- scope:
  - use provided scope=...
  - else infer from dominant top-level directory name, or omit if unclear
