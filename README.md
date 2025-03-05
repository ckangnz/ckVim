# CK-NVim

> [!IMPORTANT]
> You need to install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Installing CK-NVIM

> [!NOTE] Pre-requisite for :penguin: Linux (WSL)

```bash
# You must install essential C Compilers
sudo apt-get update && sudo apt-get install build-essential

# Install dotnet8
sudo apt update && sudo apt install dotnet8
```

### 1. Clone this project into `~/.vim`

```bash
git clone https://github.com/chris542/ckVim ~/.vim
```

### 2. Install dependencies

> [!WARNING] This will override your .vimrc file

```bash
. ~/.vim/install.sh
```

### 3. Install extra software on MacOS

```bash
. ~/.vim/install_others.sh
```

---

# CK-ZSH ⚡️

> [!NOTE]
>
> #### Pre-requisite (only :penguin: For WSL/Linux)
>
> ##### Enabling Hyper V
>
> 1. Open "Turn Windows features on or off"
> 2. Find Hyper-V and enable it (This may require rebooting your comptuer)
>
> ##### Font Setup
>
> - Manually download the FiraCode.zip from [here](https://github.com/ryanoasis/nerd-fonts/releases)
> - Configure the Terminal configuration with the font

### Install Zsh if not installed

```bash
brew install zsh

# Set zsh as default
chsh -s $(which zsh)
```

### Install Zap (Zsh Plugin Manager)

> [!WARNING] This will create a new `.zshrc` and back up your old one.

```bash
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
```

### Link .zshrc

> [!WARNING] This will override your .zshrc file

```bash
rm $HOME/.zshrc
ln -s $HOME/.vim/.zshrc $HOME/.zshrc
source $HOME/.zshrc
```

Now you can restart your terminal!

## Configure your Powerlevel10k

Run following command to configure your powerlevel10k theme.
Avoid sourcing `~/.p10k.zsh` as it is already imported in `.zshrc`

```bash
#alias p10
p10k configure
```

## Trouble-Shooting

- zsh compinit: insecure directories, run compaudit for list, run :

```bash
compaudit | xargs chmod g-w
```

- If you get a prompt that brew is missing after installation, simply run this command

```bash
# For Mac
eval "$(/usr/lib/bin/brew shellenv)"

# For Mac ARM
echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> $HOME/.zprofile

# For WSL
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"]
```

- If you get python issue on nvim install pynvim

```bash
$(which python3) -m pip install pynvim
```

- Update csharp_ls time to time

```bash
dotnet tool update -g csharp-ls
```

- If you get FNM Error 13 permission denied

```bash
sudo chown -R $(whoami) /run/user/1000/
```

- If you get "Cannot request projects v2, missing scope 'read:project'" message, it means the gh credential does not have read:project auth. Run this command:

```bash
gh auth refresh -s read:project
```

- For WSL windows, install win32yank with choco to yank into clipboard

```Powershell
choco install win32yank
```

- For WSL windows, when you get `no such file or directory: /usr/share/zsh/vendor-completions/_docker` error, run:

```bash
# Remove symlink
sudo rm -rf /usr/share/zsh/vendor-completions/_docker
#copy over wsl completions
sudo cp /mnt/wsl/docker-desktop/cli-tools/usr/share/zsh/vendor-completions/_docker /usr/share/zsh/vendor-completions/
#make it non-writable
sudo chattr +i /usr/share/zsh/vendor-completions/_docker
```
