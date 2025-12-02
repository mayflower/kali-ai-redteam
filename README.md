# Kali AI Red Team

Docker image for AI application security testing with Claude Code.

## Quick Start

```bash
# Pull from Docker Hub
docker pull mayflowergmbh/kali-ai-redteam:latest

# Create and start container
docker run -d --name ai-redteam \
    -v $(pwd)/reports:/pentest/reports \
    mayflowergmbh/kali-ai-redteam:latest

# Connect to running session
docker attach ai-redteam
```

### Build locally

```bash
docker build -t kali-ai-redteam .
```

First run: follow the Claude login URL in your browser to authenticate.

## Connecting to the Container

**Create the container (once):**
```bash
docker run -d --name ai-redteam \
    -v $(pwd)/reports:/pentest/reports \
    kali-ai-redteam
```

**Connect to running session:**
```bash
docker attach ai-redteam
```

**Detach without stopping:** Press `Ctrl+P` then `Ctrl+Q`

**Reconnect after detaching:**
```bash
docker attach ai-redteam
```

**With host network access (for testing local targets):**
```bash
docker run -d --name ai-redteam \
    --network host \
    -v $(pwd)/reports:/pentest/reports \
    kali-ai-redteam
```

**Stop and remove when done:**
```bash
docker stop ai-redteam && docker rm ai-redteam
```

**Open additional shell in running container:**
```bash
docker exec -it ai-redteam fish
```

## Pre-installed Tools

| Tool | Command | Purpose |
|------|---------|---------|
| garak | `garak --model_type openai --model_name gpt-4 --probes promptinject` | LLM vulnerability scanner |
| promptfoo | `promptfoo redteam run` | Red team evaluation |
| ART | Python library | Adversarial Robustness Toolbox |

> **Note:** `prompt-security-fuzzer` and `agentic-security` are not included due to Python 3.13 compatibility issues (pandas build failures). Install manually via `pipx` once upstream fixes are available.

## Example Workflow

```bash
# 1. Start container
docker run -d --name ai-redteam -v $(pwd)/reports:/pentest/reports kali-ai-redteam

# 2. Connect - Claude Code starts automatically with --dangerously-skip-permissions
docker attach ai-redteam

# 3. Detach with Ctrl+P Ctrl+Q, reconnect later with docker attach ai-redteam

# 4. Run scans in separate shell while Claude session continues
docker exec -it ai-redteam garak --model_type rest --model_name http://target/api --probes promptinject,dan
```

## Shell Aliases

- `c` - Claude Code
- `scan <target>` - nmap version scan
- `serve` - Python HTTP server
- `listen <port>` - Netcat listener

## Environment Variables

Pass API keys for testing external LLMs:

```bash
docker run -d --name ai-redteam \
    -e OPENAI_API_KEY="sk-..." \
    -e ANTHROPIC_API_KEY="sk-ant-..." \
    -v $(pwd)/reports:/pentest/reports \
    kali-ai-redteam
```

## Documentation

See `CLAUDE.md` inside the container for:
- OWASP LLM Top 10 reference
- Tool usage examples
- Attack techniques & payloads
- Testing workflow
