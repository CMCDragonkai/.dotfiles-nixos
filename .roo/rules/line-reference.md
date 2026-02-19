# Line Reference Policy

Never emit `path:line` (e.g. `foo.ts:1`, `README.md:126`) in any content intended to be written into repository files (code comments, markdown, docs, templates).

- Do NOT put `:number` inside Markdown link destinations: `[x](path:123)` is banned.
- If a line reference is needed, use either:
  - `[x](path#heading-anchor) (if possible), or
  - `[x](path) (line 123)` (preferred, portable), or
  - `[x](path#L123)` only when explicitly targeting a renderer that supports `#L` anchors.
- If you would have emitted `:1`, drop it entirely: use `path` with no line info.
