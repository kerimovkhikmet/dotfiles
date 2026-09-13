# ~/.bash_aliases - sourced from .bashrc
# shellcheck shell=bash
# git shorthands - bash port of the oh-my-zsh git plugin, aliases only
# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh
#
# Branch names are resolved inline, no helper functions:
#   current = git branch --show-current
#   main    = "main" when that branch exists, else "master"
#   develop = develop

# status
alias gst='git status'
alias gss='git status --short'
alias gsb='git status --short --branch'

# add / apply / wip
alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'
alias gau='git add --update'
alias gav='git add --verbose'
alias gap='git apply'
alias gapt='git apply --3way'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'

# am
alias gam='git am'
alias gama='git am --abort'
alias gamc='git am --continue'
alias gamscp='git am --show-current-patch'
alias gams='git am --skip'

# bisect
alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsn='git bisect new'
alias gbso='git bisect old'
alias gbsr='git bisect reset'
alias gbss='git bisect start'

# blame
alias gbl='git blame -w'

# branch
alias gb='git branch'
alias gba='git branch --all'
alias gbd='git branch --delete'
alias gbD='git branch --delete --force'
alias gbgd='LANG=C git branch --no-color -vv | grep ": gone\]" | cut -c 3- | cut -d" " -f1 | xargs git branch -d'
alias gbgD='LANG=C git branch --no-color -vv | grep ": gone\]" | cut -c 3- | cut -d" " -f1 | xargs git branch -D'
alias gbm='git branch --move'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remotes'
alias ggsup='git branch --set-upstream-to=origin/$(git branch --show-current)'
alias gbg='LANG=C git branch -vv | grep ": gone\]"'

# cherry-pick
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

# clean / clone
alias gclean='git clean --interactive -d'
alias gcl='git clone --recurse-submodules'
alias gclf='git clone --recursive --shallow-submodules --filter=blob:none --also-filter-submodules'

# checkout / switch
alias gco='git checkout'
alias gcor='git checkout --recurse-submodules'
alias gcb='git checkout -b'
alias gcB='git checkout -B'
alias gcd='git checkout develop'
alias gcm='git checkout $(git show-ref -q --verify refs/heads/main && echo main || echo master)'
alias gsw='git switch'
alias gswc='git switch --create'
alias gswd='git switch develop'
alias gswm='git switch $(git show-ref -q --verify refs/heads/main && echo main || echo master)'

# commit
alias gcam='git commit --all --message'
alias gcas='git commit --all --signoff'
alias gcasm='git commit --all --signoff --message'
alias gcs='git commit --gpg-sign'
alias gcss='git commit --gpg-sign --signoff'
alias gcssm='git commit --gpg-sign --signoff --message'
alias gcmsg='git commit --message'
alias gcsm='git commit --signoff --message'
alias gc='git commit --verbose'
alias gca='git commit --verbose --all'
alias gca!='git commit --verbose --all --amend'
alias gcan!='git commit --verbose --all --no-edit --amend'
alias gcans!='git commit --verbose --all --signoff --no-edit --amend'
alias gcann!='git commit --verbose --all --date=now --no-edit --amend'
alias gc!='git commit --verbose --amend'
alias gcn='git commit --verbose --no-edit'
alias gcn!='git commit --verbose --no-edit --amend'
alias gcf='git config --list'
alias gcfu='git commit --fixup'

# describe / diff
alias gdct='git describe --tags $(git rev-list --tags --max-count=1)'
alias gd='git diff'
alias gdca='git diff --cached'
alias gdcw='git diff --cached --word-diff'
alias gds='git diff --staged'
alias gdw='git diff --word-diff'
alias gdup='git diff @{upstream}'
alias gdt='git diff-tree --no-commit-id --name-only -r'

# fetch
alias gf='git fetch'
alias gfa='git fetch --all --tags --prune --jobs=10'
alias gfo='git fetch origin'

# gui / help
alias gg='git gui citool'
alias gga='git gui citool --amend'
alias ghh='git help'

# log
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glods='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short'
alias glod='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"'
alias glola='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all'
alias glols='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat'
alias glol='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'
alias glo='git log --oneline --decorate'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias glp='git log --pretty='
alias glg='git log --stat'
alias glgp='git log --stat --patch'
alias gwch='git log --patch --abbrev-commit --pretty=medium --raw'

# ls-files
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias gfg='git ls-files | grep'

# merge
alias gm='git merge'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gms='git merge --squash'
alias gmff='git merge --ff-only'
alias gmom='git merge origin/$(git show-ref -q --verify refs/heads/main && echo main || echo master)'
alias gmum='git merge upstream/$(git show-ref -q --verify refs/heads/main && echo main || echo master)'
alias gmtl='git mergetool --no-prompt'
alias gmtlvim='git mergetool --no-prompt --tool=vimdiff'

# pull
alias gl='git pull'
alias gpr='git pull --rebase'
alias gprv='git pull --rebase -v'
alias gpra='git pull --rebase --autostash'
alias gprav='git pull --rebase --autostash -v'
alias gprom='git pull --rebase origin $(git show-ref -q --verify refs/heads/main && echo main || echo master)'
alias gpromi='git pull --rebase=interactive origin $(git show-ref -q --verify refs/heads/main && echo main || echo master)'
alias gprum='git pull --rebase upstream $(git show-ref -q --verify refs/heads/main && echo main || echo master)'
alias gprumi='git pull --rebase=interactive upstream $(git show-ref -q --verify refs/heads/main && echo main || echo master)'
alias ggpull='git pull origin "$(git branch --show-current)"'
alias gluc='git pull upstream $(git branch --show-current)'
alias glum='git pull upstream $(git show-ref -q --verify refs/heads/main && echo main || echo master)'

# push
alias gp='git push'
alias gpd='git push --dry-run'
alias gpf!='git push --force'
alias gpf='git push --force-with-lease --force-if-includes'
alias gpsup='git push --set-upstream origin $(git branch --show-current)'
alias gpsupf='git push --set-upstream origin $(git branch --show-current) --force-with-lease --force-if-includes'
alias gpv='git push --verbose'
alias gpoat='git push origin --all && git push origin --tags'
alias gpod='git push origin --delete'
alias ggpush='git push origin "$(git branch --show-current)"'
alias gpu='git push upstream'

# rebase
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase --interactive'
alias grbo='git rebase --onto'
alias grbs='git rebase --skip'
alias grbd='git rebase develop'
alias grbm='git rebase $(git show-ref -q --verify refs/heads/main && echo main || echo master)'
alias grbom='git rebase origin/$(git show-ref -q --verify refs/heads/main && echo main || echo master)'
alias grbum='git rebase upstream/$(git show-ref -q --verify refs/heads/main && echo main || echo master)'

# reflog
alias grf='git reflog'

# remote
alias gr='git remote'
alias grv='git remote --verbose'
alias gra='git remote add'
alias grrm='git remote remove'
alias grmv='git remote rename'
alias grset='git remote set-url'
alias grup='git remote update'

# reset
alias grh='git reset'
alias gru='git reset --'
alias grhh='git reset --hard'
alias grhk='git reset --keep'
alias grhs='git reset --soft'
alias gpristine='git reset --hard && git clean --force -dfx'
alias gwipe='git reset --hard && git clean --force -df'
alias groh='git reset origin/$(git branch --show-current) --hard'

# restore
alias grs='git restore'
alias grss='git restore --source'
alias grst='git restore --staged'

# wip
alias gunwip='git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1'

# revert
alias grev='git revert'
alias greva='git revert --abort'
alias grevc='git revert --continue'

# rm
alias grm='git rm'
alias grmc='git rm --cached'

# show / shortlog
alias gcount='git shortlog --summary --numbered'
alias gsh='git show'
alias gsps='git show --pretty=short --show-signature'

# stash
alias gstall='git stash --all'
alias gstaa='git stash apply'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsta='git stash push'
alias gsts='git stash show --patch'
alias gstu='gsta --include-untracked'

# submodule
alias gsi='git submodule init'
alias gsu='git submodule update'

# svn
alias gsd='git svn dcommit'
alias git-svn-dcommit-push='git svn dcommit && git push github $(git show-ref -q --verify refs/heads/main && echo main || echo master):svntrunk'
alias gsr='git svn rebase'

# tag
alias gta='git tag --annotate'
alias gts='git tag --sign'
alias gtv='git tag | sort -V'
alias gtl='git tag --sort=-v:refname -n --list'

# update-index
alias gignore='git update-index --assume-unchanged'
alias gunignore='git update-index --no-assume-unchanged'

# worktree
alias gwt='git worktree'
alias gwta='git worktree add'
alias gwtls='git worktree list'
alias gwtmv='git worktree move'
alias gwtrm='git worktree remove'

# repo root
alias grt='cd "$(git rev-parse --show-toplevel || echo .)"'

# gitk
alias gk='gitk --all --branches &'
alias gke='gitk --all $(git log --walk-reflogs --pretty=%h) &'

# misc
alias g='git'
