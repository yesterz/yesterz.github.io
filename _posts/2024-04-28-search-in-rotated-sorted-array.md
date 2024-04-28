---
title: Search in Rotated Sorted Array
date: 2024-04-28 21:23:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Medium, Sword To Offer, Array, Binary Search]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/search-in-rotated-sorted-array/>

```java
class Solution {
    
    public int search(int[] nums, int target) {

        if (nums == null || nums.length == 0) {
            return -1;
        }

        int left = 0;
        int right = nums.length - 1;

        while (left < right) {
            if (nums[left] < nums[right]) {
                break;
            }
            int mid = left + (right - left) / 2;
            if (nums[mid] > nums[right]) {
                left = mid + 1;
            } else {
                right = mid;
            }
        }

        int offset = left;
        left = 0;
        right = nums.length - 1;
        while (left <= right) {
            int mid = left + (right - left) / 2;
            int realMid = (mid + offset) % nums.length;
            if (nums[realMid] == target) {
                return realMid;
            } else if (nums[realMid] < target) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }

        return -1;

    }
}
```

**Complexity**

* Time = O(log(n)) 
* Space = O(1) 

---