#!/bin/bash

# Interactive menu for selecting which "others" packages to install.
# Detects OS and shows the appropriate package manager label per item.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/install_methods.sh" --source-only

# ── Colors ──────────────────────────────────────────────────────────────────
CYAN='\033[1;36m'
GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
GRAY='\033[0;90m'
BLUE='\033[1;34m'
RESET='\033[0m'

# ── OS detection ─────────────────────────────────────────────────────────────
IS_MAC=0
IS_LINUX=0
[[ "$machine" == "Mac" ]] && IS_MAC=1
[[ "$machine" == "Linux" ]] && IS_LINUX=1

# ── Package definitions ───────────────────────────────────────────────────────
# Format per entry:
#   display_name | brew_pkg | cask_pkg | snap_pkg | apt_pkg
#
# Rules for label shown in the menu:
#   Mac:   cask_pkg set  → "name (cask)"
#          brew_pkg only → "name"
#   Linux: snap_pkg set  → "name (snap)"
#          apt_pkg  set  → "name (apt)"
#          brew_pkg only → "name"
#   A "-" means "not available on this platform / skip"
#
# Sorted: brew-only entries first (alphabetical), then cask/snap/apt (alphabetical).

PACKAGES=(
	# brew-only (alphabetical)
	"aws-cli|awscli|-|awscli|awscli"
	"helm|helm|-|helm|-"
	"k9s|k9s|-|k9s|-"
	"kubectl|kubectl|-|kubectl|kubectl"
	"meetingbar|meetingbar|-|-|-"

	# cask / snap / apt (alphabetical)
	"dia|-|thebrowsercompany-dia|-|-"
	"docker|-|docker|docker|-"
	"dotnet-sdk|-|dotnet-sdk|-|dotnet8"
	"hiddenbar|-|hiddenbar|-|-"
	"itsycal|-|itsycal|-|-"
	"kitty|-|kitty|kitty|kitty"
	"maccy|-|maccy|-|-"
	"rectangle|-|rectangle|-|-"
)

# ── Build the items list for the current OS ───────────────────────────────────
# Each element: "display_label|install_type|pkg_id"
# install_type: brew | cask | snap | apt | skip
ITEMS=()

for entry in "${PACKAGES[@]}"; do
	IFS="|" read -r display brew_pkg cask_pkg snap_pkg apt_pkg <<< "$entry"

	if [[ $IS_MAC -eq 1 ]]; then
		if [[ "$cask_pkg" != "-" ]]; then
			ITEMS+=("${display} (cask)|cask|${cask_pkg}")
		elif [[ "$brew_pkg" != "-" ]]; then
			ITEMS+=("${display}|brew|${brew_pkg}")
		fi
		# Mac-only items with no brew/cask: skip silently

	elif [[ $IS_LINUX -eq 1 ]]; then
		if [[ "$snap_pkg" != "-" ]]; then
			ITEMS+=("${display} (snap)|snap|${snap_pkg}")
		elif [[ "$apt_pkg" != "-" ]]; then
			ITEMS+=("${display} (apt)|apt|${apt_pkg}")
		elif [[ "$brew_pkg" != "-" ]]; then
			ITEMS+=("${display}|brew|${brew_pkg}")
		fi
		# Linux-only items with nothing: skip silently
	fi
done

TOTAL=${#ITEMS[@]}

if [[ $TOTAL -eq 0 ]]; then
	echo -e "${RED}No packages available for this platform.${RESET}" > /dev/tty
	exit 1
fi

# ── Selection state (all off by default) ─────────────────────────────────────
declare -a SELECTED
for ((i = 0; i < TOTAL; i++)); do
	SELECTED[$i]=0
done

# ── Draw menu ────────────────────────────────────────────────────────────────
draw_menu() {
	clear > /dev/tty
	echo -e "${CYAN}╔════════════════════════════════════════════╗${RESET}" > /dev/tty
	echo -e "${CYAN}║${RESET}    ${BLUE}Select packages to install${RESET}               ${CYAN}║${RESET}" > /dev/tty
	echo -e "${CYAN}╚════════════════════════════════════════════╝${RESET}" > /dev/tty
	echo "" > /dev/tty

	for ((i = 0; i < TOTAL; i++)); do
		local label="${ITEMS[$i]%%|*}"
		local num=$((i + 1))
		if [[ ${SELECTED[$i]} -eq 1 ]]; then
			echo -e "  ${GREEN}[$num]${RESET} ${GREEN}◉${RESET} ${GREEN}${label}${RESET}" > /dev/tty
		else
			echo -e "  ${GRAY}[$num]${RESET} ${GRAY}○${RESET} ${GRAY}${label}${RESET}" > /dev/tty
		fi
	done

	echo "" > /dev/tty
	echo -e "${CYAN}────────────────────────────────────────────${RESET}" > /dev/tty
	echo -e "${YELLOW}Press 1-${TOTAL} to toggle, a for all, Enter to confirm, q to quit${RESET}" > /dev/tty
	echo -e "${CYAN}────────────────────────────────────────────${RESET}" > /dev/tty
}

# ── Main loop ────────────────────────────────────────────────────────────────
while true; do
	draw_menu

	read -n1 -r input < /dev/tty
	echo "" > /dev/tty

	if [[ "$input" == "" ]]; then
		break
	elif [[ "$input" == "q" || "$input" == "Q" ]]; then
		clear > /dev/tty
		echo -e "${RED}✗ Quit.${RESET}" > /dev/tty
		exit 1
	elif [[ "$input" =~ ^[0-9]+$ ]] && ((input >= 1 && input <= TOTAL)); then
		idx=$((input - 1))
		SELECTED[$idx]=$(( 1 - SELECTED[$idx] ))
	elif [[ "$input" == "a" || "$input" == "A" ]]; then
		all_on=1
		for ((i = 0; i < TOTAL; i++)); do
			[[ ${SELECTED[$i]} -eq 0 ]] && all_on=0 && break
		done
		for ((i = 0; i < TOTAL; i++)); do
			SELECTED[$i]=$(( 1 - all_on ))
		done
	fi
done

clear > /dev/tty

# ── Collect selected items ────────────────────────────────────────────────────
brew_pkgs=()
cask_pkgs=()
snap_pkgs=()
apt_pkgs=()

for ((i = 0; i < TOTAL; i++)); do
	[[ ${SELECTED[$i]} -eq 0 ]] && continue
	IFS="|" read -r _label install_type pkg_id <<< "${ITEMS[$i]}"
	case "$install_type" in
		brew) brew_pkgs+=("$pkg_id") ;;
		cask) cask_pkgs+=("$pkg_id") ;;
		snap) snap_pkgs+=("$pkg_id") ;;
		apt)  apt_pkgs+=("$pkg_id") ;;
	esac
done

total_selected=$(( ${#brew_pkgs[@]} + ${#cask_pkgs[@]} + ${#snap_pkgs[@]} + ${#apt_pkgs[@]} ))

if [[ $total_selected -eq 0 ]]; then
	echo -e "${RED}✗ Nothing selected. Exiting.${RESET}" > /dev/tty
	exit 0
fi

echo -e "${GREEN}✓ Installing selected packages...${RESET}" > /dev/tty
echo "" > /dev/tty

# ── Install ───────────────────────────────────────────────────────────────────
if [[ ${#brew_pkgs[@]} -gt 0 ]]; then
	echo -e "${CYAN}── brew ─────────────────────────────────────${RESET}"
	brew_install "${brew_pkgs[@]}"
	echo ""
fi

if [[ ${#cask_pkgs[@]} -gt 0 ]]; then
	echo -e "${CYAN}── brew cask ────────────────────────────────${RESET}"
	brew_install_cask "${cask_pkgs[@]}"
	echo ""
fi

if [[ ${#snap_pkgs[@]} -gt 0 ]]; then
	echo -e "${CYAN}── snap ─────────────────────────────────────${RESET}"
	linux_install_snap "${snap_pkgs[@]}"
	echo ""
fi

if [[ ${#apt_pkgs[@]} -gt 0 ]]; then
	echo -e "${CYAN}── apt ──────────────────────────────────────${RESET}"
	linux_install_apt "${apt_pkgs[@]}"
	echo ""
fi

echo -e "${GREEN}DONE!${RESET}"
