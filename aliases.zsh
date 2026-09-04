alias neo="neovide --fork"
alias icat="kitten icat"

alias bu="brew update"
alias bup="brew upgrade"
alias buc="brew upgrade --cask"

alias p10="p10k configure"

alias gas="gh auth switch"

alias gcnv='gc --no-verify'
alias gcnva='gc --no-verify --amend'
alias gcnvan='gc --no-verify --amend --no-edit'

alias grbom='grb origin/$(git_main_branch)'
alias gmom='gm origin/$(git_main_branch)'

alias zl="zap list"
alias zu="zap update all"
alias zc="zap clean"

alias dcup="docker compose up"
alias dcdn="docker compose down"
alias dczsh="docker compose run --rm web zsh"
alias dcbash="docker compose run --rm web bash"
alias lzg="lazygit"
alias lzd="lazydocker"

_wt_current_workspace_id() {
  local worktree_root
  local worktrees
  local workspace_id

  if ! worktree_root=$(git rev-parse --show-toplevel 2>/dev/null); then
    print -u2 -- "Not inside a Git worktree."
    return 1
  fi

  if ! worktrees=$(herdr worktree list); then
    return 1
  fi

  if ! workspace_id=$(print -r -- "$worktrees" | jq -er --arg path "$worktree_root" '
    .result.worktrees[] | select(.path == $path) | .open_workspace_id
  '); then
    print -u2 -- "The current Git worktree is not registered with Herdr."
    return 1
  fi

  print -r -- "$workspace_id"
}

_wt_worktree_for_target() {
  local target="$1"
  local worktrees
  local match_count

  if ! worktrees=$(herdr worktree list); then
    return 1
  fi

  match_count=$(print -r -- "$worktrees" | jq -r --arg target "$target" '
    [.result.worktrees[] | select(
      .open_workspace_id == $target or .branch == $target or .path == $target
    )] | length
  ') || return 1

  if (( match_count == 0 )); then
    print -u2 -- "No worktree matches '$target'."
    return 1
  fi

  if (( match_count > 1 )); then
    print -u2 -- "More than one worktree matches '$target'; use its full path."
    return 1
  fi

  print -r -- "$worktrees" | jq -c --arg target "$target" '
    .result.worktrees[] | select(
      .open_workspace_id == $target or .branch == $target or .path == $target
    )
  '
}

wt() {
  if [[ "$1" == "current" ]]; then
    _wt_current_workspace_id
    return
  fi

  if [[ "$1" == "list" ]]; then
    local worktrees

    if ! worktrees=$(herdr worktree list); then
      return 1
    fi

    {
      print -r -- $'WORKSPACE\tBRANCH\tPATH'
      print -r -- "$worktrees" |
        jq -r '.result.worktrees[] | [.open_workspace_id // "-", .branch // "-", .path] | @tsv'
    } |
      column -t -s $'\t'
    return
  fi

  if [[ "$1" == "rm" ]]; then
    local target="$2"
    local worktree
    local workspace_id
    local worktree_path
    local git_common_dir
    local branch_name
    local original_directory
    local result_file
    local started_at
    local removal_status
    local worktree_removal_status
    local process_id
    local spinner_index=1
    local force_requested=false
    local branch_delete_option=-d
    local confirmation
    local -a spinner=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    local -a remove_command
    local -a remove_options

    if [[ -z "$target" ]]; then
      print -u2 -- "Usage: wt rm <workspace-id|branch|path|.> [-f|--force]"
      return 2
    fi

    shift 2
    for option in "$@"; do
      if [[ "$option" == "-f" || "$option" == "--force" ]]; then
        force_requested=true
        branch_delete_option=-D
        remove_options+=(--force)
      else
        remove_options+=("$option")
      fi
    done

    if [[ "$force_requested" == true ]]; then
      if [[ -r /dev/tty && -w /dev/tty ]]; then
        printf 'Remove %s with force? [y/N] ' "$target" > /dev/tty
        read -r confirmation < /dev/tty
      else
        printf 'Remove %s with force? [y/N] ' "$target"
        read -r confirmation
      fi

      if [[ "$confirmation" != "y" ]]; then
        print -- "Cancelled."
        return 0
      fi
    fi

    if [[ "$target" == "." ]]; then
      workspace_id=$(_wt_current_workspace_id) || return 1
      worktree_path=$(git rev-parse --show-toplevel) || return 1
      git_common_dir=$(git rev-parse --path-format=absolute --git-common-dir) || return 1
      branch_name=$(git branch --show-current)
      original_directory="$PWD"

      if ! cd "$worktree_path/.."; then
        print -u2 -- "Could not leave the current worktree before removing it."
        return 1
      fi
      remove_command=(herdr worktree remove --workspace "$workspace_id")
    else
      worktree=$(_wt_worktree_for_target "$target") || return 1
      workspace_id=$(print -r -- "$worktree" | jq -r '.open_workspace_id // empty')
      worktree_path=$(print -r -- "$worktree" | jq -r '.path')

      if [[ $(git -C "$worktree_path" rev-parse --is-bare-repository 2>/dev/null) == "true" ]]; then
        print -u2 -- "Refusing to remove the bare repository at '$worktree_path'."
        return 1
      fi

      if ! git_common_dir=$(git -C "$worktree_path" rev-parse --path-format=absolute --git-common-dir); then
        print -u2 -- "Could not locate the Git repository for '$worktree_path'."
        return 1
      fi

      branch_name=$(git -C "$worktree_path" branch --show-current)

      if [[ -n "$workspace_id" ]]; then
        remove_command=(herdr worktree remove --workspace "$workspace_id")
      else
        remove_command=(git -C "$git_common_dir" worktree remove "$worktree_path")
      fi
    fi

    result_file=$(mktemp "${TMPDIR:-/tmp}/wt-rm.XXXXXX") || return 1
    started_at=$SECONDS
    "${remove_command[@]}" "${remove_options[@]}" >"$result_file" 2>&1 &
    process_id=$!

    while kill -0 "$process_id" 2>/dev/null; do
      printf '\r\033[2K%s Removing %s… %ds' "$spinner[$spinner_index]" "$workspace_id" "$((SECONDS - started_at))"
      spinner_index=$((spinner_index % ${#spinner[@]} + 1))
      sleep 1
    done

    wait "$process_id"
    removal_status=$?
    worktree_removal_status=$removal_status
    printf '\r\033[2K'

    if (( removal_status == 0 )); then
      if [[ -n "$branch_name" ]]; then
        if git -C "$git_common_dir" branch "$branch_delete_option" -- "$branch_name" >"$result_file" 2>&1; then
          print -- "Removed $target and deleted local branch '$branch_name' in $((SECONDS - started_at))s."
        else
          print -u2 -- "Removed $target, but could not delete local branch '$branch_name'."
          cat "$result_file" >&2
          removal_status=1
        fi
      else
        print -- "Removed $target in $((SECONDS - started_at))s."
      fi
    elif [[ -s "$result_file" ]]; then
      cat "$result_file" >&2
    else
      print -u2 -- "Failed to remove $workspace_id."
    fi

    rm -f "$result_file"

    if (( worktree_removal_status != 0 )) && [[ -n "$original_directory" ]]; then
      cd "$original_directory" || return 1
    fi

    return "$removal_status"
  fi

  print -u2 -- "Usage: wt current | wt list | wt rm <workspace-id|branch|path|.> [-f|--force]"
  return 2
}
