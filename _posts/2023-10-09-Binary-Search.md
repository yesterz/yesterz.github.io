---
title: First Postion of Target
date: 2023-10-09 20:00:00 +0800
author: Algorithms-Notes
categories: [Leetcode]
tags: [Leetcode, Binary Search]
pin: false
math: true
mermaid: false
---

## First Postion of Target

Leetcode <https://leetcode.cn/problems/binary-search/>

### 题目描述

给定一个 n 个元素有序的（升序）整型数组 nums 和一个目标值 target  ，写一个函数搜索 nums 中的 target，如果目标值存在返回下标，否则返回 -1。


**示例 1:**

输入: nums = [-1,0,3,5,9,12], target = 9

输出: 4

解释: 9 出现在 nums 中并且下标为 4

**示例 2:**

输入: nums = [-1,0,3,5,9,12], target = 2

输出: -1

解释: 2 不存在 nums 中因此返回 -1
 
**提示：**

1. 你可以假设 nums 中的所有元素是不重复的。
2. n 将在 [1, 10000]之间。
3. nums 的每个元素都将在 [-9999, 9999]之间。


### 解题报告

```java
class Solution {
    public int search(int[] nums, int target) {
        if (nums == null || nums.length == 0) {
            return -1;
        }

        int start = 0;
        int end = nums.length - 1;
        while (start + 1 < end) {
            int middle = start + (end - start) / 2;
            if (nums[middle] == target) {
                end = middle;
            } else if (nums[middle] < target) {
                start = middle;
            } else {
                end = middle;
            }
        } // end while loop

        if (nums[start] == target) {
            return start;
        }
        if (nums[end] == target) {
            return end;
        }

        return -1;
    } // end search
} // end Solution
```