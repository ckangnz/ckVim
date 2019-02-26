# Install Pyenv and Pyenv-virtualenvwrapper

```bash
brew install pyenv pyenv-virtualenvwrapper
```

### Include this in .zshrc :

```bash
eval "$(pyenv init -)"
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
export WORKON_HOME=$HOME/.virtualenvs
pyenv virtualenvwrapper_lazy
```

## Usage

* Install a new python version

```python
# List available python versions
pyenv install --list

# List already installed pythons
pyenv whence 2to3

# Install python version 3.6.0
pyenv install 3.6.0

# Install virtualenvwrapper for that python version
pyenv shell 3.6.0
pyenv virtualenvwrapper

# Use virtualenv wrapper while on 3.6.0 shell
lsvirtualenv // mkvirtualenv // rmvirtualenv

# Start / stopping Virtual environment
workon / deactivate

# Change to default system python after deactivating the virtual env
pyenv shell system

```

* Make sure the check which python you are using when virtualenv is created

```python
python -V
#3.6.0
```
