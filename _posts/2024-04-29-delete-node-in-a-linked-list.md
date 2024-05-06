---
title: Delete Node in a Linked List
date: 2024-04-29 13:38:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Medium, Sword To Offer, Linked List]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/delete-node-in-a-linked-list/>

```java
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode(int x) { val = x; }
 * }
 */
class Solution {
    
    public void deleteNode(ListNode node) {

        node.val = node.next.val;
        node.next = node.next.next;
    }
}
```

**Complexity**

* Time = O(1) 
* Space = O(1) 

---