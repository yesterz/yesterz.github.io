---
title: 共享模型之管程（Monitor）
author: someone
date: 2023-05-20 11:33:00 +0800
categories: [Concurrent Programming]
tags: [Concurrent Programming]
pin: false
math: false
mermaid: false
---

## ch4 共享模型之管程（Monitor）

## 1 本章内容

并发之共享模型——管程-悲观锁（阻塞）

- 共享问题
- synchronized 关键字，解决多线程中的并发问题
- 线程安全分析，知道怎么样的代码编写是线程安全的，哪些有隐患
- Monitor，原理分析，管程的底层实现
- 重要组成部分 wait/notify 也是线程通信的基础
- 线程状态转换，补充第 3 章线程状态
- 活跃性（死锁，活锁，饥饿）
- Lock 对活跃性中出现的问题进行改进，用 synchronized 可能在处理活跃性有问题

**Q 什么共享资源**

> Ans 指的是多个线程同时对同一份资源进行访问（读写操作）
> 

**Q 数据同步 or 资源同步？**

> Ans 意思是保证多个线程访问到的数据是一样的，一致的
> 

Q 管程是什么意思？

> Ans 翻译的问题，就是Monitor 直译叫监视器，操作系统领域翻译成管程，就是**管理共享变量以及对共享变量的操作过程，让他们支持并发**
> 

- **临界区 Critical Section**
    1. 一个程序运行多个线程本身是没有问题的
    2. 问题出在多个线程访问共享资源
        1. 多个线程读共享资源其实也没有问题
        2. 在多个线程对共享资源读写操作时发生指令交错，就会出现问题
    3. 一段代码如果存在对共享资源的多线程读写操作，称这段代码块为**临界区（Critical Section）**
- **竞态条件 Race Condition**
  
    多个线程在临界区内执行，由于代码的执行序列不同而导致结果无法预测，称之为发生了**竞态条件（Race Condition）**
    

1. CAS（比较和交换指令）：是一种CPU指令，用于实现多线程同步。CAS指令接受三个操作数：内存位置、期望值和新值。如果内存位置的值与期望值相同，则将该位置的值更新为新值，否则什么也不做。CAS指令在多线程编程中常用于实现非阻塞算法。

为了解决临界区的竞态条件发生，有以下几种方法

1. 阻塞式的解决方案：synchronized，Lock
2. 非阻塞式的解决方案：原子变量

## 2 synchronized

**参考文章：**

https://github.com/farmerjohngit/myblog/issues/12

[盘一盘 synchronized （一）—— 从打印Java对象头说起 - 柠檬五个半 - 博客园](https://www.cnblogs.com/LemonFive/p/11246086.html)

[盘一盘 synchronized （二）—— 偏向锁批量重偏向与批量撤销 - 柠檬五个半 - 博客园](https://www.cnblogs.com/LemonFive/p/11248248.html)

[](https://www.oracle.com/technetwork/java/biasedlocking-oopsla2006-wp-149958.pdf)

synchronized 俗称“对象锁”，它采用互斥的方式让同一时刻至多只有一个线程能持有“对象锁”，其它线程再想获取这个“对象锁”时就会阻塞住。排他机制，同一时间只能有一个线程执行。

这样就能保证拥有锁的线程可以安全的执行临界区内的代码，不用担心上下文切换。

> **注意：**虽然 Java 中互斥和同步都可以采用 synchronized 关键字来完成，但它们还是有区别的：a. 互斥是保证临界区的竞态条件发生，同一时刻只能有一个线程执行临界区代码 b. 同步是由于线程执行的先后、顺序不同、需要一个线程等待其他线程运行到某个点
> 

Synchronized keyword enable a simple strategy for preventing thread interference and memory consistency errors: if an object is visible to more than one thread, all reads or writes to that object’s variables are done through synchronized methods.

- **synchronized 语法**
    1. 对于普通同步方法，锁是当前实例对象
    2. 对于同步方法块，锁是 synchronized 括号里配置的对象
    3. 对于静态同步方法，锁是当前类的Class对象

```java
synchronized(对象) // 线程1，线程2（BLOCKED）
{
    // Critical Section
} // **1** 同步方法块，锁是 synchronized 括号里配置的对象
```

```java
class Test {
    public synchronized void test() {
        // Critical Section
    }
}
// 等价于
class Test {
    public void test() {
        synchronized(this) {
            // Critical Section
        }
    }
} // **2** 普通同步方法，锁是当前实例对象
```

```java
class Test {
    public synchronized static void test() {
				// Critical Section
		}
}
// 等价于
class Test {
		public static void test() {
				synchronized(Test.class) {
						// Critical Section				
				}
		}
} // **3** 静态同步方法，锁是当前类的Class对象
```

[[TODO]线程八锁问题](https://www.notion.so/TODO-7b7d5f5db08b4314b771bd7212d8a6b4?pvs=21) 

## 3 变量的线程安全分析

### 成员变量和静态变量是否线程安全？

Q 什么叫做线程安全？

> Ans 线程安全（Thread Safety）是指当多个线程同时访问一个共享资源时，不会出现数据竞争（Data Race）或者不一致的结果，且不需要额外的同步措施或者锁来保证数据的正确性。具有线程安全性的程序能够正确地处理并发访问，且不会引起数据损坏、数据丢失或其他未定义行为。
> 
- 如果它们没有共享，则线程安全
- 如果它们被共享了，根据它们的状态是否能够改变，又分两种情况
    1. 如果只有读操作，则线程安全
    2. 如果有读写操作，则这段代码是临界区，需要考虑线程安全

### 局部变量是否线程安全？

- 局部变量是线程安全的
- 但局部变量引用的对象未必
    1. 如果该对象没有逃离方法的作用访问，它是线程安全的
    2. 如果该对象逃离方法的作用范围，需要考虑线程安全
- 分析
  
    局部变量，每个线程调用时都会创建其不同实例，没有共享
    

### 常见的线程安全类

- String
- Integer
- StringBuffer
- Random
- Vector
- Hashtable
- java.util.concurrent 包下的类

这里说它们时线程安全的是指，多个线程调用它们同一个实例的某个方法时，是线程安全的

```java
Hashtable table = new Hashtable();

new Thread(() -> {
		table.put("key", "value1");
}).start();

new Thread(() -> {
		table.put("key", "value2");
}).start();
```

- 它们的每个方法是原子的
- 但注意它们多个方法的组合不是原子的

### 不可变类线程安全性

String、Integer等都是不可变类，因为其内部的状态不可以改变，因此它们的方法都是线程安全的。

### 解决

- 多实例，也就是不用单例模式了
- 使用 java.util.concurrent 下面的类库
- 使用锁机制 synchronized、lock 方式

## 4 Monitor 概念 & 原理

Monitor 被翻译为监视器或管程，关注访问共享变量时，保证临界区代码的原子性

### Java 对象头

以32位虚拟机为例，对象在堆内存中的存储布局可以划分为三个部分：对象头（Header）、实例数据（Instance Data）和对齐填充（Padding）

对象头部分包括两类信息。第一类是用于存储对象自身的运行时数据，称之为 Mark Word。

另外一部分是类型指针，即对象指向它的类型元数据的指针，Java 虚拟机通过这个指针来确定该对象是哪个类的实例。[参考页面](https://www.notion.so/ch2-JVM-afd703b3ac2c44429912f0cf11e56375?pvs=21)

- 普通对象

```markdown
|--------------------------------------------------------------|
|                   Object Header (64 bits)                    |
|------------------------------------|-------------------------|
|          Mark Word (32 bits)       |   Klass Word (32 bits)  |
|------------------------------------|-------------------------|
```

- 数组对象

```markdown
|---------------------------------------------------------------------------------|
|                        Object Header (96 bits)                                  |
|--------------------------------|-----------------------|------------------------|
|         Mark Word(32bits)      | Klass Word(32bits)    |  array length(32bits)  |
|--------------------------------|-----------------------|------------------------|
```

其中 Mark Word 结构为

```markdown
|-------------------------------------------------------|--------------------|
|                Mark Word (32 bits)                    |       State        |
|-------------------------------------------------------|--------------------|
|   hashcode:25         | age:4 | biased_lock:0 | 01    |       Normal       |
|-------------------------------------------------------|--------------------|
|  thread:23 | epoch:2  | age:4 | biased_lock:1 | 01    |       Biased       |
|-------------------------------------------------------|--------------------|
|         ptr_to_lock_record:30                 | 00    | Lightweight Locked |
|-------------------------------------------------------|--------------------|
|        ptr_to_heavyweight_monitor:30          | 10    | Heavyweight Locked |
|-------------------------------------------------------|--------------------|
|                                               | 11    |   Marked for GC    |
|-------------------------------------------------------|--------------------|
```

| 存储内容 | 标志位 | 状态 |
| --- | --- | --- |
| 对象哈希码、对象分代年龄 | 01 | 未锁定 |
| 指向锁记录的指针 | 00 | 轻量级锁定 |
| 指向重量级锁的指针 | 10 | 膨胀（重量级锁定） |
| 空，不需要记录信息 | 11 | GC 标记 |
| 偏向线程ID、偏向时间戳、对象分代年龄 | 01 | 可偏向 |

![Untitled](/assets/images/MonitorImages/Untitled.png)

64位虚拟机 Mark Word

![Untitled](/assets/images/MonitorImages/Untitled%201.png)

> 深入理解 Java 虚拟机 P51 2.3.2 对象的内存布局
> 

每个 Java 对象对可以关联一个 Monitor 对象，如果使用 synchronized 给对象上锁(重量级)之后，该对象头的 Mark Word 中被设置指向 Monitor 对象的指针

### Monitor 结构

![Untitled](/assets/images/MonitorImages/Untitled%202.png)

1. 刚开始 Monitor 中 Owner 为 null
2. 当 Thread-2 执行 synchronized(obj) 就会将 Monitor 的所有者 Owner 置为 Thread-2，Monitor 中只能有一个 Owner
3. 在 Thread-2 上锁的过程中，如果 Thread-3，Thread-4，Thread-5 也来执行 synchronized(obj)，就会进入 EntryList BLOCKED
4. Thread-2 执行完同步代码块的内容，然后唤醒 EntryList 中等待的线程来竞争锁，竞争时是非公平的
5. 图中 WaitSet 中的 Thread-0，Thread-1 是之前获得过锁，但条件不满足进入 WAITING 状态的线程，后面讲 wait-notify 时会分析

> 注意： 1 synchronized 必须是进入同一个对象的 Monitor 才有上述的效果 2 不加 synchronized 的对象不会关联 Monitor，不遵循以上规则
> 

### synchronized 原理

```java
static final Object lock = new Object();
static int counter = 0;

public static void main(String[] args) {
		synchronized (lock) {
				counter++;
		}
}
```

```java
public static void main(java.lang.String[]);
	 descriptor: ([Ljava/lang/String;)V
	 flags: ACC_PUBLIC, ACC_STATIC
	 Code:
		stack=2, locals=3, args_size=1
			 0: getstatic #2 // <- lock引用 （synchronized开始）
			 3: dup
			 4: astore_1 // lock引用 -> slot 1
			 5: monitorenter // 将 lock对象 MarkWord 置为 Monitor 指针
			 6: getstatic #3 // <- i
			 9: iconst_1 // 准备常数 1
			 10: iadd // +1
			 11: putstatic #3 // -> i
			 14: aload_1 // <- lock引用
			 15: monitorexit // 将 lock对象 MarkWord 重置, 唤醒 EntryList
			 16: goto 24
			 19: astore_2 // e -> slot 2 
			 20: aload_1 // <- lock引用
			 21: monitorexit // 将 lock对象 MarkWord 重置, 唤醒 EntryList
			 22: aload_2 // <- slot 2 (e)
			 23: athrow // throw e
			 24: return
	 Exception table:
		 from to target type
				 6 16  19  any
				 19 22  19 any
 LineNumberTable:
 line 8: 0
 line 9: 6
 line 10: 14
 line 11: 24
 LocalVariableTable:
 Start Length Slot Name Signature
 0 25 0 args [Ljava/lang/String;
 StackMapTable: number_of_entries = 2
 frame_type = 255 /* full_frame */
 offset_delta = 19
 locals = [ class "[Ljava/lang/String;", class java/lang/Object ]
 stack = [ class java/lang/Throwable ]
 frame_type = 250 /* chop */
 offset_delta = 4
```

- [ ]  讲大白话思路：[TODO]

### synchronized 原理进阶

这部分五块内容轻量级锁、锁膨胀、自旋优化、偏向锁、锁消除

- **轻量级锁**

轻量级锁的使用场景：如果一个对象虽然有多线程要加锁，但加锁的时间是错开的（也就是没有竞争），那么可以使用轻量级锁来优化。

轻量级锁对使用者是透明的，即语法仍然是 `synchronized`

假设有两个方法同步块，利用同一个对象加锁

```java
static final Object obj = new Object();
public static void method1() {
		synchronized(obj) {
				// 同步块 A
				method2();
		}
}
public static void method2() {
		synchronized(obj) {
				// 同步块 B
		}
}
```

![Untitled](/assets/images/MonitorImages/Untitled%203.png)

首先创建锁记录（Lock Record）对象，每个线程的栈帧都会包含一个锁记录的结构，内部可以存储锁定对象 Mark Word

线程中的 Lock Record 对象包含锁记录对象的地址和状态，还有锁的地址

![Untitled](/assets/images/MonitorImages/Untitled%204.png)

让锁记录中 Object reference 指向锁对象，并尝试用 CAS 替换 Object 的 Mark Word，将 Mark Word 的值存入锁记录

如果 CAS 替换成功，对象头中存储了锁记录地址和状态00，表示由线程给对象加锁，这时图示为

![Untitled](/assets/images/MonitorImages/Untitled%205.png)

![Untitled](/assets/images/MonitorImages/Untitled%206.png)

如果 **CAS 失败**，有两种情况

1. 如果是其他线程已经持有了该 Object 的轻量级锁，这时表明有竞争，进入锁[膨胀过程](https://www.notion.so/ch4-Monitor-31f3b4b19110419981f92db6bd6a2de2?pvs=21)
2. 如果是自己执行了 synchronized 锁重入，那么再添加一条 Lock Record 作为重入的计数

当退出 synchronized 代码块（解锁时）如果有取值为 null 的锁记录，表示有重入，这是重置锁记录，表示重入计数减一

![Untitled](/assets/images/MonitorImages/Untitled%207.png)

当退出 synchronized 代码块（解锁时）锁记录的值不为 null，这时使用 CAS 将 Mark Word 的值恢复给对象头

1. 成功，则解锁成功
2. 失败，说明轻量级锁进行了锁膨胀或已经升级为重量级锁，进入重量级锁解锁流程
- **锁膨胀（重量级锁）**

如果在尝试加轻量级锁的过程中，CAS 操作无法成功，这时一种情况就是有其他线程为此时对象加上了轻量级锁（有竞争），这时需要进行锁膨胀，将轻量级锁变为重量级锁。

```java
static Object obj = new Object();
public static void method1() {
		synchronized(obj) {
				// 同步块
		}
}
```

当 Thread-1 进行轻量级加锁时，Thread-0 已经对该对象加了轻量级锁

![当 Thread-1 进行轻量级加锁时，Thread-0 已经对该对象加了轻量级锁](/assets/images/MonitorImages/Untitled%208.png)

当 Thread-1 进行轻量级加锁时，Thread-0 已经对该对象加了轻量级锁

这时 Thread-1 加轻量级锁失败，进入锁膨胀流程

1. 即为 Object 对象申请 Monitor 锁，让 Object 指向重量级锁地址
2. 然后自己进入 Monitor 的 EntryList BLOCKED

![Thread-1 为 Object 对象申请 Monitor 锁，让 Object 指向重量级锁地址](/assets/images/MonitorImages/Untitled%209.png)

Thread-1 为 Object 对象申请 Monitor 锁，让 Object 指向重量级锁地址

当 Thread-0 退出同步块解锁时，使用 CAS 将 Mark Word 的值恢复给对象头，失败。这时会进入重量级解锁流程，即按照 Monitor 地址找到 Monitor 对象，设置 Owner 为 null，唤醒 EntryList 中 BLOCKED 线程

- **自旋优化**

重量级锁竞争的时候，还可以使用自旋来进行优化，如果当前线程自旋成功（即这时候持锁线程已经退出了同步块，释放了锁），这时当前线程就可以避免阻塞。

*自旋重试成功的情况*

| Thread-1（core-1） | Mark Word | Thread-2（core-2） |
| --- | --- | --- |
| - | 10（重量锁） | - |
| 访问同步块，获取 Monitor | 10（重量锁）重量锁指针 | - |
| 成功（加锁） | 10（重量锁）重量锁指针 | - |
| 执行同步块 | 10（重量锁）重量锁指针 | - |
| 执行同步块 | 10（重量锁）重量锁指针 | 访问同步块，获取 Monitor |
| 执行同步块 | 10（重量锁）重量锁指针 | 自旋重试 |
| 执行完毕 | 10（重量锁）重量锁指针 | 自旋重试 |
| 成功（解锁） | 01（无锁） | 自旋重试 |
| - | 10（重量锁）重量锁指针 | 成功（加锁） |
| - | 10（重量锁）重量锁指针 | 执行同步块 |
| - | … | … |

*自旋重试失败的情况*

| Thread-1（core-1） | Mark Word | Thread-2（core-2） |
| --- | --- | --- |
| - | 10（重量锁） | - |
| 访问同步块，获取 Monitor | 10（重量锁）重量锁指针 | - |
| 成功（加锁） | 10（重量锁）重量锁指针 | - |
| 执行同步块 | 10（重量锁）重量锁指针 | - |
| 执行同步块 | 10（重量锁）重量锁指针 | 访问同步块，获取 Monitor |
| 执行同步块 | 10（重量锁）重量锁指针 | 自旋重试 |
| 执行同步块 | 10（重量锁）重量锁指针 | 自旋重试 |
| 执行同步块 | 10（重量锁）重量锁指针 | 自旋重试 |
| 执行同步块 | 10（重量锁）重量锁指针 | 阻塞 |
| - | … | … |

自旋会占用 CPU 时间，单核 CPU 自旋就是浪费，多核 CPU 自旋才能发挥优势。

在 Java 6 之后自旋锁时自适应的，比如对象刚刚的一次自旋操作成功过，那么认为这次自旋成功的可能性会高，就多自旋几次；反之，就少自旋甚至不自旋，总之，比较智能。

Java 7 之后不能控制是否开启自旋功能。

- **偏向锁**

偏向状态、撤销-调用对象hashcode、撤销-其他线程使用对象、撤销-调用wait/notify、批量重偏向、批量撤销

轻量级锁在没有竞争时（就自己这个线程），每次重入仍然需要执行 CAS 操作。

Java 6 中引入了偏向锁来做进一步优化：只有第一次使用 CAS 将线程 ID 设置到对象的 Mark Word 头，之后发现这个线程 ID 是自己的就表示没有竞争，不用重新 CAS。以后只要不发生竞争，这个对象就归该线程所有

例如：

```java
static final Object obj = new Object();
public static void m1() {
		synchronized(obj) {
				// 同步块 A
				m2();
		}
}
public static void m2() {
		synchronized(obj) {
				// 同步块 B
				m3();
		}
}
public static void m3() {
		sychronized(obj) {
				// 同步块 C
		}
}
```

![轻量级锁三次调用均生成锁记录](/assets/images/MonitorImages/Untitled%2010.png)

轻量级锁三次调用均生成锁记录

![偏向锁检查 ThreadID 是否是自己，并不生成锁记录](/assets/images/MonitorImages/Untitled%2011.png)

偏向锁检查 ThreadID 是否是自己，并不生成锁记录

***偏向状态***

回忆一下[对象头格式](https://www.notion.so/ch4-Monitor-31f3b4b19110419981f92db6bd6a2de2?pvs=21)

![Untitled](/assets/images/MonitorImages/Untitled%2012.png)

一个对象创建时：

1. 如果开启了偏向锁（默认开启），那么对象创建后，Mark Word 值为 0x05 即最后 3 位是 101，这时它的 thread、epoch、age 都为0
2. 偏向锁是默认是延迟的，不会在程序启动时立即生效，如果想避免延迟，可以加 VM 参数 `-XX:BiasedLockingStartupDelay=0` 来禁用延迟
3. 如果没有开启偏向锁，那么对象创建后，Mark Word 值为 0x01 即最后 3 位为 001，这时它的 hashcode、age 都为 0，第一次用到 hashcode 时才会赋值

***撤销-调用对象 hashcode***

调用了对象的 hashCode，但偏向锁的对象 Mark Word 中存储的时线程ID，如果调用 hashCode 会导致偏向锁被撤销

1. 轻量级锁会在锁记录中记录 hashCode
2. 重量级锁会在 Monitor 中记录 hashCode

在调用 hashCode 后使用偏向锁，记得去掉`-XX:-UseBiasedLocking`

***撤销-其他线程使用对象***

当有其他线程使用偏向锁对象时，会将偏向锁升级为轻量级锁

***撤销-调用 wait/notify***

其他线程调用 notify 方法时，会导致偏向锁被撤销

- **批量重偏向**

如果对象虽然被多个线程访问，但没有竞争，这时偏向了线程 T1 的对象仍有机会重新偏向 T2，重偏向会重置对象的 Thread ID

当撤销偏向锁阈值超过20次后，JVM 会这样觉得，我是不是偏向错了呢，于是会给这些对象加锁时重新偏向加锁线程

- **批量撤销**

当撤销偏向锁阈值超过40次后，JVM会这样觉得，自己确实偏向错了，根本就不该偏向。于是整个类的所有对象都会变为不可偏向的，新建的对象也是不可偏向的

- **锁消除**
- **锁粗化**

### 4 wait & notify

![Untitled](/assets/images/MonitorImages/Untitled%2013.png)

1. Owner 线程发现条件不满足，调用 wait 方法，即可进入 WaitSet 变为 WAITING 状态
2. BLOCKED 和 WAITING 的线程都处于阻塞状态，不占用 CPU 时间片
3. BLOCKED 线程会在 Owner 线程释放锁时唤醒
4. WAITING 线程会在 Owner 线程调用 notify 或 notifyAll 时唤醒，但唤醒后并不意味着立刻获得锁，仍需进入 EntryList 重新竞争

| obj.wait() | 让进入 object 监视器的线程到 WaitSet 等待 |
| --- | --- |
| obj.notify() | 在 object 上正在 WaitSet 等待的线程中挑一个唤醒 |
| obj.notifyAll() | 让 object 上正在 WaitSet 等待的线程全部唤醒 |

它们都属于线程之间进行协作的手段，都属于 Object 对象的方法。必须获得此对象的锁，才能调用这几个方法

`wait()` 方法会释放对象的锁，进入 WaitSet 等待区，从而让其他线程有机会获得对象的锁。无限制等待，直到 notify 为止

`wait(long n)`有时限的等待，到 n 毫秒后结束等待，或是被 notify

先看 `sleep(long n)` 和 `wait(long n)` 的区别

1. sleep 是 Thread 方法，而 wait 是 Object 的方法
2. sleep 不需要强制和 synchronized 配合使用，但 wait 需要和 synchronized 一起用
3. sleep 在睡眠的时候，不会释放对象锁，但 wait 在等待的时候会释放对象锁
4. 它们状态 TIMED_WAITING

## 5 park & unpark

### park/unpark 基本使用

它们是 LockSupport 类中的方法

```java
// 暂停当前线程
LockSupport.park();
// 恢复某个线程的运行
LockSupport.unpark(暂停线程对象);
```

先 park 再 unpark 

### park/unpark 特点

与 Object 的 wait/notify 相比

- wait，notify 和 notifyAll 必须配合 Object Monitor 一起使用，而 park/unpark 不必
- park & unpark 是以线程为单位来阻塞和唤醒线程，而 notify 只能随机唤醒一个等待线程，notifyAll 是唤醒所有等待线程，就不那么精确
- park & unpark 可以先 unpark，而 wait & notify 不能先 notify

### park & unpark 原理

每个线程都有自己的一个 Parker 对象，由三部分组成 `_*counter`，`_cond` 和 `_mutex`*

| _counter | _counter 变量用于记录某个共享资源的使用情况。它可以是一个整数类型的变量，初始值为 0，每当一个线程访问该共享资源时，就会将 _counter 的值加 1，当线程结束访问时，就会将 _counter 的值减 1。通过对 _counter 变量进行原子操作，可以避免多个线程同时访问同一个共享资源的情况。 |
| --- | --- |
| _cond | _cond 变量用于实现条件变量，它可以让线程在某个条件满足时等待，直到另一个线程通知它可以继续执行。使用 _cond 变量可以避免线程在等待某个条件时浪费 CPU 时间。 |
| _mutex | _mutex 变量用于实现互斥锁，它可以防止多个线程同时访问共享资源。当一个线程获取到了 _mutex 变量时，其他线程就不能再访问共享资源了。当线程结束访问共享资源时，它需要释放 _mutex 变量，以便其他线程可以获取到它。通过使用 _mutex 变量，可以保证每个时刻只有一个线程可以访问共享资源，从而避免竞争条件的出现。 |
- _counter 可以是一个整型变量，用于记录某个共享资源的使用情况。当一个线程调用 park() 方法时，它会将 _counter 减 1，如果 _counter 已经为 0，则线程将被阻塞。当其他线程调用 unpark() 方法时，它会将 _counter 加 1，如果有线程被阻塞，则会有一个线程被唤醒。
- _cond 变量可以是一个条件变量，用于实现线程间的协作。当一个线程调用 park() 方法时，它会加入到 _cond 队列中等待被唤醒。当其他线程调用 unpark() 方法时，它会从 _cond 队列中取出一个等待的线程，并将其唤醒。
- _mutex 变量可以是一个互斥锁，用于控制对共享资源的访问。当一个线程调用 park() 方法时，它会释放 _mutex 锁，并进入等待状态。当其他线程调用 unpark() 方法时，它会获得 _mutex 锁，并唤醒一个等待的线程。

![Untitled](/assets/images/MonitorImages/Untitled%2014.png)

1. 当前线程调用 `Unsafe.park()` 方法
2. 检查 `_counter` ，本情况为 0，这时，获得 `_mutex` 互斥锁
3. 线程进入 `_cond` 条件变量阻塞
4. 设置 `_counter = 0`

![Untitled](/assets/images/MonitorImages/Untitled%2015.png)

1. 调用 `Unsafe.unpark(Thread_0)` 方法，设置 `_counter` 为 1
2. 唤醒 `_cond` 条件变量中的 `Thread_0`
3. `Thread_0` 恢复运行
4. 设置 `_counter` 为 0

![Untitled](/assets/images/MonitorImages/Untitled%2016.png)

1. 调用 `Unsafe.unpark(Thread_0)` 方法，设置 `_counter` 为 1
2. 当前线程调用 `Unsafe.park()` 方法
3. 检查 `_counter` ，本情况为 1，这时线程无需阻塞，继续运行
4. 设置 `_counter` 为 0

## 6 重新来理解线程状态转换

![Untitled](/assets/images/MonitorImages/Untitled%2017.png)

❗❗❗假设有线程 `Thread t`

### 情况1 NEW —> RUNNABLE

- 当调用 `t.start()` 方法时，由 NEW —> RUNNABLE

### 情况2 RUNNABLE <—> WAITING

t 线程用 `synchronized(obj)` 获取了锁对象后

- 调用 `obj.wait()` 方法时，t 线程从 RUNNABLE —> WAITING
- 调用 `obj.notify()` ，`obj.notifyAll()` ，`t.interrupt()` 时
    - 竞争锁成功，t 线程从 WAITING —> RUNNABLE
    - 竞争锁失败，t 线程从 WAITING —> BLOCKED

### 情况3 RUNNABLE <—> WAITING

- 当前线程调用 `t.join()` 方法，当前线程从 RUNNABLE —> WAITING
    - 注意是当前线程在 t 线程对象的监视器上等待
- t 线程运行结束，或调用了当前线程的 `interrupt()` 时，当前线程从 WAITING —> RUNNABLE

### 情况4 RUNNABLE <—> WAITING

- 当前线程调用 `LockSupport.park()` 方法会让当前线程从 RUNNABLE —> WAITING
- 调用 `LockSupport.unpark(目标线程)` 或调用了线程的 interrupt() ，会让目标线程从 WAITING —> RUNNABLE

### 情况5 RUNNABLE <—> TIMED_WAITING

t 线程用 `synchronized(obj)` 获取了对象锁后

- 调用 `obj.wait(long n)` 方法时，t 线程从 RUNNABLE —> TIMED_WAITING
- t 线程等待时间超过了 n 毫秒，或调用 `obj.notify()` ，`obj.notifyAll()` ，`t.interrupt()` 时
    - 竞争锁成功，t 线程从 TIMED_WAITING —> RUNNABLE
    - 竞争锁失败，t 线程从 TIMED_WAITING —> BLOCKED

### 情况6 RUNNABLE <—> TIMED_WAITING

- 当前线程调用 `t.join(long n)` 方法时，当前线程从 RUNNABLE —> TIMED_WAITING
    - 注意是当前线程在 t 线程对象的监视器上等待
- 当前线程等待时间超过了 n 毫秒，或 t 线程运行结束，或调用了当前线程的 `interrupt()` 时，当前线程从 TIMED_WAITING —> RUNNABLE

### 情况7 RUNNABLE <—> TIMED_WAITING

- 当前线程调用 `Thread.sleep(long n)` ，当前线程从 RUNNABLE —> TIMED_WAITING
- 当前线程等待时间超过了 n 毫秒，当前线程从 TIMED_WAITING —> RUNNABLE

### 情况8 RUNNABLE <—> TIMED_WAITING

- 当前线程调用 `LockSuport.parkNanos(long nanos)` 或 `LockSupport.parkUntil(long millis)` 时，当前线程从 RUNNABLE —> TIMED_WAITING
- 调用 `LockSupport.unpark(目标线程)` 或调用了线程的 `interrupt()` ，或是等待超时，会让目标线程从 TIMED_WAITING —> RUNNABLE

### 情况9 RUNNABLE <—> BLOCKED

- t 线程用 `synchronized(obj)` 获取了对象锁时如果竞争失败，从 RUNNABLE —> BLOCKED
- 持 obj 锁线程的同步代码块执行完毕，会唤醒该对象上所有 BLOCKED 的线程重新竞争，如果其中 t 线程竞争成功，从 BLOCKED —> RUNNABLE ，其他失败的线程让然 BLOCKED

### 情况10 RUNNABLE <—> TERMINATED

当前线程所有代码运行完毕，进入 TERMINATED

## 7 多把锁——多把不相干的锁

一间大屋子有两个功能：睡觉、学习、互不相干

现在A要学习，B要睡觉，但如果只用一间屋子（一个对象锁）的话，那么并发度很低

解决办法就是准备多个房间（多个对象锁）

将锁的粒度细分

- 好处，是可以增强并发度
- 坏处，如果一个线程需要同时获得多把锁，就容易发生死锁

## 8 活跃性

### 死锁

有这样的情况：一个线程需要同时获取多把锁，这时就容易发生死锁

Thread_1 获得 object_A 锁，接下来想获取 object_B 的锁 Thread_2 获得 object_B 锁，接下来想获取 object_A 的锁。

```java
Object A = new Object();
Object B = new Object();
Thread t1 = new Thread(() -> {
		synchronized (A) {
				log.debug("lock A");
				sleep(1);
				synchronized (B) {
						log.debug("lock B");
						log.debug("do something...");
				}
		}
}, "t1");

Thread t2 = new Thread(() -> {
		synchronized (B) {
				log.debug("lock B");
				sleep(0.5);
				synchronized (A) {
						log.debug("lock A");
						log.debug("do something...");
				}
		}
}, "t2");
t1.start();
t2.start();
```

### 定位死锁

- 检测死锁可以使用 jconsole 工具，或使用 jps 定位进程 id ，再用 jstack 定位死锁;
- 避免死锁要注意加锁顺序
- 另外如果由于某个线程进入了死循环，导致其他线程一直等待，对于这种情况 linux 下可以通过 top 先定位到 CPU 占用高的 Java 进程，再利用 top -Hp 进程id 来定位是哪个线程，最后再用 jstack 排查

### 哲学家就餐问题

有五位哲学家，围坐在圆桌旁。
他们只做两件事，思考和吃饭，思考一会吃口饭，吃完饭后接着思考。
吃饭时要用两根筷子吃，桌上共有 5 根筷子，每位哲学家左右手边各有一根筷子。
如果筷子被身边的人拿着，自己就得等待

### 活锁

活锁出现在两个线程互相改变对方的结束条件，最后谁也无法结束。

### 饥饿

很多教程中把饥饿定义为，一个线程由于优先级太低，始终得不到 CPU 调度执行，也不能够结束，饥饿的情况不
易演示，讲读写锁时会涉及饥饿问题
下面我讲一下我遇到的一个线程饥饿的例子，先来看看使用顺序加锁的方式解决之前的死锁问题

![Untitled](/assets/images/MonitorImages/Untitled%2018.png)

顺序加锁的解决方案

![Untitled](/assets/images/MonitorImages/Untitled%2019.png)

## 9 ReentrantLock

相对于 synchronized 它具备如下特点

- 可中断
- 可以设置超时时间
- 可以设置为公平锁
- 支持多个条件变量

与 synchronized 一样，都支持可重入

### 基本语法

```java
// 获取锁
reentrantLock.lock()
try {
		// 临界区
} finally {
		// 释放锁
		reentrantLock.unlock();
}
```

### 可重入的意思

可重入是指同一个线程如果首次获得了这把锁，那么因为它是这把锁的拥有者，因此有权利再次获取这把锁；如果是不可重入锁，那么第二次获得锁时，自己也会被锁挡住

### 可打断

注意如果是不可中断模式，那么即使使用了 interrupt 也不会让等待中断

### 锁超时

立刻失败

### 公平锁

ReentrantLock 默认是不公平的；公平锁一般没有必要，会降低并发度，后面分析原理时会讲解

### 条件变量

synchronized 中也有条件变量，就是我们讲原理时那个 waitSet 休息室，当条件不满足时进入 waitSet 等待；ReentrantLock 的条件变量比 synchronized 强大之处在于，他是支持多个条件变量的，这就好比

- synchronized 是那些不满足条件的线程都在一间休息室等消息
- 而 ReentrantLock 支持多间休息室，有专门等烟的休息室，专门等早餐的休息室、唤醒时也是按休息室来唤醒

使用要点：

- await 前需要获得锁
- await 执行后，会释放锁，进入 conditionObject 等待
- await 的线程被唤醒（或打断、或超时）取重新竞争 lock 锁
- 竞争 lock 锁成功后，从 await 后继续执行

## ch4 本章总结 见图

![Untitled](/assets/images/MonitorImages/Untitled%2020.png)

[[TODO]线程八锁问题](https://www.notion.so/TODO-7b7d5f5db08b4314b771bd7212d8a6b4?pvs=21)