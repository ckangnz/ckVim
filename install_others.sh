# Load install methods
. ./install_methods.sh --source-only

echo "LET'S INSTALL CK-OTHERS!!!!!!!"
echo ""

# Install Homebrew packages
packages=(
	"meetingbar"
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
	"dotnet-sdk"
	# sudo apt update && sudo apt install dotnet dotnet8 # :For Ubuntu
	# "dotnet-sdk9:isen-ng/dotnet-sdk-versions"

	"kitty"
	"arc"
	"docker"
	"itsycal"
	"rectangle"
	"maccy"
	"hiddenbar"
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
