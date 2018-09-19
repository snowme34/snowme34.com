---
title: No Scary Git
date: 2018-04-09 22:31:43
categories: 
- Notes
- Programming Basis
tags: [Tutorial, Git]
sidebar: toc
copyright: true
comments: true
---
All you need to know to work on Github with very small team in 3 min.

# Sign up

[Join GitHub](https://github.com/join?source=header-home)

# Create Repo

[Create a new repository](https://github.com/new)

Give repo name. Can be changed later.

* Public

  Anyone can see

* Private

  You control who can see

* README

  The first page people see when open your repo. Usually in Markdown

# Invite

repo's settings -> Collaborator -> [type Github account] -> invite

(optional) copy invite link
(or create one: https://github.com/[Your User Name]/[Your Repo Name]/invitations)

# Join

Click the invitation link

# Fetch files from Github to local

``` bash
git clone https://github.com/[Your User Name]/[Your Repo Name].git
```

If you are not owner or collaborator, you need to **fork** the repo and clone from your repo.
If you just want to download other's repo, use their ".git" link found in **Clone or download**, the big green button.

# Edit files

Use your editor.

# Save the changes (commit)

Commit is to "save your changes".

One reason why we use git is because it can revert changes and it separates "your currently working tree" and "committed files" that are stored in ".git" folder.

(in the root dir of the repo in your local)

``` bash
git add .
git commit -m "[A Message for this commit]"
```

"git add ." actually "stages" the files. But you don't need to know the difference right now.

# Upload your changes

``` bash
git push origin master
```

origin is the upstream.

master is the name of the branch you are working on.

If you are owner of collaborators, you can choose to make the change instantly (you have other choices in **settings**).

If you are not, you need to push to your repo and create a **Pull Request** in the original repo to actually contribute your changes.

# Download Changes of Other People

``` bash
git pull origin
```

# Start from Local

Initialize an empty local git repo

``` bash
git init
```

Maybe you also need to set the upstream too. Just follow the instruction.

# Best Friend

``` bash
git help [command]
```

# External Links

[git - the simple guide - no deep shit!](https://rogerdudler.github.io/git-guide/)
[Pro Git](https://git-scm.com/book/en/v2)
[Git 指南](http://yqrashawn.com/2016/10/09/git-tutorial/)