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

# zoxide: Must be the last line
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# fzf shell integration
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS (Homebrew)
  source <(fzf --zsh)
elif [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  # Linux Mint / Debian / Ubuntu
  source /usr/share/doc/fzf/examples/key-bindings.zsh
  source /usr/share/doc/fzf/examples/completion.zsh
fi
