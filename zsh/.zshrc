# 1. IMMEDIATE GUARD - No text output for non-interactive shells
[[ $- != *i* ]] && return

# 2. Path check - prevent errors if paths differ
ZSH_CONFIG_DIR="$HOME/.config/zsh"

# fnm: ensure it's on PATH and initialize it before sourcing any config files
export FNM_DIR="$HOME/.local/share/fnm"
if [ -d "$FNM_DIR" ]; then
  export PATH="$FNM_DIR:$PATH"
  if command -v fnm >/dev/null 2>&1; then
    eval "$(fnm env)"
  fi
fi

if [ -d "$ZSH_CONFIG_DIR" ]; then
  source "$ZSH_CONFIG_DIR/global.zsh"
  source "$ZSH_CONFIG_DIR/functions.zsh"
  source "$ZSH_CONFIG_DIR/config.zsh"
  source "$ZSH_CONFIG_DIR/scripts.zsh"
fi

PATH=~/.console-ninja/.bin:$PATH
# Add ~/.local/bin to PATH if it exists
if [ -d "$HOME/.local/bin" ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# fzf shell integration
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS (Homebrew)
  source <(fzf --zsh)
elif [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  # Linux Mint / Debian / Ubuntu
  source /usr/share/doc/fzf/examples/key-bindings.zsh
  source /usr/share/doc/fzf/examples/completion.zsh
fi

# --- WezTerm Integration ---

# Function to send a variable to WezTerm via escape sequences
wezterm_set_var() {
  local name=$1
  # Encode value to base64 and strip newlines to ensure it reaches WezTerm cleanly
  local value=$(echo -n "$2" | base64 | tr -d '\n')
  printf "\033]1337;SetUserVar=%s=%s\007" "$name" "$value"
}

# Signal that this shell is the Homelab environment
# This will trigger the theme change in your local WezTerm
wezterm_set_var "is_homelab" "true"

# Optional: Reset the variable when logging out to prevent theme "sticking"
alias exit='wezterm_set_var "is_homelab" "false"; exit'

# Path to token (keeping it in .config but ignored by git)
# Inside ~/.config/zsh/.zshrc
if [ -f "$HOME/.config/jules/.token" ]; then
    export JULES_API_KEY=$(tr -d '\n\r ' < "$HOME/.config/jules/.token")
    export JULES_TOKEN="$JULES_API_KEY"
fi

# zoxide: Must be the last line
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
