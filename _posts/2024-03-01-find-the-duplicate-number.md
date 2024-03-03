---
title: Find the Duplicate Number
date: 2024-03-01 07:03:00 +0800
author: Algorithms-Notes
categories: [Algorithms, LeetCode Hot 100]
tags: [medium, top-100-liked, 剑指 Offer, Bit Manipulation, Array, Two pointers, Binary Search]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/find-the-duplicate-number/>

## Binary search

```java
class Solution {
    public int findDuplicate(int[] nums) {
        int n = nums.length;
        int l = 1, r = n - 1, ans = -1;
        while (l <= r) {
            int mid = (l + r) >> 1;
            int cnt = 0;
            for (int i = 0; i < n; ++i) {
                if (nums[i] <= mid) {
                    cnt++;
                }
            }
            if (cnt <= mid) {
                l = mid + 1;
            } else {
                r = mid - 1;
                ans = mid;
            }
        }
        return ans;
    }
}
```

**Complexity**

* Time = O(logn) 
* Space = O(1) 

## Two pointers

```java
class Solution {
    public int findDuplicate(int[] nums) {
        int slow = 0;
        int fast = 0;
        while (true) {
            slow = nums[slow];
            fast = nums[nums[fast]];
            if (slow == fast) {
                break;
            }
        }
        slow = 0;
        while (true) {
            slow = nums[slow];
            fast = nums[fast];
            if (slow == fast) {
                break;
            }
        }
        return slow;
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(1) 