#!/bin/bash

# Pass through API key if provided
if [ -n "$ANTHROPIC_API_KEY" ]; then
    export ANTHROPIC_API_KEY
fi

# Configure MCP servers on first run
if [ ! -f ~/.claude.json ] || ! grep -q "mcpServers" ~/.claude.json 2>/dev/null; then
    echo "Configuring MCP servers..."
    claude mcp add filesystem -s user -- npx -y @modelcontextprotocol/server-filesystem /pentest /tmp /var/log >/dev/null 2>&1
    claude mcp add fetch -s user -- npx -y @modelcontextprotocol/server-fetch >/dev/null 2>&1
    claude mcp add playwright -s user -- npx -y @anthropic/mcp-server-playwright >/dev/null 2>&1
    claude mcp add memory -s user -- npx -y @anthropic/mcp-server-memory >/dev/null 2>&1
    echo "MCP servers configured."
fi

exec "$@"
