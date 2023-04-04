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
annual=''
dayOf=''

# When specifying workspace data, `annual` should be an empty string or `-a`.
# The latter will pass the proper `annual mode` flag.
if [[ $workspace = home ]]; then
   countdown_emoji=":dog:"
   countdown_date="Apr 4"
   annual=''
elif [[ $workspace = a8c ]]; then
   countdown_emoji=":christmas_tree:"
   countdown_date="Apr 4"
   annual=''
   dayOf='Merry Christmas!'
fi

#  Default status is only set if the values are defined for the workspace.
if [[ -n $countdown_emoji ]] && [[ -n $countdown_date ]]; then
   countdown_value="$(countdown -s $annual -d "$countdown_date") $countdown_emoji"

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

exit

current_status=$( slackli ${workspace} getStatus ${username} )
current_emoji=$(echo $current_status | /opt/homebrew/bin/jq -r '.emoji')
curent_text=$(echo $current_status | /opt/homebrew/bin/jq -r '.text')

# We update the status if:
# 1. It's empty OR
# 2. It has the right current_emoji AND
#    It has 1-3 digit number followed by the right current_emoji AND
#    It doesn't have the same number as the countdown value.
# I'd prefer to combine the last two conditions, but zsh was being a dick.
if ([[ -z $current_emoji ]] && [[ -z $curent_text ]]) || \
   ([[ $current_emoji = "${countdown_emoji}" ]] && \
   [[ $curent_text =~ "^[0-9]{1,3} ${countdown_emoji}$" ]] && \
   [[ $curent_text != "${countdown_value} ${countdown_emoji}" ]]); then
	slackli ${workspace} status clear
fi
