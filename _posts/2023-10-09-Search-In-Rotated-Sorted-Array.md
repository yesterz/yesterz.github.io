---
title: Search in Rotated Sorted Array
date: 2023-10-09 22:03:00 +0800
author: Algorithms-Notes
categories: [Leetcode]
tags: [Leetcode, Binary Search]
pin: false
math: true
mermaid: false
---

## Search in Rotated Sorted Array

Leetcode <https://leetcode.cn/problems/search-in-rotated-sorted-array>

### 题目描述

整数数组 nums 按升序排列，数组中的值 互不相同 。

在传递给函数之前，nums 在预先未知的某个下标 k（0 <= k < nums.length）上进行了 旋转，使数组变为 [nums[k], nums[k+1], ..., nums[n-1], nums[0], nums[1], ..., nums[k-1]]（下标 从 0 开始 计数）。例如， [0,1,2,4,5,6,7] 在下标 3 处经旋转后可能变为 [4,5,6,7,0,1,2] 。

给你 旋转后 的数组 nums 和一个整数 target ，如果 nums 中存在这个目标值 target ，则返回它的下标，否则返回 -1 。

你必须设计一个时间复杂度为 O(log n) 的算法解决此问题。


示例 1：

输入：nums = [4, 5, 6, 7, 0, 1, 2], target = 0

输出：4

**示例 2：**

输入：nums = [4, 5, 6, 7, 0, 1, 2], target = 3

输出：-1

**示例 3：**

输入：nums = [1], target = 0

输出：-1
 
**提示：**

1. 1 <= nums.length <= 5000
2. -10^4 <= nums[i] <= 10^4
3. nums 中的每个值都 独一无二
4. 题目数据保证 nums 在预先未知的某个下标上进行了旋转
5. -10^4 <= target <= 10^4


### 解题报告

**！！！！很重要的一道题！！！！**

两种情况，一种 middle 在第一段上升区间，另一种是 middle 在第二段上升区间。

分情况讨论。确定答案在哪个区间，然后切一刀。

```java
class Solution {
    public int search(int[] nums, int target) {
        if (nums == null || nums.length == 0) {
            return -1;
        }

        int start = 0;
        int end = nums.length - 1;
        int mid;
        
        while (start + 1 < end) {
            mid = start + (end - start) / 2;
            if (nums[mid] == target) {
                return mid;
            }
            if (nums[start] < nums[mid]) {
                if (nums[start] <= target && target <= nums[mid]) {
                    end = mid;
                } else {
                    start = mid;
                }
            } else {
                if (nums[mid] <= target && target <= nums[end]) {
                    start = mid;
                } else {
                    end = mid;
                }
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