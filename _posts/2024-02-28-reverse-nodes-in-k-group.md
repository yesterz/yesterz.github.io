---
title: Reverse Nodes in k-Group
date: 2024-02-28 07:16:00 +0800
author: Algorithms-Notes
categories: [Algorithms, LeetCode Hot 100]
tags: [Hard, top-100-liked, Recursion, Linked List]
pin: false
math: true
mermaid: false
---

LeetCode <https://leetcode.cn/problems/reverse-nodes-in-k-group/>

## Recursive

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
    public ListNode reverseKGroup(ListNode head, int k) {
        ListNode kth = head;
        int cnt = 1;
        while (kth != null && cnt < k) {
            cnt++;
            kth = kth.next;
        }
        if (kth == null) {
            return head;
        }
        ListNode nextKth = kth.next;
        ListNode prev = null, curr = head;
        while (curr != nextKth) {
            ListNode next = curr.next;
            curr.next = prev;
            prev = curr;
            curr = next;
        }
        head.next = reverseKGroup(nextKth, k);
        return kth;
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(1) 

## Iterative

- [ ] iterative method