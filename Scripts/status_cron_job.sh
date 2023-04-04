#!/bin/zsh
# shellcheck disable=all

# This script is meant to be run as a cron job.
# It starts by updating all default status that look like relevant countdowns
# to the correct value.
# Then it checks the current status for the provided workspace ($1) and
# username ($2).
# If the status is empty or has the wrong countdown value, it clears the status,
# which will trigger the default if it's set in Slackli.

source ~/.zshrc

workspace=$1
username=$2
countdown_emoji=''
countdown_date=''
annual=false
dayOf=''

# When specifying workspace data, set `annual` to true if the countdown is
# annual, and set `dayOf` to the text you want to display on the day of the
# countdown.
if [[ $workspace = home ]]; then
   countdown_emoji=":christmas_tree:"
   countdown_date="Dec 25"
   annual=true
   dayOf='Merry Christmas!'
elif [[ $workspace = a8c ]]; then
   countdown_emoji=":christmas_tree:"
   countdown_date="Dec 25"
   annual=true
   dayOf='Happy Holidays!'
fi

if $annual ;then
   a_flag="-a"
else
   a_flag=""
fi

#  Default status is only set if the values are defined for the workspace.
if [[ -n $countdown_emoji ]] && [[ -n $countdown_date ]]; then
   countdown_value="$(countdown -s $a_flag -d $countdown_date) $countdown_emoji"

   if [[ -n $dayOf ]] && [[ $countdown_value = "0 $countdown_emoji" ]]; then
      countdown_value=$dayOf
   fi

   updatedConfig="$( /opt/homebrew/bin/jq --tab \
                     --arg workspace "$workspace" \
                     --arg emoji "$countdown_emoji" \
                     --arg text "$countdown_value" \
                     '.workspaces[$workspace].defaultStatus.emoji = $emoji | 
                     .workspaces[$workspace].defaultStatus.text = $text' ~/dev/slackli/config.json)" && \
                  echo -E "${updatedConfig}" >  ~/dev/slackli/config.json
fi

current_status=$( slackli ${workspace} getStatus ${username} )
current_emoji=$(echo $current_status | /opt/homebrew/bin/jq -r '.emoji')
current_text=$(echo $current_status | /opt/homebrew/bin/jq -r '.text')

# Brace thyself.
if \
   # The status is clear
   [[ -z $current_emoji && -z $current_text ]] || ( \
   # or it has the current emoji and...
   [[ $current_emoji = "${countdown_emoji}" ]] && ( \
      # it's a number followed by the correct emoji, but does not match the current countdown value
      [[ $current_text =~ "^-?[0-9]{1,3} ${countdown_emoji}$" && $current_text != "${countdown_value}" ]] || \
      # or it matches the current dayOf string, but that isn't what the countdown value shoule be
      [[ -n $dayOf && $current_text = $dayOf && $current_text != $countdown_value ]] ) ) ;then
         # Clear the status
         slackli ${workspace} status clear
fi
