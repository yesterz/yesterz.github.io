---
title: Edit Distance
date: 2023-11-13 06:43:00 +0800
author: Algorithms-Notes
categories: [Algorithms, Dynamic Programming]
tags: [String, Dynamic Programming]
pin: false
math: false
mermaid: false
---

Leetcode <https://leetcode.cn/problems/edit-distance/>

```java
class Solution {
    public int minDistance(String word1, String word2) {

        if (word1 == null || word2 == null) {
            return -1;
        }

        int word1len = word1.length();
        int word2len = word2.length();

        int[][] distance = new int[word1len + 1][word2len + 1];

        for (int i = 0; i <= word1len; i++) {
            for (int j = 0; j <= word2len; j++) {
                if (i == 0) {
                    distance[i][j] = j;
                } else if (j == 0) {
                    distance[i][j] = i;
                } else if (word1.charAt(i - 1) == word2.charAt(j - 1)) {
                    distance[i][j] = distance[i - 1][j - 1];
                } else {
                    distance[i][j] = Math.min(distance[i - 1][j - 1] + 1, distance[i - 1][j] + 1);
                    distance[i][j] = Math.min(distance[i][j], distance[i][j - 1] + 1);
                }
            }
        }

        return distance[word1len][word2len];
    }
}
```

**Complexity**

* Time = O(m*n) 
* Space = O(m*n) 

---