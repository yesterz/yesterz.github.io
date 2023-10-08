---
title: Quick Sort
date: 2023-10-08 12:53:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Array, Sorting]
pin: false
math: true
mermaid: false
img_path: /assets/images/
---



![快速排序示意图](QuickSort.png)

```java
public int[] quickSort(int[] array) {
    helper(array, 0, array.length - 1);
    return array;
} // end quickSort

// Divide
public void helper(int[] array, int left, int right) {
    if (left >= right) {
        return;
    }
    int pivot = partition(array, left, right);
    helper(array, left, pivot - 1);
    helper(array, pivot + 1, right);
} // end helper

public int partition(int[] array, int left, int right) {
    int pivot = array[right];
    int start = left, end = right - 1;
    while (start <= end) {
        if (array[start] <= pivot) {
            start++;
        } else if (array[end] > pivot) {
            end--;
        } else {
            swap(array, start++, end--);
        }
    } // end while loop
    swap(array, start, right);
    return start;
} // end partition

private int partition2(int[] nums, int left, int right) {
    int pivot = nums[right], wall = left;
    for (int i = left; i < right; i++) {
        if (nums[i] < pivot) {
            swap(nums, i, wall);
            wall++;
        }
    } // end for loop
    return wall;
} // end partition2

private void swap(int[] nums, int i, int j) {
    int tmp = nums[i];
    nums[i] = nums[j];
    nums[j] = tmp;
} // end swap

private void shuffle() {
    Random random = new Random();
    for (int i = 0; i < nums.length; i++) {
        int j = random.nextInt(i + 1); // [i, j)
        swap(nums, i, j);
    } // end for loop
} // end shuffle
```