---
title: Subarray Sum Equals K
date: 2024-02-25 07:52:00 +0800
author: Algorithms-Notes
categories: [Algorithms, LeetCode Hot 100]
tags: [Medium, top-100-liked, Array, Hash Table, Prefix Sum]
pin: false
math: true
mermaid: false
---

LeetCode <https://leetcode.cn/problems/subarray-sum-equals-k/>

```java
class Solution {
    public int subarraySum(int[] nums, int k) {
        if (nums == null || nums.length < 1) {
            return 0;
        }
        int len = nums.length;
        // Array to store cumulative sum of elements in nums
        // from the beginning up to index i, inclusive.
        int[] prefixSum = new int[len + 1];
        prefixSum[0] = 0;
        for (int i = 0; i < len; i++) {
            prefixSum[i + 1] = prefixSum[i] + nums[i];
        }
        
        int count = 0;
        for (int left = 0; left < len; left++) {
            for (int right = left; right < len; right++) {
                if (prefixSum[right + 1] - prefixSum[left] == k) {
                    count++;
                }
            }
        }
        
        return count;
    }
}
```

**Complexity**

* Time = O($n^2$) 
* Space = O(n) 

## Follow up: Time = O(n)

- [ ] 前缀和 + 哈希表优化