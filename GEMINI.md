# .config Project Configuration

This `GEMINI.md` documents the specific rules and context for the `~/.config` repository (Dotfiles & Config Backup).

## Project Overview
- **Purpose**: Centralized development environment configuration.
- **Scope**: Machine-agnostic (Work Laptop `vkajiyama` & Home Lab `kajiyamavk`).
- **Structure**: Root of the git repository is `~/.config`.

## Critical Constraints & Rules

### 1. File System & Paths
- **NO Hardcoded Paths**: Always use `$HOME` or relative paths. This repo is shared between users with different home directories.
- **Whitelist Strategy**: This repo uses a `deny-all` git strategy (`*`). You MUST explicitly check `.gitignore` and likely add a whitelist rule (e.g., `!folder/`) when adding new directories to git.

### 2. Shell & SSH Safety
- **Non-Interactive Shells**: Do NOT print to stdout in `.zshrc` unless checking `[[ $- == *i* ]]`. This prevents SSH/SCP failures and VS Code connection issues.

### 3. Key Components
- **Global Config**: `gemini/` (Agent rules)
- **Shell**: `zsh/` (Entry point `.zshenv` points here)
- **Automation**: `frigate/`, `home-assistant/`
- **Editors**: `nvim/`

### 4. Git & Version Control
- **Repo Location**: `~/.config`
- **Ignored Directories**: `Code/`, `.vscode-server/` (Prevent watcher loops).

## Helper Context
- If editing Zsh config, remember the entry point is often `~/.zshenv` pointing `ZDOTDIR` to `~/.config/zsh`.
