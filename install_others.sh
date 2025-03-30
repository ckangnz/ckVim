# Load install methods
. ./install_methods.sh --source-only

# Install Homebrew packages
packages=(
  "ducker"
  "awscli"
  "kubectl"
  "k9s"
  "helm"
  "tfenv" # Terraform with version control
  "hashicorp/tap/terraform-ls"
)
echo "Installing brew packages..."
brew_install "${packages[@]}"

echo ""
echo ""

# Install Homebrew cask packages
cask_packages=(
  "dotnet-sdk" # sudo apt update && sudo apt install dotnet8
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
brew_install_cask "${cask_packages[@]}"
