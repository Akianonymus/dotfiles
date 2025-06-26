#!/bin/bash

packages=(
    apidog-bin
    libreoffice-fresh
    visual-studio-code-bin
    mongodb-compass
    google-chrome
    64gram-desktop-bin
    bun-bin
    vlc
    yt-dlp
    ytdownloader-gui-bin
    anydesk-bin
    ventoy-bin
    yazi
    partitionmanager
    kooha
    warpinator
    kimageformats5
    stow
    android-tools
    mise
)

# install yay
command -v yay > /dev/null || (
    git clone "https://aur.archlinux.org/yay-bin" .build
    cd .build && makepkg -si --noconfirm
    cd ../
    rm -rf .build
)

yay --noconfirm --norebuild -S "${packages[@]}"
