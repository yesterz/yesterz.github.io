---
title: Subsets II
date: 2024-03-21 20:00:00 +0800
author: Algorithms-Notes
categories: [Leetcode]
tags: [Medium, Bit Manipulation, Array, Back tracking]
pin: false
math: true
mermaid: false
---

Leetcode <https://leetcode.cn/problems/subsets-ii/>

## 题目描述

给你一个整数数组 nums ，其中可能包含重复元素，请你返回该数组所有可能的子集（幂集）。

解集 不能 包含重复的子集。返回的解集中，子集可以按 任意顺序 排列。

**示例 1：**

输入：nums = [1, 2, 2]

输出：[ [], [1], [1, 2], [1, 2, 2], [2], [2, 2] ]

**示例 2：**

输入：nums = [0]

输出：[ [], [0] ]
 

**提示：**

* 1 <= nums.length <= 10
* -10 <= nums[i] <= 10

## 解题报告

```java
class Solution {
    public List<List<Integer>> subsetsWithDup(int[] nums) {
        List<List<Integer>> results = new ArrayList<>();
        if (nums == null) {
            return results;
        }

        if (nums.length == 0) {
            results.add(new ArrayList<Integer>());
            return results;
        }

        Arrays.sort(nums);

        List<Integer> subset = new ArrayList<>();
        helper(nums, 0, subset, results);

        return results;
    } // end subsetWithDup

    public void helper(int[] nums, int startIndex, List<Integer> subset, List<List<Integer>> results) {
        results.add(new ArrayList<Integer>(subset));
        for (int i = startIndex; i < nums.length; i++) {
            if (i != startIndex && nums[i] == nums[i-1]) {
                continue;
            }
            subset.add(nums[i]);
            helper(nums, i + 1, subset, results);
            subset.remove(subset.size() - 1);
        } // end for i
    } // end helper
} // end Solution
```