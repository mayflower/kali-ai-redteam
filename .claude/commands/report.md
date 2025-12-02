---
description: Compile findings into markdown security assessment report
---

Generate AI security assessment report from `/pentest/` findings.

## Report Structure

Create `/pentest/reports/assessment-$(date +%Y%m%d).md` with:

### 1. Executive Summary
- Assessment scope and objectives
- Key findings overview (Critical/High/Medium/Low counts)
- Overall risk rating
- Top 3 recommendations

### 2. Methodology
- Tools used (garak, promptfoo, manual testing)
- Testing phases completed
- Scope limitations

### 3. Target Information
- Pull from `/pentest/recon/`
- Model/API details
- Authentication method
- Identified endpoints

### 4. Findings by OWASP LLM Top 10

For each applicable category:

#### LLM01: Prompt Injection
#### LLM02: Insecure Output Handling
#### LLM03: Training Data Poisoning
#### LLM04: Model Denial of Service
#### LLM05: Supply Chain Vulnerabilities
#### LLM06: Sensitive Information Disclosure
#### LLM07: Insecure Plugin Design
#### LLM08: Excessive Agency
#### LLM09: Overreliance
#### LLM10: Model Theft

Include for each finding:
- Severity rating
- Description
- Evidence/PoC
- Reproduction steps
- Remediation recommendation

### 5. Scan Results Summary
- Pull from `/pentest/scans/`
- Successful exploits
- Failed attempts (for coverage)

### 6. Recommendations
- Prioritized remediation steps
- Quick wins vs long-term fixes
- Defense-in-depth suggestions

### 7. Appendices
- Full scan outputs
- Payload samples
- Response logs

## Output

Save report and notify when complete.
