#zmodload zsh/zprof
autoload -Uz +X bashcompinit && bashcompinit
autoload -Uz +X compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

export TERM="xterm-256color"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

# powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
POWERLINE_DISABLE_RPROMPT="true"
COMPLETION_WAITING_DOTS="true"

# oh-my-zsh
export ZSH=$HOME/.oh-my-zsh
ZSH_DISABLE_COMPFIX=true
#source $ZSH/oh-my-zsh.sh

# Set PATH
export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
export PATH="$PATH:/home/linuxbrew/.linuxbrew/sbin"
export PATH="$PATH:/usr/local/bin:/usr/bin:/bin"
export PATH="$PATH:/usr/sbin:/sbin"
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$PATH:$HOME/.dotnet/tools"
export PATH="$PATH:$HOME/.pub-cache/bin"

NPM_PACKAGES="${HOME}/.npm-packages"
NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
unset MANPATH
MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
export PATH="$PATH:$NPM_PACKAGES/bin"
export HOMEBREW_PREFIX=$(brew --prefix)

#------Source plugins--------
source $HOME/.vim/plugins.zsh
#------Source plugins--------

# zsh-users/zsh-syntax
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

# softmoth/zsh-vim-mode
bindkey -v
MODE_CURSOR_VICMD="green block"
MODE_CURSOR_VIINS="#20d08a blinking bar"
MODE_CURSOR_SEARCH="#ff00ff blinking underline"
MODE_INDICATOR_VIINS='%F{15}<%F{8}INSERT<%f'
MODE_INDICATOR_VICMD='%F{10}<%F{2}NORMAL<%f'
MODE_INDICATOR_REPLACE='%F{9}<%F{1}REPLACE<%f'
MODE_INDICATOR_SEARCH='%F{13}<%F{5}SEARCH<%f'
MODE_INDICATOR_VISUAL='%F{12}<%F{4}VISUAL<%f'
MODE_INDICATOR_VLINE='%F{12}<%F{4}V-LINE<%f'

# Kubectl
if [ -d "$HOMEBREW_PREFIX/opt/kubectl/bin" ];then
  source <(kubectl completion zsh)
  complete -F __start_kubectl k
fi
# Helm
if [ -d "$HOMEBREW_PREFIX/opt/helm/bin" ];then
  source <(helm completion zsh)
fi
# FNM
if [ -d "$HOMEBREW_PREFIX/opt/fnm/bin" ]; then
  export PATH="$PATH:$FNM_MULTISHELL_PATH"
  eval "$(fnm env --use-on-cd)"
fi
# Ruby
if [ -d "$HOMEBREW_PREFIX/opt/ruby/bin" ]; then
  export PATH=$HOMEBREW_PREFIX/opt/ruby/bin:$PATH
  export PATH=`gem environment gemdir`/bin:$PATH
fi
#Apple silicon version Ruby
#if [ -d "/opt/homebrew/opt/ruby/bin" ]; then
  #export PATH=/opt/homebrew/opt/ruby/bin:$PATH
  #export PATH=`gem environment gemdir`/bin:$PATH
#fi

#alias
alias vim="vim"
alias neo="neovide --multigrid"
alias bu="brew upgrade && brew update --cask"
alias zi="zplug install"
alias zu="zplug update"
alias dczsh="docker-compose run --rm web zsh"
alias dcbash="docker-compose run --rm web bash"
function dcupp(){
  profiles=''
  for profile in "$@"
  do
    profiles="${profiles} --profile ${profile}"
  done
  eval "docker compose${profiles} up"
}
function dcdnp(){
  profiles=''
  for profile in "$@"
  do
    profiles="${profiles} --profile ${profile}"
  done
  eval "docker compose${profiles} down"
}

#Postgresql
#brew install postgresql
#ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
alias pgstart="launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
alias pgstop="launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
alias dyna="docker run --rm -it -p 8000:8000 amazon/dynamodb-local"
alias jserv="json-server --watch db.json --port 3004"

#FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#
# --------Custom Methods--------
#

[ -f ~/.extraAlias.zsh ] && source ~/.extraAlias.zsh


bindkey -e
#zprof
