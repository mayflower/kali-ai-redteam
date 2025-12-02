# Kali AI Red Team

Docker image for AI application security testing with Claude Code.

## Quick Start

```bash
# Pull from Docker Hub
docker pull mayflowergmbh/kali-ai-redteam:latest

# Run interactively (Claude Code starts automatically)
docker run -it --name ai-redteam \
    -v $(pwd)/pentest:/pentest \
    mayflowergmbh/kali-ai-redteam:latest
```

First run: follow the Claude login URL in your browser to authenticate.

### Build locally

```bash
docker build -t kali-ai-redteam .
```

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

| Tool | Command | Purpose |
|------|---------|---------|
| garak | `garak --model_type openai --model_name gpt-4 --probes promptinject` | LLM vulnerability scanner |
| promptfoo | `promptfoo redteam run` | Red team evaluation |
| ART | Python library | Adversarial Robustness Toolbox |

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
# 1. Start container
docker run -it --name ai-redteam -v $(pwd)/pentest:/pentest mayflowergmbh/kali-ai-redteam:latest

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

Pass API keys for testing external LLMs:

```bash
docker run -it --name ai-redteam \
    -e OPENAI_API_KEY="sk-..." \
    -e ANTHROPIC_API_KEY="sk-ant-..." \
    -v $(pwd)/pentest:/pentest \
    mayflowergmbh/kali-ai-redteam:latest
```

## MCP Servers

- **filesystem** - Access to /pentest, /tmp, /var/log
- **fetch** - HTTP requests to target APIs
- **playwright** - Browser automation for web-based LLM testing
- **memory** - Persistent storage for findings across sessions

## Documentation

See `CLAUDE.md` inside the container for:
- OWASP LLM Top 10 reference
- Tool usage examples
- Attack techniques & payloads
- Testing workflow
