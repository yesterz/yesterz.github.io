---
title: Max Depth of Binary Tree
date: 2023-10-10 22:03:00 +0800
author: Algorithms-Notes
categories: [Leetcode]
tags: [Leetcode, Binary Tree]
pin: false
math: true
mermaid: false
---

## Max Depth of Binary Tree

Leetcode <https://leetcode.cn/problems/maximum-depth-of-binary-tree/>

### 题目描述

给定一个二叉树 root ，返回其最大深度。

二叉树的 最大深度 是指从根节点到最远叶子节点的最长路径上的节点数。

**示例 1：**

输入：root = [3,9,20,null,null,15,7]

输出：3

**示例 2：**

输入：root = [1,null,2]

输出：2
 

**提示：**

1. 树中节点的数量在 [0, 104] 区间内。
2. -100 <= Node.val <= 100

### 解题报告

```java
/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     int val;
 *     TreeNode left;
 *     TreeNode right;
 *     TreeNode() {}
 *     TreeNode(int val) { this.val = val; }
 *     TreeNode(int val, TreeNode left, TreeNode right) {
 *         this.val = val;
 *         this.left = left;
 *         this.right = right;
 *     }
 * }
 */
class Solution {
    public int maxDepth(TreeNode root) {
        if (root == null) {
            return 0;
        }

        int left = maxDepth(root.left);
        int right = maxDepth(root.right);

        return left > right ? left + 1 : right + 1;
    } // end maxDepth
} // end Solution
```