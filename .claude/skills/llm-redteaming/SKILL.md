---
name: llm-redteaming
description: Use when testing LLM applications or agentic systems for prompt injection, jailbreaks, tool abuse, data leakage, and eval regressions. Uses garak/promptfoo and the configured MCP servers; writes all artifacts under /pentest/.
license: MIT
metadata:
  owner: mayflowergmbh/kali-ai-redteam
---

# LLM Red Teaming Runbook

## Inputs To Collect

- Target base URL / API endpoint(s)
- Auth method (key, cookie, OAuth), rate limits, and scope constraints
- Model/provider (if known) and tool/plugin surface (if any)

## Baseline

1. Run `/recon <target-url>` and save output under `/pentest/recon/`.
2. Record request/response schema (including streaming) and any moderation behavior.

## Automated Coverage

- `garak` for probe-driven scanning; save to `/pentest/scans/garak-*`.
- `promptfoo` for eval suites/redteam runs; save to `/pentest/scans/promptfoo-*`.

## Manual Exploitation

- Use `/probe` for quick injections and `/extract` for system prompt extraction attempts.
- Use Playwright MCP for headless flows (login, multi-step prompt injection, indirect injection via UI content).
- Persist key artifacts in `/pentest/prompts/` and `/pentest/exploits/` (full payload + full response).

## Reporting

- Map findings to OWASP LLM Top 10 categories.
- Include exact repro steps and expected/actual behavior.
