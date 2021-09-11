#!/bin/bash

# Print a git alias cheatsheet

gitcheat() {
    if [ $# -eq 0 ]
    then
        cat $DOTFILES/Git/aliases.sh
    elif [ $1 = "status" ]
    then
        sed -n '/Status/,/committing/{/committing/!p;}' Git/aliases.sh
    elif [ $1 = "stage" ] || [ $1 = "commit" ]
    then
        sed -n '/Staging/,/Branches/{/Branches/!p;}' Git/aliases.sh
    elif [ $1 = "branch" ] || [ $1 = "remote" ]
    then
        sed -n '/Branches/,/Push/{/Push/!p;}' Git/aliases.sh
    elif [ $1 = "push" ] || [ $1 = "pull" ]
    then
        sed -n '/Push/,/Other/{/Other/!p;}' Git/aliases.sh
    elif [ $1 = "bisect" ] || [ $1 = "rebase" ] || [ $1 = "cherry-pick" ] || [ $1 = "other" ]
    then
        sed -n '/Other/,$p;' Git/aliases.sh
  else
        echo 'Invalid search term'
    fi
}