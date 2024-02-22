---
title: Path Sum III
date: 2024-02-22 06:53:00 +0800
author: Algorithms-Notes
categories: [Algorithms, LeetCode Hot 100]
tags: [Medium, top-100-liked, Tree, Depth-First Search, Binary Tree]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/path-sum-iii/>


## naive

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
    public int pathSum(TreeNode root, int targetSum) {
        if (root == null) {
            return 0;
        }

        int res = pathSumHelper(root, (long)targetSum);
        res += pathSum(root.left, targetSum);
        res += pathSum(root.right, targetSum);

        return res;
    }

    private int pathSumHelper(TreeNode root, Long targetSum) {
        int res = 0;

        if (root == null) {
            return 0;
        }
        int val = root.val;
        if (val == targetSum) {
            res++;
        }

        res += pathSumHelper(root.left, targetSum - val);
        res += pathSumHelper(root.right, targetSum - val);

        return res;
    }
}
```

**Complexity**

* Time = O(n^2) 
* Space = O(height) 

## prefix sum

- [ ] prefix sum solution