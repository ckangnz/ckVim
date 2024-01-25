#zmodload zsh/zprof
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

export TERM="xterm-256color"

# Set PATH
PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
PATH="$PATH:/home/linuxbrew/.linuxbrew/sbin"
PATH="$PATH:/usr/local/bin:/usr/bin:/bin"
PATH="$PATH:/usr/sbin:/sbin"
PATH="$PATH:$HOME/.rvm/bin"
PATH="$PATH:$HOME/.dotnet/tools"
PATH="$PATH:$HOME/.pub-cache/bin"

NPM_PACKAGES="${HOME}/.npm-packages"
NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
unset MANPATH
MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
PATH="$PATH:$NPM_PACKAGES/bin"

export HOMEBREW_PREFIX=$(brew --prefix)
#------Source zplugins--------

if [[ -d "$HOMEBREW_PREFIX/opt/zplug" ]]; then
  ZPLUG_LOADFILE=$HOME/.vim/plugins.zsh
  export ZPLUG_HOME=$HOMEBREW_PREFIX/opt/zplug
  source $ZPLUG_HOME/init.zsh
else
  echo "ZPLUG IS NOT INSTALLED!"
fi

#------Source Brew plugins--------
# Kubectl
if [[ -e "$HOMEBREW_PREFIX/bin/kubectl" ]];then
  source <(kubectl completion zsh)
  complete -F __start_kubectl k
fi
# Helm
if [[ -e "$HOMEBREW_PREFIX/bin/helm" ]];then
  source <(helm completion zsh)
fi
# FNM
if [[ -e "$HOMEBREW_PREFIX/bin/fnm" ]]; then
  PATH="$PATH:$FNM_MULTISHELL_PATH"
  eval "$(fnm env --use-on-cd)"
fi
# Python
if [[ -d "$HOMEBREW_PREFIX/opt/python3/bin" ]]; then
  PATH=$PATH:$HOMEBREW_PREFIX/opt/python3/bin
fi
# Java
if [[ -d "$HOMEBREW_PREFIX/opt/openjdk/bin" ]]; then
  PATH=$PATH:$HOMEBREW_PREFIX/opt/openjdk/bin
fi
# Ruby
if [[ -d "$HOMEBREW_PREFIX/opt/ruby/bin" ]]; then
  PATH=$PATH:$HOMEBREW_PREFIX/opt/ruby/bin
  PATH=$PATH:`gem environment gemdir`/bin
fi
# FZF
if [[ -f ~/.fzf.zsh ]]; then
  source ~/.fzf.zsh
elif [[-d "$HOMEBREW_PREFIX/opt/fzf/bin"]]; then
  $HOMEBREW_PREFIX/opt/fzf/install
fi

#alias
alias vim="vim"
alias neo="neovide"
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

### Fix slowness of pastes with zsh-syntax-highlighting.zsh
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic
}
pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
### Fix slowness of pastes

# Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
POWERLINE_DISABLE_RPROMPT="true"

# --------Custom Methods--------
[[ -f ~/.extraAlias.zsh ]] && source ~/.extraAlias.zsh

# Export PATH
export PATH

bindkey -e
#zprof
