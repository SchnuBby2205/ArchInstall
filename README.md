# 🐧 SchnuBby Arch Installer

An advanced **interactive Bash installer** for setting up a customized Arch Linux environment with optional desktop configurations, application presets, and `SchnuBby`-specific dotfiles.

---

## ⚡ Features

- ✅ Guided Arch Linux base installation
- ✅ Interactive terminal UI with colorful prompts
- ✅ Supports Hyprland via HyDE
- ✅ Modular options (e.g., dotfiles, GPU config, GRUB, system locales)
- ✅ `SchnuBby` presets (lutris, zsh history, Steam, fstab, git config, etc.)
- ✅ Password setup flow with confirmation
- ✅ Optional headless/scriptable defaults

---

## 📁 Repository Structure

- `install.sh` – main script with all logic
- `HyDE` – optional Hyprland dotfiles repository
- `.config/`, `.zsh_history`, `.gitconfig` – sourced from mounted backup
- `fstab`, etc. – optional config files used during install

---

## 🧰 Requirements

- A working Arch ISO (booted)
- Internet connection
- Mounted backup volume (e.g. `/programmieren`)
- Open terminal access as `root` or via `sudo`
- `git`, `pacman`, and optionally `yay` pre-installed

---

## 🚀 Quick Start

### 1. **Download the script**
```bash
curl -o https://raw.githubusercontent.com/SchnuBby/ArchInstall/main/ArchInstall.sh ./ArchInstall.sh
chmod +x ./ArchInstall.sh
