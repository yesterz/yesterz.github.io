---
title: Diameter of Binary Tree
date: 2024-02-19 07:51:00 +0800
author: Algorithms-Notes
categories: [Algorithms, LeetCode Hot 100]
tags: [Easy, Depth-First Search, Binary Tree]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/diameter-of-binary-tree/>

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
    public int diameterOfBinaryTree(TreeNode root) {
        
        int[] maxValue = { 0 };
        maxPathLength(root, maxValue);

        return maxValue[0];
    }

    public int maxPathLength(TreeNode root, int[] maxValue) {
        // base case
        if (root == null) {
            return 0;
        }

        int lCost = maxPathLength(root.left, maxValue);
        int rCost = maxPathLength(root.right, maxValue);
        int currCost = lCost + rCost;
        maxValue[0] = Math.max(maxValue[0], currCost);

        return Math.max(lCost, rCost) + 1;
    }
}
```