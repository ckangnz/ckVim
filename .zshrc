# Set PATH
PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
PATH="$PATH:/home/linuxbrew/.linuxbrew/sbin"
PATH="$PATH:/usr/local/bin:/usr/bin:/bin"
PATH="$PATH:/usr/sbin:/sbin"
PATH="$PATH:$HOME/.rvm/bin"
PATH="$PATH:$HOME/.dotnet/tools"
PATH="$PATH:$HOME/.pub-cache/bin"

#------Source Zap--------
if [[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ]]; then
  source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
else
  echo "Install ZAP!"
  echo "zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1"
  echo "Then symlink: rm .zshrc && ln -s $HOME/.vim/.zshrc $HOME/.zshrc"
fi
source $HOME/.vim/plugins.zsh

#------Source Brew plugins--------
export HOMEBREW_PREFIX=$(brew --prefix)
# FNM
if [[ -e "$HOMEBREW_PREFIX/bin/fnm" ]]; then
  PATH="$FNM_MULTISHELL_PATH":$PATH
fi
# FZF
if [[ -f ~/.fzf.zsh ]]; then
  source ~/.fzf.zsh
elif [[-d "$HOMEBREW_PREFIX/opt/fzf/bin"]]; then
  $HOMEBREW_PREFIX/opt/fzf/install
fi
#Dotnet
if [[ -e "$HOMEBREW_PREFIX/bin/dotnet" ]]; then
  _dotnet_completion() {
    local -a completions=("${(@f)$(dotnet complete "${words}")}")
    reply=( "${(ps:\n:)completions}" )
    _files
  }
  compdef _dotnet_completion dotnet
fi


#alias
alias vim="vim"
alias neo="neovide"

alias bu="brew upgrade"
alias buc="brew update --cask"

alias p10="p10k configure"

alias zl="zap list"
alias zu="zap update"
alias zc="zap clean"

alias dcup="docker-compose up"
alias dcdn="docker-compose down"
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
function speedTest(){
  for i in $(seq $@); do
    /usr/bin/time zsh -lic exit
  done
}

# Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
POWERLINE_DISABLE_RPROMPT="true"

# --------Custom Methods--------
[[ -f ~/.extraAlias.zsh ]] && source ~/.extraAlias.zsh

bindkey -e

# Load and initialise completion system
autoload -Uz compinit
compinit
