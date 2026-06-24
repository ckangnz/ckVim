#!/usr/bin/env bash
# Map a codex/claude lifecycle event to the tmux status engine.
# Usage: agent-tmux-hook.sh <event> [label]

set -uo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
API="$DIR/agent-status.sh"
[[ -x "$API" ]] || exit 0

EVENT="${1:-}"
LABEL="${2:-Agent}"

set_status() {
	bash "$API" set "$1" >/dev/null 2>&1 || true
}

notify() {
	bash "$API" notify "$1" >/dev/null 2>&1 || true
}

case "$EVENT" in
	SessionStart | SessionEnd | on_session_start)
		set_status ""
		;;
	UserPromptSubmit | PreToolUse | SubagentStart | on_user_prompt | on_tool_start)
		set_status "🟡"
		;;
	Stop | SubagentStop | on_complete)
		set_status "🟢"
		notify "$LABEL: Ready"
		;;
	PermissionRequest | Notification | on_tool_permission)
		set_status "❗"
		notify "$LABEL: Needs your input"
		;;
	on_error)
		set_status "❗"
		notify "$LABEL: Error occurred"
		;;
esac

exit 0
