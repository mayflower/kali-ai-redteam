---
description: Enumerate target LLM API endpoints and model information
argument-hint: <target-url>
---

Perform reconnaissance on the target LLM application at $ARGUMENTS.

## Reconnaissance Steps

1. **Endpoint Discovery**
   - Identify API endpoints (chat, completions, embeddings)
   - Check for OpenAPI/Swagger documentation
   - Look for health/status endpoints

2. **Authentication Analysis**
   - Detect authentication method (API key, OAuth, session)
   - Check for exposed keys in responses or errors
   - Test rate limiting behavior

3. **Model Identification**
   - Detect model provider (OpenAI, Anthropic, local, custom)
   - Identify model version if possible
   - Check for model switching capabilities

4. **Input/Output Mapping**
   - Document request format (JSON structure, parameters)
   - Map response format and fields
   - Identify streaming vs batch modes

5. **Configuration Exposure**
   - Check for debug endpoints
   - Look for configuration leaks in errors
   - Test for verbose error messages

Save all findings to `/pentest/recon/` with timestamp.
Create a summary file with key findings for next phase.
