---
title: Rotate Array
date: 2024-02-26 06:55:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Medium, top-100-liked, Array, Math, Two Pointers]
pin: false
math: true
mermaid: false
---

LeetCode <https://leetcode.cn/problems/rotate-array/>


```java
class Solution {
    public void rotate(int[] nums, int k) {
        // index  0  1  2  3  4  5  6 
        // nums   1  2  3  4  5  6  7 
        // step1  7  6  5  4  3  2  1
        // step2  5  6  7  4  3  2  1
        // step3  5  6  7  1  2  3  4
        // result 5  6  7  1  2  3  4

        k %= nums.length;
        reverse(nums, 0, nums.length - 1);
        reverse(nums, 0, k - 1);
        reverse(nums, k, nums.length - 1);
    }

    private void reverse(int[] nums, int left, int right) {
        if (left >= right) {
            return;
        }
        exchange(nums, left, right);
        reverse(nums, left + 1, right - 1);
    }

    // exchange arr[i] and a[j]
    private void exchange(int[] arr, int i, int j) {
        int swap = arr[i];
        arr[i] = arr[j];
        arr[j] = swap;
    }
}
```

**iterative reversal**

```java
class Solution {
    public void rotate(int[] nums, int k) {
        k %= nums.length;
        reverse(nums, 0, nums.length - 1);
        reverse(nums, 0, k - 1);
        reverse(nums, k, nums.length - 1);
    }

    private void reverse(int[] nums, int left, int right) {
        while (left < right) {
            exchange(nums, left++, right--);
        }
    }

    // exchange arr[i] and a[j]
    private void exchange(int[] arr, int i, int j) {
        int swap = arr[i];
        arr[i] = arr[j];
        arr[j] = swap;
    }
}
```

```java
    private void reverse(int[] nums, int left, int right) {
        while (left < right) {
            exchange(nums, left, right);
            left++;
            right--;
        }
    }
```

**Complexity**

* Time = O(n) 
* Space = O(1) 