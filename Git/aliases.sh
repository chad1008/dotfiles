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

# Staging and stashing
# keywords: stage stash add
alias     ga='git add'
alias    gau='git add -u'
alias    gaa='git add -A'
alias    gap='git add -p'

alias    gst='git stash'
alias   gstm='git stash -m'
alias   gstl='git stash list'
alias   gsta='git stash apply'
alias   gstp='git stash pop'
alias   gstc='git stash clear'
alias   gstd='git stash drop'

# Committing
# keywords: commit amend no-edit
alias     gc='git commit'
alias    gcm='git commit -m'
alias    gcu='git add -u && git commit'
alias   gcum='git add -u && git commit -m'
alias    gca='git add -A && git commit'
alias   gcam='git add -A && git commit -m'
alias    gcA='git commit --amend'
alias   gcAn='git commit --amend --no-edit'

# Branches and remotes
# keywords: branch remote merge
alias    gco='git checkout'
alias   gcob='git checkout -b'
alias   gcom='git checkout $(git_main_branch)'
alias     gb='git branch'
alias    gbd='git branch -d'
alias    gbD='git branch -D'
alias     gn='nuke_branches'
alias    gni='nuke_branches -i'

alias     gr='git remote'

alias     gm='git merge'
alias    gmm='git_merge_main'

# Push and pull
# keywords: push pull
alias   gpsh='git push'
alias  gpshu='git push -u origin $(git_current_branch)'
alias   gpll='git pull'
alias     gf='git fetch'

# Bisect
# keywords: bisect
alias    gbs='git bisect'
alias   gbss='git bisect start'
alias   gbsg='git bisect good'
alias   gbsb='git bisect bad'
alias   gbsr='git bisect reset'

# Other
# keywords: rebase reset cherry-pick other cheat diff
alias    grst='git reset'
alias   grsth='git reset --hard'

alias    grb='git rebase'
alias   grbi='git rebase -i'
alias   grbm='git rebase $(git_main_branch)'
alias   grbc='git rebase --continue'
alias   grba='git rebase abort'

alias    gcp='git cherry-pick'

alias     gd='git diff'
alias    gdm='git diff $(git_main_branch)'

alias gcheat='gitcheat'
