---
title: Binary Tree Traversal
date: 2023-10-10 21:03:00 +0800
author: Algorithms-Notes
categories: [Leetcode]
tags: [Leetcode, Binary Tree]
pin: false
math: true
mermaid: false
---

## Preorder Traverse

Leetcode <https://leetcode.cn/problems/binary-tree-preorder-traversal/>

### 题目描述

给你二叉树的根节点 root ，返回它节点值的 前序 遍历。

**示例 1：**

输入：root = [1, null, 2, 3]

输出：[1, 2, 3]

**示例 2：**

输入：root = []

输出：[]

**示例 3：**

输入：root = [1]

输出：[1]

**示例 4：**

输入：root = [1, 2]

输出：[1, 2]

**示例 5：**

输入：root = [1, null, 2]

输出：[1, 2]
 

**提示：**

1. 树中节点数目在范围 [0, 100] 内
2. -100 <= Node.val <= 100
 

进阶：递归算法很简单，你可以通过迭代算法完成吗？

### 解题报告

* Recursion

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
    public List<Integer> preorderTraversal(TreeNode root) {
        List<Integer> results = new ArrayList<>();
        helper(root, results);

        return results;
    } // end preorderTraversal

    public void helper(TreeNode root, List<Integer> results) {
        if (root == null) {
            return;
        }
        results.add(root.val);
        helper(root.left, results);
        helper(root.right, results);
    } // end helper
} // end Solution
```

* Divide Conquer
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
    public List<Integer> preorderTraversal(TreeNode root) {
        List<Integer> res = new ArrayList<>();
        // null or leaf
        if (root == null) {
            return res;
        }

        // Divide
        List<Integer> left = preorderTraversal(root.left);
        List<Integer> right = preorderTraversal(root.right);

        // Conquer
        res.add(root.val);
        res.addAll(left);
        res.addAll(right);

        return res;
    } // end preorderTraversal
} // end Solution
```

* Non-Recursion (Recommend)

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
    public List<Integer> preorderTraversal(TreeNode root) {
        Stack<TreeNode> stack = new Stack<>();
        List<Integer> preorder = new ArrayList<>();

        if (root == null) {
            return preorder;
        }

        stack.push(root);
        while (!stack.empty()) {
            TreeNode node = stack.pop();
            preorder.add(node.val);
            if (node.right != null) {
                stack.push(node.right);
            }
            if (node.left != null) {
                stack.push(node.left);
            }
        } // end while loop

        return preorder;
    } // end preorderTraversal
} // end Solution
```

## Level Order Traverse

Leetcode <https://leetcode.cn/problems/binary-tree-level-order-traversal/>

### 题目描述

给你二叉树的根节点 root ，返回其节点值的 层序遍历 。 （即逐层地，从左到右访问所有节点）。

**示例 1：**


输入：root = [3,9,20,null,null,15,7]

输出：[[3],[9,20],[15,7]]

**示例 2：**

输入：root = [1]

输出：[[1]]

**示例 3：**

输入：root = []

输出：[]
 

**提示：**

1. 树中节点数目在范围 [0, 2000] 内
2. -1000 <= Node.val <= 1000


### 解题报告

BFS Template!!!!

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
        List<List<Integer>> res = new ArrayList<>();
        if (root == null) {
            return res;
        }

        Queue<TreeNode> queue = new LinkedList<>();
        queue.offer(root);

        while (!queue.isEmpty()) {
            List<Integer> level = new ArrayList<>();
            int size = queue.size();
            for (int i = 0; i < size; i++) {
                TreeNode node = queue.poll();
                level.add(node.val);
                if (node.left != null) {
                    queue.offer(node.left);
                }
                if (node.right != null) {
                    queue.offer(node.right);
                }
            } // end for i
            res.add(level);
        } // end while loop

        return res;
    } // end levelOrder
} // end Solution
```