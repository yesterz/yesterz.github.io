---
title: Reverse Linked List
date: 2024-04-27 22:26:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Easy, Sword To Offer, Recursion, Linked List]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/reverse-linked-list/>

* Method 1: recursion

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

    public ListNode reverseList(ListNode head) {

        if (head == null || head.next == null) {
            return head;
        }

        ListNode current = head;
        ListNode newHead = reverseList(current.next);
        current.next.next = current;
        current.next = null;

        return newHead;
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(n) 

* Method 2: iteration

```java
/**
 * Definition for singly-linked list.
 * public class ListNode {
 * int val;
 * ListNode next;
 * ListNode() {}
 * ListNode(int val) { this.val = val; }
 * ListNode(int val, ListNode next) { this.val = val; this.next = next; }
 * }
 */
class Solution {

    public ListNode reverseList(ListNode head) {

        if (head == null || head.next == null) {
            return head;
        }

        ListNode prev = null;
        ListNode curr = head;
        while (curr != null) {
            ListNode next = curr.next;
            curr.next = prev;
            prev = curr;
            curr = next;
        }
        
        return prev;
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(1) 

---