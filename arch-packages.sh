#!/bin/bash

packages=(
    aria2
    papirus-icon-theme
    intel-media-driver auto-cpufreq base-devel
    bat fd fzf git git-delta
    github-cli btop jq lsd mpv
    bob neovim ripgrep wezterm zoxide zsh
    android-file-transfer
    ark
    sqlitebrowser
    dolphin
    filelight
    firefox
    partitionmanager
    kitty
    kooha
    mpv
    neovim
    scrcpy
    vlc
    warpinator
    64gram-desktop-bin
    anydesk-bin
    cursor-bin
    pinta
    freedownloadmanager
    google-chrome
    auto-cpufreq
    ventoy-bin
    yazi
    electron30-bin
    ytdownloader-gui-bin
    mongodb-compass-bin
    yt-dlp
    apidog-bin
    libreoffice-fresh visual-studio-code-bin
    google-chrome 64gram-desktop-bin
    vlc yt-dlp
    anydesk-bin ventoy-bin yazi
    kimageformats5 stow
    android-tools mise
)

# install yay
command -v yay > /dev/null || (
    git clone "https://aur.archlinux.org/yay-bin" .build
    cd .build && makepkg -si --noconfirm
    cd ../
    rm -rf .build
)

yay -Syu
yay --noconfirm --norebuild -S "${packages[@]}"
