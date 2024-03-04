---
title: Lecture-3 Binary Tree & Divide Conquer
date: 2023-09-24 15:01:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Algorithms Note]
pin: false
math: true
mermaid: false
---

## Outline

1. DFS in Binary Tree
   1. Preorder / Inorder / Postorder
   2. Introduce Divide Conquer Algorithm
   3. Non-recursion **vs** Traverse **vs** Divide Conquer
2. BFS in Binary Tree
3. Binary Search Tree
   1. Insert / Remove / Find / Validate

## Time Complexity Training

- 通过 O(n) 的时间，把 n 的问题，变为了 n/2 的问题，复杂度是多少？O(n)
- 通过 O(1) 的时间，把 n 的问题，变成了两个 n/2 的问题，复杂度是多少？O(n)

通过 O(n) 的时间，把 n 的问题，变为了 n/2 的问题，复杂度是多少？O(n)

![image.png](/assets/images/BinaryTreeAndDivideConquer/Lecture-3-image-1.png)

通过 O(1) 的时间，把 n 的问题，变成了两个 n/2 的问题，复杂度是多少？O(n)

![image.png](/assets/images/BinaryTreeAndDivideConquer/Lecture-3-image-2.png)

![image.png](/assets/images/BinaryTreeAndDivideConquer/Lecture-3-image-3.png)

答案是O(n)

## Preorder Postorder Inorder

```
    1
   / \
  2   3
 / \
4   5
```

- Preorder 前序遍历
   - 1 245 3 根左右
- Inorder 中序遍历
   - 425 1 3 左 根 右
- Postorder 后序遍历
   - 452 3 1 左 右 根

## DFS in Binary Tree

- Preorder
   - <https://www.lintcode.com/problem/binary-tree-preorder-traversal/>
   - <https://www.jiuzhang.com/solutions/binary-tree-preorder-traversal/>
- Inorder
   - <https://www.lintcode.com/en/problem/binary-tree-inorder-traversal/>
   - <https://www.jiuzhang.com/solutions/binary-tree-inorder-traversal/>
- Postorder
   - <https://www.lintcode.com/en/problem/binary-tree-postorder-traversal/>
   - <https://www.jiuzhang.com/solutions/binary-tree-postorder-traversal/>

> **这三个程序需要背诵并理解，先背诵再理解。**
{: .prompt-tip }

非递归方式实现前序遍历时，首先存入当前节点值，然后先将右儿子压入栈中，再将左儿子压入栈中。对栈中元素遍历访问。

### Non-Recursion (Recommend)

```java
//Version 0: Non-Recursion (Recommend)
/**
 * Definition for binary tree
 * public class TreeNode {
 *     int val;
 *     TreeNode left;
 *     TreeNode right;
 *     TreeNode(int x) { val = x; }
 * }
 */
public class Solution {
    public List<Integer> preorderTraversal(TreeNode root) {
        Stack<TreeNode> stack = new Stack<TreeNode>();
        List<Integer> preorder = new ArrayList<Integer>();
        
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
        }
        
        return preorder;
    }
}
```

### Traverse

```java
//Version 1: Traverse
public class Solution {
    public ArrayList<Integer> preorderTraversal(TreeNode root) {
        ArrayList<Integer> result = new ArrayList<Integer>();
        traverse(root, result);
        return result;
    }
    // 把root为根的preorder加入result里面
    private void traverse(TreeNode root, ArrayList<Integer> result) {
        if (root == null) {
            return;
        }

        result.add(root.val);
        traverse(root.left, result);
        traverse(root.right, result);
    }
}

```

### Divide & Conquer

```java
//Version 2: Divide & Conquer
public class Solution {
    public ArrayList<Integer> preorderTraversal(TreeNode root) {
        ArrayList<Integer> result = new ArrayList<Integer>();
        // null or leaf
        if (root == null) {
            return result;
        }

        // Divide
        ArrayList<Integer> left = preorderTraversal(root.left);
        ArrayList<Integer> right = preorderTraversal(root.right);

        // Conquer
        result.add(root.val);
        result.addAll(left);
        result.addAll(right);
        return result;
    }
}
```

要求背诵。

不管什么非递归的程序都用到了栈这个数据结构。

- [ ] Java 栈数据结构API 整理
- [x] 这里用meiaid画一个图

你要理解一个递归你首先要会写一个递归的程序

```java
//Version 1: Traverse
public class Solution {
    public ArrayList<Integer> preorderTraversal(TreeNode root) {
        ArrayList<Integer> result = new ArrayList<Integer>();
        traverse(root, result);
        return result;
    }
    // 把root为根的preorder加入result里面
    private void traverse(TreeNode root, ArrayList<Integer> result) {
        if (root == null) {
            return;
        }

        result.add(root.val);
        traverse(root.left, result);
        traverse(root.right, result);
    }
}
```

递归要做三件事情

1. 给你的递归函数一个定义：一句话描述你的递归函数做了什么事情
2. 出口，在什么情况下你的递归不要再往下递归了？
   1. 在什么情况下不要自己调用自己了
   2. 递归就是一种程序的实现方式
   3. root == null 程序会整洁一点
3. 看这个递归怎么去拆分为更小的问题
   1. 根左右
   2. 先处理根，再去处理左子树，再去处理右子树

一般把要处理的东西，放到 traverse 的参数里面，traverse的过程是一个游走的过程，有时候会写成xxxHelper函数，例如是 preorderHelper()

另一种方法就是 Divide & Conquer

```java
// Version 2: Divide & Conquer
public class Solution {
    public ArrayList<Integer> preorderTraversal(TreeNode root) {
        ArrayList<Integer> result = new ArrayList<Integer>();
        // null or leaf
        if (root == null) {
            return result;
        }

        // Divide
        ArrayList<Integer> left = preorderTraversal(root.left);
        ArrayList<Integer> right = preorderTraversal(root.right);

        // Conquer
        result.add(root.val);
        result.addAll(left);
        result.addAll(right);

        return result;
    }
}
```

## Divide Conquer Algorithm

- Traverse vs Divide Conquer
   - They are both Recursion Algorithm
   - Result in parameter **vs** Result in return value
   - Top down **vs** Bottom up
- Merge Sort / Quick Sort
- 90% Binary Tree Problems!

## 独孤九剑之破枪式

碰到二叉树的问题，就想想整棵树在该问题上的结果和左右儿子在该问题上的结果之间的联系是什么？

## Max Depth of Binary Tree

Lintcode <https://www.lintcode.com/problem/maximum-depth-of-binary-tree/>

Leetcode <https://leetcode.cn/problems/maximum-depth-of-binary-tree/>

Solution <https://www.jiuzhang.com/solutions/maximum-depth-of-binary-tree/>

Related Question: Minimum Depth of Binary Tree

很多的问题两种方法都能解决，建议先试试分治，再尝试traverse

## Balanced Binary Tree

Lintcode <https://www.lintcode.com/problem/balanced-binary-tree/>

Solution <https://www.jiuzhang.com/solutions/balanced-binary-tree/>

When we need ResultType?

### Version 1: with ResultType

```java
// Version 1: with ResultType
/**
 * Definition of TreeNode:
 * public class TreeNode {
 *     public int val;
 *     public TreeNode left, right;
 *     public TreeNode(int val) {
 *         this.val = val;
 *         this.left = this.right = null;
 *     }
 * }
 */
class ResultType {
    public boolean isBalanced;
    public int maxDepth;
    public ResultType(boolean isBalanced, int maxDepth) {
        this.isBalanced = isBalanced;
        this.maxDepth = maxDepth;
    }
}

public class Solution {
    /**
     * @param root: The root of binary tree.
     * @return: True if this Binary tree is Balanced, or false.
     */
    public boolean isBalanced(TreeNode root) {
        return helper(root).isBalanced;
    }
    
    private ResultType helper(TreeNode root) {
        if (root == null) {
            return new ResultType(true, 0);
        }
        
        ResultType left = helper(root.left);
        ResultType right = helper(root.right);
        
        // subtree not balance
        if (!left.isBalanced || !right.isBalanced) {
            return new ResultType(false, -1);
        }
        
        // root not balance
        if (Math.abs(left.maxDepth - right.maxDepth) > 1) {
            return new ResultType(false, -1);
        }
        
        return new ResultType(true, Math.max(left.maxDepth, right.maxDepth) + 1);
    }
}
```

ResultType 更工程化一点，coding style 好一点！

### Version 2: without ResultType

```java
// Version 2: without ResultType
public class Solution {
    public boolean isBalanced(TreeNode root) {
        return maxDepth(root) != -1;
    }

    private int maxDepth(TreeNode root) {
        if (root == null) {
            return 0;
        }

        int left = maxDepth(root.left);
        int right = maxDepth(root.right);
        if (left == -1 || right == -1 || Math.abs(left-right) > 1) {
            return -1;
        }
        return Math.max(left, right) + 1;
    }
}
```

> 课前把题目看一遍，描述搞清楚。

## Lowest Common Ancesstor

Lintcode <https://www.lintcode.com/problem/lowest-common-ancestor/>

Solution <https://www.jiuzhang.com/solutions/lowest-common-ancestor/>

with parent pointer **vs** no parent pointer

这是一道非常非常经典的题目，如果变点新东西进去，会出的很难。

离线或者在线的一些算法，会考的很难的算法。

还有一个题2 lowest Common Ancesstor

需要问一下面试官，这个节点能不能访问parent指针。

### Description

Given the root and two nodes in a Binary Tree. Find the lowest common ancestor(LCA) of the two nodes.

The lowest common ancestor is the node with largest depth which is the ancestor of both nodes.

### Solutions

- version : Traditional Method

```java
// version : Traditional Method

public class Solution {
    private ArrayList<TreeNode> getPath2Root(TreeNode node) {
        ArrayList<TreeNode> list = new ArrayList<TreeNode>();
        while (node != null) {
            list.add(node);
            node = node.parent;
        }
        return list;
    }
    public TreeNode lowestCommonAncestor(TreeNode node1, TreeNode node2) {
        ArrayList<TreeNode> list1 = getPath2Root(node1);
        ArrayList<TreeNode> list2 = getPath2Root(node2);

        int i, j;
        for (i = list1.size() - 1, j = list2.size() - 1; i >= 0 && j >= 0; i--, j--) {
            if (list1.get(i) != list2.get(j)) {
                return list1.get(i).parent;
            }
        } // for

        return list1.get(i + 1);
    }
}
```

- Version : Divide & Conquer

```java
// Version : Divide & Conquer

public class Solution {
    // 在root为根的二叉树中找A,B的LCA:
    // 如果找到了就返回这个LCA
    // 如果只碰到A，就返回A
    // 如果只碰到B，就返回B
    // 如果都没有，就返回null
    public TreeNode lowestCommonAncestor(TreeNode root, TreeNode node1, TreeNode node2) {
        if (root == null || root == node1 || root == node2) {
            return root;
        }
        
        // Divide
        TreeNode left = lowestCommonAncestor(root.left, node1, node2);
        TreeNode right = lowestCommonAncestor(root.right, node1, node2);
        
        // Conquer
        if (left != null && right != null) {
            return root;
        } 
        if (left != null) {
            return left;
        }
        if (right != null) {
            return right;
        }
        return null;
    }
}
```

## Binary Tree Maximum Path Sum ii

- [ ] 先做这道预备题

### Solutions

```java
public class Solution {

    public int maxPathSum2(TreeNode root) {
        if (root == null) {
            return 0;
        }

        int left = maxPathSum2(root.left);
        int right = maxPathSum2(root.right);

        return root.val +
    }
}
```

## Binary Tree Maximum Path Sum

Lintcode [https://www.lintcode.com/problem/binary-tree-maximum-path-sum/](https://www.lintcode.com/problem/binary-tree-maximum-path-sum/)

Solution [https://www.jiuzhang.com/solutions/binary-tree-maximum-path-sum/](https://www.jiuzhang.com/solutions/binary-tree-maximum-path-sum/)

any to any **vs** root to any  

### Description

Given a binary tree, find the maximum path sum.

The path may start and end at any node in the tree.

(Path sum is the sum of the weights of nodes on the path between two nodes.)

### Solutions

要去问面试官，有没有负数？！再去做处理。

```java
public class Solution {
    private class ResultType {
        // singlePath: 从root往下走到任意点的最大路径，这条路径可以不包含任何点
        // maxPath: 从树中任意到任意点的最大路径，这条路径至少包含一个点
        int singlePath, maxPath; 
        ResultType(int singlePath, int maxPath) {
            this.singlePath = singlePath;
            this.maxPath = maxPath;
        }
    }

    private ResultType helper(TreeNode root) {
        if (root == null) {
            return new ResultType(0, Integer.MIN_VALUE);
        }
        // Divide
        ResultType left = helper(root.left);
        ResultType right = helper(root.right);

        // Conquer
        int singlePath = Math.max(left.singlePath, right.singlePath) + root.val;
        singlePath = Math.max(singlePath, 0);

        int maxPath = Math.max(left.maxPath, right.maxPath);
        maxPath = Math.max(maxPath, left.singlePath + right.singlePath + root.val);

        return new ResultType(singlePath, maxPath);
    }

    public int maxPathSum(TreeNode root) {
        ResultType result = helper(root);
        return result.maxPath;
    }
}
```

```java
// Version 2:
// SinglePath也定义为，至少包含一个点。
public class Solution {
    /**
     * @param root: The root of binary tree.
     * @return: An integer.
     */
    private class ResultType {
        int singlePath, maxPath;
        ResultType(int singlePath, int maxPath) {
            this.singlePath = singlePath;
            this.maxPath = maxPath;
        }
    }

    private ResultType helper(TreeNode root) {
        if (root == null) {
            return new ResultType(Integer.MIN_VALUE, Integer.MIN_VALUE);
        }
        // Divide
        ResultType left = helper(root.left);
        ResultType right = helper(root.right);

        // Conquer
        int singlePath =
            Math.max(0, Math.max(left.singlePath, right.singlePath)) + root.val;

        int maxPath = Math.max(left.maxPath, right.maxPath);
        maxPath = Math.max(maxPath,
                           Math.max(left.singlePath, 0) + 
                           Math.max(right.singlePath, 0) + root.val);

        return new ResultType(singlePath, maxPath);
    }

    public int maxPathSum(TreeNode root) {
        ResultType result = helper(root);
        return result.maxPath;
    }

}
```

写的不大好的地方，ResultType应该写到class外面，class 套class总是不大好。

好难啊，我怎么能想出来呢？

## BFS in Binary Tree

Binary Tree Level Order Traversal

Lintcode [https://www.lintcode.com/problem/binary-tree-level-order-traversal/](https://www.lintcode.com/problem/binary-tree-level-order-traversal/)

Solution [https://www.jiuzhang.com/solutions/binary-tree-level-order-traversal/](https://www.jiuzhang.com/solutions/binary-tree-level-order-traversal/)

- 2 Queues
- 1 Queue + Dummy Node
- **1 Queue (Best)**

理解并背诵就可以了

### Solutions

- version 1: BFS

1. 模拟执行这个程序。
2. 背诵这个程序，知道它的大框架。这个流程就叫宽度优先搜索！

```java
// version 1: BFS
public class Solution {
    public List<List<Integer>> levelOrder(TreeNode root) {
        List result = new ArrayList();

        if (root == null) {
            return result;
        }

        Queue<TreeNode> queue = new LinkedList<TreeNode>();
        queue.offer(root);

        while (!queue.isEmpty()) {
            ArrayList<Integer> level = new ArrayList<Integer>();
            int size = queue.size();
            for (int i = 0; i < size; i++) {
                TreeNode head = queue.poll();
                level.add(head.val);
                if (head.left != null) {
                    queue.offer(head.left);
                }
                if (head.right != null) {
                    queue.offer(head.right);
                }
            }
            result.add(level);
        }

        return result;
    }
}
```

- version 3: BFS. two queues

```java
// version 3: BFS. two queues
public class Solution {
    /**
     * @param root: The root of binary tree.
     * @return: Level order a list of lists of integer
     */
    public List<List<Integer>> levelOrder(TreeNode root) {
        List<List<Integer>> result = new ArrayList<List<Integer>>();
        if (root == null) {
            return result;
        }
        
        List<TreeNode> Q1 = new ArrayList<TreeNode>();
        List<TreeNode> Q2 = new ArrayList<TreeNode>();

        Q1.add(root);
        while (Q1.size() != 0) {
            List<Integer> level = new ArrayList<Integer>();
            Q2.clear();
            for (int i = 0; i < Q1.size(); i++) {
                TreeNode node = Q1.get(i);
                level.add(node.val);
                if (node.left != null) {
                    Q2.add(node.left);
                }
                if (node.right != null) {
                    Q2.add(node.right);
                }
            }
            
            // swap q1 and q2
            List<TreeNode> temp = Q1;
            Q1 = Q2;
            Q2 = temp;
            
            // add to result
            result.add(level);
        }
        
        return result;
    }
}
```

- version 4: BFS, queue with dummy node

```java
// version 4: BFS, queue with dummy node
public class Solution {
    /**
     * @param root: The root of binary tree.
     * @return: Level order a list of lists of integer
     */
    public List<List<Integer>> levelOrder(TreeNode root) {
        List<List<Integer>> result = new ArrayList<List<Integer>>();
        if (root == null) {
            return result;
        }
        
        Queue<TreeNode> Q = new LinkedList<TreeNode>();
        Q.offer(root);
        Q.offer(null); // dummy node
        
        List<Integer> level = new ArrayList<Integer>();
        while (!Q.isEmpty()) {
            TreeNode node = Q.poll();
            if (node == null) {
                if (level.size() == 0) {
                    break;
                }
                result.add(level);
                level = new ArrayList<Integer>();
                Q.offer(null); // add a new dummy node
                continue;
            }
            
            level.add(node.val);
            if (node.left != null) {
                Q.offer(node.left);
            }
            if (node.right != null) {
                Q.offer(node.right);
            }
        }
        
        return result;
    }
}
```

### Follow Up

Can you do it in DFS?

- version 2: DFS

```java
// version 2:  DFS
public class Solution {
    /**
     * @param root: The root of binary tree.
     * @return: Level order a list of lists of integer
     */
    public List<List<Integer>> levelOrder(TreeNode root) {
        List<List<Integer>> results = new ArrayList<List<Integer>>();
        
        if (root == null) {
            return results;
        }
        
        int maxLevel = 0;
        while (true) {
            List<Integer> level = new ArrayList<Integer>();
            dfs(root, level, 0, maxLevel);
            if (level.size() == 0) {
                break;
            }
            
            results.add(level);
            maxLevel++;
        }
        
        return results;
    }
    
    private void dfs(TreeNode root,
                     List<Integer> level,
                     int curtLevel,
                     int maxLevel) {
        if (root == null || curtLevel > maxLevel) {
            return;
        }
        
        if (curtLevel == maxLevel) {
            level.add(root.val);
            return;
        }
        
        dfs(root.left, level, curtLevel + 1, maxLevel);
        dfs(root.right, level, curtLevel + 1, maxLevel);
    }
}
```

很有趣，迭代搜索，主要思想是我放一个限制，我逐步放宽这个限制。

### Related Questions

**Binary Tree Level Order Traversal ii**

- Lintcode [https://www.lintcode.com/problem/binary-tree-level-order-traversal-ii/](https://www.lintcode.com/problem/binary-tree-level-order-traversal-ii/)
- Solution [https://www.jiuzhang.com/solutions/binary-tree-level-order-traversal-ii/](https://www.jiuzhang.com/solutions/binary-tree-level-order-traversal-ii/)

**Binary Tree Zigzag Level Order Traversal**

- Lintcode [https://www.lintcode.com/problem/binary-tree-zigzag-level-order-traversal/](https://www.lintcode.com/problem/binary-tree-zigzag-level-order-traversal/)
- Solution [https://www.jiuzhang.com/solutions/binary-tree-zigzag-level-order-traversal/](https://www.jiuzhang.com/solutions/binary-tree-zigzag-level-order-traversal/)

## Binary Search Tree

Assume a BST is defined as follows:

- The left subtree of a node contains only nodes with keys **less than** the node's key.
- The right subtree of a node contains only nodes with keys **greater than** the node's key.
- Both the left and right subtrees must also be binary search trees.
- A single node tree is a BST

简称BST，BST的中序序列是一个升序序列！！

## Validate Binary Search Tree

Lintcode [https://www.lintcode.com/problem/validate-binary-search-tree/](https://www.lintcode.com/problem/validate-binary-search-tree/)

Solution [https://www.jiuzhang.com/solutions/validate-binary-search-tree/](https://www.jiuzhang.com/solutions/validate-binary-search-tree/)

Traverse **vs** Divide Conquer

### Description

Given a binary tree, determine if it is a valid binary search tree (BST).

Assume a BST is defined as follows:

- The left subtree of a node contains only nodes with keys **less than** the node's key.
- The right subtree of a node contains only nodes with keys **greater than** the node's key.
- Both the left and right subtrees must also be binary search trees.
- A single node tree is a BST

### Solustion

分治法，但是 minValue 和 maxValue 用 minNode 和 maxNode 来代替。

```java
/**
 * Definition of TreeNode:
 * public class TreeNode {
 *     public int val;
 *     public TreeNode left, right;
 *     public TreeNode(int val) {
 *         this.val = val;
 *         this.left = this.right = null;
 *     }
 * }
 */

class ResultType {
    public boolean isBST;
    public TreeNode maxNode, minNode;
    public ResultType(boolean isBST) {
        this.isBST = isBST;
        this.maxNode = null;
        this.minNode = null;
    }
}

public class Solution {
    /**
     * @param root: The root of binary tree.
     * @return: True if the binary tree is BST, or false
     */
    public boolean isValidBST(TreeNode root) {
        return divideConquer(root).isBST;
    }
    
    private ResultType divideConquer(TreeNode root) {
        if (root == null) {
            return new ResultType(true);
        }
        
        ResultType left = divideConquer(root.left);
        ResultType right = divideConquer(root.right);
        if (!left.isBST || !right.isBST) {
            return new ResultType(false);
        }
        
        if (left.maxNode != null && left.maxNode.val >= root.val) {
            return new ResultType(false);
        }
        
        if (right.minNode != null && right.minNode.val <= root.val) {
            return new ResultType(false);
        }
        
        // is bst
        ResultType result = new ResultType(true);
        result.minNode = left.minNode != null ? left.minNode : root;
        result.maxNode = right.maxNode != null ? right.maxNode : root;
        
        return result;
    }
}
```

- 采用遍历法（Traversal） 时间复杂度 O(n)

```java
// version 1 Traverse
public class Solution {
    private int lastVal = Integer.MIN_VALUE;
    private boolean firstNode = true;
    public boolean isValidBST(TreeNode root) {
        if (root == null) {
            return true;
        }
        if (!isValidBST(root.left)) {
            return false;
        }
        if (!firstNode && lastVal >= root.val) {
            return false;
        }
        firstNode = false;
        lastVal = root.val;
        if (!isValidBST(root.right)) {
            return false;
        }
        return true;
    }
}
```

如果它的中序序列是升序的那么就是一个BST，否则False

如果是分治的方法来做的话

采用分治法，时间复杂度 O(n)

```java
public class Solution {
    /**
     * @param root: The root of binary tree.
     * @return: True if the binary tree is BST, or false
     */
    public boolean isValidBST(TreeNode root) {
        // write your code here
        return divConq(root, Long.MIN_VALUE, Long.MAX_VALUE);
    }
    
    private boolean divConq(TreeNode root, long min, long max){
        if (root == null){
            return true;
        }
        if (root.val <= min || root.val >= max){
            return false;
        }
        return divConq(root.left, min, Math.min(max, root.val)) && 
                divConq(root.right, Math.max(min, root.val), max);
    }
}
```

分治就是他分左子树是不是BST，右子树是不是BST。

他最大的点都比我小！

## Inorder Successor in Binary Search Tree

Lintcode [https://www.lintcode.com/problem/inorder-successor-in-binary-search-tree/](https://www.lintcode.com/problem/inorder-successor-in-binary-search-tree/)

Solution [https://www.jiuzhang.com/solutions/inorder-successor-in-binary-search-tree/](https://www.jiuzhang.com/solutions/inorder-successor-in-binary-search-tree/)

这是一道模拟题

### Description

Given a binary search tree ([See Definition](https://www.lintcode.com/problem/validate-binary-search-tree/)) and a node in it, find the in-order successor of that node in the BST.

If the given node has no in-order successor in the tree, return null.

### Solutions

```java
public class Solution {
    public TreeNode inorderSuccessor(TreeNode root, TreeNode p) {
        TreeNode successor = null;
        while (root != null && root != p) {
            if (root.val > p.val) {
                successor = root;
                root = root.left;
            } else {
                root = root.right;
            }
        }
        
        if (root == null) {
            return null;
        }
        
        if (root.right == null) {
            return successor;
        }
        
        root = root.right;
        while (root.left != null) {
            root = root.left;
        }
        
        return root;
    }
}

// version: 高频题班
public class Solution {
    public TreeNode inorderSuccessor(TreeNode root, TreeNode p) {
        // write your code here
        if (root == null || p == null) {
            return null;
        }

        if (root.val <= p.val) {
            return inorderSuccessor(root.right, p);
        } else {
            TreeNode left = inorderSuccessor(root.left, p);
            return (left != null) ? left : root;
        }
    }
}
```

自己去研究一下，看懂就好了。

## Binary Search Tree Iterator

需要背过这道题！！

对比看的一道题 中序遍历的非递归的那道题。

Lintcode 	[https://www.lintcode.com/en/problem/binary-search-tree-iterator/](https://www.lintcode.com/en/problem/binary-search-tree-iterator/)

Solution [https://www.jiuzhang.com/solutions/binary-search-tree-iterator/](https://www.jiuzhang.com/solutions/binary-search-tree-iterator/)

Iterator **vs** Inorder with non-recursion

## Related Questions

Search Range in Binary Search Tree

[https://www.lintcode.com/problem/search-range-in-binary-search-tree/](https://www.lintcode.com/problem/search-range-in-binary-search-tree/)

Insert Node in a Binary Search Tree

[https://www.lintcode.com/problem/insert-node-in-a-binary-search-tree/](https://www.lintcode.com/problem/insert-node-in-a-binary-search-tree/)


Remove Node in a Binary Search Tree

[https://www.lintcode.com/problem/remove-node-in-binary-search-tree/](https://www.lintcode.com/problem/remove-node-in-binary-search-tree/)

[https://www.mathcs.emory.edu/~cheung/Courses/171/Syllabus/9-BinTree/BST-delete.html](https://www.mathcs.emory.edu/~cheung/Courses/171/Syllabus/9-BinTree/BST-delete.html) **[Expired]**

other links

1. [https://www.geeksforgeeks.org/deletion-in-binary-search-tree/](https://www.geeksforgeeks.org/deletion-in-binary-search-tree/)
2. [https://www.enjoyalgorithms.com/blog/deletion-in-binary-search-tree](https://www.enjoyalgorithms.com/blog/deletion-in-binary-search-tree)


删除挺难的，面试官要挂人的时候，因为他有很多种情况要归类想到。

## Conclusions

增和查一定要会

- DFS in Binary Tree
   - Traverse **vs** Divide Conquer
   - Non Recursion for Preorder + Inorder
- BFS in Binary Tree
   - 1 Queue
- Binary Search Tree
   - Inorder **vs** BST

## Homework

**Required**

1. [Easy] 97 Maximum Depth of Binary Tree
2. [Easy] 66 Binary Tree Preorder Traversal
3. [Medium] 475 Binary Tree Maximum Path Sum ii
4. [Medium] 448 Inorder Successor in Binary Search Tree
5. [Medium] 95 Validate Binary Search Tree
6. [Medium] 94 Binary Tree Maximum Path Sum
7. [Medium] 93 Balanced Binary Tree
8. [Medium] 88 Lowest Common Ancestor
9. [Medium] 69 Binary Tree Level Order Traversal
10. [Hard] 86 Binary Search Tree Iterator

**Optional**

1. [Easy] 376 Binary Tree Path Sum
2. [Easy] 474 Lowest Common Ancestor ii
3. [Easy] 470 Tweaked Identical Binary Tree
4. [Easy] 469 Identical Binary Tree
5. [Easy] 468 Symmetric Binary Tree
6. [Easy] 467 Complete Binary Tree
7. [Easy] 155 Minimum Depth of Binary Tree
8. [Easy] 85 Insert Node in a Binary Search Tree
9. [Easy] 68 Binary Tree Postorder Traversal
10. [Easy] 67 Binary Tree Inorder Traversal
11. [Medium] 73 Construct Binary Tree from Preorder and Inorder Traversal
12. [Medium] 72 Construct Binary Tree from Inorder and Postorder Traversal
13. [Medium] 71 Binary Tree Zigzag Level Order Traversal
14. [Medium] 70 Binary Tree Level Order Traversal ii
15. [Medium] 11 Search Range in Binary Search Tree
16. [Medium] 7 Binary Tree Serialization
17. [Hard] 87 Remove Node in Binary Search Tree