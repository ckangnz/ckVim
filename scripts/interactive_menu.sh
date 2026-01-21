#!/bin/bash

# Interactive menu for selecting make targets
# Used by 'make all' command

# ANSI color codes
CYAN='\033[1;36m'
GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
GRAY='\033[0;90m'
BLUE='\033[1;34m'
RESET='\033[0m'

sel_brew=1
sel_vim=1
sel_zsh=1
sel_others=0

while true; do
	clear > /dev/tty
	echo -e "${CYAN}╔════════════════════════════════════════════╗${RESET}" > /dev/tty
	echo -e "${CYAN}║${RESET}    ${BLUE}Select Make Targets to Run${RESET}              ${CYAN}║${RESET}" > /dev/tty
	echo -e "${CYAN}╚════════════════════════════════════════════╝${RESET}" > /dev/tty
	echo "" > /dev/tty
	[ $sel_brew -eq 1 ] && echo -e "  ${GREEN}[1]${RESET} ${GREEN}◉${RESET} ${GREEN}brew${RESET}" > /dev/tty || echo -e "  ${GRAY}[1]${RESET} ${GRAY}○${RESET} ${GRAY}brew${RESET}" > /dev/tty
	[ $sel_vim -eq 1 ] && echo -e "  ${GREEN}[2]${RESET} ${GREEN}◉${RESET} ${GREEN}vim${RESET}" > /dev/tty || echo -e "  ${GRAY}[2]${RESET} ${GRAY}○${RESET} ${GRAY}vim${RESET}" > /dev/tty
	[ $sel_zsh -eq 1 ] && echo -e "  ${GREEN}[3]${RESET} ${GREEN}◉${RESET} ${GREEN}zsh${RESET}" > /dev/tty || echo -e "  ${GRAY}[3]${RESET} ${GRAY}○${RESET} ${GRAY}zsh${RESET}" > /dev/tty
	[ $sel_others -eq 1 ] && echo -e "  ${GREEN}[4]${RESET} ${GREEN}◉${RESET} ${GREEN}others${RESET}" > /dev/tty || echo -e "  ${GRAY}[4]${RESET} ${GRAY}○${RESET} ${GRAY}others${RESET}" > /dev/tty
	echo "" > /dev/tty
	echo -e "${CYAN}────────────────────────────────────────────${RESET}" > /dev/tty
	echo -e "${YELLOW}Press 1-4 to toggle, a for all, Enter to confirm${RESET}" > /dev/tty
	echo -e "${CYAN}────────────────────────────────────────────${RESET}" > /dev/tty
	read -n1 -r input < /dev/tty
	echo "" > /dev/tty
	case "$input" in
		1) sel_brew=$((1 - sel_brew)) ;;
		2) sel_vim=$((1 - sel_vim)) ;;
		3) sel_zsh=$((1 - sel_zsh)) ;;
		4) sel_others=$((1 - sel_others)) ;;
		a|A)
			if [ $sel_brew -eq 1 ] && [ $sel_vim -eq 1 ] && [ $sel_zsh -eq 1 ] && [ $sel_others -eq 1 ]; then
				sel_brew=0; sel_vim=0; sel_zsh=0; sel_others=0
			else
				sel_brew=1; sel_vim=1; sel_zsh=1; sel_others=1
			fi
			;;
		"") break ;;
	esac
done

clear > /dev/tty

# Build list of selected targets
run_targets=""
[ $sel_brew -eq 1 ] && run_targets="$run_targets brew"
[ $sel_vim -eq 1 ] && run_targets="$run_targets vim"
[ $sel_zsh -eq 1 ] && run_targets="$run_targets zsh"
[ $sel_others -eq 1 ] && run_targets="$run_targets others"

if [ -z "$run_targets" ]; then
	echo -e "${RED}No targets selected. Exiting.${RESET}" > /dev/tty
	exit 0
fi

echo -e "${GREEN}✓ Running:${RESET}${BLUE}$run_targets${RESET}" > /dev/tty
echo "" > /dev/tty

# Return the selected targets (space-separated)
echo "$run_targets"
