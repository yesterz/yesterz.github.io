---
title: Path Sum II
date: 2024-05-01 13:38:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Medium, Sword To Offer, Tree, Depth-First Search, Backtracking, Binary Tree]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/path-sum-ii/>

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

    public List<List<Integer>> pathSum(TreeNode root, int targetSum) {

        if (root == null) {
            return new ArrayList<>();
        }

        List<List<Integer>> res = new ArrayList<>();
        List<Integer> curr = new ArrayList<>();

        pathSumHelper(root, targetSum, curr, res);

        return res;
    }

    private void pathSumHelper(TreeNode root, int target, List<Integer> path, List<List<Integer>> result) {
        
        if (root == null) {
            return;
        }

        path.add(root.val);
        target -= root.val;
        if (target == 0 && root.left == null && root.right == null) {
            result.add(new ArrayList<Integer>(path));
        }
        pathSumHelper(root.left, target, path, result);
        pathSumHelper(root.right, target, path, result);
        path.remove(path.size() - 1);
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(height) 

---