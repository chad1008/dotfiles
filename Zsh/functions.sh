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
    CHRISTMAS_DAYMONTH="Dec 25"
    CURRENT_YEAR=$(TZ=UTC+4 date -R +"%Y")
    CURRENT_CHRISTMAS=$(date -jf "%H:%M:%S %b %d %Z %Y" "23:59:59 $CHRISTMAS_DAYMONTH EDT $CURRENT_YEAR" "+%s")
    TODAY=$(date +%s)
    # If Christmas has passed, bump the target date to next year
    if [[ "${TODAY}" -lt "${CURRENT_CHRISTMAS}" ]]; then
        COUNTDOWN_YEAR=${CURRENT_YEAR}
    else
        COUNTDOWN_YEAR=$(( ${CURRENT_YEAR} + 1 ))
    fi
    CHRISTMAS=$(date -jf "%H:%M:%S %b %d %Z %Y" "23:59:59 $CHRISTMAS_DAYMONTH EDT $COUNTDOWN_YEAR" "+%s")
    COUNTDOWN=$(( (${CHRISTMAS} - ${TODAY})/60/60/24 ))

    # Check for short mode. Output the value or get confused on unrecognized input
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

    # If we aren't in short mode, output message for Christmas day, Christmas eve, and the rest of the year
    if [ $OPTIND -eq 1 ]; then
        if [[ "${COUNTDOWN}" = 365 ]]; then
            echo "$(tput bold)$(tput setaf 2)Merry $(tput setaf 1)Christmas$(tput setaf 2)!$(tput setaf 1)!$(tput setaf 2)!$(tput sgr0)"
        elif [[ "${COUNTDOWN}" = 1 ]]; then
            echo "$(tput bold)$(tput setaf 2)Tomorrow $(tput setaf 1)is $(tput setaf 2)the $(tput setaf 1)big $(tput setaf 2)day $(tput setaf 1)!$(tput setaf 2)!$(tput setaf 1)!$(tput sgr0)"
        else 
            echo "$(tput bold)$(tput setaf 2)${COUNTDOWN} $(tput setaf 1)days $(tput setaf 2)until $(tput setaf 1)christmas$(tput setaf 2)!$(tput setaf 1)!$(tput setaf 2)!$(tput sgr0)"
        fi
    fi
}

## Audio Controls - requires https://github.com/deweller/switchaudio-osx
headset() {
  switchaudiosource -s "Sennheiser SC 130 USB"
  switchaudiosource -s "Sennheiser SC 130 USB" -t input
}
monitoraudio() {
  switchaudiosource -s "C49RG9x"
}
mbpaudio() {
  switchaudiosource -s "MacBook Pro Speakers"
  switchaudiosource -s "MacBook Pro Microphone" -t input
}