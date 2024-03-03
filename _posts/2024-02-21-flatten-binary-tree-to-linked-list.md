---
title: Flatten Binary Tree to Linked List
date: 2024-02-21 06:53:00 +0800
author: Algorithms-Notes
categories: [Algorithms, LeetCode Hot 100]
tags: [Medium, top-100-liked, Stack, Tree, Depth-First Search, Linked List, Binary Tree]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/flatten-binary-tree-to-linked-list/>

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
    public void flatten(TreeNode root) {
        if (root == null) {
            return;
        }
        ArrayList<TreeNode> preorder = new ArrayList<>();
        flattenHelper(root, preorder);
        TreeNode current = root;
        for (int i = 0; i < preorder.size() - 1; i++) {
            current.left = null;
            current.right = preorder.get(i + 1);
            current = preorder.get(i + 1);
        }
    }

    private void flattenHelper(TreeNode root, ArrayList<TreeNode> preorder) {
        if (root == null) {
            return;
        }
        preorder.add(root);
        flattenHelper(root.left, preorder);
        flattenHelper(root.right, preorder);
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(n) 