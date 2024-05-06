---
title: Validate Stack Sequences
date: 2024-05-01 13:38:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Medium, Sword To Offer, Stack, Array, Simulation]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/validate-stack-sequences/>

```java
class Solution {
    
    public boolean validateStackSequences(int[] pushed, int[] popped) {

        Deque<Integer> stack = new ArrayDeque<Integer>();
        int n = pushed.length;
        for (int i = 0, j = 0; i < n; i++) {
            stack.push(pushed[i]);
            while (!stack.isEmpty() && stack.peek() == popped[j]) {
                stack.pop();
                j++;
            }
        }
        return stack.isEmpty();
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(n) 

---