---
title: Best Time to Buy and Sell Stock
date: 2024-03-27 07:51:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Easy, top-100-liked, Array, Dynamic Programming]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/best-time-to-buy-and-sell-stock/>

```java
class Solution {
    public int maxProfit(int[] prices) {
        if (prices == null || prices.length < 2) {
            return 0;
        }

        int min = prices[0];
        // max profit
        int max = 0;

        for (int i = 0; i < prices.length; ++i) {
            if (prices[i] < min) {
                min = prices[i];
            }
            // current profit
            int curr = prices[i] - min;
            if (curr > max) {
                max = curr;
            }
        }

        return max;
    }
}
```

**Complexity**

* Time = O(n) 
* Space = O(1) 

---

股票的买入价格和卖出价格两个数字组成一个数对，那么利润就是这个数对的差值。

最大利润就是数组中所有数对的最大差值。