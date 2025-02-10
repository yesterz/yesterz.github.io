---
title: "Redis 数据结构与对象"
categories: [Cache]
tags: [Cache]
toc: true
mermaid: true
media_subpath: /assets/images/2023-06-30-Redis-Data-Structure-And-Objects
---

Redis 数据库里面的每个键值对（key-value pair）都是由对象（object）组成的，其中:
1. 数据库键总是一个字符串对象（string object）;
2. 而数据库键的值则可以是字符串对象、列表对象（list object）、哈希对象（hash object）、集合对象（set object）、有序集合对象（sorted set object）这五种对象中的其中一种。

## 简单动态字符串 SDS

 简单动态字符串 sinple dynamic string, SDS

字符串字面量：string literal

Redis 只会使用 C 字符串作为字面量，在大多数情况下，Redis 使用 SDS（Simple Dynamic String，简单动态字符串）作为字符串表示。

### SDS 的定义

```c
struct sdsdr {

    // 记录 buf 数组中已使用的字节的数量
    // 等于 SDS 所保存字符串的长度
    int len;

    // 记录 buf 数组中未使用字节的数量
    int free;

    // 字节数组，用于保存字符串
    char buf[];

}
```

### O(1) 获取字符串长度

因为 C 字符串并不记录自身的长度信息，所以为了获取一个 C 字符串的长度，程序必须遍历整个字符串，对遇到的每个字符进行计数，直到遇到代表字符串结尾的空字符为止，这个操作的复杂度为 O(N)。

和 C 字符串不同，因为 SDS 在 len 属性中记录了 SDS 本身的长度，所以获取一个 SDS 长度的复杂度仅为 O(1)。

设置和更新 SDS 长度的工作是由 SDS 的 API 在执行时自动完成的，使用 SDS 无须进行任何手动修改长度的工作。

### 杜绝缓冲区溢出

与 C 字符串不同，SDS 的空间分配策略完全杜绝了发生缓冲区溢出的可能性:

当 SDS API 需要对 SDS 进行修改时，API 会先检査 SDS 的空间是否满足修改所需的要求，如果不满足的话，API 会自动将 SDS 的空间扩展至执行修改所需的大小，然后才执行实际的修改操作，所以使用 SDS 既不需要手动修改 SDS 的空间大小，也不会出现前面所说的缓冲区出问题。

### SDS 内存分配策略

为了避免 C 字符串的这种缺陷，SDS 通过未使用空间（free 变量）解除了字符串长度和底层数组长度之间的关联:

在 SDS 中，buf 数组的长度不一定就是字符数量加一，数组里面可以包含未使用的字节，而这些字节的数量就由 SDS 的 free 属性记录。通过未使用空间，SDS 实现了空间预分配和惰性空间释放两种优化策略。

<font color='red' style='font-weight:bold'>1. 空间预分配 -> 用于优化 SDS 的字符串增长操作:</font>

当 SDS 的 API 对一个 SDS 进行修改，并且需要对 SDS 进行空间扩展的时候，程序不仅会为 SDS 分配修改所必须要的空间，还会为 SDS 分配额外的未使用空间。

如果对 SDS 进行修改之后，SDS 的长度（也即是 len 属性的值）将小于 1MB，那么程序分配和 1en 属性同样大小的未使用空间，这时 SDS len 属性的值将和 free 属性的值相同。

如果对 SDS 进行修改之后，SDS 的长度将大于等于 1MB，那么程序会分配 1MB 的未使用空间。

通过空间预分配策略，Redis 可以减少连续执行字符串增长操作所需的内存重分配次数。在扩展 SDS 空间之前，SDS API 会先检查未使用空间是否足够，如果足够的话，API 就会直接使用未使用空间，而无须执行内存重分配。**通过这种预分配策略，SDS 将连续增长 N 次字符串所需的内存重分配次数从必定 N 次降低为最多 N 次。**

<font color='red' style='font-weight:bold'>2. 惰性空间释放 -> 用于优化 SDS 的字符串缩短操作：</font>

当 SDS 的 API 需要缩短 SDS 保存的字符串时，程序并不立即使用内存重分配来回收缩短后多出来的字节，而是使用 free 属性将这些字节的数量记录起来，并等待将来使用。

### binary-safe 二进制安全

binary-safe

所有 SDS API 都会以处理二进制的方式来处理 SDS 存放在 buf 数组里的数据程序不会对其中的数据做任何限制、过滤、或者假设，数据在写人时是什么样的，它被读取时就是什么样。

这也是我们将 SDS 的 buf 属性称为字节数组的原因--Redis 不是用这个数组来保存字符，而是用它来保存一系列二进制数据。

### 兼容部分 C 字符串函数

虽然 SDS 的 API 都是二进制安全的，但它们一样遵循 C 字符串以空字符结尾的惯例：

SDS 遵循 C 字符串以空字符结尾的惯例，保存空字符的 1 字节空间不计算在 SDS 的 len 属性里面，并且为空字符分配额外的 1 字节空间，以及添加空字符到字符串末尾等操作，都是由 SDS 函数自动完成的，所以这个空字符对于 SDS 的使用者来说是完全透明的。遵循空字符结尾这一惯例的好处是，SDS 可以直接重用一部分C字符串函数库里面的函数。

这些 API 总会将 SDS 保存的数据的末尾设置为空字符，并且总会在为 buf 数组分配空间时多分配一个字节来容纳这个空字符，这是为了让那些保存文本数据的 SDS 可以重用一部分<string.h>库定义的函数。

### SDS 与 C 字符串的区别

1. 常数复杂度 O(1) 获取字符串长度，SDS 属性就有 len 字符串长度属性。
2. 杜绝缓冲区溢出的问题
3. 减少修改字符串长度时所需的内存重新分配的次数
   1. 空间预分配策略：连续增长 N 次字符串所需要的内存分配次数必定 N 次**降低为最多 N 次**
   2. 惰性空间释放策略：用于优化 SDS 的字符串缩短操作，把多出来的字节用 free 属性记录起来，等待将来使用
4. 二进制安全（binary-safe）可以保存文本或者二进制数据
5. 兼容部分 C 字符串函数

| C字符串                                     | SDS                                       |
|-----------------------------------------|-----------------------------------------|
| 获取字符串长度的复杂度为 O(N)            | 获取字符串长度的复杂度为 O(1)            |
| API是不安全的，可能会造成缓冲区溢出      | API是安全的，不会造成缓冲区溢出          |
| 修改字符串长度 N 次必然需要执行 N 次内存重分配 | 修改字符串长度 N 次最多需要执行 N 次内存重分配 |
| 只能保存文本数据                         | 可以保存文本或者二进制数据                |
| 可以使用所有<string.h>库中的函数         | 可以使用一部分<string.h>库中的函数         |

---

## 链表 list

链表在 Redis 中的应用非常广泛，比如列表键的底层实现之一就是链表。当一个列表键包含了数量比较多的元素，又或者列表中包含的元素都是比较长的字符串时，Redis 就会使用链表作为列表键的底层实现。

除了链表键之外，发布与订阅、慢查询、监视器等功能也用到了链表，Redis 服务器本身还使用链表来保存多个客户端的状态信息，以及使用链表来构建客户端输出缓冲区 output buffer )，本书后续的章节将陆续对这些链表应用进行介绍。

### list & listNode

```c
typedef struct listNode {

    // 前置节点
    struct listNode *prev;

    // 后置节点
    struct listNode *next;

    // 节点的值
    void *value;

} listNode;
```

多个 listNode 可以通过 prev 和 next 指针组成双端链表。

![由多个 listNode 组成的双端链表](listNodes.png)
_由多个 listNode 组成的双端链表_

```c
typedef struct list {

    // 表头节点
    listNode *head;

    // 表尾节点
    listNode *tail;

    // 链表所包含的节点数量
    unsigned long len;

    // 节点值复制函数
    void *(*dup)(void *ptr);

    // 节点值释放函数
    void (*free)(void *ptr);

    // 节点值对比函数
    int (*match)(void *ptr, void *key);

} list;
```

list 结构为链表提供了表头指针 head、表尾指针 tail，以及链表长度计数器 len，而 dup、free 和 match 成员则是用于实现多态链表所需的类型特定函数:
- dup 函数用于复制链表节点所保存的值；
- free 函数用于释放链表节点所保存的值；
- match 函数则用于对比链表节点所保存的值和另一个输入值是否相等。

`list` 结构和 `listNode` 结构组成的链表示意图如下

![由 list 结构和 listNode 结构组成的链表](List.png)
_由 list 结构和 listNode 结构组成的链表_

### 链表实现的特性

总结如下：

- **双端：**链表节点带 `prev` 和 `next` 指针，获取某个节点的前置节点和后置节点的复杂度都是 O(1)。
- **无环：**表头节点的 `prev` 指针和表尾节点的 `next` 指针都指向 `NULL`，对链表的访问以 `NULL` 为终点。
- **带表头指针和表尾指针：**通过 `list` 结构的 head 指针和 tail 指针，程序获取链表的表头节点和表尾节点的复杂度为 O(1)。
- **带链表长度计数器：**程序使用 list 结构的 len 属性来对 list 持有的链表节点进行行计数，程序获取链表中节点数量的复杂度为 O(1)。
- **多态：**链表节点使用 void* 指针来保存节点值，并且可以通过 list 结构的 dup、free、match 三个属性为节点值设置类型特定函数，所以链表可以用于保存各种不同类型的值。

---

## 字典 dictionary

字典，又称为符号表（symbol table）、关联数组（associative array）或映射（map），是一种用于保存键值对（key-value pair）的抽象数据结构。

在字典中，一个键（key）可以和一个值（value）进行关联（或者说将键映射为值），这些关联的键和值就称为键值对。Redis 的数据库底层就是用字典来实现的。

字典中的每个键都是独一无二的，程序可以在字典中根据键查找与之关联的值，或者通过键来更新值，又或者根据键来删除整个键值对，等等。

1. 字典被广泛用于实现 Redis的各种功能，其中包括数据库和哈希键。
2. Redis 中的字典使用哈希表作为底层实现，每个字典带有两个哈希表，一个平时使用，另一个仅在进行 rehash 时使用。
3. 当字典被用作数据库的底层实现，或者哈希键的底层实现时，Redis 使用 MurmurHash2 算法来计算键的哈希值。
4. 哈希表使用链地址法来解决键冲突，被分配到同一个索引上的多个键值对会连接成 1 个单向链表。
5. 在对哈希表进行扩展或者收缩操作时，程序需要将现有哈希表包含的所有键值对 rehash 到新哈希表里面，并且这个 rehash 过程并不是一次性地完成的，而是渐进式地完成的。

**参考资料：**
1. Associative Array <https://en.wikipedia.org/wiki/Associative_array>
2. Hash Table <https://en.wikipedia.org/wiki/Hash_table>

### 字典的实现

<font color='red' style='font-weight:bold'>Redis 的字典使用哈希表作为底层实现，一个哈希表里面可以有多个哈希表节点，而每个哈希表节点就保存了字典中的一个键值对。</font>

#### 哈希表 dictht

```c
typedef struct dictht {

    // 哈希表数组
    dictEntry **table;

    // 哈希表大小
    unsigned long size;

    // 哈希表大小掩码，用于计算索引值
    // 总是等于 size-1
    unsigned long sizemask;

    // 该哈希表已有节点的数量
    unsigned long used;

} dictht;
```

table 属性是一个数组，数组中的每一个元素都是一个指向 dictEntry 结构的指针，每个 dictEntry 结构保存着一个键值对。size 属性记录了哈希表的大小，也即是 table 数组的大小，而 used 属性则记录了哈希表目前已有节点（键值对）的数量。sizemask 属性的值总是等于 size-1，这个属性和哈希值一起决定一个键应该被放到 table 数组的哪个索引上面。

#### 哈希表节点 dictEntry

哈希表节点使用 dictEntry 结构表示，每个 dictEntry 结构都保存着一个键值对:

```c
typedef struct dictEntry {

    // 键
    void *key;

    // 值
    union{
        void *val;
        uint64_t u64;
        int64_t s64;
    } v;

    // 指向下个哈希表节点，形成链表
    struct dictEntry *next;  /* Next entry in the same hash bucket. */

} dictEntry;
```

key 属性保存着键值对中的键，而 v 属性则保存着键值对中的值，其中键值对的值可以是一个指针，或者是一个uint64_t 整数，又或者是一个 int64_t 整数。

`next`属性是指向另一个哈希表节点的指针，这个指针可以将多个哈希值相同的键值对连接在一起，来解决键冲突（collision）的问题。

#### 字典 dict

```c
typedef struct dict {

    // 类型特定函数
    dictType *type;

    // 私有数据
    void *privdata;

    // 哈希表
    dictht ht[2];

    // rehash 索引
    // 当 rehash 不在进行时，值为 -1
    int rehashidx; /* rehashing not in progress'if rehashidx == -1*/

}
```

type 属性和 privdata 属性是针对不同类型的键值对，为创建多态字典而设置的：
- type 属性是一个指向 dictrype 结构的指针，每个 dictType 结构保存了一簇用于操作特定类型键值对的函数，Redis 会为用途不同的字典设置不同的类型特定函数。
- 而 privdata 属性则保存了需要传给那些类型特定函数的可选参数。

```c
typedef struct dictType {
    
    // 计算哈希值的函数
    uint64_t (*hashFunction)(const void *key);

    // 复制键的函数
    void *(*keyDup)(dict *d, const void *key);

    // 复制值的函数
    void *(*valDup)(dict *d, const void *obj);

    // 对比键的函数
    int (*keyCompare)(dict *d, const void *key1, const void *key2);

    // 销毁键的函数
    void (*keyDestructor)(dict *d, void *key);

    // 销毁值的函数
    void (*valDestructor)(dict *d, void *obj);
} dictType;
```

ht 属性是一个包含两个项的数组，数组中的每个项都是一个 dictht 哈希表，一般情况下，字典只使用 ht[0] 哈希表，ht[1] 哈希表只会在对 ht[0] 哈希表进行 rehash 时使用。

除了 ht[1] 之外，另一个和 rehash 有关的属性就是 rehashidx，它记录了 rehash 目前的进度，如果目前没有在进行 rehash，那么它的值为 -1。

<font color='red' style='font-weight:bold'>Redis 的字典使用哈希表作为底层实现，一个哈希表里面可以有多个哈希表节点，而每个哈希表节点就保存了字典中的一个键值对。</font>

**dict, dictht 和 dictEntry 结构示意图如下**

![普通状态下的字典](normal_dict.png)
_一个普通状态下（没有进行 rehash）的字典_

### 哈希算法

当要将一个新的键值对添加到字典里面时，程序需要

   1. 先根据键值对的键计算出哈希值和索引值
   2. 然后再根据索引值，将包含新键值对的哈希表节点放到哈希表数据的指定索引上面。

   ```c
   // 使用字典设置的哈希函数，计算键 key 的哈希值
   hash = dict->type->hashFunction(key);

   // 使用哈希表的 sizemask 属性和哈希值，计算出索引值
   // 根据情况不同，ht[x] 可以是 ht[0] 或者 ht[1]
   index = hash & dict->ht[x].sizemask;
   ```

当字典被用作数据库的底层实现，或者哈希键的底层实现时，Redis 使用 [MurmurHash2 算法](https://code.google.com/p/smhasher)来计算键的哈希值

### 解决键冲突

当两个或两个以上数量的键被分配到了哈希表数组的同一个索引上面时，我们称键发生了冲突（collision）。

**使用链地址法（separate chaining）来解决**

每个哈希表节点都有一个 next 指针，多个哈希表节点可以用 next 指针构成一个单向链表，被分配到同一个索引上的多个节点可以用这个单向链表连接起来，就解决了键冲突的问题。

### 重新散列 rehash

随着操作的不断执行，哈希表保存的键值对会逐渐地增多或者减少，让哈希表的负载因子（load factor）维持在一个合理的范围之内，当哈希表保存的键值对数量太多或者太少时，程序需要对哈希表的大小进行相应的扩展或者收缩。通过执行`rehash`（重新散列）操作来完成扩展或收缩。

Redis 对字典的哈希表执行 rehash 的步骤如下：

1. 为字典的 ht[1] 哈希表分配空间，这个哈希表的空间大小取决于要执行的操作，以及 ht[0] 当前包含的键值对数量（也就是 ht[0].used 属性的值）：
   1. 如果执行的是扩展操作，那么 ht[1] 的大小作为第一个大于等于 ht[0].used*2 的 2^n（2 的 n 次方幂）；
   2. 如果执行的是收缩操作，那么 ht[1] 的大小为第一个大于等于 ht[0].used 的 2^n。
2. 将保存在 ht[0] 中的所有键值对 rehash 到 ht[1] 上面：rehash 指的是重新计算键的哈希值和索引值，然后将键值对放置到 ht[1] 哈希表的指定位置上。
3. 当 ht[0] 包含的所有键值对都迁移到了 ht[1] 之后（ht[0] 变为空表），释放 ht[0]，将 ht[1] 设置为 ht[0]，并在 ht[1] 新创建一个空白哈希表，为下一次 rehash 做准备。

**当哈希表的负载因子小于0.1时，程序自动开始对哈希表执行收缩操作。**

**而当以下条件中的任意一个被满足时，程序会自动开始对哈希表执行扩展操作：**

1. 服务器目前没有在执行 bgsave 命令或者 bgrewriteaof 命令，并且哈希表的负载因子大于等于 1
2. 服务器目前正在执行 bgsave 命令或者 bgrewriteaof 命令，并且哈希表的负载因子大于等于 5；

其中哈希表的负载因子这么算出来： 

```c
// 负载因子 = 哈希表已保存节点数量 / 哈希表大小
load_factor = ht[0].used / ht[0].size;
```

根据 BGSAVE 命令或 BGREWRITEAOF 命令是否正在执行，服务器执行扩展操作所需的负载因子并不相同，这是因为在执行 BGSAVE 命令或 BGREWRITEAOF 命令的过程中，Redis 需要创建当前服务器进程的子进程，而大多数操作系统都采用写时复制（copy-on-write）技术来优化子进程的使用效率，所以在子进程存在期间，服务器会提高执行扩展操作所需的负载因子，从而尽可能地避免在子进程存在期间进行哈希表扩展操作，这可以避免不必要的内存写人操作，最大限度地节约内存。

### 渐进式重新散列 rehash

rehash 动作并不是一次性、集中式地完成的，而是分多次、渐进式地完成的。

**原因：键值对存储数量过于庞大（上千万亿个键值对），如果一次性 rehash 到 ht[1] 的话，庞大的计算量会导致服务器在一段时间内停止服务。**

**哈希表渐进式 rehash 的详细步骤：**

1. 为 ht[1] 分配空间，让字典同时持有 ht[0] 和 ht[1] 两个哈希表。
2. 在字典中维持一个索引计数器变量 rehashidx，并将它的值设置为0，表示 rehash 工作正式开始。
3. 在 rehash 进行期间，每次对字典执行添加、删除、查找或者更新操作时，程序除了执行指定的操作以外，还会顺带将 ht[0] 哈希表在 rehashidx 索引上的所有键值对 rehash 到 ht[1] （分而治之），当 rehash 工作完成之后，程序将 rehashidx 属性值加一。
4. 随着字典操作的不断进行，最终在某个时间点上，ht[0] 的所有键值对 rehash 到 ht[1] ，这时程序将 rehashidx 属性设置为 -1，表示 rehash 操作已完成。

因为在进行渐进式 rehash 的过程中，字典会同时使用 ht[0] 和 ht[1] 两个哈希表，所以在渐进式 rehash 进行期间，字典的删除(delete)、查找(find)、更新(update)等操作会在两个哈希表上进行。例如，要在字典里面查找一个键的话，程序会先在 ht[0] 里面进行查找，如果没找到的话，就会继续到 ht[1] 里面进行查找，诸如此类。

另外，在渐进式 rebash 执行期间，新添加到字典的键值对一律会被保存到 ht[1] 里面而 ht[0] 则不再进行任何添加操作，这一措施保证了 ht[0] 包含的键值对数量会只减不增，并随着 rehash 操作的执行而最终变成空表。

---

## 跳跃表 skiplist

一种有序数据结构，它通过**在每个节点维持多个指向其他节点的指针**，从而能够快速访问节点。

跳跃表支持平均 O(logN)、最坏 O(N) 复杂度的节点查找，还可以通过顺序性操作来批量处理节点。在大部分情况下，跳跃表的效率可以和平衡树相美，并且因为跳跃表的实现比平衡树要来得更为简单，所以有不少程序都使用跳跃表来代替平衡树。

Redis 使用跳跃表作为有序集合键的底层实现之一，如果一个有序集合包含的元素数量比较多，又或者有序集合中的元素成员（member）是比较长的字符串时，Redis 就会使用跳跃表来作为有序集合键的底层实现。

Redis 只在两个地方用到了跳跃表，一个是实现有序集合键，另一个是在集群节点中用作内部数据结构，除此之外，跳表在 Redis 里面没有其他用途。

**参考资料：**

1. Skip list <https://en.wikipedia.org/wiki/Skip_list>
2. 一篇论文：Skip lists: A probabilistic alternative to balanced trees

**跳跃表的实现**

由 zskiplistNode 表示跳跃表节点，zskiplist 结构用于保存跳跃表节点的相关信息。

#### 跳跃表节点 zskiplistNode

```c
typedef struct zskiplistNode {

    // 层
    struct zskiplistLevel {

        // 前进指针
        struct zskiplistNode *forward;

        // 跨度
        unsigned int span;

    } level[];

    // 后退指针
    struct zskiplistNode *backward;

    // 分值
    double score;

    // 成员对象
    robj *obj;

} zskiplistNode;
```

1. level

   1. level 数组中包含多个元素，每个元素都包含一个指向其他节点的指针，程序可以通过这些层来加快访问其他节点的速度。一般来说，层的数量越多，访问其他节点的速度就越快。
   2. 每次创建一个新跳跃表节点的时候，程序都根据幂次定律（power law，越大的数出现的概率越小）随机生成一个介于 1 和 32 之间的值作为 level 数组的大小，这个大小就是层的“高度”。

2. forward

   每个层都有一个指向表尾方向的前进指针（1evel[i].forward属性），用于从表头向表尾方向访问节点。遇到 NULL，就知道到达了跳跃表的表尾。

3. backward

   节点的后退指针（backward 属性）用于从表尾向表头方向访问节点：跟可以一次跳过多个节点的前进指针不同，因为每个节点只有一个后退指针，所以每次只能后退至前一个节点。

4. span

   层的跨度（level[i].span）用于记录两个节点之间的距离：

   1. 两个节点之间的跨度越大，相距得越远。
   2. 指向 NULL 的所有前进指针的跨度都为 0，因为它们没有连向任何节点。

   跨度实际上是用来计算排位（rank）的：在查找某个节点的过程中，将沿途访问过的所有层的跨度累计起来，得到的结果就是目标节点在跳跃表中的排位。
   
5. score & obj

   1. 节点的分值（score 属性）是一个 double 类型的浮点数，跳跃表中的所有节点都按照分值从小到大来排序
   2. 节点的成员对象（obj 属性）是一个指针，它指向一个字符串对象，而字符串对象保存着一个 SDS 值。
   3. 在同一个跳跃表中，各个节点保存的成员对象必须是唯一的，但是多个节点保存的分值却可以是相同的：分值相同的节点将按照成员对象在字典序中的大小来进行排序，成员对象较小的节点会排在前面（靠近表头的方向），而成员对象较大的节点则会排在后面（靠近表尾的方向）。

#### 跳跃表 zskiplist

仅靠多个跳跃表节点就可以组成一个跳跃表。但通过使用一个 zskiplist 结构来持有这些节点，程序可以更方便地对整个跳跃表进行处理，比如快速访问跳跃表的表头节点和表尾节点，或者快速地获取跳跃表节点的数量（也即是跳跃表的长度）等信息。

```c
typedef struct zskiplist {

    // 表头节点和表尾节点
    strcut zskiplistNode *header, *tail;

    // 表中节点的数量
    unsigned long length;

    // 表中层数最大的节点的层数
    int level;

} zskiplist;
```

- header 和 tail 指针分别指向跳跃表的表头和表尾节点，通过这两个指针，程序定位表头节点和表尾节点的复杂度为 O(1)。
- 通过使用 length 属性来记录节点的数量，程序可以在 O(1) 复杂度内返回跳跃表的长度。
- level 属性则用于在 O(1) 复杂度内获取跳跃表中层高最大的那个节点的层数量，注意表头节点的层高并不计算在内。

![带有 zskiplist 结构的跳跃表](skiplist.png)
_带有 zskiplist 结构的跳跃表_

---

## 整数集合 intset

整数集合（intset）是集合键的底层实现之一，当一个集合只包含整数值元素，并且这个集合的元素数量不多时，Redis 就会使用整数集合作为集合键的底层实现。

### 整数集合的实现

```c
typedef struct intset {

    // 编码方式
    uint32_t encoding;

    // 集合包含的元素数量
    uint32_t length;

    // 保存元素的数组
    int8_t contents[];

} intset;
```

1. contents

    数组是整数集合的底层实现：整数集合的每个元素都是 contents 数组的 1 个数组项（item），各个项在数组中按值的大小从小到大有序地排列，并且数组中不包含任何重复项。

2. length

    length 属性记录了整数集合包含的元素数量，也即是 contents 数组的长度。

3. encoding

    虽然 intset 结构将 contents 属性声明为 int8_t 类型的数组，但实际上 contents 数组并不保存任何 int8_t 类型的值，contents 数组的真正类型取决于 encoding 属性的值：encoding:INTSET_ENC_INT16 -> contents 就是 int16_t 类型的数组，INTSET_ENC_INT32 -> int32_t，INTSET_ENC_INT64 -> int64_t

### 升级 upgrade

把一个新元素添加到整数集合里面，并且新元素的类型比整数集合现有所有的元素的类型都要长时，就需要先升级才能添加。

**三步走：**

1. 根据新元素的类型，扩展整数集合底层数组的空间大小，并为新空间分配空间。
2. 将底层数组现有的所在元素都转换成于新元素相同的类型，并将类型转换后的元素放置到正确的位上，而且在放置元素的过程中，需要继续维持底层数组的有序性质不变。
3. 将新元素添加到底层数组里面。

**升级的好处：**提高灵活性 & 节约内存

### 降级

<font color='red' style='font-weight:bold'>不支持</font>

---

## 压缩列表 ziplist

压缩列表（ziplist）是列表键和哈希键的底层实现之一。当一个列表键只包含少量列表项，并且每个列表项要么就是小整数值，要么就是长度比较短的字符串，那么 Redis 就会使用压缩列表来做列表键的底层实现。

另外，当一个哈希键只包含少量键值对，比且每个键值对的键和值要么就是小整数值，要么就是长度比较短的字符串，那么 Redis 就会使用压缩列表来做哈希键的底层实现。



### 压缩列表的构成

`zlbytes`、`zltail`、`zllen`、`entry1`、...、`entryN`、`zlend`

ziplist 是为了节约内存而开发的，是由一系列特殊编码的连续内存块组成的顺序型（sequential）数据结构。一个压缩列表可以包含任意多个节点（entry）、每个节点可以保存一个字节数组或者一个整数值。

| 属性    | 类型          | 长度   | 用途                                                                                     |
|---------|---------------|--------|------------------------------------------------------------------------------------------|
| zlbytes | uint32_t      | 4字节  | 记录整个压缩列表占用的内存字节数：在对压缩列表进行内存重分配或者计算 zlend 的位置时使用      |
| zltail  | uint32_t      | 4字节  | 记录压缩列表表尾节点距离压缩列表的起始地址有多少字节：通过这个偏移量确定表尾节点的地址         |
| zllen   | uint16_t      | 2字节  | 记录了压缩列表包含的节点数量：当值小于65535时，属性的值即为压缩列表包含节点的数量；当值为65535时，节点的真实数量需遍历整个压缩列表才能计算得出 |
| entryX  | 列表节点      | 不定   | 压缩列表包含的各个节点，节点的长度由节点保存的内容决定                                    |
| zlend   | uint8_t       | 1字节  | 特殊值 0xFF（十进制255），用于标记压缩列表的末端                                              |

### 压缩列表节点的构成

`previout_entry_length`、`encoding`、`content`

每个压缩列表节点可以保存一个字节数组或者一个整数值

1. `previous_entry_length` 以字节为单位，记录压缩列表中前一个节点的长度，previous_entry_length 属性的长度可以是1字节或者5字节；
2. `encoding` 记录节点 content 属性所保存数据的类型以及长度；
3. `content` 负责保存节点的值，节点值可以是一个字节数组或者整数，值的类型和长度由节点的 encoding 属性决定。

### 连锁更新 cascade update

添加新节点到压缩列表，或者从压缩列表中删除节点，可能会引发连锁更新操作，但这种操作出现的机率并不高。

连续多次空间扩展操作 

---

## 对象 object

Redis 基于上述介绍的数据结构创建了一个对象系统，这个系统包含字符串对象、列表对象、哈希对象、集合对象、有序集合对象，每种对象都用到了至少一种上述所介绍的数据结构。

### 对象的类型与编码

Redis 使用对象来表示数据库中的键和值，每次当我们在 Redis 的数据库中新创建一个键值对时，我们至少会创建两个对象，一个对象用作键值对的键（**键对象**），另一个对象用作键值对的值（**值对象**）

```c
typedef struct redisObject {

    // 类型
    unsigned type:4;

    // 编码
    unsigned encoding:4;

    // LRU 计时时钟
    unsigned lru:22;

    // 引用计数
    int refcount;

    // 指向底层实现数据结构的指针
    void *ptr;

    // ...

} robj;
```

- type 字段

type 字段:表示当前对象使用的数据类型，Redis 主要支持 5 种数据类型:string, hash, list, set, zset。可以使用 type { key }命令查看对象所属类型,type 命令返回的是值对象类型,键都是 string 类型。

- encoding 字段

**encoding** **字段** ：表示Redis内部编码类型，encoding 在 Redis 内部使用，代表当前对象内部采用哪种数据结构实现。理解Redis内部编码方式对于优化内存非常重要，同一个对象采用不同的编码实现内存占用存在明显差异。

- lru 字段

lru 字段：记录对象最后次被访问的时间，当配置了 maxmemory 和 maxmemory-policy=volatile-lru 或者 allkeys-lru 时，用于辅助 LRU 算法删除键数据。可以使用 object idletime {key} 命令在不更新 lru 字段情况下查看当前键的空闲时间。


*可以使用 scan + object idletime* *命令批量查询哪些键长时间未被访问，找出长时间不访问的键进行清理,* *可降低内存占用。*

- refcount 字段

refcount 字段：记录当前对象被引用的次数，用于通过引用次数回收内存，当 refcount=0 时，可以安全回收当前对象空间。使用 object refcount(key} 获取当前对象引用。当对象为整数且范围在[0-9999]时，Redis 可以使用共享对象的方式来节省内存。

PS 面试题，Redis 的对象垃圾回收算法-----引用计数法。

- *ptr 字段

*ptr 字段:与对象的数据内容相关，如果是整数，直接存储数据；否则表示指向数据的指针。

Redis 新版本字符串且长度 <=44 字节的数据，字符串 sds 和 redisobject 一起分配，从而只要一次内存操作即可。

*PS* *：高并发写入场景中，在条件允许的情况下，建议字符串长度控制在44**字节以内，减少创建redisobject**内存分配次数，从而提高性能。*

#### 类型 type

对应 Redis 数据库保存的键值对来说，键总是一个字符串对象，而值则可以是字符串对象、列表对象、哈希对象、集合对象或者有序集合对象的其中的一种。

**行话：**字符串键就是指的是数据库键对应值为字符串对象

| 对象 | 对象 type 属性的值 | type 命令的输出 |
| --- | --- | --- |
| 字符串对象 | REDIS_STRING | "string" |
| 列表对象 | REDIS_LIST | "list" |
| 哈希对象 | REDIS_HASH | "hash" |
| 集合对象 | REDIS_SET | "set" |
| 有序集合对象 | REDIS_ZSET | "zset" |

#### 编码和底层实现

对象的`ptr`指针指向对象的底层实现数据结构，而这些数据结构由对象的 encoding 属性决定。

encoding 属性记录了对象所使用的编码，也就是说这个对象使用了什么数据结构作为对象的底层实现。

- 对象的编码

| 编码常量              | 底层数据结构                |
|----------------------|--------------------------|
| REDIS_ENCODING_INT   | long 类型的整数           |
| REDIS_ENCODING_EMBSTR | embstr 编码的简单动态字符串 |
| REDIS_ENCODING_RAW    | 简单动态字符串             |
| REDIS_ENCODING_HT      | 字典                     |
| REDIS_ENCODING_LINKEDLIST | 双端链表                 |
| REDIS_ENCODING_ZIPLIST  | 压缩列表                 |
| REDIS_ENCODING_INTSET | 整数集合                 |
| REDIS_ENCODING_SKIPLIST | 跳跃表和字典             |

Redis 可以根据不同的使用场景来为一个对象设置不同的编码，从而优化对象在某一场景下的效率。

- 不同类型和编码的对象

| 类型           | 编码                  | 对象                                           |
|----------------|-----------------------|------------------------------------------------|
| REDIS_STRING   | REDIS_ENCODING_INT    | 使用整数值实现的字符串对象                        |
| REDIS_STRING   | REDIS_ENCODING_EMBSTR | 使用 embstr 编码的简单动态字符串实现的字符串对象 |
| REDIS_STRING   | REDIS_ENCODING_RAW    | 使用简单动态字符串实现的字符串对象                 |
| REDIS_LIST     | REDIS_ENCODING_ZIPLIST | 使用压缩列表实现的列表对象                         |
| REDIS_LIST     | REDIS_ENCODING_LINKEDLIST | 使用双端链表实现的列表对象                    |
| REDIS_HASH     | REDIS_ENCODING_IPLIST | 使用压缩列表实现的哈希对象                         |
| REDIS_HASH     | REDIS_ENCODING_HT     | 使用字典实现的哈希对象                             |
| REDIS_SET      | REDIS_ENCODING_INTSET | 使用整数集合实现的集合对象                         |
| REDIS_SET      | REDIS_ENCODING_HT     | 使用字典实现的集合对象                             |
| REDIS_ZSET     | REDIS_ENCODING_ZIPLIST | 使用压缩列表实现的有序集合对象                     |
| REDIS_ZSET     | REDIS_ENCODING_SKIPLIST | 使用跳跃表和字典实现的有序集合对象                |

### 字符串对象

字符串对象的编码可以是 int、raw 或者 embstr。

**编码的转换？**

对于 int 编码的对象来说，执行了命令后让这个对象存储的不在是整数值而是一个字符串值，对象编码 `int` -> `raw`

另外，embstr 编码的字符串对象没有修改 API，实际上 embstr 编码的字符串对象是只读的。所有如果要修改 embstr 编码的对象，总是会编码 `embstr` -> `raw`

### 列表对象

列表对象的编码可以是 ziplist 或者 linkedlist

1. ziplist 编码的列表对象使用压缩列表作为底层实现，每个压缩列表节点（entry）保存了一个列表元素。
2. linkedlist 编码的列表对象使用双端链表作为底层实现，每个双端链表节点（node）都保存了一个字符串对象，而每个字符串对象都保存了一个列表元素。

字符串对象是 Redis 五种类型的对象中唯一一种会被其他四种类型对象嵌套的对象。

**编码转换？** `ziplist` -> `linkedlist`

当列表对象可以同时满足以下两个条件时，列表对象使用 ziplist 编码：

1. 列表对象保存的所有字符串元素长度都小于 64 字节；
2. 列表对象保存的元素数量小于 512 个；

不能满足这两个条件的列表对象需要使用 linkedlist 编码。配置文件可修改这些数值。

对于使用 ziplist 编码的列表对象来说，当使用 ziplist 编码所需的两个条件的任意一个不能被满足时，对象的编码转换操作就会被执行，原本保存在压缩列表里的所有列表元素都会被转移并保存到双端链表里面，对象的编码也会从 ziplist 变为 linkedlist。

### 哈希对象

哈希对象的编码可以是 ziplist 或者 hashtable

**ziplist 编码：**每当由新的键值对加入，程序会先保存键的 ziplistNode 推入到压缩列表表尾，然后再将保存了值的 ziplistNode 推入到压缩列表表尾。

1. 保存了同一键值对的两个节点总是紧挨在一起，保存键的节点在前，保存值的节点在后；
2. 先添加到哈希对象中的键值对会被放在压缩列表的表头方向，而后来添加到哈希对象中的键值对会被放在压缩列表的表尾方向。

**hashtable 编码：**使用字典作为底层实现，哈希对象中的每个键值对都使用一个字典键值对来保存：

1. 字典的每一个键都是一个字符串对象，对象中保存了键值对的键；
2. 字典中的每个值都是一个字符串对象，对象中保存了键值对的值。

**编码转换？**`ziplist` -> `hashtable`

当哈希对象可以同时满足以下两个条件时，哈希对象使用ziplist 编码：

1. 哈希对象保存的所有键值对的键和值的字符串长度都小于 64 字节；
2. 哈希对象保存的键值对数量小于 512 个；

不能满足这两个条件的哈希对象需要使用 hashtable 编码。配置文件可修改这些数值。

ziplist 编码的列表对象，任一两个条件不满足就会发生编码转换。

### 集合对象

集合对象可以是 intset 或者 hashtable

**intset 编码：**所有元素都保存在整数集合里面

**hashtable 编码：**字典作为底层实现，字典的每个键都是一个字符串对象，每个字符串对象包含了一个集合元素，而字典的值则全部被设置为 NULL。

**编码转换？**`intset` -> `hashtable`

当集合对象可以同时满足以下两个条件时，对象使用 intset 编码：

1. 集合对象保存的所有元素都是整数值；
2. 集合对象保存的元素数量小于 512 个；

不能满足这两个条件的集合对象需要使用 hashtable 编码。配置文件可修改这些数值。

### 有序集合对象

有序集合的编码可以是 ziplist 或者 skiplist

ziplist 编码：用压缩列表作为底层实现，每个集合元素使用两个紧挨在一起的压缩列表节点来保存，第一个节点保存元素的成员（member），而第二个元素则保存元素的分值（score）。压缩列表内的集合元素按分值从小到大进行排序，分值较小的元素被放置在靠近表头的方向，而分值较大的放置在靠近表尾的方向。

**编码转换？**`ziplist` -> `skiplist`

1. 有序集合保存的元素小于 128 个；
2. 有序集合保存的元素成员长度小于 64 字节；

不满足则`ziplist` -> `skiplist`

### 内存回收

Redis 在自己的对象系统中构建了一个引用计数（reference counting）技术实现的内存回收机制。通过这一机制，程序可以通过跟踪对象的引用计数信息，在适当的时候自动释放对象并进行内存回收。

每个对象的引用计数信息由 redisObject 结构的 refcount 属性记录：

```c
typedef struct redisObject {
    // ...
    // 引用计数
    int refcount;
    // ...
} robj;
```

Redis 的对象系统带有引用计数实现的内存回收机制，当一个对象不再被使用时，该对象所占用的内存就会被自动释放。

### 对象共享

`refcount`还有对象共享的作用。

Redis 会共享值为 0 到 9999 的字符串对象。目前来说，Redis 会在初始化服务器时，创建一万个字符串对象，这些对象包含了从 0 到 9999 的所有整数值，当服务器需要用到值为 0 到 9999 的字符串对象时，服务器就会使用这些共享对象，而不是新创建对象。

### 对象的空转时长

lru 属性，该属性记录了对象最后一次被命令程序访问的时间：

```c
typedef struct redisObject {

    // ...

    unsigned lru:22;

    // ...

} robj;
```

<font color='red' >给定键的空转时长 = 当前时间 - 对象的 lru 时间</font>

`lru`属性记录了对象最后一次被命令程序访问的时间，这个时间可以用于计算对象的空转时间。

如果服务器打开了 maxmemory 选项，并且服务器用于回收内存的算法为 volatile-lru 或者 allkeys-lru，那么当服务器占用的内存数超过了 maxmemory选项所设置的上限值时，空转时长较高的那部分键会优先被服务器释放，从而回收内存。