## 1. 统计不同号码的个数

**题目描述**：已知某个文件内包含大量的电话号码，每个号码的数字为 8 位，怎么统计不同号码的个数？

**思路分析**：采用位图法，8 位的电话号码可以表示的范围为 00000000 ~ 99999999，共 1 亿个数字。使用 bit 表示一个号码，需要 1 亿个 bit，约 10 MB 内存。

**具体实现**：

- 使用 int 数组实现位图（Java 中 int 占 4 字节）。
- 通过电话号码 P 获取位图中对应位置：
  - 数组下标：`P / 32`
  - bit 位置：`P % 32`
  - 将 1 左移 `P % 32` 位，与数组中值做或运算，设置对应位为 1。
- 最后统计位图中 bit 值为 1 的数量，即为不同电话号码的个数。

```java
public class FindDuplicatesIn32000 {
    public void checkDuplicates(int[] array) {
        BitSet bs = new BitSet(32000);
        for (int i = 0; i < array.length; i++) {
            int num = array[i];
            int num0 = num - 1;
            if (bs.get(num0)) {
                System.out.println(num);
            } else {
                bs.set(num0);
            }
        }
    }

    class BitSet {
        int[] bitset;

        public BitSet(int size) {
            this.bitset = new int[size >> 5];
        }

        boolean get(int pos) {
            int wordNumber = (pos >> 5); // 除以 32
            int bitNumber = (pos & 0x1F); // 除以 32
            return (bitset[wordNumber] & (1 << bitNumber)) != 0;
        }

        void set(int pos) {
            int wordNumber = (pos >> 5); // 除以 32
            int bitNumber = (pos & 0x1F); // 除以 32
            bitset[wordNumber] |= 1 << bitNumber;
        }
    }
}
```

## 2. 出现频率最高的 100 个词

**题目描述**：有一个 1G 大小的文件，文件里每一行是一个词，每个词的大小不超过 16 bytes，要求返回出现频率最高的 100 个词。内存限制是 10M。

**解法 1**：

1. 遍历文件，对每个词 `x` 执行 `hash(x) % 500`，将结果为 `i` 的词存放到文件 `f(i)` 中，得到 500 个小文件。
2. 统计每个小文件中出现频率最高的 100 个词，使用 HashMap 实现（key 为词，value 为频率）。
3. 维护一个小顶堆，遍历所有小文件，找到出现频率最高的 100 个词。

```java
BufferedReader br = new BufferedReader(new FileReader(fin));
String line = null;
while ((line = br.readLine()) != null) {
    if (map.containsKey(line)) {
        map.put(line, map.get(line) + 1);
    } else {
        map.put(line, 1);
    }
}
br.close();
```

**解法 2**：

1. 使用多路归并排序对大文件排序，使相同单词紧挨着。
2. 初始化一个 100 个节点的小顶堆，遍历整个文件，统计单词频率，更新堆。

## 3. 5 亿个数的大文件怎么排序

**题目描述**：一个文件大小为 4663M，其中一共有 5 亿个数字，文件中的数据随机，一行一个整数，如何对这个大文件排序？

**内部排序**：

- 快速排序或归并排序，但数据量大，递归深，可能栈溢出，数组长度长，可能 OOM。

**归并排序实现**：

```java
private final int cutoff = 8;
public <T> void perform(Comparable<T>[] a) {
    perform(a, 0, a.length - 1);
}

private <T> void perform(Comparable<T>[] a, int low, int high) {
    int n = high - low + 1;
    if (n <= cutoff) {
        InsertionSort insertionSort = SortFactory.createInsertionSort();
        insertionSort.perform(a, low, high);
    } else if (n <= 100) {
        int m = median3(a, low, low + (n >>> 1), high);
        exchange(a, m, low);
    } else {
        int gap = n >>> 3;
        int m = low + (n >>> 1);
        int m1 = median3(a, low, low + gap, low + (gap << 1));
        int m2 = median3(a, m - gap, m, m + gap);
        int m3 = median3(a, high - (gap << 1), high - gap, high);
        int ninther = median3(a, m1, m2, m3);
        exchange(a, ninther, low);
    }
    if (high <= low) return;
    int lt = low;
    int gt = high;
    Comparable<T> pivot = a[low];
    int i = low + 1;
    while (i <= gt) {
        if (lessThan(a[i], pivot)) {
            exchange(a, lt++, i++);
        } else if (lessThan(pivot, a[i])) {
            exchange(a, i, gt--);
        } else {
            i++;
        }
    }
    perform(a, low, lt - 1);
    perform(a, gt + 1, high);
}
```

## 4. 查找两个大文件共同的 URL：分治加统计

**题目要求**：给定 a、b 两个文件，各存放 50 亿个 URL，每个 URL 占 64B，找出 a、b 两个文件共同的 URL。内存限制是 4G。

**分析**：

1. 分治策略，将文件中的 URL 按哈希取余划分为多个小文件，使每个小文件大小不超过 4G。
2. 遍历对应小文件，使用 HashSet 统计共同 URL。

## 5. 海量数据寻找中位数：分治法

**题目要求**：给定 100 亿个无符号的乱序整数序列，求出这 100 亿个数的中位数，内存只有 512M。

**分析**：

1. 使用分治法，按二进制位划分文件，逐步缩小范围。
2. 例如，先按最高位划分，再按次高位划分，直到可直接加载进内存，快速排序后找出中位数。

## 6. 如何查询最热门的查询串：前缀树法

**题目描述**：搜索引擎记录用户每次检索的查询串，有 1000w 个记录，重复度高，统计最热门的 10 个查询串，内存不超过 1G。

**方法 1：分治法**：

1. 划分为多个小文件，求每个文件中出现次数最多的 10 个字符串，最后通过小顶堆统计。

**方法 2：HashMap 法**：

1. 将所有字符串及出现次数保存在 HashMap 中，遍历构建小顶堆。

**方法 3：前缀树法**：

1. 使用前缀树统计字符串出现次数，最后用小顶堆排序。

## 7. 如何找出排名前 500 的数：堆排序

**题目描述**：有 1w 个数组，每个数组有 500 个元素，且有序排列。找出这 10000 * 500 个数中前 500 的数。

**方法 1：归并排序**：

1. 依次归并数组，直到找出前 500 个数。

**方法 2：堆排序**：

1. 建立大顶堆，大小为数组个数（10000），每个数组最大值存入堆中。
2. 删除堆顶元素，保存到结果数组中，插入删除元素所在数组的下一个元素。
3. 重复直到删除第 500 个元素。

```java
import lombok.Data;
import java.util.Arrays;
import java.util.PriorityQueue;

@Data
public class DataWithSource implements Comparable<DataWithSource> {
    private int value;
    private int source;
    private int index;

    public DataWithSource(int value, int source, int index) {
        this.value = value;
        this.source = source;
        this.index = index;
    }

    @Override
    public int compareTo(DataWithSource o) {
        return Integer.compare(o.getValue(), this.value);
    }
}

class Test {
    public static int[] getTop(int[][] data) {
        int rowSize = data.length;
        int columnSize = data[0].length;

        int[] result = new int[columnSize];
        PriorityQueue<DataWithSource> maxHeap = new PriorityQueue<>();
        for (int i = 0; i < rowSize; ++i) {
            DataWithSource d = new DataWithSource(data[i][0], i, 0);
            maxHeap.add(d);
        }

        int num = 0;
        while (num < columnSize) {
            DataWithSource d = maxHeap.poll();
            result[num++] = d.getValue();
            if (num >= columnSize) {
                break;
            }
            d.setValue(data[d.getSource()][d.getIndex() + 1]);
            d.setIndex(d.getIndex() + 1);
            maxHeap.add(d);
        }
        return result;
    }

    public static void main(String[] args) {
        int[][] data = {
            {29, 17, 14, 2, 1},
            {19, 17, 16, 15, 6},
            {30, 25, 20, 14, 5},
        };
        int[] top = getTop(data);
        System.out.println(Arrays.toString(top)); // [30, 29, 25, 20, 19]
    }
}
```

## 8. 如何按照查询频率排序：分治法 / 哈希

**题目描述**：有 10 个文件，每个文件大小为 1G，每个文件的每一行存放的都是用户的 query，要求按照 query 的频度排序。

**方法 1：HashMap 法**：

1. 如果 query 重复率高，可直接加载到内存中的 HashMap 中，统计出现次数后排序。

**方法 2：分治法**：

1. 遍历文件，通过 `hash(query) % 10` 将 query 划分到 10 个小文件中。
2. 对每个小文件使用 HashMap 统计 query 出现次数，排序后写入单独文件。
3. 使用归并排序对所有文件按 query 次数排序。

## 9. 用 4 KB 的内存寻找重复元素

**题目描述**：给定一个数组，包含从 1 到 N 的整数，N 最大为 32000，数组可能还有重复值，且 N 的取值不定，只有 4KB 的内存可用，如何打印数组中所有重复元素。

**解决方案**：

1. 使用位向量（BitSet）存储数据，创建 32000 个 bit 的位向量。
2. 遍历数组，如果发现数组元素是 v，则将位置为 v 的设置为 1，碰到重复元素则输出。

```java
public class FindDuplicatesIn32000 {
    public void checkDuplicates(int[] array) {
        BitSet bs = new BitSet(32000);
        for (int i = 0; i < array.length; i++) {
            int num = array[i];
            int num0 = num - 1;
            if (bs.get(num0)) {
                System.out.println(num);
            } else {
                bs.set(num0);
            }
        }
    }

    class BitSet {
        int[] bitset;

        public BitSet(int size) {
            this.bitset = new int[size >> 5];
        }

        boolean get(int pos) {
            int wordNumber = (pos >> 5); // 除以 32
            int bitNumber = (pos & 0x1F); // 除以 32
            return (bitset[wordNumber] & (1 << bitNumber)) != 0;
        }

        void set(int pos) {
            int wordNumber = (pos >> 5); // 除以 32
            int bitNumber = (pos & 0x1F); // 除以 32
            bitset[wordNumber] |= 1 << bitNumber;
        }
    }
}
```

## 10. 从 40 亿中产生一个不存在的整数

**题目描述**：给定一个输入文件，包含 40 亿个非负整数，请设计一个算法，产生一个不存在该文件中的整数，假设你有 1 GB 的内存来完成这项任务，如何实现？如果只有 10 MB 的内存呢？

**位图法**：

1. 使用长度为 4294967295 的 bit 类型数组 bitArr，每个位置表示一个整数是否出现。
2. 遍历 40 亿个数，将对应的 bitArr 位置设置为 1。
3. 遍历完成后，查找 bitArr 中值为 0 的位置，对应的数即为未出现的数。

**分块法 + 位图法（10 MB 内存）**：

1. 将 0~4294967295 分成 64 个区间，每个区间包含约 67108864 个数。
2. 使用长度为 64 的整型数组 countArr 统计每个区间上的数的个数。
3. 找到计数小于 67108864 的区间，对该区间内的数进行位图映射，找到未出现的数。

## 11. 使用 2 GB 内存在 20 亿个整数中找出出现次数最多的数

**题目要求**：有一个包含 20 亿个全是 32 位整数的大文件，限制内存为 2 GB，在其中找到出现次数最多的数。

**方法**：

1. 使用哈希表统计每个数的出现次数，但直接统计可能内存不足。
2. 将大文件通过哈希函数分成 16 个小文件，每个小文件中不同数不超过 2 亿种。
3. 对每个小文件使用哈希表统计出现次数，找出每个小文件中出现次数最多的数。
4. 比较 16 个小文件的第 1 名，选出出现次数最多的数。

## 12. 从 100 亿个 URL 中查找的问题

**题目要求**：有一个包含 100 亿个 URL 的大文件，假设每个 URL 占用 64B，请找出其中所有重复的 URL。

**解决方法**：

1. **直接哈希**：使用哈希表统计每个 URL 的出现次数，找出重复的 URL。
2. **分而治之**：将大文件通过哈希函数分配到多台机器或拆分成多个小文件，分别处理后再合并结果。

## 13. 求出每天热门 100 词

**题目要求**：某搜索公司一天的用户搜索词汇是海量的（百亿数据量），请设计一种求出每天热门 Top 100 词汇的可行办法。

**解题方法：分流 + 哈希**：

1. 将数据分流到不同机器上，每台机器处理一部分数据。
2. 对每台机器的数据，使用哈希表统计词频，构建大小为 100 的小根堆，选出每台机器的 Top 100。
3. 将各台机器的 Top 100 进行外排序或继续使用小根堆，最终求出整体的 Top 100。

## 14. 40 亿个非负整数中找到出现两次的数

**题目要求**：32 位无符号整数的范围是 0～4294967295，现在有 40 亿个无符号整数，使用最多 1GB 的内存，找出所有出现了两次的数。

**解题方法**：

1. 使用长度为 4294967295 * 2 的 bit 类型数组 bitArr，用 2 个位置表示一个数的出现次数。
2. 遍历 40 亿个数，根据出现次数更新 bitArr 的对应位置。
3. 遍历完成后，查找 bitArr 中值为 10 的位置，对应的数即为出现两次的数。

## 15. 对 20 GB 文件进行排序

**题目要求**：假设你有一个 20GB 的文件，每行一个字符串，请说明如何对这个文件进行排序。

**解决方法：外部排序**：

1. 将文件划分为多个块，每块大小为可用内存大小（如 1GB）。
2. 对每个块进行排序。
3. 使用两两归并或堆排序策略逐步合并所有块，最终得到排序后的文件。

## 16. 超大文本中搜索两个单词的最短距离

**题目要求**：有个超大文本文件，内部是很多单词组成的，现在给定两个单词，请找出这两个单词在这个文件中的最短距离。

**解题方法**：

1. 遍历数组，记录每个单词出现的位置。
2. 使用双指针遍历两个单词的位置列表，计算最短距离。
3. 如果需要多次查询，可以维护一个哈希表记录每个单词的下标列表，查询时直接使用双指针遍历。

## 17. 从 10 亿个数字中寻找最小的 100 万个数字

**题目要求**：设计一个算法，给定 10 亿个数字，从中找出最小的 100 万个数字，假设计算机内存足够容纳全部 10 亿个数字。

**方法 1：先排序所有元素**：

1. 时间复杂度 O(nlogn)，效率较低。

**方法 2：选择排序**：

1. 时间复杂度 O(nm)，效率极低。

**方法 3：大顶堆**：

1. 维护一个大小为 100 万的大顶堆，遍历所有数字，更新堆，最后堆中的数字即为最小的 100 万个数字。

## 18. 大数据 Top K 问题常用套路

**题目来源**：百度二面

**方法**：

1. **堆排序法**：维护一个大小为 K 的小顶堆，遍历数据，更新堆，最后堆中的元素即为 Top K。
2. **类似快排法**：改进快速排序，仅对部分数据递归计算，理论最优时间复杂度 O(n)，平均时间复杂度 O(nlogn)。
3. **使用 Bitmap**：将数据存入 Bitmap，降低空间复杂度，适用于不重复且有范围的数据。
4. **使用 Hash**：对字符串类型数据，通过哈希函数进行查询，适合需要多次查询的情况。
5. **字典树**：适合反复多次查询字符序列的情况，减少空间复杂度，加速查询效率。
6. **混合查询**：
   - **分流 + 快排**：先对每台机器上的数据进行快排，找出每台机器的 Top K，再合并。
   - **分流 + 堆排**：先对每台机器上的数据进行堆排，找出每台机器的 Top K，再合并。