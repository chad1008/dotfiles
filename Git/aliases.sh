#!/bin/bash

## GIT ALIASES
## Note: formatting is crucial to the gitcheat() function:
##    - section names MUST start with '# ' (including  trailing space)
##    - keyword strings MUST be included, and begin with '# kewords: ' (including  trailing space)

alias      g='git'

# Status and info
# keywords: status log
alias     gs='git status'
alias    gss='git status -s'

alias     gl='git log --oneline'

# Staging and committing
# keywords: stage stash add commit
alias     ga='git add'
alias    gau='git add -u'
alias    gaa='git add -A'

alias     gc='git commit'
alias    gcm='git commit -m'
alias    gcu='git add -u && git commit'
alias   gcum='git add -u && git commit -m'
alias    gca='git add -a && git commit'
alias   gcam='git add -a && git commit -m'
alias    gcA='git commit --amend'
alias   gcAn='git commit --amend --no-edit'

alias    gst='git stash'
alias   gstm='git stash -m'
alias   gstl='git stash list'
alias   gsta='git stash apply'
alias   gstp='git stas pop'

# Branches and remotes
# keywords: branch remote
alias    gco='git checkout'
alias   gcob='git checkout -b'
alias    gbd='git branch -d'
alias    gbD='git branch -D'

alias     gr='git remote'

alias     gm='git merge'

# Push and pull
# keywords: push pull
alias   gpsh='git push'
alias   gpll='git pull'
alias     gf='git fetch'

# Other
# keywords: bisect rebase cherry-pick other
alias     gb='git bisect'
alias    gbs='git bisect start'
alias    gbg='git bisect good'
alias    gbb='git bisect bad'
alias    gbr='git bisect reset'

alias    grb='git rebase -i'
alias   grba='git rebase abort'

alias    gcp='git cherry-pick'

alias gcheat='gitcheat'