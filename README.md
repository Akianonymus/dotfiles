# dotfiles

Cross-platform dotfiles managed with GNU Stow.

## Supported Platforms

- **Arch Linux** - yay + AUR
- **Ubuntu** - Homebrew
- **Termux** - pkg
- **WSL** - Homebrew

## Setup

```bash
git clone https://github.com/Akianonymus/dotfiles ~/.dotfiles
cd ~/.dotfiles
./setup.sh
```

## Scripts

- `setup.sh` - Auto-detects OS and installs packages
- `arch-packages.sh` - Arch package installation + system configs (yay)
- `ubuntu-packages.sh` - Ubuntu package installation (brew)
- `scripts/lang-setup.sh` - Language servers (all platforms)
- `scripts/stow_setup.sh` - Stow dotfiles

## Stow

```bash
# Stow all
stow -R src

# Unstow
stow -D src
```
