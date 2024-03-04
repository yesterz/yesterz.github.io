---
title: Kth Largest Element in an Array
date: 2024-02-29 07:00:00 +0800
author: Algorithms-Notes
categories: [Algorithms, LeetCode Hot 100]
tags: [Medium, top-100-liked, Array, Divide and Conquer, Quickselect, Sorting, Heap]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/kth-largest-element-in-an-array/>

```java
class Solution {
    public int findKthLargest(int[] nums, int k) {
        Queue<Integer> maxHeap = new PriorityQueue<>(
            (e1, e2) -> e2 - e1
        );

        for (int num : nums) {
            maxHeap.add(num);
        }
        
        for (int i = 0; i < k-1; i++) {
            maxHeap.poll();
        }

        return maxHeap.poll();
    }
}
```

**Complexity**

* Time = O(nlogn) 
* Space = O(n) 

