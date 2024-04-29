---
title: Copy List with Random Pointer
date: 2024-02-28 07:11:00 +0800
author: Algorithms-Notes
categories: [Algorithms, LeetCode Hot 100]
tags: [Medium, top-100-liked, Sword To Offer, Hash Table, Linked List]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/copy-list-with-random-pointer/>

## Solution 1: HashMap

**Idea:** Build mapping between node in the original list and the corresponding node in the new list

Two pointers:
1. Head -> current list
2. Curr -> new list

HashMap: 
1. KEY: original node
2. VALUE: new node

```java
/*
// Definition for a Node.
class Node {
    int val;
    Node next;
    Node random;

    public Node(int val) {
        this.val = val;
        this.next = null;
        this.random = null;
    }
}
*/

class Solution {

    public Node copyRandomList(Node head) {

        if (head == null) {
            return null;
        }

        Node dummy = new Node(0);
        Node curr = dummy;

        Map<Node, Node> mapping = new HashMap<>();
        while (head != null) {
            if (!mapping.containsKey(head)) {
                mapping.put(head, new Node(head.val));
            }
            curr.next = mapping.get(head);
            if (head.random != null) {
                if (!mapping.containsKey(head.random)) {
                    mapping.put(head.random, new Node(head.random.val));
                }
                curr.next.random = mapping.get(head.random);
            }
            head = head.next;
            curr = curr.next;
        }

        return dummy.next;
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(n) 

## Solution 2: No HashMap

Steps:
1. For each node in the original list, insert a copied node between the node and the node.next
2. Link the random pointer for the copied node
3. extract the copied node (namely copy next pointer)

```java
/*
// Definition for a Node.
class Node {
    int val;
    Node next;
    Node random;

    public Node(int val) {
        this.val = val;
        this.next = null;
        this.random = null;
    }
}
*/

class Solution {

    public Node copyRandomList(Node head) {
        
        if (head == null) {
            return null;
        }

        Node curr = head;
        while (curr != null) {
            Node copy = new Node(curr.val);
            copy.next = curr.next;
            curr.next = copy;
            curr = curr.next.next;
        }

        curr = head;
        while (curr != null) {
            if (curr.random != null) {
                curr.next.random = curr.random.next;
            }
            curr = curr.next.next;
        }
        
        curr = head;
        Node dummy = new Node(0);
        Node copyPrev = dummy;
        while (curr != null) {
            copyPrev.next = curr.next;
            curr.next = curr.next.next;
            copyPrev = copyPrev.next;
            curr = curr.next;
        }

        return dummy.next;
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(1) 