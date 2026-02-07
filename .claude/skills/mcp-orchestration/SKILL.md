---
name: mcp-orchestration
description: Use when orchestrating headless tooling via MCP in this container (filesystem, fetch, playwright, semgrep, trivy, promptfoo, sqlite, kubernetes). Ensures outputs are saved under /pentest/ and avoids brittle npx cold-starts.
license: MIT
metadata:
  owner: mayflowergmbh/kali-ai-redteam
---

# MCP Orchestration (Headless)

## Available MCP Servers (Configured By entrypoint.sh)

- `filesystem`: read/write under `/pentest`, `/tmp`, `/var/log`
- `fetch`: HTTP client (`mcp-server-fetch`)
- `playwright`: headless browser automation
- `memory`: scratch memory for the session
- `promptfoo`: run evals/redteam
- `trivy`: run `trivy mcp` for scans
- `semgrep`: run `semgrep-mcp` for repo scans
- `sqlite`: local db at `/pentest/mcp.sqlite`
- `kubernetes`: cluster inspection (uses `kubectl` config)

## Conventions

- Always write artifacts to `/pentest/` (never to `$HOME`).
- Cache expensive results and summarize them into `/pentest/reports/`.
- If an MCP server is unavailable, fall back to the CLI tool directly.
