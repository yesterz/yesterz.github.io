---
title: Merge Two Sorted Lists
date: 2024-04-30 13:51:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Easy, Sword To Offer, Recursion, Linked List]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/merge-two-sorted-lists/>

```java
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode() {}
 *     ListNode(int val) { this.val = val; }
 *     ListNode(int val, ListNode next) { this.val = val; this.next = next; }
 * }
 */
class Solution {

    public ListNode mergeTwoLists(ListNode l1, ListNode l2) {

        if (l1 == null) {
            return l2;
        } else if (l2 == null) {
            return l1;
        } else if (l1.val < l2.val) {
            l1.next = mergeTwoLists(l1.next, l2);
            return l1;
        } else {
            l2.next = mergeTwoLists(l1, l2.next);
            return l2;
        }
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(1) 

---