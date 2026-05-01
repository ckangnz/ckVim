#!/usr/bin/env bash
set -uo pipefail

SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"

_find_target() {
    local all_panes pid match
    all_panes=$(tmux list-panes -a -F '#{pane_pid} #{session_name}:#{window_index}' 2>/dev/null) || return 1
    pid="${PPID:-$$}"
    while [[ "$pid" -gt 1 ]]; do
        match=$(echo "$all_panes" | /usr/bin/awk -v p="$pid" '$1 == p {print $2; exit}')
        if [[ -n "$match" ]]; then
            echo "$match"
            return 0
        fi
        pid=$(ps -p "$pid" -o ppid= 2>/dev/null | tr -d ' ') || break
        [[ -z "$pid" ]] && break
    done
    return 1
}

_strip_icon() {
    local name="$1" prev=""
    while [[ "$name" != "$prev" ]]; do
        prev="$name"
        name="${name% 🟡}"
        name="${name% 🟢}"
        name="${name% ❗}"
        name="${name% 🔵}"
        name="${name% 🟣}"
    done
    printf '%s' "$name"
}

_target_is_focused() {
    local target="$1" s w hit
    s="${target%%:*}"
    w="${target##*:}"
    hit=$(tmux list-clients -F '#{client_session}|#{session_attached}|#{window_index}' 2>/dev/null \
          | /usr/bin/awk -F'|' -v s="$s" -v w="$w" \
              '$1 == s && $2+0 >= 1 && $3 == w { print "yes"; exit }')
    [[ "$hit" == "yes" ]]
}

_set_window() {
    local target="$1" icon="$2"
    local current bname new_name
    current=$(tmux display-message -p -t "$target" '#{window_name}' 2>/dev/null) || return 0
    [[ -z "$current" ]] && return 0
    bname=$(_strip_icon "$current")

    if [[ -n "$icon" ]]; then
        new_name="${bname} ${icon}"
    else
        new_name="$bname"
    fi

    tmux set-window-option -t "$target" automatic-rename off >/dev/null 2>&1 || true
    if [[ "$current" != "$new_name" ]]; then
        tmux rename-window -t "$target" "$new_name" >/dev/null 2>&1 || true
    fi
}

_install_hooks() {
    local cmd="run-shell -b 'bash \"${SELF}\" _on_focus'"
    local existing
    existing=$(tmux show-hooks -g 2>/dev/null || true)

    for hook in after-select-window client-attached session-window-changed; do
        if ! echo "$existing" | grep -q "${hook}.*agent-status.sh.*_on_focus"; then
            tmux set-hook -g "$hook" "$cmd" >/dev/null 2>&1 || true
        fi
    done
}

_on_focus() {
    while IFS='|' read -r sess attached idx wname; do
        [[ "$attached" -lt 1 ]] && continue
        clean=$(_strip_icon "$wname")
        if [[ "$wname" != "$clean" ]]; then
            tmux rename-window -t "${sess}:${idx}" "$clean" >/dev/null 2>&1 || true
        fi
    done < <(tmux list-clients -F '#{client_session}|#{session_attached}|#{window_index}|#{window_name}' 2>/dev/null || true)
}

cmd="${1:-}"
shift || true

case "$cmd" in
    set)
        icon="${1:-}"
        _install_hooks
        target=$(_find_target) || exit 0
        if [[ -z "$icon" ]]; then
            _set_window "$target" ""
        elif [[ "$icon" == "🟢" ]] && _target_is_focused "$target"; then
            _set_window "$target" ""
        else
            _set_window "$target" "$icon"
        fi
        ;;
    clear)
        _install_hooks
        target=$(_find_target) || exit 0
        _set_window "$target" ""
        ;;
    notify)
        title="${1:-Agent}"
        printf '\033]99;i=1:d=0;title=%s\007' "$title" 2>/dev/null || true
        ;;
    install-hooks)
        _install_hooks
        ;;
    _on_focus)
        _on_focus
        ;;
    *)
        echo "usage: $(basename "$0") {set <icon>|clear|notify <title>|install-hooks}" >&2
        echo "  set <icon>      set status icon on the calling pane's window" >&2
        echo "                  (special: 🟢 is suppressed if window already focused)" >&2
        echo "  clear           remove any status icon" >&2
        echo "  notify <title>  send OSC 99 bell notification" >&2
        echo "  install-hooks   register tmux focus hooks (auto-runs on set/clear)" >&2
        exit 2
        ;;
esac
