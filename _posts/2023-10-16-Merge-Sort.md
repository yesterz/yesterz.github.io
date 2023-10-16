---
title: Merge Sort
date: 2023-10-16 12:10:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Sort]
pin: false
math: true
mermaid: false
---

Time = O(nlogn)

Space = O(n)

```
// main function that calls merge_sort
// left: the left index of the sub vector
// right: the right index of the sub vector

vector<int> mergeSort(vector<int>& a, int left, int right) {
    vector<int> solution;
    if (left == right) {
        solution.push_back(array[left]);
        return solution;
    }
    int mid = left + (right - left) / 2;
    vector<int> solu_left = mergeSort(a, left, mid);
    vector<int> solu_left = mergeSort(a, mid + 1, right);
    solution = combine(solu_left, solu_right);
    
    return solution;
}
```

有且只有一条指令得到执行，从一个状态转换到另一个唯一状态。

## Discussion

1) Could we use Merge Sort to sort a linked list? What is the time Complexity if so?

2) 什么是面试中一个类型的题？