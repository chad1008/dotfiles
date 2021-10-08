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

# Get days until Christmas
christmas() {
    YEAR=$(TZ=UTC+4 date -R +"%Y")
    CHRISTMAS=$(date -jf "%b %d %Z %Y" "Dec 25 EDT $YEAR" "+%s")
    TODAY=$(date +%s)
    COUNTDOWN=$(( (${CHRISTMAS} - ${TODAY})/60/60/24 ))

    while getopts ":s" o; do
        case "${o}" in
            s)
                echo "${COUNTDOWN}"
                ;;
            *)
                echo "$(tput bold)$(tput setaf 2)w$(tput setaf 1)u$(tput setaf 2)t$(tput setaf 1)?$(tput sgr0)"
        esac
    done
    shift $((OPTIND-1))
    if [ $OPTIND -eq 1 ]; then echo "$(tput bold)$(tput setaf 2)${COUNTDOWN} $(tput setaf 1)days $(tput setaf 2)until $(tput setaf 1)christmas$(tput setaf 2)!$(tput setaf 1)!$(tput setaf 2)!$(tput sgr0)"; fi
}