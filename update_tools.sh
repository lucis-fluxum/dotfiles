#!/bin/sh
# Update packages, dev tools, vim plugins, etc.

brew upgrade

# Update rust, rbenv, yarn, and vim plugins
sudo -i -u luc << END

rustup update stable

yarn global upgrade

nvim --headless +PlugUpgrade +PlugUpdate +qa!

END
