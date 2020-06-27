# Git Commands

*Last Update: 06/27/2020.*

## From Github Git Cheat Sheet

* [Git Cheat Sheet](https://services.github.com/on-demand/downloads/github-git-cheat-sheet.pdf)

basic

```bash
git help [command]

git config --global

git init
git clone url [dir]

git status
```

add and commit and check and re-set

```bash
git add -A
git add .  # no 'rm'
git add -u # no new files

git commit -m ""
git commit --amend
git diff
git diff --staged
git reset [file]
```

branch

```bash
git branch
git branch [new-branch-name]
git checkout [branch]
git checkout -b [new-branch-name]
git merge [branch]
git branch -d [branch-to-delete]
```

remote

```bash
git remote add origin

git fetch [bookmark]
git merge [bookmark]/[branch]
git push [alias] [branch]
git pull # git fetch + git merge
```

history

```bash
git log
git log --follow [file]
git diff [branch_a]...[branch_b]
git show [commit]
git tag
```

rm

```bash
git rm [file] # both delete from working directory and stage this deletion
git rm --cashed [file] # delete from version control
git mv [file-original] [file-new]
```

ignore

```bash
vim .gitignore # edit excluded files
git ls-files --other --ignored --exclude-standard # list excluded files
```

temporarily store changes (stash)

```bash
git stash
git stash pop
git stash list
git stash drop

git stash show -p             # default to be stash@{0}
git stash show -p stash@{1}   # can specify
git stash show -p stash@{0}^! # can specify the commit only (no parent)

# https://stackoverflow.com/questions/5506339/how-can-i-git-stash-a-specific-file#
git stash push -m <some-stash-message> -- <some-file>
```

reset

```bash
git reset [commit] # undo, locally
git reset --hard [commit] # discard all and jump back
```

## Commands

config

```bash
git config --global user.name "na"
git config --global user.email "a@b.co"

# line ending preference
git config --global core.autocrlf input
git config --global core.safecrlf true
```

fetch

```bash
# fetch a PR and create a read-only branch
git fetch origin pull/<pull request ID>/head:<some new branch name to create>
```

log

```bash
git log --pretty=oneline
git log --pretty=oneline --all
git log --pretty=oneline --max-count=2 --since='1024 minutes ago' --until='256 minutes ago' --author=<Mike>
git log --all --pretty=format:'%h %cd %s (%an)' --since='1 days ago'
git log --pretty=format:'%h %ad - %s%d [%an]' --graph --date=short
# in .gitconfig, under [alias], add "history = log --pretty=format:'%h %ad - %s%d [%an]' --graph --date=short"
git log --graph --date=short master --all
```

look at an old state without affecting current working directory

```bash
git checkout [hash-of-previous-commits]
git checkout master # go back to master
```

tag

```bash
git tag # list tags
git tag v0 # tag current version as v0
# checkout to the first ancestor of a tag
git checkout v0^
git checkout v0~1
```

edit

```bash
# amend the last commit message
git commit --amend
## cleanup the whitespace (not the default lines beginning with '#')
## in the commit messages, i.e. keep '#' in commit messages
git commit --cleanup=whitespace
## https://git-scm.com/docs/git-commit#Documentation/git-commit.txt-scissors
git commit --cleanup=scissors

# discard unstaged changes
## make changes to a.b
## start to undo
git checkout a.b

# undo uncommitted changes
## make changes to a.b
git add a.b
## start to undo
git reset HEAD a.b # reset the staging area to be the version in HEAD
# reset does not change working directory
git checkout a.b # checkout the file

# undo committed changes with writing to history
## make changes to a.b
git add a.b
git commit -m "Bad Commit!"
## start to undo
git revert HEAD # or the hash of other previous commits
## git revert HEAD --no-edit

# undo committed changes without writing to history
## git reset [reference-of-commit] # Rewrite the current branch to point to that commit
# ... (making mistakes and committing mistakes)
git tag to-remove
git reset --hard to-remove^ # can use other reference
## -hard: working directory should be updated to be consistent with the new branch head
## the bad commits are still in history
## https://stackoverflow.com/questions/9529078/how-do-i-use-git-reset-hard-head-to-revert-to-a-previous-commit
git tag -d to-remove # delete the tag

# How do I undo the most recent commits in Git?
# https://stackoverflow.com/questions/927358/how-do-i-undo-the-most-recent-commits-in-git/34547846
git reset --soft HEAD~1 # For a local commit
git rm --cached <file> # don't know which commit it was
# For a pushed commit
git filter-branch --index-filter 'git rm --cached <file>' HEAD # use with care
# see https://www.kernel.org/pub/software/scm/git/docs/git-filter-branch.html
```

diff

```bash
# check which files changed
git diff --name-status branch_a..branch_b
# check diff of a file in different branches 
# https://stackoverflow.com/questions/4099742/how-to-compare-files-from-two-different-branches
git diff branch_a branch_b -- some.file
git diff branch_a..branch_b -- some.file
# print statistics
git diff --numstat
```

clean

```bash
# remove local untracked files
# must have -i -n -f options to run this command
git clean -n   # dry run
git clean -f   # remove files
git clean -fd  # remove files and directory
git clean -fX  # remove ignored files
git clean -fdX # remove ignored files and directory
git clean -fdx # remove ignored and non-ignored files and directory
```

* [Git workflow and rebase vs merge questions](https://stackoverflow.com/questions/457927/git-workflow-and-rebase-vs-merge-questions)
* [When do you use git rebase instead of git merge?](https://stackoverflow.com/questions/804115/when-do-you-use-git-rebase-instead-of-git-merge)
* [What does cherry-picking a commit with Git mean?](https://stackoverflow.com/questions/9339429/what-does-cherry-picking-a-commit-with-git-mean)
* [Git Cherry-pick vs Merge Workflow](https://stackoverflow.com/questions/1241720/git-cherry-pick-vs-merge-workflow)

```bash
git rebase -i
git cherry-pick [commit_hash]
```

credential

```bash
# NOT SAFE: store the password/token in **unencrypted** text files
# ~/.git-credentials
# "https://user:pass@example.com"
git config credential.helper store
```

## Miscellaneous

Apply .gitignore

* [Apply gitignore on an existing repository already tracking large number of files](https://stackoverflow.com/questions/19663093/apply-gitignore-on-an-existing-repository-already-tracking-large-number-of-files)

```bash
## commit *ALL* changes first
git rm -r --cached .
git add .
git commit -m ".gitignore is now working"
# git push origin
```

[Set CRLF of git to LF on Windows](https://stackoverflow.com/questions/2517190/how-do-i-force-git-to-use-lf-instead-of-crlf-under-windows)

Push up to a commit

* can be combined with `git rebase -i`
* fails if remote branch not exist, create one first
* [How can I push a specific commit to a remote, and not previous commits?](https://stackoverflow.com/questions/3230074/how-can-i-push-a-specific-commit-to-a-remote-and-not-previous-commits)

```bash
git push <remote> <commit SHA>:<remote-branch>

# auto create a remote branch
git push <remote> <commit SHA>:refs/heads/<remote-branch>
```
