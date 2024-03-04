---
title: Find First and Last Position of Element in Sorted Array
date: 2024-03-02 07:03:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Medium, top-100-liked, Array, Binary Search]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/find-first-and-last-position-of-element-in-sorted-array/>

```java
class Solution {
    public int[] searchRange(int[] nums, int target) {
        int[] res = new int[] { -1, -1 };
        if (nums == null || nums.length == 0) {
            return res;
        }
        
        // Find the first occurrence
        int left = 0;
        int right = nums.length - 1;
        while (left <= right) {
            int mid = left + (right - left) / 2;
            if (nums[mid] < target) {
                left = mid + 1;
            } else if (nums[mid] > target) {
                right = mid - 1;
            } else {
                res[0] = mid;
                right = mid - 1; // Continue searching on the left side
            }
        }
        
        // Find the last occurrence
        left = 0;
        right = nums.length - 1;
        while (left <= right) {
            int mid = left + (right - left) / 2;
            if (nums[mid] < target) {
                left = mid + 1;
            } else if (nums[mid] > target) {
                right = mid - 1;
            } else {
                res[1] = mid;
                left = mid + 1; // Continue searching on the right side
            }
        }
        
        return res;
    }
}
```

**Complexity**

* Time = O(logn) 
* Space = O(1) 