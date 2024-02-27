---
title: Valid Parentheses
date: 2024-02-27 07:16:00 +0800
author: Algorithms-Notes
categories: [Algorithms, LeetCode Hot 100]
tags: [Easy, top-100-liked, Stack, String]
pin: false
math: true
mermaid: false
---

LeetCode <https://leetcode.cn/problems/valid-parentheses/>

```java
class Solution {
    public boolean isValid(String s) {
        if (s.length() < 2) {
            return false;
        }
        Stack<Character> stack = new Stack<>();
        for (int i = 0; i < s.length(); i++) {
            char curr = s.charAt(i);
            if (curr == '(' || curr == '[' || curr == '{') {
                stack.push(curr);
                continue;
            } 
            if (!stack.isEmpty()) {
                if (curr == ')' && stack.peek() == '(') {
                    stack.pop();
                } else if (curr == ']' && stack.peek() == '[') {
                    stack.pop();
                } else if (curr == '}' && stack.peek() == '{') {
                    stack.pop();
                } else {
                    return false;
                }
            } else {
                return false;
            }
        }

        return stack.isEmpty();
    }
}
```


**Complexity**

* Time = O(n) 
* Space = O(n) 
