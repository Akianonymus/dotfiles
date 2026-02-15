#!/bin/bash

main() {
    set -o errexit -o noclobber -o pipefail

    [[ $EUID -eq 0 ]] && exit 1

    declare os=""

    { grep -qE 'Arch Linux|EndeavourOS' /etc/os-release 2> /dev/null && os=arch; } ||
        { grep -qE 'Ubuntu' /etc/os-release 2> /dev/null && os=ubuntu; } ||
        { [[ -n ${TERMUX_VERSION} ]] && os=termux; } || :

    case "${os}" in
        arch)
            sh ./arch-packages.sh
            chsh -s "$(chsh -l zsh | grep -m 1 zsh)"
            ;;
        termux)
            packages=(
                aria2
                bat
                fd fzf
                git git-delta gh gotop
                htop-legacy
                jq
                lsd
                neovim
                ripgrep
                zoxide zsh
            )
            pkg upgrade
            # install packages
            pkg install "${packages[@]}"

            chsh -s zsh
            ;;
        ubuntu)
            bash ./ubuntu-packages.sh
            sudo chsh -s "$(which zsh)" || echo "Warning: Could not change default shell to zsh"
            ;;
        *)
            echo "Error: Unsupported operating system"
            echo "Supported: Arch Linux, EndeavourOS, Ubuntu, Termux"
            exit 1
            ;;
    esac

    # setup zsh and other configs
    bash scripts/stow_setup.sh "${os}" || return 1
}

main "${@}" || exit 1
