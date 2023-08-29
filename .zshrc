#zmodload zsh/zprof
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'


export TERM="xterm-256color"

# Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
POWERLINE_DISABLE_RPROMPT="true"

# oh-my-zsh
zstyle ':omz:*' aliases no
zstyle ':omz:update' mode auto
zstyle ':omz:update' verbose silent # only errors
export ZSH=$HOME/.oh-my-zsh
ZSH_DISABLE_COMPFIX=true
source $ZSH/oh-my-zsh.sh

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
#------Source zplugins--------
if [[ -d "$HOMEBREW_PREFIX/opt/zplug" ]]; then
  source $HOME/.vim/plugins.zsh
else
  echo "ZPLUG IS NOT INSTALLED!"
fi

#------Source Brew plugins--------
# Kubectl
if [ -d "$HOMEBREW_PREFIX/bin/kubectl" ];then
  source <(kubectl completion zsh)
  complete -F __start_kubectl k
fi
# Helm
if [ -d "$HOMEBREW_PREFIX/bin/helm" ];then
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

#alias
alias vim="vim"
alias neo="neovide --multigrid"
alias bu="brew upgrade"
alias buc="brew update --cask"
alias p10="p10k configure"
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

#FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# --------Custom Methods--------
[ -f ~/.extraAlias.zsh ] && source ~/.extraAlias.zsh

bindkey -e
#zprof
