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

main() {
    for cmd in zsh git stow; do
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

    cd "${current_dir}" || return 1

    mkdir -p "${HOME}"/{.bin,.cache/zsh}

    # Stow home package
    [[ -d src ]] && {
        echo "Stowing src..."
        stow -R src || { echo "Failed to stow home" && return 1; }
    }

    # Handle termux separately
    [[ -n ${TERMUX_VERSION} ]] && [[ -d termux ]] && {
        echo "Stowing termux..."
        stow -R termux || { echo "Failed to stow termux" && return 1; }
    }
}

main "${@}" || exit 1
