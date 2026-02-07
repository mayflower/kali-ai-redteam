# Kali AI Red Team

Headless Kali Linux container for AI application and external security testing with Claude Code.

## Quick Start

```bash
# Pull from Docker Hub
docker pull mayflowergmbh/kali-ai-redteam:latest

# Run interactively (Claude Code starts automatically)
docker run -it --name ai-redteam \
    -v $(pwd)/pentest:/pentest \
    mayflowergmbh/kali-ai-redteam:latest
```

On first run, follow the login URL to authenticate with Claude Code. MCP servers are configured automatically.

### Build locally

The image uses a two-tier build for faster rebuilds:

```bash
# Build base image (slow, ~25-35 min - contains kali-linux-headless)
docker build -f Dockerfile.base -t mayflowergmbh/kali-ai-redteam-base:latest .

# Build main image (fast, ~15 min - uses base image)
docker build -t mayflowergmbh/kali-ai-redteam:latest .
```

For development, only rebuild the main image - the base image rarely needs updating.

## Container Usage

**Run interactively:**
```bash
docker run -it --name ai-redteam \
    -v $(pwd)/pentest:/pentest \
    mayflowergmbh/kali-ai-redteam:latest
```

**Detach without stopping:** Press `Ctrl+P` then `Ctrl+Q`

**Reattach to running container:**
```bash
docker attach ai-redteam
```

**With host network access (for testing local targets):**
```bash
docker run -it --name ai-redteam \
    --network host \
    -v $(pwd)/pentest:/pentest \
    mayflowergmbh/kali-ai-redteam:latest
```

**Stop and remove when done:**
```bash
docker stop ai-redteam && docker rm ai-redteam
```

**Open additional shell in running container:**
```bash
docker exec -it ai-redteam fish
```

## Slash Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/recon` | Enumerate target LLM API/model info | `/recon https://api.target.com` |
| `/scan` | Run garak/promptfoo vulnerability scans | `/scan openai gpt-4 --probes promptinject,dan` |
| `/probe` | Quick prompt injection test | `/probe "ignore previous instructions"` |
| `/jailbreak` | Generate jailbreak payloads | `/jailbreak chatgpt` |
| `/extract` | System prompt extraction attempts | `/extract https://api.target.com/chat` |
| `/report` | Generate assessment report | `/report` |

## Autonomous Agents

| Agent | Description |
|-------|-------------|
| `scanner` | Systematic vulnerability scanning with garak/promptfoo |
| `exploiter` | Payload crafting and exploitation testing |
| `reporter` | Compile findings into assessment reports |

## Pre-installed Tools

This is a headless container (no GUI). Playwright runs in headless mode with Chromium installed.

LLM / AI appsec:
- `claude` (Claude Code)
- `garak`
- `promptfoo`

Scanning, SAST, secrets, SBOM, vuln triage:
- `semgrep`
- `gitleaks`
- `trivy` (plus `trivy mcp`)
- `syft` (SBOM)
- `grype` (vulns from SBOM)
- `nuclei`

Recon / web / network (Kali baseline + headless):
- `nmap`, `masscan`, `httpx`, `ffuf`, `amass`, `subfinder`, `naabu`, `feroxbuster`, `dirsearch`, `nikto`, `sqlmap`

AD / Windows tooling (where applicable):
- `bloodhound-python`, `crackmapexec`, `netexec`, `impacket-*`, `responder`

Kubernetes:
- `kubectl`, `helm`

MCP debugging (optional):
- `mcp-chat` (requires `ANTHROPIC_API_KEY`)

## Output Structure

All findings are saved to `/pentest/` (mounted to host):

```
pentest/
├── recon/       # Target reconnaissance
├── scans/       # Automated scan results
├── prompts/     # Test prompts and responses
├── exploits/    # Successful attacks and PoCs
└── reports/     # Assessment reports
```

## Example Workflow

```bash
# 1. Start container (login on first run)
docker run -it --name ai-redteam \
    -v $(pwd)/pentest:/pentest \
    mayflowergmbh/kali-ai-redteam:latest

# 2. Use slash commands for guided testing
/recon https://target-llm.com/api
/scan rest https://target-llm.com/api --probes promptinject,dan
/jailbreak target-model
/report

# 3. Or run autonomous agents
# (agents will run without confirmation prompts)
```

## Shell Aliases

- `c` - Claude Code
- `scan <target>` - nmap version scan
- `serve` - Python HTTP server
- `listen <port>` - Netcat listener

## Environment Variables

Pass API keys for testing external LLM targets (garak, promptfoo, optional MCP tools):

```bash
docker run -it --name ai-redteam \
    -e ANTHROPIC_API_KEY="..." \
    -e OPENAI_API_KEY="sk-..." \
    -v $(pwd)/pentest:/pentest \
    mayflowergmbh/kali-ai-redteam:latest
```

Note: Claude Code authentication is handled via browser login on first run. `ANTHROPIC_API_KEY` is still useful for API-driven tooling and `mcp-chat`.

## MCP Servers

Configured automatically on first run:

- `filesystem` - Access to `/pentest`, `/tmp`, `/var/log`
- `fetch` - HTTP requests (via `mcp-server-fetch`)
- `playwright` - Headless browser automation (Chromium)
- `memory` - In-session memory MCP
- `promptfoo` - Promptfoo MCP transport
- `trivy` - Trivy MCP transport (`trivy mcp`)
- `semgrep` - Semgrep MCP transport (`semgrep-mcp`)
- `sqlite` - Local SQLite scratch DB at `/pentest/mcp.sqlite`
- `kubernetes` - Kubernetes MCP server (uses `kubectl` config inside the container)

To inspect MCP health:
```bash
claude mcp list
```

## Documentation

See `CLAUDE.md` inside the container for:
- OWASP LLM Top 10 reference
- Tool usage examples
- Attack techniques & payloads
- Testing workflow
