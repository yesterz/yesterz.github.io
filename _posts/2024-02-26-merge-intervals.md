---
title: Merge Intervals
date: 2024-02-26 06:53:00 +0800
author: Algorithms-Notes
categories: [Algorithms, LeetCode Hot 100]
tags: [Medium, top-100-liked, Array, Sorting]
pin: false
math: true
mermaid: false
---

LeetCode <https://leetcode.cn/problems/merge-intervals/>

```java
class Solution {
    public int[][] merge(int[][] intervals) {
        if (intervals == null || intervals.length < 1) {
            return intervals;
        }
        // intervals[i][0] < intervals[i+1][0] ???
        Arrays.sort(intervals, (a, b) -> Integer.compare(a[0], b[0]));

        List<int[]> res = new ArrayList<>();
        int[] currentInterval = intervals[0];
        // intervals[i] = [start(i), end(i)]
        // Merge rule: start(i) < start(i+1) < end(i) < end(i+1), for each intervals[i]
        for (int i = 1; i < intervals.length; i++) {
            if (currentInterval[1] >= intervals[i][0]) {
                currentInterval[1] = Math.max(currentInterval[1], intervals[i][1]);
            } else {
                res.add(currentInterval);
                currentInterval = intervals[i];
            }
        }
        res.add(currentInterval);
        return res.toArray(new int[res.size()][]);
    }
}
```

**Complexity**

* Time = O(nlogn) 
* Space = O(n) 
