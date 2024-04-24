---
title: 
date: 2024-04-15 08:14:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Easy, top-100-liked, Bit Manipulation, Array]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/edit-distance/>

❌ 超出时间限制
```java
class Solution {
    public int minDistance(String word1, String word2) {
        // Base case
        if (word1.isEmpty())
            return word2.length();
        if (word2.isEmpty())
            return word1.length();

        // (a) Check what the distance is if the characters[0] are identical and we do
        // nothing first
        int nothing = Integer.MAX_VALUE;
        if (word1.charAt(0) == word2.charAt(0)) {
            nothing = minDistance(word1.substring(1), word2.substring(1));
        }
        // (b) Check what the distance is if we do a Replace first?
        int replace = 1 + minDistance(word1.substring(1), word2.substring(1));
        // (c) Check what the distance is if we do a Delete first?
        int delete = 1 + minDistance(word1.substring(1), word2);
        // (d) Check what the distance is if we do a Insert first?
        int insert = 1 + minDistance(word1, word2.substring(1));

        // Return best solution
        return Math.min(nothing, Math.min(replace, Math.min(delete, insert)));
    }
}
```

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

* Time = O(m * n) 
* Space = O(m * n) 

---