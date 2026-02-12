DISABLE_AUTO_TITLE="true"
# ==============================================================================
# .zshrc - Centralized Configuration (~/.config/zsh/.zshrc)
# Managed by: kajiyamavk | Synced via GitHub
# ==============================================================================

# --- 1. VS CODE REMOTE-SSH COMPATIBILITY ---
# This guard prevents the shell from producing any output (stdout) for 
# non-interactive sessions (like VS Code SSH or rsync). 
# Without this, terminal output from tools like 'fnm' or 'nvm' during 
# handshake can break the VS Code "AsyncPipe" connection.
[[ $- != *i* ]] && return
# ---------------------------------------------

# --- 2. ENVIRONMENT & PATHS ---
# Uses $HOME instead of hardcoded paths to support different usernames 
# (vkajiyama on Work Ubuntu vs kajiyamavk on Homelab Mint).
ZSH_CONFIG_DIR="$HOME/.config/zsh"

# Add local binaries to PATH
export PATH="$HOME/.local/bin:$HOME/.console-ninja/.bin:$PATH"

# --- 3. NODE VERSION MANAGERS ---
# FNM: Fast Node Manager
export FNM_DIR="$HOME/.local/share/fnm"
if [ -d "$FNM_DIR" ]; then
  export PATH="$FNM_DIR:$PATH"
  if command -v fnm >/dev/null 2>&1; then
    eval "$(fnm env)"
  fi
fi

# NVM: Node Version Manager (Fallback/Legacy)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# --- 4. MODULAR CONFIG SOURCING ---
if [ -d "$ZSH_CONFIG_DIR" ]; then
  source "$ZSH_CONFIG_DIR/global.zsh"
  source "$ZSH_CONFIG_DIR/functions.zsh"
  source "$ZSH_CONFIG_DIR/config.zsh"
  source "$ZSH_CONFIG_DIR/scripts.zsh"
fi

# --- 5. SHELL TOOLS (FZF) ---
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS (Homebrew)
  source <(fzf --zsh)
elif [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  # Linux (Ubuntu/Mint)
  source /usr/share/doc/fzf/examples/key-bindings.zsh
  source /usr/share/doc/fzf/examples/completion.zsh
fi

# --- 6. WEZTERM INTEGRATION ---
# Function to send variables to WezTerm for dynamic themes/tab titles
wezterm_set_var() {
  local name=$1
  local value=$(echo -n "$2" | base64 | tr -d '\n')
  printf "\033]1337;SetUserVar=%s=%s\007" "$name" "$value"
}

# MACHINE-SPECIFIC IDENTITY:
# Only signal "is_homelab" if we are actually on the homelab host.
# This prevents theme "sticking" on the Work laptop.
if [[ "$(hostname)" == "homelab" ]]; then
# # else
fi

# Reset variable on exit to clean up the WezTerm state

# --- 7. API TOKENS & SECRETS ---
# Keeping tokens in .config/jules but ensuring they are gitignored
if [ -f "$HOME/.config/jules/.token" ]; then
    export JULES_API_KEY=$(tr -d '\n\r ' < "$HOME/.config/jules/.token")
    export JULES_TOKEN="$JULES_API_KEY"
fi

# --- 8. ZOXIDE (MUST BE LAST) ---
# Smarter directory jumping (replaces 'cd')
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
# 
# --- Flutter
export PATH="$HOME/development/flutter/bin:$PATH"

# ==============================================================================
# End of .zshrc
# ==============================================================================export PATH="$HOME/src/flutter/bin:$PATH"
precmd() { print -Pn "]2;%n@%m: %~" }
export OPENCLAW_STATE_DIR="$HOME/.config/openclaw"

# OpenClaw Completion
source "/home/kajiyamavk/.config/openclaw/completions/openclaw.zsh"
