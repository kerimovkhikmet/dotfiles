# ~/.bash_aliases - sourced from .bashrc
# shellcheck shell=bash
# git aliases - curated subset of the oh-my-zsh git plugin (zsh-only); extend as needed
# full list: https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh

# status
alias gst='git status'
alias gss='git status -s'

# add
alias ga='git add'
alias gaa='git add --all'
alias gap='git add --patch'

# branch / checkout / switch
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch --delete'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcm='git checkout master'  # matches init.defaultBranch=master
alias gsw='git switch'
alias gswc='git switch --create'

# diff
alias gd='git diff'
alias gds='git diff --staged'
alias gdw='git diff --word-diff'

# log
alias glo='git log --oneline --decorate'
alias glog='git log --oneline --decorate --graph'

# push / pull / fetch
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpu='git pull'
alias gfo='git fetch origin'

# merge / rebase / reset
alias gm='git merge'
alias grb='git rebase'
alias grh='git reset'
alias grhh='git reset --hard'

# stash
alias gsta='git stash'
alias gstp='git stash pop'

# misc
alias gcl='git clone'
alias gcp='git cherry-pick'
