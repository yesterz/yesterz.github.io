---
title: Java 线程安全与锁优化
date: 2023-04-17 21:09:00 +0800
author: 
categories: [JVM]
tags: [JVM]
pin: false
math: false
mermaid: true
img_path: /assets/images/
---

ch13 线程安全与锁优化

## 1 线程安全

可操作的定义：

当多个线程同时访问一个对象时，如果不用考虑这些线程在运行时环境下的调度和交替执行，也不需要进行额外的同步，或者在调用方进行任何其他的协作操作，调用这个对象的行为都可以获得正确的结果，那就称这个**对象是线程安全的**。

要求线程安全的代码：

代码本身封装了所有必要的正确性保障手段（如互斥同步等），令调用者无须关心多线程下的调用问题，更无需自己实现任何措施来保证多线程环境下的正确调用。

### Java 语言中的线程安全

前提：**多个线程之间存在共享数据访问为前提**

把 Java 语言中各种操作共享的数据分为以下五类：不可变、绝对线程安全、相对线程安全、线程兼容和线程对立。

1. **不可变**
    
    不可变（Immutable）的对象一定是线程安全的，无论是对象的方法实现还是方法的调用者，都不需要再进行任何线程安全保障措施。
    
2. **绝对线程安全**
    
    例如 Vector 一定要做到绝对的线程安全，那就必须在它内部维护一组一致性的快照访问才行，每次对其中元素进行改动都要产生新的快照，这样要付出的时间和空间成本都是非常大的。
    
3. **相对线程安全**
    
    相对线程安全就是通常意义上所讲的线程安全，即**它需要保障这个对象单次的操作是线程安全的**，我们在调用的时候不需要进行额外的保障措施，但对于一些特定顺序的连续调用，就可能需要在调用端使用额外的同步手段来保证调用的正确性。
    
    在 Java 语言中，大部分声称线程安全的类都属于这种类型，例如 Vector、HashTable、Collections 的 synchronizedCollection() 方法包装的集合等。
    
4. **线程兼容**
    
    线程兼容是指对象本身并不是线程安全的，但是可以通过在调用端正确地使用同步手段来保证对象在并发环境中可以安全地使用。
    
5. **线程对立**
    
    指不管调用端是否采取了同步措施，都无法在多线程环境中并发使用代码。
    
    很少出现 & 这种代码有害
    

### 线程安全的实现方法

1. 互斥同步 Mutual Exclusion & Synchronization

同步：多个线程并发访问共享数据时，保证共享数据在同一个时刻只被一条（或者时一些，当使用信号量的时候）线程使用。

互斥：是实现同步的一种手段，临界区（Critical Section）、互斥量（Mutex）、信号量（Semaphore）

这里的关系是 互斥是因，同步是果；互斥是方法，同步是目的。

在 Java 里面，最基本的互斥同步手段 synchronized 关键字，再就是 java.util.concurrent，其中的 java.util.concurrent.locks.Lock 接口

1. 非阻塞同步 Non-Blocking Synchronization

基于冲突检测的乐观并发策略，通俗的说就是不管风险，先进行操作，如果没有其他线程征用共享数据，那就操作之直接成功了；如果共享数据的确被争用，产生了冲突，那再进行其他的补偿措施，最常用的补偿措施是不断地重试，直到出现没有竞争地共享数据为止。

这种乐观并发策略的实现不再需要把线程阻塞挂起，因此这种同步操作被称为非阻塞同步（Non-Blocking Synchronization），使用这种措施的代码也常被称为无锁（Lock-Free）编程。

1. 无同步方案

会有一些代码天生就是线程安全的

- 可重入代码（Reentrant Code）
    
    这种代码又称纯代码（Pure Code），是指可以在代码执行的任何时刻中断它，转而去执行另外一段代码（包括递归调用它本身），而在控制权返回后，原来的程序不会出现任何错误，也不会对结果有所影响。
    
- 线程本地存储（Thread Local Storage）
    
    如果一段代码中所需要的数据必须与其他代码共享，那就看看这些共享数据的代码是否能保证在同一个线程中执行。如果能保证，我们就可以把共享数据的可见范围限制在同一个线程之内，这样，无须同步也能保证线程之间不出现数据争用的问题。
    

## 2 锁优化

为了解决在线程之间更高效地共享数据及解决竞争问题，从而提高程序的执行效率。

### 自旋锁 & 自适应自旋 Adaptive Spinning

物理机器有一个以上的处理器或者处理器核心，能让两个或以上的线程同时并行执行，我们
就可以让后面请求锁的那个线程“稍等一会”，但不放弃处理器的执行时间，看看持有锁的线程是否很快就会释放锁。为了让线程等待，我们只须让线程执行一个忙循环（自旋），这项技术就是所谓的自旋锁。

### 锁消除 Lock Elimination

锁消除是指虚拟机即时编译器在运行时，对一些代码要求同步，但是对被检测到不可能存在共享数据竞争的锁进行消除。锁消除的主要判定依据来源于逃逸分析的数据支持（第11章），如果判断到一段代码中，在堆上的所有数据都不会逃逸出去被其他线程访问到，那就可以把它们当作栈上数据对待，认为它们是线程私有的，同步加锁自然就无须再进行。

### 锁粗化 Lock Coarsening

如果一系列的连续操作都**对同一个对象反复加锁和解锁**，甚至加锁操作是出现在循环体之中的，那即使没有线程竞争，频繁地进行互斥同步操作也会导致不必要的性能损耗。

如果虚拟机探测到有这样一串零碎的操作都对同一个对象加锁，将会把**加锁同步的范围扩展（粗化）到整个操作序列的外部。**

### 轻量级锁 Lightweight Locking

在代码即将进入同步块的时候，如果此同步对象没有被锁定（锁标志位为“01”状态），虚拟机首先将在当前线程的栈帧中建立一个名为锁记录（Lock Record）的空间，用于存储锁对象目前的Mark Word的拷贝（官方为这份拷贝加了一个Displaced前缀，即Displaced Mark Word）

然后，虚拟机将使用CAS操作尝试把对象的Mark Word更新为指向Lock Record的指针。如果这个
更新动作成功了，即代表该线程拥有了这个对象的锁，并且对象Mark Word的锁标志位（Mark Word的最后两个比特）将转变为“00”，表示此对象处于轻量级锁定状态。

如果这个更新操作失败了，那就意味着至少存在一条线程与当前线程竞争获取该对象的锁。虚拟机首先会检查对象的Mark Word是否指向当前线程的栈帧，如果是，说明当前线程已经拥有了这个对象的锁，那直接进入同步块继续执行就可以了，否则就说明这个锁对象已经被其他线程抢占了。如果出现两条以上的线程争用同一个锁的情况，那轻量级锁就不再有效，必须要膨胀为重量级锁，锁标志的状态值变为“10”，此时Mark Word中存储的就是指向重量级锁（互斥量）的指针，后面等待锁的线程也必须进入阻塞状态

[4 Monitor 概念 & 原理](https://www.notion.so/4-Monitor-03a01a9f422549bcb64eab5a93fa7c28?pvs=21) 

### 偏向锁 Biased Locking

假设当前虚拟机启用了偏向锁（启用参数-XX：+UseBiased Locking，这是自 JDK 6 起HotSpot虚拟机的默认值），那么当锁对象第一次被线程获取的时候，虚拟机将会把对象头中的标志位设置为“01”、把偏向模式设置为“1”，表示进入偏向模式。

同时使用CAS操作把获取到这个锁的线程的ID记录在对象的Mark Word之中。如果CAS操作成功，持有偏向锁的线程以后每次进入这个锁相关的同步块时，虚拟机都可以不再进行任何同步操作（例如加锁、解锁及对Mark Word的更新操作等）。

一旦出现另外一个线程去尝试获取这个锁的情况，偏向模式就马上宣告结束。根据锁对象目前是否处于被锁定的状态决定是否撤销偏向（偏向模式设置为“0”），撤销后标志位恢复到未锁定（标志位为“01”）或轻量级锁定（标志位为“00”）的状态，后续的同步操作就按照上面介绍的轻量级锁那样去执行。