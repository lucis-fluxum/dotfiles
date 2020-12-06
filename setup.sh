#!/bin/sh
# Create symlinks from the home directory to any desired dotfiles in ~/.dotfiles
# and setup a pre-commit hook for updating submodules

dir=~/.dotfiles
olddir=~/.dotfiles_old
files="zshrc irbrc venvs vimrc vim"

echo "\n== Creating $olddir for backup of existing dotfiles =="
mkdir -p $olddir

cd $dir

for file in $files; do
    echo "\nMoving existing .$file from ~ to $olddir"
    mv -vn ~/.$file $olddir
    echo "\nCreating symlink: .$file -> $dir/$file"
    ln -s $dir/$file ~/.$file
done

echo "\n== Linking nodenv, pyenv, rbenv =="
mv -vn ~/.nodenv $dir/nodenv && ln -s $dir/nodenv ~/.nodenv
mv -vn ~/.pyenv $dir/pyenv && ln -s $dir/pyenv ~/.pyenv
mv -vn ~/.rbenv $dir/rbenv && ln -s $dir/rbenv ~/.rbenv

echo "\n== Setting up pre-commit hook =="
ln -s $dir/submodules.sh .git/hooks/pre-commit

echo "\n== Done! =="
