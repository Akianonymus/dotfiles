#!/bin/bash

main() {
    set -o errexit -o noclobber -o pipefail

    [[ $EUID -eq 0 ]] && exit 1

    release=$(grep 'NAME="Arch Linux"' /etc/os-release)
    case "${release}" in
        *"Arch Linux"*)
            packages=(zsh base-devel git github-cli kitty lsd htop firefox vivaldi mpv baka-mplayer)

            sudo pacman -S "${packages[@]}"
            chsh -s "$(chsh -l zsh | grep -m 1 zsh)"

            # setup zsh and other configs
            bash config-setup.sh || return 1

            # install yay
            git clone "https://aur.archlinux.org/yay-bin" .build
            cd .build && makepkg -si --noconfirm
            cd ../
            rm -rf .build

            yay_packages=(zoxide-bin gotop-bin neovim-nightly-bin sublime-text-4-dev)

            yay --noconfirm -S "${yay_packages[@]}"
            ;;
        *)
            echo "Not arch linux" && exit 1
            ;;
    esac

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
    # Enable edge scrolling
    Option "ScrollMethod" "edge"
EndSection\n' | sudo tee /etc/X11/xorg.conf.d/40-libinput.conf 1> /dev/null

}

main "${@}" || exit 1
