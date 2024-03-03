---
title: 剑指Offer的链表题目
author: Algorithms-Notes
date: 2023-08-23 11:33:00 +0800
categories: [Algorithms]
tags: [剑指Offer, Linked List]
pin: false
math: false
mermaid: false
---

## Review

- [x] 剑指Offer的9道算法题目，做出来了4道题，其余的要么是根本没思路，要么是思路卡壳时间太久，直接看了题解。
- [ ] 这一片post还要改改文章格式，看着有点小乱。

## JZ6 从尾到头打印链表

- 描述

输入一个链表的头节点，按链表从尾到头的顺序返回每个节点的值（用数组返回）。
如输入{1,2,3}的链表如下图:
![](/assets/images/SwordToOfferImages/JZ6.png)
返回一个数组为[3,2,1]；0 <= 链表长度 <= 10000

- 示例1

输入：{1,2,3}
返回值：[3,2,1]

- 示例2

输入：{67,0,24,58}
返回值：[58,24,0,67]

我第一时间想到的是把这个链表逆序，然后顺序打印出来。

```java
import java.util.*;
/**
*    public class ListNode {
*        int val;
*        ListNode next = null;
*
*        ListNode(int val) {
*            this.val = val;
*        }
*    }
*
*/
import java.util.ArrayList;
public class Solution {
    public static ListNode reverse(ListNode head) {
        ListNode prev = null;
        ListNode next = null;
        while (head != null) {
            next = head.next;
            head.next = prev;
            prev = head;
            head = next;
        }
        return prev;
    }

    public ArrayList<Integer> printListFromTailToHead(ListNode listNode) {
        ListNode head = reverse(listNode);
        ArrayList<Integer> ans = new ArrayList<>();
        while (head != null) {
            ans.add(head.val);
            head = head.next;
        }
        return ans;
    }
}

```

还可以用栈这个数据结构，不过我没想到这个。

```java
import java.util.*;
public class Solution {
    public ArrayList<Integer> printListFromTailToHead(ListNode listNode) {
        ArrayList<Integer> res = new ArrayList<Integer>();
        Stack<Integer> s = new Stack<Integer>();
        //正序输出链表到栈中
        while(listNode != null){ 
            s.push(listNode.val);
            listNode = listNode.next;
        }
        //输出栈中元素到数组中
        while(!s.isEmpty()) 
            res.add(s.pop());
        return res;
    }
}
```

## JZ24 反转链表

- 描述

给定一个单链表的头结点pHead(该头节点是有值的，比如在下图，它的val是1)，长度为n，反转该链表后，返回新链表的表头。
数据范围： 0\leq n\leq10000≤_n_≤1000
要求：空间复杂度 O(1)_O_(1) ，时间复杂度 O(n)_O_(_n_) 。
如当输入链表{1,2,3}时，经反转后，原链表变为{3,2,1}，所以对应的输出为{3,2,1}。
以上转换过程如下图所示：

![](/assets/images/SwordToOfferImages/JZ24.png)

- 示例1

输入：{1,2,3}复制
返回值：{3,2,1}复制

- 示例2

输入：{}复制
返回值：{}复制
说明：空链表则输出空

```java
import java.util.*;

/*
 * public class ListNode {
 *   int val;
 *   ListNode next = null;
 *   public ListNode(int val) {
 *     this.val = val;
 *   }
 * }
 */

public class Solution {
    /**
     * 代码中的类名、方法名、参数名已经指定，请勿修改，直接返回方法规定的值即可
     *
     * 
     * @param head ListNode类 
     * @return ListNode类
     */
    public ListNode ReverseList (ListNode head) {
        // write code here
        ListNode prev = null;
        ListNode next = null;
        while (head != null) {
            next = head.next;
            head.next = prev;
            prev = head;
            head = next;
        }

        return prev;
    }
}
```

## JZ25 合并两个排序的链表【review】

- 描述

输入两个递增的链表，单个链表的长度为n，合并这两个链表并使新链表中的节点仍然是递增排序的。
数据范围： 0 \le n \le 10000≤_n_≤1000，-1000 \le 节点值 \le 1000−1000≤节点值≤1000
要求：空间复杂度 O(1)_O_(1)，时间复杂度 O(n)_O_(_n_)
如输入{1,3,5},{2,4,6}时，合并后的链表为{1,2,3,4,5,6}，所以对应的输出为{1,2,3,4,5,6}，转换过程如下图所示：

![](/assets/images/SwordToOfferImages/JZ25-1.png)

或输入{-1,2,4},{1,3,4}时，合并后的链表为{-1,1,2,3,4,4}，所以对应的输出为{-1,1,2,3,4,4}，转换过程如下图所示：

![](assets/images/SwordToOfferImages/JZ25-2.png)

- 示例1

输入：{1,3,5},{2,4,6}复制
返回值：{1,2,3,4,5,6}复制

- 示例2

输入：{},{}复制
返回值：{}复制

- 示例3

输入：{-1,2,4},{1,3,4}复制
返回值：{-1,1,2,3,4,4}

<h3 data-toc-skip>超级6的解法</h3>

```java
import java.util.*;

/*
 * public class ListNode {
 *   int val;
 *   ListNode next = null;
 *   public ListNode(int val) {
 *     this.val = val;
 *   }
 * }
 */

public class Solution {
    /**
     * 代码中的类名、方法名、参数名已经指定，请勿修改，直接返回方法规定的值即可
     *
     * 
     * @param pHead1 ListNode类 
     * @param pHead2 ListNode类 
     * @return ListNode类
     */
    public ListNode Merge (ListNode pHead1, ListNode pHead2) {
        if (pHead1 == null || pHead2 == null) {
            return pHead1 == null ? pHead2 : pHead1;
        }
        ListNode head = pHead1.val <= pHead2.val ? pHead1 : pHead2;
        ListNode cur1 = head.next;
        ListNode cur2 = head == pHead1 ? pHead2 : pHead1;
        ListNode pre = head;
        while (cur1 != null && cur2 != null) {
            if (cur1.val <= cur2.val) {
                pre.next = cur1;
                cur1 = cur1.next;
            } else {
                pre.next = cur2;
                cur2 = cur2.next;
            }
            pre = pre.next;
        }
        pre.next = cur1 != null ? cur1 : cur2;

        return head;
    }
}
```

## **JZ52 两个链表的第一个公共结点【review】**

- 描述

输入两个无环的单向链表，找出它们的第一个公共结点，如果没有公共节点则返回空。（注意因为传入数据是链表，所以错误测试数据的提示是用其他方式显示的，保证传入数据是正确的）
数据范围： n \le 1000_n_≤1000
要求：空间复杂度 O(1)_O_(1)，时间复杂度 O(n)_O_(_n_)
例如，输入{1,2,3},{4,5},{6,7}时，两个无环的单向链表的结构如下图所示：

![](assets/images/SwordToOfferImages/JZ52-1.png)

可以看到它们的第一个公共结点的结点值为6，所以返回结点值为6的结点。
输入描述：
输入分为是3段，第一段是第一个链表的非公共部分，第二段是第二个链表的非公共部分，第三段是第一个链表和第二个链表的公共部分。 后台会将这3个参数组装为两个链表，并将这两个链表对应的头节点传入到函数FindFirstCommonNode里面，用户得到的输入只有pHead1和pHead2。
返回值描述：
返回传入的pHead1和pHead2的第一个公共结点，后台会打印以该节点为头节点的链表。

- 示例1

输入：{1,2,3},{4,5},{6,7}复制
返回值：{6,7}复制
说明：第一个参数{1,2,3}代表是第一个链表非公共部分，第二个参数{4,5}代表是第二个链表非公共部分，最后的{6,7}表示的是2个链表的公共部分 这3个参数最后在后台会组装成为2个两个无环的单链表，且是有公共节点的

- 示例2

输入：{1},{2,3},{}复制
返回值：{}复制
说明：2个链表没有公共节点 ,返回null，后台打印{}       

**解题思路：**

使用两个指针N1,N2，一个从链表1的头节点开始遍历，我们记为N1，一个从链表2的头节点开始遍历，我们记为N2。
让N1和N2一起遍历，当N1先走完链表1的尽头（为null）的时候，则从链表2的头节点继续遍历，同样，如果N2先走完了链表2的尽头，则从链表1的头节点继续遍历，也就是说，N1和N2都会遍历链表1和链表2。</br>
因为两个指针，同样的速度，走完同样长度（链表1+链表2），不管两条链表有无相同节点，都能够到达同时到达终点。（N1最后肯定能到达链表2的终点，N2肯定能到达链表1的终点）。所以，如何得到公共节点：

- 有公共节点的时候，N1和N2必会相遇，因为长度一样嘛，速度也一定，必会走到相同的地方的，所以当两者相等的时候，则会第一个公共的节点
- 无公共节点的时候，此时N1和N2则都会走到终点，那么他们此时都是null，所以也算是相等了。

下面看个动态图，可以更形象的表示这个过程~

![](assets/images/SwordToOfferImages/JZ52.gif)

代码：

```java
publicListNode FindFirstCommonNode(ListNode pHead1, ListNode pHead2) {

        ListNode l1 = pHead1, l2 = pHead2;
        while(l1 != l2){
            l1 = (l1==null)?pHead2:l1.next;
            l2 = (l2==null)?pHead1:l2.next;
        }
        returnl1;
    }
```

**复杂度分析：**

1. 时间复杂度：O(m+n)。链表1和链表2的长度之和。
2. 空间复杂度：O(1)。常数的空间。

## JZ23 链表中环的入口结点【review】

- 描述

给一个长度为n链表，若其中包含环，请找出该链表的环的入口结点，否则，返回null。
数据范围： n\le10000_n_≤10000，1<=结点值<=100001<=结点值<=10000
要求：空间复杂度 O(1)_O_(1)，时间复杂度 O(n)_O_(_n_)
例如，输入{1,2},{3,4,5}时，对应的环形链表如下图所示：
![](assets/images/SwordToOfferImages/JZ23.png)
可以看到环的入口结点的结点值为3，所以返回结点值为3的结点。
输入描述：
输入分为2段，第一段是入环前的链表部分，第二段是链表环的部分，后台会根据第二段是否为空将这两段组装成一个无环或者有环单链表
返回值描述：
返回链表的环的入口结点即可，我们后台程序会打印这个结点对应的结点值；若没有，则返回对应编程语言的空结点即可。

- 示例1

输入：{1,2},{3,4,5}复制
返回值：3复制
说明：返回环形链表入口结点，我们后台程序会打印该环形链表入口结点对应的结点值，即3

- 示例2

输入：{1},{}复制
返回值："null"复制
说明：没有环，返回对应编程语言的空结点，后台程序会打印"null"

- 示例3

输入：{},{2} 复制
返回值：2复制
说明：环的部分只有一个结点，所以返回该环形链表入口结点，后台程序打印该结点对应的结点值，即2   

```java
import java.util.*;
/*
 public class ListNode {
    int val;
    ListNode next = null;

    ListNode(int val) {
        this.val = val;
    }
}
*/
public class Solution {

    public ListNode EntryNodeOfLoop(ListNode pHead) {
        Map<ListNode, Integer> map = new HashMap<>();
        ListNode node = pHead;
        while (node != null) {
            map.put(node, map.getOrDefault(node, 0)+1);
            if (map.get(node) == 2) {
                return node;
            }
            node = node.next;
        }
        return null;
    }
}

```

## JZ22 链表中倒数最后k个结点

- 描述

输入一个长度为 n 的链表，设链表中的元素的值为 ai ，返回该链表中倒数第k个节点。
如果该链表长度小于k，请返回一个长度为 0 的链表。
数据范围：0 \leq n \leq 10^50≤_n_≤105，0 \leq a_i \leq 10^90≤_ai_≤109，0 \leq k \leq 10^90≤_k_≤109
要求：空间复杂度 O(n)_O_(_n_)，时间复杂度 O(n)_O_(_n_)
进阶：空间复杂度 O(1)_O_(1)，时间复杂度 O(n)_O_(_n_)
例如输入{1,2,3,4,5},2时，对应的链表结构如下图所示：

![](assets/images/SwordToOfferImages/JZ22.png)

其中蓝色部分为该链表的最后2个结点，所以返回倒数第2个结点（也即结点值为4的结点）即可，系统会打印后面所有的节点来比较。

- 示例1

输入：{1,2,3,4,5},2复制
返回值：{4,5}复制
说明：返回倒数第2个节点4，系统会打印后面所有的节点来比较。 

- 示例2

输入：{2},8复制
返回值：{}

```java
import java.util.*;

/*
 * public class ListNode {
 *   int val;
 *   ListNode next = null;
 *   public ListNode(int val) {
 *     this.val = val;
 *   }
 * }
 */

public class Solution {
    /**
     * 代码中的类名、方法名、参数名已经指定，请勿修改，直接返回方法规定的值即可
     *
     * 
     * @param pHead ListNode类 
     * @param k int整型 
     * @return ListNode类
     */
    public ListNode FindKthToTail (ListNode pHead, int k) {
        // write code here
        
        int listLen = length(pHead);
        if (listLen < k) return null;
        ListNode ptrK = pHead;
        for (int i=0; i<(listLen-k); i++) {
            ptrK = ptrK.next;
        }
        return ptrK;
    }
    public int length(ListNode n) {
        ListNode head = n;
        int cnt = 0;
        if (head == null) {
            return cnt;
        }
        while (head != null) {
            cnt++;
            head = head.next;
        }
        return cnt;
    }
}
```

**我感觉很优雅的一个解法！我自己没想出来这个，头一次见快慢指针的解法。**
**知识点：双指针**
双指针指的是在遍历对象的过程中，不是普通的使用单个指针进行访问，而是使用两个指针（特殊情况甚至可以多个），两个指针或是同方向访问两个链表、或是同方向访问一个链表（快慢指针）、或是相反方向扫描（对撞指针），从而达到我们需要的目的。

**思路：**
我们无法逆序遍历链表，就很难得到链表的倒数第kk_k_个元素，那我们可以试试反过来考虑，如果当前我们处于倒数第kk_k_的位置上，即距离链表尾的距离是kk_k_，那我们假设双指针指向这两个位置，二者同步向前移动，当前面个指针到了链表头的时候，两个指针之间的距离还是kk_k_。虽然我们没有办法让指针逆向移动，但是我们刚刚这个思路却可以正向实施。

**具体做法：**

- step 1：准备一个快指针，从链表头开始，在链表上先走kk_k_步。
- step 2：准备慢指针指向原始链表头，代表当前元素，则慢指针与快指针之间的距离一直都是kk_k_。
- step 3：快慢指针同步移动，当快指针到达链表尾部的时候，慢指针正好到了倒数kk_k_个元素的位置。

```java
import java.util.*;
public class Solution {
    public ListNode FindKthToTail (ListNode pHead, int k) {
        int n = 0;
        ListNode fast = pHead; 
        ListNode slow = pHead;
        //快指针先行k步
        for(int i = 0; i < k; i++){  
            if(fast != null)
                fast = fast.next;
            //达不到k步说明链表过短，没有倒数k
            else 
                return slow = null;
        }
        //快慢指针同步，快指针先到底，慢指针指向倒数第k个
        while(fast != null){ 
            fast = fast.next;
            slow = slow.next;
        }
        return slow;
    }
}
```

## JZ35 复杂链表的复制【review】

题目的主要信息：

- 一个复杂链表除了有指向后一个节点的指针，还有一个指针随机节点的指针
- 将该复杂链表拷贝，返回拷贝链表的头节点
- 拷贝链表必须创建新的节点

方法一：组合链表（推荐使用）
**知识点：双指针**
双指针指的是在遍历对象的过程中，不是普通的使用单个指针进行访问，而是使用两个指针（特殊情况甚至可以多个），两个指针或是同方向访问两个链表、或是同方向访问一个链表（快慢指针）、或是相反方向扫描（对撞指针），从而达到我们需要的目的。
**思路：**
正常链表的复制，从头到尾遍历链表，对于每个节点创建新的节点，赋值，并将其连接好就可以了。这道题的不同之处在于我们还要将随机指针连接好，我们创建节点的时候，有可能这个节点创建了，但是它的随机指针指向的节点没有创建，因此创建的时候只能连接指向后面的指针，无法连接随机指针。

等链表连接好了，再连接随机指针的话，我们又难以找到这个指针指向的位置，因为链表不支持随机访问。但是吧，我们待拷贝的链表可以通过随机指针访问节点，那么我们不如将拷贝后的每个节点插入到原始链表相应节点之后，这样连接random指针的时候，原始链表random指针后一个元素就是原始链表要找的随机节点，而该节点后一个就是它拷贝出来的新节点，这不就可以连上了嘛。

```java
//跟随前一个连接random
if(cur.random == null)
    clone.random = null;
else
    //后一个节点才是拷贝的
    clone.random = cur.random.next;
```

这样等随机指针链表完成之后，再遍历链表，将其拆分按照奇偶序列拆分成两个链表：只需要每次越过相邻节点连接就可以了。

```java
//cur.next必定不为空
cur.next = cur.next.next;
cur = cur.next;
//检查末尾节点
if(clone.next != null)
    clone.next = clone.next.next;
clone = clone.next;
```

**具体做法：**

- step 1：遍历链表，对每个节点新建一个拷贝节点，并插入到该节点之后。
- step 2：使用双指针再次遍历链表，两个指针每次都移动两步，一个指针遍历原始节点，一个指针遍历拷贝节点，拷贝节点的随机指针跟随原始节点，指向原始节点随机指针的下一位。
- step 3：再次使用双指针遍历链表，每次越过后一位相连，即拆分成两个链表。

**图示：**

```java
public class Solution {
    public RandomListNode Clone(RandomListNode pHead) {
        //空节点直接返回
        if(pHead == null)
            return pHead;
        //添加一个头部节点
        RandomListNode cur = pHead;
        //遍历原始链表，开始复制
        while(cur != null){
            //拷贝节点
            RandomListNode clone = new RandomListNode(cur.label);
            //将新节点插入到被拷贝的节点后
            clone.next = cur.next;
            cur.next = clone;
            cur = clone.next;
        }
        cur = pHead;
        RandomListNode clone = pHead.next;
        RandomListNode res = pHead.next;
        //连接新链表的random节点
        while(cur != null){
            //跟随前一个连接random
            if(cur.random == null)
                clone.random = null;
            else
                //后一个节点才是拷贝的
                clone.random = cur.random.next;
            //cur.next必定不为空
            cur = cur.next.next;
            //检查末尾节点
            if(clone.next != null)
                clone = clone.next.next;
        }
        cur = pHead;
        clone = pHead.next;
        //拆分两个链表
        while(cur != null){
            //cur.next必定不为空
            cur.next = cur.next.next;
            cur = cur.next;
            //检查末尾节点
            if(clone.next != null)
                clone.next = clone.next.next;
            clone = clone.next;
        }
        return res;
    }
}
```

## JZ76 删除链表中重复的节点【review】

描述：在一个排序的链表中，存在重复的结点，请删除该链表中重复的结点，重复的结点不保留，返回链表头指针。 例如，链表 1->2->3->3->4->4->5  处理后为 1->2->5
数据范围：链表长度满足 0 \le n \le 1000 \0≤_n_≤1000  ，链表中的值满足 1 \le val \le 1000 \1≤_val_≤1000 
进阶：空间复杂度 O(n)\_O_(_n_)  ，时间复杂度 O(n) \_O_(_n_) 
例如输入{1,2,3,3,4,4,5}时，对应的输出为{1,2,5}，对应的输入输出链表如下图所示：

![](assets/images/SwordToOfferImages/JZ76.png)

- 示例1

输入：{1,2,3,3,4,4,5}复制
返回值：{1,2,5}复制

- 示例2

输入：{1,1,1,8}复制
返回值：{8}

**这道题我自己的解法没过，看了一下，这是题解的代码。。。**

```java
class Solution {
    public ListNode deleteDuplication(ListNode pHead) {
        ListNode dummy = new ListNode(-1);
        ListNode tail = dummy;
        while (pHead != null) {
            // 进入循环时，确保了 pHead 不会与上一节点相同
            if (pHead.next == null || pHead.next.val != pHead.val) {
                tail.next = pHead;
                tail = pHead;
            }
            // 如果 pHead 与下一节点相同，跳过相同节点（到达「连续相同一段」的最后一位）
            while (pHead.next != null && pHead.val == pHead.next.val) pHead = pHead.next;
            pHead = pHead.next;
        }
        tail.next = null;
        return dummy.next;
    }
}
```

## JZ18 删除链表的节点

- 描述

给定单向链表的头指针和一个要删除的节点的值，定义一个函数删除该节点。返回删除后的链表的头节点。
1. 此题对比原题有改动
2. 题目保证链表中节点的值互不相同
3. 该题只会输出返回的链表和结果做对比，所以若使用 C 或 C++ 语言，你不需要 free 或 delete 被删除的节点
数据范围:
0<=链表节点值<=10000
0<=链表长度<=10000

- 示例1

输入：{2,5,1,9},5复制
返回值：{2,1,9} 复制
说明：给定你链表中值为 5 的第二个节点，那么在调用了你的函数之后，该链表应变为 2 -> 1 -> 9 

- 示例2

输入：{2,5,1,9},1复制
返回值：{2,5,9} 复制
说明：给定你链表中值为 1 的第三个节点，那么在调用了你的函数之后，该链表应变为 2 -> 5 -> 9   

```java
import java.util.*;

/*
 * public class ListNode {
 *   int val;
 *   ListNode next = null;
 *   public ListNode(int val) {
 *     this.val = val;
 *   }
 * }
 */

public class Solution {
    /**
     * 代码中的类名、方法名、参数名已经指定，请勿修改，直接返回方法规定的值即可
     *
     * 
     * @param head ListNode类 
     * @param val int整型 
     * @return ListNode类
     */
    public ListNode deleteNode (ListNode head, int val) {
        // write code here
        ListNode p = head;

        // 单独判断第一个节点是不是要删除的节点
        if (head.val == val) {
            //head = head.next;
            return head.next;
        }
        
        while (p != null) {
            if (p.next.val == val) {
                p.next = p.next.next;
                break;
            }
            p = p.next;
        }
        return head;
    }
}
```