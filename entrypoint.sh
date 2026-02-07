#!/bin/bash

# Keep startup predictable; don't fail the whole container if an optional MCP
# server can't be configured.
set -euo pipefail

# Pass through API key if provided
if [ -n "${ANTHROPIC_API_KEY:-}" ]; then
    export ANTHROPIC_API_KEY
fi

add_mcp() {
    local name="$1"
    shift

    if claude mcp add "$name" -s user -- "$@" >/dev/null 2>&1; then
        return 0
    fi

    echo "WARN: Failed to configure MCP server: ${name}" >&2
    return 1
}

# Configure MCP servers on first run
if [ ! -f ~/.claude.json ] || ! grep -q "mcpServers" ~/.claude.json 2>/dev/null; then
    echo "Configuring MCP servers..."
    add_mcp filesystem npx -y @modelcontextprotocol/server-filesystem /pentest /tmp /var/log || true
    add_mcp fetch mcp-server-fetch || true
    add_mcp playwright npx -y @playwright/mcp@latest || true
    add_mcp memory npx -y @modelcontextprotocol/server-memory || true

    # Pentest-oriented additions (headless / CLI-only).
    add_mcp promptfoo promptfoo mcp --transport stdio || true
    add_mcp trivy trivy mcp || true
    add_mcp sqlite mcp-server-sqlite --db /pentest/mcp.sqlite || true
    add_mcp kubernetes mcp-server-kubernetes || true
    echo "MCP servers configured."
fi

exec "$@"
