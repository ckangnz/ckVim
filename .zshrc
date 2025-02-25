autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit -C

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
export HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-$(brew --prefix)}
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=0
export HOMEBREW_NO_ENV_HINTS=1

# FNM
if [[ -e "$HOMEBREW_PREFIX/bin/fnm" ]]; then
  PATH="$FNM_MULTISHELL_PATH:$PATH"
fi
# Java
if [[ -d "$HOMEBREW_PREFIX/opt/openjdk/bin" ]]; then
  local JDK_HOME=$HOMEBREW_PREFIX/opt/openjdk
  PATH="$HOMEBREW_PREFIX/opt/openjdk/bin:$PATH"
fi
# FZF
if [[ -f ~/.fzf.zsh ]]; then
  FZF_HOME="$HOMEBREW_PREFIX/opt/fzf"
  source ~/.fzf.zsh
  [[ -f "$FZF_HOME/shell/completion.zsh" ]] && source "$FZF_HOME/shell/completion.zsh"
  [[ -f "$FZF_HOME/shell/key-bindings.zsh" ]] && source "$FZF_HOME/shell/key-bindings.zsh"
elif [[ -d "$HOMEBREW_PREFIX/opt/fzf/bin" ]]; then
  "$HOMEBREW_PREFIX/opt/fzf/install"
fi
# Docker
if [[ -d "$HOME/.docker/completions" ]]; then
  fpath+=("$HOME/.docker/completions")
  compinit
fi
# AwsCli
if [[ -f "$HOMEBREW_PREFIX/bin/aws_completer" ]];then
  complete -C "$HOMEBREW_PREFIX/bin/aws_completer" aws
fi
# Terraform
if [[ -f "$HOMEBREW_PREFIX/bin/terraform" ]];then
  complete -o nospace -C "$HOMEBREW_PREFIX/bin/terraform" terraform
fi
# Kubectl
if [[ -f "$HOMEBREW_PREFIX/bin/kubectl" ]];then
  alias k=kubectl
  source <(kubectl completion zsh)
fi
#lsd
if [[ -d "$HOMEBREW_PREFIX/opt/lsd/bin" ]]; then
  alias ls="lsd --group-directories-first"
  alias la="lsd -la --group-directories-first"
  alias lt="lsd --tree"
fi

#alias
alias neo="neovide --fork"

alias bud="brew update"
alias bu="brew upgrade"
alias buc="brew upgrade --cask"

alias p10="p10k configure"

alias gas="gh auth switch"
alias gcan='git commit --amend --no-edit'

alias zl="zap list"
alias zu="zap update"
alias zc="zap clean"

alias tr="tmux source ~/.config/tmux/tmux.conf"
alias ta="tmux attach"

alias dcup="docker compose up"
alias dcdn="docker compose down"
alias dczsh="docker compose run --rm web zsh"
alias dcbash="docker compose run --rm web bash"

function dcupp() {
  docker compose $(printf " --profile %s" "$@") up
}
function dcdnp() {
  docker compose $(printf " --profile %s" "$@") down
}

function speedTest() {
  for ((i = 1; i <= $1; i++)); do
    /usr/bin/time zsh -lic exit
  done
}

# Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
POWERLINE_DISABLE_RPROMPT="true"

# --------Custom Methods--------
[[ -f ~/.extraAlias.zsh ]] && source ~/.extraAlias.zsh

# -------- ZSH VIM Mode
bindkey -v

bindkey -M viins '^P' up-line-or-history
bindkey -M viins '^N' down-line-or-history
bindkey -M viins '^E' end-of-line
