---
title: Construct Binary Tree from Preorder and Inorder Traversal
date: 2024-02-21 06:53:00 +0800
author: Algorithms-Notes
categories: [Algorithms, LeetCode Hot 100]
tags: [Medium, top-100-liked, Tree, Array, Hash Table, Divide and Conquer, Binary Tree]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/construct-binary-tree-from-preorder-and-inorder-traversal/>

| Index | 0 | 1 | 2 | 3 | 4 | 5 | 6 |
|-------|---|---|---|---|---|---|---|
| Preorder | 10 | 5 | 2 | 7 | 15 | 12 | 20 |
| Inorder | 2 | 5 | 7 | 10 | 12 | 15 | 20 |


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
    public TreeNode buildTree(int[] preorder, int[] inorder) {
        Map<Integer, Integer> map = new HashMap<>();
        for (int i = 0; i < inorder.length; i++) {
            map.put(inorder[i], i);
        }

        return buildTreeHelper(preorder, inorder, 0, inorder.length -1, 0, 
          preorder.length - 1, map);
    }

    private TreeNode buildTreeHelper(int[] preorder, int[] inorder,
     int inL, int inR, int preL, int preR, Map<Integer, Integer> map) {
        // base case
        if (inL > inR) {
            return null;
        }

        TreeNode root = new TreeNode(preorder[preL]);
        int size = map.get(preorder[preL]) - inL;
        root.left = buildTreeHelper(preorder, inorder, inL, inL + size -1, 
          preL + 1, preL + size, map);
        root.right = buildTreeHelper(preorder, inorder, inL + size + 1, inR, 
          preL + 1 + size, preR, map);
        
        return root;
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(n) 