#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default values
default_bind_key='s'
default_preview_pane='true'
default_fzf_window_position='center,70%,80%'
default_fzf_preview_window_position='right,,,nowrap'
default_tmux_list_panes_format='pane_id session_name window_name pane_title pane_current_command'

# User overridable options
tmux_bind_key="@fzf_pane_switch_bind-key"
tmux_preview_pane="@fzf_pane_switch_preview-pane"
tmux_fzf_window_position="@fzf_pane_switch_window-position"
tmux_fzf_preview_window_position="@fzf_pane_switch_preview-pane-position"
tmux_list_panes_format="@fzf_pane_switch_list-panes-format"

get_tmux_option() {
    local option="${1}"
    local default_value="${2}"
    local option_override
    option_override="$(tmux show-option -gqv "${option}")"
    if [ -z "${option_override}" ]; then
        echo "${default_value}"
    else
        echo "${option_override}"
    fi
}

set_switch_pane_bindings() {
    local bind_key preview_pane fzf_window_position fzf_preview_window_position list_panes_format
    bind_key="$(get_tmux_option "${tmux_bind_key}" "${default_bind_key}")"
    preview_pane="$(get_tmux_option "${tmux_preview_pane}" "${default_preview_pane}")"
    fzf_window_position="$(get_tmux_option "${tmux_fzf_window_position}" "${default_fzf_window_position}")"
    fzf_preview_window_position="$(get_tmux_option "${tmux_fzf_preview_window_position}" "${default_fzf_preview_window_position}")"
    list_panes_format="$(get_tmux_option "${tmux_list_panes_format}" "${default_tmux_list_panes_format}")"

    tmux bind-key "${bind_key}" run-shell \
        "'${CURRENT_DIR}/fzf-pane-switch.sh' '${preview_pane}' '${fzf_window_position}' '${fzf_preview_window_position}' \"${list_panes_format}\""
}

set_switch_pane_bindings
