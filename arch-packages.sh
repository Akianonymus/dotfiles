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
    discord
    dolphin
    filelight
    firefox
    partitionmanager
    kitty
    kooha
    mpv
    neovim
    scrcpy
    transmission-qt
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
    ytdownloader-gui-bin
    mongodb-compass
    yt-dlp
    apidog-bin
    libreoffice-fresh visual-studio-code-bin
    mongodb-compass google-chrome 64gram-desktop-bin
    vlc yt-dlp ytdownloader-gui-bin
    anydesk-bin ventoy-bin yazi partitionmanager
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
