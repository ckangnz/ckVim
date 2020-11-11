export ZSH=$HOME/.oh-my-zsh
export TERM="xterm-256color"

ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_MODE="nerdfont-complete"
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_PROMPT_ON_NEWLINE=false
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(virtualenv user dir vcs background_jobs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
POWERLEVEL9K_ROOT_ICON="\uF09C"
POWERLEVEL9K_SUDO_ICON=$'\uF09C'  #
POWERLEVEL9K_PYTHON_ICON='🐍'
POWERLEVEL9K_TIME_FORMAT="%D{%H:%M}"
POWERLEVEL9K_VCS_GIT_ICON=''
POWERLEVEL9K_VCS_BRANCH_ICON=$'\uF126 '
ZSH_DISABLE_COMPFIX=true
COMPLETION_WAITING_DOTS="true"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

NPM_PACKAGES="${HOME}/.npm-packages"
NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"

PATH="$NPM_PACKAGES/bin:$PATH"
unset MANPATH
MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
export PATH="$PATH:$HOME/.rvm/bin"

#alias
alias zshconfig="vim ~/.zshrc"
alias dcup="docker-compose up"
alias dczsh="docker-compose run --rm web zsh"
alias dcbash="docker-compose run --rm web bash"
alias dcbuild="docker-compose build"
alias divioshell="PATH=/virtualenv/bin:/pipsi/bin:$HOME/.local/bin:/usr/local/bin:$PATH;unset DOCKER_HOST;docker run -it --rm  -v '/var/run/docker.sock:/var/run/docker.sock:rw' -v '/Users/chrisk/.netrc:/home/divio/.netrc:rw' -v '/Users/chrisk/.aldryn:/home/divio/.aldryn:rw' -v '/Users/chrisk/code/divio:/Users/chrisk/code/divio:rw' divio/divio-app-toolbox:chrisk-0.12.0-webadmin_movio.co 'cd /Users/chrisk/code/divio/movio;divio doctor;bash'"

#Postgresql
#brew install postgresql
#ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
alias pgstart="launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
alias pgstop="launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
alias dyna="docker run --rm -it -p 8000:8000 amazon/dynamodb-local"

alias jserv="json-server --watch db.json --port 3004"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#VirtualEnvWrapper and Pyenv
#eval "$(pyenv init -)"
#export PYENV_VIRTUALENVWRAPPER_PREFER_PYENV="true"
#export WORKON_HOME=$HOME/.virtualenvs
#pyenv virtualenvwrapper_lazy

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
