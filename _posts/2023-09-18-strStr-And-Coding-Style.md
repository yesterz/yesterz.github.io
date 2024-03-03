---
title: Lecture-1 strStr & Coding Style
date: 2023-09-18 15:01:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Search]
pin: false
math: true
mermaid: false
---

## Outline

1. 从一道入门题说起
2. 面试中常见的误区
3. 如何准备面试算法
4. 排列组合模板
5. 
6. 

## 从一道入门题strStr说起

### Description

Returns the position of the first occurrence of string target in string source, or -1 if target is not part of source.

Lintcode [https://www.lintcode.com/problem/strstr/](https://www.lintcode.com/problem/strstr/)

Leetcode [https://leetcode.cn/problems/find-the-index-of-the-first-occurrence-in-a-string](https://leetcode.cn/problems/find-the-index-of-the-first-occurrence-in-a-string/)

### Solutions

```java
class Solution {
    /**
     * Returns a index to the first occurrence of target in source,
     * or -1  if target is not part of source.
     * @param source string to be scanned.
     * @param target string containing the sequence of characters to match.
     */
    public int strStr(String source, String target) {
        if (source == null || target == null) {
            return -1;
        }
        
        for (int i = 0; i < source.length() - target.length() + 1; i++) {
            int j = 0;
            for (j = 0; j < target.length(); j++) {
                if (source.charAt(i + j) != target.charAt(j)) {
                    break;
                }
            }
            // finished loop, target found
            if (j == target.length()) {
                return i;
            }
        }
        return -1;
    }
}
```

- **说明**



在面试中我是否需要实现KMP算法？

- 不需要，当这种问题出现在面试中时，面试官知识想测试一下你的基础应用能力。

问面试官？能不能用hashmap？ 面试官比较为难，说行还是不行呢？

这道题差不多的时间是给面试官看简历的，看完简历，这道题差不多也就做完了，正好来看看你的代码写的如何。

我们可以简单说可以用双重循环的方法来解决

```java
class Solution {
    /**
     * Returns the position of the first occurrence of string target in string source, 
     * or -1 if target is not part of source.
     * @parm source string to be scanned.
     * @parm target string containing the sequence of characters to match.
     */
    public int strStr(String source, String target) {
        if (source == null || target == null) {
            return -1;
        }

        int i, j;
        for (i = 0; i < source.length() - target.length() + 1; i++) {
            for (j = 0; j < target.length(); j++) {
                if (source.charAt(i + j) != target.charAt(j)) {
                    break;
                } // if
            } // for j
            if (j == target.length()) {
                return i;
            }
        } // for i
        
        return -1;
    }
}
```

## strStr常见错误2

coding style sucks

变量名命名，让别人能看得懂的意义！！

第8行，写成了一行，但是代码的可读性变差了。就算只有一行也要加括号。

二元运算符两边都需要加空格，++是单元运算符不用加空格。

谷歌的Java代码风格guide [https://google.github.io/styleguide/javaguide.html](https://google.github.io/styleguide/javaguide.html)

## strStr常见错误3

异常检测到的时候，计算机会挂掉。

这里讲的就是异常检测和边界处理。

## 面试官眼中的求职者

你可能是他未来的同事

1. 你的代码看起来舒服么
   1. TA需要多少时间Review你的代码
2. 你的Coding习惯好吗
   1. TA不会在未来疲于帮你DEBUG，你不会动不动就搞出SEV
3. 你的沟通能力好么
   1. TA和你交流费劲么

> "SEV" 在这里可能指的是 "severity"（严重性）的缩写。在软件开发中，"severity" 通常用来描述 bug 或问题的严重程度。不同的 bug 可能会有不同的严重性级别，例如：
> - SEV-1：表示一个非常严重的问题，可能会导致系统崩溃或无法正常工作。
> - SEV-2：表示一个严重的问题，可能会影响系统的核心功能。
> - SEV-3：表示一个较为一般的问题，不会影响系统的核心功能，但仍然需要解决。
> - SEV-4：表示一个较小的问题，通常是一些不紧急的 bug 或改进建议。
{: .prompt-tip }

coding习惯：异常检测和边界处理

SEV

## 面试考察的编程基本功

1. 程序风格 Coding Style（缩进，括号，变量名）
2. Coding习惯，Bug Free（异常检查，边界处理）
3. 沟通（让面试官时刻明白你的意图）
   1. 闷头就开始写 VS 每写一句话就BB半天
4. 测试（主动写出合理的Testcase，Cover掉所有情况）

## 排列组合模板

- 全子集问题 Subsets
   - Lintcode [https://www.lintcode.com/problem/subsets/](https://www.lintcode.com/problem/subsets/)
   - Solution [https://www.jiuzhang.com/solutions/subsets/](https://www.jiuzhang.com/solutions/subsets/)
- 带重复元素的全子集问题
   - Lintcode [https://www.lintcode.com/problem/subsets-ii/](https://www.lintcode.com/problem/subsets-ii/)
   - Solution [https://www.jiuzhang.com/solutions/subsets-ii/](https://www.jiuzhang.com/solutions/subsets-ii/)

## Subsets

### Description

Given a set of distinct integers, return all possible subsets.

> Elements in a subset must be in _non-descending_ order.
> The solution set must not contain duplicate subsets.
{: .prompt-tip }

### Examples

**Example 1:**

Input:

```
nums = [0]
```

Output:

```
[ 
  [], 
  [0] 
]
```

Explanation: The subsets of [0] are only [] and [0].

**Example 2:**

Input:

```
nums = [1,2,3]
```

Output:

```
[ 
  [3], 
  [1], 
  [2], 
  [1,2,3], 
  [1,3], 
  [2,3], 
  [1,2], 
  [] 
]
```

Explanation: The subsets of [1,2,3] are [], [1], [2], [3], [1,2], [1,3], [2,3], [1,2,3].

### Follow Up

Can you do it in both recursively and non-recursively?

那怎么去思考这个问题

### Solutions

使用组合类搜索的专用深度优先搜索算法。 一层一层的决策每个数要不要放到最后的集合里。

```java
public class Solution {
    /**
     * @param nums: A set of numbers
     * @return: A list of lists
     */
    public List<List<Integer>> subsets(int[] nums) {
        List<List<Integer>> results = new ArrayList<>();
        Arrays.sort(nums);
        dfs(nums, 0, new ArrayList<Integer>(), results);
        return results;
    }
    
    // 1. 递归的定义
    // 以 subset 开头的，配上 nums 以 index 开始的数所有组合放到 results 里
    private void dfs(int[] nums,
                     int index,
                     List<Integer> subset,
                     List<List<Integer>> results) {
        // 3. 递归的出口
        if (index == nums.length) {
            results.add(new ArrayList<Integer>(subset));
            return;
        }
        
        // 2. 递归的拆解
        // (如何进入下一层)
        
        // 选了 nums[index]
        subset.add(nums[index]);
        dfs(nums, index + 1, subset, results);
        
        // 不选 nums[index]
        subset.remove(subset.size() - 1);
        dfs(nums, index + 1, subset, results);
    }
}
```

使用比较通用的深度优先搜索方法

```java
// 递归：实现方式，一种实现DFS算法的一种方式
class Solution {
    /**
     * @param S: A set of numbers.
     * @return: A list of lists. All valid subsets.
     */
    public List<List<Integer>> subsets(int[] nums) {
        List<List<Integer>> results = new ArrayList<>();
        
        if (nums == null) {
            return results;
        }
        
        if (nums.length == 0) {
            results.add(new ArrayList<Integer>());
            return results;
        }
        
        Arrays.sort(nums);
        helper(new ArrayList<Integer>(), nums, 0, results);
        return results;
    }
    
    
    // 递归三要素
    // 1. 递归的定义：在 Nums 中找到所有以 subset 开头的的集合，并放到 results
    private void helper(ArrayList<Integer> subset,
                        int[] nums,
                        int startIndex,
                        List<List<Integer>> results) {
        // 2. 递归的拆解
        // deep copy
        // results.add(subset);
        results.add(new ArrayList<Integer>(subset));
        
        for (int i = startIndex; i < nums.length; i++) {
            // [1] -> [1,2]
            subset.add(nums[i]);
            // 寻找所有以 [1,2] 开头的集合，并扔到 results
            helper(subset, nums, i + 1, results);
            // [1,2] -> [1]  回溯
            subset.remove(subset.size() - 1);
        }
        
        // 3. 递归的出口
        // return;
    }
}
```


使用宽度优先搜索算法的做法（BFS） 一层一层的找到所有的子集：

```
[] 
[1] [2] [3]
[1, 2] [1, 3] [2, 3]
[1, 2, 3]
```

```java
public class Solution {
    /*
     * @param nums: A set of numbers
     * @return: A list of lists
     */
    public List<List<Integer>> subsets(int[] nums) {
        if (nums == null) {
            return new ArrayList<>();
        }
        
        List<List<Integer>> queue = new ArrayList<>();
        int index = 0;
        
        Arrays.sort(nums);
        queue.add(new ArrayList<Integer>());
        while (index < queue.size()) {
            List<Integer> subset = queue.get(index++);
            for (int i = 0; i < nums.length; i++) {
                if (subset.size() != 0 && subset.get(subset.size() - 1) >= nums[i]) {
                    continue;
                }
                List<Integer> newSubset = new ArrayList<>(subset);
                newSubset.add(nums[i]);
                queue.add(newSubset);
            }
        }
        
        return queue;
    }
}
```

第二种 BFS算法

```java
public class Solution {
    /*
     * @param nums: A set of numbers
     * @return: A list of lists
     */
    public List<List<Integer>> subsets(int[] nums) {
        if (nums == null) {
            return new ArrayList<>();
        }
        
        List<List<Integer>> queue = new ArrayList<>();
        queue.add(new LinkedList<Integer>());
        Arrays.sort(nums);
        
        for (int num : nums) {
            int size = queue.size();
            for (int i = 0; i < size; i++) {
                List<Integer> subset = new ArrayList<>(queue.get(i));
                subset.add(num);
                queue.add(subset);
            }
        }
        
        return queue;
    }
}
```

## Subsets ii: Unique Subsets

1. 与Subsets有关，先背下Subsets的模板
2. 既然要求Unique的，就想办法排除掉重复的，选择一个“代表”
3. 思考哪些情况会重复？
   1. 如{1, 2(1), 2(2), 2(3)}，规定{1, 2(1)}和{1, 2(2)}重复
4. 观察规律，得出：我们只关心取多少个2，不关心取哪几个。  
5. 规定必须从第一个2开始连续取（作为重复集合中的代表）  
   1. 如必须是{1, 2(1)}不能是{1, 2{2})  
6. 将这个逻辑转换为程序语言去判断  

### Solutions

```java
// return List<List<Integer>>
class Solution {
    /**
     * @param nums: A set of numbers.
     * @return: A list of lists. All valid subsets.
     */
    public List<List<Integer>> subsetsWithDup(int[] nums) {
        // write your code here
        List<List<Integer>> results = new ArrayList<List<Integer>>();
        if (nums == null) return results;
        
        if (nums.length == 0) {
            results.add(new ArrayList<Integer>());
            return results;
        }
        Arrays.sort(nums);

        List<Integer> subset = new ArrayList<Integer>();
        helper(nums, 0, subset, results);
        
        return results;
        
        
    }
    public void helper(int[] nums, int startIndex, List<Integer> subset, List<List<Integer>> results){
        results.add(new ArrayList<Integer>(subset));
        for(int i = startIndex; i < nums.length; i++){
            if (i != startIndex && nums[i] == nums[i-1]) {
                continue;
            }
            subset.add(nums[i]);
            helper(nums, i + 1, subset, results);
            subset.remove(subset.size() - 1);
        }
    }
}
```

```java
// return ArrayList<ArrayList<Integer>> 
class Solution {
    /**
     * @param nums: A set of numbers.
     * @return: A list of lists. All valid subsets.
     */
    public List<List<Integer>> subsetsWithDup(int[] nums) {
        // write your code here
        List<List<Integer>> results = new ArrayList<>();
        if (nums == null) return results;
        
        if (nums.length == 0) {
            results.add(new ArrayList<Integer>());
            return results;
        }
        Arrays.sort(nums);

        ArrayList<Integer> subset = new ArrayList<>();
        helper(nums, 0, subset, results);
        
         return results;
        
        
    }
    public void helper(int[] nums, int startIndex, List<Integer> subset, List<List<Integer>> results){
        results.add(new ArrayList<Integer>(subset));
        for(int i = startIndex; i < nums.length; i++){
            if (i != startIndex && nums[i] == nums[i - 1]) {
                continue;
            }
            subset.add(nums[i]);
            helper(nums, i + 1, subset, results);
            subset.remove(subset.size() - 1);
        }
    }
}
```

## 排列组合模板总结

- 使用范围
   - 几乎所有的搜索问题
- 根据具体题目要求进行改动
   - 什么时候输出
   - 哪些情况需要跳过

## 适用该模板的问题

- [ ] Homework

1. Permutations
2. Unique Permutations
3. Combination Sum
4. Letter Combination of a Phone Number
5. Palindrome Partitioning
6. Restore IP Address
7. ...