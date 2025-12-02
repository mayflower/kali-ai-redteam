---
description: Run garak or promptfoo vulnerability scans against target
argument-hint: <model-type> <model-name> [--probes <probe-list>]
---

Run automated LLM vulnerability scan using garak.

## Usage Examples

```bash
# OpenAI model scan
/scan openai gpt-4 --probes promptinject,dan

# Local/REST API scan
/scan rest http://target:8080/api/chat --probes encoding,glitch

# Anthropic model scan
/scan anthropic claude-3-sonnet --probes all
```

## Execution

Run garak with the provided arguments:
```bash
garak --model_type $1 --model_name $2 $3 $4 $5 --report_prefix /pentest/scans/garak
```

## Available Probe Categories

- `dan` - Do Anything Now jailbreaks
- `promptinject` - Prompt injection attacks
- `encoding` - Encoding-based bypasses (base64, rot13, etc.)
- `glitch` - Token glitch exploits
- `goodside` - Goodside prompt attacks
- `knownbadsignatures` - Known malicious patterns
- `leakreplay` - Training data extraction
- `malwaregen` - Malware generation attempts
- `misleading` - Misleading prompt attacks
- `packagehallucination` - Package hallucination tests
- `realtoxicityprompts` - Toxicity generation
- `snowball` - Snowball prompt attacks
- `xss` - XSS payload generation

## Post-Scan

1. Save results to `/pentest/scans/`
2. Parse output for critical findings
3. Summarize vulnerabilities by severity
4. Flag any successful exploits for manual review
