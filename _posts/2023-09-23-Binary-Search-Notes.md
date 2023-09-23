---
title: Lecture-2 Binary Search
date: 2023-09-22 22:16:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Binary Search]
pin: false
math: true
mermaid: false
---

## Outline

1. Binary Search Template
2. When & How?
3. Binary Search in Rotated Sorted Array

拿到一个数据首先要 sorted 要排好序，两个指针

start/low 和 end/high 分别指向数组的开头和结尾

每次做一件事情，取二者之间的中点middle，找一个target，找得到就返回下标，找不到就返回-1，每次和middle来比较。

如果target小于middle，那么右边的部分去掉，移动end/high指针到middle-1，然后再取middle来比较，这个操作是O(1)

最好的情况是第一次middle就找到了，就是O(1)

最坏的情况则O(logn)

## Binary Search

Given an sorted integer array - nums, and an integer - target.

Find the **any/first/last** position of target in nums

Return **-1** if target doesn't exist.

What's the difference?

[https://leetcode.cn/problems/binary-search](https://leetcode.cn/problems/binary-search)

[https://leetcode.cn/problems/find-first-and-last-position-of-element-in-sorted-array](https://leetcode.cn/problems/find-first-and-last-position-of-element-in-sorted-array/description/)

## Time Complexity

T(n) = T(n/2) + O(1) = O(longn)

通过O(1)的时间，把规模为n的问题变为n/2

思考：通过O(n)的时间，把规模为n的问题变为n/2？

> 基本上只有二分法可以达到O(logn)
{: .prompt-tip }

## Recursion or While-loop?

Recursion? While-loop? Both OK?

直接问面试官，你要我写什么方法？？

什么不能问/少问，我可不可以运行我的代码呀（你运行就运行呗，为什么要问呀。。。。）

如果我只想到了while-loop，就问下面试官我能不能用while-loop呀？

Recursion cost too much function stack 工程开发中尽量避免recursion，必须尽量避免。

搜索类的问题需要用recursion，如果面试官不特意要求就不要用非递归的方法来写。

如果递归和非递归都很简单，那就非递归的方法。

## 二分法程序实现中的常见的问题

- 又死循环了！what are you 弄撒捏！
- 循环结束条件到底是哪个？
   - start <= end
   - start < end
   - start + 1< end
- 指针变化到底是哪个？
   - start = mid
   - start = mid + 1
   - start = mid - 1

## 通用的二分法模板

**四点要素：**

1. **start + 1 < end**
2. **start + (end - start) / 2**
3. **A[mid] ==, <, >**
4. **A[start] A[end] ? target**

参考程序 from [https://www.jiuzhang.com/solutions/binary-search](https://www.jiuzhang.com/solutions/binary-search/)

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

start + 1 < end 就可以退出条件，永远不会死循环。

start + 1 < end 的意思是相邻就退出，好处就是永远不会死循环。如果中间不隔着数的时候就会退出。

```java
while (start + 1 < end) {
    int mid = start + (end - start ) / 2;
    
} // end while loop
```

再找last position of target的时候很容易出现死循环。

给定的数组是升序的。

为什么模板里面不写成start = mid + 1; 或者 end = mid -1这样子？

**先闭着眼睛写出来这个模板。**

## When & How

### When?

- 你需要优化一个O(n)的暴力算法到更快的算法
- Sorted Array or Ratated Sorted Array

### How?

- 找到满足某个条件的**第一个**或者是**最后一个**位置

两种问题 1 二分法 2 倍增法（基本上遇到的只有一种题目用倍增法）

## 独孤九剑 之 破剑式

比 O(n) 更优的时间复杂度，几乎只能是 O(logn) 的二分法

## Sqrt(x)

Last number that number^2 <= x

Solution [https://www.jiuzhang.com/solutions/sqrtx](https://www.jiuzhang.com/solutions/sqrtx)

Leetcode [https://leetcode.cn/problems/sqrtx](https://leetcode.cn/problems/sqrtx)

### Description

Implement int sqrt(int x).

Compute and return the square root of _x_.

lintcode [http://www.lintcode.com/problem/sqrtx](http://www.lintcode.com/problem/sqrtx/)

leetcode [https://leetcode.cn/problems/sqrtx](https://leetcode.cn/problems/sqrtx/)

### Solutions

from [https://www.jiuzhang.com/solutions/sqrtx](https://www.jiuzhang.com/solutions/sqrtx)

```java
class Solution {
    /**
     * @param x: An integer
     * @return: The sqrt of x
     */
    public int sqrt(int x) {
        // find the last number which square of it <= x
        long start = 1, end = x;
        while (start + 1 < end) {
            long mid = start + (end - start) / 2;
            if (mid * mid <= x) {
                start = mid;
            } else {
                end = mid;
            }
        } // while

        if (end * end <= x) {
            return (int)end;
        }

        return (int)start;
    }
}
```


### Follow Up

What if return a double, not integer?

double sqrt(int x)

这个就不适合这个二分法模板了，因为这个double是实数

```java
public double sqrt(int x) {
	// start 和 end 之间的距离 > 10^(-6)
	while (() > 1e-6) {
        double middle = (start + end) / 2;
        // do something...
    }
}
```

```java
public double sqrt(int x) {
    double start = 0;
    double end = x;
    
    while (end - start > 1e-6) {
        double middle = start + (end - start) / 2;
        double square = middle * middle;
        
        if (square < x) {
            start = middle;
        } else {
            end = middle;
        }
    }
    
    return start + (end - start) / 2;
}

```

有一道题 search for a range

## Search a 2D  Matrix

Lintcode [http://www.lintcode.com/problem/search-a-2d-matrix/](http://www.lintcode.com/problem/search-a-2d-matrix/)

Leetcode [https://leetcode.cn/problems/search-a-2d-matrix](https://leetcode.cn/problems/search-a-2d-matrix)

Solusiton [http://www.jiuzhang.com/solutions/search-a-2d-matrix/](http://www.jiuzhang.com/solutions/search-a-2d-matrix/)

**_Last_ **row that matrix[row][0] <= target

### Description

Write an efficient algorithm that searches for a target value in an _m_ x _n_ matrix.

This matrix has the following properties:

- Integers in each row are sorted from left to right.
- The first integer of each row is greater than the last integer of the previous row.

时间复杂度：log(m+n) 即log(m) + log(n)

search a 2D Matrix 2

把二维矩阵当成一维矩阵来处理 `int number = matrix[mid / column][mid % column];`

### Solutions

Write an efficient algorithm that searches for a value in an m x n matrix. This matrix has the following properties:

Integers in each row are sorted from left to right. The first integer of each row is greater than the last integer of the previous row. For example,

Consider the following matrix:

[ 1, 3, 5, 7, 10, 11, 16, 20, 23, 30, 34, 50 ] Given target = 3, return true.

可以看作是一个有序数组被分成了n段，每段就是一行。因此依然可以二分求解。 对每个数字，根据其下标i，j进行编号，每个数字可被编号为0～n*n-1

相当于是在一个数组中的下标。然后直接像在数组中二分一样来做。取的mid要还原成二位数组中的下标，i = mid/n, j = mid%n

```java
// Binary Search Twice
public class Solution {
    public boolean searchMatrix(int[][] matrix, int target) {
        if (matrix == null || matrix.length == 0) {
            return false;
        }
        if (matrix[0] == null || matrix[0].length == 0) {
            return false;
        }
        
        int row = matrix.length;
        int column = matrix[0].length;
        
        // find the row index, the last number <= target 
        int start = 0, end = row - 1;
        while (start + 1 < end) {
            int mid = start + (end - start) / 2;
            if (matrix[mid][0] == target) {
                return true;
            } else if (matrix[mid][0] < target) {
                start = mid;
            } else {
                end = mid;
            }
        }
        if (matrix[end][0] <= target) {
            row = end;
        } else if (matrix[start][0] <= target) {
            row = start;
        } else {
            return false;
        }
        
        // find the column index, the number equal to target
        start = 0;
        end = column - 1;
        while (start + 1 < end) {
            int mid = start + (end - start) / 2;
            if (matrix[row][mid] == target) {
                return true;
            } else if (matrix[row][mid] < target) {
                start = mid;
            } else {
                end = mid;
            }
        }
        if (matrix[row][start] == target) {
            return true;
        } else if (matrix[row][end] == target) {
            return true;
        }
        return false;
    }
}
```

```java
// Binary Search Once
public class Solution {
    /**
     * @param matrix, a list of lists of integers
     * @param target, an integer
     * @return a boolean, indicate whether matrix contains target
     */
    public boolean searchMatrix(int[][] matrix, int target) {
        // write your code here
        if(matrix == null || matrix.length == 0){
            return false;
        }
        
        if(matrix[0] == null || matrix[0].length == 0){
            return false;
        }
        
        int row = matrix.length;
        int column = matrix[0].length;
        
        int start = 0, end = row * column - 1;
        while(start <= end){
            int mid = start + (end - start) / 2;
            int number = matrix[mid / column][mid % column];
            if(number == target){
                return true;
            }else if(number > target){
                end = mid - 1;
            }else{
                start = mid + 1;
            }
        }
        
        return false;
        
    }
}
```

```java
public class Solution {
    /**
     * @param matrix, a list of lists of integers
     * @param target, an integer
     * @return a boolean, indicate whether matrix contains target
     */
    public boolean searchMatrix(int[][] matrix, int target) {
        if (matrix == null || matrix.length == 0) {
            return false;
        }
        if (matrix[0] == null || matrix[0].length == 0) {
            return false;
        }
        
        int n = matrix.length, m = matrix[0].length;
        int start = 0, end = n * m - 1;
        while (start + 1 < end){
            int mid = start + (end - start) / 2;
            if (get(matrix, mid) < target) {
                start = mid;
            } else {
                end = mid;
            }
        }
        
        if (get(matrix, start) == target) {
            return true;
        }
        if (get(matrix, end) == target) {
            return true;
        }
        return false;
    }
    
    private int get(int[][] matrix, int index) {
        int x = index / matrix[0].length;
        int y = index % matrix[0].length;
        return matrix[x][y];
    }
}
```

last row that matrix[row][0] <= target

### Follow up

O(log(n) + log(m)) time

## Search Insert Position

Lintcode [http://www.lintcode.com/problem/search-insert-position/](http://www.lintcode.com/problem/search-insert-position/)

Leetcode [https://leetcode.cn/problems/search-insert-position/](https://leetcode.cn/problems/search-insert-position/)

Solution [http://www.jiuzhang.com/solutions/search-insert-position/](http://www.jiuzhang.com/solutions/search-insert-position/)

- **_First_** posistion >= target 
- (**_Last_** postion < target) + 1

### Related Questions

1. Count of Smaller Number
   1. Lintcode [http://www.lintcode.com/problem/count-of-smaller-number/](http://www.lintcode.com/problem/count-of-smaller-number/)
   2. Leetcode [https://leetcode.cn/problems/count-of-smaller-numbers-after-self](https://leetcode.cn/problems/count-of-smaller-numbers-after-self)
2. Search for a Range / Number of Target
   1. Lintcode [http://www.lintcode.com/problem/search-for-a-range/](http://www.lintcode.com/problem/search-for-a-range/)
   2. Leetcode [https://leetcode.cn/problems/find-first-and-last-position-of-element-in-sorted-array](https://leetcode.cn/problems/find-first-and-last-position-of-element-in-sorted-array)
3. Search in a Big/Infinite Sorted Array
   1. Lintcode [http://www.lintcode.com/problem/search-in-a-big-sorted-array/](http://www.lintcode.com/problem/search-in-a-big-sorted-array/)
   2. Leetcode 

找某一段就是找到第一个出现的和最后一个出现的

还有唯一一个使用倍增算法的一道题。

---

不是那么明显的二分法的题目

## First Bad Version

Lintcode [https://www.lintcode.com/problem/74/](https://www.lintcode.com/problem/74/)

Leetcode [https://leetcode.cn/problems/first-bad-version/](https://leetcode.cn/problems/first-bad-version/)

Solustion [https://www.jiuzhang.com/solutions/find-bad-version/](https://www.jiuzhang.com/solutions/find-bad-version/)

First version that is bad version

first postion of version

## Find Minimum in Rotated Sorted Array

Lintcode [http://www.lintcode.com/problem/find-minimum-in-rotated-sorted-array/](http://www.lintcode.com/problem/find-minimum-in-rotated-sorted-array/)

Leetcode [https://leetcode.com/problems/find-minimum-in-rotated-sorted-array/](https://leetcode.com/problems/find-minimum-in-rotated-sorted-array/)

Solution [http://www.jiuzhang.com/solutions/find-minimum-in-rotated-sorted-array/](http://www.jiuzhang.com/solutions/find-minimum-in-rotated-sorted-array/)

**_First _**position <= Last Number

(**WRONG:** First position <= or < First Number)

旋转数组？

- [x] 找一下力扣的一样的题目。

## Keep the part that must have target in it

99% 的二分法题目是 Find the first/last position

下面的题目是另外的一种类型

## Search in Rotated Sorted Array

Lintcode [http://www.lintcode.com/problem/search-in-rotated-sorted-array/](http://www.lintcode.com/problem/search-in-rotated-sorted-array/)

Leetcode [https://leetcode.com/problems/search-in-rotated-sorted-array](https://leetcode.com/problems/search-in-rotated-sorted-array)

Solution [http://www.jiuzhang.com/solutions/search-in-rotated-sorted-array/](http://www.jiuzhang.com/solutions/search-in-rotated-sorted-array/)

**You may assume no duplicate exists in the array. （特别重要）**

还有一种思维上更简单的解法

用Find Minimum in Rotated Sorted Array这道题的来解决。

**两种方法都要掌握**

**遇到的面试题目需要你排序的话，可以用系统的排序函数ArrayList.sort()！！！**

```java
import java.util.ArrayList;
import java.util.Collections;

public class ArrayListSortExample {
    public static void main(String[] args) {
        // 创建一个 ArrayList
        ArrayList<Integer> numbers = new ArrayList<Integer>();
        numbers.add(5);
        numbers.add(2);
        numbers.add(8);
        numbers.add(1);
        numbers.add(3);

        // 使用 Collections.sort() 方法对 ArrayList 进行排序
        Collections.sort(numbers);

        // 打印排序后的 ArrayList
        for (Integer number : numbers) {
            System.out.print(number + " ");
        }
    }
}
```

**一定要会用。**

## Find Peak Element

Lintcode [http://www.lintcode.com/problem/find-peak-element/](http://www.lintcode.com/problem/find-peak-element/)

Leetcode [https://leetcode.com/problems/find-peak-element](https://leetcode.com/problems/find-peak-element)

Solution [http://www.jiuzhang.com/solutions/find-peak-element/](http://www.jiuzhang.com/solutions/find-peak-element/)

### Description

There is an integer array which has the following features:

- The numbers in adjacent positions are different.
- A[0] < A[1] && A[A.length - 2] > A[A.length - 1].

We define a position P is a peek if:

### Follow Up

Find Peak Element ii

### Related Questions

1. Recover Rotated Sorted Array
   1. Lintcode [http://www.lintcode.com/problem/recover-rotated-sorted-array/](http://www.lintcode.com/problem/recover-rotated-sorted-array/)
   2.  Solutions [http://www.jiuzhang.com/solutions/recover-rotated-sorted-array/](http://www.jiuzhang.com/solutions/recover-rotated-sorted-array/)
2. Rotate String
   1. Lintcode [http://www.lintcode.com/problem/rotate-string/](http://www.lintcode.com/problem/rotate-string/)
   2. Solutions [http://www.jiuzhang.com/solutions/rotate-string/](http://www.jiuzhang.com/solutions/rotate-string/)

## Conclusion

**Top-down 刨析了二分法的整个结构**

1. 怎么写二分法的程序，一个起点 start，一个终点 end，还有一个在中间的值 middle，然后判断往左走还是往右走，四点要素：
   1. start + 1 < end 怎么避免死循环
   2. start + (end - start) / 2 怎么避免越界
   3. A[mid] ==, <, > 怎么去割掉一半
   4. A[start] A[end] > target 最后只剩下两个数了，怎么if一下判断一个我要的target
2. 二分法的题目是要找到 first/last postion of something 90%的二分法的题目
3. 我要保留有答案的一半，一个不那么明显的二分法的题目则是要找到的答案是再另一半区间里面（**深层次的思想**）
4. 比 O(n) 更优的时间复杂度，几乎只能是 O(logn) 的二分法

**理解二分法的三个层次**

1. 头尾指针，取中点，判断往哪走
2. 分析出问题是需要寻找第一个满足某个条件的位置还是最后一个满足某个条件的位置
3. 保留剩下来一定有解的那一半

## Homework

### Required

60 Search Insert Position

28 Search a 2D Matrix

14 First Position of Target

447 Search in a Big Sorted Array

159 Find Minimum in Rotated Sorted Array

75 Find Peak Element

74 First Bad Version

62 Search in Rotated Sorted Array

61 Search for a Range

### Optional

462 Total Occurrence of Target

459 Closest Number in Sorted Array

458 Last Position of Target

457 Classical Binary Search

460 K Closest Numbers In Sorted Array

183 Wood Cut

160 Find Minimum in Rotated Sorted Array ii

63 Search in Rotated Sorted Array ii

38 Search a 2D Matrix ii