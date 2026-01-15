export LANG=en_US.UTF-8
#
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

local zsh_plugin_folder="${HOME:?}/.zsh"

# End of lines configured by zsh-newuser-install
[[ -f ${zsh_plugin_folder}/powerlevel10k/powerlevel10k.zsh-theme ]] && source "${zsh_plugin_folder}/powerlevel10k/powerlevel10k.zsh-theme"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# automatic dir change
setopt autocd

# enable history and set related options
HISTFILE="$HOME/.cache/zsh/history"
HISTSIZE=1000000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt hist_expire_dups_first    # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups          # ignore duplicated commands history list
setopt hist_ignore_space         # ignore commands that start with space
setopt hist_verify               # show command with history expansion to user before running it
setopt inc_append_history        # add commands to HISTFILE in order of execution
# setopt sharehistory
# setopt appendhistory
setopt hist_find_no_dups

zstyle ':completion:*' rehash true
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
# enable autocomplete and set related options
autoload -Uz compinit  && compinit
autoload -U bashcompinit && bashcompinit
# fzf tab complition
[[ -f ${zsh_plugin_folder}/fzf-tab/fzf-tab.plugin.zsh ]] && {
  source "${zsh_plugin_folder}/fzf-tab/fzf-tab.plugin.zsh"
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
  zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
}

# fish like auto suggestions for zsh
[[ -f ${zsh_plugin_folder}/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source "${zsh_plugin_folder}/zsh-autosuggestions/zsh-autosuggestions.zsh"


# history search fzf
[[ -f ${zsh_plugin_folder}/zsh-fzf-history-search/zsh-fzf-history-search.zsh ]] && source "${zsh_plugin_folder}/zsh-fzf-history-search/zsh-fzf-history-search.zsh"

# a powerful alternative for cd
export _ZO_DOCTOR=0
command -v zoxide > /dev/null && eval "$(zoxide init zsh)" && alias cd="z"

misc_stuff_folder="${HOME:?}/.dotfiles/src/misc"
files_to_source=(ls_colors.sh keybindings.zsh aliases.sh git_aliases.sh functions.sh)
for f in "${files_to_source[@]}"; do
	pp="${misc_stuff_folder}/${f}"
	[[ -f ${pp} ]] && source "${pp}"
done

# use lsd if available
command -v lsd >/dev/null && alias ls='lsd'
alias l='ls -l' \
	la='ls -a' \
	lla='ls -la' \
	lt='ls --tree'

{ command -v nvim >/dev/null && export EDITOR=nvim ;} || export EDITOR="nano"

# should be sourced at last to avoid startup delays
[[ -f ${zsh_plugin_folder}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]] && source "${zsh_plugin_folder}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# blur if kitty terminal opened
if [[ $(ps --no-header -p $PPID -o comm) =~ '^yakuake|kitty$' ]]; then
        for wid in $(xdotool search --pid $PPID); do
            xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id $wid; done
fi

command -v fzf > /dev/null && source <(fzf --zsh)

function command_not_found_handler() {
  local pkgs cmd="$1"
  local RED GREEN YELLOW BLUE RESET

  # Define color codes
  RED=$'%{\e[31m%}'
  GREEN=$'%{\e[32m%}'
  YELLOW=$'%{\e[33m%}'
  RESET=$'%{\e[0m%}'
  BLUE=$'%{\e[34m%}'

  pkgs=(${(f)"$(pkgfile -b -v -- "$cmd" 2>/dev/null)"})
  if [[ -n "$pkgs" ]]; then
    # Use print -P here
    print -P "${YELLOW}${cmd}${RESET} ${GREEN}may be found in the following packages:${RESET}"
    for pkg in $pkgs[@]; do
      print -P "  ${BLUE}${pkg}${RESET}"
    done
  else
    # Use print -P here
    print -P "${RED}zsh: command not found: ${cmd}${RESET}" 1>&2
  fi

  return 127
}

if [[ -r /usr/share/bash-completion/completions/aria2c ]]; then
  source /usr/share/bash-completion/completions/aria2c
fi

# shuvcode
export PATH=/home/aki/.shuvcode/bin:$PATH
