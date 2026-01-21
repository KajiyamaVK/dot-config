🛠️ Dotfiles & Config Backup
This repository centralizes my development environment configurations within the ~/.config directory. It is designed to be machine-agnostic, supporting both my Work Ubuntu laptop (vkajiyama) and my Home Lab Linux Mint server (kajiyamavk).

📁 Repository Structure
Unlike the previous "Git-as-Home" strategy, this repository now lives at ~/.config/. Core shell files are symlinked to $HOME.

Shell: Zsh (zsh/, .zshrc)

Automation/IoT: Frigate (frigate/), Home Assistant (home-assistant/)

Editors: Neovim (nvim/), VS Code (Code/ - metadata only)

Terminals: Alacritty (alacritty/), Warp (warp-terminal/)

Scripts: Private tokens (jules/ - gitignored)

🚀 Restoration & Machine Setup
Since configurations are shared across machines with different usernames, follow these steps for a clean setup:

1. The Entry Point (.zshenv)
Zsh must be told where to look for its configuration. Create this file on the host machine:

Bash

# ~/.zshenv
# Points to the centralized repo regardless of the username
export ZDOTDIR="$HOME/.config/zsh"
2. Manual Symlinks
For tools that do not natively support XDG_CONFIG_HOME, link them manually:

Bash

ln -s "$HOME/.config/zsh/.zshrc" "$HOME/.zshrc"
3. WezTerm Theme Integration
The theme/identity logic is dynamic. It uses the is_homelab variable, which is set in .zshrc only if $(hostname) matches homelab.

🏗️ Whitelist Strategy (.gitignore)
To keep the repository clean, we ignore everything by default and explicitly allow the tools we want to track.

Logic:

/* - Ignore everything.

!.config/ - Allow the config folder.

!.config/nvim/ - Allow specific apps.

CRITICAL: The Code/ folder and .vscode-server/ are explicitly ignored to prevent recursive file-watcher loops that crash Remote-SSH connections.

🔧 Troubleshooting & Lessons Learned
2026-01-21: VS Code SSH Disconnection Loop
Issue: VS Code SSH fails with AsyncPipeFailed or reverts to the local .config folder.

Cause 1 (Terminal Output): Tools like fnm or nvm printing text during handshake breaks the SSH pipe.

Cause 2 (Path Mismatch): Hardcoded home paths (e.g., /home/vkajiyama) failing on the server (/home/kajiyamavk).

Cause 3 (Watcher Loop): VS Code trying to index its own ~/.config/Code directory.

Solutions implemented in this repo:

Stdout Guard: Added [[ $- != *i* ]] && return to the top of .zshrc.

Dynamic Paths: Used $HOME or $(hostname) in all scripts instead of hardcoded strings.

Exclusions: Added Code/ and .vscode-server/ to .gitignore and VS Code files.watcherExclude.

Rofi (Combined Mode)
Ensure keyboard shortcuts use rofi -show combi to see both applications and open windows, as defined in .config/rofi/config.rasi.

📦 Essential Packages
Bash

# Ubuntu / Linux Mint
sudo apt-get update
sudo apt-get install zsh neovim alacritty rofi fzf zoxide git