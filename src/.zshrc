# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

zsh_config_folder="${HOME:?}/.dotfiles"

# End of lines configured by zsh-newuser-install
[[ -f ${zsh_config_folder}/powerlevel10k/powerlevel10k.zsh-theme ]] && source "${zsh_config_folder}/powerlevel10k/powerlevel10k.zsh-theme"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# automatic dir change
setopt autocd

# enable history and set related options
HISTFILE="$HOME/.cache/zsh/history"
HISTSIZE=1000000
SAVEHIST=$HISTSIZE
setopt hist_expire_dups_first    # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups          # ignore duplicated commands history list
setopt hist_ignore_space         # ignore commands that start with space
setopt hist_verify               # show command with history expansion to user before running it
setopt inc_append_history        # add commands to HISTFILE in order of execution

# enable autocomplete and set related options
autoload -Uz compinit && compinit
# fzf tab complition
[[ -f ${zsh_config_folder}/fzf-tab/fzf-tab.plugin.zsh ]] && source "${zsh_config_folder}/fzf-tab/fzf-tab.plugin.zsh"

# configure keybindings
[[ -f ${zsh_config_folder}/keybindings.zsh ]] && source "${zsh_config_folder}/keybindings.zsh"

# fish like auto suggestions for zsh
[[ -f ${zsh_config_folder}/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source "${zsh_config_folder}/zsh-autosuggestions/zsh-autosuggestions.zsh"

# a powerful alternative for cd
command -v zoxide > /dev/null && eval "$(zoxide init zsh)" && alias cd="z"

# ls colors for ls / lsd / exa
[[ -f ${zsh_config_folder}/misc/ls_colors ]] && source "${zsh_config_folder}/misc/ls_colors"
command -v lsd >/dev/null && alias ls='lsd'
alias l='ls -l' \
	la='ls -a' \
	lla='ls -la' \
	lt='ls --tree'

# source the git aliases
[[ -f ${zsh_config_folder}/misc/git_aliases ]] && source "${zsh_config_folder}/misc/git_aliases"

# some functions for stuff
[[ -f ${zsh_config_folder}/misc/functions ]] && source "${zsh_config_folder}/misc/functions"

{ command -v nvim >/dev/null && export EDITOR=nvim ;} || export EDITOR="nano"

# should be sourced at last to avoid startup delays
[[ -f ${zsh_config_folder}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]] && source "${zsh_config_folder}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
