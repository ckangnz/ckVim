export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "zsh-users/zsh-autosuggestions", defer:2
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "lukechilds/zsh-nvm"

zplug "romkatv/powerlevel10k", as:theme, depth:1

zplug "plugins/brew", from:oh-my-zsh
zplug "plugins/fzf", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/kubectl", from:oh-my-zsh
zplug "plugins/aws", from:oh-my-zsh
zplug "plugins/django", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh
zplug "plugins/dotnet", from:oh-my-zsh
zplug "plugins/pyenv", from:oh-my-zsh
zplug "plugins/python", from:oh-my-zsh
zplug "plugins/nvm", from:oh-my-zsh
