#!/usr/bin/env bash

alarm() {
    declare t="${1:?Give time in hrs}"
    sudo rtcwake -m mem -s "$((t * 60 * 60))"
    vlc '/data/stash/Distraction/Music/Angrezi/how deep﹖ how deep﹖ Tai Verdes.m4a'
}

merge_media() {
    # Display help if no arguments or `--help` is passed
    if [ "$#" -eq 0 ] || [[ "$1" == "--help" ]]; then
        echo "Usage: merge_media <output_file> <input_file1> [<input_file2> ...]"
        echo
        echo "Description:"
        echo "  Concatenates multiple audio or video files into a single file using ffmpeg."
        echo "  The output format is determined by the extension of <output_file>."
        echo
        echo "Arguments:"
        echo "  output_file      Path to the output file (e.g., output.mp4, output.mp3)"
        echo "  input_files      One or more input files to be concatenated."
        echo
        echo "Example:"
        echo "  merge_media output.mp4 video1.mp4 video2.mp4"
        echo "  merge_media output.mp3 audio1.mp3 audio2.mp3"
        echo
        return 0
    fi

    # Check if at least two arguments are provided
    if [ "$#" -lt 2 ]; then
        echo "Error: Not enough arguments provided. Use --help for usage details." >&2
        return 1
    fi

    # Extract the output file and input files
    output_file="$1"
    shift
    input_files=("$@")

    # Check if ffmpeg is installed
    if ! command -v ffmpeg &> /dev/null; then
        echo "Error: ffmpeg is not installed." >&2
        return 1
    fi

    # Check if output file already exists to avoid overwriting
    if [ -e "$output_file" ]; then
        echo "Error: Output file '$output_file' already exists. Please choose a different name or remove the existing file." >&2
        return 1
    fi

    # Check if output directory exists and is writable
    output_dir=$(dirname "$output_file")
    if [ ! -d "$output_dir" ] || [ ! -w "$output_dir" ]; then
        echo "Error: Directory '$output_dir' does not exist or is not writable." >&2
        return 1
    fi

    # Check if all input files exist and are readable
    for file in "${input_files[@]}"; do
        if [ ! -r "$file" ]; then
            echo "Error: Input file '$file' does not exist or is not readable." >&2
            return 1
        fi
    done

    # Create a temporary file for the file list
    temp_list=$(mktemp)
    trap 'rm -f "$temp_list"' EXIT

    # Populate the temporary file list
    for file in "${input_files[@]}"; do
        printf "file '%s'\n" "$(realpath "$file")" >> "$temp_list"
    done

    # Run ffmpeg to concatenate files
    if ffmpeg -f concat -safe 0 -i "$temp_list" -c copy "$output_file"; then
        echo "Successfully created '$output_file'."
    else
        echo "Error: Failed to create '$output_file'." >&2
        return 1
    fi
}

alias videomerge='merge_media'
alias audiomerge='merge_media'

# batch rename files
brename() {
    abspath() {
        case "$1" in
            /*) printf "%s\n" "$1" ;;
            *) printf "%s\n" "$PWD/$1" ;;
        esac
    }
    if [ $# -gt 1 ]; then
        sed_pattern=$1
        shift
        for file in "${@}"; do
            target="$(sed "${sed_pattern}" <<< "$file")"
            mkdir -p "$(dirname "$(abspath "$target")")"
            mv -v "$file" "$target"
        done
    else
        echo "usage: $0 sed_pattern files..."
    fi
}

# funtion to upload to pixeldrain
# todo: add this
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
    local status="" mode="" node='/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode'

    [[ -f ${node} ]] || { echo "No node for conservation mode." && return 1; }
    if grep -q 1 "${node}"; then
        status="Disabled" mode=0
    else
        status="Enabled" mode=1
    fi

    [[ -w ${node} ]] || {
        echo "Enter sudo passwd"
        sudo chown -R "$(whoami):$(whoami)" "${node}" || return 1
    }
    echo "${mode}" | sudo tee "${node}" > /dev/null
    echo "Conservation mode ${status}"
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

reload_plasmashell() {
    command -v plasmashell && {
        killall plasmashell
        plasmashell > /dev/null 2>&1 &
        disown
    }
}
export reload_plasmashell

update_mirror() {
    command -v reflector &&
        sudo reflector --latest 5 --age 2 --fastest 5 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
}
export update_mirror

function y() {
    command -v yazi &&
        {

            local tmp
            tmp="$(mktemp -t 'yazi-cwd.XXXXXX')" cwd
            yazi "$@" --cwd-file="${tmp}"
            if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
                builtin cd -- "$cwd" || return
            fi
            rm -f -- "$tmp"
        }
}
export y

function waydroid_stop() {
    command -v waydroid && {
        waydroid session stop
        if [[ "$1" == "f" ]]; then
            sudo waydroid container stop
        fi
    }
}
export waydroid_stop
