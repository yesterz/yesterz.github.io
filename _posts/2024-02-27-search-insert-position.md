---
title: Search Insert Position
date: 2024-02-27 07:19:00 +0800
author: Algorithms-Notes
categories: [Algorithms, LeetCode Hot 100]
tags: [Easy, top-100-liked, Array, Binary Search]
pin: false
math: true
mermaid: false
---

LeetCode <https://leetcode.cn/problems/search-insert-position/>

```java
class Solution {
    public int searchInsert(int[] nums, int target) {
        // if (nums.length <= 1) {
        //     return 1;
        // }
        int left = 0;
        int right = nums.length - 1;
        int mid = left + (right - left) / 2;
        while (left <= right) {
            if (nums[mid] == target) {
                return mid;
            }
            if (nums[mid] < target) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
            mid = left + (right - left) / 2;
        }
        return mid;
    }
}
```

考虑 nums = [1], target = 0 的情况！

```java
class Solution {
    public int searchInsert(int[] nums, int target) {
        int n = nums.length;
        int left = 0, right = n - 1, ans = n;
        while (left <= right) {
            int mid = ((right - left) >> 1) + left;
            if (target <= nums[mid]) {
                ans = mid;
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }
        return ans;
    }
}
```

**Complexity**

* Time = O(logn) 
* Space = O(1) 