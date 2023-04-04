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

# When specifying workspace data, `annual` should be an empty string or `-a`.
# The latter will pass the proper `annual mode` flag.
if [[ $workspace = home ]]; then
   countdown_emoji=":house:"
   countdown_date="Apr 1"
   annual=''
   dayOf="I'm on my way!"
elif [[ $workspace = a8c ]]; then
   countdown_emoji=":christmas_tree:"
   countdown_date="Dec 25"
   annual=''
   dayOf='Merry Christmas!'
fi

countdown_value=$(countdown -s $annual -d "$countdown_date")

# If `dayOf` is not an empty string, and the countdown value is 0, we set the
# countdown_value to the `dayOf` string.
if [[ -n $dayOf ]] && [[ $countdown_value = 0 ]]; then
   countdown_value=$dayOf
fi

# The default status is only modified if the text is 1-3 digits followed by the
# right emoji. (first sed statement) OR
# if the text matches the current `dayOf` string. (second sed statement)
# This updates ALL default statuses that match the the current workspace's 
# countdown_emoji`.
#
# In the future, I should clean this up so that two workspaces could safely use
# the same emoji for different dates.
sed -i '' -e "s/\([0-9].*\)\( ${countdown_emoji}\)/${countdown_value}\2/g;s/\(${dayOf}\)\( ${countdown_emoji}\)/${countdown_value}\2/" ~/dev/slackli/config.json

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
