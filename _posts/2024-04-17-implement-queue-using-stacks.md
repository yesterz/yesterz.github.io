---
title: Implement Queue using Stacks
date: 2024-04-17 21:46:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Easy, top-100-liked, Stack, Design, Queue]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/implement-queue-using-stacks/>

```java
class MyQueue {

    private Deque<Integer> stackOne;
    private Deque<Integer> stackTwo;

    public MyQueue() {
        stackOne = new LinkedList<>();
        stackTwo = new LinkedList<>();
    }
    
    public void push(int x) {
        stackOne.push(x);
    }
    
    public int pop() {
        if (stackTwo.isEmpty()) {
            transferStack();
        }
        return stackTwo.pop();
    }
    
    public int peek() {
        if (stackTwo.isEmpty()) {
            transferStack();
        }
        return stackTwo.peek();
    }
    
    public boolean empty() {
        return stackOne.isEmpty() && stackTwo.isEmpty();
    }

    private void transferStack() {
        while (!stackOne.isEmpty()) {
            stackTwo.push(stackOne.pop());
        }
    }
}

/**
 * Your MyQueue object will be instantiated and called as such:
 * MyQueue obj = new MyQueue();
 * obj.push(x);
 * int param_2 = obj.pop();
 * int param_3 = obj.peek();
 * boolean param_4 = obj.empty();
 */
```

**Complexity**

* Time = O(k)，k 为 n 的二进制长度
* Space = O(1) 

---