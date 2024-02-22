---
title: Lowest Common Ancestor of a Binary Tree
date: 2024-02-22 06:53:00 +0800
author: Algorithms-Notes
categories: [Algorithms, LeetCode Hot 100]
tags: [Medium, top-100-liked, Tree, Depth-First Search, Binary Tree]
pin: false
math: false
mermaid: true
---

## Description

LeetCode <https://leetcode.cn/problems/lowest-common-ancestor-of-a-binary-tree/>

Given a binary tree, find the lowest common ancestor (LCA) of two given nodes in the tree.

According to the [definition of LCA on Wikipedia](https://en.wikipedia.org/wiki/Lowest_common_ancestor): “The lowest common ancestor is defined between two nodes p and q as the lowest node in T that has both p and q as descendants (where we allow a node to be a descendant of itself).”

 

### Example 1:

```mermaid
graph TD
    A((3))
    B((5))
    C((1))
    D((6))
    E((2))
    F((0))
    G((8))
    H((7))
    I((4))
    A --> B
    A --> C
    B --> D
    B --> E
    C --> F
    C --> G
    E --> H
    E --> I
```

Input: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 1

Output: 3

Explanation: The LCA of nodes 5 and 1 is 3.

### Example 2:

```mermaid
graph TD
    A((3))
    B((5))
    C((1))
    D((6))
    E((2))
    F((0))
    G((8))
    H((7))
    I((4))
    A --> B
    A --> C
    B --> D
    B --> E
    C --> F
    C --> G
    E --> H
    E --> I
```

Input: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 4

Output: 5

Explanation: The LCA of nodes 5 and 4 is 5, since a node can be a descendant of itself according to the LCA definition.

### Example 3:

Input: root = [1,2], p = 1, q = 2

Output: 1
 

### Constraints:

* The number of nodes in the tree is in the range [2, 105].
* -109 <= Node.val <= 109
* All Node.val are unique.
* p != q
* p and q will exist in the tree.


```java
/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     int val;
 *     TreeNode left;
 *     TreeNode right;
 *     TreeNode(int x) { val = x; }
 * }
 */
class Solution {
    public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
        if (root == null || p == root || q == root) {
            return root;
        }

        TreeNode left = lowestCommonAncestor(root.left, p, q);
        TreeNode right = lowestCommonAncestor(root.right, p, q);

        if (left != null && right != null) {
            return root;
        }

        return left == null ? right : left;
    }
}
```


**Complexity**

* Time = O(n) 
* Space = O(height) 