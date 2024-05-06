---
title: Remove Duplicates from Sorted List II
date: 2024-04-29 13:40:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Medium, Sword To Offer, Linked List, Two Pointers]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/remove-duplicates-from-sorted-list-ii/>

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

    public ListNode deleteDuplicates(ListNode head) {

        if (head == null) {
            return head;
        }
        
        ListNode dummy = new ListNode(0, head);

        ListNode cur = dummy;
        while (cur.next != null && cur.next.next != null) {
            if (cur.next.val == cur.next.next.val) {
                int x = cur.next.val;
                while (cur.next != null && cur.next.val == x) {
                    cur.next = cur.next.next;
                }
            } else {
                cur = cur.next;
            }
        }

        return dummy.next;
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(1) 

---