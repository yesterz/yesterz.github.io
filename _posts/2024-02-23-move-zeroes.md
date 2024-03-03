---
title: Move Zeroes
date: 2024-02-23 07:02:00 +0800
author: Algorithms-Notes
categories: [Algorithms, LeetCode Hot 100]
tags: [Medium, top-100-liked, Array, Two Pointers]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/move-zeroes/>

```java
class Solution {
    public void moveZeroes(int[] nums) {
        if (nums == null || nums.length <= 1) {
            return;
        }
        int slow = 0;
        int fast = 0;
        while (fast < nums.length) {
            if (nums[fast] != 0) {
                nums[slow++] = nums[fast++];
            } else {
                fast++;
            }
        }
        while (slow < nums.length) {
            nums[slow++] = 0;
        }
    }
}
```

```java
class Solution {
    // slow: slow 的左侧都是非0，不包括 slow 位置的。
    // fast: fast 的右侧是还没确定的区域。
    public void moveZeroes(int[] nums) {
        if (nums == null || nums.length == 0) {
            return;
        }
        int slow = 0;
        int fast = 0;
        for (; fast < nums.length; fast++) {
            if (nums[fast] != 0) {
                exchange(nums, slow, fast);
                slow++;
            } 
        }
    }

    private void exchange(int[] nums, int i, int j) {
        if (i >= j) {
            return;
        }
        int temp = nums[i];
        nums[i] = nums[j];
        nums[j] = temp;
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(1) 