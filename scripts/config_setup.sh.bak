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

symlink_single() {
    symlink="${1:?Error: Missing path}"
    target="${2:?Error: Missin Target}"
    full_path="${target}/${symlink}"

    [[ -d ${full_path} || -f ${full_path} ]] && mv -f "${full_path}" "${full_path}.bak"
    ln -sfr "${symlink}" "${full_path}"
}

symlink_multiple() {
    local symlink full_path
    for symlink in "${@}"; do
        symlink_single "${symlink}" "${HOME}"
    done
}

create_dirs() {
    find "${1:?Error: Give Source Dir}" -type d | while read -r dir; do
        target_dir="${2:?Error: Give Target Dir}/${dir}"
        if [[ ! -d "$target_dir" ]]; then
            mkdir -p "$target_dir"
        fi
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
    cd "${current_dir}/src/home" || return 1

    mkdir -p "${HOME}"/{.bin,.cache/zsh}

    find "." -type d | while read -r dir; do
        target_dir="${HOME}/${dir}"
        if [[ ! -d "$target_dir" ]]; then
            mkdir -v -p "$target_dir"
        fi
    done

    find "." -type f | while read -r file; do
        symlink_single "${file}" "${HOME}"
    done

    # handle termux stuff
    [[ ${1:-} = arch ]] || {
        [[ -n ${TERMUX_VERSION} ]] || return 0

        mkdir -p "${HOME}/.termux"
        symlink_list=(.termux/{colors.properties,dark,font.ttf,light,termux.properties})

        symlink_multiple "${symlink_list[@]}"
    }
}

main "${@}" || exit 1
