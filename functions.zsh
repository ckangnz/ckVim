_wt_base_branch() {
  local main=$(git_main_branch)
  local toplevel=$(git rev-parse --show-toplevel 2>/dev/null)
  local worktrees=$(git worktree list --porcelain 2>/dev/null | awk '/^worktree / {print $2}')
  local main_worktree=$(echo "$worktrees" | head -1)
  if [[ "$toplevel" != "$main_worktree" ]]; then
    local num=$(basename "$toplevel" | grep -oE '[0-9]+$')
    if [[ -n "$num" ]]; then
      local padded=$(printf "%03d" "$num")
      echo "agent/${padded}"
      return
    fi
  fi
  echo "$main"
}

gfom() {
  local main=$(git_main_branch)
  echo "🔄 Fetching origin/$main..."
  gfo "$main" --prune --prune-tags --no-tags && echo "✅ Fetched origin/$main"
}

gsm() {
  local main=$(git_main_branch)
  echo "⏩ Fast-forwarding $main → origin/$main..."
  local ref=$(git rev-parse "origin/$main" 2>/dev/null) || { echo "❌ origin/$main not found" >&2; return 1 }
  git update-ref "refs/heads/$main" "$ref" && echo "✅ $main up to date"
}

gswt() {
  local main=$(git_main_branch)
  local base=$(_wt_base_branch)
  if [[ "$base" == "$main" ]]; then
    echo "❌ Not in a worktree — use gsm instead." >&2
    return 1
  fi
  echo "⏩ Fast-forwarding $base → origin/$main..."
  local ref=$(git rev-parse "origin/$main" 2>/dev/null) || { echo "❌ origin/$main not found" >&2; return 1 }
  git update-ref "refs/heads/$base" "$ref" && echo "✅ $base up to date"
}

gdf() {
	# example: gdf "test\.tsx$"
	local pattern="${1}"
	if [[ -z "$pattern" ]]; then
		gd --name-only --relative "$(git_main_branch)...HEAD"
	else
		gd --name-only --relative "$(git_main_branch)...HEAD" | grep -E "$pattern"
	fi
}

function dcupp() {
	docker compose $(printf " --profile %s" "$@") up
}
function dcdnp() {
	docker compose $(printf " --profile %s" "$@") down
}

function speedTest() {
	local count=${1:-1} # Default to 1 if no argument is given
	for ((i = 1; i <= count; i++)); do
		/usr/bin/time zsh -lic exit
	done
}

function fixCompaudits() {
	compaudit | while read file; do
		echo "🔐 Fixing $file..."
		sudo chmod go-w "$file"
	done
	echo "✅ Compaudit issues fixed."
}

function killport() {
	local -a pids
	pids=("${(@f)$(lsof -ti :"$1")}")
	(( ${#pids[@]} )) && kill -9 "${pids[@]}"
}
