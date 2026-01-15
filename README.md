# dotfiles

Managed with GNU Stow.

## Structure

```
home/              # single stow package containing all dotfiles
├── .zshrc
├── .zshenv
├── .p10k.zsh
├── .gitconfig
├── .npmrc
├── .config/       # application configs
│   ├── nvim/
│   ├── mpv/
│   ├── kitty/
│   ├── wezterm/
│   ├── gh/
│   ├── lsd/
│   ├── gotop/
│   ├── mise/
│   ├── auto-cpufreq/
│   ├── .ideavimrc
│   ├── nvim-vscode/
│   └── .vscode-settings/
└── .local/
    └── share/fonts/

misc/              # helper scripts + wallpaper (not stowed)
termux/            # termux-specific configs (separate package)
scripts/           # setup scripts
```

## Usage

Full setup (Arch Linux or Termux):

```bash
./setup.sh
```

Stow everything (all dotfiles):

```bash
bash scripts/stow_setup.sh
# or
stow -R src
```

Unstow everything:

```bash
stow -D src
```

Stow termux only (on Termux):

```bash
stow -R termux
```

Install language servers:

```bash
bash scripts/lang-setup.sh all
# or individual:
bash scripts/lang-setup.sh python rust lua
```
