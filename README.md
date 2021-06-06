# luc's dotfiles

`setup.sh [platform]` creates the necessary symlinks. Existing dotfiles are backed up to `~/.dotfiles.old`.

Added a new Vim plugin? Make sure it gets registered using `git submodule add [url] vim/bundle/[name]`.

## Linux
Run `setup.sh linux`.

`sudo bash fedora_kickstart.sh` will perform almost all needed configuration and installation on Fedora,
including setting up these dotfiles.

## macOS
Run `setup.sh mac`.
