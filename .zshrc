# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export TERM="xterm-256color"

source $HOME/.vim/plugins.zsh
zplug load

export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

ZSH_DISABLE_COMPFIX=true

# powerlevel10k
POWERLINE_DISABLE_RPROMPT="true"
COMPLETION_WAITING_DOTS="true"

# zsh-users/zsh-syntax
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

# lukechilds/zsh-nvm
export NVM_COMPLETION=true
export NVM_LAZY_LOAD=true

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
#alias dcup="docker-compose up"
#alias dczsh="docker-compose run --rm web zsh"
#alias dcbash="docker-compose run --rm web bash"
#alias dcbuild="docker-compose build"
#alias divioshell="PATH=/virtualenv/bin:/pipsi/bin:$HOME/.local/bin:/usr/local/bin:$PATH;unset DOCKER_HOST;docker run -it --rm  -v '/var/run/docker.sock:/var/run/docker.sock:rw' -v '/Users/chrisk/.netrc:/home/divio/.netrc:rw' -v '/Users/chrisk/.aldryn:/home/divio/.aldryn:rw' -v '/Users/chrisk/code/divio:/Users/chrisk/code/divio:rw' divio/divio-app-toolbox:chrisk-0.12.0-webadmin_movio.co 'cd /Users/chrisk/code/divio/movio;divio doctor;bash'"

#Postgresql
#brew install postgresql
#ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
alias pgstart="launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
alias pgstop="launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
alias dyna="docker run --rm -it -p 8000:8000 amazon/dynamodb-local"

alias jserv="json-server --watch db.json --port 3004"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
