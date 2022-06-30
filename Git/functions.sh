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

# Clean up local git branches
nuke_git_branches() {
    red=$(tput setaf 1)
    green=$(tput setaf 2)
    reset=$(tput sgr0)
    branch_list=($(git branch | grep -v "$(git_main_branch)" | sed 's/\* //'))

    if [[ ${#branch_list[@]} = 0 ]]; then
        echo "${green}There are no local branches to remove.${reset}"
    elif [[ "$1" = "-i" ]]; then
        count=1
        declare -a to_delete=()
        for b in "${branch_list[@]}"
        do
            read -r "?${count} of ${#branch_list[@]}: Delete \"${b}\"? (y/n) " "delete_branch"
            count=$((count+1))
            if [[ "${delete_branch}" =~ ^[Yy]$ ]]; then
                to_delete+=("${b}")
            elif [[ ! "${delete_branch}" =~ ^[Nn]$ ]]; then
                echo "Invalid response: \"${delete_branch}\". ${b} will not be deleted."
            fi
        done

        printf "\n%s\n\n" "Deleting the requested branch(es)..."
        for delete_me in "${to_delete[@]}"
        do
            git branch -D "${delete_me}"
        done
    else
        echo "${red}You are about to delete ${#branch_list[@]} local branches:${reset}"
        printf '%s\n' "${branch_list[@]}"

        echo
        read -r "?Are you sure? (y/n) " "confirm"
        if [[ ${confirm} =~ ^[Yy]$ ]]; then
            printf "%s\n\n" "${green}Processing...${reset}"

            git checkout "$(git_main_branch)"
            git branch | grep -v "$(git_main_branch)" |
            xargs git branch -D
        elif [[ ${confirm} =~ ^[Nn]$ ]]; then
            printf "\n%s\n" "Exiting..." 
        else
            printf "\n%s\n%s\n%s\n" "You entered: \"${confirm}\"." "https://cldup.com/Tk7K6KLGlY.gif" "Please use \"y\" or \"n\". Exiting for now!"      
        fi
    fi
}

# Merge current branch into main branch
git_merge_main() {
    declare BRANCH_TO_MERGE=$(git_current_branch)
    
    if [[ $BRANCH_TO_MERGE == $(git_main_branch) ]]; then
        echo "Already on '$(git_main_branch)'"
    else
        git checkout $(git_main_branch)
        git merge ${BRANCH_TO_MERGE}
    fi
}