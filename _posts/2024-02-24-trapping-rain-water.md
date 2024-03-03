---
title: Trapping Rain Water
date: 2024-02-24 07:30:00 +0800
author: Algorithms-Notes
categories: [Algorithms, LeetCode Hot 100]
tags: [Hard, top-100-liked, Stack, Array, Two Pointers, Dynamic Programming, Monotonic Stack]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/trapping-rain-water/>

## DP Method

```java
class Solution {
    public int trap(int[] height) {
        int len = height.length;
        int[] leftMax = new int[len];
        leftMax[0] = height[0];
        for (int i = 1; i < len; i++) {
            leftMax[i] = Math.max(leftMax[i-1], height[i]);
        }

        int[] rightMax = new int[len];
        rightMax[len - 1] = height[len - 1];
        for (int i = len - 2; i >= 0; i--) {
            rightMax[i] = Math.max(rightMax[i + 1], height[i]);
        }

        int ans = 0;
        for (int i = 0; i < len; i++) {
            ans += Math.min(leftMax[i], rightMax[i]) - height[i];
        }
        return ans;
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(1) 

## Greedy Method

- [ ] Greedy Solution