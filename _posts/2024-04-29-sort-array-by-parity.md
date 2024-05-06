---
title: Sort Array By Parity
date: 2024-04-29 13:38:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Easy, Sword To Offer, Array, Two Pointers, Sorting]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/sort-array-by-parity/>

```java
class Solution {
    public int[] sortArrayByParity(int[] nums) {
        int n = nums.length;
        int[] res = new int[n];
        int left = 0, right = n - 1;
        for (int num : nums) {
            if (num % 2 == 0) {
                res[left++] = num;
            } else {
                res[right--] = num;
            }
        }
        return res;
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(1) 

---