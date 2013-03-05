#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
#############################

dest=~/dotfiles
archive=~/dotarchive

mkdir -p $archive

files="bashrc vimrc screenrc"
for file in $files; do
    mv ~/.$file $archive
    ln -s $dest/$file ~/.$file
done
