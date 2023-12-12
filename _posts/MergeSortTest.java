import java.util.Arrays;

public class MergeSortTest {
    public static void main(String[] args) {
        MergeSortTest tester = new MergeSortTest();
        tester.testMergeSort();
    }

    public void testMergeSort() {
        // 正常情况
        int[] input1 = {5, 3, 9, 1, 7};
        int[] expected1 = {1, 3, 5, 7, 9};
        testHelper(input1, expected1);

        // 空数组
        int[] input2 = {};
        int[] expected2 = {};
        testHelper(input2, expected2);

        // 已经排序的数组
        int[] input3 = {1, 2, 3, 4, 5};
        int[] expected3 = {1, 2, 3, 4, 5};
        testHelper(input3, expected3);

        // 重复元素
        int[] input4 = {4, 2, 7, 2, 1, 5, 4};
        int[] expected4 = {1, 2, 2, 4, 4, 5, 7};
        testHelper(input4, expected4);

        // 负数
        int[] input5 = {-5, -2, -8, -1, -7};
        int[] expected5 = {-8, -7, -5, -2, -1};
        testHelper(input5, expected5);
    }

    private void testHelper(int[] input, int[] expected) {
        int[] result = mergeSort(input);
        System.out.println(Arrays.equals(result, expected) ? "Pass" : "Fail");
    }

    // 将你的 mergeSort 方法添加到这里
    // Merge sort
public int[] mergeSort(int[] array) {
    return divide(array, 0, array.length - 1);
}

public int[] divide(int[] array, int left, int right) {
    if (left >= right) {
        return new int[] { array[left] };
    }
    int mid = left + (right - left) / 2;
    int[] leftResult = divide(array, left, mid);
    int[] rightResult = divide(array, mid + 1, right);
    
    return merge(leftResult, rightResult);
}

public int[] merge(int[] left, int[] right) {
    int[] res = new int[left.length + right.length];
    int i = 0, j = 0, k = 0;
    while (i < left.length && j < right.length) {
        if (left[i] <= right[j]) {
            res[k] = left[i++];
        } else {
            res[k] = right[j++];
        }
    }
    while (i < left.length) {
        res[k++] = left[i++];
    }
    while (j < right.length) {
        res[k++] = right[j++];
    }
    
    return res;
}
}
