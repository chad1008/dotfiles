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
                sed -n "/${SECTIONS[index]}/,\$p" $ALIAS_FILE | sed -n '/^# keywords:/!p' | sed -e 's/alias //' | sed -e "s/'//g" | sed -e "s/=/ = /"
            else
                # Print to the next section, excluding its title
                sed -n "/${SECTIONS[index]}/,/${SECTIONS[index+1]}/{/${SECTIONS[index+1]}/!p;}" $ALIAS_FILE | sed -n '/^# keywords:/!p' | sed -e 's/alias //' | sed -e "s/'//g" | sed -e "s/=/ = /"
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