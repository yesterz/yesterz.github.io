---
title: Spiral Matrix
date: 2024-05-01 13:38:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Medium, Sword To Offer, Array, Matrix, Simulation]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/spiral-matrix/>

```java
class Solution {

    public List<Integer> spiralOrder(int[][] matrix) {
        
        List<Integer> result = new ArrayList<>();

        if (matrix == null || matrix.length == 0 || matrix[0].length == 0) {
            return result;
        }

        spiralTraverse(matrix, result, 0, matrix.length, matrix[0].length);

        return result;
    }

    private void spiralTraverse(int[][] matrix, List<Integer> result, int offset, int rowLength, int colLength) {

        if (rowLength == 0 || colLength == 0) {
            return;
        }

        if (rowLength == 1) {
            for (int i = 0; i < colLength; i++) {
                result.add(matrix[offset][offset + i]);
            }
            return;
        }

        if (colLength == 1) {
            for (int i = 0; i < rowLength; i++) {
                result.add(matrix[offset + i][offset]);
            }
            return;
        }

        // top-left to top-right
        for (int i = 0; i < colLength; i++) {
            result.add(matrix[offset][offset + i]);
        }

        // top-right to bottom-right
        for (int i = 1; i < rowLength - 1; i++) {
            result.add(matrix[offset + i][offset + colLength - 1]);
        }

        // bottom-right to bottom-left
        for (int i = colLength - 1; i >= 0; i--) {
            result.add(matrix[offset + rowLength - 1][offset + i]);
        }

        // bottom-left to top-left
        for (int i = rowLength - 2; i >= 1; i--) {
            result.add(matrix[offset + i][offset]);
        }

        // the next layer
        spiralTraverse(matrix, result, offset + 1, rowLength - 2, colLength - 2);
    }
}
```

**Complexity**

* Time = O(m*n) 
* Space = O(1) 

---