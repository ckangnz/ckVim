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

wt() {
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
    local workspace_id="$2"
    local result_file
    local started_at
    local removal_status
    local process_id
    local spinner_index=1
    local -a spinner=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")

    if [[ -z "$workspace_id" ]]; then
      print -u2 -- "Usage: wt rm <workspace-id> [--force]"
      return 2
    fi

    shift 2
    result_file=$(mktemp "${TMPDIR:-/tmp}/wt-rm.XXXXXX") || return 1
    started_at=$SECONDS
    herdr worktree remove --workspace "$workspace_id" "$@" >"$result_file" 2>&1 &
    process_id=$!

    while kill -0 "$process_id" 2>/dev/null; do
      printf '\r\033[2K%s Removing %s… %ds' "$spinner[$spinner_index]" "$workspace_id" "$((SECONDS - started_at))"
      spinner_index=$((spinner_index % ${#spinner[@]} + 1))
      sleep 1
    done

    wait "$process_id"
    removal_status=$?
    printf '\r\033[2K'

    if (( removal_status == 0 )); then
      print -- "Removed $workspace_id in $((SECONDS - started_at))s."
    elif [[ -s "$result_file" ]]; then
      cat "$result_file" >&2
    else
      print -u2 -- "Failed to remove $workspace_id."
    fi

    rm -f "$result_file"
    return "$removal_status"
  fi

  print -u2 -- "Usage: wt list | wt rm <workspace-id> [--force]"
  return 2
}
