[ -d "$HOME/.bin" ] && PATH="$HOME/.bin:$PATH"
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/go/bin" ] && PATH="$HOME/go/bin:$PATH"

[ -f "${HOME}/.gdrive-downloader/gdl" ] && [ -x "${HOME}/.gdrive-downloader/gdl" ] && PATH="${HOME}/.gdrive-downloader:${PATH}"
[ -f "${HOME}/.google-drive-upload/bin/gupload" ] && [ -x "${HOME}/.google-drive-upload/bin" ] && PATH="${HOME}/.google-drive-upload/bin:${PATH}"

