if (( $+commands[herdr] )); then
  source <(herdr completion zsh)
fi

_wt_removal_targets() {
  local worktrees
  local target_lines
  local -a targets

  if ! worktrees=$(herdr worktree list 2>/dev/null); then
    return
  fi

  target_lines=$(print -r -- "$worktrees" | jq -r '
      .result.worktrees[]
      | select((.open_workspace_id // "") != "" or (.branch // "-") != "-")
      | [
          (if (.open_workspace_id // "") != "" then "\(.open_workspace_id):workspace \(.path)" else empty end),
          (if (.branch // "-") != "-" then "\(.branch):branch \(.path)" else empty end),
          "\(.path):path"
        ]
      | .[]
    ') || return

  targets=(
    '.'\:'current worktree'
    "${(@f)target_lines}"
  )
  _describe -t worktrees 'worktree' targets
}

_wt() {
  local state
  typeset -A opt_args

  _arguments -C \
    '1:command:->command' \
    '2:target:->target' \
    '*::option:->option'

  case "$state" in
    command)
      _values 'wt command' current list rm
      ;;
    target)
      if [[ "${words[2]}" == "rm" ]]; then
        _wt_removal_targets
      fi
      ;;
    option)
      if [[ "${words[2]}" == "rm" ]]; then
        _arguments '-f[force removal]' '--force[force removal]'
      fi
      ;;
  esac
}
compdef _wt wt

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
