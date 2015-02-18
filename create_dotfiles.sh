#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
#############################

dest=~/dotfiles
archive=~/dotarchive

mkdir -p $archive

# Make sure you have the revisioned copy of the file in $dest
files="bashrc bashrc.d vimrc screenrc bash_profile tmux.conf"
for file in $files; do
    if [ -d ~/.$file ]; then
        echo "Creating directory .$file in $archive";
        cp -r ~/.$file $archive
    else
        echo "Copying file .$file to $archive";
        mv ~/.$file $archive
    fi
    ln -s $dest/$file ~/.$file
done
