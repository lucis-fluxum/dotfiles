#!/bin/bash
# Update packages, dev tools, vim plugins, etc.

GIT_PULL="git pull origin master"

dnf upgrade -y

# Update rust, rbenv, yarn, and vim plugins
sudo -i -u luc << END

rustup update stable

cd ~/.rbenv && $GIT_PULL && cd plugins/ruby-build && $GIT_PULL && cd plugins/rbenv-gemset
cd ~/.pyenv && $GIT_PULL
cd ~/.nvm && $GIT_PULL
yarn global upgrade

nvim --headless +PlugUpgrade +PlugUpdate +qa!

END
