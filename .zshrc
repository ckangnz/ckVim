# wt completions — must be before compinit
[[ -d "$HOME/.vim/wt" ]] && fpath=("$HOME/.vim/wt" $fpath)

# Load zsh + bash completions
autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit
compinit -C -d ~/.zcompdump &>/dev/null

# Set PATH
typeset -U path
path=(
	$HOME/.pub-cache/bin
	$HOME/.dotnet/tools
	$HOME/.rvm/bin
	/home/linuxbrew/.linuxbrew/bin
	/home/linuxbrew/.linuxbrew/sbin
	/usr/local/bin
	/usr/bin
	/bin
	/usr/sbin
	/sbin
	$path
)
export PATH

#------Source Zap--------
if [[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ]]; then
	source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
	source $HOME/.vim/plugins.zsh
else
	echo "----OOPS: You need to install ZAP!------"
	echo ""
	echo "Please copy this below:"
	echo ""
	echo "zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1"
	echo ""
	echo "Please copy this below:"
	echo ""
	echo "rm .zshrc && ln -s $HOME/.vim/.zshrc $HOME/.zshrc"
	echo ""
fi

#------Source Brew plugins--------
if command -v brew >/dev/null 2>&1; then
	export HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-$(brew --prefix)}
	export HOMEBREW_NO_AUTO_UPDATE=1
	export HOMEBREW_NO_INSTALL_CLEANUP=
	export HOMEBREW_NO_ENV_HINTS=1

	# FNM
	if [[ -e "$HOMEBREW_PREFIX/bin/fnm" ]]; then
		PATH="$FNM_MULTISHELL_PATH:$PATH"
	fi
	# Python3
	if [[ -e "$HOMEBREW_PREFIX/opt/python3/bin" ]]; then
		PATH="$HOMEBREW_PREFIX/opt/python3/bin:$PATH"
	fi
	# Java
	if [[ -d "$HOMEBREW_PREFIX/opt/openjdk/bin" ]]; then
		JDK_HOME=$HOMEBREW_PREFIX/opt/openjdk
		PATH="$JDK_HOME/bin:$PATH"
	fi
	# FZF
	if [[ -f ~/.fzf.zsh ]]; then
		FZF_HOME="$HOMEBREW_PREFIX/opt/fzf"
		source ~/.fzf.zsh
		source <(fzf --zsh)
	elif [[ -d "$HOMEBREW_PREFIX/opt/fzf/bin" ]]; then
		"$HOMEBREW_PREFIX/opt/fzf/install"
	fi
	#lsd
	if [[ -d "$HOMEBREW_PREFIX/opt/lsd/bin" ]]; then
		alias ls="lsd --group-directories-first"
		alias la="lsd -la --group-directories-first"
		alias lt="lsd --tree"
	fi
fi

# XDG Configs
export TMUX_CONF_DIR="$HOME/.config/tmux"
export LAZYGIT_CONFIG_DIR="$HOME/.config/lazygit"

# Aliases & functions
[[ -f $HOME/.vim/aliases.zsh ]] && source $HOME/.vim/aliases.zsh
[[ -f $HOME/.vim/functions.zsh ]] && source $HOME/.vim/functions.zsh

# Extra Alias
[[ -f $HOME/.extraAlias.zsh ]] && source $HOME/.extraAlias.zsh

# COMPLETIONS
[[ -f $HOME/.vim/completions.zsh ]] && source $HOME/.vim/completions.zsh

# Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
POWERLINE_DISABLE_RPROMPT="true"

# -------- ZSH VIM Mode
bindkey -v

bindkey -M viins '^P' up-line-or-history
bindkey -M viins '^N' down-line-or-history
bindkey -M viins '^E' end-of-line
if [ -f "$HOME/.afm-bin-path-manager.zsh" ]; then source "$HOME/.afm-bin-path-manager.zsh"; fi
