#!/usr/bin/env bash
# This script uses fzf to display a list of panes and allows you to select one.
#
# If you press ENTER, it switches to the selected pane.
# If you press ENTER on an empty line, it creates a new window in the current session.
# If you press ESC, the modal closes without switching panes.
function select_pane() {
    local border_styling="" fzf_version_comparison
    local current_pane pane pane_id preview

    # Save the currently active pane ID
    current_pane=$(tmux display-message -p '#{pane_id}')

    # Setup border styling
    # Specific fzf releases have added additional styling options.
    fzf_version=$(fzf --version | awk '{print $1}')
    # - 0.58.0 or later, we can enable border styling
    vercomp '0.58.0' "${fzf_version}"
    fzf_version_comparison=$?
    if [[ ${fzf_version_comparison} -ne 1 ]]; then
        border_styling+=" --input-border --input-label=' Search ' --info=inline-right"
        border_styling+=" --list-border --list-label=' Panes '"
        border_styling+=" --preview-border --preview-label=' Preview '"
    fi
    # - 0.61.0 or later, we can enable ghost text
    vercomp '0.61.0' "${fzf_version}"
    fzf_version_comparison=$?
    if [[ ${fzf_version_comparison} -ne 1 ]]; then
        border_styling+=" --ghost 'type to search...'"
    fi
    # Fallback to old border styling used in tmux-fzf-pane-switch release v1.1.2 if $border_styling is not set
    if [[ -z ${border_styling+x} ]]; then
        border_styling="--preview-label='pane preview'"
    fi

    # Check if we're using the fzf preview pane
    if [[ "${1}" = 'true' ]]; then
        preview="--preview 'sh ~/.config/tmux/scripts/fzf-pane-preview.sh {1} \${FZF_PREVIEW_LINES:-30}'"
        preview+=" --preview-window=${3}"
    fi

    # Launch switcher
    # NOTE: --print-query is intentionally omitted here. With --print-query, fzf always
    # writes at least one line (the query string) to stdout even on ESC, which caused
    # the modal to reopen. Without it, ESC produces no output and the script exits cleanly.
    #
    # Tmux format string uses TAB (\t) between fields so window names with spaces stay
    # in a single column. We then pipe through awk to pad each column to the widest
    # value (so columns line up visually), keeping TAB as the in-row separator. fzf
    # delimits on TAB, hides field 1 (pane_id used internally), and only matches/searches
    # against the visible fields (2..).
    pane=$(tmux list-windows -aF "${4}" \
        | awk -F'\t' '
            {
                # field layout: window_id, session_index, session_name, window_index, window_name
                for (i=1; i<=NF; i++) { rows[NR,i]=$i; if (length($i) > w[i]) w[i]=length($i) }
                nf=NF
            }
            END {
                cur_session = ""
                for (r=1; r<=NR; r++) {
                    sess = rows[r,3]
                    if (sess != cur_session) {
                        cur_session = sess
                        sess_idx = rows[r,2]
                        if (sess == sess_idx) {
                            printf "SESSION:%s\t── Session %s ──\n", sess, sess_idx
                        } else {
                            printf "SESSION:%s\t── Session %s: %s ──\n", sess, sess_idx, sess
                        }
                    }
                    # visible: window_index (col 4), window_name (col 5)
                    out = rows[r,1]
                    out = out "\t" sprintf("%-" w[4] "s", rows[r,4])
                    out = out "\t" rows[r,5]
                    print out
                }
            }' \
        | eval fzf --exit-0 --reverse --tmux "${2}" --delimiter="'\t'" --with-nth=2.. \
            --no-sort \
            "${border_styling}" "${preview}")

    # Set pane_id to first TAB-separated field of fzf output
    pane_id=$(printf '%s' "${pane}" | awk -F'\t' '{print $1}')

    # If pane_id is empty (ESC), exit
    if [[ -z "${pane_id}" ]]; then
        return
    # Session header selected — switch to that session's last active window
    elif [[ "${pane_id}" == SESSION:* ]]; then
        local sess_name="${pane_id#SESSION:}"
        tmux switch-client -t "${sess_name}"
    elif tmux display-message -t "${pane_id}" -p "" >/dev/null 2>&1; then
        tmux select-window -t "${pane_id}"
        tmux switch-client -t "${pane_id}"
    else
        tmux command-prompt -b -p "Press ENTER to create a new window in the current session [${pane}]" "new-window -n \"${pane}\""
    fi
}

function vercomp() {
  local v1="$1"
  local v2="$2"

  # Split each version string into arrays using '.' as the delimiter
  IFS='.' read -r -a ver1 <<< "$v1"
  IFS='.' read -r -a ver2 <<< "$v2"

  # Compare major, minor, and patch components one by one
  for i in 0 1 2; do
    # Default to 0 if a component is missing (e.g., "1.2" becomes "1.2.0")
    local num1="${ver1[i]:-0}"
    local num2="${ver2[i]:-0}"

    # Compare the numeric values of the current component
    if (( num1 > num2 )); then
      return 1  # First version is newer
    elif (( num1 < num2 )); then
      return 2  # First version is older
    fi
  done

  return 0  # Versions are equal
}

# Check for required commands
command -v tmux >/dev/null 2>&1 || { echo "tmux not found"; exit 1; }
command -v fzf >/dev/null 2>&1 || { echo "fzf not found"; exit 1; }

# Pane preview
preview_pane="${1}"
# FZF window position
fzf_window_position="${2}"
# FZF preview window position
fzf_preview_window_position="${3}"
# TMUX list-panes format
read -r -a list_panes_format_overrides <<< "${4}"
# Use TAB as the field separator so window names containing spaces stay in one column
list_panes_formatted_overrides=$(printf '#{%s}\t' "${list_panes_format_overrides[@]}")
list_panes_formatted_overrides="${list_panes_formatted_overrides%$'\t'}"

select_pane "${preview_pane}" "${fzf_window_position}" "${fzf_preview_window_position}" "#{window_id}	${list_panes_formatted_overrides}"
