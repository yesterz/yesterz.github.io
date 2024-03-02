---
title: Search a 2D Matrix
date: 2024-03-02 07:03:00 +0800
author: Algorithms-Notes
categories: [Algorithms, LeetCode Hot 100]
tags: [medium, top-100-liked, Array, Binary Search, Matrix]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/search-a-2d-matrix/>

```java
class Solution {
    public boolean searchMatrix(int[][] matrix, int target) {
        if (matrix == null || matrix.length == 0 || matrix[0].length == 0) {
            return false;
        }
        int row = matrix.length;
        int col = matrix[0].length;
        int i = 0;
        int j = row * col -1;
        while (i <= j) {
            int mid = i + (j - i) / 2;
            int r = mid / col;
            int c = mid % col;
            if (matrix[r][c] == target) {
                return true;
            } else if (matrix[r][c] > target) {
                j = mid - 1;
            } else {
                i = mid + 1;
            }
        } // end while
        return false;
    }
}
```

**Complexity**

* Time = O(log(m*n)) (m, n 是行长度列长度)
* Space = O(1) 