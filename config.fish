# Kali Claude Pentest - Fish Configuration

# Add Claude Code to PATH (uses $HOME for flexibility)
set -gx PATH $HOME/.claude/local/bin $HOME/.local/bin $PATH

# Pentest prompt
function fish_prompt
    set_color red
    echo -n "kali"
    set_color white
    echo -n "@"
    set_color blue
    echo -n "pentest"
    set_color white
    echo -n ":"
    set_color green
    echo -n (prompt_pwd)
    set_color white
    echo -n " # "
end

# Disable greeting
set -g fish_greeting

# Useful aliases
alias ll='ls -la'
alias scan='nmap -sV -sC'
alias serve='python3 -m http.server'
alias listen='nc -lvnp'

# Claude shortcuts
alias c='claude'
alias cp='claude -p'
