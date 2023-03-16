#!/bin/zsh
# shellcheck disable=all
source ~/.zshrc
countdown_value=$(christmas -s)
sed -i '' -e "s/\([0-9].*\)\( :christmas_tree:\)/${countdown_value}\2/g" ~/dev/slackli/config.json

current_status=$( slackli home getStatus chad )

emoji=$(echo $current_status | /opt/homebrew/bin/jq -r '.emoji')
text=$(echo $current_status | /opt/homebrew/bin/jq -r '.text')

# We update the status if:
# 1. It's empty OR
# 2. It has the right emoji AND
#    It has 1-3 digit number followed by the right emoji AND
#    It doesn't have the same number as the countdown value.
# I'd prefer to combine the last two conditions, but zsh was being a dick.
if ([[ -z $emoji ]] && [[ -z $text ]]) || \
   ([[ $emoji = ":christmas_tree:" ]] && \
   [[ $text =~ "^[0-9]{1,3} :christmas_tree:$" ]] && \
   [[ $text != "${countdown_value} :christmas_tree:" ]]); then
	echo "updating status..."
	slackli home status clear
	slackli a8c status clear
fi


