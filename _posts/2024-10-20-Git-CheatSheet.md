---
title: Git CheatSheet
categories: [Uncategorized]
tags: [Uncategorized]
toc: true
media_subpath: 
---

## SETUP

Configuring user information used across all local repositories 

1. git config --global user.name “[firstname lastname]” 

set a name that is identifiable for credit when review version history 

2. git config --global user.email “[valid-email]” 

set an email address that will be associated with each history marker 

3. git config --global color.ui auto 

set automatic command line coloring for Git for easy reviewing



## SETUP & INIT

Configuring user information, initializing and cloning repositories 

1. git init 

initialize an existing directory as a Git repository 

2. git clone [url] 

retrieve an entire repository from a hosted location via URL



## STAGE & SNAPSHOT

Working with snapshots and the Git staging area git status show modified files in working directory, staged for your next commit 

1. git add [file] 

add a file as it looks now to your next commit (stage) 

2. git reset [file] 

unstage a file while retaining the changes in working directory 

3. git diff 

diff of what is changed but not staged 

4. git diff --staged 

diff of what is staged but not yet committed 

5. git commit -m “[descriptive message]” 

commit your staged content as a new commit snapshot



## BRANCH & MERGE

Isolating work in branches, changing context, and integrating changes git branch list your branches. a * will appear next to the currently active branch

1. git branch

   List all of the branches in your repo. Add a  argument to create a new branch with the name.

2. git branch [branch-name] 

​	create a new branch at the current commit.

3. git checkout 

​	switch to another branch and check it out into your working directory.

4. git checkout -b 

​	Create and check out a new branch named . Drop the -b flag to checkout an existing branch.

5. git merge [branch] 

​	merge the specified branch’s history into the current one 

6. git log 

​	show all commits in the current branch’s history



