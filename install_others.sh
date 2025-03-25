# Load install methods
. ./install_methods.sh --source-only

# Define optional cask packages (name:tap)
cask_packages=(
  "neovide"
  "iterm2"
  "postman"
  "postman-agent"
  "docker"
  "itsycal"
  "rectangle"
  "maccy"
  "hiddenbar"
  #"azure-data-studio"
  #"session-manager-plugin"
  #"microsoft-remote-desktop"
)
for cask in "${cask_packages[@]}"; do
  brew_install_cask "$cask"
done
