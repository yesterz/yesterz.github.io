---
title: Kth Smallest Element in a BST
date: 2024-02-20 08:04:00 +0800
author: Algorithms-Notes
categories: [Algorithms, LeetCode Hot 100]
tags: [Medium, top-100-liked, Tree, Depth-First Search, Binary Search Tree, Binary Tree]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/kth-smallest-element-in-a-bst/>

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
    public int kthSmallest(TreeNode root, int k) {
        ArrayList<Integer> inorderSequence = new ArrayList<>();

        helper(root, inorderSequence);

        return inorderSequence.get(k - 1);
    }

    public void helper(TreeNode root, ArrayList<Integer> arr) {
        if (root == null) {
            return;
        }

        helper(root.left, arr);
        arr.add(root.val);
        helper(root.right, arr);
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(height) 