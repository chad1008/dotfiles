#!/bin/bash

# Print a git alias cheatsheet
gitcheat() {
    declare ALIAS_FILE=$DOTFILES/Git/aliases.sh
    # Read file sections from alias.sh
    IFS=$'\n' SECTIONS=($(sed -n -e '/^# /{/^# keywords:/!p;}' $ALIAS_FILE))
    # Read file section keywords from alias.sh
    IFS=$'\n' KEYS=($(sed -n -e '/^# keywords:/p' $ALIAS_FILE | sed -e "s/# keywords://"))
    declare MATCH=false

    # Loop through the sections
    for ((index=1; index <= ${#SECTIONS[@]}; index++)); do
        # If the search term matches keywords for the current section...
        if [[ ${KEYS[index]} == *"$1"* ]];then
            MATCH=true
            # If the current section is the last on the page...
            if [[ $index == ${#SECTIONS[@]} ]]; then
                # Print to the end of the file
                sed -n "/${SECTIONS[index]}/,\$p" $ALIAS_FILE | gitcheat_sed_cleanup
            else
                # Print to the next section, excluding its title
                sed -n "/${SECTIONS[index]}/,/${SECTIONS[index+1]}/{/${SECTIONS[index+1]}/!p;}" $ALIAS_FILE | gitcheat_sed_cleanup
            fi
        fi
    done

    # Handle invalid search terms
    if [[ $MATCH == false ]]; then
        echo "Keyword \"$1\" was not found. Please try one of the following:"
        for i in "${KEYS[@]}"; do
            echo $i
        done
    fi
}

# Clean up gitcheat's sed output
gitcheat_sed_cleanup() {
    sed -n '/^# keywords:/!p' |
    sed -e 's/alias //' |
    sed -e "s/'//g" |
    sed -e "s/=/ = /"
}

# Destroy all branches other than main
nuke_git_branches() {
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    NC='\033[0m'

    if [[ "$(git branch | grep -vc "$(git_main_branch)")" == 0 ]]; then
        echo ${GREEN}There are no remote branches to remove.${NC}
    else
        echo ${RED}You are about to delete the following local branches:${NC}
        git branch | grep -v "$(git_main_branch)"

        read "?Are you sure? (y/n) "
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            echo ${GREEN}Processing...${NC}
            echo
            git checkout $(git_main_branch)
            git branch | grep -v "$(git_main_branch)" |
            xargs git branch -D
        else
            echo "Exiting..."
        fi
    fi
}