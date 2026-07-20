#!/usr/bin/env zsh
# ~/.vim/wt/wt.zsh
# wt — ephemeral worktree workspace manager
#
# Thin ergonomic layer over `git worktree` + tmux + an APFS cp -c warm-seed.
# Every registered repo is a plain git clone. Create per-feature worktrees on
# demand and remove them when merged (vanilla git worktree; no "agents" layout).
# `git worktree list` is the source of truth, so wt also sees worktrees created
# by other tools (e.g. Claude Code's .claude/worktrees/).
#
# Config: ~/.wt/repos  (auto-created on first use)
# Source this file from ~/.zshrc:
#   source "$HOME/.vim/wt/wt.zsh"

# ── config ────────────────────────────────────────────────────────────────────

: ${WT_CONFIG_DIR:="${HOME}/.wt"}
: ${WT_REPOS_FILE:="${WT_CONFIG_DIR}/repos"}
: ${WT_DEFAULT_SEEDS:="node_modules,.yarn"}

# ── error/info helpers ──────────────────────────────────────────────────────────

_wt_err()  { echo "❌ $*" >&2 }
_wt_ok()   { echo "✅ $*" }
_wt_info() { echo "ℹ️  $*" }
_wt_warn() { echo "⚠️  $*" }

# ── registry ────────────────────────────────────────────────────────────────────

_wt_ensure_config() {
    [[ -d "$WT_CONFIG_DIR" ]] || mkdir -p "$WT_CONFIG_DIR"
    if [[ ! -f "$WT_REPOS_FILE" ]]; then
        cat > "$WT_REPOS_FILE" << 'EOF'
# ~/.wt/repos — wt repo registry
# Format: <name> <path> <kind> [seed-globs-csv]
#   <path>          a plain git clone
#   <kind>          vestigial ("repo"); older single/worktree values still parse
#   seed-globs-csv  dirs to cp -c warm-seed into new worktrees, default: node_modules,.yarn
#
# Managed by: wt register / wt unregister
EOF
    fi
}

# Emit: <name> <path> <kind> <seeds>  (defaults applied; kind kept for column shape only)
_wt_repos() {
    _wt_ensure_config
    /usr/bin/awk -v ds="$WT_DEFAULT_SEEDS" \
        '!/^[[:space:]]*#/ && !/^[[:space:]]*$/ {
            kind = ($3 == "" ? "repo" : $3)
            seeds = ($4 == "" ? ds : $4)
            print $1, $2, kind, seeds
        }' "$WT_REPOS_FILE"
}

_wt_field()        { _wt_repos | /usr/bin/awk -v n="$1" -v f="$2" '$1 == n {print $f; exit}' }
_wt_repo_seeds()   { _wt_field "$1" 4 }
_wt_repo_rawpath() { _wt_field "$1" 2 }
_wt_is_repo()      { _wt_repos | /usr/bin/awk -v n="$1" '$1 == n {f=1} END {exit !f}' }

# Resolve a repo's main clone. Auto-maps a legacy ".../agents" entry to its
# sibling ".../master" so old registrations keep working.
_wt_clone_path() {
    local p; p=$(_wt_repo_rawpath "$1")
    [[ -z "$p" ]] && return 1
    if [[ "${p:t}" == "agents" && -d "${p:h}/master" ]]; then
        echo "${p:h}/master"
    else
        echo "$p"
    fi
}

# ── git worktree helpers ─────────────────────────────────────────────────────────

_wt_primary_branch() {
    local dir="$1"
    if git -C "$dir" rev-parse --verify main &>/dev/null; then
        echo "main"
    else
        echo "master"
    fi
}

# Emit "<path>\t<branch>" for each real worktree of a clone (skips the bare entry).
_wt_worktrees() {
    local clone="$1"
    git -C "$clone" worktree list --porcelain </dev/null 2>/dev/null | /usr/bin/awk '
        /^worktree /{ path=substr($0,10); branch=""; bare=0 }
        /^bare/     { bare=1 }
        /^branch /  { branch=substr($0,8); sub(/^refs\/heads\//,"",branch) }
        /^detached/ { branch="(detached)" }
        /^$/        { if (path!="" && !bare) print path"\t"branch; path=""; branch=""; bare=0 }
        END         { if (path!="" && !bare) print path"\t"branch }
    '
}

# Echo the worktree path for an id. Accepts the forms shown by `wt list`:
#   <basename>            e.g. agent-002
#   <repo>/<basename>     e.g. afm/agent-002
_wt_resolve_target() {
    local id="$1" name rp kind seeds clone p b wtl
    while read -r name rp kind seeds; do
        clone=$(_wt_clone_path "$name") || continue
        wtl=$(_wt_worktrees "$clone")
        while IFS=$'\t' read -r p b; do
            [[ -z "$p" ]] && continue
            [[ "${p:t}" == "$id" || "${name}/${p:t}" == "$id" ]] && { print -r -- "$p"; return 0 }
        done <<< "$wtl"
    done <<< "$(_wt_repos)"
    return 1
}

# Echo "<clone>\t<name>" for the repo that owns a given worktree path.
_wt_owner_of_path() {
    local target="$1" name rp kind seeds clone p b wtl
    while read -r name rp kind seeds; do
        clone=$(_wt_clone_path "$name") || continue
        wtl=$(_wt_worktrees "$clone")
        while IFS=$'\t' read -r p b; do
            [[ -z "$p" ]] && continue
            [[ "$p" == "$target" ]] && { print -r -- "$clone"$'\t'"$name"; return 0 }
        done <<< "$wtl"
    done <<< "$(_wt_repos)"
    return 1
}

# "Feature Title!" → "feature-title"
_wt_slugify() {
    local s="${(L)1}"
    s="${s//[^a-z0-9]/-}"
    while [[ "$s" == *--* ]]; do s="${s//--/-}"; done
    s="${s#-}"; s="${s%-}"
    print -r -- "$s"
}

# ── warm-seed (APFS cp -c, background) ───────────────────────────────────────────

_wt_seed_run() {
    local clone="$1" wt="$2"; shift 2
    local g d
    for g in "$@"; do
        if [[ "$g" == "node_modules" ]]; then
            (cd "$clone" && find . -type d -name node_modules -prune 2>/dev/null) | while IFS= read -r d; do
                mkdir -p "$wt/${d:h}" 2>/dev/null
                cp -cR "$clone/$d" "$wt/$d" 2>/dev/null
            done
        elif [[ -e "$clone/$g" ]]; then
            [[ "${g:h}" != "." ]] && mkdir -p "$wt/${g:h}" 2>/dev/null
            cp -cR "$clone/$g" "$wt/$g" 2>/dev/null
        fi
    done
}

_wt_start_seed() {
    local clone="$1" wt="$2"; shift 2
    local -a globs=("$@")
    local label="${wt:t}"
    (
        _wt_seed_run "$clone" "$wt" "${globs[@]}"
        rm -f "$wt/.wt-seeding" 2>/dev/null
        : > "$wt/.wt-ready" 2>/dev/null
        tmux display-message "wt: warm-seed ready — ${label}" 2>/dev/null
    ) &!
    echo "$!" > "$wt/.wt-seeding" 2>/dev/null
}

_wt_kill_seed() {
    local wt="$1"
    [[ -f "$wt/.wt-seeding" ]] || return 0
    local spid; spid=$(cat "$wt/.wt-seeding" 2>/dev/null)
    if [[ -n "$spid" ]]; then
        pkill -9 -P "$spid" 2>/dev/null
        kill -9 "$spid" 2>/dev/null
    fi
    pkill -9 -f "cp -cR.*${wt}/" 2>/dev/null
    sleep 1
    rm -f "$wt/.wt-seeding" 2>/dev/null
}

# ── tmux layout ──────────────────────────────────────────────────────────────────

_wt_window_for_path() {
    local p="$1"
    tmux list-panes -a -F '#{session_name}:#{window_index}|#{pane_current_path}' 2>/dev/null \
        | /usr/bin/awk -F'|' -v p="$p" '$2 == p {print $1; exit}'
}

_wt_panes_for_path() {
    local p="$1"
    tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index}|#{pane_current_path}' 2>/dev/null \
        | /usr/bin/awk -F'|' -v p="$p" '$2 == p {print $1}'
}

_wt_create_layout() {
    local cwd="$1"
    tmux split-window -v -p 30 -c "$cwd"
    tmux select-pane -t top
    tmux split-window -h -p 50 -c "$cwd"
    tmux select-pane -t top-left
}

_wt_layout() {
    [[ -z "$TMUX" ]] && { _wt_err "Not running inside tmux."; return 1 }
    local panes; panes=$(tmux display-message -p '#{window_panes}')
    if [[ "$panes" -gt 1 ]]; then
        _wt_warn "Current window has ${panes} panes — refusing to overwrite layout."
        return 1
    fi
    _wt_create_layout "$(tmux display-message -p '#{pane_current_path}')"
}

_wt_window_name() {
    local repo="$1" branch="$2"
    [[ -z "$branch" ]] && echo "$repo" || echo "${repo}: ${branch}"
}

# ── subcommands ──────────────────────────────────────────────────────────────────

_wt_help() {
    cat << 'EOF'
wt — ephemeral worktree workspace manager

USAGE
  wt <command> [args]

REGISTRY
  wt register <name> <path> [--seed a,b]   Register a repo (a plain git clone)
  wt unregister <name>                     Unregister a repo

WORKSPACES
  wt <repo> "Feature title"   Create (or focus) a feature worktree:
                                git worktree add + background warm-seed + single-pane tmux window
  wt <repo>                   Open/focus the repo's main workspace (the clone itself)

  Single-use repos: just don't create worktrees — use branches in the main clone.
  You still CAN `wt <repo> "title"` on any repo; it uses vanilla `git worktree`.

MANAGE
  wt list [repo]              List worktrees (from `git worktree list`) + status
  wt open                     fzf-select a worktree → cd the current pane into it
  wt open --tab               fzf-select → open it in a new named tab instead
                                (bind `prefix C-o` to a popup running `wt open --tab`)
  wt rm                       Remove the worktree you're in (cwd)
  wt rm <repo> <id>           Remove a worktree of <repo> (tab-completes ids)
  wt rm <repo> --all          Remove all merged worktrees of <repo>
  wt rm ... --force | -f      Also remove unmerged worktrees
  wt close                    Close the current tmux window
  wt layout                   Apply the triptych layout to the current window

  wt help | --help            Show this help

Rebase a worktree with plain git (e.g. gfom && grbom). There is no `wt sync`.
EOF
}

_wt_register() {
    local seeds="$WT_DEFAULT_SEEDS"
    local -a pos=()
    while (( $# )); do
        case "$1" in
            --seed) shift; seeds="${1:-}" ;;
            *)      pos+=("$1") ;;
        esac
        shift
    done
    local name="${pos[1]:-}" p="${pos[2]:-}"
    if [[ -z "$name" || -z "$p" ]]; then
        _wt_err "Usage: wt register <name> <path> [--seed a,b]"
        return 1
    fi
    p="${p:A}"
    _wt_ensure_config
    if _wt_is_repo "$name"; then
        _wt_err "Repo '$name' already registered. Use 'wt unregister $name' first."
        return 1
    fi
    if [[ ! -d "$p" ]]; then
        _wt_err "Path does not exist: $p"
        return 1
    fi
    if [[ ! ( -d "$p/.git" || -f "$p/.git" ) ]]; then
        _wt_err "Not a git repo: $p"
        return 1
    fi
    echo "${name}  ${p}  repo  ${seeds}" >> "$WT_REPOS_FILE"
    _wt_ok "Registered '$name' → $p"
    _wt_info "Worktrees (optional): wt ${name} \"Title\"  →  ${p:h}/${name}-<slug>   seed: ${seeds}"
    return 0
}

_wt_unregister() {
    local name="$1"
    [[ -z "$name" ]] && { _wt_err "Usage: wt unregister <name>"; return 1 }
    _wt_ensure_config
    if ! _wt_is_repo "$name"; then
        _wt_err "Repo '$name' not found in registry."
        return 1
    fi
    local tmp="${WT_REPOS_FILE}.tmp"
    /usr/bin/awk -v n="$name" '$1 != n' "$WT_REPOS_FILE" > "$tmp" && mv "$tmp" "$WT_REPOS_FILE"
    _wt_ok "Unregistered '$name'."
}

_wt_open() {
    local arg="$1"
    local title_given=0 title=""
    (( $# >= 2 )) && { title_given=1; title="$2" }

    [[ -z "$TMUX" ]] && { _wt_err "Not inside a tmux session. Start tmux first."; return 1 }

    if ! _wt_is_repo "$arg"; then
        _wt_err "Repo '$arg' not registered."
        echo "  Run: wt register $arg <path>"
        return 1
    fi

    local clone; clone=$(_wt_clone_path "$arg") || { _wt_err "No clone path for '$arg'."; return 1 }
    if [[ ! ( -d "$clone/.git" || -f "$clone/.git" ) ]]; then
        _wt_err "Main clone is not a git repo: $clone"
        return 1
    fi

    local target_path id window_name slug="" branch
    if (( ! title_given )); then
        target_path="$clone"; id="$arg"
        branch=$(git -C "$target_path" rev-parse --abbrev-ref HEAD 2>/dev/null)
        window_name=$(_wt_window_name "$arg" "$branch")
    else
        slug=$(_wt_slugify "$title")
        [[ -z "$slug" ]] && { _wt_err "Could not derive a slug from '$title'."; return 1 }
        target_path="${clone:h}/${arg}-${slug}"; id="${arg}-${slug}"
        window_name=$(_wt_window_name "$arg" "$slug")

        if [[ ! -d "$target_path" ]]; then
            # Open the tab first, then run the slow `git worktree add` + seed INSIDE it,
            # so the current pane returns immediately instead of blocking on the checkout.
            tmux new-window -a -n "$window_name" -c "$clone"
            local newwin; newwin=$(tmux display-message -p '#{session_name}:#{window_index}')
            tmux send-keys -t "$newwin" "wt _create ${(q)arg} ${(q)slug} ${(q)title}" Enter
            _wt_ok "Opening '${window_name}' — worktree checkout + warm-seed run in that tab."
            return 0
        fi
    fi

    # Existing worktree, or the repo's main workspace: focus or open (instant).
    local existing_win; existing_win=$(_wt_window_for_path "$target_path")
    if [[ -n "$existing_win" ]]; then
        (( title_given )) && tmux rename-window -t "$existing_win" "$window_name" 2>/dev/null
        tmux switch-client -t "$existing_win" 2>/dev/null || tmux select-window -t "$existing_win" 2>/dev/null
        _wt_info "Focused existing window '${existing_win}' for ${id}"
        return 0
    fi

    tmux new-window -a -n "$window_name" -c "$target_path"
    _wt_ok "Opened '${window_name}' [$(git -C "$target_path" rev-parse --abbrev-ref HEAD 2>/dev/null)]"
}

# Internal: runs inside the freshly-opened tab to do the checkout + seed.
_wt__create() {
    local repo="$1" slug="$2" title="${3:-}"
    local clone; clone=$(_wt_clone_path "$repo") || { _wt_err "Unknown repo '$repo'."; return 1 }
    local target="${clone:h}/${repo}-${slug}"
    if [[ ! -d "$target" ]]; then
        local primary base
        primary=$(_wt_primary_branch "$clone")
        if git -C "$clone" rev-parse --verify "origin/${primary}" &>/dev/null; then
            base="origin/${primary}"
        else
            base="$primary"
        fi
        echo "📁 Creating worktree ${repo}-${slug}  (branch: ${slug}, base: ${base})"
        git -C "$clone" worktree add "$target" -b "$slug" "$base" \
            || { _wt_err "git worktree add failed."; return 1 }
        _wt_start_seed "$clone" "$target" ${(s:,:)$(_wt_repo_seeds "$repo")}
        _wt_ok "Worktree ready. Warm-seed (node_modules, …) running in background."
    fi
    cd "$target"
}

# Remove one worktree by path (guard + kill seed + close window + prune branch).
_wt_rm_path() {
    local clone="$1" wt="$2" force="$3"
    if [[ "$wt" == "$clone" ]]; then
        _wt_err "Refusing to remove the main clone: $wt"
        return 1
    fi
    local branch; branch=$(git -C "$wt" rev-parse --abbrev-ref HEAD 2>/dev/null)

    if [[ "$force" != "1" ]]; then
        local primary base
        primary=$(_wt_primary_branch "$clone")
        base="origin/${primary}"
        git -C "$clone" rev-parse --verify "$base" &>/dev/null || base="$primary"
        local dirty; dirty=$(git -C "$wt" status --porcelain --untracked-files=no 2>/dev/null | head -1)
        local unmerged=0
        [[ -n "$dirty" ]] && unmerged=1
        git -C "$wt" merge-base --is-ancestor HEAD "$base" 2>/dev/null || unmerged=1
        if (( unmerged )); then
            local ahead; ahead=$(git -C "$wt" rev-list --count "${base}..HEAD" 2>/dev/null)
            _wt_warn "'${wt:t}' has unmerged work (${ahead:-?} commit(s) ahead of ${base}$([[ -n $dirty ]] && echo ', uncommitted changes')."
            echo "   Branch: ${branch}"
            echo "   Not removed. Push/merge first, or re-run with --force to discard."
            return 1
        fi
    fi

    _wt_info "Stopping warm-seed for ${wt:t}..."
    _wt_kill_seed "$wt"
    local -a panes=()
    local pane; while IFS= read -r pane; do
        [[ -n "$pane" ]] && panes+=("$pane")
    done <<< "$(_wt_panes_for_path "$wt")"

    _wt_info "Deleting worktree ${wt:t}..."
    git -C "$clone" worktree remove --force "$wt" 2>/dev/null || rm -rf "$wt"
    if [[ -n "$branch" && "$branch" != "HEAD" ]]; then
        _wt_info "Deleting branch ${branch}..."
        git -C "$clone" branch -D "$branch" 2>/dev/null
    fi
    _wt_ok "Removed ${wt:t} (branch: ${branch:-?})"
    if (( ${#panes} )); then
        _wt_info "Closing ${#panes} tmux pane(s) for ${wt:t}..."
        for pane in "${panes[@]}"; do
            tmux kill-pane -t "$pane" 2>/dev/null
        done
    fi
}

_wt_rm() {
    local force=0 all=0
    local -a rest=()
    local a
    for a in "$@"; do
        case "$a" in
            --force|-f) force=1 ;;
            --all)      all=1 ;;
            *)          rest+=("$a") ;;
        esac
    done
    local repo="${rest[1]:-}" wtid="${rest[2]:-}"

    # No positionals and not --all: remove the worktree you're in (cwd).
    if (( ! all )) && [[ -z "$repo" ]]; then
        local top; top=$(git -C "$PWD" rev-parse --show-toplevel 2>/dev/null)
        [[ -z "$top" ]] && { _wt_err "Not inside a git worktree. Usage: wt rm <repo> <id> | wt rm <repo> --all"; return 1 }
        local owner; owner=$(_wt_owner_of_path "$top") \
            || { _wt_err "'$top' is not a registered wt worktree."; return 1 }
        local clone="${owner%%$'\t'*}"
        [[ "$top" == "$clone" ]] && { _wt_err "That's the main clone — not removable."; return 1 }
        _wt_rm_path "$clone" "$top" "$force" && git -C "$clone" worktree prune 2>/dev/null
        return
    fi

    # First positional is not a registered repo → treat it as a worktree id (or repo/id).
    if [[ -n "$repo" ]] && ! _wt_is_repo "$repo"; then
        local wtp; wtp=$(_wt_resolve_target "$repo") \
            || { _wt_err "'$repo' is not a registered repo or a worktree id."
                 echo "  Usage: wt rm <repo> <id> | wt rm <repo> --all | wt rm  (inside a worktree)"
                 return 1 }
        local owner; owner=$(_wt_owner_of_path "$wtp"); local clone="${owner%%$'\t'*}"
        _wt_rm_path "$clone" "$wtp" "$force" && git -C "$clone" worktree prune 2>/dev/null
        return
    fi

    [[ -z "$repo" ]] && { _wt_err "Usage: wt rm <repo> <id> | wt rm <repo> --all"; return 1 }
    local clone; clone=$(_wt_clone_path "$repo")

    # wt rm <repo> --all  → remove all feature worktrees (merged; --force also unmerged)
    if (( all )); then
        local -a wts=()
        local p b wtl; wtl=$(_wt_worktrees "$clone")
        while IFS=$'\t' read -r p b; do
            [[ -z "$p" || "$p" == "$clone" ]] && continue
            wts+=("$p")
        done <<< "$wtl"
        (( ${#wts} == 0 )) && { _wt_info "No feature worktrees for '$repo'."; return 0 }
        echo "🗑  Removing ${#wts} worktree(s) for '$repo'$( (( force )) && echo ' (force)' ):"
        printf '   %s\n' "${wts[@]:t}"
        echo -n "   Continue? [y/N] "; read -r a
        [[ "$a" != "y" && "$a" != "Y" ]] && { echo "Aborted."; return 0 }
        for p in "${wts[@]}"; do _wt_rm_path "$clone" "$p" "$force"; done
        git -C "$clone" worktree prune 2>/dev/null
        return 0
    fi

    # wt rm <repo> <id>
    [[ -z "$wtid" ]] && { _wt_err "Usage: wt rm $repo <worktree-id>  (tab-completes)  |  wt rm $repo --all"; return 1 }
    local wtp="" p b wtl; wtl=$(_wt_worktrees "$clone")
    while IFS=$'\t' read -r p b; do
        [[ -z "$p" || "$p" == "$clone" ]] && continue
        [[ "${p:t}" == "$wtid" || "${repo}/${p:t}" == "$wtid" ]] && { wtp="$p"; break }
    done <<< "$wtl"
    [[ -z "$wtp" ]] && { _wt_err "No worktree '$wtid' in '$repo'. See: wt list $repo"; return 1 }
    _wt_rm_path "$clone" "$wtp" "$force"
    git -C "$clone" worktree prune 2>/dev/null
}

_wt_close() {
    [[ -z "$TMUX" ]] && { _wt_err "Not inside a tmux session."; return 1 }
    local cur; cur=$(tmux display-message -p '#{session_name}:#{window_index}')
    tmux kill-window -t "$cur" 2>/dev/null \
        && _wt_ok "Closed current window '${cur}'" \
        || _wt_err "Failed to close window '${cur}'"
}

_wt_list() {
    local filter="$1"
    _wt_ensure_config
    local repos; repos=$(_wt_repos)
    [[ -z "$repos" ]] && { _wt_info "No repos registered. Use 'wt register <name> <path>'."; return 0 }

    local pane_map; pane_map=$(tmux list-panes -a -F '#{session_name}:#{window_index}|#{pane_current_path}' 2>/dev/null)
    printf "%-24s %-28s %s\n" "WORKSPACE" "BRANCH" "STATUS"
    printf "%-24s %-28s %s\n" "---------" "------" "------"

    local name rp kind seeds clone p b tag win st wtl
    while read -r name rp kind seeds; do
        [[ -n "$filter" && "$name" != "$filter" ]] && continue
        clone=$(_wt_clone_path "$name") || continue
        wtl=$(_wt_worktrees "$clone")
        while IFS=$'\t' read -r p b; do
            [[ -z "$p" ]] && continue
            if [[ "$p" == "$clone" ]]; then
                tag="${name} (main)"
            else
                tag="${name}/${p:t}"
            fi
            win=$(echo "$pane_map" | /usr/bin/awk -F'|' -v x="$p" '$2 == x {print $1; exit}')
            st=""
            [[ -n "$win" ]] && st="in tmux"
            [[ -f "$p/.wt-seeding" ]] && st="${st:+$st, }seeding"
            [[ -f "$p/.wt-ready" ]]   && st="${st:+$st, }warm"
            printf "%-24s %-28s %s\n" "${tag:0:24}" "${b:0:28}" "$st"
        done <<< "$wtl"
    done <<< "$repos"
}

_wt_open_pick() {
    # Default: cd the current pane into the chosen worktree (works because wt is a
    # sourced function). --tab: open it in a new named tab instead — used by the
    # tmux popup binding, which runs wt as a subprocess that can't cd the pane.
    local mode="cd"
    [[ "$1" == "--tab" || "$1" == "-t" ]] && mode="tab"
    command -v fzf >/dev/null 2>&1 || { _wt_err "fzf not found"; return 1 }
    local rows=() name rp kind seeds clone p b tag st wtl
    while read -r name rp kind seeds; do
        clone=$(_wt_clone_path "$name") || continue
        wtl=$(_wt_worktrees "$clone")
        while IFS=$'\t' read -r p b; do
            [[ -z "$p" ]] && continue
            [[ "$p" == "$clone" ]] && tag="${name} (main)" || tag="${name}/${p:t}"
            st="wt"
            [[ -f "$p/.wt-seeding" ]] && st="seeding"
            [[ -f "$p/.wt-ready" ]]   && st="warm"
            rows+=("$p"$'\t'"$(printf '%-24s %-6s %s' "${tag:0:24}" "$st" "$b")")
        done <<< "$wtl"
    done <<< "$(_wt_repos)"

    (( ${#rows} == 0 )) && { _wt_info "No worktrees registered."; return 0 }

    local sel
    sel=$(printf '%s\n' "${rows[@]}" \
        | fzf --reverse --exit-0 --no-multi \
              --delimiter=$'\t' --with-nth=2 \
              --header="$(printf '%-24s %-6s %s' 'WORKSPACE' 'STATE' 'BRANCH')")
    [[ -z "$sel" ]] && return 0
    local dir="${sel%%$'\t'*}"

    if [[ "$mode" != "tab" || -z "$TMUX" ]]; then
        cd "$dir" && _wt_ok "cd → $dir"
        return
    fi
    # --tab: focus the worktree's window if it already has one, else open a new named tab.
    local existing; existing=$(_wt_window_for_path "$dir")
    if [[ -n "$existing" ]]; then
        tmux select-window -t "$existing" 2>/dev/null
        tmux switch-client -t "$existing" 2>/dev/null
        return 0
    fi
    local owner; owner=$(_wt_owner_of_path "$dir")
    local repo="${owner##*$'\t'}"
    tmux new-window -a -n "$(_wt_window_name "$repo" "$b")" -c "$dir"
}

# ── main entrypoint ──────────────────────────────────────────────────────────────

wt() {
    local cmd="${1:-}"
    case "$cmd" in
        --help|-h|help|"")     _wt_help ;;
        register)              _wt_register   "${@:2}" ;;
        unregister)            _wt_unregister "${@:2}" ;;
        init)                  _wt_register   "${@:2}" ;;   # alias
        uninit)                _wt_unregister "${@:2}" ;;   # alias
        list)                  _wt_list       "${@:2}" ;;
        rm)                    _wt_rm         "${@:2}" ;;
        close)                 _wt_close      "${@:2}" ;;
        layout)                _wt_layout     "${@:2}" ;;
        open|search|pick)      _wt_open_pick  "${@:2}" ;;
        _create)               _wt__create    "${@:2}" ;;
        new|sync|clean|convert|repo)
            _wt_err "'wt $cmd' was removed in the ephemeral redesign."
            echo "  Worktrees are created per-feature (wt <repo> \"title\") and"
            echo "  rebased with plain git (gfom && grbom). See: wt --help"
            return 1 ;;
        *)                     _wt_open       "$cmd" "${@:2}" ;;
    esac
}
