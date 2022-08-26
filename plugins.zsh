if [[ -d "/usr/local/opt/zplug" ]]; then
    export ZPLUG_HOME=/usr/local/opt/zplug
elif [[ -d "/usr/share/zplug" ]]; then
    export ZPLUG_HOME=/usr/share/zplug
else
    echo "ZPLUG IS NOT INSTALLED!"
fi

source $ZPLUG_HOME/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "zsh-users/zsh-autosuggestions"

zplug "plugins/git", from:oh-my-zsh
zplug "plugins/kubectl", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh
zplug "plugins/fnm", from:oh-my-zsh

zplug "zdharma-continuum/fast-syntax-highlighting", defer:2


zplug "romkatv/powerlevel10k", as:theme

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load
