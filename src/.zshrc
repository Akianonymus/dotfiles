# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

zsh_plugin_folder="${HOME:?}/.zsh"

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
setopt hist_expire_dups_first    # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups          # ignore duplicated commands history list
setopt hist_ignore_space         # ignore commands that start with space
setopt hist_verify               # show command with history expansion to user before running it
setopt inc_append_history        # add commands to HISTFILE in order of execution

# enable autocomplete and set related options
autoload -Uz compinit && compinit
# fzf tab complition
[[ -f ${zsh_plugin_folder}/fzf-tab/fzf-tab.plugin.zsh ]] && source "${zsh_plugin_folder}/fzf-tab/fzf-tab.plugin.zsh"

# fish like auto suggestions for zsh
[[ -f ${zsh_plugin_folder}/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source "${zsh_plugin_folder}/zsh-autosuggestions/zsh-autosuggestions.zsh"

# a powerful alternative for cd
command -v zoxide > /dev/null && eval "$(zoxide init zsh)" && alias cd="z"

misc_stuff_folder="${HOME:?}/.dotfiles/src/misc"
files_to_source=(ls_colors keybindings.zsh git_aliases functions)
for f in "${files_to_source[@]}"; do
	source "${misc_stuff_folder}/${f}"
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
