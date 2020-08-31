alias ga='git add'
alias gap='git add -p'
alias gb='git branch'
alias gba='git branch -a'
alias gbav='git branch -avv'
alias gbd='git branch -d'
alias gbv='git branch -vv'
alias gk='git checkout'
alias gkb='git checkout -b'
alias gq='git cherry-pick'
alias gc='git commit -m'
alias gd='git diff'
alias gdc='git diff --cached'
alias gdn='git diff --name-only'
alias gdt='git difftool'
alias gf='git fetch'
alias gfa='git fetch --all'
alias gfp='git fetch --prune'
alias gfap='git fetch --all --prune'
alias gg='git grep'
alias gi='git init'
alias gl='git log --decorate --oneline --graph --color'
alias gld='git log --decorate --oneline --graph --color --boundary'
alias gldl='git log --decorate --graph --color --boundary'
alias gll='git log --decorate --graph --color'
alias gls='git ls-tree --name-only -r $args'
alias gmg='git merge'
alias gv='git mv'
alias gu='git pull'
alias gp='git push'
alias gpu='git push -u'
alias ge='git rebase'
alias gei='git rebase --interactive'
alias go='git remote -v'
alias goa='git remote add'
alias gr='git reset'
alias gw='git show'
alias gh='git stash'
alias gha='git stash apply'
alias ghl='git stash list'
alias ghp='git stash pop'
alias gs='git status'
alias gt='git tag'

if [ -f ~/.git-completion.bash ]; then
	__git_complete ga _git_add
	__git_complete gap _git_add
	__git_complete gb _git_branch
	__git_complete gba _git_branch
	__git_complete gbav _git_branch
	__git_complete gbd _git_branch
	__git_complete gbv _git_branch
	__git_complete gk _git_checkout
	__git_complete gkb _git_checkout
	__git_complete gq _git_cherry_pick
	__git_complete gc _git_commit
	__git_complete gd _git_diff
	__git_complete gdc _git_diff
	__git_complete gdn _git_diff
	__git_complete gdt _git_difftool
	__git_complete gf _git_fetch
	__git_complete gfa _git_fetch
	__git_complete gfp _git_fetch
	__git_complete gfap _git_fetch
	__git_complete gg _git_grep
	__git_complete gi _git_init
	__git_complete gl _git_log
	__git_complete gld _git_log
	__git_complete gldl _git_log
	__git_complete gll _git_log
	__git_complete gls _git_ls_tree
	__git_complete gmg _git_merge
	__git_complete gv _git_mv
	__git_complete gu _git_pull
	__git_complete gp _git_push
	__git_complete gpu _git_push
	__git_complete ge _git_rebase
	__git_complete gei _git_rebase
	__git_complete go _git_remote
	__git_complete goa _git_remote
	__git_complete gr _git_reset
	__git_complete gw _git_show
	__git_complete gh _git_stash
	__git_complete gha _git_stash
	__git_complete ghl _git_stash
	__git_complete ghp _git_stash
	__git_complete gs _git_status
	__git_complete gt _git_tag
fi
