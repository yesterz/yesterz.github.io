---
title: First Unique Character in a String
date: 2024-02-17 19:46:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Easy, Sword To Offer, Queue, Hash Table, String, Counting]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/first-unique-character-in-a-string/>


```java
class Solution {
    public int firstUniqChar(String s) {

        HashMap<Character, Integer> map = new HashMap<>();
        for (char ch : s.toCharArray()) {
            map.put(ch, map.getOrDefault(ch, 0) + 1);            
        }
        for (int i = 0; i < s.length(); i++) {
            if (map.get(s.charAt(i)) == 1) {
                return i;
            }
        }

        return -1;
    }
}
```

**Optimize**

```java
class Solution {
    public int firstUniqChar(String s) {

        int min = Integer.MAX_VALUE;
        for (char c = 'a'; c <= 'z'; ++c){
            int index = s.indexOf(c);
            if (index != -1 &&  index == s.lastIndexOf(c))
                min = Math.min(min, index);
        }
        
        return min == Integer.MAX_VALUE ? -1: min;
    }
}
```