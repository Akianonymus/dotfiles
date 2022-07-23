#!/usr/bin/env bash
declare os=""

{ grep -qE 'Arch Linux|EndeavourOS' /etc/os-release 2> /dev/null && os=arch; } ||
    { [[ -n ${TERMUX_VERSION} ]] && os=termux; } || :

if [[ ${os} = 'arch' ]]; then
    declare yay_c=(yay --noconfirm --norebuild --noredownload -S)
    yay_install() {
        for p in "${@}"; do
            declare ver=''
            if ver="$(pacman -Qs "^${p}$")"; then
                ver="$(head -n 1 <<< "${ver}" | sed "s|.*${p} ||g")"
                if yay -Ss "${p}" | grep -q "${p} ${ver}"; then
                    echo "${p}" latest version already installed.
                    continue
                fi
            fi
            "${yay_c[@]}" "${p}"
        done
    }
    _c() { yay_install clang; }

    _bash() { yay_install shellcheck-bin shfmt && sudo npm install -g bash-language-server; }

    _lua() { yay_install luacheck lua-language-server stylua; }

    _python() {
        sudo npm install -g pyright
        sudo pip install black isort flake8
    }

    _rust() { yay_install rust rust-analyzer; }

    _treesitter() { yay_install tree-sitter-git; }

    _web() { sudo npm install -g emmet-ls @fsouza/prettierd vscode-langservers-extracted; }

elif [[ ${os} = 'termux' ]]; then
    _c() { pkg install clang; }

    _bash() {
        pkg install shfmt
        npm update -g bash-language-server

        # install shellcheck
        ldir="$(mktemp -d)"
        {
            (
                cd "${ldir}"
                wget -O shellcheck.tar.xz https://github.com/koalaman/shellcheck/releases/download/v0.8.0/shellcheck-v0.8.0.linux.aarch64.tar.xz
                tar -xf shellcheck.tar.xz
                cp shellcheck-v0.8.0/shellcheck "${HOME}/.bin/shellcheck_binary"
            ) || return 1
            rm -rf "${ldir}"
            printf "%s\n%s\n" "#\!/usr/bin/env sh" \
                "[ -x \"\${HOME}/.bin/shellcheck_binary\" ] && su -c \"\${HOME}/.bin/shellcheck_binary\" \"\${@}\"" >| "${HOME}/.bin/shellcheck"
        } || { rm -rf "${ldir}" && return 1; }
    }

    _lua() { pkg install luarocks lua-language-server stylua && luarocks install luacheck; }

    _python() {
        npm update -g pyright
        install black isort flake8
    }

    _rust() { pkg install rust rust-analyzer; }

    _treesitter() {
        ldir="$(mktemp -d)"
        {
            (
                cd "${ldir}"
                wget -O ts.zip https://github.com/tree-sitter/tree-sitter/archive/refs/heads/master.zip
                unzip ts.zip
                (
                    cd tree-sitter-master/cli
                    cargo build --release -j 4
                ) &&
                    cp tree-sitter-master/target/release/tree-sitter "${HOME}/.bin/tree-sitter"
            ) || return 1
            rm -rf "${ldir}"
        } || { rm -rf "${ldir}" && return 1; }
    }

    _web() { npm update -g emmet-ls @fsouza/prettierd vscode-langservers-extracted; }
else
    exit 0
fi

_FUNCTIONS=(c bash lua python rust treesitter web)

main() {
    set -o noclobber -o pipefail

    if [[ ${1} = "all" ]]; then
        for i in "${_FUNCTIONS[@]}"; do
            "_${i}"
        done
    else
        for j in "${@}"; do
            for i in "${_FUNCTIONS[@]}"; do
                [[ ${j} = "${i}" ]] && {
                    "_${i}"
                    break
                }
            done
        done
    fi

    return 0
}

main "${@}" || exit 1
