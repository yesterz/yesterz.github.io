---
title: 常用 git 操作
date: 2023-10-16 20:10:00 +0800
author: 
categories: [Git]
tags: [Git]
pin: false
math: true
mermaid: false
---

```sh
git init #在当前目录新建一个 Git 代码库

git clone [url]  # 下载一个项目和它的整个代码历史

git config --list # 显示当前的 Git 配置

git config -e [--global]  # 编辑 Git 配置文件

git add  # 添加指定文件到暂存区

git add -u # 只添加modified的文件到暂存区

git rm   # 删除工作区文件，并且将这次删除放入暂存区

git commit -m [message]  # 提交暂存区到仓库区

git commit -a # 提交工作区自上次 commit 之后的变化，直接到仓库区

git commit --amend -m [message]   # 使用一次新的 commit，替代上一次提交
如果代码没有任何新变化，则用来改写上一次 commit 的提交信息

git commit --amend [file1] [file2] ...  # 重做上一次 commit，并包括指定文件的新变化
```

[] 下面内容重新合并过来

git rebase http://gitbook.liuhui998.com/4_2.html

合并多个commit： https://blog.csdn.net/itfootball/article/details/44154121

```sh
# 分支相关

git branch  # 列出所有本地分支

git branch -r  # 列出所有远程分支

git branch [branch-name]  # 新建一个分支，但依然停留在当前分支

git checkout [branch-name]  # 切换到指定分支，并更新工作区

git checkout -b [branch]  # 新建一个分支，并切换到该分支

git branch [branch] [commit]  # 新建一个分支，指向指定 commit

git checkout -b [branch] [tag]  # 新建一个分支，指向某个 tag

git branch --track [branch] [remote-branch]  # 新建一个分支，与指定的远程分支建立追踪关系

git branch --set-upstream [branch] [remote-branch]  # 建立追踪关系，在现有分支与指定的远程分支之间

git merge [branch]  # 合并指定分支到当前分支

git cherry-pick [commit]  # 选择一个 commit，合并进当前分支

git branch -d [branch-name]  # 删除分支

git push origin --delete [branch-name] # 删除远程分支

git branch -dr [remote/branch]  # 删除远程分支
```

```sh
# 标签

git tag  # 列出所有 tag

git tag [tag] # 新建一个 tag 在当前 commit

git tag [tag] [commit] # 新建一个 tag 在指定 commit

git show [tag]  # 查看 tag 信息

git push [remote] [tag]  # 提交指定 tag

git push [remote] --tags   # 提交所有 tag
```

```sh
# 查看

git status # 显示有变更的文件

git log # 显示当前分支的版本历史

git log --stat # 显示 commit 历史，以及每次 commit 发生变更的文件

git log --follow [file] # 显示某个文件的版本历史，包括文件改名

git log -p [file] # 显示指定文件相关的每一次 diff

git blame [file] # 显示指定文件是什么人在什么时间修改过

git diff # 显示暂存区和工作区的差异

git diff --cached [file] # 显示暂存区和上一个 commit 的差异

git diff HEAD # 显示工作区与当前分支最新 commit 之间的差异

git diff [first-branch]...[second-branch] # 显示两次提交之间的差异

git show [commit] # 显示某次提交的元数据和内容变化

git show --name-only [commit] # 显示某次提交发生变化的文件

git show [commit]:[filename] # 显示某次提交时，某个文件的内容

git reflog # 显示当前分支的最近几次提交
```

```sh
# 远程

git fetch [remote] # 下载远程仓库的所有变动

git remote -v  # 显示所有远程仓库

git remote show [remote]  # 显示某个远程仓库的信息

git remote add [shortname] [url]  # 增加一个新的远程仓库，并命名

git pull [remote] [branch]  # 取回远程仓库的变化，并与本地分支合并

git push [remote] [branch] # 上传本地指定分支到远程仓库

git push [remote] --force # 强行推送当前分支到远程仓库，即使有冲突

git push [remote] --all # 推送所有分支到远程仓库
```

```sh
# 撤销
 
git checkout [file] # 恢复暂存区的指定文件到工作区
 
git checkout [commit] [file] # 恢复某个 commit 的指定文件到工作区
 
git checkout . # 恢复上一个 commit 的所有文件到工作区
 
git reset [file] # 重置暂存区的指定文件，与上一次 commit 保持一致，但工作区不变
 
git reset        # 不删除工作空间改动代码，撤销commit，并且撤销git add . 操作
 
git reset --hard # 重置暂存区与工作区，与上一次 commit 保持一致
 
git reset --soft # 不删除工作空间改动代码，撤销commit，不撤销git add .
 
git reset [commit] # 重置当前分支的指针为指定 commit，同时重置暂存区，但工作区不变
 
git reset --hard [commit] # 重置当前分支的 HEAD 为指定 commit，同时重置暂存区和工作区，与指定 commit 一致
 
git reset --keep [commit] # 重置当前 HEAD 为指定 commit，但保持暂存区和工作区不变
 
git revert [commit] # 新建一个 commit，用来撤销指定 commit，后者的所有变化都将被前者抵消，并且应用到当前分支
```

```sh
git clean -f    # 删除 untracked files

git clean -fd   # 连 untracked 的目录也一起删掉

git clean -xfd  # 连 gitignore 的untrack 文件/目录也一起删掉 （慎用，一般这个是用来删掉编译出来的 .o之类的文件用的）

# 在用上述 git clean 前，强烈建议加上 -n 参数来先看看会删掉哪些文件，防止重要文件被误删
git clean -nf
git clean -nfd
git clean -nxfd
```