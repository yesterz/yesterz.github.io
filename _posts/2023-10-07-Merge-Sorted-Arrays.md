---
title: Merge Sorted Arrays
date: 2023-10-07 23:58:00 +0800
author: Algorithms-Notes
categories: [Leetcode]
tags: [Leetcode, Two Pointers, Array, Sorting]
pin: false
math: true
mermaid: false
---

## Merge Sorted Array

Lintcode <https://www.lintcode.com/problem/64/>

Leetcode <https://leetcode.com/problems/merge-sorted-array/>

### 题目描述

给你两个按 非递减顺序 排列的整数数组 nums1 和 nums2，另有两个整数 m 和 n ，分别表示 nums1 和 nums2 中的元素数目。

请你 合并 nums2 到 nums1 中，使合并后的数组同样按 非递减顺序 排列。

**注意：** 最终，合并后数组不应由函数返回，而是存储在数组 nums1 中。为了应对这种情况，nums1 的初始长度为 m + n，其中前 m 个元素表示应合并的元素，后 n 个元素为 0 ，应忽略。nums2 的长度为 n 。

`public void mergeSortedArray(int[] A, int m, int[] B, int n)`
 

**示例 1：**

输入：nums1 = [1,2,3,0,0,0], m = 3, nums2 = [2,5,6], n = 3

输出：[1,2,2,3,5,6]

解释：需要合并 [1,2,3] 和 [2,5,6] 。合并结果是 [1,2,2,3,5,6] ，其中斜体加粗标注的为 nums1 中的元素。

**示例 2：**

输入：nums1 = [1], m = 1, nums2 = [], n = 0

输出：[1]

解释：需要合并 [1] 和 [] 。合并结果是 [1] 。

**示例 3：**

输入：nums1 = [0], m = 0, nums2 = [1], n = 1

输出：[1]

解释：需要合并的数组是 [] 和 [1] 合并结果是 [1] 。

注意，因为 m = 0 ，所以 nums1 中没有元素。nums1 中仅存的 0 仅仅是为了确保合并结果可以顺利存放到 nums1 中。
 

**提示：**

* nums1.length == m + n
* nums2.length == n
* 0 <= m, n <= 200
* 1 <= m + n <= 200
* -10^9 <= nums1[i], nums2[j] <= 10^9
 

进阶：你可以设计实现一个时间复杂度为 O(m + n) 的算法解决此问题吗？

### 解题报告

“数组的整体挪动”操作的时间复杂度是 O(n)

小的trick：从最大的开始合并，那就可以从空的地方开始。可以 O(m+n) 完成

最直观的方法是将数组 A 放进数组 B 的尾部，然后直接对整个数组进行排序。

```java
class Solution {
    public void merge(int[] nums1, int m, int[] nums2, int n) {
        for (int i = 0; i != n; ++i) {
            nums1[m + i] = nums2[i];
        }
        Arrays.sort(nums1);
    } // end merge
} // end Solution
```

第二种方法，从前往后，双指针一个指向 nums1，另一个指向 nums2，每次取较小的数出来给 ans，然后最后，把 ans 复制给 nums1。


```java
class Solution {
    public void merge(int[] nums1, int m, int[] nums2, int n) {
        int p1 = 0, p2 = 0, cur = 0;
        int[] ans = new int[m + n];
        while (p1 != m || p2 != n) {
            if (p1 == m) {
                cur = nums2[p2++];
            } else if (p2 == n) {
                cur = nums1[p1++];
            } else if (nums1[p1] <= nums2[p2]) {
                cur = nums1[p1++];
            } else {
                cur = nums2[p2++];
            }
            ans[p1 + p2 - 1] = cur;
        } // end while loop
        for (int i = 0; i < ans.length; i++) {
            nums1[i] = ans[i];
        } // end for loop
    } // end merge
} // end Solution
```

第3种方法，不用开辟新的数组，直接用给的，从后往前比较大小，取较大的放到数组的最后面来填充数组。

不会覆盖的原因，一句话就能说明白：

把 nums1 的数字移到另一个空位，又产生了一个新的空位，空位个数不变，所以总是有空位可以让 nums2 的数字填入。

```java
class Solution {
    public void merge(int[] nums1, int m, int[] nums2, int n) {
        int p1 = m - 1;
        int p2 = n - 1;
        int p = m + n -1;
        while (p2 >= 0) { // nums2 还有要合并的元素
            // 如果 p1 < 0，那么走 else 分支，把 nums2 合并到 nums1 中
            if (p1 >= 0 && nums1[p1] > nums2[p2]) {
                nums1[p] = nums1[p1];
                p1 -= 1;
            } else {
                nums1[p] = nums2[p2];
                p2 -= 1;
            }
            p -= 1; // 更新下一个要填充的位置
        } // end while loop
    } // end merge
} // end Solution
```

## Merge Two Sorted Arrays

Lintcode <https://www.lintcode.com/problem/6/>

Solution <https://www.jiuzhang.com/solutions/merge-sorted-array-ii/>

**五星级重要！！！！！**

### 题目描述

将按升序排序的整数数组A和B合并，新数组也需有序。
`public int[] mergeSortedArray(int[] a, int[] b) `

**样例 1：**

**输入：** A = [1] B = [1]

**输出：** [1,1]

解释：返回合并后的数组。

**样例 2：**

**输入：** A = [1,2,3,4] B = [2,4,5,6]

**输出：** [1,2,2,3,4,4,5,6]

**挑战** 如果一个数组很大，另一个数组很小，你将如何优化算法？



### 解题报告

```java
class Solution {
    /**
     * @param A and B: sorted integer array A and B.
     * @return: A new sorted integer array
     */
    public int[] mergeSortedArray(int[] A, int[] B) {
        // Write your code here
        int[] ans = new int[A.length + B.length];
        int a = 0, b = 0, temp = 0;
        while(a != A.length && b != B.length) {
            if(A[a] > B[b]){
                ans[temp] = B[b++];
            }
            else {
                ans[temp] = A[a++];
            }
            temp ++;
        }
        if(a != A.length){
            while(a != A.length){
                ans[temp++] = A[a++];
            }
        } else {
            while(b != B.length){
                ans[temp++] = B[b++];
            }
        }
        return ans;
    }
}
```

```java
public class Solution {
    /**
     * @param a: sorted integer array A
     * @param b: sorted integer array B
     * @return: A new sorted integer array
     */
    public int[] mergeSortedArray(int[] a, int[] b) {
        // write your code here
        int[] ans = new int[a.length + b.length];
        int p1 = 0;
        int p2 = 0;
        int p = 0;
        while (p1 != a.length && p2 != b.length) {
            if (a[p1] > b[p2]) {
                ans[p] = b[p2++];
            } else {
                ans[p] = a[p1++];
            }
            p++;
        } // end while loop
        if (p1 != a.length) {
            while (p1 != a.length) {
                ans[p++] = a[p1++];
            } // end
        } else {
            while (p2 != b.length) {
                ans[p++] = b[p2++];
            } // end while loop
        }

        return ans;
    } // end mergeSortedArray
} // end Solution
```

## Merge K Sorted Arrays

Lintcode <https://www.lintcode.com/problem/486/>

### 题目描述

将 k 个有序数组合并为一个大的有序数组。

**样例 1:**
```
Input: 
  [
    [1, 3, 5, 7],
    [2, 4, 6],
    [0, 8, 9, 10, 11]
  ]
Output: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11] 
```

**样例 2:**

```
Input:
  [
    [1,2,3],
    [1,2]
  ]
Output: [1,1,2,2,3] 
```

### 解题报告

可以用堆做到 O(N log k) 的时间复杂度.

初始将所有数组的首个元素入堆, 并记录入堆的元素是属于哪个数组的.

每次取出堆顶元素, 并放入该元素所在数组的下一个元素.

```java
class Element {
    public int row, col, val;
    Element(int row, int col, int val) {
        this.row = row;
        this.col = col;
        this.val = val;
    }
}

public class Solution {
    private Comparator<Element> ElementComparator = new Comparator<Element>() {
        public int compare(Element left, Element right) {
            return left.val - right.val;
        }
    };
    
    /**
     * @param arrays k sorted integer arrays
     * @return a sorted array
     */
    public int[] mergekSortedArrays(int[][] arrays) {
        if (arrays == null) {
            return new int[0];
        }
        
        int total_size = 0;
        Queue<Element> Q = new PriorityQueue<Element>(
            arrays.length, ElementComparator);
            
        for (int i = 0; i < arrays.length; i++) {
            if (arrays[i].length > 0) {
                Element elem = new Element(i, 0, arrays[i][0]);
                Q.add(elem);
                total_size += arrays[i].length;
            }
        }
        
        int[] result = new int[total_size];
        int index = 0;
        while (!Q.isEmpty()) {
            Element elem = Q.poll();
            result[index++] = elem.val;
            if (elem.col + 1 < arrays[elem.row].length) {
                elem.col += 1;
                elem.val = arrays[elem.row][elem.col];
                Q.add(elem);
            }
        }
        
        return result;
    }
}
```

## Related

 104. Merge K Sorted Lists
 
 486. Merge K Sorted Arrays
 
 577. Merge K Sorted Interval Lists