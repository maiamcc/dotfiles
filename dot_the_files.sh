#!/bin/bash

DIR=${PWD}

# TODO: make this not suck, i.e. iterate over files in directory except for
# specific files to be ignored.

# Delete mode: delete currently existing dotfiles so we can symlink new ones.
if [[ "$1" == "-d" ]] || [[ "$1" == "-D" ]] || [[ "$1" == "--delete" ]]; then
  echo "Deleting your current dotfiles..."
  rm ~/.ApathyBeep.aif
  rm ~/.DunDunDun.aiff
  rm ~/.bash_aliases
  rm ~/.bash_profile
  rm ~/.git-completion.bash
  rm ~/.gitconfig
  rm ~/.punlist
  rm ~/.safety_pig
  rm ~/.vimrc
fi

echo "Symlinking your shiny new dotfiles..."
ln -s $DIR/ApathyBeep.aif ~/.ApathyBeep.aif
ln -s $DIR/DunDunDun.aiff ~/.DunDunDun.aiff
ln -s $DIR/bash_aliases ~/.bash_aliases
ln -s $DIR/bash_profile ~/.bash_profile
ln -s $DIR/git-completion.bash ~/.git-completion.bash
ln -s $DIR/gitconfig ~/.gitconfig
ln -s $DIR/punlist ~/.punlist
ln -s $DIR/safety_pig ~/.safety_pig
ln -s $DIR/vimrc ~/.vimrc

source ~/.bash_profile

echo "The files have been dotted!"
