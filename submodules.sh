#!/bin/sh
# Update .gitmodules from vimrc and other sources

> .gitmodules

# Vim plugins
rg -oP "^Plug '\K.+?(?=')" vimrc | while read -r line ; do
    plugin=$(rg -oP "\/\K.+" <<< $line)
    echo "[submodule \"vim/bundle/$plugin\"]
\tpath = vim/bundle/$plugin
\turl = https://github.com/$line\n" >> .gitmodules
done

git add .gitmodules
