---
title: Binary Tree Level Order Traversal
date: 2024-02-18 08:44:00 +0800
author: Algorithms-Notes
categories: [Algorithms, LeetCode Hot 100]
tags: [Medium, top-100-liked, Tree, Breadth-First Search, Binary Tree]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/binary-tree-level-order-traversal/>

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
    public List<List<Integer>> levelOrder(TreeNode root) {

        List<List<Integer>> results = new ArrayList<>();
        if (root == null) {
            return results;
        }

        Queue<TreeNode> queue = new LinkedList<>();
        queue.offer(root);

        while (!queue.isEmpty()) {
            List<Integer> level = new ArrayList<>();
            int size = queue.size();
            for (int i = 0; i < size; i++) {
                TreeNode current = queue.poll();
                if (current.left != null) {
                    queue.offer(current.left);
                }
                if (current.right != null) {
                    queue.offer(current.right);
                }
                level.add(current.val);
            }
            results.add(level);
        }

        return results;
    }
}
``

**Complexity**

* Time = O(n) 
* Space = O(n) 