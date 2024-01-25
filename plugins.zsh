zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "zsh-users/zsh-autosuggestions", defer:2
zplug "zdharma-continuum/fast-syntax-highlighting", defer:2
zplug "memark/zsh-dotnet-completion", defer:2

zplug "lib/completion", from:oh-my-zsh, defer:3
zplug "plugins/git", from:oh-my-zsh, defer:3
zplug "plugins/kubectl", from:oh-my-zsh, defer:3
zplug "plugins/docker", from:oh-my-zsh, defer:3
zplug "plugins/docker-compose", from:oh-my-zsh, defer:3

zplug "romkatv/powerlevel10k", as:theme, depth:1

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load
