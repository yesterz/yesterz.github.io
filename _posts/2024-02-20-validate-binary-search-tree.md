---
title: Validate Binary Search Tree
date: 2024-02-20 08:04:00 +0800
author: Algorithms-Notes
categories: [Algorithms, LeetCode Hot 100]
tags: [Easy, top-100-liked, Tree, Depth-First Search, Binary Search Tree, Binary Tree]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/validate-binary-search-tree/>

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
    public boolean isValidBST(TreeNode root) {
        if (root == null) {
            return true;
        }

        return isBSTHelper(root, Long.MIN_VALUE, Long.MAX_VALUE);
    }

    public boolean isBSTHelper(TreeNode root, long lo, long hi) {
        if (root == null) {
            return true;
        }
        if (root.val <= lo || root.val >= hi) {
            return false;
        }

        return isBSTHelper(root.left, lo, root.val) && isBSTHelper(root.right, root.val, hi);
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(height) 

----

这道题有一个测试用例 `[2147483647]` 如果边界范围不够大，这个用例过不了。。。