---
title: Breadth First Search Template
date: 2023-10-04 19:27:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Graph, Search]
pin: false
math: true
mermaid: false
media_subpath: /assets/images/BFSImages/
---

## Outline

- 二叉树上的宽搜 BFS in Binary Tree
- 图上的宽搜 BFS in Graph
  - 拓扑排序 Topological Sorting

- 棋盘上的宽搜 BFS

## 什么时候应该使用BFS？

**图的遍历 Traversal in Graph**

- 层次遍历 Level Order Traversal
- 由点及面 Connected Component
- 拓扑排序 Topological Sorting

**最短路径 Shortest Path in Simple Graph**

- 仅限简单图求最短路径
- 即，图中每条边长度都是1，且没有方向



如果题目问最短路径，除了 BFS 还可能是什么算法？ 有可能是DP

如果问最长路径呢？ 有可能是DP，或者DFS

## Template Binary Tree Level Order Traversal

Lintcode <https://www.lintcode.com/problem/binary-tree-level-order-traversal/>

Leetcode <https://leetcode.cn/problems/binary-tree-level-order-traversal/>

Solution <https://www.jiuzhang.com/solutions/binary-tree-level-order-traversal/>

图的遍历（层级遍历）

注意：树是图的一种特殊形态，树属于图，树的全称是树状图。

BFS Template <https://www.jiuzhang.com/solutions/bfs-template/>

### Description

Given the root of a binary tree, return *the level order traversal of its nodes' values*. (i.e., from left to right, level by level).



**Example 1:**

![img](tree1.jpg)

Input: root = [3,9,20,null,null,15,7] 

Output: [[3],[9,20],[15,7]] 

**Example 2:**

Input: root = [1] 

Output: [[1]] 

**Example 3:**

Input: root = [] 

Output: [] 



**Constraints:**

- The number of nodes in the tree is in the range [0, 2000].
- -1000 <= Node.val <= 1000

### Solutions

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

        // interface
        // 1. 创建一个队列，把起始节点都放到里面去(第1层节点)
        Queue<TreeNode> queue = new LinkedList<TreeNode>();
        queue.offer(root);

        // 2. while 队列不空，处理队列中的节点，并拓展出新的节点
        while (!queue.isEmpty()) {
            List<Integer> level = new ArrayList<Integer>();
            int size = queue.size();
            // for 上一层的节点拓展下一层的节点
            for (int i = 0; i < size; i++) {
                TreeNode node = queue.poll();
                level.add(node.val);
                if (node.left != null) {
                    queue.offer(node.left);
                }
                if (node.right != null) {
                    queue.offer(node.right);
                }
            } // for i loop

            results.add(level);
        } // end while loop

        return results;
    } // end levelOrder
} // end Solution
```



用arraylist 实现功效一样。

```java
ArrayList<TreeNode> queue = ...
startIndex = 0;
```



Map<Integer, Integer> map = new HashMap<Integer, Integer>();

接口<> 变量名 = new 实现类<>();

无脑记住这个写法，一种多态的写法。



## 宽搜要点 BFS Key Points

Q 使用队列作为主要的数据结构 Queue

思考：用栈（Stack）是否可行？为什么行 or 为什么不行？

BFS 标配 Queue，而 DFS 标配 Stack



Q 是否需要实现分层？

需要分层的算法比不需要分层的算法多一个循环



size = queue.size()

如果直接 `for (int i = 0; i < queue.size(); i++)` 会怎么样？

Ans queue 是在变化的，所以 queue.size() 不固定。



## Binary Tree Serialization

Q 什么是序列化？

将“内存”中结构化的数据变成“字符串”的过程

- 序列化：object to string
- 反序列化：string to object



Q 什么时候需要序列化？？

1. 将内存中的数据持久化存储时

内存中重要的数据不能只是呆在内存里，这样断电就没有了，所需需要用一种方式写入硬盘，在需要的时候，能否再从硬盘中读出来在内存中重新创建

1. 网络传输时

机器与机器之间交换数据的时候，不可能互相去读对方的内存。只能讲数据变成字符流数据（字符串）后，通过网络传输过去。接受的一方再将字符串解析后到内存中。

常用的一些序列化手段：

- XML
- JSON
- Thrift (by Facebook)
- ProtoBuf (by Google)

一些序列化的例子：

- 比如一个数组，里面都是整数，我们可以简单的序列化为"[1,2,3]"
- 一个整数链表，我们可以序列化为，"1->2->3"
- 一个哈希表（HashMap），我们可以序列化为"{\"key\":\"value\"}"

序列化算法设计时需要考虑的因素：

- 压缩率。对于网络传输和磁盘存储而言，当然希望更节省。

- 如 Thrift，ProtoBuf 都是为了更快的传输数据和节省存储空间而设计的。

- 可读性。我们希望开发人员，能够通过序列化后的数据直接看懂原始数据是什么。

- 如 Json，LintCode 的输入数据

Binary Tree Representation <https://www.lintcode.com/help/binary-tree-representation>

你可以使用任何你想要用的方法进行序列化，只要保证能够解析回来即可。

leetcode <https://leetcode.com/problems/serialize-and-deserialize-binary-tree/>

Solution 

What does [1,null,2,3] mean in binary tree representation? <https://support.leetcode.com/hc/en-us/articles/360011883654-What-does-1-null-2-3-mean-in-binary-tree-representation->

### Description

Serialization is the process of converting a data structure or object into a sequence of bits so that it can be stored in a file or memory buffer, or transmitted across a network connection link to be reconstructed later in the same or another computer environment.

Design an algorithm to serialize and deserialize a binary tree. There is no restriction on how your serialization/deserialization algorithm should work. You just need to ensure that a binary tree can be serialized to a string and this string can be deserialized to the original tree structure.

**Clarification:** The input/output format is the same as [how LeetCode serializes a binary tree](https://support.leetcode.com/hc/en-us/articles/360011883654-What-does-1-null-2-3-mean-in-binary-tree-representation-). You do not necessarily need to follow this format, so please be creative and come up with different approaches yourself.



**Example 1:**

![img](serdeser.jpg)

Input: root = [1,2,3,null,null,4,5] 

Output: [1,2,3,null,null,4,5] 

**Example 2:**

Input: root = [] 

Output: [] 



**Constraints:**

- The number of nodes in the tree is in the range [0, 104].
- -1000 <= Node.val <= 1000



### Solutions

还是 Template BFS 来写的

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
public class Codec {

    private TreeNode generateNode(String val) {
        if (val.equals("null")) {
            return null;
        }
        return new TreeNode(Integer.valueOf(val));
    }

    // Encodes a tree to a single string.
    public String serialize(TreeNode root) {
        LinkedList<String> ans = new LinkedList<>();
        if (root == null) {
            ans.add(null);
        } else {
        ans.add(String.valueOf(root.val));
        Queue<TreeNode> queue = new LinkedList<TreeNode>();
        queue.add(root);
        while (!queue.isEmpty()) {
            root = queue.poll();
            if (root.left != null) {
                ans.add(String.valueOf(root.left.val));
                queue.add(root.left);
            } else {
                ans.add(null);
            }
            if (root.right != null) {
                ans.add(String.valueOf(root.right.val));
                queue.add(root.right);
            } else {
                ans.add(null);
            }
        } }

        while (!ans.isEmpty() && ans.peekLast() == null) {
            ans.pollLast();
        }
        StringBuilder builder = new StringBuilder();
        builder.append("[");
        String str = ans.pollFirst();
        builder.append(str == null ? "null" : str);
        while (!ans.isEmpty()) {
            str = ans.pollFirst();
            builder.append("," + (str == null ? "null" : str));
        }
        builder.append("]");
        
        return builder.toString();
    }

    // Decodes your encoded data to tree.
    public TreeNode deserialize(String data) {
        String[] strs = data.substring(1, data.length() - 1).split(",");
        int index = 0;
        TreeNode root = generateNode(strs[index++]);
        Queue<TreeNode> queue = new LinkedList<TreeNode>();
        if (root != null) {
            queue.add(root);
        }
        while (!queue.isEmpty()) {
            TreeNode node = queue.poll();
            node.left = generateNode(index == strs.length ? "null" : strs[index++]);
            node.right = generateNode(index == strs.length ? "null" : strs[index++]);
            if (node.left != null) {
                queue.add(node.left);
            }
            if (node.right != null) {
                queue.add(node.right);
            }
        }

        return root;
    }
}

// Your Codec object will be instantiated and called as such:
// Codec ser = new Codec();
// Codec deser = new Codec();
// TreeNode ans = deser.deserialize(ser.serialize(root));
```



## 相关问题 Related Problems

1. Binary Tree Level Order Traversal ii
2. Binary Tree Zigzag Order Traversal
3. Convert Binary Tree to Linked Lists by Depth



## BFS in Graph

图上的宽度优先搜索

问：和树上有什么区别？

G = <V, E> 其中 Vertex 顶点，Edge 边

**无向图（undirected graph） 有向图（directed graph），区别是边是否有方向。**

**一般套上 Social Network 的背景来出题。**



**HashMap** 

图中存在环，存在环意味着，同一个节点可能重复进入队列

## Graph Valid Tree

Flood fill，灌水法。

1. Tree：N个点，N-1条边。
2. 所有点连通，从0点出发，可以触达所有点。

问：如何用基本数据结构表示一个图？

邻接矩阵来表示

Lintcode <https://www.lintcode.com/problem/178/>

### Description

Given n nodes labeled from 0 to n-1 and a list of undirected edges (each edge is a pair of nodes), write a function to check whether these edges make up a valid tree.

**Example 1:**

```plain
Input: n = 5, and edges = [[0,1], [0,2], [0,3], [1,4]]
Output: true
```

**Example 2:**

```plain
Input: n = 5, and edges = [[0,1], [1,2], [2,3], [1,3], [1,4]]
Output: false
```

Before solving the problem, we have to know the definitions.



图的存储形式：邻接表表示方法 adjcent list

Map<Integer, Set<Integer>> graph = new HashMap<>();

还有另一种方法 Union Find 并查集的方法。

### Solutions

**Accepted in Lintcode**

```java
// version 1: BFS

import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.Map;
import java.util.Queue;

public class Solution {

    /**
     * @param n an integer
     * @param edges a list of undirected edges
     * @return true if it's a valid tree. or false
     */

     public boolean validTree(int n, int[][] edges) {
        if (n == 0) {
            return false;
        }

        if (edges.length != n - 1) {
            return false;
        }

        Map<Integer, Set<Integer>> graph = initializaGraph(n, edges);
        
        // bfs
        Queue<Integer> queue = new LinkedList<>();
        Set<Integer> hash = new HashSet<>();

        queue.offer(0);
        hash.add(0);
        while (!queue.isEmpty()) {
            int node = queue.poll();
            for (Integer neighbor : graph.get(node)) {
                if (hash.contains(neighbor)) {
                    continue;
                }
                hash.add(neighbor);
                queue.offer(neighbor);
            } // end for neighbor
        } // end while loop

        return (hash.size() == n);
     } // end validTree

    private Map<Integer, Set<Integer>> initializaGraph(int n, int[][] edges) {
        Map<Integer, Set<Integer>> graph = new HashMap<>();
        for (int i = 0; i < n; i++) {
            graph.put(i, new HashSet<Integer>());
        } // end for i in n

        for (int i = 0; i < edges.length; i++) {
            int u = edges[i][0];
            int v = edges[i][1];
            graph.get(u).add(v);
            graph.get(v).add(u);
        } // end for i in edges.length

        return graph;
    } // end initializaGraph
} // end Solution
```

## Clone Graph

图的遍历（由点及面）

Lintcode <https://www.lintcode.com/problem/clone-graph/>

Leetcode <https://leetcode.com/problems/clone-graph/>

Solution <https://www.jiuzhang.com/solutions/clone-graph/>

### Description

Given a reference of a node in a [connected](https://en.wikipedia.org/wiki/Connectivity_(graph_theory)#Connected_graph) undirected graph.

Return a [deep copy](https://en.wikipedia.org/wiki/Object_copying#Deep_copy) (clone) of the graph.

Each node in the graph contains a value (int) and a list (List[Node]) of its neighbors.

class Node {     public int val;     public List<Node> neighbors; } 



**Test case format:**

For simplicity, each node's value is the same as the node's index (1-indexed). For example, the first node with val == 1, the second node with val == 2, and so on. The graph is represented in the test case using an adjacency list.

**An adjacency list** is a collection of unordered **lists** used to represent a finite graph. Each list describes the set of neighbors of a node in the graph.

The given node will always be the first node with val = 1. You must return the **copy of the given node** as a reference to the cloned graph.



**Example 1:**

![img](133_clone_graph_question.png)

Input: adjList = [[2,4],[1,3],[2,4],[1,3]] 

Output: [[2,4],[1,3],[2,4],[1,3]] 

Explanation: There are 4 nodes in the graph. 

1st node (val = 1)'s neighbors are 2nd node (val = 2) and 4th node (val = 4). 

2nd node (val = 2)'s neighbors are 1st node (val = 1) and 3rd node (val = 3). 

3rd node (val = 3)'s neighbors are 2nd node (val = 2) and 4th node (val = 4). 

4th node (val = 4)'s neighbors are 1st node (val = 1) and 3rd node (val = 3). 

**Example 2:**

![img](graph.png)

Input: adjList = [[]] 

Output: [[]] 

Explanation: Note that the input contains one empty list. The graph consists of only one node with val = 1 and it does not have any neighbors. 

**Example 3:**

Input: adjList = [] Output: [] Explanation: This an empty graph, it does not have any nodes. 



**Constraints:**

- The number of nodes in the graph is in the range [0, 100].
- 1 <= Node.val <= 100
- Node.val is unique for each node.
- There are no repeated edges and no self-loops in the graph.
- The Graph is connected and all nodes can be visited starting from the given node.



### Solutions

1. node -> nodes
2. copy nodes
3. copy edges

```java
/**
 * Definition for undirected graph.
 * class UndirectedGraphNode {
 *     int label;
 *     ArrayList<UndirectedGraphNode> neighbors;
 *     UndirectedGraphNode(int x) { label = x; neighbors = new ArrayList<UndirectedGraphNode>(); }
 * };
 */
public class Solution {
    /**
     * @param node: A undirected graph node
     * @return: A undirected graph node
     */
    public UndirectedGraphNode cloneGraph(UndirectedGraphNode node) {
        if (node == null) {
            return node;
        }

        // use bfs algorithm to traverse the graph and get all nodes.
        ArrayList<UndirectedGraphNode> nodes = getNodes(node);

        // copy nodes, store the old->new mapping information in a hash map
        HashMap<UndirectedGraphNode, UndirectedGraphNode> mapping = new HashMap<>();
        for (UndirectedGraphNode n : nodes) {
            mapping.put(n, new UndirectedGraphNode(n.label));
        }

        // copy neighbors(edges)
        for (UndirectedGraphNode n : nodes) {
            UndirectedGraphNode newNode = mapping.get(n);
            for (UndirectedGraphNode neighbor : n.neighbors) {
                UndirectedGraphNode newNeighbor = mapping.get(neighbor);
                newNode.neighbors.add(newNeighbor);
            }
        }

        return mapping.get(node);
    }

    private ArrayList<UndirectedGraphNode> getNodes(UndirectedGraphNode node) {
        Queue<UndirectedGraphNode> queue = new LinkedList<UndirectedGraphNode>();
        HashSet<UndirectedGraphNode> set = new HashSet<>();

        queue.offer(node);
        set.add(node);
        while (!queue.isEmpty()) {
            UndirectedGraphNode head = queue.poll();
            for (UndirectedGraphNode neighbor : head.neighbors) {
                if (!set.contains(neighbor)) {
                    set.add(neighbor);
                    queue.offer(neighbor);
                }
            }
        }

        return new ArrayList<UndirectedGraphNode>(set);
    }
}
```

## 独孤九剑——破枪式

能够用 BFS 解决的问题，一定**不要用**DFS去做！！！

因为用 Recursion 实现的 DFS 可能造成 StackOverflow!

（NonRecursion 的 DFS 一来你不会写，二来面试官也看不懂）

图的遍历（由点及面）

问：为什么不需要做分层遍历？

follow up: 如何找到所有最近的 value = target 的点？

## Search Graph Nodes

Lintcode <https://www.lintcode.com/problem/search-graph-nodes>

Solution <https://www.jiuzhang.com/solutions/search-graph-nodes>

### Description

Given a undirected graph, a node and a target, return the nearest node to given node which value of it is target, return NULL if you can't find.

There is a mapping store the nodes' values in the given parameters.

**Notice**

It's guaranteed there is only one available solution

**Example**

```plain
2------3  5
 \     |  | 
  \    |  |
   \   |  |
    \  |  |
      1 --4
Give a node 1, target is 50

there a hash named values which is [3,4,10,50,50], represent:
Value of node 1 is 3
Value of node 2 is 4
Value of node 3 is 10
Value of node 4 is 50
Value of node 5 is 50

Return node 4
```

### Solutions

朴素bfs即可。

```java
/**
 * Definition for graph node.
 * class UndirectedGraphNode {
 *     int label;
 *     ArrayList<UndirectedGraphNode> neighbors;
 *     UndirectedGraphNode(int x) { 
 *         label = x; neighbors = new ArrayList<UndirectedGraphNode>(); 
 *     }
 * };
 */
public class Solution {
    /**
     * @param graph a list of Undirected graph node
     * @param values a hash mapping, <UndirectedGraphNode, (int)value>
     * @param node an Undirected graph node
     * @param target an integer
     * @return the a node
     */
    public UndirectedGraphNode searchNode(ArrayList<UndirectedGraphNode> graph,
                                          Map<UndirectedGraphNode, Integer> values,
                                          UndirectedGraphNode node,
                                          int target) {
        // Write your code here
        Set<UndirectedGraphNode> set = new HashSet<UndirectedGraphNode>();
        Queue<UndirectedGraphNode> queue = new LinkedList<UndirectedGraphNode>();
        queue.offer(node);
        set.add(node);
        while(!queue.isEmpty()) {
            UndirectedGraphNode currentNode = queue.poll();
            if(values.get(currentNode) == target) {
                return currentNode;
            }
            for(UndirectedGraphNode neighbor : currentNode.neighbors){
                if(!set.contains(neighbor)) {
                   queue.offer(neighbor);
                   set.add(neighbor);
                }
            }
        }
        return null;
    }
}
```

## Topological Sorting

几乎每个公司都有一道拓扑排序的面试题！

问：可以使用 DFS 来做吗？

拓扑排序是排序吗？不是排序，它排的是拓扑序，一种依赖关系。

Lintcode <https://www.lintcode.com/problem/topological-sorting/>

Solution <https://www.jiuzhang.com/solutions/topological-sorting>

### Description

Given an directed graph, a topological order of the graph nodes is defined as follow:

- For each directed edge A -> B in graph, A must before B in the order list.
- The first node in the order can be any node in the graph with no nodes direct to it.

Find any topological order for the given graph.

You can assume that there is at least one topological order in the graph.



**Example 1:**

Input:

```plain
graph = {0,1,2,3#1,4#2,4,5#3,4,5#4#5}
```

Output:

Explanation:

For graph as follow:

![img](topologicalsorting.jpg)

the topological order can be:
[0, 1, 2, 3, 4, 5]
[0, 2, 3, 1, 5, 4]
...
You only need to return any topological order for the given graph.



**Follow up**

Can you do it in both BFS and DFS?



### Solutions

如果用递归实现会爆栈。

虽然可以用DFS，但是不要用DFS，你会坑死你自己的。

```java
/**
 * Definition for Directed graph.
 * class DirectedGraphNode {
 *     int label;
 *     ArrayList<DirectedGraphNode> neighbors;
 *     DirectedGraphNode(int x) { label = x; neighbors = new ArrayList<DirectedGraphNode>(); }
 * };
 */
public class Solution {
    /**
     * @param graph: A list of Directed graph node
     * @return: Any topological order for the given graph.
     */    
    public ArrayList<DirectedGraphNode> topSort(ArrayList<DirectedGraphNode> graph) {
        // write your code here
        ArrayList<DirectedGraphNode> result = new ArrayList<DirectedGraphNode>();
        HashMap<DirectedGraphNode, Integer> map = new HashMap();
        for (DirectedGraphNode node : graph) {
            for (DirectedGraphNode neighbor : node.neighbors) {
                if (map.containsKey(neighbor)) {
                    map.put(neighbor, map.get(neighbor) + 1);
                } else {
                    map.put(neighbor, 1); 
                }
            }
        }
        Queue<DirectedGraphNode> q = new LinkedList<DirectedGraphNode>();
        for (DirectedGraphNode node : graph) {
            if (!map.containsKey(node)) {
                q.offer(node);	
                result.add(node);
            }
        }
        while (!q.isEmpty()) {
            DirectedGraphNode node = q.poll();
            for (DirectedGraphNode n : node.neighbors) {
                map.put(n, map.get(n) - 1);
                if (map.get(n) == 0) {
                    result.add(n);
                    q.offer(n);
                }
            }
        }
        return result;
    }
}
```

## 拓扑排序相关题

**Course Schedule 1 && 2**

课程表 <https://www.lintcode.com/problem/course-schedule/>

课程表2 <https://www.lintcode.com/problem/course-schedule-ii/>

裸拓扑排序



**Sequence Reconstruction**

<https://www.lintcode.com/problem/sequence-reconstruction/>

判断是否只存在一个拓扑排序的序列

只需要保证队列中一直最多只有1个元素即可



还有一种题目让你判断能不能被拓扑排序

## BFS in Matrix

矩阵中的宽度优先搜索

### 图 Graph

N个点，M条边

M最大是 O(N^2) 的级别

图上 BFS 时间复杂度 = O(N + M)

说是 O(M) 问题也不大，因为 M 一般都比 N 大，所以最坏情况可能是 O(N^2)



### 矩阵 Matrix

R行C列

RxC个点，RxCx2 条边（每个点上下左右 4 条边，每条边被 2 个点共享）。

矩阵中 BFS 时间复杂度 = O(R * C)

## Number of Islands

Lintcode <https://www.lintcode.com/problem/number-of-islands/>

Leetcode <https://leetcode.com/problems/number-of-islands/>

Solution <https://www.jiuzhang.com/solutions/number-of-islands/>

图的遍历（由点及面）

### Description

Given an m x n 2D binary grid grid which represents a map of '1's (land) and '0's (water), return *the number of islands*.

An **island** is surrounded by water and is formed by connecting adjacent lands horizontally or vertically. You may assume all four edges of the grid are all surrounded by water.



**Example 1:**

Input: grid = [   

["1","1","1","1","0"],   

["1","1","0","1","0"],   

["1","1","0","0","0"],   

["0","0","0","0","0"] ] 

Output: 1 

**Example 2:**

Input: grid = [   

["1","1","0","0","0"],   

["1","1","0","0","0"],   

["0","0","1","0","0"],   

["0","0","0","1","1"] ] 

Output: 3 



**Constraints:**

- m == grid.length
- n == grid[i].length
- 1 <= m, n <= 300
- grid[i][j] is '0' or '1'.



### Solutions

```java
// version 1: BFS
class Coordinate {
    int x, y;
    public Coordinate(int x, int y) {
        this.x = x;
        this.y = y;
    }
}

public class Solution {
    /**
     * @param grid a boolean 2D matrix
     * @return an integer
     */
    public int numIslands(boolean[][] grid) {
        if (grid == null || grid.length == 0 || grid[0].length == 0) {
            return 0;
        }
        
        int n = grid.length;
        int m = grid[0].length;
        int islands = 0;
        
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (grid[i][j]) {
                    markByBFS(grid, i, j);
                    islands++;
                }
            }
        }
        
        return islands;
    }
    
    private void markByBFS(boolean[][] grid, int x, int y) {
        // magic numbers!
        int[] directionX = {0, 1, -1, 0};
        int[] directionY = {1, 0, 0, -1};
        
        Queue<Coordinate> queue = new LinkedList<>();
        
        queue.offer(new Coordinate(x, y));
        grid[x][y] = false;
        
        while (!queue.isEmpty()) {
            Coordinate coor = queue.poll();
            for (int i = 0; i < 4; i++) {
                Coordinate adj = new Coordinate(
                    coor.x + directionX[i],
                    coor.y + directionY[i]
                );
                if (!inBound(adj, grid)) {
                    continue;
                }
                if (grid[adj.x][adj.y]) {
                    grid[adj.x][adj.y] = false;
                    queue.offer(adj);
                }
            }
        }
    }
    
    private boolean inBound(Coordinate coor, boolean[][] grid) {
        int n = grid.length;
        int m = grid[0].length;
        
        return coor.x >= 0 && coor.x < n && coor.y >= 0 && coor.y < m;
    }
}
```



```java
// version 2: Union Find
class UnionFind { 

    private int[] father = null;
    private int count;

    private int find(int x) {
        if (father[x] == x) {
            return x;
        }
        return father[x] = find(father[x]);
    }

    public UnionFind(int n) {
        // initialize your data structure here.
        father = new int[n];
        for (int i = 0; i < n; ++i) {
            father[i] = i;
        }
    }

    public void connect(int a, int b) {
        // Write your code here
        int root_a = find(a);
        int root_b = find(b);
        if (root_a != root_b) {
            father[root_a] = root_b;
            count --;
        }
    }
        
    public int query() {
        // Write your code here
        return count;
    }
    
    public void set_count(int total) {
        count = total;
    }
}

public class Solution {
    /**
     * @param grid a boolean 2D matrix
     * @return an integer
     */
    public int numIslands(boolean[][] grid) {
        int count = 0;
        int n = grid.length;
        if (n == 0)
            return 0;
        int m = grid[0].length;
        if (m == 0)
            return 0;
        UnionFind union_find = new UnionFind(n * m);
        
        int total = 0;
        for(int i = 0;i < grid.length; ++i)
            for(int j = 0;j < grid[0].length; ++j)
            if (grid[i][j])
                total ++;
    
        union_find.set_count(total);
        for(int i = 0;i < grid.length; ++i)
            for(int j = 0;j < grid[0].length; ++j)
            if (grid[i][j]) {
                if (i > 0 && grid[i - 1][j]) {
                    union_find.connect(i * m + j, (i - 1) * m + j);
                }
                if (i <  n - 1 && grid[i + 1][j]) {
                    union_find.connect(i * m + j, (i + 1) * m + j);
                }
                if (j > 0 && grid[i][j - 1]) {
                    union_find.connect(i * m + j, i * m + j - 1);
                }
                if (j < m - 1 && grid[i][j + 1]) {
                    union_find.connect(i * m + j, i * m + j + 1);
                }
            }
        return union_find.query();
    }
}
// version 3: DFS (not recommended)
public class Solution {
    /**
     * @param grid a boolean 2D matrix
     * @return an integer
     */
    private int m, n;
    public void dfs(boolean[][] grid, int i, int j) {
        if (i < 0 || i >= m || j < 0 || j >= n) return;
        
        if (grid[i][j]) {
            grid[i][j] = false;
            dfs(grid, i - 1, j);
            dfs(grid, i + 1, j);
            dfs(grid, i, j - 1);
            dfs(grid, i, j + 1);
        }
    }

    public int numIslands(boolean[][] grid) {
        // Write your code here
        m = grid.length;
        if (m == 0) return 0;
        n = grid[0].length;
        if (n == 0) return 0;
        
        int ans = 0;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (!grid[i][j]) continue;
                ans++;
                dfs(grid, i, j);
            }
        }
        return ans;
    }
}
//version 
public class Solution {
    /**
     * @param grid: a boolean 2D matrix
     * @return: an integer
     */
    public int numIslands(boolean[][] grid) {
        // write your code here
        if (grid == null || grid.length == 0 || grid[0].length == 0) {
            return 0;
        }
        int ans = 0;
        boolean[][] v = new boolean[grid.length][grid[0].length];

        for (int i = 0; i < grid.length; i++) {
            for (int j = 0; j < grid[0].length; j++) {
                if (grid[i][j] && !v[i][j]) {
                    ans++;
                    bfs(grid, v, i, j);
                }
            }
        }
        return ans;
    } // end numIslands

    private void bfs(boolean[][] grid, boolean[][] v, int sx, int sy) {
        int[] dx = {1, 0, 0, -1};
        int[] dy = {0, 1, -1, 0};

        Queue<Integer> qx = new LinkedList<>();
        Queue<Integer> qy = new LinkedList<>();

        qx.offer(sx);
        qy.offer(sy);
        v[sx][sy] = true;

        while (!qx.isEmpty()) {
            int cx = qx.poll();
            int cy = qy.poll();

            for (int i = 0; i < 4; i++) {
                int nx = cx + dx[i];
                int ny = cy + dy[i];
                if (0 <= nx && nx < grid.length && 0 <= ny && ny < grid[0].length && !v[nx][ny] && grid[nx][ny]) {
                    qx.offer(nx);
                    qy.offer(ny);
                    v[nx][ny] = true;
                }
            } // end for i
        } // end while loop
    } // end dfs
} // end Solution
```

## 坐标变化数组

非常有用的trick!!!

```
int[] deltaX = { 1, 0, 0, -1 };
int[] deltaY = { 0, 1, -1, 0 };
```

问：写出八个方向的坐标变换数组？



isBound 是否还在matrix里面

```java
private boolean inBound(Coordinate coor, boolean[][] grid) {
    int n = grid.length;
    int m = grid[0].length;

    return coor.x >= 0 && coor.x < n && coor.y >= 0 && coor.y < m;
} // end inBound
```

## Zombie in Matrix

Lintcode <https://www.lintcode.com/problem/zombie-in-matrix/>

Solution <https://www.jiuzhang.com/solutions/zombie-in-matrix/>

Leetcode Disscuss <https://leetcode.com/discuss/interview-question/411357/>

图的遍历（层级遍历）

## Build Post Office ii

Lintcode <https://www.lintcode.com/problem/build-post-office-ii/>

Solution <https://www.jiuzhang.com/solutions/build-post-office-ii/>

简单图最短路径

## Knight Shortest Path

简单图最短路径

follow up: speed up?

这个题就8个方向！

Lintcode <https://www.lintcode.com/problem/knight-shortest-path/>

Solution <https://www.jiuzhang.com/solutions/knight-shortest-path/>

## Conclusion

- 能用 BFS 的一定不要用 DFS （除非面试官特别要求）

- BFS 的两个使用条件

  - 图的遍历（由点及面，层级遍历）

  - 简单图最短路径

- 是否需要层级遍历
  - size = queue.size()

- **拓扑排序必须掌握！**

- 坐标变化数组

  - deltaX, deltaY

  - inBound