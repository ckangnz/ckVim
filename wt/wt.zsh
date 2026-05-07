#!/usr/bin/env zsh
# ~/.vim/wt/wt.zsh
# wt — worktree workspace manager
#
# Manages git worktrees + tmux windows for parallel agent workflows.
# Generic: works with any git repo. No Atlassian/AFM specific logic.
#
# Config: ~/.wt/repos  (auto-created on first use)
# Source this file from ~/.zshrc:
#   source "$HOME/.vim/wt/wt.zsh"

# ── config ────────────────────────────────────────────────────────────────────

: ${WT_CONFIG_DIR:="${HOME}/.wt"}
: ${WT_REPOS_FILE:="${WT_CONFIG_DIR}/repos"}

# ── helpers ───────────────────────────────────────────────────────────────────

_wt_ensure_config() {
    [[ -d "$WT_CONFIG_DIR" ]] || mkdir -p "$WT_CONFIG_DIR"
    if [[ ! -f "$WT_REPOS_FILE" ]]; then
        cat > "$WT_REPOS_FILE" << 'EOF'
# ~/.wt/repos — wt repo registry
# Format: <name> <path> <kind>
#   kind = worktree  (path is <root>/agents/, expects sibling <root>/master/)
#   kind = single    (path is the actual repo dir; no worktrees)
#   (kind defaults to "worktree" if omitted, for backwards compatibility)
#
# Examples:
#   multi-worktree-project  /Users/me/code/proj/agents      worktree
#   non-worktree-project    /Users/me/code/small-app        single
#
# Managed by: wt repo register / wt repo unregister
EOF
    fi
}

_wt_repos() {
    _wt_ensure_config
    /usr/bin/awk '!/^[[:space:]]*#/ && !/^[[:space:]]*$/ { kind = ($3 == "" ? "worktree" : $3); print $1, $2, kind }' "$WT_REPOS_FILE"
}

_wt_agents_dir() {
    local name="$1"
    _wt_repos | /usr/bin/awk -v n="$name" '$1 == n {print $2}'
}

_wt_repo_kind() {
    local name="$1"
    _wt_repos | /usr/bin/awk -v n="$name" '$1 == n {print $3}'
}

_wt_repo_path() {
    local name="$1"
    _wt_repos | /usr/bin/awk -v n="$name" '$1 == n {print $2}'
}

_wt_repo_root() {
    local name="$1"
    local kind p
    kind=$(_wt_repo_kind "$name")
    p=$(_wt_repo_path "$name")
    if [[ "$kind" == "single" ]]; then
        echo "$p"
    else
        echo "${p:h}"
    fi
}

_wt_master_dir() {
    local agents_dir="$1"
    echo "${agents_dir:h}/master"
}

# Zero-pad agent number: 3 → 003
_wt_pad() {
    printf "%03d" "$((10#$1))"
}

# Find next available agent number — fills gaps first
_wt_next_agent_num() {
    local agents_dir="$1"
    local n=1
    while true; do
        local candidate="${agents_dir}/agent-$(_wt_pad $n)"
        [[ ! -d "$candidate" ]] && { _wt_pad $n; return }
        (( n++ ))
    done
}

# Get primary branch name (main or master)
_wt_primary_branch() {
    local dir="$1"
    if git -C "$dir" rev-parse --verify main &>/dev/null; then
        echo "main"
    else
        echo "master"
    fi
}

# List tmux windows and their current paths
_wt_tmux_windows() {
    tmux list-windows -a \
        -F '#{session_name}:#{window_index} #{window_name} #{pane_current_path}' \
        2>/dev/null
}

# Find which tmux window is using a given path (exact match on any pane)
_wt_window_for_path() {
    local p="$1"
    tmux list-panes -a \
        -F '#{session_name}:#{window_index}|#{pane_current_path}' \
        2>/dev/null | /usr/bin/awk -F'|' -v p="$p" '$2 == p {print $1; exit}'
}

# Create the triptych tmux layout in current window:
#   ┌──────────────┬──────────────┐  70% height
#   │  pane 1      │  pane 2      │
#   ├──────────────┴──────────────┤  30% height
#   │  pane 3 (full width)        │
#   └─────────────────────────────┘
_wt_create_layout() {
    local cwd="$1"
    # Start with a single pane in cwd
    # Split bottom 30% horizontally
    tmux split-window -v -p 30 -c "$cwd"
    # Go back to top pane, split right 50%
    tmux select-pane -t top
    tmux split-window -h -p 50 -c "$cwd"
    # Focus top-left (pane 1 — where user will start rovo)
    tmux select-pane -t top-left
}

# Apply the triptych layout to the current tmux window using the current
# pane's working directory. Refuses to run if the window already has more
# than one pane (to avoid clobbering an existing layout).
_wt_layout() {
    if [[ -z "$TMUX" ]]; then
        _wt_err "Not running inside tmux."
        return 1
    fi

    local panes
    panes=$(tmux display-message -p '#{window_panes}')
    if [[ "$panes" -gt 1 ]]; then
        _wt_warn "Current window has ${panes} panes — refusing to overwrite layout."
        echo "   Close other panes first (or run from a single-pane window)."
        return 1
    fi

    local cwd
    cwd=$(tmux display-message -p '#{pane_current_path}')
    _wt_create_layout "$cwd"
}

# ── error/info helpers ────────────────────────────────────────────────────────

_wt_err()  { echo "❌ $*" >&2 }
_wt_ok()   { echo "✅ $*" }
_wt_info() { echo "ℹ️  $*" }
_wt_warn() { echo "⚠️  $*" }

# ── subcommands ───────────────────────────────────────────────────────────────

_wt_help() {
    cat << 'EOF'
wt — workspace manager

USAGE
  wt <command> [args]

REPO KINDS
  worktree   <root>/master/ + <root>/agents/agent-NNN/   (multi-worktree)
  single     <repo-dir>                                  (no worktrees)

  The kind is auto-detected at registration time:
    if <path>/master AND <path>/agents both exist  -> worktree
    otherwise                                       -> single

COMMANDS

  Repo management
    wt repo register <name> <path>    Register a repo (kind auto-detected)
    wt repo unregister <name>         Unregister a repo
    wt repo list                      List registered repos (with KIND column)

  Worktree-only setup
    wt init <url> <root-dir>          Clone repo into worktree structure
    wt convert <dir>                  Convert existing repo to worktree structure

  Worktree-only commands         (single-mode repos error with hint)
    wt new  [repo] [count]            Create N agent worktrees (default: 1)
    wt rm   <repo>-<num>              Remove one worktree + branch
    wt rm   <repo>                    Remove ALL worktrees for a repo

  Common commands         (work for both worktree and single)
    wt list [repo]                    List worktrees + single-mode repos
    wt sync [repo]                    Fetch + rebase
                                        worktree: master + all agents
                                        single:   local primary + current branch
    wt sync <repo>-<num>              (worktree) sync one agent worktree
    wt clean                          Reset worktree to its base branch + sync
                                        master/: checkout primary, delete old branch
                                        agent-N/: checkout agent/N, delete old branch
                                        Then runs wt sync automatically.
    wt close [repo|repo-num]          Close tmux window for a workspace
                                        Omit arg to auto-detect from current dir
    wt layout                         Apply triptych layout to CURRENT tmux window

  Workspace switching (tmux)
    wt <repo>                         No-title open / focus
                                        worktree: next free agent (window: '<repo>-N')
                                        single:   the repo dir   (window: '<repo>')
                                      If already open, just focus.
    wt <repo> "<title>"               Open / focus + rename
                                        worktree: '<repo>-N: <title>'
                                        single:   '<repo>: <title>'
                                      If already open: focus AND rename to new title.
    wt <repo>-<num> ["<title>"]       (worktree) target a specific agent worktree.
                                        <num> = 0  opens the master/ directory.
                                        <num> = 1+ opens agents/agent-NNN/.

  Help
    wt --help | -h                    Show this help

LAYOUT
  Each workspace opens a triptych layout:
    ┌──────────────┬──────────────┐  ← 70% height
    │  pane 1      │  pane 2      │
    ├──────────────┴──────────────┤  ← 30% height
    │  pane 3 (full width)        │
    └─────────────────────────────┘

CONFIG
  ~/.wt/repos   Repo registry: <name> <path> <kind>
                Managed by 'wt repo register' / 'wt repo unregister'.

EOF
}

_wt_repo_register() {
    local name="$1" p="$2"
    if [[ -z "$name" || -z "$p" ]]; then
        _wt_err "Usage: wt repo register <name> <path>"
        return 1
    fi
    p="${p:A}"
    _wt_ensure_config
    if _wt_repos | /usr/bin/awk -v n="$name" '$1 == n { found=1 } END { exit !found }'; then
        _wt_err "Repo '$name' is already registered."
        _wt_info "Use 'wt repo unregister $name' first if you want to update it."
        return 1
    fi

    local kind
    if [[ -d "${p}/master" && -d "${p}/agents" ]]; then
        kind="worktree"
        local agents_dir="${p}/agents"
        echo "${name}  ${agents_dir}  ${kind}" >> "$WT_REPOS_FILE"
        _wt_ok "Registered repo '$name' (worktree) → $agents_dir"
    elif [[ "${p:t}" == "agents" && -d "${p:h}/master" ]]; then
        kind="worktree"
        echo "${name}  ${p}  ${kind}" >> "$WT_REPOS_FILE"
        _wt_ok "Registered repo '$name' (worktree) → $p"
    else
        kind="single"
        if [[ ! -d "$p" ]]; then
            _wt_err "Path does not exist: $p"
            return 1
        fi
        if [[ ! -d "${p}/.git" ]]; then
            _wt_warn "Path is not a git repo (no .git dir found): $p"
            _wt_info "Registering anyway as single-mode."
        fi
        echo "${name}  ${p}  ${kind}" >> "$WT_REPOS_FILE"
        _wt_ok "Registered repo '$name' (single) → $p"
    fi
}

_wt_repo_unregister() {
    local name="$1"
    if [[ -z "$name" ]]; then
        _wt_err "Usage: wt repo unregister <name>"
        return 1
    fi
    _wt_ensure_config
    if ! _wt_repos | /usr/bin/awk -v n="$name" '$1 == n { found=1 } END { exit !found }'; then
        _wt_err "Repo '$name' not found in registry."
        return 1
    fi
    local tmpfile="${WT_REPOS_FILE}.tmp"
    /usr/bin/awk -v n="$name" '$1 != n' "$WT_REPOS_FILE" > "$tmpfile" && mv "$tmpfile" "$WT_REPOS_FILE"
    _wt_ok "Removed repo '$name' from registry."
}

_wt_repo_list() {
    _wt_ensure_config
    local repos
    repos=$(_wt_repos)
    if [[ -z "$repos" ]]; then
        _wt_info "No repos registered. Use 'wt repo register <name> <path>'."
        return 0
    fi
    printf "%-20s %-10s %s\n" "NAME" "KIND" "PATH"
    printf "%-20s %-10s %s\n" "----" "----" "----"
    echo "$repos" | while read -r name p kind; do
        local extra=""
        if [[ "$kind" == "worktree" ]]; then
            local count=0
            [[ -d "$p" ]] && count=$(ls -d "${p}"/agent-*(N) 2>/dev/null | wc -l | tr -d ' ')
            extra="  (${count} worktrees)"
        fi
        printf "%-20s %-10s %s%s\n" "$name" "$kind" "$p" "$extra"
    done
}

_wt_init() {
    local url="$1" root_dir="$2"
    if [[ -z "$url" || -z "$root_dir" ]]; then
        _wt_err "Usage: wt init <url> <root-dir>"
        return 1
    fi
    root_dir="${root_dir:A}"
    if [[ -d "$root_dir" ]]; then
        _wt_err "Directory already exists: $root_dir"
        _wt_info "Use 'wt convert $root_dir' if you have an existing checkout."
        return 1
    fi
    echo "🔧 Cloning into worktree structure..."
    echo "   URL:  $url"
    echo "   Root: $root_dir"
    mkdir -p "$root_dir"
    # Clone into master/
    git clone "$url" "${root_dir}/master" || { _wt_err "Clone failed."; return 1 }
    mkdir -p "${root_dir}/agents"
    _wt_ok "Cloned into ${root_dir}/master/"
    _wt_ok "Created ${root_dir}/agents/"
    echo ""
    # Prompt to register
    local suggested="${root_dir:t}"
    echo -n "   Register as repo name [$suggested]: "
    read -r reg_name
    [[ -z "$reg_name" ]] && reg_name="$suggested"
    _wt_repo_register "$reg_name" "${root_dir}/agents"
    echo ""
    _wt_info "Next: wt new $reg_name [count]"
}

_wt_convert() {
    local dir="${1:-.}"
    dir="${dir:A}"  # resolve absolute path

    if [[ ! -d "$dir" ]]; then
        _wt_err "Directory not found: $dir"
        return 1
    fi
    if [[ ! -d "${dir}/.git" ]]; then
        _wt_err "Not a git repository: $dir"
        return 1
    fi
    if [[ -d "${dir}/master" && -d "${dir}/agents" ]]; then
        _wt_err "Already looks like a worktree structure (master/ and agents/ exist)."
        return 1
    fi

    local parent="${dir:h}"
    local dirname="${dir:t}"

    echo "🔧 Converting $dir to worktree structure..."
    echo ""
    echo "   This will:"
    echo "   1. Create ${dir}/master/"
    echo "   2. Move all contents of $dir into ${dir}/master/"
    echo "   3. Create ${dir}/agents/"
    echo ""
    echo -n "   Continue? [y/N] "
    read -r confirm
    [[ "$confirm" != "y" && "$confirm" != "Y" ]] && { echo "Aborted."; return 0 }

    # Create a temp dir alongside, move contents in, then rename back
    local tmp_master="${parent}/.wt-convert-tmp-$$"
    mkdir -p "$tmp_master"

    # Move everything from dir into tmp_master
    # Use find to handle dotfiles
    (cd "$dir" && find . -maxdepth 1 ! -name '.' -exec mv {} "$tmp_master/" \;) \
        || { _wt_err "Failed to move files."; rm -rf "$tmp_master"; return 1 }

    # Create master/ subdir inside dir and move tmp there
    mkdir -p "${dir}/master"
    (cd "$tmp_master" && find . -maxdepth 1 ! -name '.' -exec mv {} "${dir}/master/" \;) \
        || { _wt_err "Failed to move into master/."; return 1 }
    rm -rf "$tmp_master"

    # Create agents/
    mkdir -p "${dir}/agents"

    _wt_ok "Converted! Structure:"
    echo "   ${dir}/"
    echo "   ├── master/   ← your existing checkout"
    echo "   └── agents/   ← ready for wt new"
    echo ""
    # Prompt to register
    local suggested="${dir:t}"
    echo -n "   Register as repo name [$suggested]: "
    read -r reg_name
    [[ -z "$reg_name" ]] && reg_name="$suggested"
    _wt_repo_register "$reg_name" "${dir}/agents"
    echo ""
    _wt_info "Next: wt new $reg_name [count]"
}

_wt_new() {
    local repo="$1" count="${2:-1}"

    # If no repo given, auto-detect from current directory
    if [[ -z "$repo" ]]; then
        local cwd="${PWD}"
        local detected=""
        while read -r name path_candidate kind_candidate; do
            local root_candidate
            if [[ "$kind_candidate" == "single" ]]; then
                root_candidate="$path_candidate"
            else
                root_candidate="${path_candidate:h}"
            fi
            if [[ "$cwd" == "$root_candidate"* ]]; then
                detected="$name"
                break
            fi
        done <<< "$(_wt_repos)"
        if [[ -z "$detected" ]]; then
            _wt_err "Could not detect repo from current directory: $cwd"
            echo "  Usage: wt new <repo> [count]"
            echo "  Or cd into a registered repo directory first."
            return 1
        fi
        _wt_info "Auto-detected repo: $detected"
        repo="$detected"
    fi

    local kind
    kind=$(_wt_repo_kind "$repo")
    if [[ -z "$kind" ]]; then
        _wt_err "Repo '$repo' not registered."
        echo "  Run: wt repo register $repo <path>"
        return 1
    fi
    if [[ "$kind" == "single" ]]; then
        _wt_err "'$repo' is a single-mode repo and has no worktrees."
        echo "  Use: wt $repo \"<title>\"   to open the repo in a tmux window."
        return 1
    fi

    local agents_dir
    agents_dir=$(_wt_agents_dir "$repo")
    if [[ ! -d "$agents_dir" ]]; then
        _wt_err "Agents dir does not exist: $agents_dir"
        echo "  Run 'wt init' or 'wt convert' first."
        return 1
    fi
    local master_dir
    master_dir=$(_wt_master_dir "$agents_dir")
    if [[ ! -d "$master_dir" ]]; then
        _wt_err "master/ not found at: $master_dir"
        echo "  Run 'wt init' or 'wt convert' first."
        return 1
    fi
    local primary_branch
    primary_branch=$(_wt_primary_branch "$master_dir")

    # Branch from origin/<branch> if available, else local branch
    local base_ref
    if git -C "$master_dir" rev-parse --verify "origin/${primary_branch}" &>/dev/null; then
        base_ref="origin/${primary_branch}"
    else
        base_ref="$primary_branch"
    fi

    local i num wt_path branch
    for (( i=1; i<=count; i++ )); do
        num=$(_wt_next_agent_num "$agents_dir")
        wt_path="${agents_dir}/agent-${num}"
        branch="agent/${num}"
        echo "📁 Creating worktree: agent-${num}  (branch: ${branch}, base: ${base_ref})"
        git -C "$master_dir" worktree add -b "$branch" "$wt_path" "$base_ref" \
            || { _wt_err "Failed to create worktree agent-${num}"; return 1 }
        _wt_ok "Created ${wt_path}"
    done
}

_wt_rm_one() {
    local repo="$1" num="$2"  # num already zero-padded
    local agents_dir master_dir wt_path branch
    agents_dir=$(_wt_agents_dir "$repo")
    master_dir=$(_wt_master_dir "$agents_dir")
    wt_path="${agents_dir}/agent-${num}"
    branch="agent/${num}"

    if [[ ! -d "$wt_path" ]]; then
        _wt_err "Worktree not found: $wt_path"
        return 1
    fi

    # Close tmux window if open
    local pane_map tmux_win
    pane_map=$(tmux list-panes -a -F '#{session_name}:#{window_index}|#{pane_current_path}' 2>/dev/null)
    tmux_win=$(echo "$pane_map" | /usr/bin/awk -F'|' -v p="$wt_path" '$2 == p {print $1; exit}')
    if [[ -n "$tmux_win" ]]; then
        _wt_info "Closing tmux window: $tmux_win"
        tmux kill-window -t "$tmux_win" 2>/dev/null || true
    fi

    git -C "$master_dir" worktree remove --force "$wt_path" 2>/dev/null \
        || { _wt_err "git worktree remove failed for agent-${num}"; return 1 }
    git -C "$master_dir" branch -D "$branch" 2>/dev/null \
        || _wt_warn "Could not delete branch '$branch' (may not exist locally)."

    # Clean up saved title
    rm -f "${WT_STATE_DIR}/${repo}-$(( 10#$num ))" 2>/dev/null || true

    _wt_ok "Removed agent-${num} (branch: ${branch})"
}

_wt_rm() {
    local arg="$1"
    if [[ -z "$arg" ]]; then
        _wt_err "Usage: wt rm <repo>-<num>   remove one worktree"
        echo "       wt rm <repo>          remove ALL worktrees for a repo"
        return 1
    fi

    # Check if arg is just a repo name (no number) → remove all
    if ! [[ "$arg" =~ ^(.+)-([0-9]+)$ ]]; then
        local repo="$arg"
        local kind
        kind=$(_wt_repo_kind "$repo")
        if [[ -z "$kind" ]]; then
            _wt_err "Repo '$repo' not registered. Did you mean wt rm <repo>-<num>?"
            return 1
        fi
        if [[ "$kind" == "single" ]]; then
            _wt_err "'$repo' is a single-mode repo and has no worktrees to remove."
            echo "  Use: wt repo unregister $repo   to remove its registration."
            return 1
        fi
        local agents_dir
        agents_dir=$(_wt_agents_dir "$repo")
        local worktrees=("${agents_dir}"/agent-*(N))
        if [[ ${#worktrees[@]} -eq 0 ]]; then
            _wt_info "No worktrees found for '$repo'."
            return 0
        fi
        echo "🗑  Removing ALL ${#worktrees[@]} worktrees for '$repo':"
        for wt_path in "${worktrees[@]}"; do
            echo "   ${wt_path:t}"
        done
        echo -n "   Continue? [y/N] "
        read -r confirm
        [[ "$confirm" != "y" && "$confirm" != "Y" ]] && { echo "Aborted."; return 0 }
        local master_dir
        master_dir=$(_wt_master_dir "$agents_dir")
        for wt_path in "${worktrees[@]}"; do
            local num="${wt_path:t:s/agent-//}"
            _wt_rm_one "$repo" "$num"
        done
        git -C "$master_dir" worktree prune 2>/dev/null || true
        _wt_ok "Removed all worktrees for '$repo'."
        return 0
    fi

    local repo="${match[1]}" num
    num=$(_wt_pad "${match[2]}")
    local kind
    kind=$(_wt_repo_kind "$repo")
    if [[ -z "$kind" ]]; then
        _wt_err "Repo '$repo' not registered."
        return 1
    fi
    if [[ "$kind" == "single" ]]; then
        _wt_err "'$repo' is a single-mode repo and has no worktrees to remove."
        return 1
    fi
    local agents_dir
    agents_dir=$(_wt_agents_dir "$repo")

    echo "🗑  Removing worktree: ${repo} agent-${num}"
    echo -n "   Continue? [y/N] "
    read -r confirm
    [[ "$confirm" != "y" && "$confirm" != "Y" ]] && { echo "Aborted."; return 0 }

    _wt_rm_one "$repo" "$num"
    git -C "$(_wt_master_dir "$agents_dir")" worktree prune 2>/dev/null || true
}

_wt_list() {
    local filter_repo="$1"
    _wt_ensure_config
    local repos
    repos=$(_wt_repos)
    if [[ -z "$repos" ]]; then
        _wt_info "No repos registered. Use 'wt repo register <name> <path>'."
        return 0
    fi

    printf "%-12s %-12s %-28s %s\n" "WT" "DIR" "BRANCH" "STATUS"
    printf "%-12s %-12s %-28s %s\n" "--" "---" "------" "------"

    local pane_map
    pane_map=$(tmux list-panes -a -F '#{session_name}:#{window_index}|#{pane_current_path}' 2>/dev/null)

    local name p kind branch tmux_win wt_status wt_path agent_short id
    while read -r name p kind; do
        [[ -n "$filter_repo" && "$name" != "$filter_repo" ]] && continue
        if [[ "$kind" == "single" ]]; then
            branch=$(git -C "$p" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "(unknown)")
            local branch_display="${branch:0:27}"
            [[ "${#branch}" -gt 27 ]] && branch_display="${branch:0:24}..."
            tmux_win=$(echo "$pane_map" | /usr/bin/awk -F'|' -v p2="$p" '$2 == p2 {print $1; exit}')
            wt_status="free"
            [[ -n "$tmux_win" ]] && wt_status="in use"
            printf "%-12s %-12s %-28s %s\n" \
                "$name" "—" "$branch_display" "$wt_status"
            continue
        fi
        local master_dir_l
        master_dir_l=$(_wt_master_dir "$p")
        if [[ -d "$master_dir_l" ]]; then
            branch=$(git -C "$master_dir_l" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "(unknown)")
            local branch_display="${branch:0:27}"
            [[ "${#branch}" -gt 27 ]] && branch_display="${branch:0:24}..."
            tmux_win=$(echo "$pane_map" | /usr/bin/awk -F'|' -v p2="$master_dir_l" '$2 == p2 {print $1; exit}')
            wt_status="free"
            [[ -n "$tmux_win" ]] && wt_status="in use"
            printf "%-12s %-12s %-28s %s\n" \
                "${name}-0" "master" "$branch_display" "$wt_status"
        fi
        for wt_path in "${p}"/agent-*(N); do
            [[ ! -d "$wt_path" ]] && continue
            agent_short=$(( 10#${wt_path:t:s/agent-//} ))
            id="${name}-${agent_short}"
            branch=$(git -C "$wt_path" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "(unknown)")
            local branch_display="${branch:0:27}"
            [[ "${#branch}" -gt 27 ]] && branch_display="${branch:0:24}..."
            tmux_win=$(echo "$pane_map" | /usr/bin/awk -F'|' -v p2="$wt_path" '$2 == p2 {print $1; exit}')
            wt_status="free"
            [[ -n "$tmux_win" ]] && wt_status="in use"
            printf "%-12s %-12s %-28s %s\n" \
                "$id" "${wt_path:t}" "$branch_display" "$wt_status"
        done
    done <<< "$repos"
}

_wt_sync() {
    local arg="${1:-}"

    local repo num kind

    # ── Resolve repo + num ────────────────────────────────────────────────────
    if [[ -z "$arg" ]]; then
        local cwd="${PWD}"
        local detected_repo="" detected_num="" detected_kind=""
        while read -r name path_candidate kind_candidate; do
            local root_candidate
            if [[ "$kind_candidate" == "single" ]]; then
                root_candidate="$path_candidate"
            else
                root_candidate="${path_candidate:h}"
            fi
            if [[ "$cwd" == "$root_candidate"* ]]; then
                detected_repo="$name"
                detected_kind="$kind_candidate"
                if [[ "$kind_candidate" != "single" ]]; then
                    if [[ "$cwd" == "${path_candidate}/agent-"* ]]; then
                        local agent_dir="${cwd#${path_candidate}/}"
                        agent_dir="${agent_dir%%/*}"
                        detected_num="${agent_dir#agent-}"
                    elif [[ "$cwd" == "${path_candidate:h}/master"* ]]; then
                        detected_num="0"
                    fi
                fi
                break
            fi
        done <<< "$(_wt_repos)"
        if [[ -z "$detected_repo" ]]; then
            _wt_err "Not inside a registered repo. Specify explicitly:"
            echo "  wt sync <repo>          sync master/"
            echo "  wt sync <repo>-<num>    sync a specific agent worktree"
            return 1
        fi
        repo="$detected_repo"
        num="$detected_num"
        kind="$detected_kind"
    elif [[ "$arg" =~ ^(.+)-([0-9]+)$ ]]; then
        repo="${match[1]}"
        num="${match[2]}"
    else
        repo="$arg"
        num=""
    fi

    if [[ -z "$kind" ]]; then
        kind=$(_wt_repo_kind "$repo")
        if [[ -z "$kind" ]]; then
            _wt_err "Repo '$repo' not registered."
            return 1
        fi
    fi

    # ── Single-mode ───────────────────────────────────────────────────────────
    if [[ "$kind" == "single" ]]; then
        local repo_path primary_branch current_branch
        repo_path=$(_wt_repo_path "$repo")
        if [[ ! -d "${repo_path}/.git" ]]; then
            _wt_err "Not a git repo at: $repo_path"
            return 1
        fi
        primary_branch=$(_wt_primary_branch "$repo_path")
        current_branch=$(git -C "$repo_path" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
        echo "🔄 Fetching origin/$primary_branch..."
        git -C "$repo_path" fetch origin "$primary_branch" --prune --prune-tags --no-tags 2>/dev/null \
            || _wt_warn "Fetch failed."
        git -C "$repo_path" branch -f "$primary_branch" "origin/${primary_branch}" 2>/dev/null
        echo "↪ Rebasing $current_branch onto $primary_branch..."
        if git -C "$repo_path" rebase "$primary_branch" 2>/dev/null; then
            _wt_ok "$current_branch is up to date"
        else
            _wt_warn "Rebase conflict — resolve manually."
        fi
        return 0
    fi

    # ── Worktree-mode ─────────────────────────────────────────────────────────
    local agents_dir master_dir primary_branch
    agents_dir=$(_wt_agents_dir "$repo")
    master_dir=$(_wt_master_dir "$agents_dir")
    if [[ ! -d "$master_dir" ]]; then
        _wt_err "master/ not found at: $master_dir"
        return 1
    fi
    primary_branch=$(_wt_primary_branch "$master_dir")

    echo "🔄 Fetching origin/$primary_branch..."
    git -C "$master_dir" fetch origin "$primary_branch" --prune --prune-tags --no-tags 2>/dev/null \
        || _wt_warn "Fetch failed."
    git -C "$master_dir" branch -f "$primary_branch" "origin/${primary_branch}" 2>/dev/null

    local target_dir padded agent_branch target_branch

    if [[ -z "$num" || "$num" == "0" ]]; then
        target_dir="$master_dir"
    else
        padded=$(_wt_pad "$num")
        target_dir="${agents_dir}/agent-${padded}"
        if [[ ! -d "$target_dir" ]]; then
            _wt_err "Worktree not found: $target_dir"
            return 1
        fi

        agent_branch="agent/${padded}"
        echo "↪ Fast-forwarding $agent_branch to origin/${primary_branch}..."
        if git -C "$master_dir" branch -f "$agent_branch" "origin/${primary_branch}" 2>/dev/null; then
            _wt_ok "$agent_branch updated"
        else
            _wt_warn "Could not fast-forward $agent_branch — resolve manually in $master_dir"
            return 1
        fi
    fi

    target_branch=$(git -C "$target_dir" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "?")
    local rebase_onto="${agent_branch:-origin/${primary_branch}}"
    if [[ "$target_branch" != "${agent_branch:-}" ]]; then
        echo "↪ Rebasing $target_branch onto $rebase_onto..."
        if git -C "$target_dir" rebase "$rebase_onto" 2>/dev/null; then
            _wt_ok "$target_branch is up to date"
        else
            _wt_warn "Conflict rebasing $target_branch — resolve manually in $target_dir"
            git -C "$target_dir" rebase --abort 2>/dev/null || true
        fi
    else
        _wt_ok "$target_branch is up to date"
    fi
}

_wt_clean() {
    local cwd="${PWD}"

    # Auto-detect repo + worktree from cwd
    local repo="" num="" kind="" wt_dir="" base_branch=""
    while read -r name path_candidate kind_candidate; do
        if [[ "$kind_candidate" == "single" ]]; then
            if [[ "$cwd" == "$path_candidate"* ]]; then
                repo="$name"; kind="single"; wt_dir="$path_candidate"
                base_branch=$(_wt_primary_branch "$wt_dir")
                break
            fi
        else
            local master_candidate="${path_candidate:h}/master"
            if [[ "$cwd" == "${path_candidate}/agent-"* ]]; then
                repo="$name"; kind="worktree"; wt_dir="$path_candidate"
                local agent_dir="${cwd#${path_candidate}/}"
                agent_dir="${agent_dir%%/*}"
                local padded="${agent_dir#agent-}"
                base_branch="agent/${padded}"
                break
            elif [[ "$cwd" == "${master_candidate}"* ]]; then
                repo="$name"; kind="worktree"; wt_dir="$master_candidate"
                base_branch=$(_wt_primary_branch "$master_candidate")
                break
            fi
        fi
    done <<< "$(_wt_repos)"

    if [[ -z "$repo" ]]; then
        _wt_err "Not inside a registered repo. Run wt clean from inside a worktree."
        return 1
    fi

    local current_branch
    current_branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")

    if [[ -z "$current_branch" ]]; then
        _wt_err "Could not determine current branch."
        return 1
    fi

    if [[ "$current_branch" == "$base_branch" ]]; then
        _wt_info "Already on base branch '$base_branch'. Running sync..."
        _wt_sync
        return
    fi

    echo "🧹 Cleaning '$current_branch' → resetting to '$base_branch'..."
    echo -n "   Delete branch '$current_branch' and sync? [y/N] "
    read -r confirm
    [[ "$confirm" != "y" && "$confirm" != "Y" ]] && { echo "Aborted."; return 0 }

    # agent/NNN branches are tied to their worktree and can't be checked out normally.
    # Instead: switch to detached HEAD at base_branch tip, delete the feature branch,
    # then re-attach to base_branch.
    local base_sha
    base_sha=$(git -C "$cwd" rev-parse "$base_branch" 2>/dev/null)
    if [[ -z "$base_sha" ]]; then
        _wt_err "Cannot resolve '$base_branch' — does it exist?"
        return 1
    fi
    git -C "$cwd" checkout --detach "$base_sha" 2>/dev/null \
        || { _wt_err "Failed to detach HEAD."; return 1 }
    git -C "$cwd" branch -D "$current_branch" 2>/dev/null \
        || _wt_warn "Could not delete '$current_branch'."
    # agent/NNN is locked to its worktree in master/ — recreate the ref here
    # pointing to base_sha so this worktree is back on its base branch
    git -C "$cwd" checkout -B "$base_branch" "$base_sha" 2>/dev/null \
        || { _wt_err "Failed to recreate '$base_branch'."; return 1 }
    _wt_ok "Deleted '$current_branch', now on '$base_branch'"

    _wt_sync
}

_wt_close() {
    local arg="${1:-}"

    if [[ -z "$arg" ]]; then
        local cwd="${PWD}"
        local detected_repo="" detected_num="" detected_kind=""
        while read -r name path_candidate kind_candidate; do
            if [[ "$kind_candidate" == "single" ]]; then
                if [[ "$cwd" == "$path_candidate"* ]]; then
                    detected_repo="$name"
                    detected_kind="single"
                    break
                fi
            else
                if [[ "$cwd" == "${path_candidate}/agent-"* ]]; then
                    detected_repo="$name"
                    detected_kind="worktree"
                    local agent_dir="${cwd#${path_candidate}/}"
                    agent_dir="${agent_dir%%/*}"
                    detected_num="${agent_dir#agent-}"
                    break
                fi
            fi
        done <<< "$(_wt_repos)"
        if [[ -z "$detected_repo" ]]; then
            _wt_err "Not inside a registered repo directory. Usage: wt close <repo>-<num> | wt close <single-repo>"
            return 1
        fi
        if [[ "$detected_kind" == "single" ]]; then
            arg="$detected_repo"
        else
            arg="${detected_repo}-${detected_num}"
        fi
    fi

    local repo num kind
    if [[ "$arg" =~ ^(.+)-([0-9]+)$ ]]; then
        repo="${match[1]}"
        num=$(_wt_pad "${match[2]}")
    else
        repo="$arg"
        num=""
    fi

    kind=$(_wt_repo_kind "$repo")
    if [[ -z "$kind" ]]; then
        _wt_err "Repo '$repo' not registered."
        return 1
    fi

    local target_path
    if [[ "$kind" == "single" ]]; then
        if [[ -n "$num" ]]; then
            _wt_err "'$repo' is a single-mode repo; <num> doesn't apply."
            return 1
        fi
        target_path=$(_wt_repo_path "$repo")
    else
        if [[ -z "$num" ]]; then
            _wt_err "Usage: wt close <repo>-<num>"
            return 1
        fi
        local agents_dir
        agents_dir=$(_wt_agents_dir "$repo")
        if [[ "$num" == "0" ]]; then
            target_path=$(_wt_master_dir "$agents_dir")
        else
            target_path="${agents_dir}/agent-${num}"
        fi
    fi

    local pane_map tmux_win
    pane_map=$(tmux list-panes -a -F '#{session_name}:#{window_index}|#{pane_current_path}' 2>/dev/null)
    tmux_win=$(echo "$pane_map" | /usr/bin/awk -F'|' -v p="$target_path" '$2 == p {print $1; exit}')

    if [[ -z "$tmux_win" ]]; then
        _wt_info "No tmux window is currently using $repo${num:+-$num}."
        return 0
    fi

    tmux kill-window -t "$tmux_win" 2>/dev/null \
        && _wt_ok "Closed tmux window '$tmux_win' ($repo${num:+ agent-$num})" \
        || _wt_err "Failed to close window '$tmux_win'"
}

_wt_pick() {
    if [[ -z "${TMUX:-}" ]]; then
        _wt_err "Not inside a tmux session."
        return 1
    fi
    command -v fzf >/dev/null 2>&1 || { _wt_err "fzf not found"; return 1 }

    local pane_map
    pane_map=$(tmux list-panes -a -F '#{session_name}:#{window_index}|#{pane_current_path}' 2>/dev/null)

    local rows=()
    local name p kind branch wt_status tmux_win wt_path agent_short id

    while read -r name p kind; do
        if [[ "$kind" == "single" ]]; then
            branch=$(git -C "$p" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "(unknown)")
            tmux_win=$(echo "$pane_map" | /usr/bin/awk -F'|' -v p2="$p" '$2 == p2 {print $1; exit}')
            wt_status="${tmux_win:-free}"
            local branch_display="${branch:0:25}"
            [[ "${#branch}" -gt 25 ]] && branch_display="${branch:0:22}..."
            rows+=("${tmux_win:-}"$'\t'"$(printf '%-12s %-12s %-27s %-8s' "$name" "—" "$branch_display" "${tmux_win:+open}")")
            continue
        fi
        local master_dir_p
        master_dir_p=$(_wt_master_dir "$p")
        if [[ -d "$master_dir_p" ]]; then
            branch=$(git -C "$master_dir_p" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "(unknown)")
            tmux_win=$(echo "$pane_map" | /usr/bin/awk -F'|' -v p2="$master_dir_p" '$2 == p2 {print $1; exit}')
            local branch_display="${branch:0:25}"
            [[ "${#branch}" -gt 25 ]] && branch_display="${branch:0:22}..."
            rows+=("${tmux_win:-}"$'\t'"$(printf '%-12s %-12s %-27s %-8s' "${name}-0" "master" "$branch_display" "${tmux_win:+open}")")
        fi
        for wt_path in "${p}"/agent-*(N); do
            [[ ! -d "$wt_path" ]] && continue
            agent_short=$(( 10#${wt_path:t:s/agent-//} ))
            id="${name}-${agent_short}"
            branch=$(git -C "$wt_path" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "(unknown)")
            tmux_win=$(echo "$pane_map" | /usr/bin/awk -F'|' -v p2="$wt_path" '$2 == p2 {print $1; exit}')
            local branch_display="${branch:0:25}"
            [[ "${#branch}" -gt 25 ]] && branch_display="${branch:0:22}..."
            rows+=("${tmux_win:-}"$'\t'"$(printf '%-12s %-12s %-27s %-8s' "$id" "${wt_path:t}" "$branch_display" "${tmux_win:+open}")")
        done
    done <<< "$(_wt_repos)"

    if [[ ${#rows[@]} -eq 0 ]]; then
        _wt_info "No workspaces registered."
        return 0
    fi

    local selected
    selected=$(printf '%s\n' "${rows[@]}" \
        | fzf --exit-0 --reverse --tmux "center,60%,50%" \
              --delimiter=$'\t' --with-nth=2 \
              --header="$(printf '%-12s %-12s %-27s %s' 'WT' 'DIR' 'BRANCH' 'STATUS')" \
              --no-multi)

    [[ -z "$selected" ]] && return 0

    local target_win
    target_win=$(echo "$selected" | cut -d$'\t' -f1)

    if [[ -z "$target_win" ]]; then
        local wt_id
        wt_id=$(echo "$selected" | cut -d$'\t' -f2 | awk '{print $1}')
        _wt_info "Opening '$wt_id'..."
        wt "$wt_id"
        return
    fi

    local win_idx
    win_idx=$(echo "$target_win" | cut -d: -f2)
    tmux select-window -t "$target_win" 2>/dev/null \
        && tmux switch-client -t "$target_win" 2>/dev/null
}

_wt_window_name() {
    local id="$1" title="$2"
    if [[ -z "$title" ]]; then
        echo "$id"
    else
        echo "${id}: ${title}"
    fi
}

_wt_open() {
    local arg="$1"
    local title_given=0 title=""
    if (( $# >= 2 )); then
        title_given=1
        title="$2"
    fi

    if [[ -z "${TMUX:-}" ]]; then
        _wt_err "Not inside a tmux session. Start tmux first."
        return 1
    fi

    local repo_kind=""
    if [[ ! "$arg" =~ ^(.+)-([0-9]+)$ ]]; then
        repo_kind=$(_wt_repo_kind "$arg")
    fi

    if [[ "$repo_kind" == "single" ]]; then
        local repo="$arg"
        local repo_path
        repo_path=$(_wt_repo_path "$repo")
        if [[ ! -d "$repo_path" ]]; then
            _wt_err "Repo path does not exist: $repo_path"
            return 1
        fi

        local pane_map existing_win
        pane_map=$(tmux list-panes -a -F '#{session_name}:#{window_index}|#{pane_current_path}' 2>/dev/null)
        existing_win=$(echo "$pane_map" | /usr/bin/awk -F'|' -v p2="$repo_path" '$2 == p2 {print $1; exit}')
        if [[ -n "$existing_win" ]]; then
            if (( title_given )); then
                local window_name=$(_wt_window_name "$repo" "$title")
                tmux rename-window -t "$existing_win" "$window_name" 2>/dev/null
                _wt_info "Focused '${existing_win}' (renamed to '${window_name}')"
            else
                _wt_info "Focused existing window '${existing_win}' for ${repo}"
            fi
            tmux switch-client -t "$existing_win" 2>/dev/null || tmux select-window -t "$existing_win" 2>/dev/null
            return 0
        fi

        local window_name=$(_wt_window_name "$repo" "$title")
        tmux new-window -a -n "$window_name" -c "$repo_path"
        _wt_create_layout "$repo_path"
        _wt_ok "Opened '${window_name}' [$(git -C "$repo_path" rev-parse --abbrev-ref HEAD 2>/dev/null)]"
        return 0
    fi

    local repo num wt_path
    if [[ "$arg" =~ ^(.+)-([0-9]+)$ ]]; then
        repo="${match[1]}"
        local raw_num="${match[2]}"
        local agents_dir master_dir
        agents_dir=$(_wt_agents_dir "$repo")
        if [[ -z "$agents_dir" ]]; then
            _wt_err "Repo '$repo' not registered."
            return 1
        fi
        if [[ "$raw_num" == "0" ]]; then
            master_dir=$(_wt_master_dir "$agents_dir")
            if [[ ! -d "$master_dir" ]]; then
                _wt_err "master/ not found at: $master_dir"
                return 1
            fi
            wt_path="${master_dir:A}"
            num="0"
        else
            num=$(_wt_pad "$raw_num")
            wt_path="${agents_dir}/agent-${num}"
            if [[ ! -d "$wt_path" ]]; then
                _wt_err "Worktree not found: $wt_path"
                echo "  Run: wt new $repo"
                return 1
            fi
        fi
    else
        repo="$arg"
        local agents_dir
        agents_dir=$(_wt_agents_dir "$repo")
        if [[ -z "$agents_dir" ]]; then
            _wt_err "Repo '$repo' not registered."
            echo "  Run: wt repo register $repo <path>"
            return 1
        fi
        if [[ ! -d "$agents_dir" ]]; then
            _wt_err "Agents dir does not exist: $agents_dir"
            echo "  Run 'wt init' or 'wt convert' first, then 'wt new $repo'."
            return 1
        fi

        local pane_map_open
        pane_map_open=$(tmux list-panes -a -F '#{session_name}:#{window_index}|#{pane_current_path}' 2>/dev/null)
        wt_path=""
        for candidate in "${agents_dir}"/agent-*(N); do
            [[ ! -d "$candidate" ]] && continue
            local in_use
            in_use=$(echo "$pane_map_open" | /usr/bin/awk -F'|' -v p2="$candidate" '$2 == p2 {print $1; exit}')
            if [[ -z "$in_use" ]]; then
                wt_path="$candidate"
                break
            fi
        done

        if [[ -z "$wt_path" ]]; then
            _wt_err "No free agent worktrees available for '$repo'."
            echo "  All worktrees are currently in use by a tmux window."
            echo "  Create more with: wt new $repo"
            return 1
        fi
    fi

    local agent_short
    if [[ "$num" == "0" ]]; then
        agent_short="0"
    else
        agent_short=$(( 10#${wt_path:t:s/agent-//} ))
    fi
    local id="${repo}-${agent_short}"

    local pane_map existing_win
    pane_map=$(tmux list-panes -a -F '#{session_name}:#{window_index}|#{pane_current_path}' 2>/dev/null)
    existing_win=$(echo "$pane_map" | /usr/bin/awk -F'|' -v p2="$wt_path" '$2 == p2 {print $1; exit}')
    if [[ -n "$existing_win" ]]; then
        if (( title_given )); then
            local window_name=$(_wt_window_name "$id" "$title")
            tmux rename-window -t "$existing_win" "$window_name" 2>/dev/null
            _wt_info "Focused '${existing_win}' (renamed to '${window_name}')"
        else
            _wt_info "Focused existing window '${existing_win}' for ${id}"
        fi
        tmux switch-client -t "$existing_win" 2>/dev/null || tmux select-window -t "$existing_win" 2>/dev/null
        return 0
    fi

    local window_name=$(_wt_window_name "$id" "$title")
    tmux new-window -a -n "$window_name" -c "$wt_path"
    _wt_create_layout "$wt_path"
    _wt_ok "Opened '${window_name}' [$(git -C "$wt_path" rev-parse --abbrev-ref HEAD 2>/dev/null)]"
}

# ── main entrypoint ───────────────────────────────────────────────────────────

wt() {
    local cmd="${1:-}"

    case "$cmd" in
        --help|-h|help|"")
            _wt_help
            ;;
        repo)
            local subcmd="${2:-}"
            case "$subcmd" in
                register)   _wt_repo_register   "${@:3}" ;;
                unregister) _wt_repo_unregister  "${@:3}" ;;
                list)       _wt_repo_list ;;
                *)
                    _wt_err "Unknown repo subcommand: '$subcmd'"
                    echo "  Available: register, unregister, list"
                    return 1
                    ;;
            esac
            ;;
        init)    _wt_init    "${@:2}" ;;
        convert) _wt_convert "${@:2}" ;;
        new)     _wt_new     "${@:2}" ;;
        rm)      _wt_rm      "${@:2}" ;;
        list)    _wt_list    "${@:2}" ;;
        sync)    _wt_sync    "${@:2}" ;;
        clean)   _wt_clean   "${@:2}" ;;
        close)   _wt_close   "${@:2}" ;;
        layout)  _wt_layout  "${@:2}" ;;
        pick)    _wt_pick   "${@:2}" ;;
        *)
            _wt_open "$cmd" "${2:-}"
            ;;
    esac
}
