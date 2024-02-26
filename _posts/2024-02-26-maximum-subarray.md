---
title: Maximum Subarray
date: 2024-02-26 06:51:00 +0800
author: Algorithms-Notes
categories: [Algorithms, LeetCode Hot 100]
tags: [Medium, top-100-liked, Array, Divide and Conquer, Dynamic Programming]
pin: false
math: true
mermaid: false
---

LeetCode <https://leetcode.cn/problems/maximum-subarray/>

```java
class Solution {
    public int maxSubArray(int[] nums) {
        if (nums == null || nums.length < 1) {
            return 0;
        }

        int lastMax = 0;
        int globalMax = nums[0];
        for (int i = 0; i < nums.length; i++) {
            lastMax = Math.max(nums[i], nums[i] + lastMax);
            globalMax = Math.max(globalMax, lastMax);
        }
        
        return globalMax;
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(1) 
