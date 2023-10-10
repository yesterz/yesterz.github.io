---
title: Lowest Common Ancesstor
date: 2023-10-10 22:03:00 +0800
author: Algorithms-Notes
categories: [Leetcode]
tags: [Leetcode, Binary Tree]
pin: false
math: true
mermaid: false
---

最近公共祖先（Lowest Common Ancestor，简称 LCA）。

git pull 这个命令我们经常会用，它默认是使用 merge 方式将远端别人的修改拉到本地；如果带上参数 git pull -r，就会使用 rebase 的方式将远端修改拉到本地。

这二者最直观的区别就是：merge 方式合并的分支会看到很多「分叉」，而 rebase 方式合并的分支就是一条直线。但无论哪种方式，如果存在冲突，Git 都会检测出来并让你手动解决冲突。

那么问题来了，Git 是如何检测两条分支是否存在冲突的呢？

以 rebase 命令为例，我站在 dev 分支执行 git rebase master，然后 dev 就会接到 master 分支之上：


这个过程中，Git 是这么做的：

首先，找到这两条分支的最近公共祖先 LCA，然后从 master 节点开始，重演 LCA 到 dev 几个 commit 的修改，如果这些修改和 LCA 到 master 的 commit 有冲突，就会提示你手动解决冲突，最后的结果就是把 dev 的分支完全接到 master 上面。

那么，Git 是如何找到两条不同分支的最近公共祖先的呢？

## Lowest Common Ancesstor

Leetcode <https://leetcode.cn/problems/lowest-common-ancestor-of-a-binary-tree/>

### 题目描述

给定一个二叉树, 找到该树中两个指定节点的最近公共祖先。

百度百科中最近公共祖先的定义为：“对于有根树 T 的两个节点 p、q，最近公共祖先表示为一个节点 x，满足 x 是 p、q 的祖先且 x 的深度尽可能大（一个节点也可以是它自己的祖先）。”

**示例 1：**

输入：root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 1

输出：3

解释：节点 5 和节点 1 的最近公共祖先是节点 3 。

**示例 2：**

输入：root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 4

输出：5

解释：节点 5 和节点 4 的最近公共祖先是节点 5 。因为根据定义最近公共祖先节点可以为节点本身。

**示例 3：**

输入：root = [1,2], p = 1, q = 2

输出：1
 
**提示：**

1. 树中节点数目在范围 [2, 105] 内。
2. -109 <= Node.val <= 109
3. 所有 Node.val 互不相同 。
4. p != q
5. p 和 q 均存在于给定的二叉树中。

### 解题报告

在root为根的二叉树中找A,B的LCA:

1. 如果找到了就返回这个LCA
2. 如果只碰到A，就返回A
3. 如果只碰到B，就返回B
4. 如果都没有，就返回null

```java
/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     int val;
 *     TreeNode left;
 *     TreeNode right;
 *     TreeNode(int x) { val = x; }
 * }
 */
class Solution {
    public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
        if (root == null || root == p || root == q) {
            return root;
        }

        // Divide
        TreeNode left = lowestCommonAncestor(root.left, p, q);
        TreeNode right = lowestCommonAncestor(root.right, p, q);

        // Conquer
        if (left != null && right != null) {
            return root;
        }
        if (left != null) {
            return left;
        }
        if (right != null) {
            return right;
        }

        return null;
    } // end lowestCommonAncestor
} // end Solution
```

## Lowest Common Ancesstor II

这道题要会员！

Leetcode <https://leetcode.cn/problems/lowest-common-ancestor-of-a-binary-tree-ii/>

### 题目描述

这个节点定义是带父节点的

```java
public class TreeNode {
     int val;
     TreeNode left;
     TreeNode right;
     TreeNode parent;
     TreeNode(int x) { val = x; }
}
```

给一棵二叉树和二叉树中的两个节点，找到这两个节点的最近公共祖先LCA。

两个节点的最近公共祖先，是指两个节点的所有父亲节点中（包括这两个节点），离这两个节点最近的公共的节点。

每个节点除了左右儿子指针以外，还包含一个父亲指针parent，指向自己的父亲。

### 解题报告

两个节点都遍历到同一个高度 root 的路径，然后再一起往下走，如果两个节点的路径分叉了，说明 LCA 就是这个位置。

```java
/**
 * Definition of ParentTreeNode:
 * 
 * class ParentTreeNode {
 *     public ParentTreeNode parent, left, right;
 * }
 */
public class Solution {
    /**
     * @param root: The root of the tree
     * @param A, B: Two node in the tree
     * @return: The lowest common ancestor of A and B
     */
    public ParentTreeNode lowestCommonAncestorII(ParentTreeNode root,
                                                 ParentTreeNode A,
                                                 ParentTreeNode B) {
        ArrayList<ParentTreeNode> pathA = getPath2Root(A);
        ArrayList<ParentTreeNode> pathB = getPath2Root(B);
        
        int indexA = pathA.size() - 1;
        int indexB = pathB.size() - 1;
        
        ParentTreeNode lowestAncestor = null;
        while (indexA >= 0 && indexB >= 0) {
            if (pathA.get(indexA) != pathB.get(indexB)) {
                break;
            }
            lowestAncestor = pathA.get(indexA);
            indexA--;
            indexB--;
        } // end while loop
        
        return lowestAncestor;
    } // end lowestCommonAncestorII
    
    private ArrayList<ParentTreeNode> getPath2Root(ParentTreeNode node) {
        ArrayList<ParentTreeNode> path = new ArrayList<>();
        while (node != null) {
            path.add(node);
            node = node.parent;
        }
        return path;
    } // end getPath2Root
} // end Solution
```

## Lowest Common Ancesstor III


### 题目描述

给一棵二叉树和二叉树中的两个节点，找到这两个节点的最近公共祖先LCA。

两个节点的最近公共祖先，是指两个节点的所有父亲节点中（包括这两个节点），离这两个节点最近的公共的节点。

返回 null 如果两个节点在这棵树上不存在最近公共祖先的话。

1. 这两个节点未必都在这棵树上出现。
2. 每个节点的值都不同

```java
//输入: 
{4, 3, 7, #, #, 5, 6}
3 5
5 6
6 7 
5 8
//输出: 
4
7
7
null
//解释:
  4
 / \
3   7
   / \
  5   6

LCA(3, 5) = 4
LCA(5, 6) = 7
LCA(6, 7) = 7
LCA(5, 8) = null
```


### 解题报告

```java

```


## Lowest Common Ancestor of a Binary Search Tree


### 题目描述


### 解题报告


```java

```