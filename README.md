# Installation

## Install Homebrew

```bash
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then source it depending on your environment.

```bash
# For Mac
eval "$(/usr/lib/bin/brew shellenv)"

# For Mac ARM
echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> $HOME/.zprofile

# For WSL
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

## Clone this project into `~/.vim`

```bash
git clone https://github.com/chris542/ckVim ~/.vim
```

# Installing CK-NVIM

> [!NOTE]
> Pre-requisite for :penguin: Linux (WSL)

```bash
# You must install essential C Compilers

# Debian
sudo apt-get update && sudo apt-get install build-essential


# Archlinux (SteamOS especially)
sudo steamos-readoonly disable # enable once all packages are installed

sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman-key --populate holo

sudo pacman -Syu
sudo pacman -S --noconfirm base-devel glibc linux-api-headers # If you see an error regards to stdint.h
```

## Run the script

> [!WARNING]
> This will override your .vimrc file

```bash
make vim
```

---

# Installing CK-ZSH ⚡️

> [!NOTE]
>
> Pre-requisite (only :penguin: For WSL/Linux)
>
> Enabling Hyper V
>
> 1. Open "Turn Windows features on or off"
> 2. Find Hyper-V and enable it (This may require rebooting your computer)
>
> Font Setup
>
> - Manually download the FiraCode.zip from [here](https://github.com/ryanoasis/nerd-fonts/releases)
> - Configure the Terminal configuration with the font

## Run the script

> [!WARNING]
> This will override your .zshrc file

```bash
make zsh
```

Now you can restart your terminal!

## Configure your Powerlevel10k

Run following command to configure your powerlevel10k theme.
Avoid sourcing `~/.p10k.zsh` as it is already imported in `.zshrc`

```bash
#alias p10
p10k configure
```

---

# Setting up the working environment

## Install extra software on MacOS

```bash
make others
```

---

# Trouble-Shooting

- zsh compinit: insecure directories, run compaudit for list, run :

```bash
compaudit | xargs chmod g-w
```

- If you get node issue, install neovim via npm

```bash
npm install -g neovim
```

- If you get python issue, install pynvim via pip

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

- WSL Clipboards

```Powershell
choco install win32yank
```

- Linux Clipboards

```bash
sudo pacman -S xsel
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
