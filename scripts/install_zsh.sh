#!/bin/bash

set -eo pipefail

# Load install methods
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/install_methods.sh" --source-only
HERDR_DIR="$(cd "$SCRIPT_DIR/../.config/herdr" && pwd)"

ensure_herdr_plugin() {
	local plugin_id="$1"
	shift
	local plugin_info

	plugin_info=$(herdr plugin list --plugin "$plugin_id" --json)
	if ! printf '%s' "$plugin_info" | jq -e 'length > 0' >/dev/null; then
		echo "INSTALL: Herdr plugin $plugin_id..."
		"$@"
	elif printf '%s' "$plugin_info" | jq -e '.[0].enabled == true' >/dev/null; then
		echo "FOUND: Herdr plugin $plugin_id is already installed!"
	else
		echo "ENABLE: Herdr plugin $plugin_id..."
		herdr plugin enable "$plugin_id"
	fi
}

apply_reviewr_focus_patch() {
	local plugin_info
	local plugin_root
	local patch_file="$HERDR_DIR/patches/persiyanov.reviewr/focus-tab.patch"

	plugin_info=$(herdr plugin list --plugin persiyanov.reviewr --json)
	plugin_root=$(printf '%s' "$plugin_info" | jq -er '.[0].plugin_root')

	if git -C "$plugin_root" apply --reverse --check "$patch_file" >/dev/null 2>&1; then
		echo "FOUND: Herdr plugin patch focus-tab.patch"
	elif git -C "$plugin_root" apply --check "$patch_file" >/dev/null 2>&1; then
		git -C "$plugin_root" apply "$patch_file"
		echo "PATCH: Herdr plugin persiyanov.reviewr"
	else
		echo "ERROR: Reviewr focus patch cannot be applied: $patch_file" >&2
		exit 1
	fi
}

echo "LET'S INSTALL CKZSH!!!!!!!"
echo ""

# Ensure ~/.config exists
[ -d ~/.config ] || mkdir -p ~/.config

# Install Homebrew packages
packages=(
	"zsh"

	"python3"
	"node"
	"fnm"
	"uv"

	"gh"
	"bat"

	"fd"
	"ripgrep"
	"fzf"
	"jq"

	"lsd"

	"lazygit"
	"lazydocker"
	"herdr"
	"caffeine"

	"jannis-baum/tap/vivify"
)
echo "Installing brew packages..."
brew_install "${packages[@]}"
echo ""
echo ""

echo "Configuring Herdr plugins..."
ensure_herdr_plugin ck.lazygit herdr plugin link "$HERDR_DIR/local/lazygit" --enabled
ensure_herdr_plugin persiyanov.reviewr herdr plugin install persiyanov/herdr-reviewr --yes
apply_reviewr_focus_patch
ensure_herdr_plugin ray.plugin-manager herdr plugin install speardragon/herdr-plugin-manager --yes

if herdr status server >/dev/null 2>&1; then
	herdr server reload-config
fi

echo "Installing ZAP"
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1 -k
echo ""
echo ""

if [[ "$(basename "$SHELL")" != "zsh" ]]; then
	echo "Changing default shell to zsh..."
	chsh -s "$(which zsh)"
else
	echo "Default shell is already zsh."
fi

echo "."
echo "."
echo " ██████╗██╗  ██╗███████╗███████╗██╗  ██╗"
echo "██╔════╝██║ ██╔╝╚══███╔╝██╔════╝██║  ██║"
echo "██║     █████╔╝   ███╔╝ ███████╗███████║"
echo "██║     ██╔═██╗  ███╔╝  ╚════██║██╔══██║"
echo "╚██████╗██║  ██╗███████╗███████║██║  ██║"
echo " ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝"
echo "."
echo "."
echo "Installation Completed!!"
