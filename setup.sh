#!/bin/bash

main() {
    set -o errexit -o noclobber -o pipefail

    [[ $EUID -eq 0 ]] && exit 1

    decalre os=""

    { grep -qE 'Arch Linux|EndeavourOS' /etc/os-release 2> /dev/null && os=arch; } ||
        { [[ -n ${TERMUX_VERSION} ]] && os=termux; } || :

    case "${os}" in
        arch)
            packages=(aria2
                auto-cpufreq
                baka-mplayer base-devel bat
                fd fzf firefox
                git git-delta-git github-cli gotop-bin
                htop
                jq
                kitty
                lsd
                mpv
                neovim
                ripgrep
                touche touchegg
                zoxide zsh)

            # install yay
            command -v yay > /dev/null || (
                git clone "https://aur.archlinux.org/yay-bin" .build
                cd .build && makepkg -si --noconfirm
                cd ../
                rm -rf .build
            )

            yay --noconfirm --norebuild -S "${packages[@]}"
            chsh -s "$(chsh -l zsh | grep -m 1 zsh)"

            # get rid of system beep
            sudo rmmod pcspkr snd_pcsp &> /dev/null
            printf "blacklist pcspkr\nblacklist snd_pcsp" | sudo tee /etc/modprobe.d/nobeep.conf 1> /dev/null

            # https://man.archlinux.org/man/libinput.4
            printf 'Section "InputClass"
    Identifier "libinput touchpad catchall"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    Driver "libinput"
    # Enable adaptice touchpad
    Option "AccelProfile" "adaptive"
    # Enable tap to click
    Option "Tapping" "on"
    # Enable double tab and drag
    Option "TappingDrag" "on"
    # Disable when typing
    Option "DisableWhileTyping" "true"
    # Enable horizontal scrolling
    Option "HorizontalScrolling" "true"
    Option "NaturalScrolling" "true"
    # Enable edge scrolling
    Option "ScrollMethod" "twofinger"
    Option "ScrollPixelDistance" "30"
EndSection\n' | sudo tee /etc/X11/xorg.conf.d/40-libinput.conf 1> /dev/null

            # enable experimental bluetooth features - to enable battery info
            sed -E -e "s/^#+?[[:space:]]+?Experimental[[:space:]]+?=[[:space:]]+?false/Experimental = true/" \
                /etc/bluetooth/main.conf | sudo tee /etc/bluetooth/main.conf
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
        *)
            echo "Not supported linux." && exit 1
            ;;
    esac

    # setup zsh and other configs
    bash config_setup.sh "${os}" || return 1
}

main "${@}" || exit 1
