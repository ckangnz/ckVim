# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
source $HOME/.vim/plugins.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
compinit

export TERM="xterm-256color"

# powerlevel10k
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
POWERLINE_DISABLE_RPROMPT="true"
COMPLETION_WAITING_DOTS="true"

# zsh-users/zsh-syntax
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

# lukechilds/zsh-nvm
export NVM_COMPLETION=true
export NVM_LAZY_LOAD=true

# autoload nvmrc
autoload -U add-zsh-hook
load-nvmrc() {
  [[ -a .nvmrc ]] || return
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

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

# oh-my-zsh
export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

ZSH_DISABLE_COMPFIX=true


# Kubectl and helm
if [ kubectl ];then
    source <(kubectl completion zsh)
    complete -F __start_kubectl k
    autoload -Uz compinit
    compinit
fi
if [ helm ];then
    source <(helm completion zsh)
fi

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

NPM_PACKAGES="${HOME}/.npm-packages"
NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"

PATH="$NPM_PACKAGES/bin:$PATH"
unset MANPATH
MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
export PATH="$PATH:$HOME/.rvm/bin"

#alias
alias zshconfig="vim ~/.zshrc"
[ -f ~/.extraAlias.zsh ] && source ~/.extraAlias.zsh
alias dczsh="docker-compose run --rm web zsh"
alias dcbash="docker-compose run --rm web bash"

#Postgresql
#brew install postgresql
#ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
alias pgstart="launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
alias pgstop="launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
alias dyna="docker run --rm -it -p 8000:8000 amazon/dynamodb-local"

alias jserv="json-server --watch db.json --port 3004"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
