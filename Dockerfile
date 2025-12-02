FROM kalilinux/kali-rolling

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install kali-linux-headless metapackage
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install kali-linux-headless && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js, Python tools, fish shell, and sudo
RUN apt-get update && \
    apt-get -y install nodejs npm curl git fish python3-pip python3-venv pipx sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user
ARG USERNAME=hacker
ARG USER_UID=1000
ARG USER_GID=1000
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m -s /usr/bin/fish $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME

# Install global tools as root first
RUN pip3 install --break-system-packages \
    adversarial-robustness-toolbox \
    instructor \
    httpx \
    openai \
    anthropic

# Install promptfoo (Node.js based) globally
RUN npm install -g promptfoo

# Install Playwright system dependencies (requires root)
RUN npx playwright install-deps chromium

# Switch to non-root user for remaining setup
USER $USERNAME
WORKDIR /home/$USERNAME

# Ensure pipx binaries are in PATH
ENV PATH="/home/$USERNAME/.local/bin:$PATH"

# Install AI red teaming tools using pipx for isolation
# Use CPU-only torch to avoid ~8GB NVIDIA CUDA dependencies
RUN pipx install garak --pip-args="--extra-index-url https://download.pytorch.org/whl/cpu"

# NOTE: prompt-security-fuzzer and agentic-security have Python 3.13 compatibility issues
# (pandas build failures). Install manually via pipx once upstream fixes are available.

# Create fish config directory
RUN mkdir -p /home/$USERNAME/.config/fish

# Copy fish configuration
COPY --chown=$USERNAME:$USERNAME config.fish /home/$USERNAME/.config/fish/config.fish

# Install Claude Code
RUN curl -fsSL https://claude.ai/install.sh | bash

# Add Claude Code to PATH
ENV PATH="/home/$USERNAME/.claude/local/bin:$PATH"

# Create default MCP config directory
RUN mkdir -p /home/$USERNAME/.claude

# Copy MCP server configuration
COPY --chown=$USERNAME:$USERNAME mcp-config.json /home/$USERNAME/.claude/mcp-servers.json

# Set working directory for pentests
WORKDIR /pentest

# Copy CLAUDE.md instructions for Claude Code
COPY --chown=$USERNAME:$USERNAME CLAUDE.md /pentest/CLAUDE.md

# Copy Claude Code configuration (slash commands, agents, settings)
COPY --chown=$USERNAME:$USERNAME .claude /pentest/.claude

# Install Playwright browser for MCP server
RUN npx playwright install chromium

# Support both auth methods:
# 1. ANTHROPIC_API_KEY env var at runtime
# 2. Volume mount of ~/.claude from host

# Entrypoint script for flexibility
COPY --chown=$USERNAME:$USERNAME entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["claude", "--dangerously-skip-permissions"]
