---
title: Search in Rotated Sorted Array
date: 2023-10-09 22:03:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Medium, top-100-liked, Array, Binary Search]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/search-in-rotated-sorted-array/>

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



## Find Minimum in Rotated Sorted Array

Leetcode <https://leetcode.cn/problems/find-minimum-in-rotated-sorted-array/>

### 题目描述

已知一个长度为 n 的数组，预先按照升序排列，经由 1 到 n 次 旋转 后，得到输入数组。例如，原数组 nums = [0, 1, 2, 4, 5, 6, 7] 在变化后可能得到：

若旋转 4 次，则可以得到 [4, 5, 6, 7, 0, 1, 2]

若旋转 7 次，则可以得到 [0, 1, 2, 4, 5, 6, 7]

注意，数组 [a[0], a[1], a[2], ..., a[n-1]] 旋转一次 的结果为数组 [a[n-1], a[0], a[1], a[2], ..., a[n-2]] 。

给你一个元素值 互不相同 的数组 nums ，它原来是一个升序排列的数组，并按上述情形进行了多次旋转。请你找出并返回数组中的 最小元素 。

你必须设计一个时间复杂度为 O(log n) 的算法解决此问题。

 

**示例 1：**

输入：nums = [3, 4, 5, 1, 2]

输出：1

解释：原数组为 [1, 2, 3, 4, 5] ，旋转 3 次得到输入数组。

**示例 2：**

输入：nums = [4, 5, 6, 7, 0, 1, 2]
输出：0

解释：原数组为 [0, 1, 2, 4, 5, 6, 7] ，旋转 4 次得到输入数组。

**示例 3：**

输入：nums = [11, 13, 15, 17]

输出：11

解释：原数组为 [11, 13, 15, 17] ，旋转 4 次得到输入数组。
 

**提示：**

1. n == nums.length
2. 1 <= n <= 5000
3. -5000 <= nums[i] <= 5000
4. nums 中的所有整数 互不相同
5. nums 原来是一个升序排序的数组，并进行了 1 至 n 次旋转

### 解题报告

继续二分法搜索，最后的时候找出 start 和 end 哪个最小，返回最小的。

与朴素二分相比，拿 middle 位置的数和 end 位置比较，如果 middle 位置的数大说明最小值藏在右半部分，挪 start 指针到 middle，反之 end 位置的数大说明最小值藏在左半部分，挪 end 到 middle 位置，循环跑到最后的时候 start 和 end 相邻了，取较小者就是最小值。

```java
class Solution {
    public int findMin(int[] nums) {
        if (nums == null || nums.length == 0) {
            return -1;
        }
        
        int start = 0;
        int end = nums.length - 1;
        while (start + 1 < end) {
            int mid = start + (end - start) / 2;
            if (nums[mid] > nums[end]) {
                start = mid;
            } else {
                end = mid;
            }
        } // end while loop

        return Math.min(nums[start], nums[end]);
    } // end findMin
} // end Solution
```