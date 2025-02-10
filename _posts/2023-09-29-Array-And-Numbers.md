---
title: Lecture-7 Array & Numbers
date: 2023-09-29 23:58:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Array]
pin: false
math: true
mermaid: false
media_subpath: /assets/images/LinkedListImages/
---

## Outline

- Sorted Array
    - Merge Two Sorted Arrays / Merge k Sorted Arrays
    - **Median Of Two Sorted Arrays**

- **Subarray**
    - Best Time to Buy and Sell Stockes  I, II, III
    - Subarray  I, II, III, IV

- Two Pointers
    - Two sum, 3 Sum, 4 Sum, k Sum, 3 Sum Closest
    - **Partition Array**

## Merge Sorted Array

Lintcode <https://www.lintcode.com/en/problem/merge-sorted-array/>

Leetcode <https://leetcode.com/problems/merge-sorted-array/>

### Description

You are given two integer arrays nums1 and nums2, sorted in **non-decreasing order**, and two integers m and n, representing the number of elements in nums1 and nums2 respectively.

**Merge** nums1 and nums2 into a single array sorted in **non-decreasing order**.

The final sorted array should not be returned by the function, but instead be *stored inside the array* nums1. To accommodate this, nums1 has a length of m + n, where the first m elements denote the elements that should be merged, and the last n elements are set to 0 and should be ignored. nums2 has a length of n.



**Example 1:**

Input: nums1 = [1, 2, 3, 0, 0, 0], m = 3, nums2 = [2, 5, 6], n = 3 

Output: [1, 2, 2, 3, 5, 6] 

Explanation: The arrays we are merging are [1, 2, 3] and [2, 5, 6]. The result of the merge is [1, 2, 2, 3, 5, 6] with the underlined elements coming from nums1. 

**Example 2:**

Input: nums1 = [1], m = 1, nums2 = [], n = 0 

Output: [1] 

Explanation: The arrays we are merging are [1] and []. The result of the merge is [1]. 

**Example 3:**

Input: nums1 = [0], m = 0, nums2 = [1], n = 1 

Output: [1] 

Explanation: The arrays we are merging are [] and [1]. The result of the merge is [1]. Note that because m = 0, there are no elements in nums1. The 0 is only there to ensure the merge result can fit in nums1. 



**Constraints:**

- nums1.length == m + n
- nums2.length == n
- 0 <= m, n <= 200
- 1 <= m + n <= 200
- -109 <= nums1[i], nums2[j] <= 109



**Follow up:** Can you come up with an algorithm that runs in O(m + n) time?



### Solutions

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

### Description

Merge two given sorted ascending integer array A and B into a new sorted integer array.

**Examples:** 

**Input**: arr1[] = { 1, 3, 4, 5}, arr2[] = {2, 4, 6, 8}

**Output**: arr3[] = {1, 2, 3, 4, 4, 5, 6, 8}

**Input**: arr1[] = { 5, 8, 9}, arr2[] = {4, 7, 8}

**Output**: arr3[] = {4, 5, 7, 8, 8, 9}



### Solutions

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

## Median of Two Sorted Arrays

这道题是求两个排序数组的中位数。



Lintcode <https://www.lintcode.com/problem/median-of-two-sorted-arrays/>

Leetcode <https://leetcode.com/problems/median-of-two-sorted-arrays/>

Solution <https://www.jiuzhang.com/solutions/median-of-two-sorted-arrays/>

### Description

Given two sorted arrays nums1 and nums2 of size m and n respectively, return **the median** of the two sorted arrays.

The overall run time complexity should be O(log (m+n)).



**Example 1:**

Input: nums1 = [1,3], nums2 = [2] 

Output: 2.00000 

Explanation: merged array = [1,2,3] and median is 2. 

**Example 2:**

Input: nums1 = [1,2], nums2 = [3,4] 

Output: 2.50000 

Explanation: merged array = [1,2,3,4] and median is (2 + 3) / 2 = 2.5. 



**Constraints:**

- nums1.length == m
- nums2.length == n
- 0 <= m <= 1000
- 0 <= n <= 1000
- 1 <= m + n <= 2000
- -10^6 <= nums1[i], nums2[i] <= 10^6



### Solutions

还有一道题，就叫 [Median](https://www.lintcode.com/problem/median) 。一个数组的中位数，解法就是 Quick Select 他能找到的是一个无序数组的第K大的数，O(n)的时间完成这个。

- Quickselect Algorithm

![img](AN1.png)



![img](AN2.png)

这就是 Quick Select 的做法。

median = array.size()，findKth()，无非是size/2找出的是Median



快排的复杂度最坏情况是 O(n^2)

但是我们常说的复杂度是平摊复杂度或者均摊复杂度是O(nlogn)



回到这道题目 Median of two Sorted Arrays

我们变成了两个数组的第k大的数。

```java
int k = (A.length + B.length) / 2;
findKth(A, B, k);
// 如果是偶数呢？
return (findKth(A, B, 3) + findKth(A, B, 4)) / 2.0;
```

首先这是一道比较难的题目，拿到题想到的是先归并起来。

如果是 log() 级别的复杂度，需要用二分法来处理。

核心思路：是把 n 的问题，我们通过 O(1) 的判断变成了 n/2 的问题。

分治法。时间复杂度 log(n+m)

```java
public class Solution {
    public double findMedianSortedArrays(int A[], int B[]) {
        int n = A.length + B.length;
        
        if (n % 2 == 0) {
            return (
                findKth(A, 0, B, 0, n / 2) + 
                findKth(A, 0, B, 0, n / 2 + 1)
            ) / 2.0;
        }
        
        return findKth(A, 0, B, 0, n / 2 + 1);
    }

    // find kth number of two sorted array
    public static int findKth(int[] A, int startOfA,
                              int[] B, int startOfB,
                              int k){       
        if (startOfA >= A.length) {
            return B[startOfB + k - 1];
        }
        if (startOfB >= B.length) {
            return A[startOfA + k - 1];
        }

        if (k == 1) {
            return Math.min(A[startOfA], B[startOfB]);
        }
        
        int halfKthOfA = startOfA + k / 2 - 1 < A.length
            ? A[startOfA + k / 2 - 1]
            : Integer.MAX_VALUE;
        int halfKthOfB = startOfB + k / 2 - 1 < B.length
            ? B[startOfB + k / 2 - 1]
            : Integer.MAX_VALUE; 
        
        if (halfKthOfA < halfKthOfB) {
            return findKth(A, startOfA + k / 2, B, startOfB, k - k / 2);
        } else {
            return findKth(A, startOfA, B, startOfB + k / 2, k - k / 2);
        }
    }
}
```

二分答案的方法，时间复杂度 O(log(range)∗(log(n)+log(m)))

其中 range 为最小和最大的整数之间的范围。 可以拓展到 Median of K Sorted Arrays

```java
public class Solution {
    /*
     * @param A: An integer array
     * @param B: An integer array
     * @return: a double whose format is *.5 or *.0
     */
    public double findMedianSortedArrays(int[] A, int[] B) {
        int n = A.length + B.length;
        
        if (n % 2 == 0) {
            return (findKth(A, B, n / 2) + findKth(A, B, n / 2 + 1)) / 2.0;
        }
        
        return findKth(A, B, n / 2 + 1);
    }
    
    // k is not zero-based, it starts from 1
    public int findKth(int[] A, int[] B, int k) {
        if (A.length == 0) {
            return B[k - 1];
        }
        if (B.length == 0) {
            return A[k - 1];
        }
        
        int start = Math.min(A[0], B[0]);
        int end = Math.max(A[A.length - 1], B[B.length - 1]);
        
        // find first x that >= k numbers is smaller or equal to x
        while (start + 1 < end) {
            int mid = start + (end - start) / 2;
            if (countSmallerOrEqual(A, mid) + countSmallerOrEqual(B, mid) < k) {
                start = mid;
            } else {
                end = mid;
            }
        }
        
        if (countSmallerOrEqual(A, start) + countSmallerOrEqual(B, start) >= k) {
            return start;
        }
        
        return end;
    }
    
    private int countSmallerOrEqual(int[] arr, int number) {
        int start = 0, end = arr.length - 1;
        
        // find first index that arr[index] > number;
        while (start + 1 < end) {
            int mid = start + (end - start) / 2;
            if (arr[mid] <= number) {
                start = mid;
            } else {
                end = mid;
            }
        }
        
        if (arr[start] > number) {
            return start;
        }
        
        if (arr[end] > number) {
            return end;
        }
        
        return arr.length;
    }
}
```



## BT2B & SS vs MMS

https://www.lintcode.com/problem/best-time-to-buy-and-sell-stock/

https://www.lintcode.com/problem/best-time-to-buy-and-sell-stock-ii/

https://www.lintcode.com/problem/best-time-to-buy-and-sell-stock-iii/

## Best Time to Buy and Sell Stock

买卖股票的最佳时机

Leetcode <https://leetcode.com/problems/best-time-to-buy-and-sell-stock/>

Lintcode <https://www.lintcode.com/problem/best-time-to-buy-and-sell-stock/>

Solution <https://www.jiuzhang.com/solutions/best-time-to-buy-and-sell-stock/>

### Description

You are given an array prices where prices[i] is the price of a given stock on the ith day.

You want to maximize your profit by choosing a **single day** to buy one stock and choosing a **different day in the future** to sell that stock.

Return *the maximum profit you can achieve from this transaction*. If you cannot achieve any profit, return 0.



**Example 1:**

Input: prices = [7, 1, 5, 3, 6, 4] 

Output: 5 

Explanation: Buy on day 2 (price = 1) and sell on day 5 (price = 6), profit = 6-1 = 5. 

Note that buying on day 2 and selling on day 1 is not allowed because you must buy before you sell. 

**Example 2:**

Input: prices = [7, 6, 4, 3, 1] 

Output: 0 

Explanation: In this case, no transactions are done and the max profit = 0. 



**Constraints:**

- 1 <= prices.length <= 105
- 0 <= prices[i] <= 104



### Solutions

```java
public class Solution {
    public int maxProfit(int[] prices) {
        if (prices == null || prices.length == 0) {
            return 0;
        }

        int min = Integer.MAX_VALUE;  //just remember the smallest price
        int profit = 0;
        for (int i : prices) {
            min = i < min ? i : min;
            profit = (i - min) > profit ? i - min : profit;
        }

        return profit;
    } // end maxProfit
} // end Solution
```

## Maximum Subarray

Lintcode <https://www.lintcode.com/problem/maximum-subarray/>

Leetcode <https://leetcode.cn/problems/maximum-subarray/>

https://www.lintcode.com/problem/maximum-subarray-ii/

https://www.lintcode.com/problem/maximum-subarray-iii/

### Description

Given an integer array nums, find the subarray with the largest sum, and return *its sum*.



**Example 1:**

Input: nums = [-2,1,-3,4,-1,2,1,-5,4] 

Output: 6 Explanation: The subarray [4,-1,2,1] has the largest sum 6. 

**Example 2:**

Input: nums = [1] 

Output: 1 

Explanation: The subarray [1] has the largest sum 1. 

**Example 3:**

Input: nums = [5,4,-1,7,8] 

Output: 23 

Explanation: The subarray [5,4,-1,7,8] has the largest sum 23. 



**Constraints:**

- 1 <= nums.length <= 105
- -104 <= nums[i] <= 104



**Follow up:** If you have figured out the O(n) solution, try coding another solution using the **divide and conquer** approach, which is more subtle.



### Solutions

f[i] 表示以第 i 个点结束的subarray，最大是多少

f[i] = prefixSum(i) - min{ prefixSum(0 .. i-1) }

max{ f[0..n-1] }

i~j

sum[j] - sum[i-1]

必须记住这个！！





Maximum Subarray ii

Maximum Subarray iii  这道比较难，用了动态规划，划分型的



## Subarray

Minimum Subarray https://www.lintcode.com/problem/minimum-subarray/

Maximum Subarray Difference https://www.lintcode.com/problem/maximum-subarray-difference/

Subarray Sum https://www.lintcode.com/problem/subarray-sum/

Subarray Sum Closest https://www.lintcode.com/problem/subarray-sum-closest/





## Two Sum

Lintcode https://www.lintcode.com/problem/two-sum/

Leetcode https://leetcode.com/problems/two-sum/

Solution https://www.jiuzhang.com/solutions/two-sum/



for number in numbers

check (target - number) in numbers

### Description

Given an array of integers nums and an integer target, return *indices of the two numbers such that they add up to* *target*.

You may assume that each input would have ***exactly*** **one solution**, and you may not use the *same* element twice.

You can return the answer in any order.



**Example 1:**

Input: nums = [2,7,11,15], target = 9 Output: [0,1] Explanation: Because nums[0] + nums[1] == 9, we return [0, 1]. 

**Example 2:**

Input: nums = [3,2,4], target = 6 Output: [1,2] 

**Example 3:**

Input: nums = [3,3], target = 6 Output: [0,1] 



**Constraints:**

- 2 <= nums.length <= 104
- -109 <= nums[i] <= 109
- -109 <= target <= 109
- **Only one valid answer exists.**



**Follow-up:** Can you come up with an algorithm that is less than O(n2) time complexity?

### Solutions

```java
public class Solution {
    /*
     * @param numbers : An array of Integer
     * @param target : target = numbers[index1] + numbers[index2]
     * @return : [index1 + 1, index2 + 1] (index1 < index2)
         numbers=[2, 7, 11, 15],  target=9
         return [1, 2]
     */
    public int[] twoSum(int[] numbers, int target) {
        //用一个hashmap来记录，key记录target-numbers[i]的值，value记录numbers[i]的i的值，如果碰到一个
        //numbers[j]在hashmap中存在，那么说明前面的某个numbers[i]和numbers[j]的和为target，i和j即为答案
        HashMap<Integer,Integer> map = new HashMap<>();

        for (int i = 0; i < numbers.length; i++) {
            if (map.get(numbers[i]) != null) {
                int[] result = {map.get(numbers[i]), i};
                return result;
            }
            map.put(target - numbers[i], i);
        } // end for i
        
        int[] result = {};
        return result;
    } // end twoSum
} // end Solution
```

使用双指针算法。 时间复杂度 O(nlogn) 额外空间复杂度 O(n)

```java
public class Solution {
    class Pair implements Comparable<Pair> {
        int number, index;
        
        public Pair(int number, int index) {
            this.number = number;
            this.index = index;
        }
        
        public int compareTo(Pair other) {
            return number - other.number;
        }
    } // end Comparable
    /**
     * @param numbers: An array of Integer
     * @param target: target = numbers[index1] + numbers[index2]
     * @return: [index1, index2] (index1 < index2)
     */
    public int[] twoSum(int[] numbers, int target) {
        int[] result = {-1, -1};
        
        if (numbers == null) {
            return result;
        }
        
        Pair[] pairs = getSortedPairs(numbers);
        
        int left = 0, right = pairs.length - 1;
        while (left < right) {
            if (pairs[left].number + pairs[right].number < target) {
                left++;
            } else if (pairs[left].number + pairs[right].number > target) {
                right--;
            } else {
                result[0] = Math.min(pairs[left].index, pairs[right].index);
                result[1] = Math.max(pairs[left].index, pairs[right].index);
                return result;
            }
        } // end while loop
        
        return result;
    } // end twoSum
    
    private Pair[] getSortedPairs(int[] numbers) {
        Pair[] pairs = new Pair[numbers.length];
        for (int i = 0; i < numbers.length; i++) {
            pairs[i] = new Pair(numbers[i], i);
        }
        Arrays.sort(pairs);

        return pairs;
    } // end getSortedPairs
} // end Solution
```

## 3Sum

Lintcode https://www.lintcode.com/problem/3sum/

Solution https://www.jiuzhang.com/solutions/3sum/

想办法把它变成 2 Sum 。

去除重复方案。



## 3Sum Closest

Lintcode https://www.lintcode.com/problem/3sum-closest/

Solution https://www.jiuzhang.com/solutions/3sum-closest/



## 4Sum

Lintcode https://www.lintcode.com/problem/4sum/

Solution https://www.jiuzhang.com/solutions/4sum/





## K Sum (Optional)

Lintcode https://www.lintcode.com/problem/k-sum/

Solution https://www.jiuzhang.com/solutions/k-sum/

##  Partition Array  

Lintcode https://www.lintcode.com/problem/partition-array/

Solution https://www.jiuzhang.com/solutions/partition-array/

## Sort Letters by Case

Lintcode https://www.lintcode.com/problem/sort-letters-by-case/

Solution https://www.jiuzhang.com/solutions/sort-letters-by-case/

## Sort Colors

Lintcode https://www.lintcode.com/en/problem/sort-colors/

Solution https://www.jiuzhang.com/solutions/sort-colors/





考一些很有趣的排序

1. Rainbow Sort  k 种数 O(kn) time + O(1) space
2. Counting Sort O(n) time O(k) space





以下是 Related Questions  

## Sort Colors II  

Lintcode https://www.lintcode.com/en/problem/sort-colors-ii/

Solution https://www.jiuzhang.com/solutions/sort-colors-ii/

## Interleaving Positive and Negative Numbers  

Lintcode https://www.lintcode.com/problem/interleaving-positive-and-negative-numbers/

Solution https://www.jiuzhang.com/solutions/interleaving-positive-and-negative-integers/