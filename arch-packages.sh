#!/bin/bash

set -o errexit -o noclobber -o pipefail

packages=(
    aria2
    papirus-icon-theme
    # intel-media-driver
    auto-cpufreq base-devel
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
    scrcpy
    warpinator
    yazi
    64gram-desktop-bin
    anydesk-bin
    pinta
    freedownloadmanager
    google-chrome
    ventoy-bin
    electron30-bin
    ytdownloader-gui-bin
    mongodb-compass-bin
    yt-dlp
    apidog-bin
    libreoffice-fresh
    kimageformats5
    stow
    android-tools
    mise
    claude-code
    opencode-bin
    dbgate-bin
    mongodb-bin
    mongodb-tools-bin
    bitwarden
    rclone
    ngrok
    ollama
    glances
    inxi
    tldr
    pandoc-bin
    bun
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

# Apply Arch-specific system configurations
# get rid of system beep
sudo rmmod pcspkr snd_pcsp &> /dev/null
printf "blacklist pcspkr\nblacklist snd_pcsp" | sudo tee /etc/modprobe.d/nobeep.conf 1> /dev/null

# https://man.archlinux.org/man/libinput.4
printf 'Section "InputClass"
    Identifier "libinput touchpad catchall"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    Driver "libinput"
    # Enable adaptive touchpad
    Option "AccelProfile" "adaptive"
    # Enable tap to click
    Option "Tapping" "on"
    # Enable double tap and drag
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
sed -E -e "s/^#+?[[:space:]]+Experimental[[:space:]]+?=[[:space:]]+?false/Experimental = true/" \
    /etc/bluetooth/main.conf | sudo tee /etc/bluetooth/main.conf
