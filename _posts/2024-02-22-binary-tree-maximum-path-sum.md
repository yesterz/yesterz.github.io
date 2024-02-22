---
title: Binary Tree Maximum Path Sum
date: 2024-02-22 06:53:00 +0800
author: Algorithms-Notes
categories: [Algorithms, LeetCode Hot 100]
tags: [Medium, top-100-liked, Tree, Depth-First Search, Dynamic Programming, Binary Tree]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/binary-tree-maximum-path-sum/>

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

    private int max = Integer.MIN_VALUE;
    public int maxPathSum(TreeNode root) {
        maxPathSumHelper(root);
        return max;
    }
    private int maxPathSumHelper(TreeNode root) {
        if (root == null) {
            return 0;
        }

        // Step 1
        int left = maxPathSumHelper(root.left);
        int right = maxPathSumHelper(root.right);

        // Step 2
        left = left < 0 ? 0 : left;
        right = right < 0 ? 0 : right;
        max = Math.max(max, root.val + left + right);

        // Step 3
        return root.val + Math.max(left, right);
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(height) 