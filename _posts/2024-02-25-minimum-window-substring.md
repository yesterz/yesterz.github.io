---
title: Minimum Window Substring
date: 2024-02-25 07:56:00 +0800
author: Algorithms-Notes
categories: [Algorithms, LeetCode Hot 100]
tags: [Hard, top-100-liked, Hash Table, String, Sliding Window]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/minimum-window-substring/>

## Description

Given a string S and a string T, find the minimum window in S which will contain all the characters in T in complexity O(n).

For example,

**S** = "ADOBECODEBANC"

**T** = "ABC"

Minimum window is"BANC".

Note:

If there is no such window in S that covers all characters in T, return the empty string"".

If there are multiple such windows, you are guaranteed that there will always be only one unique minimum window in S.

S = "ADOBECODEBAN"

T = "ABC"

Minimum window is "BANC".

## General Idea:

For each fast pointer, we need to find the corresponding slow pointer to ensure the sliding window is the shortest one matching T.

and **we know that if fast to fast + 1, slow pointer will never move left.**

so the high level idea is using a slow and a fast, 

for each fast, find the corresponding slow by continuously moving to the right.

Map
1. key: distinct character
2. value: frequency

<A, 1>, <B, 1>, <C, 1>

* slow
* fast
* match_count
* min_len
* index


## Solution

```java
class Solution {
    // Assumption: s and t are both not null
    public String minWindow(String s, String t) {
        // corner case
        if (s.length() < t.length()) {
            return "";
        }

        Map<Character, Integer> wordDict = constructWordDict(t);
        int matchCnt = 0, index = 0, minLen = Integer.MAX_VALUE, slow = 0;

        for (int fast = 0; fast < s.length(); fast++) {
            char ch = s.charAt(fast);
            Integer count = wordDict.get(ch);
            if (count == null) {
                continue;
            }
            wordDict.put(ch, count - 1);
            // match another character
            if (count == 1) {
                // 1 -> 0
                matchCnt++;
            }

            while (matchCnt == wordDict.size()) {
                // find a valid substring
                if (fast - slow + 1 < minLen) {
                    minLen = fast - slow + 1;
                    index = slow;
                }
                char leftmost = s.charAt(slow++);
                Integer leftmostCount = wordDict.get(leftmost);
                if (leftmostCount == null) {
                    continue;
                }
                wordDict.put(leftmost, leftmostCount + 1);
                if (leftmostCount == 0) {
                    // 0 -> 1
                    matchCnt--;
                }
            }
        }
        return minLen == Integer.MAX_VALUE ? "" : s.substring(index, index + minLen);
    }

    private Map<Character, Integer> constructWordDict(String t) {
        Map<Character, Integer> map = new HashMap<>();
        for (char ch : t.toCharArray()) {
            Integer count = map.get(ch);
            if (count == null) {
                map.put(ch, 1);
            } else {
                map.put(ch, count + 1);
            }
        }
        return map;
    }

}
```

**Complexity**

* Time = O(n) 
* Space = O(n) 