---
title: Permutations
date: 2024-03-26 08:16:00 +0800
author: Algorithms-Notes
categories: [Algorithms]
tags: [Medium, top-100-liked, Array, Backtracking]
pin: false
math: false
mermaid: false
---

LeetCode <https://leetcode.cn/problems/permutations/>

```java
class Solution {
    public List<List<Integer>> permute(int[] nums) {
        List<List<Integer>> results = new ArrayList<>();
        if (nums == null) {
            return results;
        }

        if (nums.length == 0) {
            results.add(new ArrayList<Integer>());
            return results;
        }

        List<Integer> list = new ArrayList<>();
        helper(nums, list, results);

        return results;
    }

    private void helper(int[] nums, 
                        List<Integer> permutation, 
                        List<List<Integer>> results) {
        if (permutation.size() == nums.length) {
            results.add(new ArrayList<Integer>(permutation));
            return;
        }

        for (int i = 0; i < nums.length; i++) {
            if (permutation.contains(nums[i])) {
                continue;
            }
            permutation.add(nums[i]);
            helper(nums, permutation, results);
            permutation.remove(permutation.size() - 1);
        }
    }
}
```