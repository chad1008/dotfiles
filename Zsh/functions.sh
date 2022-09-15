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

## Meeting Control
meetstart() {
    headset
    slackli status :zoom: "in a meeting" "60 min"
    slackli home send lynne ":red_circle: Meeting has started! :heart:"
    node ~/dev/hue/onAir.js
}

meetend() {
    monitoraudio
    slackli status clear
    slackli home send lynne ":large_green_circle: Meeting is all done! :green_heart:"
    node ~/dev/hue/offAir.js
}

# Expects one positional argument for the number of minutes to wait before clearing slack status
doggo() {
    slackli status :dogwalk: "brb, doggo time" "${1} min"
}

morning () {
    morning_quiet=false
    while getopts ":lfqm:" opts
    do	case "$opts" in
        l)	    message="Good morning! Late start today.";;
        f)	    message="👋 Forgot to say good morning!";;
        q)      morning_quiet=true;;
        m)      message="${OPTARG}";;
        [?])	print >&2 "Invalid option(s)
        [-q]            Quiet mode. Sends no message to Slack.
        [-m] message    Specify custom Slack message.
        [-l]            Send a 'late start' message.
        [-f]            Send a 'forgot to say good morning' message."
            return 1;;
        esac
    done
    shift $OPTIND-1

    if [[ -z ${message} ]]; then
        # Prepare team greeting
        greetings=("morning" "good morning" "good morning everyone" "hi" "hello")
        emoji=("👋"\
            ":howdy:"\
            ":blob-wave:"\
            ":goodmorning:"\
            ":sun:"\
            ":sunny:"\
            "🌅"\
            ":sun-sun-sun:"\
            ":sun-happy-sun:"\
            ":sun-bounce-happy:"\
            )
        gifs=("https://cldup.com/HfZ2UOvd5j.gif"\
            "https://cldup.com/ufvYPXt6QX.gif"\
            "https://cldup.com/fNTrWry_bT.gif"\
            "https://cldup.com/oaEpP8M3JK.gif"\
            "https://cldup.com/MeE0KHuQ52.gif"\
            "https://cldup.com/rpT3-gzt2s.gif"\
            "https://cldup.com/hWTzTzmBIa.gif"\
            )
        # Generate a number between one and ten
        CAP=10
        main_chance=$RANDOM
        (( main_chance %= $CAP ))
        (( main_chance += 1 ))
        # a 10% chance of a gif appearing.
        if [[ ${main_chance} -eq 1 ]]; then
            message=${gifs[ $RANDOM % ${#gifs[@]} + 1 ]}
        # a 10% of an emoji-only greeting.
        elif [[ ${main_chance} -eq 2 ]]; then
            message=${emoji[ $RANDOM % ${#emoji[@]} + 1 ]}
        # Otherwise (80%) a text greeting.
        else
            text=${greetings[ $RANDOM % ${#greetings[@]} + 1 ]}
            emoji_chance=$RANDOM
            (( emoji_chance %= $CAP ))
            (( emoji_chance += 1 ))
            # 70% chance to include an emoji
            if [[ $emoji_chance -gt 3 ]]; then
                emoji=" ${emoji[ $RANDOM % ${#emoji[@]} + 1 ]}"
            else
                emoji=""
            fi
            # 50% chance text will include an exclamation point
            exclamation_chance=$RANDOM
            (( exclamation_chance %= $CAP ))
            (( exclamation_chance += 1 ))
            if [[ $exclamation_chance -gt 5 ]]; then
                exclamation="!"
            else
                exclamation=""
            fi

            message="${text}${exclamation}${emoji}"
        fi
    fi
    startproxy
    if [[ "${morning_quiet}" = false ]]; then
        slackli send "${team_channel}" "${message}" --active
    fi
    slackli title "Code Wrangler and GIF curator on Team Calypso 🎄$(christmas -s)🎄"
    open -a Slack
    unset message
}

night() {
    night_quiet=false
    while getopts ":qm:" opts
    do	case "$opts" in
        q)      night_quiet=true;;
        m)      message="${OPTARG}";;
        [?])	print >&2 "Invalid option(s)
        [-q]            Quiet mode. Sends no message to Slack.
        [-m] message    Specify custom Slack message."
            return 1;;
        esac
    done
    shift $OPTIND-1

    if [[ -z ${message} ]]; then
        # Prepare team goodbye
        farewells=("good night" "good night everyone" "calling it a night" "calling it a day" "I'm headed out" "heading out" "I'm heading out" "signing off")
        emoji=("👋"\
            ":bye:"\
            ":byee:"\
            ":bye_speech_bubble:"\
            ":goodnight2:"\
            )
        # Generate a number between one and ten
        CAP=10
        text=${farewells[ $RANDOM % ${#farewells[@]} + 1 ]}
        # 50% chance to include an emoji
        emoji_chance=$RANDOM
        (( emoji_chance %= $CAP ))
        (( emoji_chance += 1 ))
        if [[ $emoji_chance -gt 5 ]]; then
            emoji=" ${emoji[ $RANDOM % ${#emoji[@]} + 1 ]}"
        else
            emoji=""
        fi
        # 50% chance text will include an exclamation point
        exclamation_chance=$RANDOM
        (( exclamation_chance %= $CAP ))
        (( exclamation_chance += 1 ))
        if [[ $exclamation_chance -gt 5 ]]; then
            exclamation="!"
        else
            exclamation=""
        fi

        message="${text}${exclamation}${emoji}"
    fi

    
    endproxy
    if [[ "${night_quiet}" = false ]]; then
        slackli send "${team_channel}" "${message}" --away
    fi
    osascript -e 'quit app "Slack"'
    unset message
}
