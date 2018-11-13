# How to install Terminal (Ubuntu) Environment to use ckVim

* Go to Control Panel => Programs => Turn Window Features On and Off
* Near the bottom, check Windows Subsystem for Linux (This will require reboot)
* Install Ubuntu from Microsoft Store
* Install hyper.js from https://hyper.js/

### Edit Hyper.js options
```js
plugins : [
  "hyper-material-theme",
]
...
shell: ' C:\\Windows\\System32\\bash.exe'
```

## Install Oh My Zsh
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

## Install nodejs
```bash
sudo apt install nodejs
```

## Install Python and Pip
```bash
sudo apt install python python3 python-pip python3-pip
```
