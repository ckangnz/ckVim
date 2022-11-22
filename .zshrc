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

#------Source plugins--------
source $HOME/.vim/plugins.zsh
#------Source plugins--------

# oh-my-zsh
export ZSH=$HOME/.oh-my-zsh
ZSH_DISABLE_COMPFIX=true
#source $ZSH/oh-my-zsh.sh

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

# Kubectl and helm
if [ kubectl ];then
  source <(kubectl completion zsh)
  complete -F __start_kubectl k
fi
if [ helm ];then
  source <(helm completion zsh)
fi

# Set PATH
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

NPM_PACKAGES="${HOME}/.npm-packages"
NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
PATH="$NPM_PACKAGES/bin:$PATH"

unset MANPATH
MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

export PATH="$HOME/.rvm/bin:$PATH"
export PATH="$PATH:/Users/chris.kang/.dotnet/tools"

#alias
alias vim="mvim -v"
alias neo="neovide --multigrid"
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

eval "$(fnm env --use-on-cd)"

[ -f ~/.extraAlias.zsh ] && source ~/.extraAlias.zsh


bindkey -e
#zprof
