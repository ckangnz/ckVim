#!/bin/sh
target="$1"
lines="${2:-30}"

case "$target" in
    SESSION:*)
        sess="${target#SESSION:}"
        tmux list-windows -t "$sess" -F "  #{window_index}  #{window_name}" 2>/dev/null
        ;;
    *)
        tmux capture-pane -ep -S "-${lines}" -t "$target" 2>/dev/null \
            | awk '{a[NR]=$0} END{for(i=NR;i>0;i--) if(a[i]~/[^ \t]/){for(j=1;j<=i;j++) print a[j]; exit}}' \
            | tail -n "$lines"
        ;;
esac
