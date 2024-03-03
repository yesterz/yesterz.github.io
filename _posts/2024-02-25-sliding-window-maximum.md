---
title: Sliding Window Maximum
date: 2024-02-25 07:54:00 +0800
author: Algorithms-Notes
categories: [Algorithms, LeetCode Hot 100]
tags: [Hard, top-100-liked, Queue, Array, Sliding Window, Monotonic Queue, Heap]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/sliding-window-maximum/>

```java
class Solution {
    public int[] maxSlidingWindow(int[] nums, int k) {
        if (nums == null || nums.length < 1 || k < 0 || k > nums.length) {
            return nums;
        }

        int[] res = new int[nums.length - k + 1];
        int resIndex = 0;

        Deque<Integer> deque = new ArrayDeque<>(k);
        int start = 0;

        for (int end = 0; end < nums.length; end++) {
            while (!deque.isEmpty() && nums[end] > nums[deque.peekLast()]) {
                deque.pollLast();
            }
            deque.offerLast(end);
            if (end - start + 1 == k) {
                res[resIndex++] = nums[deque.peekFirst()];
                if (deque.peekFirst() == start++) {
                    deque.pollFirst();
                }
            }
        }

        return res;
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(n) 