#!/bin/bash

handle_repo() {
    local repo="${1:?}"
    local repo_path="${2:-${repo##*/}}"
    printf '%s' "${repo_path}: "
    if [[ -d "${repo_path}" ]]; then
        if git -C "${repo_path}" remote -v | grep -q "${3:-${repo_path}}"; then
            git -C "${repo_path}" pull || { echo "failed to update ${repo}" && return 1; }
        else
            mv -f "${repo_path}" "${repo_path}.bak"
            git clone "${repo}" "${repo_path}" --depth 2 || { echo "failed to clone ${repo}" && return 1; }
        fi
    else
        [[ -f "${repo_path}" ]] && mv -f "${repo_path}" "${repo_path}.bak"
        git clone "${repo}" "${repo_path}" --depth 2 || { echo "failed to clone ${repo}" && return 1; }

    fi
}

symlink() {
    local symlink full_path
    for symlink in "${@}"; do
        full_path="${HOME}/${symlink}"
        [[ -d ${full_path} || -f ${full_path} ]] && mv -f "${full_path}" "${full_path}.bak"
        ln -sfr "${symlink}" "${full_path}"
    done
}

main() {
    for cmd in zsh git grep; do
        command -v "${cmd}" >| /dev/null || { echo "${cmd} not available." && exit 1; }
    done
    local current_dir="${PWD}"
    [[ "${current_dir}" =~ ${HOME}/.dotfiles ]] || { echo "Not in ${HOME}/.dotfiles directory" && return 1; }

    local zsh_stuff="${HOME}/.zsh"
    local repos=(
        https://github.com/romkatv/powerlevel10k
        https://github.com/zdharma-continuum/fast-syntax-highlighting
        https://github.com/Aloxaf/fzf-tab
        https://github.com/zsh-users/zsh-autosuggestions
        https://github.com/joshskidmore/zsh-fzf-history-search
    )

    mkdir -p "${zsh_stuff}"

    cd "${zsh_stuff}" || return 1
    for repo in "${repos[@]}"; do
        handle_repo "${repo}" || return 1
    done

    # now symlink
    # create dirs
    mkdir -p "${HOME}"/{.bin,.config/{gh,gotop,kitty,lsd,mpv,nvim,wezterm,auto-cpufreq},.local/share/fonts,.cache/zsh}
    # files to be symlinked
    symlink_list=(.config/mpv .config/nvim .config/.ideavimrc .config/wezterm .config/auto-cpufreq/auto-cpufreq.conf
        .config/gh/config.yml .config/gotop/gotop.conf .config/kitty/kitty.conf .config/lsd/config.yaml
        '.local/share/fonts/JetBrains Mono Bold Italic Nerd Font Complete.ttf'
        '.local/share/fonts/JetBrains Mono Bold Nerd Font Complete.ttf'
        '.local/share/fonts/JetBrains Mono ExtBd Ita Nerd Font Complete.ttf'
        '.local/share/fonts/JetBrains Mono ExtraBold ExBd I Nerd Font Complete.ttf'
        '.local/share/fonts/JetBrains Mono ExtraBold ExtBd Nerd Font Complete.ttf'
        '.local/share/fonts/JetBrains Mono Extra Bold Nerd Font Complete.ttf'
        '.local/share/fonts/JetBrains Mono Italic Nerd Font Complete.ttf'
        '.local/share/fonts/JetBrains Mono Medium Italic Nerd Font Complete.ttf'
        '.local/share/fonts/JetBrains Mono Medium Med Ita Nerd Font Complete.ttf'
        '.local/share/fonts/JetBrains Mono Medium Medium Nerd Font Complete.ttf'
        '.local/share/fonts/JetBrains Mono Medium Nerd Font Complete.ttf'
        '.local/share/fonts/JetBrains Mono Regular Nerd Font Complete.ttf'
        .p10k.zsh .zshrc .zshenv .gitconfig)

    cd "${current_dir}/src" || return 1
    symlink "${symlink_list[@]}"

    # handle termux stuff
    [[ ${1:-} = arch ]] || {
        [[ -n ${TERMUX_VERSION} ]] || return 0

        mkdir -p "${HOME}/.termux"
        symlink_list=(.termux/{colors.properties,dark,font.ttf,light,termux.properties})

        symlink "${symlink_list[@]}"
    }
}

main "${@}" || exit 1
