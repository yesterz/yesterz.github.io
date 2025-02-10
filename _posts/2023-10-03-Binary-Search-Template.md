---
title: Binary Search Template
date: 2023-10-03 14:08:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Search]
pin: false
math: true
mermaid: false
media_subpath: /assets/images/GraphAndSearchImages/
---

## Outline

- 第一境界 二分法模板
  - 时间复杂度小练习
  - 递归与非递归的权衡
  - 二分的三大痛点
  - 通用的二分法模板

- 第二境界：二分位置 之 圈圈叉叉 Binary Search on Index - OOXX
  - 找到满足某个条件的第一个位置或者最后一个位置

- 第三境界：二分位置 之 保留一半 Binary Search on Index - Half half
  - 保留有解的一半，或者去掉无解的一半

## Binary Search

Given an sorted integer array - nums, and an integer - target.

Find the **any/first/last** position of target in nums

Return **-1** if target does not exist.

## 时间复杂度的训练

T(n) = T(n/2) + O(1) = O(logn)

通过 O(1) 的时间，把规模为 n 的问题变为 n/2

思考：通过O(n)的时间，把规模为 n 的问题变为 n/2？

空间复杂度基本不考，没有什么考查的的点。

Q: O是什么个东西？

Ans: 本来区分 big O 和 small o（big O 是上限，最慢的情况下。small o 是最快的情况下。）但是我们不区分，基本讲时间复杂度都是大O。

![img](bs1.png)

1. 不要和面试官说时间复杂度是 O(2n) => O(n)，时间复杂度与系数无关。
2. O(n + 10) => O(n)，时间复杂度不论常数项
3. O(n^3 + n^2) => O(n^3)，时间复杂度只看最高项
4. O(n^2 + nlongn) => O(n^2)
5. 约等于，只是关心它的数量级是什么，而不是算出来的具体值。
6. O(n) + O(n) = O(2n) = O(n)



Q n是什么？

Ans n是指它的数据规模，比如数组就是数组长度。



Q T是什么？

Ans T就是时间复杂度。Time Complexity，T(n) 是问题规模。



![img](bs2.png)

T(n) = T(n/2) + O(1) = [ T(n/4) + O(1) ] + O(1) = ... = T(1) + logn

= log2(n) x O(1) + O(1)



log(n) 和 log(n^2) = 2log(n)

T(n) 是一个 Question，O(n) 是最后的结果。



T(n) = T(n/2) + O(n) = O(n)

## Time Complexity in Coding Interview

- O(1) 极少
- O(longn) 几乎都是二分法
- O(根号n) 几乎是分解质因数
- O(n) 高频
- O(nlogn) 一般都可能要排序
- O(n^2) 数组，枚举，动态规划
- O(n^3) 数组，枚举，动态规划
- O(2^n) 与组合有关的搜索
- O(n!) 与排列有关的搜索

## 独孤九剑——破剑式

**比 O(n) 更优的时间复杂度几乎只能是 O(logn) 的二分法**

经验之谈：根据时间复杂度倒推算法是面试中的常用策略

**二分查找法主要是解决在“一堆数中找出指定的数”这类问题。**

**而想要应用二分查找法，这“一堆数”必须有一下特征：**

**存储在数组中**

**有序排列 （无序的话二分用来当猜答案的方法）**

**所以如果是用链表存储的，就无法在其上应用二分查找法了。**

## Recursion or While Loop?

R: Recursion W: While loop B: Both work

## Recursion or Non-Recursion

面试中是否使用 Recursion 的几个判断条件

1. 面试官是否要求了不使用 Recursion（如果你不确定，就向面试官询问）
2. 不用 Recursion 是否会造成实现变得很复杂
3. Recursion 的深度是否会很深
4. 题目的考点是 Recursion vs Non-Recursion 还是就是考你是否会 Recursion？

- 记住：不要自己下判断，要跟面试官讨论！
- 实际做工程项目的时候，递归是一个不好的 coding pattern

## 二分法常见痛点

- 又死循环了！what are you 弄撒捏！
- 循环结束条件到底是哪个？

- start <= end
- start < end
- start + 1< end

- 指针变化到底是哪个？

- start = mid
- start = mid + 1
- start = mid - 1

## 第一境界 二分法模板

1. start + 1 < end
2. start + (end - start) / 2
3. A[mid] ==, <, >
4. A[start] A[end] ? target

## Template - Binary Search

The first position of target. Position starts from 0.

Binary Search <https://leetcode.cn/problems/binary-search/>

```java
// version 1: with jiuzhang template
class Solution {
    /**
     * @param nums: The integer array.
     * @param target: Target to find.
     * @return: The first position of target. Position starts from 0.
     */
    public int binarySearch(int[] nums, int target) {
        if (nums == null || nums.length == 0) {
            return -1;
        }

        int start = 0, end = nums.length - 1;
        while (start + 1 < end) {
            int mid = start + (end - start) / 2;
            if (nums[mid] == target) {
                end = mid;
            } else if (nums[mid] < target) {
                start = mid;
                // or start = mid + 1
            } else {
                end = mid;
                // or end = mid - 1
            }
        }

        if (nums[start] == target) {
            return start;
        }
        if (nums[end] == target) {
            return end;
        }
        return -1;
    }
}
```

```java
// version 2: without jiuzhang template
class Solution {
    /**
     * @param nums: The integer array.
     * @param target: Target to find.
     * @return: The first position of target. Position starts from 0.
     */
    public int binarySearch(int[] nums, int target) {
        if (nums == null || nums.length == 0) {
            return -1;
        }

        int start = 0, end = nums.length - 1;
        while (start < end) {
            int mid = start + (end - start) / 2;
            if (nums[mid] == target) {
                end = mid;
            } else if (nums[mid] < target) {
                start = mid + 1;
            } else {
                end = mid - 1;
            }
        }

        if (nums[start] == target) {
            return start;
        }

        return -1;
    }
}
```

## Last Position of Target

### Description

Find the last position of a target number in a sorted array. Return -1 if target does not exist.

**Example** Given [1, 2, 2, 4, 5, 5].
For target = 2, return 2.
For target = 5, return 5.
For target = 6, return -1.

### Solutions

```java
public class Solution {
    /*
     * @param nums: An integer array sorted in ascending order
     * @param target: An integer
     * @return: An integer
     */
    public int lastPosition(int[] nums, int target) {
        if (nums == null || nums.length == 0) {
            return -1;
        }
        int start = 0;
        int end = nums.length - 1;
        while (start + 1 < end) {
            int mid = start + (end - start) / 2;
            if (nums[mid] == target) {
                start = mid;
            } else if (nums[mid] < target) {
                start = mid;
                // or start = mid + 1;
            } else {
                end = mid;
                // or end = mid - 1;
            }

            if (nums[end] == target) {
                return end;
            }
            if (nums[start] == target) {
                return start;
            }
        } // end while loop

        return -1;
    } // end lastPosition

    public static void main(String[] args) {
        int[] nums = new int[] { 2, 2, 2, 2, 2, 2 };
        int target = 2;
        int ret = new Solution().lastPosition(nums, target);
        System.out.println(ret); // 5
    } // end main
} // end Solution
```

找 last 需要挪动 start，而找 first 的话就挪动 end。

`int mid = start + (end - start) / 2;` // 如果两个是特别大的数，会溢出，**这里就是装逼用的**，表明你考虑到了这一点。

## First Position of Target

### Description

For a given sorted array (ascending order) and a target number, find the first index of this number in O(longn) time complexity.

If the target number does not exist in the array, return -1;

**Example**

If the array is { 1, 2, 3, 3, 4, 5, 10}, for given target 3, return 2.

### Solutions

```java
public class Solution {
    /*
     * @param nums: An integer array sorted in ascending order
     * @param target: Target to find.
     * @return: The first position of target. Position starts from 0.
     */
    public int firstPosition(int[] nums, int target) {
        if (nums == null || nums.length == 0) {
            return -1;
        }
        int start = 0;
        int end = nums.length - 1;
        while (start + 1 < end) {
            int mid = start + (end - start) / 2;
            if (nums[mid] == target) {
                end = mid;
            } else if (nums[mid] < target) {
                start = mid;
            } else {
                end = mid;
            }

            if (nums[start] == target) {
                return start;
            }
            if (nums[end] == target) {
                return end;
            }
        } // end while loop

        return -1;
    } // end lastPosition

    public static void main(String[] args) {
        int[] nums = new int[] { 2, 2, 2, 2, 2, 2 };
        int target = 2;
        int ret = new Solution().firstPosition(nums, target);
        System.out.println(ret); // 0
    } // end main
} // end Solution
```

## 第二境界 二分位置 之 OOXX

一半会给你一个数组，让你找数组中第一个/最后一个满足某个条件的位置 OOOOOOO...OOXX...XXXXXXXXXX

**二分查找法主要是解决在“一堆数中找出指定的数”这类问题。**

**而想要应用二分查找法，这“一堆数”必须有一下特征：**

**存储在数组中**

**有序排列 （无序的话二分用来当猜答案的方法）**

**所以如果是用链表存储的，就无法在其上应用二分查找法了。**


 first postion of something



## First Bad Version

first version that is bad version.

Lintcode <https://www.lintcode.com/problem/74/

Leetcode <https://leetcode.cn/problems/first-bad-version/>

Solustion <https://www.jiuzhang.com/solutions/find-bad-version/>

First version that is bad version

### Description

You are a product manager and currently leading a team to develop a new product. Unfortunately, the latest version of your product fails the quality check. Since each version is developed based on the previous version, all the versions after a bad version are also bad.

Suppose you have n versions [1, 2, ..., n] and you want to find out the first bad one, which causes all the following ones to be bad.

You are given an API bool isBadVersion(version) which returns whether version is bad. Implement a function to find the first bad version. You should minimize the number of calls to the API.



**Example 1:**

Input: n = 5, bad = 4 

Output: 4 Explanation: call isBadVersion(3) -> false call isBadVersion(5) -> true call isBadVersion(4) -> true Then 4 is the first bad version. 

**Example 2:**

Input: n = 1, bad = 1 

Output: 1 



**Constraints:**

- 1 <= bad <= n <= 231 - 1

first postion of version

### Solutions

```java
public class Solution extends VersionControl {
    public int firstBadVersion(int n) {
        int left = 1, right = n;
        while (left <= right) {
            int mid = left + (right - left) / 2;
            if (!isBadVersion(mid)) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        } // end while loop

        return left; // mid 是最后一个 good, next left is bad
    } // end firstBadVersion v1

    public int firstBadVersion(int n) {
        int left = 1, right = n;
        while (left < right) {
            int mid = left + (right - left) / 2;
            if (!isBadVersion(mid)) {
                left = mid + 1;
            } else {
                right = mid;
            }
        } // end while loop

        return left; // or return right; left == right
    } // end firstBadVersion v2

    public int firstBadVersion(int n) {
        if (n == 1) {
            return isBadVersion(mid) ? 1 : -1;
        }
        int left = 1, right = n;
        while (left + 1 < right) {
            int mid = left + (right - left) / 2;
            if (!isBadVersion(mid)) {
                left = mid;
            } else {
                right = mid;
            }
        } // end while loop
        
        if (isBadVersion(left)) {
            return left;
        } 
        if (isBadVersion(right)) {
            return right;
        }
        
        return -1;
    } // end firstBadVersion v3
} // end Solution
/* The isBadVersion API is defined in the parent class VersionControl.
      boolean isBadVersion(int version); */

public class Solution extends VersionControl {
    public int firstBadVersion(int n) {
        // if (n == 1) {
        //     return n;
        // }
        int start = 1;
        int end = n;
        while (start + 1 < end) {
            int mid = start + (end - start) / 2;
            if (isBadVersion(mid)) {
                end = mid;
            } else {
                start = mid;
            }
        } // end while loop

        if (isBadVersion(start)) {
            return start;
        }
        if (isBadVersion(end)) {
            return end;
        }

        return -1;
    } // end firstBadVersion
} // end Solution
```

## Search in a Big Sorted Array



Tips 没有中点怎么办？先去找到可能的middle



Vector (ArrayList) 的实现方式：动态数组 Dynamic Array

刁难面试者的一个点：你用的什么数据结构，他就会问你，这个数据结构是怎么实现的？

倍增的思想，double 来实现的动态数组。

exponential backoff

Exponential backoff is **an algorithm that uses feedback to multiplicatively decrease the rate of some process, in order to gradually find an acceptable rate**. These algorithms find usage in a wide range of systems and processes, with radio networks and computer networks being particularly notable.



如果没有终点怎么办？就用这个办法来做。

## Find Minimum in Rotated Sorted Array

Lintcode <https://www.lintcode.com/problem/find-minimum-in-rotated-sorted-array/>

Leetcode <https://leetcode.com/problems/find-minimum-in-rotated-sorted-array/>

Solution <https://www.jiuzhang.com/solutions/find-minimum-in-rotated-sorted-array/>

***First*** position <= Last Number

(**WRONG:** First position <= or < First Number)

旋转数组？

## Related Questions

- Search in a 2D Matrix ii

- 不是二分法，但是常考题

- Binary Search

- tag/binary-search

- Rotate Array

- Recover Rotated Sorted Array
- Rotate String



打擂台算法来找（打擂台算法就是简单排序算法）

First position <= Last Number

## 第三境界 二分位置 之 Half half

并无法找到一个条件，形成 OOXX 的模型，但可以根据判断，保留下有解的那一半或者去掉无解的一半



## Maximum Number in Mountain Sequence

在先增后减的序列中找最大值





## Find Peak Element

follow up: Find Peak Element ii



## Find Minimum in Rotated Sorted Array ii



## !!! Search in Rotated Sorted Array

**会了这道题，才敢说自己会二分法。**

Lintcode <https://www.lintcode.com/problem/search-in-rotated-sorted-array/>

Leetcode <https://leetcode.com/problems/search-in-rotated-sorted-array>

Solution <https://www.jiuzhang.com/solutions/search-in-rotated-sorted-array/>

**You may assume no duplicate exists in the array. （特别重要）**



## 总结——我们今天学到了什么

- 使用递归与非递归的权衡方法

- 使用 T 函数的时间复杂度计算方式

- 二分法模板的四点要素

  - `start + 1 < end`

  - `start + (end - start) / 2`

  - `A[mid] ==, <, >`

  - `A[start] A[end] ? target`

- 三个境界

  - 二分法模板

  - OOXX

  - Half half