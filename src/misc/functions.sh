#!/usr/bin/env bash
# function to change http urls to ssh and clone, works for bash and zsh
clone() {
    [[ -z "$1" ]] && echo "git clone needs an argument" && return 1
    local args
    args=(git clone)
    for i in "$@"; do
        case "$i" in
            *github.com*) args+=("${i/*github.com\//git@github.com:}") ;;
            *gitlab.com*) args+=("${i/*gitlab.com\//git@gitlab.com:}") ;;
            *) args+=("${i}") ;;
        esac
    done
    "${args[@]}"
}
export clone

# funtion to upload to pixeldrain
upload() {
    if [[ -n ${1} && -f ${1} ]]; then
        DOWNLOAD='https://pixeldrain.com/api/file/'$(curl -# -F 'file=@'"$1" "https://pixeldrain.com/api/file" | cut -d '"' -f 6)'?download' || return 1
        echo "${DOWNLOAD}"
    else
        echo "upload: Needs argument ( filename )"
    fi
}
export upload

# format shell scripts
fmt() {
    command -v shfmt > /dev/null || { printf "Install shfmt" && return 0; }
    env shfmt -ci -sr -i 4
}
export fmt

# lint shell scripts
shl() {
    command -v shellcheck > /dev/null || { printf "Install shellcheck" && return 0; }
    env find ./* -type f -name "*.sh" -exec sh -c '{ printf "{}" && shellcheck "{}" && printf ": SUCCESS\n" ;} || printf ": ERROR\n"' \;
    env find ./* -type f -name "*.bash" -exec sh -c '{ printf "{}" && shellcheck "{}" && printf ": SUCCESS\n" ;} || printf ": ERROR\n"' \;
}
export shl

config_update() {
    [[ -d ${HOME}/.dotfiles ]] || return 1
    cd "${HOME}/.dotfiles" || return 1
    bash config_setup.sh
    cd - || return 1
}
export config_update

# toggle conservation mode
conservation_mode() {
    local sstatus="" mode="" node='/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode'

    [[ -f ${node} ]] || { echo "No node for conservation mode." && return 1; }
    if grep -q 1 "${node}"; then
        sstatus="Disabled" mode=0
    else
        sstatus="Enabled" mode=1
    fi

    [[ -w ${node} ]] || {
        echo "Enter sudo passwd"
        sudo chown -R "$(whoami):$(whoami)" "${node}" || return 1
    }
    echo "${mode}" | sudo tee "${node}" > /dev/null
    echo "Conservation mode ${sstatus}"
}
export conservation_mode

addsshkey() {
    local key="${1:?1. Give key path}"
    [[ -r ${key} && -r ${key}.pub ]] || {
        echo "Error: Cannot read given key file."
    }
    eval "$(ssh-agent -s)" &&
        ssh-add "${key}"
}
export addsshkey
