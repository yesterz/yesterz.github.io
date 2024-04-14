---
title: Majority Element
date: 2024-04-14 21:28:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Easy, top-100-liked, Array, Hash Table, Divide and Conquer, Counting, Sorting]
pin: false
math: false
mermaid: false
---

Leetcode <https://leetcode.cn/problems/majority-element/>

```java
class Solution {
    public int majorityElement(int[] nums) {

        int candidate = nums[0];
        int counter = 0;

        for (int num : nums) {
            if (counter == 0) {
                candidate = num;
                counter = 1;
                continue;
            } 
            if (candidate == num) {
                counter++;
            } else {
                counter--;
            }
        }

        return candidate;
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(1) 

---