---
title: Container With Most Water
date: 2024-02-23 07:03:00 +0800
author: Algorithms-Notes
categories: [Algorithms, LeetCode Hot 100]
tags: [Medium, top-100-liked, Greedy, Array, Two Pointers]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/container-with-most-water/>


```java
class Solution {
    public int maxArea(int[] height) {
        int i = 0;
        int j = height.length - 1;
        int globalMax = 0;
        while (i < j) {
            globalMax = height[i] < height[j] ?
                Math.max(globalMax, (j - i) * height[i++]) :
                Math.max(globalMax, (j - i) * height[j--]);
        }
        return globalMax;
    }
}
```


**Complexity**

* Time = O(n) 
* Space = O(1) 