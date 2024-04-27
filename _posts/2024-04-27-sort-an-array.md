---
title: Sort an Array
date: 2024-04-27 22:36:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Medium, Sword To Offer, Array, Divide and Conquer, Bucket Sort, Counting Sort, Radix Sort, Sorting, Heap (Priority Queue), Merge Sort]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/sort-an-array/>

## Quicksort

```java
class Solution {

    public int[] sortArray(int[] nums) {

        if (nums == null || nums.length <= 1) {
            return nums;
        }

        // quick sorting
        quickSortHelper(nums, 0, nums.length - 1);

        return nums;
    }
    
    public void quickSortHelper(int[] a, int lo, int hi) {

        if (hi <= lo)
            return;
        int pivot = partition(a, lo, hi);
        quickSortHelper(a, lo, pivot - 1);
        quickSortHelper(a, pivot + 1, hi);
    }

    public static int partition(int[] a, int lo, int hi) {
        int i = lo;
        int j = hi + 1;
        int pivot = a[lo];
        while (true) {
            while (a[++i] < pivot)
                if (i == hi)
                    break;
            while (pivot < a[--j])
                if (j == lo)
                    break;
            if (i >= j)
                break;
            exch(a, i, j);
        }

        exch(a, lo, j);

        return j;
    }

    public static void exch(int[] a, int i, int j) {
        int swap = a[i];
        a[i] = a[j];
        a[j] = swap;
    }

}
```

**Complexity**

* Time = O(nlog(n)) 
* Space = O(log(n)) 

---

## Mergesort



## Heapsort

