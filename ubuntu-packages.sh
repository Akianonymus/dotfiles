#!/bin/bash

# Ubuntu setup script - hybrid approach
# Minimal apt (git, zsh, kitty-terminfo), Homebrew for everything else

main() {
    set -o errexit -o noclobber -o pipefail

    [[ $EUID -eq 0 ]] && exit 1

    declare os=""
    { grep -qE 'Ubuntu' /etc/os-release 2> /dev/null && os=ubuntu; } ||
        { [[ -n ${TERMUX_VERSION} ]] && os=termux; } || :

    [[ ${os} != 'ubuntu' ]] && {
        echo "This script is for Ubuntu only."
        exit 1
    }

    echo "Checking package managers..."

    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
    else
        echo "Homebrew already installed, updating..."
        brew update
    fi

    echo "Adding git PPA..."
    sudo add-apt-repository -y ppa:git-core/ppa

    echo "Updating apt cache..."
    sudo apt update

    echo "Installing apt packages (minimal system packages)..."
    sudo apt install -y git kitty-terminfo make

    echo "Installing Homebrew packages (all development tools)..."
    brew install neovim fzf mise zoxide bat fd ripgrep jq gh lsd btop aria2 stow rust anomalyco/tap/opencode zsh node oven-sh/bun/bun

    echo ""
    echo "Setup complete!"
    echo ""
    echo "Package Summary:"
    echo "  Homebrew: neovim, fzf, mise, zoxide, opencode, bat, fd, ripgrep, jq, gh, lsd, btop, aria2, stow, cargo, zsh"
    echo "  apt: git, kitty-terminfo"
    echo ""
    echo "Reload your shell or run: source ~/.zshrc"
}

main "${@}"
