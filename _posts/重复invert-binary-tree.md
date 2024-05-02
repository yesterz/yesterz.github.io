---
title: Invert Binary Tree
date: 2024-05-01 13:38:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Easy, Sword To Offer, Tree, Depth-First Search, Breadth-First Search, Binary Tree]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/invert-binary-tree/>

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
    
    public TreeNode invertTree(TreeNode root) {

        // base case
        if (root == null) {
            return root;
        }

        TreeNode left = invertTree(root.left);
        TreeNode right = invertTree(root.right);

        root.left = right;
        root.right = left;

        return root;
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(Height) 

---