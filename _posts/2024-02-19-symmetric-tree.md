---
title: Symmetric Tree
date: 2024-02-19 07:48:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Easy, top-100-liked, Sword To Offer, Depth-First Search, Breadth-First Search, Binary Tree]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/symmetric-tree/>

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
    public boolean isSymmetric(TreeNode root) {
        if (root == null) {
            return true;
        }

        return symmetricHelper(root.left, root.right);
    }

    public boolean symmetricHelper(TreeNode left, TreeNode right) {
        
        if (left == null && right == null) {
            return true;
        } else if (left == null || right == null) {
            return false;
        } else if (left.val != right.val) {
            return false;
        }

        return symmetricHelper(left.left, right.right) && symmetricHelper(left.right, right.left);
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(height) 