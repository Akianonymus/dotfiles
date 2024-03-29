#!/usr/bin/env sh

# shfmt - beautify scripts
if command -v shfmt 1>| /dev/null; then
    printf "Beautifying scripts with shfmt... \n"
    for i in ./*.sh src/misc/*.sh; do
        if ! shfmt -w "${i}"; then
            printf "%s\n\n" "${i}: ERROR"
            format_status=1
        else
            printf "%s\n" "${i}: SUCCESS"
        fi
    done
    format_status="${format_status:-0}"
    printf "\n"
else
    printf 'Install shfmt to format script\n\n'
    printf 'Check https://github.com/mvdan/sh/releases\n\n'
fi

# shell check - lint script
if command -v shellcheck 1>| /dev/null; then
    printf "Linting scripts with shellcheck... \n"
    for i in ./*.sh src/misc/*.sh; do
        if ! shellcheck "${i}"; then
            printf "\n%s\n\n" "${i}: ERROR"
            lint_status=1
        else
            printf "%s\n" "${i}: SUCCESS"
        fi
    done
    lint_status="${lint_status:-0}"
    printf "\n"
else
    printf 'Install shellcheck to lint script.\n'
    printf 'Check https://www.shellcheck.net/ or https://github.com/koalaman/shellcheck\n\n'
fi

if command -v stylua >| /dev/null; then
    printf "Formatting lua files with stylua.. \n"
    find . -name "*.lua" -exec stylua {} \;
    format_status="${?:-0}"
    printf "\n"
else
    printf 'Install stylua to format lua files\n'
fi

case "${format_status}" in
    1) printf "Error: Some files not formatted succesfully.\n" ;;
esac

case "${lint_status}" in
    1) printf "Error: Some shellcheck warnings need to be fixed.\n" ;;
esac

if [ "${lint_status}" = 1 ] || [ "${format_status}" = 1 ]; then
    exit 1
else
    exit 0
fi
