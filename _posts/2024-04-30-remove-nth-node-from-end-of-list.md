---
title: Remove Nth Node From End of List
date: 2024-04-30 13:38:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Medium, Sword To Offer, Linked List, Two Pointers]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/remove-nth-node-from-end-of-list/>

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

    public ListNode removeNthFromEnd(ListNode head, int n) {

        ListNode dummy = new ListNode(0, head);
        ListNode first = head;
        ListNode second = dummy;
        for (int i = 0; i < n; ++i) {
            first = first.next;
        }
        while (first != null) {
            first = first.next;
            second = second.next;
        }
        second.next = second.next.next;
        ListNode ans = dummy.next;
        return ans;
    }
}
```

**Complexity**

* Time = O(length) 
* Space = O(1) 

---