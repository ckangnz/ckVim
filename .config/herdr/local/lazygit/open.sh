#!/bin/sh

set -eu

herdr_bin=${HERDR_BIN_PATH:-herdr}
cwd=$(printf '%s' "$HERDR_PLUGIN_CONTEXT_JSON" | jq -er '.focused_pane_cwd // .workspace_cwd')
open_result=$("$herdr_bin" plugin pane open \
  --plugin ck.lazygit \
  --entrypoint lazygit \
  --placement tab \
  --workspace "$HERDR_WORKSPACE_ID" \
  --cwd "$cwd" \
  --focus)
tab_id=$(printf '%s\n' "$open_result" | jq -er '.result.plugin_pane.pane.tab_id')

"$herdr_bin" tab rename "$tab_id" lazygit
