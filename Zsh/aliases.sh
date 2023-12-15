#!/bin/bash

## GENERAL ALIASES

# Navigation
alias cddf='cd $DOTFILES'

# Misc
alias clr='clear'
alias christmas='countdown -a -d "Dec 25" -n "christmas" -e "Its christmas eve!" -c "Merry Christmas!!! :christmas_tree:"'
alias nukenberg='npm run wp-env destroy && docker system prune && npm run distclean && npm ci && npx playwright install && npm run build && npm run wp-env start'

# SSH
alias sshwpcom="ssh -t wpcom 'cd public_html; bash -l'"

# VSCode
alias codein="code-insiders"