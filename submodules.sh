#!/bin/bash
# Update .gitmodules from vimrc and other sources

> .gitmodules

# Vim plugins
rg -oP "^Plug '\K.+?(?=')" vimrc | while read -r line ; do
    plugin=$(rg -oP "\/\K.+" <<< $line)
    echo -e "[submodule \"vim/bundle/$plugin\"]
\tpath = vim/bundle/$plugin
\turl = https://github.com/$line\n" >> .gitmodules
done

# rbenv
echo -e "[submodule \"rbenv\"]
\tpath = rbenv
\turl = https://github.com/rbenv/rbenv\n" >> .gitmodules

# pyenv
echo -e "[submodule \"pyenv\"]
\tpath = pyenv
\turl = https://github.com/pyenv/pyenv\n" >> .gitmodules

# nodenv
echo -e "[submodule \"nodenv\"]
\tpath = nodenv
\turl = https://github.com/nodenv/nodenv\n" >> .gitmodules

git add .gitmodules
