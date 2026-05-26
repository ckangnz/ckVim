#!/usr/bin/env bash
# agent-dashboard.sh — fzf dashboard for all AI agent panes in tmux
# Shows panes running acli/rovodev, codex, gemini, or claude
# Enter to focus the selected pane

set -uo pipefail


_get_branch() {
    local path="$1"
    git -C "$path" symbolic-ref --short HEAD 2>/dev/null \
        || git -C "$path" rev-parse --short HEAD 2>/dev/null \
        || echo "?"
}

_get_status_icon() {
    local pane_id="$1" wname="$2"
    local icon
    icon=$(tmux show-options -pqv -t "$pane_id" @agent_status 2>/dev/null || true)
    if [[ -z "$icon" ]]; then
        if   [[ "$wname" == *"🟡"* ]]; then icon="🟡"
        elif [[ "$wname" == *"🟢"* ]]; then icon="🟢"
        elif [[ "$wname" == *"❗"* ]];  then icon="❗"
        elif [[ "$wname" == *"🔵"* ]]; then icon="🔵"
        elif [[ "$wname" == *"🟣"* ]]; then icon="🟣"
        fi
    fi
    case "$icon" in
        🟡) echo "🟡 working" ;;
        🟢) echo "🟢 done"    ;;
        ❗)  echo "❗ error"   ;;
        🔵) echo "🔵 waiting" ;;
        🟣) echo "🟣 paused"  ;;
        *)   echo "⚪ idle"    ;;
    esac
}

_get_ai_name() {
    local cmd="$1"
    case "$cmd" in
        acli*|*rovodev*) echo "rovodev" ;;
        codex*)          echo "codex"   ;;
        gemini*)         echo "gemini"  ;;
        claude*)         echo "claude"  ;;
        node*)           echo "node/ai" ;;
        *)               echo "$cmd"    ;;
    esac
}


_build_rows() {
    # list-panes fields: pane_id, pane_current_command, pane_current_path, window_name, window_index, pane_index
    while IFS='|' read -r pane_id cmd path wname widx pidx; do
        case "$cmd" in
            acli*|*rovodev*|codex*|gemini*|claude*) ;;
            *) continue ;;
        esac

        local branch ai_name status_str label
        branch=$(_get_branch "$path")
        ai_name=$(_get_ai_name "$cmd")
        status_str=$(_get_status_icon "$pane_id" "$wname")

        # Columns: AI, Branch, Status (no session:win)
        label=$(printf "%-10s  %-30s  %s" \
            "$ai_name" \
            "$branch" \
            "$status_str")

        printf '%s\t%s\n' "$pane_id" "$label"
    done < <(tmux list-panes -a \
        -F '#{pane_id}|#{pane_current_command}|#{pane_current_path}|#{window_name}|#{window_index}|#{pane_index}' \
        2>/dev/null)
}

_run_dashboard() {
    local rows
    rows=$(_build_rows)

    if [[ -z "$rows" ]]; then
        tmux display-message "No AI agent panes found"
        return
    fi

    local header
    header=$(printf "%-10s  %-30s  %s" "AI" "Branch" "Status")

    local -a fzf_args=(
        --exit-0
        --reverse
        --delimiter=$'\t'
        --with-nth=2..
        --no-sort
        --header="$header"
        --input-border
        --input-label=' Search '
        --info=inline-right
        --list-border
        --list-label=' AI Agents '
    )

    local selected
    selected=$(printf '%s\n' "$rows" | fzf "${fzf_args[@]}")

    local pane_id
    pane_id=$(printf '%s' "$selected" | awk -F'\t' '{print $1}')
    [[ -z "$pane_id" ]] && return

    # Switch to the pane's window, then select the pane
    local target_sess target_win
    target_sess=$(tmux display-message -p -t "$pane_id" '#{session_name}' 2>/dev/null)
    target_win=$(tmux display-message -p -t "$pane_id" '#{window_index}' 2>/dev/null)

    tmux switch-client -t "${target_sess}:${target_win}"
    tmux select-pane -t "$pane_id"
}

_run_dashboard
