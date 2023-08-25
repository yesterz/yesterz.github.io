---
title: 共享模型之工具
author: someone
date: 2023-05-23 11:33:00 +0800
categories: [多线程]
tags: [多线程, 笔记, 线程池, JUC]
pin: false
math: false
mermaid: false
---

# 共享模型之工具

## 线程池

创建和销毁对象是很费时间的，所以有 创建统一的一个线程池。

通俗理解就是有一个池子，里面存放着已经创建好的线程，当有任务提交给线程池执行时，池子中的某个线程会主动执行该任务。如果池子中的线程数量不够应付数量众多的任务时，则需要自动扩充新的线程到池子中，但是该数量时有限的，就好比池塘的水界线一样。当任务比较少的时候，池子中的线程能够自动回收，释放资源。为了能够异步地提交任务和缓存未被处理的任务，需要有一个任务队列。。

1. newSingleThreadExecutor 创建一个单线程的线程池
2. newFixedThreadPool 创建固定大小的线程池
3. newCachedThreadPoll 创建一个可缓存的线程池

### 自定义线程池

![线程池原理图](/assets/images/ToolsImages/Untitled.png)

线程池原理图

一个完整的线程池需要包括如下要素

1. 任务队列 用于缓存提交的任务
2. 线程数量管理功能 一个线程池必须能够很好地管理和控制线程数量，可通过如下三个参数来实现，比如创建线程池时初始的线程数量 init ；线程池自动扩充时最大的线程数量 max ；在线程池空闲时需要释放线程但是也要维护一定数量的活跃数量或者核心数量 core ；有了这三个参数就能够很好的控制线程池中的线程数量，将其维护在一个合理的范围之内，三者之间的关系是 init ≤ core ≤ max
3. 任务拒绝策略 如果线程数量已达到上限且任务队列已满，则需要有相应的拒绝策略来通知任务提交者
4. 线程工厂 主要用于个性化定制线程，比如将线程设置为守护线程以及设置线程名称等
5. QueueSize 任务队列主要存放提交的 Runnable ，但是为了防止内存溢出，需要有 limit 数量对其进行控制
6. Keepedalive 时间 该时间主要决定线程各个重要参数自动维护的时间间隔

![Untitled](/assets/images/ToolsImages/Untitled%201.png)

1. 步骤1 自定义拒绝策略接口
2. 步骤2 自定义任务队列
3. 步骤3 自定义线程池
4. 步骤4 测试

### ThreadPoolExecutor

![Untitled](/assets/images/ToolsImages/Untitled%202.png)

#### 线程池状态

ThreadPoolExecutor 使用 int 的高 3 位来表示线程池状态，低 29 位表示线程数量

| 状态名 | 高 3 位 | 接收新任务 | 处理阻塞队列任务 | 说明 |
| --- | --- | --- | --- | --- |
| RUNNABLE | 111 | Y | Y |  |
| SHUTDOWN | 000 | N | Y | 不会接收新任务，但会处理阻塞队列剩余任务 |
| STOP | 001 | N | N | 会中断正在执行的任务，并抛弃阻塞队列任务 |
| TIDYING | 010 | —— | —— | 任务全执行完毕，活动线程为 0 即将进入终结 |
| TERMINATED | 011 | —— | —— | 终结状态 |

从数字上比较，TERMINATED > TIDYING > STOP > SHUTDOWN > RUNNING

这些信息存储在一个原子变量 ctl 中，目的是将线程状态域线程个数合二为一，这样就可以用一次 CAS 原子操作进行赋值

```java
// c 为旧值， ctlOf 返回结果为新值
ctl.compareAndSet(c, ctlOf(targetState, workerCountOf(c))));

// rs 为高 3 位代表线程池状态， wc 为低 29 位代表线程个数，ctl 是合并它们
private static int ctlOf(int rs, int wc) { return rs | wc; }
```

#### 构造方法

```java
public ThreadPoolExecutor(int corePoolSize,
				int maximumPoolSize,
				long keepAliveTime,
				TimeUnit unit,
				BlockingQueue<Runnable> workQueue,
				ThreadFactory threadFactory,
				RejectedExecutionHandler handler)
```

| 参数名 | 含义 |
| --- | --- |
| corePoolSize | 核心线程数目（最多保留的线程数） |
| maximumPoolSize | 最大线程数目 |
| keepAliveTime | 生存时间-针对救急线程 |
| unit | 时间单位-针对救急线程 |
| workQueue | 阻塞队列 |
| threadFactory | 线程工厂-可以为线程创建时起个好名字 |
| handler | 拒绝策略 |

工作方式

1. 线程池中开始没有线程，当一个任务提交给线程池后，线程池会创建一个新线程来执行任务
2. 当线程数达到 corePoolSize 并没有线程空闲，这时再加入任务，新加的任务会被加入 workQueue 队列排队，直到有空闲的线程
3. 如果队列选择了有界队列，那么任务超过了队列大小时，会创建 maximumPoolSize - corePoolSize 数目的线程来救急
4. 如果线程到达 maximumPoolSize 仍然有新任务这时会执行拒绝策略。拒绝策略 JDK 提供了四种实现，其它著名框架也提供了实现
    1. AbortPolicy 让调用者抛出 RejectedExecutionException 异常，这是默认策略
    2. CallerRunsPolicy 让调用者运行任务
    3. DiscardPolicy 放弃本次任务
    4. DiscardOldestPolicy 放弃队列中最早的任务，本任务取而代之
    5. Dubbo 的实现，在抛出 RejectedExecutionException 异常之前会记录日志，并 dump 线程栈信息，方便定位问题
    6. Netty 的实现，是创建一个新线程来执行任务
    7. ActiveMQ 的实现，带超时等待（60s）尝试放入队列，类似我们之前自定义的拒绝策略
    8. PinPoint 的实现，它使用了一个拒绝策略链，会逐一尝试策略链中每种拒绝策略
5. 当高峰过去后，超过 corePoolSize 的救急线程如果一段时间没有任务做，需要结束节省资源，这个时间由 keepAliveTime 和 unit 来控制

![Untitled](/assets/images/ToolsImages/Untitled%203.png)

根据这个构造方法，JDK Executors 类中提供了众多工厂方法来创建各种用途的线程池

#### newFixedThreadPool

```java
public static ExecutorService newFixedThreadPool(int nThreads) {
		return new ThreadPoolExecutor(nThreads, nThreads,
																	0L, TimeUnit.MILLISECONDS,
																	new LinkedBlockingQueue<Runnable>());
}
```

特点：

1. 核心线程数 == 最大线程数（没有救急线程被创建），因此也无需超时时间
2. 阻塞队列是无界的，可以放任意数量的任务

> 评价 适用于任务量已知，相对耗时的任务
> 

#### newCachedThreadPool

```java
public static ExecutorService newCachedThreadPool() {
		return new ThreadPoolExecutor(0, Integer.MAX_VALUE,
																	60L, TimeUnit.SECONDS,
																	new SynchronousQueue<Runnable>());
}
```

特点：

1. 核心线程数 0，最大线程数是 Integer.MAX_VALUE ，救急线程的空闲生存时间是 60s，意味着
    1. 全部都是救急线程（60s 后可以回收）
    2. 救急线程可以无限创建
2. 队列采用了 SynchronousQueue 实现特点是它没有容量，没有线程来取是放不进去的（一手交钱，一手交货）

> 评价 整个线程池表现为线程数会根据任务量不断增长，没有上线，当任务执行完毕，空闲 1 分钟后释放线程。适合任务数比较密集，但每个任务执行时间较短的情况
> 

#### newSingleThreadExecutor

```java
public static ExecutorService newSingleThreadExecutor() {
		return new FinalizableDelegatedExecutorService
				(new ThreadPoolExecutor(1, 1,
																0L, TimeUnit.MILLISECONDS,
																new LinkedBlockingQueue<Runnable>()));
}
```

使用场景：

希望多个任务排队执行。线程数固定为 1 ，任务数多余 1 时，会放入无界队列排队。任务执行完毕，这唯一的线程也不会被释放。

区别：

1. 自己创建一个单线程串行执行任务，如果任务执行失败而终止那么没有任何补救措施，而线程池还会新建一个线程，保证池的正常工作
2. Executors.newSingleThreadExecutor() 线程个数始终为 1 ，不能修改
    - FinalizableDelegatedExecutorService 应用的是装饰器模式，只对外暴露了 ExecutorService 接口，因此不能调用 ThreadPoolExecutor 中特有的方法
3. Executors.newFixedThreadPool(1) 初始时为1，以后还可以修改
    - 对外暴露的是 ThreadPoolExecutor 对象，可以强转后调用 setCorePoolSize 等方法进行修改

#### 提交任务

```java
// 执行任务
void execute(Runnable command);
// 提交任务 task，用返回值 Future 获得任务执行结果
<T> Future<T> submit(Callable<T> task);
// 提交 tasks 中所有任务
<T> List<Future<T>> invokeAll(Collection<? extends Callable<T>> tasks)
 throws InterruptedException;
// 提交 tasks 中所有任务，带超时时间
<T> List<Future<T>> invokeAll(Collection<? extends Callable<T>> tasks,
 long timeout, TimeUnit unit)
 throws InterruptedException;
// 提交 tasks 中所有任务，哪个任务先成功执行完毕，返回此任务执行结果，其它任务取消
<T> T invokeAny(Collection<? extends Callable<T>> tasks)
 throws InterruptedException, ExecutionException;
// 提交 tasks 中所有任务，哪个任务先成功执行完毕，返回此任务执行结果，其它任务取消，带超时时间
<T> T invokeAny(Collection<? extends Callable<T>> tasks,
 long timeout, TimeUnit unit)
 throws InterruptedException, ExecutionException, TimeoutException;
```

#### 关闭线程池

- shutdown
  
    线程池状态变为 SHUTDOWN ，不会接收新任务，但已提交任务会执行完，此方法不会阻塞调用线程的执行
    
    ```java
    void shutdown();
    public void shutdown() {
     final ReentrantLock mainLock = this.mainLock;
     mainLock.lock();
     try {
     checkShutdownAccess();
     // 修改线程池状态
     advanceRunState(SHUTDOWN);
     // 仅会打断空闲线程
     interruptIdleWorkers();
     onShutdown(); // 扩展点 ScheduledThreadPoolExecutor
     } finally {
     mainLock.unlock();
     }
     // 尝试终结(没有运行的线程可以立刻终结，如果还有运行的线程也不会等)
     tryTerminate();
    }
    ```
    
- shutdownNow
  
    线程池状态变为 STOP ，不会接收新任务，会将队列中的任务返回，并用 interrupt 的方式中断正在执行的任务
    
    ```java
    List<Runnable> shutdownNow()
    public List<Runnable> shutdownNow() {
    List<Runnable> tasks;
     final ReentrantLock mainLock = this.mainLock;
     mainLock.lock();
     try {
     checkShutdownAccess();
     // 修改线程池状态
     advanceRunState(STOP);
     // 打断所有线程
     interruptWorkers();
     // 获取队列中剩余任务
     tasks = drainQueue();
     } finally {
     mainLock.unlock();
     }
     // 尝试终结
     tryTerminate();
     return tasks;
    }
    ```
    
- 其它方法

```java
// 不在 RUNNING 状态的线程池，此方法就返回 true
boolean isShutdown();
// 线程池状态是否是 TERMINATED
boolean isTerminated();
// 调用 shutdown 后，由于调用线程并不会等待所有任务运行结束
// 因此如果它想在线程池 TERMINATED 后做些事情，可以利用此方法等待
boolean awaitTermination(long timeout, TimeUnit unit) throws InterruptedException;
```

### Fork/Join 【略】

## J.U.C  Java.util.concurrent

### AQS 原理

### 概述

全称是 AbstractQueuedSynchronizer ，是阻塞式锁和相关的同步器工具的框架

特点：

- 用 state 属性来表示资源的状态（分独占模式和共享模式），子类需要定义如何维护这个状态，控制如何获取锁和释放锁
    - getState - 获取 state 状态
    - setState - 设置 state 状态
    - compareAndSetState - CAS 机制设置 state 状态
    - 独占模式是只有一个线程能够访问资源，而共享模式可以允许多个线程访问资源
- 提供了基于 FIFO 的等待队列，类似于 Monitor 的 EntryList
- 条件变量来实现等待、唤醒机制，支持多个条件变量，类似于 Monitor 的 WaitSet

子类主要实现这样一些方法（默认抛出 UnsupportedOperationException ）

- tryAcquire
- tryRelease
- tryAcquireShared
- tryReleaseShared
- isHeldExclusively

获取锁的姿势

```java
// 如果获取锁失败
if (!tryAcquire(arg)) {
		// 入队，可以选择阻塞当前线程 park unpark
}
```

释放锁的姿势

```java
// 如果释放锁成功
if (tryRelease(arg)) {
		// 让阻塞线程恢复运行
}
```

### 实现不可重入锁

不可重入锁是指一种只允许一个线程在任意时刻获得该锁的锁实现。这意味着如果一个线程已经获得了该锁，在该线程释放锁之前，任何其他线程都无法获得该锁。

#### 自定义同步器

```java
final class MySync extends AbstractQueuedSynchronizer {
 @Override
 protected boolean tryAcquire(int acquires) {
 if (acquires == 1){
 if (compareAndSetState(0, 1)) {
 setExclusiveOwnerThread(Thread.currentThread());
 return true;
 }
 }
 return false;
 }
 @Override
 protected boolean tryRelease(int acquires) {
 if(acquires == 1) {
 if(getState() == 0) {
 throw new IllegalMonitorStateException();
 }
 setExclusiveOwnerThread(null);
 setState(0);
 return true;
 }
 return false;
 }
 protected Condition newCondition() {
 return new ConditionObject();
 }
 @Override
 protected boolean isHeldExclusively() {
 return getState() == 1;
}
}
```

自定义同步器的作用是为了在多线程环境中提供更灵活的同步机制。Java中的同步器是用来管理线程的访问和通信的工具，可以通过自定义同步器来实现不同的同步策略和控制机制。

自定义同步器通常用于以下几种情况：

1. 实现独占锁：可以通过自定义同步器来实现独占锁，控制只有一个线程可以获得锁，其他线程必须等待。
2. 实现共享锁：可以通过自定义同步器来实现共享锁，允许多个线程同时获得锁，但限制同时获得锁的线程数量。
3. 实现条件等待/通知机制：自定义同步器可以通过使用条件变量来实现线程的等待和通知机制，使得线程可以在特定条件下等待或被唤醒。
4. 控制线程的执行顺序：通过自定义同步器，可以实现线程的有序执行，例如按照优先级或其他自定义规则来决定线程的执行顺序。

总之，自定义同步器允许开发人员根据特定需求设计和实现灵活的同步机制，以确保多线程环境下的线程安全和正确性。

#### 自定义锁

有了自定义同步器，很容易复用 AQS ，实现一个功能完备的自定义锁

#### 心得

- 起源
  
    早期程序员会自己通过一种同步器去实现另一种相近的同步器，例如用可重入锁去实现信号量，或反之。这显然不够优雅，于是在 JSR166（Java 规范提案）中创建了 AQS ，提供了这种通用的同步器机制
    
- 目标
  
    AQS 要实现的功能目标
    
    - 阻塞版本获取锁 acquire 和非阻塞的版本尝试获取锁 tryAcquire
    - 获取锁超时机制
    - 通过打断取消机制
    - 独占机制及共享机制
    - 条件不满足时的等待机制
    
    要实现的性能目标
    
    > Instead, the primary performance goal here is scalability: to predictably maintain efficiency even, or especially, when synchronizers are contended.
    > 
- 设计
  
    AQS 的基本思想其实很简单
    
    获取锁的逻辑
    
    ```java
    while(state 状态不允许获取) {
    		if(队列中还没有此线程) {
    				入队并阻塞
    		}
    }
    当前线程出队
    ```
    
    释放锁的逻辑
    
    ```java
    if(state 状态允许了) {
    		恢复阻塞的线程(s)
    }
    ```
    
    要点
    
    1. 原子维护 state 状态
    2. 阻塞及恢复线程
    3. 维护队列
1. state 设计
    1. state 使用 volatile 配合 CAS 保证其修改时的原子性
    2. state 使用了 32 bit int 来维护同步状态，因为当时使用 long 在很多平台下测试的结果并不理想
2. 阻塞恢复设计
    1. 早起的控制线程暂停和恢复的 API 有 suspend 和 resume ，但它们时不可用的，因为如果先调用的 resume 那么 suspend 将感知不到
    2. 解决方法是使用 park & unpark 来实现线程的暂停和恢复，具体原理在之前讲过了，先 unpark 再 park 也没问题
    3. park & unpark 是针对线程的，而不是针对同步器，因此控制粒度更为精细
    4. park 线程还可以通过 interrupt 打断
3. 队列设计
    1. 使用了 FIFO 先入先出队列，并不支持优先级队列
    2. 设计时借鉴了 CLH 队列，它是一种单向无锁队列

![Untitled](/assets/images/ToolsImages/Untitled%204.png)

队列中有 head 和 tail 两个指针节点，都用 volatile 修饰配合 CAS 使用，每个节点有 state 维护节点状态入队伪代码，只需要考虑 tail 赋值的原子性

```java
do {
		// 原来的 tail
		Node prev = tail;
		// 用 CAS 在原来 tail 的基础上改为 node
} while(tail.compareAndSet(prev, node))
```

出队伪代码

```java
// prev 是上一个节点
while((Node prev=node.prev).state != 唤醒状态) {
}
// 设置头节点
head = node;
```

CLH 好处：

- 无锁，使用自旋
- 快速，无阻塞

AQS 在一些方面改进了 CLH

```java
private Node enq(final Node node) {
 for (;;) {
 Node t = tail;
 // 队列中还没有元素 tail 为 null
 if (t == null) {
 // 将 head 从 null -> dummy
 if (compareAndSetHead(new Node()))
 tail = head;
 } else {
 // 将 node 的 prev 设置为原来的 tail
 node.prev = t;
 // 将 tail 从原来的 tail 设置为 node
 if (compareAndSetTail(t, node)) {
 // 原来 tail 的 next 设置为 node
 t.next = node;
 return t;
 }
 }
 }
}
```

主要用到的 AQS 的并发工具类

![Untitled](/assets/images/ToolsImages/Untitled%205.png)

### ReentrantLock 原理

![Untitled](/assets/images/ToolsImages/Untitled%206.png)

#### 非公平锁实现原理

- 加锁解锁流程
  
    先从构造器看，默认为非公平锁实现
    
    ```java
    public ReentrantLock() {
    		sync = new NonfairSync();
    }
    ```
    
    NonfairSync 继承自 AQS
    
    没有竞争时
    
    ![Untitled](/assets/images/ToolsImages/Untitled%207.png)
    
    第一个竞争出现时
    
    ![Untitled](/assets/images/ToolsImages/Untitled%208.png)
    

Thread-1 执行了

1. CAS 尝试将 state 由 0 改为 1，结果失败
2. 进入 tryAcquire 逻辑，这时 state 已经是1，结果仍然失败
3. 接下来进入 addWaiter 逻辑，构造 Node 队列
图中黄色三角表示该 Node 的 waitStatus 状态，其中 0 为默认正常状态
Node 的创建是懒惰的
其中第一个 Node 称为 Dummy（哑元）或哨兵，用来占位，并不关联线程

当前线程进入 acquireQueued 逻辑

1. acquireQueued 会在一个死循环中不断尝试获得锁，失败后进入 park 阻塞
2. 如果自己是紧邻着 head（排第二位），那么再次 tryAcquire 尝试获取锁，当然这时 state 仍为 1，失败
3. 进入 shouldParkAfterFailedAcquire 逻辑，将前驱 node，即 head 的 waitStatus 改为 -1，这次返回 false
4. shouldParkAfterFailedAcquire 执行完毕回到 acquireQueued ，再次 tryAcquire 尝试获取锁，当然这时
state 仍为 1，失败
5. 当再次进入 shouldParkAfterFailedAcquire 时，这时因为其前驱 node 的 waitStatus 已经是 -1，这次返回
true
6. 进入 parkAndCheckInterrupt， Thread-1 park（灰色表示）

### 读写锁

[并发编程_原理.pdf](https://www.notion.so/_-pdf-c40276fb9049463d93687e9a60848a9b?pvs=21) 

### Semaphore

[ˈsɛməˌfɔr] 信号量，用来限制能同时访问共享资源的线程上限。

### CountdownLatch

用来进行线程同步协作，等待所有线程完成倒计时。

其中构造参数用来初始化等待计数值，await() 用来等待计数归零，countDown() 用来让计数减一

### CyclicBarrier

[ˈsaɪklɪk ˈbæriɚ] 循环栅栏，用来进行线程协作，等待线程满足某个计数。构造时设置『计数个数』，每个线程执行到某个需要“同步”的时刻调用 await() 方法进行等待，当等待的线程数满足『计数个数』时，继续执行

> 注意 CyclicBarrier 与 CountDownLatch 的主要区别在于 CyclicBarrier 是可以重用的 CyclicBarrier 可以被比喻为『人满发车』
> 

### 线程安全集合类概述

![Untitled](/assets/images/ToolsImages/Untitled%209.png)

线程安全集合类可以分为三大类：

- 遗留的线程安全集合如 Hashtable ， Vector
- 使用 Collections 装饰的线程安全集合，如：
Collections.synchronizedCollection
Collections.synchronizedList
Collections.synchronizedMap
Collections.synchronizedSet
Collections.synchronizedNavigableMap
Collections.synchronizedNavigableSet
Collections.synchronizedSortedMap
Collections.synchronizedSortedSet
- java.util.concurrent.*
重点介绍 java.util.concurrent.* 下的线程安全集合类，可以发现它们有规律，里面包含三类关键词：Blocking、CopyOnWrite、Concurrent
- Blocking 大部分实现基于锁，并提供用来阻塞的方法
- CopyOnWrite 之类容器修改开销相对较重
- Concurrent 类型的容器
    - 内部很多操作使用 cas 优化，一般可以提供较高吞吐量
    - 弱一致性
        - 遍历时弱一致性，例如，当利用迭代器遍历时，如果容器发生修改，迭代器仍然可以继续进行遍历，这时内容是旧的
        - 求大小弱一致性，size 操作未必是 100% 准确
        - 读取弱一致性

> 遍历时如果发生了修改，对于非安全容器来讲，使用 fail-fast 机制也就是让遍历立刻失败，抛出 ConcurrentModificationException，不再继续遍历
> 

### ConcurrentHashMap

- 死链问题
- JDK 8 ConcurrentHashMap

重要属性和内部类

```java
// 默认为 0
// 当初始化时, 为 -1
// 当扩容时, 为 -(1 + 扩容线程数)
// 当初始化或扩容完成后，为 下一次的扩容的阈值大小
private transient volatile int sizeCtl;
// 整个 ConcurrentHashMap 就是一个 Node[]
static class Node<K,V> implements Map.Entry<K,V> {}
// hash 表
transient volatile Node<K,V>[] table;
// 扩容时的 新 hash 表
private transient volatile Node<K,V>[] nextTable;
// 扩容时如果某个 bin 迁移完毕, 用 ForwardingNode 作为旧 table bin 的头结点
static final class ForwardingNode<K,V> extends Node<K,V> {}
// 用在 compute 以及 computeIfAbsent 时, 用来占位, 计算完成后替换为普通 Node
static final class ReservationNode<K,V> extends Node<K,V> {}
// 作为 treebin 的头节点, 存储 root 和 first
static final class TreeBin<K,V> extends Node<K,V> {}
// 作为 treebin 的节点, 存储 parent, left, right
static final class TreeNode<K,V> extends Node<K,V> {}
```

重要方法

```java
// 获取 Node[] 中第 i 个 Node
static final <K,V> Node<K,V> tabAt(Node<K,V>[] tab, int i)
 
// cas 修改 Node[] 中第 i 个 Node 的值, c 为旧值, v 为新值
static final <K,V> boolean casTabAt(Node<K,V>[] tab, int i, Node<K,V> c, Node<K,V> v)
 
// 直接修改 Node[] 中第 i 个 Node 的值, v 为新值
static final <K,V> void setTabAt(Node<K,V>[] tab, int i, Node<K,V> v)
```

构造器分析

可以看到实现了懒惰初始化，在构造方法中仅仅计算了 table 的大小，以后在第一次使用时才会真正创建

```java
public ConcurrentHashMap(int initialCapacity, float loadFactor, int concurrencyLevel) {
 if (!(loadFactor > 0.0f) || initialCapacity < 0 || concurrencyLevel <= 0)
 throw new IllegalArgumentException();
 if (initialCapacity < concurrencyLevel) // Use at least as many bins
 initialCapacity = concurrencyLevel; // as estimated threads
 long size = (long)(1.0 + (long)initialCapacity / loadFactor);
 // tableSizeFor 仍然是保证计算的大小是 2^n, 即 16,32,64 ... 
 int cap = (size >= (long)MAXIMUM_CAPACITY) ?
 MAXIMUM_CAPACITY : tableSizeFor((int)size);
 this.sizeCtl = cap;
}
```

### BlockingQueue

[并发编程_原理.pdf]

### ConcurrentLinkQueue

[并发编程_原理.pdf]

### CopyOnWriteArrayList

CopyOnWriteArraySet 是它的马甲 底层实现采用了 写入时拷贝 的思想，增删改操作会将底层数组拷贝一份，更改操作在新数组上执行，这时不影响其它线程的并发读，读写分离。

get 弱一致性

![Untitled](/assets/images/ToolsImages/Untitled%2010.png)

## ch8 本章总结

[并发编程_原理.pdf]

- 线程池
- JUC