# Docker (before compinit, since it modifies fpath)
if command -v docker &>/dev/null; then
  docker_comp_dir="${HOME}/.docker/completions"
  docker_comp_file="${docker_comp_dir}/_docker"
  if [[ ! -f "$docker_comp_file" ]]; then
    mkdir -p "$docker_comp_dir"
    docker completion zsh > "$docker_comp_file"
  fi
  fpath+=("$docker_comp_dir")
fi

# Github CLI
if [[ -x "${HOMEBREW_PREFIX}/bin/gh" ]]; then
  eval "$(gh completion -s zsh)"
  _gh_cache_dir="${HOME}/.config/gh/copilot"
  _gh_alias_file="${_gh_cache_dir}/copilot-alias.zsh"
  mkdir -p "$_gh_cache_dir"
  if [[ ! -f "$_gh_alias_file" ]]; then
    if gh extension list 2>/dev/null | grep -q 'github/gh-copilot'; then
      gh copilot alias -- zsh > "$_gh_alias_file"
    fi
  fi
  [[ -f "$_gh_alias_file" ]] && source "$_gh_alias_file"
fi

# Kubectl
if [[ -f "$HOMEBREW_PREFIX/bin/kubectl" ]]; then
  alias k=kubectl
  source <(kubectl completion zsh)
fi

# AWS CLI
if [[ -f "$HOMEBREW_PREFIX/bin/aws_completer" ]]; then
  complete -o nospace -C "$HOMEBREW_PREFIX/bin/aws_completer" aws
fi

# Terraform
if [[ -f "$HOMEBREW_PREFIX/bin/terraform" ]]; then
  complete -o nospace -C "$HOMEBREW_PREFIX/bin/terraform" terraform
fi

# Dotnet
_dotnet_zsh_complete() {
  local completions=("$(dotnet complete "$words")")
  if [ -z "$completions" ]; then
    _arguments '*::arguments: _normal'
    return
  fi
  compadd ${(ps:\n:)completions}
}
compdef _dotnet_zsh_complete dotnet

# Makefile
_make_targets() {
  [[ -f Makefile ]] || return
  compadd $(awk -F: '/^[a-zA-Z0-9_-]+:/ {print $1}' Makefile)
}
compdef _make_targets make
