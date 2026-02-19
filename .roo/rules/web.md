# Web retrieval policy

When answering questions that require web pages:

1. If the user provides a URL:
  - Use the fast HTTP fetch tool first (currently: MCP `fetch`) to retrieve readable content (HTML→markdown).
  - If the output looks like a JS shell / placeholder (e.g., very little real text, mostly scripts, “enable JavaScript”, empty root div),
    then use a headless JS renderer (currently: Playwright MCP) to retrieve rendered visible text/HTML.
  - If login/2FA/captcha or complex interaction is required, use Roo’s interactive browser tool.
2. If the user does NOT provide a URL:
  - Use the web search tool (currently: `brave_web_search`) and retrieve ~8–10 results.
  - Shortlist 3–5 candidates (prefer primary sources/docs; avoid SEO farms).
  - Fetch candidates until enough evidence is gathered (usually up to 3). Use JS rendering only when the fast fetch is insufficient.
3. Chunking:
  - If content is truncated, continue with paging (`start_index`) until sufficient evidence is gathered.
4. Always report:
  - which URLs were used, and which tool retrieved each page (fast fetch vs JS render vs interactive browser).
