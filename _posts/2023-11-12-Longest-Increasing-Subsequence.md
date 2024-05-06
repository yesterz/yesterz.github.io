---
title: Longest Increasing Subsequence
date: 2023-11-12 22:56:00 +0800
author: Algorithms-Notes
categories: [Leetcode]
tags: [Medium, Sword To Offer, Array, Binary Search, Dynamic Programming]
pin: false
math: false
mermaid: false
---

Leetcode <https://leetcode.cn/problems/longest-increasing-subsequence>

```java
class Solution {

    public int lengthOfLIS(int[] nums) {

        if (nums == null || nums.length == 0) {
            return 0;
        }

        int[] longest = new int[nums.length];
        longest[0] = 1;
        int maxLength = 1;
        
        for (int i = 1; i < nums.length; i++) {
            longest[i] = 1;
            for (int j = i - 1; j >= 0; j--) {
                if (nums[i] > nums[j]) {
                    longest[i] = Math.max(longest[i], longest[j] + 1);
                }
            }
            maxLength = Math.max(maxLength, longest[i]);
        }

        return maxLength;
    }
}
```

**Complexity**

* Time = O(n^2) 
* Space = O(n) 

---