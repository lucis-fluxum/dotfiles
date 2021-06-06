#!/bin/sh
# Update .gitmodules from vimrc and other sources

> .gitmodules

# Vim plugins
plugins=$(rg -oP "^\s*Plug '\K.+?(?=')" vimrc)
for plugin in $plugins; do
    name=$(rg -oP "\/\K.+" <<< "$plugin")
    cat <<- END >> .gitmodules
	[submodule "vim/bundle/$name"]
	    path = vim/bundle/$name
	    url = https://github.com/$plugin
        
		END
done

# asdf
cat << END >> .gitmodules
[submodule "asdf"]
    path = asdf
    url = https://github.com/asdf-vm/asdf 
END

git add .gitmodules
