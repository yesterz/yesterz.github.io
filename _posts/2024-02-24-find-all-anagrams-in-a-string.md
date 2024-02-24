---
title: Find All Anagrams in a String
date: 2024-02-24 07:30:00 +0800
author: Algorithms-Notes
categories: [Algorithms, LeetCode Hot 100]
tags: [Hard, top-100-liked, Hash Table, String, Sliding Window]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/find-all-anagrams-in-a-string/>

```java
class Solution {
    public List<Integer> findAnagrams(String s, String p) {
        List<Integer> res = new ArrayList<>();
        if (s == null || p == null) {
            return res;
        }
        if (s.length() == 0 || p.length() > s.length()) {
            return res;
        }
 
        Map<Character, Integer> freq = new HashMap<>();
        for (int i = 0; i < p.length(); i++) {
            freq.put(p.charAt(i), 
                    freq.getOrDefault(p.charAt(i), 0) + 1);
        } // end count frequency
        
        int matched = 0;
        int windowSize = p.length();
        for (int i = 0; i < s.length(); i++) {
            char newChar = s.charAt(i);
            Integer newFreq = freq.get(newChar);
            if (newFreq != null) {
                freq.put(newChar, --newFreq);
                if (newFreq == 0) {
                    matched++;
                }
            }
            if (i >= windowSize) {
                char oldChar = s.charAt(i - windowSize);
                Integer oldFreq = freq.get(oldChar);
                if (oldFreq != null) {
                    freq.put(oldChar, ++oldFreq);
                    if (oldFreq == 1) {
                        matched--;
                    }
                }
            }
            if (matched == freq.size()) {
                res.add(i - windowSize + 1);
            }
        }

        return res;
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(n) 
