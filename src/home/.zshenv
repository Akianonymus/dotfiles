[ -d "$HOME/.bin" ] && PATH="$HOME/.bin:$PATH"
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/go/bin" ] && PATH="$HOME/go/bin:$PATH"
[ -d "$HOME/.local/share/bob/nvim-bin" ] && PATH="$HOME/.local/share/bob/nvim-bin:$PATH"

[ -f "${HOME}/.gdrive-downloader/gdl" ] && [ -x "${HOME}/.gdrive-downloader/gdl" ] && PATH="${HOME}/.gdrive-downloader:${PATH}"
[ -f "${HOME}/.google-drive-upload/bin/gupload" ] && [ -x "${HOME}/.google-drive-upload/bin" ] && PATH="${HOME}/.google-drive-upload/bin:${PATH}"

# if [ -d "$HOME/.pyenv" ]; then
#   export PYENV_ROOT="$HOME/.pyenv"
#   export PATH="$PYENV_ROOT/bin:$PATH"
#
#   # Initialize pyenv if installed
#   if command -v pyenv >/dev/null 2>&1; then
#     eval "$(pyenv init --path)"
#     eval "$(pyenv init -)"
#   fi
# fi

[ -d "$HOME/.npm-global/bin" ] && PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"

command -v mise > /dev/null && eval "$(mise activate zsh)"
