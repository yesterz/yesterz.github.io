---
title: Top K Frequent Elements
date: 2024-02-29 07:03:00 +0800
author: Algorithms-Notes
categories: [Algorithms, LeetCode Hot 100]
tags: [medium, top-100-liked, Array, Hash Table, Divide and Conquer, Bucket Sort, Counting, Quickselect, Sorting, Heap]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/top-k-frequent-elements/>

```java
class Solution {
    public int[] topKFrequent(int[] nums, int k) {
        Map<Integer, Integer> freq = new HashMap<>();
        for (int num : nums) {
            freq.put(num, freq.getOrDefault(num, 0) + 1);
        }

        Queue<Map.Entry<Integer, Integer>> minHeap = new PriorityQueue<>(
            (e1, e2) -> e1.getValue() - e2.getValue()
        );

        for (Map.Entry<Integer, Integer> entry : freq.entrySet()) {
            if (minHeap.size() < k) {
                minHeap.offer(entry);
            } else {
                if (entry.getValue() > minHeap.peek().getValue()) {
                    minHeap.poll();
                    minHeap.offer(entry);
                }
            }
        } // end for loop

        int[] res = new int[k];
        for (int i = 0; i < k; i++) {
            res[i] = minHeap.poll().getKey();
        }

        return res;
    }
}
```

**Complexity**

* Time = O(nlogk) 
* Space = O(n) 