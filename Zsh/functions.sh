#!/bin/bash

# Always step into newly created directories
mkdir() {
    command mkdir -- "$@"
    cd -- "$_"
}

# Push changes to iTerm2 settings
pushiterm() {
    cd $DOTFILES
    git add System/iTerm2/com.googlecode.iterm2.plist &&
    git commit
    git push
}
