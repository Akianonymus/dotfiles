#!/bin/bash

main() {
    for cmd in zsh git grep; do
        command -v "${cmd}" >| /dev/null || { echo "${cmd} not available." && exit 1; }
    done
    local current_dir="${PWD}"
    local path="${HOME}/.dotfiles"
    local main_repo="https://github.com/Akianonymus/dotfiles"
    local dotfiles_path="${path}/dotfiles"
    local repos=(
        https://github.com/romkatv/powerlevel10k
        https://github.com/zdharma/fast-syntax-highlighting
        https://github.com/Aloxaf/fzf-tab
        https://github.com/zsh-users/zsh-autosuggestions
    )

    mkdir -p "${path}" || return 1
    cd "${path}" || return 1

    printf '%s' "${main_repo}: "
    if [[ -d ${dotfiles_path} ]]; then
        if git -C "${dotfiles_path}" remote -v | grep -q "Akianonymus/dotfiles"; then
            if git -C "${dotfiles_path}" ls-files -o -m -d | grep -q ""; then
                echo "Error: There are some unmerged files." && return 1
            else
                git -C "${dotfiles_path}" pull || { echo "failed to update ${main_repo}" && return 1; }
            fi
        else
            mv -f "${dotfiles_path}" "${dotfiles_path}.bak"
            git clone "${main_repo}" "${dotfiles_path}" --depth 2 || { echo "failed to clone ${main_repo}" && return 1; }
        fi
    else
        [[ -f "${dotfiles_path}" ]] && mv -f "${dotfiles_path}" "${dotfiles_path}.bak"
        git clone "${main_repo}" "${dotfiles_path}" --depth 2 || { echo "failed to clone ${main_repo}" && return 1; }
    fi

    for repo in "${repos[@]}"; do
        repo_path="${repo##*/}"
        printf '%s' "${repo_path}: "
        if [[ -d "${repo_path}" ]]; then
            if git -C "${repo_path}" remote -v | grep -q "${repo_path}"; then
                git -C "${repo_path}" pull || { echo "failed to update ${repo}" && return 1; }
            else
                mv -f "${repo_path}" "${repo_path}.bak"
                git clone "${repo}" "${repo_path}" --depth 2 || { echo "failed to clone ${repo}" && return 1; }
            fi
        else
            [[ -f "${repo_path}" ]] && mv -f "${repo_path}" "${repo_path}.bak"
            git clone "${repo}" "${repo_path}" --depth 2 || { echo "failed to clone ${repo}" && return 1; }

        fi
    done

    # now symlink
    dir_to_create=("${HOME}/.config" "${HOME}/.config/gh" "${HOME}/.config/sublime-text-3/Packages" "${HOME}/.local/share" "${HOME}/.cache/zsh")
    symlink_list=(.config/gh/config.yml .config/gotop .config/kitty .config/lsd .config/sublime-text-3/Packages/User
        .local/share/fonts
        .dotfiles/misc
        .p10k.zsh .zshrc .zshenv .gitconfig)
    mkdir -p "${dir_to_create[@]}"
    cd "${dotfiles_path}/src" || return 1
    for symlink in "${symlink_list[@]}"; do
        full_path="${HOME}/${symlink}"
        [[ -d ${full_path} || -f ${full_path} ]] && mv -f "${full_path}" "${full_path}.bak"
        ln -sfr "${symlink}" "${full_path}"
    done

    cd "${current_dir}" || return 1
}

main || exit 1
