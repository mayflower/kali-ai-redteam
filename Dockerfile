# Build on pre-built base image with kali-linux-headless.
# Override in CI if you publish the base image to a different registry:
#   docker build --build-arg BASE_IMAGE=ghcr.io/org/repo-base:sha-... .
ARG BASE_IMAGE=mayflowergmbh/kali-ai-redteam-base:latest
FROM ${BASE_IMAGE}

# Create non-root user
ARG USERNAME=hacker
ARG USER_UID=1000
ARG USER_GID=1000
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m -s /usr/bin/fish $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME

# Switch to non-root user for remaining setup
USER $USERNAME
WORKDIR /home/$USERNAME

# Ensure pipx binaries are in PATH
ENV PATH="/home/$USERNAME/.local/bin:$PATH"

# Install AI red teaming tools using pipx for isolation
# Use CPU-only torch to avoid ~8GB NVIDIA CUDA dependencies
RUN pipx install garak --pip-args="--extra-index-url https://download.pytorch.org/whl/cpu"

# Install additional CLI tools + MCP servers in isolated envs.
RUN pipx install semgrep
RUN pipx install semgrep-mcp
RUN pipx install mcp-server-fetch

# Create fish config directory
RUN mkdir -p /home/$USERNAME/.config/fish

# Copy fish configuration
COPY --chown=$USERNAME:$USERNAME config.fish /home/$USERNAME/.config/fish/config.fish

# Install Claude Code
RUN curl -fsSL https://claude.ai/install.sh | bash

# Add Claude Code to PATH
ENV PATH="/home/$USERNAME/.claude/local/bin:$PATH"

# Fail fast if the installer or PATH layout changes upstream.
RUN claude --version

# Create default MCP config directory
RUN mkdir -p /home/$USERNAME/.claude

# Copy Claude Code settings to user home (global settings)
COPY --chown=$USERNAME:$USERNAME .claude/settings.json /home/$USERNAME/.claude/settings.json

# Copy slash commands and agents to user home (global availability)
COPY --chown=$USERNAME:$USERNAME .claude/commands /home/$USERNAME/.claude/commands
COPY --chown=$USERNAME:$USERNAME .claude/agents /home/$USERNAME/.claude/agents

# Copy local Claude Code skills into the user profile.
COPY --chown=$USERNAME:$USERNAME .claude/skills /home/$USERNAME/.claude/skills

# Install community skills (Claude Code skill packs).
# Default: enabled. Disable with: --build-arg INSTALL_COMMUNITY_SKILLS=0
ARG INSTALL_COMMUNITY_SKILLS=1
RUN if [ "${INSTALL_COMMUNITY_SKILLS}" = "1" ]; then \
      DISABLE_TELEMETRY=1 npx -y skills@latest add https://github.com/trailofbits/skills -g -a claude-code --skill '*' ; \
    fi

# Create and set working directory for pentests with proper ownership
RUN sudo mkdir -p /pentest && sudo chown $USERNAME:$USERNAME /pentest
WORKDIR /pentest

# Create output directories
RUN mkdir -p /pentest/recon /pentest/scans /pentest/prompts /pentest/exploits /pentest/reports

# Copy CLAUDE.md instructions for Claude Code
COPY --chown=$USERNAME:$USERNAME CLAUDE.md /pentest/CLAUDE.md

# Install Playwright browser for MCP server
RUN npx -y playwright@latest install chromium

# Install Trivy MCP plugin (Trivy is installed in the base image).
RUN trivy plugin install mcp

# Entrypoint script for flexibility
COPY --chown=$USERNAME:$USERNAME entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["claude", "--dangerously-skip-permissions"]
