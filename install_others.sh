# Load install methods
. ./install_methods.sh --source-only

echo "LET'S INSTALL CK-OTHERS!!!!!!!"
echo ""

# Install Homebrew packages
packages=(
  "lazydocker"
  # "awscli"
  # "kubectl"
  # "k9s"
  # "helm"
  # "tfenv" # Terraform with version control
  # "hashicorp/tap/terraform-ls"
)
echo "Installing brew packages..."
brew_install "${packages[@]}"
echo ""
echo ""

# Install Homebrew cask packages
cask_packages=(
  "dotnet-sdk" # sudo apt update && sudo apt install dotnet dotnet8
  "dotnet-sdk8:isen-ng/dotnet-sdk-versions"

  "iterm2"
  "docker"
  "itsycal"
  "rectangle"
  "maccy"
  # "postman-agent"
  #"azure-data-studio"
  #"session-manager-plugin"
  #"microsoft-remote-desktop"
)
echo "Installing brew cask packages..."
brew_install_cask "${cask_packages[@]}"

echo ""
echo ""
echo "DONE!"
