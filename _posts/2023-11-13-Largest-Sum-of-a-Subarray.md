---
title: Largest Sum of a Subarray
date: 2023-11-13 06:43:00 +0800
author: Algorithms-Notes
categories: [Algorithms, Array]
tags: [Sword To Offer, Array, Dynamic Programming, Divide & Conquer]
pin: false
math: false
mermaid: false
---

Leetcode <https://leetcode.cn/problems/maximum-subarray>

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
