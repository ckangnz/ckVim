# ckVim Setup Guide

A comprehensive development environment setup with Neovim, Zsh, and essential tools.

## Quick Start

### 1. Clone this project into `~/.vim`

```bash
git clone https://github.com/ckangnz/ckVim.git ~/.vim
cd ~/.vim
```

### 2. Run interactive setup

```bash
make all
```

This will show an interactive menu where you can select which components to install:

- **brew** - Homebrew package manager (pre-selected)
- **vim** - Vim/Neovim configuration (pre-selected)
- **zsh** - Zsh shell with plugins (pre-selected)
- **others** - Additional tools (optional)

Use **1-4** to toggle selections, **a** to select/deselect all, **Enter** to confirm.

> **Note:** You can press **Ctrl+C** at any time to stop the installation.

---

## Manual Installation

You can also install components individually:

### Install Homebrew only

```bash
make brew
```

### Install Vim/Neovim

> [!WARNING]
> This will override your existing `.vimrc` file

**Includes:** Neovim, Vim, Python3, Node, FZF, Ripgrep, and more

```bash
make vim
```

### Install Zsh configuration

> [!WARNING]
> This will override your existing `.zshrc` file

**Includes:** Zsh, Tmux, Zap plugin manager, Powerlevel10k theme, and essential CLI tools

```bash
make zsh
```

After installation, restart your terminal and configure Powerlevel10k:

```bash
p10k configure
```

### Install additional tools (These are for macOS)

**Includes:** Docker, Arc Browser, Kitty terminal, Rectangle, and more (macOS only)

```bash
make others
```

### Create symlinks only

```bash
make symlink        # All symlinks
make vim_symlink    # Vim/Neovim symlinks only
make zsh_symlink    # Zsh/Tmux/Kitty symlinks only
```

### Reset environment

Remove all symlinks:

```bash
make reset
```

---

## Prerequisites

### For Linux (WSL/Ubuntu)

Install essential build tools:

```bash
# Debian/Ubuntu
sudo apt-get update && sudo apt-get install build-essential

# Arch Linux (SteamOS)
sudo steamos-readonly disable
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman -Syu
sudo pacman -S --noconfirm base-devel glibc linux-api-headers
sudo steamos-readonly enable
```

### For WSL

Enable Hyper-V on Windows:

1. Open "Turn Windows features on or off"
2. Find Hyper-V and enable it
3. Restart your computer

Install Nerd Font:

- Download [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases)
- Configure your terminal to use the font

---

## Project Structure

```
~/.vim/
├── Makefile              # Main installation orchestrator
├── scripts/              # Installation scripts
│   ├── interactive_menu.sh   # Interactive target selection
│   ├── install_methods.sh    # Shared installation functions
│   ├── install_vim.sh        # Vim/Neovim setup
│   ├── install_zsh.sh        # Zsh setup
│   └── install_others.sh     # Additional tools setup
├── .vimrc                # Vim configuration
├── .zshrc                # Zsh configuration
├── .config/
│   ├── nvim/             # Neovim configuration
│   ├── tmux/             # Tmux configuration
│   ├── kitty/            # Kitty terminal configuration
│   └── lazygit/          # LazyGit configuration
└── notes/                # Documentation and notes
```

---

## Features

### Vim/Neovim

- Modern Neovim configuration with LSP support
- Vim fallback configuration
- Custom keybindings and plugins
- File explorer and fuzzy finder

### Zsh

- Zap plugin manager
- Powerlevel10k theme
- Syntax highlighting and autosuggestions
- Git integration
- Custom aliases and functions

### Additional Tools

- **tmux** - Terminal multiplexer
- **kitty** - GPU-accelerated terminal
- **lazygit** - Terminal UI for git
- **lazydocker** - Terminal UI for docker
- **fzf** - Fuzzy finder
- **ripgrep** - Fast grep alternative
- **bat** - Cat alternative with syntax highlighting
- **lsd** - Modern ls alternative

---

## Troubleshooting

- **zsh compinit: insecure directories**

  ```bash
  compaudit | xargs chmod g-w
  ```

- **Node.js issues**

  ```bash
  npm install -g neovim
  ```

- **Python issues**

  ```bash
  $(which python3) -m pip install pynvim
  ```

- **Update C# language server**

  ```bash
  dotnet tool update -g csharp-ls
  ```

- **FNM Error 13 permission denied**

  ```bash
  sudo chown -R $(whoami) /run/user/1000/
  ```

- **GitHub Projects v2 permission error**

  ```bash
  gh auth refresh -s read:project
  ```

- **WSL clipboard issues**

  ```powershell
  choco install win32yank
  ```

- **Linux clipboard issues**

  ```bash
  sudo pacman -S xsel
  ```

- **WSL Docker completions error**
  ```bash
  # Remove symlink
  sudo rm -rf /usr/share/zsh/vendor-completions/_docker
  # Copy WSL completions
  sudo cp /mnt/wsl/docker-desktop/cli-tools/usr/share/zsh/vendor-completions/_docker /usr/share/zsh/vendor-completions/
  # Make it read-only
  sudo chattr +i /usr/share/zsh/vendor-completions/_docker
  ```

---

## Available Make Targets

Run `make help` to see all available targets:

```bash
make help
```

**Main targets:**

- `make all` - Interactive installation menu
- `make vim` - Install Vim/Neovim
- `make zsh` - Install Zsh configuration
- `make others` - Install additional tools
- `make brew` - Install Homebrew
- `make fonts` - Install Nerd Fonts
- `make symlink` - Create all symlinks
- `make reset` - Remove all symlinks
- `make help` - Show help message

---

## Contributing

Feel free to submit issues and pull requests!

## License

MIT License - feel free to use and modify as needed.
