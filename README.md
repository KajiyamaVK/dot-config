# Dotfiles & Config Backup

This repository serves as a backup for my personal Linux Mint development environment configurations. It uses a **whitelist strategy** to track only specific, critical configuration files directly in the `$HOME` directory, keeping the repository clean and focused.

## 🛠 Tracked Configurations

The following services and tools are currently tracked:

* **Shell:** Zsh (`.zshrc`, `.config/zsh/`)
* **Editors:**
    * Neovim (`.config/nvim/`)
    * VS Code (`.config/Code/`)
* **Terminals:**
    * Alacritty (`.config/alacritty/`)
    * Warp Terminal (`.config/warp-terminal/`)
* **Launcher:** Rofi (`.config/rofi/`)

## 🚀 Restoration Guide (Fresh Install)

Since this repository is designed to be the `$HOME` directory itself, you cannot perform a standard `git clone` into a non-empty directory. Follow these steps to restore configurations on a new machine:

### 1. Initialize & Connect
Open a terminal in your home directory:

```bash
cd ~
git init
git remote add origin <YOUR_REPO_URL>
```

### 2. Fetch & Reset
Fetch the contents and force the checkout to overwrite any default config files created by the OS installation:

```bash
git fetch
git checkout -f master
```

> Note: The -f flag is required because some default files (like .zshrc) might already exist.

🧠 How It Works (The Whitelist Strategy)
This repository relies on a specific .gitignore logic to avoid tracking the thousands of unrelated files in the home directory.

Logic:

1. **Ignore Everything:**  ```/*``` ignores the entire root.

2. **Allow Config Folder:** ```!.config/``` allows entry into the config directory.

3. **Ignore Config Contents:** ```.config/*``` ignores everything inside config by default.

4. **Whitelist Apps:** Specific folders (e.g., ```!.config/nvim/```) are explicitly allowed.

**Adding New Tools**
To track a new tool (e.g., ```tmux```), edit ```.gitignore```:

1. Open ```.gitignore```.

2. Add the exception rule at the bottom:

```Snippet de código

!.config/tmux/
```
3. Add the files:

```Bash

git add .config/tmux/
git commit -m "Add tmux config"
```

### 📦 Requirements
Ensure the following packages are installed on the fresh system for these configs to work correctly:

```Bash

# Linux Mint / Ubuntu
sudo apt-get update
sudo apt-get install zsh neovim alacritty rofi git
```

