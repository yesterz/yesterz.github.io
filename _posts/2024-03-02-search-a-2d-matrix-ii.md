---
title: Search a 2D Matrix II
date: 2024-03-02 07:03:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Medium, top-100-liked, 剑指 Offer, Array, Binary Search, Divide and Conquer, Matrix]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/search-a-2d-matrix-ii/>

## from bottom-left to up-right corner

```java
class Solution {

    public boolean searchMatrix(int[][] matrix, int target) {

        if (matrix == null || matrix.length == 0 || matrix[0].length == 0) {
            return false;
        }

        int row = matrix.length - 1;
        int col = 0;

        while (row >= 0 && col < matrix[0].length) {
            if (matrix[row][col] == target) {
                return true;
            } else if (matrix[row][col] > target) {
                row--;
            } else {
                col++;
            }
        } // end while

        return false;
    }
}
```

## from up-right to bottom-left corner

```java
class Solution {

    public boolean searchMatrix(int[][] matrix, int target) {

        if (matrix == null || matrix.length == 0 || matrix[0].length == 0) {
            return false;
        }

        int row = 0;
        int col = matrix[0].length - 1;

        while (row <= matrix.length - 1 && col >= 0) {
            if (matrix[row][col] < target) {
                row++;
            } else if (matrix[row][col] > target) {
                col--;
            } else {
                return true;
            }
        }
        
        return false;
    }
}
```


**Complexity**

* Time = O(m+n) 
* Space = O(1) 