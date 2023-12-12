---
title: 排序算法
date: 2023-12-11 08:36:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Algorithms, Sorting]
pin: false
math: false
mermaid: false
---

## Bubble sort

```java
private void bubbleSort(int[] arr) {
    int len = arr.length;
    for (int i = 0; i < len - 1; i++>) {
        for (int j = 0; j < len - 1 - i; j++>) {
            if (arr[j] > arr[j + 1]) {
                swap(arr, j, j + 1);
            }
        }
    }
}

private void swap(int[] arr, int i, int j) {
    int tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
}
```