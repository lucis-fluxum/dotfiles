#!/bin/sh
# Update packages, dev tools, vim plugins, etc.

brew upgrade --greedy
rustup update stable
# npm upgrade -g
nvim --headless +PlugUpgrade +PlugUpdate +qa!
