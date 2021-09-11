#!/bin/bash

## GIT ALIASES

alias    g='git'

# Status and info
alias   gs='g status'
alias  gss='gs -s'

alias   gl='g log --oneline'

# Staging and committing
alias   ga='g add'
alias  gau='ga -u'
alias  gaa='ga -A'

alias   gc='g commit'
alias  gcm='gc -m'
alias  gcu='gau && gc'
alias gcum='gau && gcm'
alias  gca='gaa && gc'
alias gcam='gaa && gcm'
alias  gc!='gc --amend'
alias gc!n='gc! --no-edit'

alias  gst='g stash'
alias gstm='gst -m'
alias gstl='gst list'
alias gsta='gst apply'
alias gstp='gst pop'

# Branches and remotes
alias  gco='g checkout'
alias gcob='gco -b'
alias  gbd='git branch -d'
alias  gbD='git branch -D'

alias   gr='g remote'

alias   gm='g merge'

# Push and pull
alias gpsh='g push'
alias gpll='g pull'
alias   gf='g fetch'

# Other
alias   gb='g bisect'
alias  gbs='gb start'
alias  gbg='gb good'
alias  gbb='gb bad'
alias  gbr='gb reset'

alias  grb='g rebase -i'
alias grba='g rebase abort'

alias  gcp='g cherry-pick'