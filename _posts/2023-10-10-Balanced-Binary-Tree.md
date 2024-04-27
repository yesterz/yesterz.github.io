---
title: Balanced Binary Tree
date: 2023-10-10 22:03:00 +0800
author: Algorithms-Notes
categories: [Leetcode]
tags: [Easy, Sword To Offer, Tree, Depth-First Search, Binary Tree]
pin: false
math: true
mermaid: false
---

## Balanced Binary Tree

Leetcode <https://leetcode.cn/problems/balanced-binary-tree/>

### 题目描述

给定一个二叉树，判断它是否是高度平衡的二叉树。

本题中，一棵高度平衡二叉树定义为：

一个二叉树每个节点 的左右两个子树的高度差的绝对值不超过 1 。

**示例 1：**

输入：root = [3, 9, 20, null, null, 15, 7]

输出：true

**示例 2：**


输入：root = [1, 2, 2, 3, 3, null, null, 4, 4]

输出：false

**示例 3：**

输入：root = []

输出：true
 

**提示：**

1. 树中的节点数在范围 [0, 5000] 内
2. -10^4 <= Node.val <= 10^4

### 解题报告

用了 ResultType 结构来返回多个属性值。

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

    class ResultType {
        public boolean isBalanced;
        public int maxDepth;
        public ResultType(boolean isBalanced, int maxDepth) {
            this.isBalanced = isBalanced;
            this.maxDepth = maxDepth;
        } // end constructor
    } // end ReaultType

    public boolean isBalanced(TreeNode root) {
        return helper(root).isBalanced;
    } // end isBalanced

    private ResultType helper(TreeNode root) {
        if (root == null) {
            return new ResultType(true, 0);
        }

        ResultType left = helper(root.left);
        ResultType right = helper(root.right);

        // subtree is not balanced
        if (!left.isBalanced || !right.isBalanced) {
            return new ResultType(false, -1);
        }

        // root is not balanced
        if (Math.abs(left.maxDepth - right.maxDepth) > 1) {
            return new ResultType(false, -1);
        }

        return new ResultType(true, Math.max(left.maxDepth, right.maxDepth) + 1);
    } // end helper
} // end Solution
```