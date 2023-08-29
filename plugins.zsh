export ZPLUG_HOME=$(brew --prefix)/opt/zplug
source $ZPLUG_HOME/init.zsh

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "zsh-users/zsh-autosuggestions"
zplug "zdharma-continuum/fast-syntax-highlighting", defer:2

zplug "plugins/git", from:oh-my-zsh, defer:3
zplug "plugins/kubectl", from:oh-my-zsh, defer:3
zplug "plugins/docker", from:oh-my-zsh, defer:3
zplug "plugins/docker-compose", from:oh-my-zsh, defer:3

zplug "romkatv/powerlevel10k", as:theme, depth:0

# Then, source plugins and add commands to $PATH
zplug load
