#!/bin/bash

## UNISON ALIASES

# Start Unison watching and syncing files
alias unison-watch="unison -ui text -repeat watch automattic-sandbox"
 
# Reset Unison to accept remote as source of truth - use with caution as this will destory local changes
alias unison-reset="unison -ui text automattic-sandbox -force ssh://wpdev@wpcom//home -batch"

# Open local wpcom sandbox directory
alias wpsb="cd ~/dev/automattic-sandbox/wpcom/public_html"
# Open local mc sandbox directory
alias mcsb="cd ~/dev/automattic-sandbox/missioncontrol/public_html"