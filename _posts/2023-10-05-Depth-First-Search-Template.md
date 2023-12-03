---
title: Depth First Search Template
date: 2023-10-05 16:17:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Graph, Search]
pin: false
math: true
mermaid: false
img_path: /assets/images/BFSImages/
---

## Outline

- Recursion
- Combination
- Permutation
- Graph
- Non-Recursion



什么时候使用 DFS？

回顾：还记得什么时候使用 BFS 吗？

## 通用的DFS时间复杂度计算通用公式

- **搜索的时间复杂度：O(答案总数 \* 构造每个答案的时间)**

举例：Subsets问题，求所有的子集。子集个数一共 2^n，每个集合的平均长度是 O(n) 的，所以时间复杂度为 O(n * 2^n)，同理 Permutations 问题的时间复杂度为：O(n * n!)

- **动态规划的时间复杂度：O(状态总数 \* 计算每个状态的时间复杂度)**

举例：triangle，数字三角形的最短路径，状态总数约 O(n^2) 个，计算每个状态的时间复杂度为 O(1)——就是求一下 min。所以总的时间复杂度为 O(n^2)

- **用分治法解决二叉树问题的时间复杂度：O(二叉树节点个数 \* 每个节点的计算时间)**

举例：二叉树最大深度。二叉树节点个数为 N，每个节点上的计算时间为 O(1)。总的时间复杂度为 O(N)

## 组合搜索问题 Combination

- **问题模型：**求出所有满足条件的"组合"。
- **判断条件：**组合中的元素是顺序无关的。
- **时间复杂度：**与 2^n 相关。

典型题目：全子集 Subsets

1. Combination Sum
2. Palindrome Partitioning

### 递归三要素

一般来说，如果面试官不特别要求的话，DFS 都可以使用递归（Recursion）的方式来实现。

递归三要素是实现递归的重要步骤：

1. 递归的定义
2. 递归的拆解
3. 递归的出口

## Combination Sum

Leetcode <https://leetcode.com/problems/combination-sum/>

Lintcode <https://www.lintcode.com/problem/combination-sum/>

Solution <https://www.jiuzhang.com/solutions/combination-sum/>

**问：和 Subsets 的区别有哪些？？？**

1. 每个数可以重复的选，duplicate

1. 答案里面可能有 duplicate
2. 输入数据可能就有 duplicate

1. 有一个目标值来filter，target

针对 b. 先去重(521. Remove Duplicate Numbers in Array)，然后再搜索

另一种办法，可以先标记，遇到重复的就 continue，if 遇到了和前面的数相同就跳过

Combination Sum 限制了组合中的数之和 -> 加入一个新的参数来限制

Subsets 无重复元素，Combination Sum 有重复元素 -> 需要先去重

Subsets 一个数只能选一次，Combination Sum 一个数可以选很多次 -> 搜索时从 index 开始而不是 index + 1 

### Description

Given an array of **distinct** integers candidates and a target integer target, return *a list of all* ***unique combinations\*** *of* candidates *where the chosen numbers sum to* target*.* You may return the combinations in **any order**.

The **same** number may be chosen from candidates an **unlimited number of times**. Two combinations are unique if the frequency of at least one of the chosen numbers is different.

The test cases are generated such that the number of unique combinations that sum up to target is less than 150 combinations for the given input.



**Example 1:**

Input: candidates = [2,3,6,7], target = 7 Output: [[2,2,3],[7]] Explanation: 2 and 3 are candidates, and 2 + 2 + 3 = 7. Note that 2 can be used multiple times. 7 is a candidate, and 7 = 7. These are the only two combinations. 

**Example 2:**

Input: candidates = [2,3,5], target = 8 

Output: [ [2, 2, 2, 2], [2, 3, 3], [3, 5] ] 

**Example 3:**

Input: candidates = [2], target = 1 

Output: [] 



**Constraints:**

- 1 <= candidates.length <= 30
- 2 <= candidates[i] <= 40
- All elements of candidates are **distinct**.
- 1 <= target <= 40

### Solutions

- version 1: Remove duplicates & generate a new array

```java
// version 1: Remove duplicates & generate a new array
public class Solution {
    /**
     * @param candidates: A list of integers
     * @param target:An integer
     * @return: A list of lists of integers
     */
    public List<List<Integer>> combinationSum(int[] candidates, int target) {
        List<List<Integer>> results = new ArrayList<>();
        if (candidates == null || candidates.length == 0) {
            return results;
        }
        
        int[] nums = removeDuplicates(candidates);
        
        dfs(nums, 0, new ArrayList<Integer>(), target, results);
        
        return results;
    }
    
    private int[] removeDuplicates(int[] candidates) {
        Arrays.sort(candidates);
        
        int index = 0;
        for (int i = 0; i < candidates.length; i++) {
            if (candidates[i] != candidates[index]) {
                candidates[++index] = candidates[i];
            }
        }
        
        int[] nums = new int[index + 1];
        for (int i = 0; i < index + 1; i++) {
            nums[i] = candidates[i];
        }
        
        return nums;
    } // end removeDuplicates
    
    private void dfs(int[] nums,
                     int startIndex,
                     List<Integer> combination,
                     int remainTarget,
                     List<List<Integer>> results) {
        if (remainTarget == 0) {
            results.add(new ArrayList<Integer>(combination));
            return;
        }
        
        for (int i = startIndex; i < nums.length; i++) {
            if (remainTarget < nums[i]) {
                break;
            }
            combination.add(nums[i]);
            dfs(nums, i, combination, remainTarget - nums[i], results);
            combination.remove(combination.size() - 1);
        } // end for i
    } // end dfs
} // end Solution
```

- version 2: reuse candidates array

递归的定义：找到所有以 combination 开头的哪些和为 target 的组合

```java
// version 2: reuse candidates array
public class Solution {
    public  List<List<Integer>> combinationSum(int[] candidates, int target) {
        List<List<Integer>> result = new ArrayList<>();
        if (candidates == null) {
            return result;
        }

        List<Integer> combination = new ArrayList<>();
        Arrays.sort(candidates);
        helper(candidates, 0, target, combination, result);

        return result;
    } // end combinationSum

     void helper(int[] candidates,
                 int index,
                 int target,
                 List<Integer> combination,
                 List<List<Integer>> result) {
        if (target == 0) {
            result.add(new ArrayList<Integer>(combination));
            return;
        }

         // 递归的拆解
        for (int i = index; i < candidates.length; i++) {
            if (candidates[i] > target) {
                break;
            }

            if (i != 0 && candidates[i] == candidates[i - 1]) {
                continue;
            }

            combination.add(candidates[i]);
            helper(candidates, i, target - candidates[i], combination, result);
            combination.remove(combination.size() - 1);
        } // end for i
    } // end helper
} // end Solution
```

![img](https://cdn.nlark.com/yuque/0/2023/png/22241519/1696487397023-56f4e596-44a2-49ab-bb35-7c3ce14dde34.png)

## Palindrome Partitioning

回文串分割

Lintcode <https://www.lintcode.com/problem/palindrome-partitioning/>

Leetcode <https://leetcode.com/problems/palindrome-partitioning/>

Solution <https://www.jiuzhang.com/solutions/palindrome-partitioning/>

### Description

Given a string s, partition s such that every substring of the partition is a **palindrome**. Return *all possible palindrome partitioning of* s.

**Example 1:**

Input: s = "aab"

Output: [["a",  "a",  "b"], ["aa", "b"]]

**Example 2:**

Input: s = "a"

Output: [["a"]]

**Constraints:**

- 1 <= s.length <= 16
- s contains only lowercase English letters.

### Solutions

先说结论：所有的切割问题，都是组合问题。

n 个字符的切割问题，就是 n-1 个数字的组合问题。

n 个字母的字符串 -> n-1 个数字的组合，那么这道题就可以完完全全的套用 Subsets。

- startIndex 这一刀可以从哪里切割。

```java
// version 1: shorter but slower
public class Solution {
    /**
     * @param s: A string
     * @return: A list of lists of string
     */
    public List<List<String>> partition(String s) {
        List<List<String>> results = new ArrayList<>();
        if (s == null || s.length() == 0) {
            return results;
        }
        
        List<String> partition = new ArrayList<String>();
        helper(s, 0, partition, results);
        
        return results;
    }
    
    private void helper(String s,
                        int startIndex,
                        List<String> partition,
                        List<List<String>> results) {
        if (startIndex == s.length()) {
            results.add(new ArrayList<String>(partition));
            return;
        }
        
        for (int i = startIndex; i < s.length(); i++) {
            String subString = s.substring(startIndex, i + 1);
            if (!isPalindrome(subString)) {
                continue;
            }
            partition.add(subString);
            helper(s, i + 1, partition, results);
            partition.remove(partition.size() - 1);
        }
    }
    
    private boolean isPalindrome(String s) {
        for (int i = 0, j = s.length() - 1; i < j; i++, j--) {
            if (s.charAt(i) != s.charAt(j)) {
                return false;
            }
        }
        return true;
    }
}
```

有的公司面试题就是让你判断一个回文串，还不会写？？？`isPalindrome(String s)`

1. 可以用 HashMap 来存储 s？getkey操作是 O(sizeof key)，不是O(1)，这个字符串多长就是多长，这个方法不行！
2. 一个字符串的子串Substring数量级是 n^2。子序列Subsequence才是 2^n。

可以优化的空间就是下面这个方法，用 区间型动态规划 的方式。其实是递推。

算是预处理`getIsPalindrome(String s)`，这个小的优化技巧需要**记住一下！**

```java
// version 2: longer but faster
public class Solution {
    List<List<String>> results;
    boolean[][] isPalindrome;
    
    /**
     * @param s: A string
     * @return: A list of lists of string
     */
    public List<List<String>> partition(String s) {
        results = new ArrayList<>();
        if (s == null || s.length() == 0) {
            return results;
        }
        
        getIsPalindrome(s);
        
        helper(s, 0, new ArrayList<Integer>());
        
        return results;
    }
    
    private void getIsPalindrome(String s) {
        int n = s.length();
        isPalindrome = new boolean[n][n];
        
        for (int i = 0; i < n; i++) {
            isPalindrome[i][i] = true;
        }
        for (int i = 0; i < n - 1; i++) {
            isPalindrome[i][i + 1] = (s.charAt(i) == s.charAt(i + 1));
        }
        
        for (int i = n - 3; i >= 0; i--) {
            for (int j = i + 2; j < n; j++) {
                isPalindrome[i][j] = isPalindrome[i + 1][j - 1] && s.charAt(i) == s.charAt(j);
            }
        }
    }
    
    private void helper(String s,
                        int startIndex,
                        List<Integer> partition) {
        if (startIndex == s.length()) {
            addResult(s, partition);
            return;
        }
        
        for (int i = startIndex; i < s.length(); i++) {
            if (!isPalindrome[startIndex][i]) {
                continue;
            }
            partition.add(i);
            helper(s, i + 1, partition);
            partition.remove(partition.size() - 1);
        }
    }
    
    private void addResult(String s, List<Integer> partition) {
        List<String> result = new ArrayList<>();
        int startIndex = 0;
        for (int i = 0; i < partition.size(); i++) {
            result.add(s.substring(startIndex, partition.get(i) + 1));
            startIndex = partition.get(i) + 1;
        }
        results.add(result);
    }
}
```

## 排列搜索问题 Permutation

- **问题模型：**求出所有满足条件的“排列”。
- **判断条件：**组合中的元素是顺序“相关”的。
- **时间复杂度：**与 n! 相关

排列还少传一个参数 startIndex，不需要去重了。



## Permutations

Lintcode <https://www.lintcode.com/problem/permutations/>

Leetcode <https://leetcode.com/problems/permutations/>

Solution <https://www.jiuzhang.com/solutions/permutations/>

### Description

Given an array nums of distinct integers, return *all the possible permutations*. You can return the answer in **any order**.

**Example 1:**

Input: nums = [1, 2, 3]

Output: [[1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1]]

**Example 2:**

Input: nums = [0, 1]

Output: [[0, 1], [1, 0]]

**Example 3:**

Input: nums = [1]

Output: [[1]]

**Constraints:**

- 1 <= nums.length <= 6
- -10 <= nums[i] <= 10
- All the integers of nums are **unique**.

### Solutions

```java
public class Solution {
    public List<List<Integer>> permute(int[] nums) {
        List<List<Integer>> results = new ArrayList<>();
        if (nums == null) {
            return results; 
        }

        if (nums.length == 0) {
            results.add(new ArrayList<Integer>());
            return results;
        }

        List<Integer> permutation = new ArrayList<Integer>();
        Set<Integer> set = new HashSet<>();
        helper(nums, permutation, set, results);

        return results;
    } // end permute

    // 1. 定义：找到所有以 permutation 开头的排列
    public void helper(int[] nums,
                       List<Integer> permutation,
                       Set<Integer> set,
                       List<List<Integer>> results) {
        // 3. 递归的出口
        if (permutation.size() == nums.length) {
            results.add(new ArrayList<Integer>(permutation));
            return;
        }


        // 2. 用一个循环来实现递归的子任务 
        for (int i = 0; i < nums.length; i++) {
            if (set.contains(nums[i])) {
                continue;
            }

            permutation.add(nums[i]);
            set.add(nums[i]);
            helper(nums, permutation, set, results);
            set.remove(nums[i]);
            permutation.remove(permutation.size() - 1);
        } // for i

    } // end helper
} // end Solution
public class Solution {
    public ArrayList<ArrayList<Integer>> permute(int[] num) {
        ArrayList<ArrayList<Integer>> results = new ArrayList<ArrayList<Integer>>();
        if (num == null || num.length == 0) {
            return results;
        }

        ArrayList<Integer> list = new ArrayList<Integer>();
        helper(results, list, num);
        return results;
    } // end permute

    public void helper(ArrayList<ArrayList<Integer>> results, 
                       ArrayList<Integer> list, 
                       int[] num) {
        if (list.size() == num.length) {
            results.add(new ArrayList<Integer>(list));
            return;
        }

        for (int i = 0; i < num.length; i++) {
            if (list.contains(num[i])) {
                continue;
            }
            list.add(num[i]);
            helper(results, list, num);
            list.remove(list.size() - 1);
        } // end for loop
    } // end helper
} // end Solution
```

## Permutations II

Lintcode <https://www.lintcode.com/problem/permutations-ii/>

Leetcode <https://www.leetcode.com/problems/permutations-ii/>

Solution <https://www.jiuzhang.com/solutions/permutations-ii/>

怎么去重？？

### Description

Given a collection of numbers, nums, ***that might contain duplicates,*** *return all possible unique permutations* *in any order*.

Find all unique permutations.

**Example 1:**

Input: nums = [1, 1, 2]

Output: [ [1, 1, 2], [1, 2, 1], [2, 1, 1] ]

**Example 2:**

Input: nums = [1, 2, 3]

Output: [ [1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1] ]

**Constraints:**

- 1 <= nums.length <= 8
- -10 <= nums[i] <= 10

### Solutions

```java
public class Solution {
    public ArrayList<ArrayList<Integer>> permuteUnique(int[] num) {
        ArrayList<ArrayList<Integer>> result = new ArrayList<ArrayList<Integer>>();
        if (numm == null || num.length == 0) {
            return result;
        }

        ArrayList<Integer> list = new ArrayList<Integer>();
        int[] visited = new int[num.length];

        Arrays.sort(num);
        helper(result, list, visited, num);
    	// 这里递归的中的 list 进去是空，出来肯定还是空。
        return result;
    } // end permuteUnique

    public void helper(ArrayList<ArrayList<Integer>> result, 
                       ArrayList<Integer> list, int[] visited, int[] num) {
        if (list.size() == num.length) {
            result.add(new ArrayList<Integer>(list));
            return;
        }

        for (int i = 0; i < num.length; i++) {
            if (visited[i] == 1 || 
                (i != 0 && num[i] == num[i-1] && visited[i-1] == 0)) {
                continue;
            }

            // [1, 2] => [1, 2, 3]
            visited[i] = 1;
            list.add(num[i]);
            
            // 只是去寻找 list 开头的所有 blablablabla，而不是要把 list 改掉
            helper(result, list, visited, num);
            
            // 回溯：backtracking
            list.remove(list.size() - 1);
            visited[i] = 0;
        } // end for i loop
    } // end helper
} // end Solution
```

## N Queens

Eight Quenes Puzzle <https://en.wikipedia.org/wiki/Eight_queens_puzzle>

Lintcode <https://www.lintcode.com/problem/n-queens/>

Leetcode <https://www.leetcode.com/problems/n-queens/>

Solution <https://www.jiuzhang.com/solutions/n-queens/>

### Description

The **n-queens** puzzle is the problem of placing n queens on an n x n chessboard such that no two queens attack each other.

Given an integer n, return *all distinct solutions to the* **n-queens puzzle**. You may return the answer in **any order**.

Each solution contains a distinct board configuration of the n-queens’ placement, where ‘Q’ and ‘.’ both indicate a queen and an empty space, respectively.

**Example 1:**

Input: n = 4

Output: [ [“.Q..”, “…Q”, “Q…”, “..Q.”],

[”..Q.”, “Q…”, “…Q”, “.Q..”] ]

Explanation: There exist two distinct solutions to the 4-queens puzzle as shown above

**Example 2:**

Input: n = 1

Output: [[“Q”]]

**Constraints:**

- 1 <= n <= 9

### Solutions

斜角攻击，x, y 横纵坐标之差一样，横纵坐标之和一样，另一个方向斜角攻击。

每个函数尽量不超过20行，工程代码尽量不超过50行

```java
class Solution {
    /**
     * Get all distinct N-Queen solutions
     * @param n: The number of queens
     * @return: All distinct solutions
     * For example, A string '...Q' shows a queen on forth position
     */
    List<List<String>> solveNQueens(int n) {
        List<List<String>> results = new ArrayList<>();
        if (n <= 0) {
            return results;
        }
        
        search(results, new ArrayList<Integer>(), n);
        return results;
    } // end solveNQueens
    
    /*
     * results store all of the chessboards
     * cols store the column indices for each row
     */
    private void search(List<List<String>> results,
                        List<Integer> cols,
                        int n) {
        if (cols.size() == n) {
            results.add(drawChessboard(cols));
            return;
        }
        
        for (int colIndex = 0; colIndex < n; colIndex++) {
            if (!isValid(cols, colIndex)) {
                continue;
            }
            cols.add(colIndex);
            search(results, cols, n);
            cols.remove(cols.size() - 1);
        } // end for colIndex
    } // end search
    
    private List<String> drawChessboard(List<Integer> cols) {
        List<String> chessboard = new ArrayList<>();
        for (int i = 0; i < cols.size(); i++) {
            StringBuilder sb = new StringBuilder();
            for (int j = 0; j < cols.size(); j++) {
                sb.append(j == cols.get(i) ? 'Q' : '.');
            }
            chessboard.add(sb.toString());
        }
        return chessboard;
    } // end drawChessboard
    
    private boolean isValid(List<Integer> cols, int column) {
        int row = cols.size();
        for (int rowIndex = 0; rowIndex < cols.size(); rowIndex++) {
            if (cols.get(rowIndex) == column) {
                return false;
            }
            if (rowIndex + cols.get(rowIndex) == row + column) {
                return false;
            }
            if (rowIndex - cols.get(rowIndex) == row - column) {
                return false;
            }
        }
        return true;
    } // end isValid
} // end Solution
```

## 图中搜索问题 Search in a Graph

图中搜索

## Word Ladder

Lintcode <https://www.lintcode.com/problem/word-ladder/>

Leetcode <https://www.leetcode.com/problems/word-ladder/>

Solution <https://www.jiuzhang.com/solutions/word-ladder/>

很具有代表性的一类题，给你一个 start 给你一个 end ，再给你一个规则。

这就是一个图。问你从起点到终点，**求最短路径**。简单图，Simple Graph。

最专业的做法就是宽度优先搜索。

还有一类BFS的问题，叫做九宫格类问题。

**归类：简单图最短路径问题。 就是一种状态的变化，从一个状态变换到另一个状态。**

### Description

A **transformation sequence** from word beginWord to word endWord using a dictionary wordList is a sequence of words beginWord -> s1 -> s2 -> … -> sk such that:

- Every adjacent pair of words differs by a single letter.
- Every si for 1 <= i <= k is in wordList. Note that beginWord does not need to be in wordList.
- sk == endWord

Given two words, beginWord and endWord, and a dictionary wordList, return *the* ***number of words\*** *in the* ***shortest transformation sequence\*** *from* beginWord *to* endWord*, or* 0 *if no such sequence exists.*

**Example 1:**

Input: beginWord = “hit”, endWord = “cog”, wordList = [“hot”,”dot”,”dog”,”lot”,”log”,”cog”]

Output: 5

Explanation: One shortest transformation sequence is “hit” -> “hot” -> “dot” -> “dog” -> cog”, which is 5 words long.

**Example 2:**

Input: beginWord = “hit”, endWord = “cog”, wordList = [“hot”,”dot”,”dog”,”lot”,”log”]

Output: 0

Explanation: The endWord “cog” is not in wordList, therefore there is no valid transformation sequence.

**Constraints:**

- 1 <= beginWord.length <= 10
- endWord.length == beginWord.length
- 1 <= wordList.length <= 5000
- wordList[i].length == beginWord.length
- beginWord, endWord, and wordList[i] consist of lowercase English letters.
- beginWord != endWord
- All the words in wordList are **unique**.

### Solutions

- version: LintCode ( Set<String> )

```java
// version: LintCode ( Set<String> )
public class Solution {
    public int ladderLength(String start, String end, Set<String> dict) {
        if (dict == null) {
            return 0;
        }

        if (start.equals(end)) {
            return 1;
        }

        dict.add(start);
        dict.add(end);

        HashSet<String> hash = new HashSet<String>();
        Queue<String> queue = new LinkedList<String>();
        queue.offer(start);
        hash.add(start);

        int length = 1;
        while(!queue.isEmpty()) { // 开始bfs
            length++;
            int size = queue.size(); // 当前步数的队列大小
            for (int i = 0; i < size; i++) {
                String word = queue.poll();
                for (String nextWord: getNextWords(word, dict)) { // 得到新单词
                    if (hash.contains(nextWord)) {
                        continue;
                    }
                    if (nextWord.equals(end)) {
                        return length;
                    }

                    hash.add(nextWord);
                    queue.offer(nextWord); // 存入队列继续搜索
                }
            }
        }
        return 0;
    }

    // replace character of a string at given index to a given character
    // return a new string
    private String replace(String s, int index, char c) {
        char[] chars = s.toCharArray();
        chars[index] = c;
        return new String(chars);
    } // end replace

    // get connections with given word.
    // for example, given word = 'hot', dict = {'hot', 'hit', 'hog'}
    // it will return ['hit', 'hog']
    private ArrayList<String> getNextWords(String word, Set<String> dict) {
        ArrayList<String> nextWords = new ArrayList<String>();
        for (char c = 'a'; c <= 'z'; c++) { // 枚举当前替换字母
            for (int i = 0; i < word.length(); i++) { // 枚举替换位置
                if (c == word.charAt(i)) {
                    continue;
                }
                String nextWord = replace(word, i, c);
                if (dict.contains(nextWord)) { // 如果dict中包含新单词，存入nextWords
                    nextWords.add(nextWord);
                }
            } // for i
        } // for c
        
        return nextWords; // 构造当前单词的全部下一步方案
    } // end getNextWords
} // end Solution
```

- version: LeetCode

```java
// version: LeetCode
public class Solution {
    public int ladderLength(String start, String end, List<String> wordList) {
        Set<String> dict = new HashSet<>();
        for (String word : wordList) { // 将wordList中的单词加入dict
            dict.add(word);
        }
        
        if (start.equals(end)) {
            return 1;
        }
        
        HashSet<String> hash = new HashSet<String>();
        Queue<String> queue = new LinkedList<String>();
        queue.offer(start);
        hash.add(start);
        
        int length = 1;
        while (!queue.isEmpty()) { // 开始bfs
            length++;
            int size = queue.size();
            for (int i = 0; i < size; i++) { // 枚举当前步数队列的情况
                String word = queue.poll();
                for (String nextWord: getNextWords(word, dict)) {
                    if (hash.contains(nextWord)) {
                        continue;
                    }
                    if (nextWord.equals(end)) {
                        return length;
                    }
                    
                    hash.add(nextWord); // 存入新单词
                    queue.offer(nextWord);
                } // end for nextWord
            } // end for i
        } // end while loop
        
        return 0;
    } // end ladderLength

    // replace character of a string at given index to a given character
    // return a new string
    private String replace(String s, int index, char c) {
        char[] chars = s.toCharArray();
        chars[index] = c;
        return new String(chars);
    } // end replace
    
    // get connections with given word.
    // for example, given word = 'hot', dict = {'hot', 'hit', 'hog'}
    // it will return ['hit', 'hog']
    private ArrayList<String> getNextWords(String word, Set<String> dict) {
        ArrayList<String> nextWords = new ArrayList<String>();
        for (char c = 'a'; c <= 'z'; c++) { //枚举替换字母
            for (int i = 0; i < word.length(); i++) { // 枚举替换位置
                if (c == word.charAt(i)) {
                    continue;
                }
                String nextWord = replace(word, i, c);
                if (dict.contains(nextWord)) { // 如果dict中包含新单词，存入nextWords O(sizeof nextWord)
                    nextWords.add(nextWord);
                }
            } // end for i
        } // end for c
        return nextWords; // 构造当前单词的全部下一步方案
    } // end getNextWords
} // end Solution
```

## Word Ladder II

还要找出所有的方案，这就要用到 BFS + DFS 了

Lintcode <https://www.lintcode.com/problem/word-ladder-ii/>

Leetcode <https://www.leetcode.com/problems/word-ladder-ii/>

Solution <https://www.jiuzhang.com/solutions/word-ladder-ii/>

### Description

A **transformation sequence** from word beginWord to word endWord using a dictionary wordList is a sequence of words beginWord -> s1 -> s2 -> … -> sk such that:

- Every adjacent pair of words differs by a single letter.
- Every si for 1 <= i <= k is in wordList. Note that beginWord does not need to be in wordList.
- sk == endWord

Given two words, beginWord and endWord, and a dictionary wordList, return all the **shortest transformation sequences** rom beginWord to endWord, or an empty list if no such sequence exists. Each sequence should be returned as a list of the words [beginWord, s1, s2, …, sk].

**Example 1:**

Input: beginWord = “hit”, endWord = “cog”, wordList = [“hot”,”dot”,”dog”,”lot”,”log”,”cog”]

Output: [[“hit”,”hot”,”dot”,”dog”,”cog”],[“hit”,”hot”,”lot”,”log”,”cog”]]

Explanation: There are 2 shortest transformation sequences: “hit” -> “hot” -> “dot” -> “dog” -> “cog” “hit” -> “hot” -> “lot” -> “log” -> “cog”

**Example 2:**

Input: beginWord = “hit”, endWord = “cog”, wordList = [“hot”,”dot”,”dog”,”lot”,”log”]

Output: []

Explanation: The endWord “cog” is not in wordList, therefore there is no valid transformation sequence.

**Constraints:**

- 1 <= beginWord.length <= 5
- endWord.length == beginWord.length
- 1 <= wordList.length <= 500
- wordList[i].length == beginWord.length
- beginWord, endWord, and wordList[i] consist of lowercase English letters.
- beginWord != endWord
- All the words in wordList are **unique**.
- The **sum** of all shortest transformation sequences does not exceed 10^5.

### Solutions

- end -> start : bfs start -> end : dfs

```java
public class Solution {
    public List<List<String>> findLadders(String start, String end,
            Set<String> dict) {
        List<List<String>> ladders = new ArrayList<List<String>>();
        Map<String, List<String>> map = new HashMap<String, List<String>>();
        Map<String, Integer> distance = new HashMap<String, Integer>();

        dict.add(start);
        dict.add(end);
 
        bfs(map, distance, end, start, dict);
        
        List<String> path = new ArrayList<String>();
        
        dfs(ladders, path, start, end, distance, map);

        return ladders;
    } // end findLadders

    void dfs(List<List<String>> ladders, List<String> path, String crt,
            String end, Map<String, Integer> distance,
            Map<String, List<String>> map) {
        path.add(crt);
        if (crt.equals(end)) {
            ladders.add(new ArrayList<String>(path));
        } else {
            for (String next : map.get(crt)) {
                if (distance.containsKey(next) && distance.get(crt) == distance.get(next) + 1) { 
                    dfs(ladders, path, next, end, distance, map);
                }
            } // end for next
        }
        path.remove(path.size() - 1);
    } // end dfs

    void bfs(Map<String, List<String>> map, Map<String, Integer> distance,
            String start, String end, Set<String> dict) {
        Queue<String> q = new LinkedList<String>();
        q.offer(start);
        distance.put(start, 0);
        for (String s : dict) {
            map.put(s, new ArrayList<String>());
        } // end for s
        
        while (!q.isEmpty()) {
            String crt = q.poll();

            List<String> nextList = expand(crt, dict);
            for (String next : nextList) {
                map.get(next).add(crt);
                if (!distance.containsKey(next)) {
                    distance.put(next, distance.get(crt) + 1);
                    q.offer(next);
                }
            } // end for next
        } // end while loop
    } // end bfs

    List<String> expand(String crt, Set<String> dict) {
        List<String> expansion = new ArrayList<String>();

        for (int i = 0; i < crt.length(); i++) {
            for (char ch = 'a'; ch <= 'z'; ch++) {
                if (ch != crt.charAt(i)) {
                    String expanded = crt.substring(0, i) + ch
                            + crt.substring(i + 1);
                    if (dict.contains(expanded)) {
                        expansion.add(expanded);
                    }
                }
            } // end for ch
        } // end for i

        return expansion;
    } // end expand
} // end Solution
```

- start -> end: bfs end -> start: dfs

```java
public class Solution {
    public List<List<String>> findLadders(String start, String end,
            Set<String> dict) {
        List<List<String>> ladders = new ArrayList<List<String>>();
        Map<String, List<String>> map = new HashMap<String, List<String>>();
        Map<String, Integer> distance = new HashMap<String, Integer>();

        dict.add(start);
        dict.add(end);
 
        bfs(map, distance, start, end, dict);
        
        List<String> path = new ArrayList<String>();
        
        dfs(ladders, path, end, start, distance, map);

        return ladders;
    } // end findLadders

    void dfs(List<List<String>> ladders, List<String> path, String crt,
            String start, Map<String, Integer> distance,
            Map<String, List<String>> map) {
        path.add(crt);
        if (crt.equals(start)) {
            Collections.reverse(path);
            ladders.add(new ArrayList<String>(path));
            Collections.reverse(path);
        } else {
            for (String next : map.get(crt)) {
                if (distance.containsKey(next) && distance.get(crt) == distance.get(next) + 1) { 
                    dfs(ladders, path, next, start, distance, map);
                }
            } // end for next
        }
        path.remove(path.size() - 1);
    } // end dfs

    void bfs(Map<String, List<String>> map, Map<String, Integer> distance,
            String start, String end, Set<String> dict) {
        Queue<String> q = new LinkedList<String>();
        q.offer(start);
        distance.put(start, 0);
        for (String s : dict) {
            map.put(s, new ArrayList<String>());
        }
        
        while (!q.isEmpty()) {
            String crt = q.poll();

            List<String> nextList = expand(crt, dict);
            for (String next : nextList) {
                map.get(next).add(crt);
                if (!distance.containsKey(next)) {
                    distance.put(next, distance.get(crt) + 1);
                    q.offer(next);
                }
            } // end for next
        } // end while loop
    } // end bfs

    List<String> expand(String crt, Set<String> dict) {
        List<String> expansion = new ArrayList<String>();

        for (int i = 0; i < crt.length(); i++) {
            for (char ch = 'a'; ch <= 'z'; ch++) {
                if (ch != crt.charAt(i)) {
                    String expanded = crt.substring(0, i) + ch
                            + crt.substring(i + 1);
                    if (dict.contains(expanded)) {
                        expansion.add(expanded);
                    }
                }
            } // end for ch
        } // end for i

        return expansion;
    } // end expand
} // end Solution
```