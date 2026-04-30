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

WT_CONFIG_DIR="${HOME}/.wt"
WT_REPOS_FILE="${WT_CONFIG_DIR}/repos"
WT_STATE_DIR="${WT_CONFIG_DIR}/state"

# ── helpers ───────────────────────────────────────────────────────────────────

_wt_save_title() {
    local key="$1" title="$2"   # key = e.g. "afm-1"
    mkdir -p "$WT_STATE_DIR"
    echo "$title" > "${WT_STATE_DIR}/${key}"
}

_wt_load_title() {
    local key="$1"
    local f="${WT_STATE_DIR}/${key}"
    [[ -f "$f" ]] && cat "$f" || echo ""
}

_wt_ensure_config() {
    [[ -d "$WT_CONFIG_DIR" ]] || mkdir -p "$WT_CONFIG_DIR"
    if [[ ! -f "$WT_REPOS_FILE" ]]; then
        cat > "$WT_REPOS_FILE" << 'EOF'
# ~/.wt/repos — wt repo registry
# Format: <name> <agents-dir>
# Example:
#   myproject  /Users/me/code/myproject/agents
#
# Managed by: wt repo new / wt repo rm
EOF
    fi
}

# Print all registered repos as: name agents-dir
_wt_repos() {
    _wt_ensure_config
    grep -v '^\s*#' "$WT_REPOS_FILE" | grep -v '^\s*$' | /usr/bin/awk '{print $1, $2}'
}

# Get agents dir for a repo name (empty string if not found)
_wt_agents_dir() {
    local name="$1"
    _wt_repos | /usr/bin/awk -v n="$name" '$1 == n {print $2}'
}

# Get master dir (parent of agents dir)
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
    local path="$1"
    tmux list-panes -a \
        -F '#{session_name}:#{window_index}|#{pane_current_path}' \
        2>/dev/null | /usr/bin/awk -F'|' -v p="$path" '$2 == p {print $1; exit}'
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

# ── error/info helpers ────────────────────────────────────────────────────────

_wt_err()  { echo "❌ $*" >&2 }
_wt_ok()   { echo "✅ $*" }
_wt_info() { echo "ℹ️  $*" }
_wt_warn() { echo "⚠️  $*" }

# ── subcommands ───────────────────────────────────────────────────────────────

_wt_help() {
    cat << 'EOF'
wt — worktree workspace manager

USAGE
  wt <command> [args]

COMMANDS

  Repo management
    wt repo register <name> <path>    Register a repo (path = agents dir)
    wt repo unregister <name>         Unregister a repo
    wt repo list                      List registered repos

  Worktree setup
    wt init <url> <root-dir>          Clone repo into worktree structure
                                        Creates <root-dir>/master/ + <root-dir>/agents/
    wt convert <dir>                  Convert existing repo to worktree structure
                                        Moves <dir> contents into <dir>/master/
                                        Creates <dir>/agents/

  Worktree management
    wt new  [repo] [count]            Create N agent worktrees (default: 1)
                                        Creates agents/agent-NNN + branch agent/NNN
                                        Omit repo to auto-detect from current directory
    wt rm   <repo>-<num>              Remove one worktree + branch
                                        e.g. wt rm myrepo-3
    wt rm   <repo>                    Remove ALL worktrees for a repo
    wt list [repo]                    List all worktrees (optionally filter by repo)
    wt sync [repo]                    Pull master + rebase all agent worktrees
                                        Omit repo to auto-detect from current directory
    wt sync <repo>-<num>              Pull master + rebase specific agent worktree
                                        e.g. wt sync afm-3
    wt close [repo-num]               Close tmux window for a worktree
                                        Omit arg to auto-detect from current directory
                                        e.g. wt close afm-1

  Workspace switching (tmux)
    wt <repo> "<title>"               Open tmux window on next unused agent worktree
    wt <repo>-<num> "<title>"         Open tmux window on specific agent worktree
                                        e.g. wt myrepo-3 "Fix auth bug"
    wt <repo>-<num>                   Reopen with saved title (no title needed)

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
  ~/.wt/repos   Repo registry (managed by wt repo new/rm)

EOF
}

_wt_repo_register() {
    local name="$1" agents_dir="$2"
    if [[ -z "$name" || -z "$agents_dir" ]]; then
        _wt_err "Usage: wt repo register <name> <agents-dir>"
        return 1
    fi
    agents_dir="${agents_dir:A}"  # resolve to absolute path
    _wt_ensure_config
    if _wt_repos | /usr/bin/awk '{print $1}' | grep -qx "$name"; then
        _wt_err "Repo '$name' is already registered."
        _wt_info "Use 'wt repo rm $name' first if you want to update it."
        return 1
    fi
    # Create agents dir if it doesn't exist yet
    if [[ ! -d "$agents_dir" ]]; then
        mkdir -p "$agents_dir"
        _wt_ok "Created agents dir: $agents_dir"
    fi
    echo "${name}  ${agents_dir}" >> "$WT_REPOS_FILE"
    _wt_ok "Registered repo '$name' → $agents_dir"
}

_wt_repo_unregister() {
    local name="$1"
    if [[ -z "$name" ]]; then
        _wt_err "Usage: wt repo unregister <name>"
        return 1
    fi
    _wt_ensure_config
    if ! _wt_repos | /usr/bin/awk '{print $1}' | grep -qx "$name"; then
        _wt_err "Repo '$name' not found in registry."
        return 1
    fi
    # Remove the line (portable sed)
    local tmpfile="${WT_REPOS_FILE}.tmp"
    grep -v "^${name}[[:space:]]" "$WT_REPOS_FILE" > "$tmpfile" && mv "$tmpfile" "$WT_REPOS_FILE"
    _wt_ok "Removed repo '$name' from registry."
}

_wt_repo_list() {
    _wt_ensure_config
    local repos
    repos=$(_wt_repos)
    if [[ -z "$repos" ]]; then
        _wt_info "No repos registered. Use 'wt repo new <name> <agents-dir>'."
        return 0
    fi
    printf "%-20s %s\n" "NAME" "AGENTS DIR"
    printf "%-20s %s\n" "----" "----------"
    echo "$repos" | while read -r name agents_dir; do
        local count=0
        [[ -d "$agents_dir" ]] && count=$(ls -d "${agents_dir}"/agent-*(N) 2>/dev/null | wc -l | tr -d ' ')
        printf "%-20s %s  (%s worktrees)\n" "$name" "$agents_dir" "$count"
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
        while read -r name agents_dir_candidate; do
            local root="${agents_dir_candidate:h}"  # parent of agents/ = repo root
            if [[ "$cwd" == "$root"* ]]; then
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

    local agents_dir
    agents_dir=$(_wt_agents_dir "$repo")
    if [[ -z "$agents_dir" ]]; then
        _wt_err "Repo '$repo' not registered."
        echo "  Run: wt repo new $repo <agents-dir>"
        return 1
    fi
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
        # Must be a plain repo name
        local repo="$arg"
        local agents_dir
        agents_dir=$(_wt_agents_dir "$repo")
        if [[ -z "$agents_dir" ]]; then
            _wt_err "Repo '$repo' not registered. Did you mean wt rm <repo>-<num>?"
            return 1
        fi
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

    # Single worktree: repo-num
    local repo="${match[1]}" num
    num=$(_wt_pad "${match[2]}")
    local agents_dir
    agents_dir=$(_wt_agents_dir "$repo")
    if [[ -z "$agents_dir" ]]; then
        _wt_err "Repo '$repo' not registered."
        return 1
    fi

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
        _wt_info "No repos registered. Use 'wt repo new <name> <agents-dir>'."
        return 0
    fi

    printf "%-12s %-12s %-28s %-10s %s\n" "REPO" "AGENT" "BRANCH" "STATUS" "TMUX WINDOW"
    printf "%-12s %-12s %-28s %-10s %s\n" "----" "-----" "------" "------" "-----------"

    # Build pane→path map once (avoids subshell tmux calls inside loop)
    local pane_map
    pane_map=$(tmux list-panes -a -F '#{session_name}:#{window_index}|#{pane_current_path}' 2>/dev/null)

    local name agents_dir agent branch tmux_win wt_status wt_path
    while read -r name agents_dir; do
        [[ -n "$filter_repo" && "$name" != "$filter_repo" ]] && continue
        for wt_path in "${agents_dir}"/agent-*(N); do
            [[ ! -d "$wt_path" ]] && continue
            agent="${wt_path:t}"
            branch=$(git -C "$wt_path" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "(unknown)")
            # Truncate long branch names
            local branch_display="${branch:0:27}"
            [[ "${#branch}" -gt 27 ]] && branch_display="${branch:0:24}..."
            tmux_win=$(echo "$pane_map" | /usr/bin/awk -F'|' -v p="$wt_path" '$2 == p {print $1; exit}')
            wt_status="free"
            [[ -n "$tmux_win" ]] && wt_status="in use"
            printf "%-12s %-12s %-28s %-10s %s\n" \
                "$name" "$agent" "$branch_display" "$wt_status" "${tmux_win:-—}"
        done
    done <<< "$repos"
}

_wt_sync() {
    local arg="${1:-}"  # e.g. "afm" or "afm-3"

    local repo num

    # Auto-detect repo and target from cwd if no arg given
    if [[ -z "$arg" ]]; then
        local cwd="${PWD}"
        local detected_repo="" detected_num=""
        while read -r name agents_dir_candidate; do
            local root="${agents_dir_candidate:h}"
            if [[ "$cwd" == "$root"* ]]; then
                detected_repo="$name"
                # Check if we're inside a specific agent dir
                if [[ "$cwd" == "${agents_dir_candidate}/agent-"* ]]; then
                    # Extract agent number from path
                    local agent_dir="${cwd#${agents_dir_candidate}/}"
                    agent_dir="${agent_dir%%/*}"  # get agent-NNN part
                    detected_num="${agent_dir#agent-}"
                fi
                break
            fi
        done <<< "$(_wt_repos)"
        if [[ -z "$detected_repo" ]]; then
            _wt_err "Could not detect repo from current directory: $cwd"
            echo "  Usage: wt sync [repo] or wt sync <repo>-<num>"
            echo "  Or cd into a registered repo directory first."
            return 1
        fi
        if [[ -n "$detected_num" ]]; then
            _wt_info "Auto-detected: $detected_repo agent-${detected_num} (syncing this agent only)"
        else
            _wt_info "Auto-detected: $detected_repo master (syncing all agents)"
        fi
        repo="$detected_repo"
        num="$detected_num"
    elif [[ "$arg" =~ ^(.+)-([0-9]+)$ ]]; then
        repo="${match[1]}"
        num=$(_wt_pad "${match[2]}")
    else
        repo="$arg"
        num=""
    fi

    # Zero-pad num if set
    [[ -n "$num" ]] && num=$(_wt_pad "$num")

    local agents_dir
    agents_dir=$(_wt_agents_dir "$repo")
    if [[ -z "$agents_dir" ]]; then
        _wt_err "Repo '$repo' not registered."
        return 1
    fi
    local master_dir
    master_dir=$(_wt_master_dir "$agents_dir")
    if [[ ! -d "$master_dir" ]]; then
        _wt_err "master/ not found at: $master_dir"
        return 1
    fi

    local primary_branch
    primary_branch=$(_wt_primary_branch "$master_dir")

    # Step 1: update master
    echo "🔄 Updating master..."
    git -C "$master_dir" fetch origin 2>/dev/null || _wt_warn "Fetch failed."
    if git -C "$master_dir" pull --rebase origin "$primary_branch" 2>/dev/null; then
        _wt_ok "master is up to date"
    else
        _wt_warn "Could not pull master (no remote or conflict). Continuing with local master."
    fi

    # Step 2: rebase agent worktree(s)
    local targets=()
    if [[ -n "$num" ]]; then
        targets=("${agents_dir}/agent-${num}")
    else
        targets=("${agents_dir}"/agent-*(N))
    fi

    if [[ ${#targets[@]} -eq 0 ]]; then
        _wt_info "No agent worktrees found for '$repo'."
        return 0
    fi

    local wt_path branch rebase_base
    # Use origin/<branch> if available, otherwise local
    if git -C "$master_dir" rev-parse --verify "origin/${primary_branch}" &>/dev/null; then
        rebase_base="origin/${primary_branch}"
    else
        rebase_base="$primary_branch"
    fi

    for wt_path in "${targets[@]}"; do
        [[ ! -d "$wt_path" ]] && continue
        branch=$(git -C "$wt_path" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "?")
        echo "🔄 Rebasing ${wt_path:t} ($branch) onto $rebase_base..."
        if git -C "$wt_path" rebase "$rebase_base" 2>/dev/null; then
            _wt_ok "${wt_path:t} rebased"
        else
            _wt_warn "${wt_path:t}: rebase conflict — resolve manually in ${wt_path}"
            git -C "$wt_path" rebase --abort 2>/dev/null || true
        fi
    done
}

_wt_close() {
    local arg="${1:-}"

    # Auto-detect from cwd if no arg
    if [[ -z "$arg" ]]; then
        local cwd="${PWD}"
        local detected_repo="" detected_num=""
        while read -r name agents_dir_candidate; do
            local root="${agents_dir_candidate:h}"
            if [[ "$cwd" == "${agents_dir_candidate}/agent-"* ]]; then
                detected_repo="$name"
                local agent_dir="${cwd#${agents_dir_candidate}/}"
                agent_dir="${agent_dir%%/*}"
                detected_num="${agent_dir#agent-}"
                break
            fi
        done <<< "$(_wt_repos)"
        if [[ -z "$detected_repo" ]]; then
            _wt_err "Not inside a worktree directory. Usage: wt close <repo>-<num>"
            return 1
        fi
        arg="${detected_repo}-${detected_num}"
    fi

    if [[ ! "$arg" =~ ^(.+)-([0-9]+)$ ]]; then
        _wt_err "Usage: wt close <repo>-<num>  e.g. wt close afm-1"
        return 1
    fi
    local repo="${match[1]}" num
    num=$(_wt_pad "${match[2]}")

    local agents_dir wt_path tmux_win
    agents_dir=$(_wt_agents_dir "$repo")
    if [[ -z "$agents_dir" ]]; then
        _wt_err "Repo '$repo' not registered."
        return 1
    fi
    wt_path="${agents_dir}/agent-${num}"

    local pane_map
    pane_map=$(tmux list-panes -a -F '#{session_name}:#{window_index}|#{pane_current_path}' 2>/dev/null)
    tmux_win=$(echo "$pane_map" | /usr/bin/awk -F'|' -v p="$wt_path" '$2 == p {print $1; exit}')

    if [[ -z "$tmux_win" ]]; then
        _wt_info "No tmux window is currently using ${repo}-${num}."
        return 0
    fi

    tmux kill-window -t "$tmux_win" 2>/dev/null \
        && _wt_ok "Closed tmux window '$tmux_win' (${repo} agent-${num})" \
        || _wt_err "Failed to close window '$tmux_win'"
}

_wt_open() {
    local arg="$1" title="$2"

    # If no title given and arg is repo-num, try to load saved title
    if [[ -z "$title" && "$arg" =~ ^(.+)-([0-9]+)$ ]]; then
        local saved_key="${match[1]}-$(( 10#$(_wt_pad ${match[2]}) ))"
        title=$(_wt_load_title "$saved_key")
        if [[ -z "$title" ]]; then
            _wt_err "No saved title for '$arg'. Provide a title:"
            echo "  wt $arg \"My Task\""
            return 1
        fi
        _wt_info "Reopening '$arg' with saved title: $title"
    elif [[ -z "$title" ]]; then
        _wt_err "A workspace title is required."
        echo "  Usage: wt <repo> \"<title>\""
        echo "         wt <repo>-<num> \"<title>\""
        return 1
    fi

    if [[ -z "${TMUX:-}" ]]; then
        _wt_err "Not inside a tmux session. Start tmux first."
        return 1
    fi

    local repo num wt_path

    # Check if arg is <repo>-<num> format
    if [[ "$arg" =~ ^(.+)-([0-9]+)$ ]]; then
        repo="${match[1]}"
        num=$(_wt_pad "${match[2]}")
        local agents_dir
        agents_dir=$(_wt_agents_dir "$repo")
        if [[ -z "$agents_dir" ]]; then
            _wt_err "Repo '$repo' not registered."
            return 1
        fi
        wt_path="${agents_dir}/agent-${num}"
        if [[ ! -d "$wt_path" ]]; then
            _wt_err "Worktree not found: $wt_path"
            echo "  Run: wt new $repo"
            return 1
        fi
    else
        # Auto-pick next unused agent worktree for this repo
        repo="$arg"
        local agents_dir
        agents_dir=$(_wt_agents_dir "$repo")
        if [[ -z "$agents_dir" ]]; then
            _wt_err "Repo '$repo' not registered."
            echo "  Run: wt repo new $repo <agents-dir>"
            return 1
        fi
        if [[ ! -d "$agents_dir" ]]; then
            _wt_err "Agents dir does not exist: $agents_dir"
            echo "  Run 'wt init' or 'wt convert' first, then 'wt new $repo'."
            return 1
        fi

        # Find next unused worktree
        local pane_map_open
        pane_map_open=$(tmux list-panes -a -F '#{session_name}:#{window_index}|#{pane_current_path}' 2>/dev/null)
        wt_path=""
        for candidate in "${agents_dir}"/agent-*(N); do
            [[ ! -d "$candidate" ]] && continue
            local in_use
            in_use=$(echo "$pane_map_open" | /usr/bin/awk -F'|' -v p="$candidate" '$2 == p {print $1; exit}')
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

    local agent_short=$(( 10#${wt_path:t:s/agent-//} ))
    local window_name="${repo}-${agent_short}: ${title}"

    _wt_save_title "${repo}-${agent_short}" "$title"

    # Focus existing window if already open
    local pane_map existing_win
    pane_map=$(tmux list-panes -a -F '#{session_name}:#{window_index}|#{pane_current_path}' 2>/dev/null)
    existing_win=$(echo "$pane_map" | /usr/bin/awk -F'|' -v p="$wt_path" '$2 == p {print $1; exit}')
    if [[ -n "$existing_win" ]]; then
        tmux switch-client -t "$existing_win" 2>/dev/null || tmux select-window -t "$existing_win" 2>/dev/null
        _wt_info "Focused existing window '${existing_win}' for ${repo}-${agent_short}"
        return 0
    fi

    local session
    session=$(tmux display-message -p '#{session_name}')
    tmux new-window -n "$window_name" -c "$wt_path"

    # Create triptych layout
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
        close)   _wt_close   "${@:2}" ;;
        *)
            _wt_open "$cmd" "${2:-}"
            ;;
    esac
}
