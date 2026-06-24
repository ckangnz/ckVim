#!/usr/bin/env bash
# Idempotently wire agent-tmux-hook.sh into codex (~/.codex/hooks.json) and
# claude (~/.claude/settings.json), preserving any existing hooks. Rovo Dev is
# left to ~/dotfiles.

set -uo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v python3 >/dev/null 2>&1; then
	echo "install-agent-hooks: python3 not found; skipping" >&2
	exit 0
fi

chmod +x "$DIR/agent-tmux-hook.sh" "$DIR/agent-status.sh" 2>/dev/null || true

HOOK="~/.vim/.config/tmux/scripts/agent-tmux-hook.sh"

CODEX_FILE="$HOME/.codex/hooks.json"
CLAUDE_FILE="$HOME/.claude/settings.json"

HOOK="$HOOK" CODEX_FILE="$CODEX_FILE" CLAUDE_FILE="$CLAUDE_FILE" python3 - <<'PY'
import json, os

HOOK = os.environ["HOOK"]
CODEX_FILE = os.environ["CODEX_FILE"]
CLAUDE_FILE = os.environ["CLAUDE_FILE"]

OURS = "agent-tmux-hook.sh"
STALE = ("hooks/tmux-hooks.sh",)


def load(path):
    try:
        with open(path) as f:
            data = json.load(f)
            return data if isinstance(data, dict) else {}
    except (FileNotFoundError, json.JSONDecodeError, ValueError):
        return {}


def group_commands(group):
    for h in (group or {}).get("hooks", []):
        if isinstance(h, dict) and "command" in h:
            yield h["command"]


def is_managed(group):
    for cmd in group_commands(group):
        if OURS in cmd or any(s in cmd for s in STALE):
            return True
    return False


def merge(path, label, events):
    data = load(path)
    hooks = data.setdefault("hooks", {})
    for event in events:
        groups = hooks.get(event, [])
        if not isinstance(groups, list):
            groups = []
        kept = [g for g in groups if not is_managed(g)]
        kept.append({
            "hooks": [{
                "type": "command",
                "command": f"{HOOK} {event} {label}",
            }]
        })
        hooks[event] = kept
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        json.dump(data, f, indent=2)
        f.write("\n")


codex_events = [
    "SessionStart",
    "UserPromptSubmit",
    "PreToolUse",
    "SubagentStart",
    "Stop",
    "SubagentStop",
    "PermissionRequest",
]

claude_events = [
    "SessionStart",
    "UserPromptSubmit",
    "PreToolUse",
    "Notification",
    "Stop",
    "SessionEnd",
]

merge(CODEX_FILE, "Codex", codex_events)
print(f"✓ codex  -> {CODEX_FILE}")

merge(CLAUDE_FILE, "Claude", claude_events)
print(f"✓ claude -> {CLAUDE_FILE}")
PY

echo "✓ agent tmux hooks installed (script: $HOOK)"
