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
shellArgs : [ '-c', 'cd ~ && zsh'],
shell: ' C:\\Windows\\System32\\bash.exe'
updateChannel: 'stable',
...
fontFamily: '"Terminess Powerline", "Anonymice Powerline", "Roboto Mono for Powerline", "Meslo LG S for Powerline", "DejaVu Sans Mono", "Lucida Console", "Pomodoro", "FontAwesome", "Octicons", "Icomoon", monospace',
...
colors : {
 black: '#546d79', red: '#ff5151', green: '#69f0ad', yellow: '#ffd73f', blue: '#40c4fe', magenta: '#ff3f80', cyan: '#64fcda', white: '#fefefe', lightBlack: '#b0bec4', lightRed: '#ff8680', lightGreen: '#b9f6c9', lightYellow: '#ffe47e', lightBlue: '#80d7fe', lightMagenta: 'ff80ad', lightCyan: '#a7fdeb', lightWhite: '#fefefe',
 }
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
pip install virtualenvwrapper

# Create virtualenvwrapper.sh clone to proper location
ln -s ~//.local/bin/virtualwrapper.sh /usr/local/bin/virtualenvwrapper.sh
ln -s ~//.local/bin/virtualenv /usr/local/bin/virtualenv
```

## Install Ack / Silversearcher
```bash
sudo apt-get install silversearcher-ag ack-grep
```
