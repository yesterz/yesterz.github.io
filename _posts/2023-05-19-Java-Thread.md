---
title: Java中的线程
categories: [Concurrent Programming]
tags: [Concurrent Programming]
toc: true
---

## 1 创建和运行线程

每个 Java 程序一启动的时候，实际上就有一个线程在运行即主方法线程，默认就有一个主线程在运行了，如果想要在主线程之外再创建线程可以有如下方法。

**创建和启动分两步走。**

**这里由三种方法**
    1. 直接使用 Thread
    2. 使用 Runnable 配合 Thread
    3. FutureTask 配合 Thread

### 第一种方法 直接使用 Thread

这里其实是**匿名内部类的写法**，创建的是Thread的一个子类，并且要覆盖其中的 run 方法。

```java
// 创建线程对象
Thread t = new Thread() {
    public void run() {
		    // 要执行的任务		
		}
};
// 启动线程
t.start();
```

```java
// 构造方法的参数是给线程指定名字，推荐使用
Thread t1 = new Thread("t1") {
		@Override
		// run 方法内实现了要执行的任务
		public void run() {
			log.debug("hello");
		}
};
t1.start();
```

Q 匿名内部类的写法 [Ans](https://www.notion.so/d004d8d721ea49afa641b25aac7d212e?pvs=21)

### 第二种方法，使用 Runnable 配合 Thread

把 线程 和 任务（要执行的代码）分开

1. Thread 代表线程
2. Runnable 可运行的任务（线程要执行的代码）

```java
Runnable runnable = new Runnable() {
    public void run() {
        // 要执行的任务
    }
};
// 创建线程对象
Thread t = new Thread(runnable);
// 启动线程
t.start();
```

例如：

```java
// 创建任务对象
Runnable task2 = new Runnable() {
    @Override
    public void run() {
        log.debug("hello");
    }
};

// 参数1 是任务对象；参数2 是线程名字，推荐
Thread t2 = new Thread(task2, "t2");
t2.start();
```

Java 8 之后可以使用 lambda 精简代码

```java
// 创建任务对象
Runnable task2 = () -> log.debug("hello");

// 参数1 是任务对象；参数2 是线程名字，推荐
Thread t2 = new Thread(task2, "t2");
t2.start();
```

- [ ]  Q lambda 表达式？ Ans

### 原理之 Thread 与 Runnable 的关系

Runnable接口

只定义了一个无参数返回值的 run 方法

```java
package java.lang;

public interface Runnable {
    void run();
}
```

JDK 中代表线程的只有 Thread 这个类，线程的执行单元就是 run 方法

【创建线程的两种方式】所以说两种方法实现自己的业务逻辑

1. 可以通过继承 Thread 类，然后重写 run 方法来实现自己的业务逻辑
2. 也可以实现 Runnable 接口实现自己的业务逻辑
- Thread run 方法的源码

```java
@Override
public void run() {
// 如果构造 Thread 时传递了 Runnable，则会执行 runnable 的 run 方法
    if (target != null) {
        target.run();
		}
// 否则需要重写 Thread 类的 run 方法
}
```

源码总结：

- 创建线程只有一种方式即构造 Thread 类
- 实现线程的执行单元则有两种方式
    1. 重写 Thread 的 run 方法
    2. 实现 Runnable 接口的 run 方法，并且将 Runnable 实例用作构造 Thread 的参数。

~~总结~~

1. ~~方法1 是把线程和任务合并在了一起，方法2 是把线程和任务分开了~~
2. ~~用 Runnable 更容易与线程池等高级 API 配合~~
3. ~~用 Runnable 让任务类脱离了 Thread 继承体系，更灵活~~

### 第三种方法，FutureTask 配合 Thread

FutureTask 能够接收 Callable 类型的参数，用来处理有返回结果的情况

```java
// 创建任务对象
FutureTask<Integer> task3 = new FutureTask<>(() -> {
    log.debug("hello");
    return 100;
});

// 参数1 是任务对象；参数2 是线程名字，推荐使用
new Thread(task3, "t3").start();

// 主线程堵塞，同步等待 task 执行完毕的结果
Integer result = task3.get();
log.debug("结果是:{}", result);
```

Q 注解用法

Ans

Q @FunctionalInterface ???????

Q 1000millis = 1s

| Reformat Code shortcut | Ctrl + Alt + L |
| --- | --- |
| Show Context Actions | Alt + Enter |
| Navigate→Declaration or Usages | Ctrl + B |
|  |  |
|  |  |
|  |  |

## 2 查看线程

### Windows

1. 任务管理器 可以查看进程和线程数，也可以用来杀死进程
2. tasklist 查看进程
3. taskkill 杀死进程

### Linux

1. ps -ef 查看所有进程
2. ps -fT -p <PID> 查看某个进程（PID）的所有进程
3. kill 杀死进程
4. top 按大写 H 切换是否显示线程
5. top -H -p <PID> 查看某个进程（PID）的所有线程

### Java

1. jps 命令查看所有 Java 进程
2. jstack <PID> 查看某个Java进程（PID）的所有线程状态
3. jconsole 来查看某个 Java 进程中线程的运行情况（图形界面）

jconsole 远程监控配置
需要以如下方式运行你的 java 类

```java
java -Djava.rmi.server.hostname='ip地址' -Dcom.sun.management.jmxremote -
Dcom.sun.management.jmxremote.port='连接端口' -Dcom.sun.management.jmxremote.ssl=是否安全连接 -
Dcom.sun.management.jmxremote.authenticate=是否认证 java类
```

修改 /etc/hosts 文件将 127.0.0.1 映射至主机名
如果要认证访问，还需要做如下步骤
复制 jmxremote.password 文件
修改 jmxremote.password 和 jmxremote.access 文件的权限为 600 即文件所有者可读写
连接时填入 controlRole（用户名），R&D（密码）

## 3 原理之线程运行

- 两部分内容
    - 线程运行流程：栈、栈帧、上下文切换、程序计数器
    - Thread 两种创建方式 的源码

### 栈与栈帧（Stack & Stack Frame）

JVM 运行时数据区是由方法区，虚拟机栈，本地方法栈，堆，程序计数器构成，其中栈内存是给谁用的，其实就是给线程用的，每个线程启动后，VM 就会为其分配一块栈内存。

Java 虚拟机栈描述的是 Java 方法执行的线程内存模型：每个方法被执行的时候，Java虚拟机都会同步创建一个栈帧（Stack Frame）用于存储局部变量表、操作数栈、动态连接、方法出口等信息。每一个方法被调用直至执行完毕的过程，就对应着一个栈帧在虚拟机栈中从入栈到出栈的过程。

1. 每个栈由多个栈帧（Frame）组成，对应着每次方法调用时所占用的内存
2. 每个线程只能有一个活动栈帧，对应着正在执行的那个方法

### 上下文切换（Thread Context Switch）

因为以下一些原因导致 CPU 不在执行当前的线程，转而执行另一个线程的代码

1. 线程的 CPU 时间片用完
2. 垃圾回收
3. 有更高优先级的线程需要运行
4. 线程自己调用了 sleep、yield、wait、join、park、synchronized、lock等方法

当 Context Switch 发生时，需要由操作系统保存当前线程的状态，并恢复另一个线程的状态，Java 中对应的概念就是程序计数器（Program Counter Register），它的作用是记住下一条 JVM 指令的执行地址，**是线程私有的**

1. 状态包括程序计数器、虚拟机栈中每个栈帧的信息，如局部变量、操作数栈、返回地址等
2. Context Switch 频繁发生会非常**影响性能**

## 3 Thread API

| 方法名         | 功能说明                                   |
| ------------- | ------------------------------------------ |
| start()       | 启动一个新线程，在新的线程运行 run 方法中的代码 |
| run()         | 新的线程启动后会调用的方法                  |
| join()        | 等待线程运行结束                           |
| join(long n)  | 等待线程运行结束                           |
| getId()       | 获取线程长整型的 id                       |
| getName()     | 获取线程名                                 |
| setName()     | 修改线程名                                 |
| getPriority() | 获取线程优先级                             |
| setPriority() | 修改线程优先级                             |
| getState()    | 判断是否被打断                             |
| interrupted() | 判断当前线程是否被打断                     |
| currentThread() | 获取当前正在执行的线程                     |
| sleep(long n) | 让当前执行的线程休眠 n 毫秒，休眠时让出 CPU 时间片给其他线程 |
| yield()       | 提示线程调度器让出当前线程对 CPU 的使用    |
| isAlive()     | 线程是否存活（还没有运行完毕）            |
| interrupt()   | 打断线程                                   |

**注意:**

- `start()`方法只是让线程进入就绪，里面代码不一定立刻运行（CPU的时间片还没分给它）。每个线程对象的`start()`方法只能调用一次，如果调用了多次会出现 `IllegalThreadStateException`.
- 如果在构造 `Thread` 对象时传递了 `Runnable` 参数，则线程启动后会调用 `Runnable` 中的 `run` 方法，否则默认不执行任何操作。但可以创建 `Thread` 的子类对象来覆盖默认行为，即使用匿名内部类形式来写（或使用 lambda 表达式来简化）.
- `interrupted()`方法会清除打断标记。
- `interrupt()`方法会设置打断标记。如果被打断线程正在 `sleep`, `wait`, `join` 会导致被打断的线程抛出 `InterruptedException`，并清除打断标记；如果打断的正在运行的线程，则会设置打断标记.


### start & run

直接上总结，区别在于 start 启动新线程，run 没有启动新线程

1. 直接调用 run 是在主线程中执行了 run，**没有启动新的线程**
2. 使用 start 是**启动新的线程**，通过新的线程间接执行 run 中的代码

### sleep & yield

- **sleep**
    1. 调用 sleep 会让当前线程从 RUNNING 进入 TIMED_WAITING 状态（阻塞）
    2. 其他线程可以使用 interrupt 方法打断正在睡眠的线程，这时 sleep 方法会抛出 InterruptedException
    3. 睡眠结束后的线程未必会立刻得到执行
    4. 建议用 TimeUnit 的 sleep 代替 Thread 的 sleep 来获得更好的可读性
    5. ❗❗❗不会放弃 monitor 锁的所有权 

> 枚举 TimeUnit，对 sleep 方法提供了很好的封装，可以省去时间换算步骤。TimeUnit.HOURS.sleep(3); TimeUnit.MINUTES.sleep(3); TimeUnit.SECONDS.sleep(3); 使用 Thread.sleep 的地方可以完全使用 TimeUnit 来代替。
> 
- **yield**
    1. 调用 yield 会让当前线程从 RUNNING 进入 RUNNABLE 就绪状态，然后调度执行其他线程
    2. 具体的实现依赖于操作系统的任务调度器

> yield 是一个启发式方法，其会提醒调度器我愿意放弃当前的 CPU 资源，如果 CPU 的资源不紧张，则会忽略这种提醒，这个方法不太常用，yield 只是一个提示（hint），CPU 调度器并不会担保每次都能满足 yield 提示，也就是说每次 yield 想让出此时的 CPU 资源任务调度器并不是每次都能满足，如果 CPU 资源比较空闲，yield 后还是会运行当前线程，并不会让出去。
> 
- **sleep & yield 总结**
    1. sleep 会导致当前线程暂停指定的时间，没有 CPU 时间片的消耗
    2. yield 只是对 CPU 调度器的一个提示，如果 CPU 调度器没有忽略这个提示，它会导致线程上下文的切换
    3. sleep 会使线程短暂 block，会在给定的时间内释放 CPU 资源
    4. yield 会使 RUNNING 状态的 Thread 进入 RUNNABLE 状态（如果 CPU 调度器没有忽略这个提示的话）
    5. sleep 几乎百分之百完成了给定时间的休眠，而 yield 的提示并不能一定担保
    6. 一个线程 sleep 另一个线程调用 interrupt 会捕获到中断信号，而 yield 则不会

- 线程优先级
    1. 线程优先级会提示（hint）调度器优先调度该线程，但它仅仅是一个提示，调度器可以忽略它
    2. 如果 CPU 比较忙，那么优先级高的线程会获得更多的时间片，但 CPU 闲时，优先级几乎没作用

### join

```java
public final void join() throws InterruptedException
public final synchronized void join(long millis, int nanos) throws InterruptedException
public final synchronized void join(long millis) throws InterruptedException
```

join 方法是一个可中断的方法，如果有线程执行了对当前线程的 interrupt 操作，它也会捕获到中断信号，并且擦除线程的 interrupt 标识

join 某个线程A（线程A.join()），会使当前线程B进入等待，直到线程A结束生命周期，或者到达给定时间，那么在此期间B线程是处于 BLOCKED 的，而不是A线程。

**大白话：**A.join() 就是当前线程B等 A 搞完事情再一起加入（join）再往下运行，此时当前线程是 BLOCKED 的。B到了 A.join() 等 A 干完事情，一起走。

### interrupt

打断 sleep, wait, join 的线程，这几个方法都会让线程进入阻塞状态

1. 打断 sleep 线程，会清空打断状态
2. 打断正常运行的线程，不会清空打断状态
3. 打断 park 线程，不会清空打断状态

> 可以使用 Thread.interrupted() 清除打断状态
> 

### 不推荐的方法

这些方法已经过时，容易破坏同步代码块，造成线程死锁

| 方法名 | 功能说明 |
| --- | --- |
| stop() | 停止线程运行 |
| suspend() | 挂起（暂停）线程运行 |
| resume() | 恢复线程运行 |

### 主线程与守护线程

默认情况下，Java 进程需要等待所有线程都运行结束，才会结束。有一种特殊线程叫做守护线程，只要其他非守护线程运行结束了，即使守护线程的代码没有执行完，也会强制结束。一般用于处理一些后台的工作，也叫后台线程。守护线程可以自动结束生命周期，有这种特性。

设置守护线程 t1.setDaemon(true); 垃圾回收器就是一种守护线程。

Q JVM 程序在什么情况下会退出？

Ans The Java Virtual Machine exits when the only threads running are all daemon threads.

So JVM 进程中，如果没有一个非守护线程，JVM会退出。

## 4 线程的生命周期

### 五种状态，从操作系统层面来描述

![img]({{ site.url }}/assets/images/wps4.jpg) 

![五种状态]({{ site.url }}/assets/images/JavaThread1.png)

【初始状态】仅是在语言层面创建了线程对象，还未与操作系统线程关联

【可运行状态】（就绪状态）指该线程已经被创建（与操作系统线程关联），可以由 CPU 调度执行

【运行状态】指获取了 CPU 时间片运行中的状态

- 当 CPU 时间片用完，会从【运行状态】转换至【可运行状态】，会导致线程的上下文切换

【阻塞状态】

- 如果调用了阻塞 API，如 BIO 读写文件，这是该线程实际不会用到 CPU ，会导致线程上下文切换进入【阻塞状态】
- 等 BIO 操作完毕，会由操作系统唤醒阻塞的线程，转换至【可运行状态】
- 与【可运行状态】的区别是，对【阻塞状态】的线程来说只要它们一直不唤醒，调度器就一直不会考虑调度它们

【终止状态】表示线程已经执行完毕，声明周期已经结束，不会再转换为其它状态

### 六种状态，从 Java API 层面来描述

![Untitled]({{ site.url }}/assets/images/JavaThread2.png)

![根据 Thread.State 枚举，分为六种状态]({{ site.url }}/assets/images/JavaThread3.png)

根据 Thread.State 枚举，分为六种状态

**NEW** 线程刚被创建，但还没有调用 start() 方法之前该线程根本不存在，与 new 一个对象没有区别。

**RUNNABLE** 当调用了 start() 方法之后，并 CPU 没有立刻去执行，需要听令于 CPU 的调度。这种中间状态即可执行状态（RUNNABLE），也就是具备执行资格，但是没有真正地执行起来而是在等待 CPU 的调度。

> 注意，Java API 层面的 **RUNNABLE** 状态涵盖了 操作系统 层面的【可运行状态】、【运行状态】和【阻塞状态】（由于 BIO 导致的线程阻塞，在 Java 里无法区分发，仍然认为是可运行的）
> 

**BLOCKED**，**WAITING**，**TIMED_WAITING** 都是 Java API 层面对【堵塞状态】的细分，后面会在[状态转换](https://www.notion.so/ch4-Monitor-31f3b4b19110419981f92db6bd6a2de2?pvs=21)一节详述

**TERMINATED** 当线程代码运行结束，意味着该线程的整个生命周期结束

1. 线程运行正常结束，结束生命周期
2. 线程运行出错意外结束
3. JVM Crash，导致所有的线程都结束

## ch3 本章总结

应用方面

- 异步调用：主线程执行期间，其他线程异步执行耗时操作
- 提高效率：并行计算，缩短运算时间
- 同步等待：join 实践
- 统筹规划：合理使用线程，得到最优效果

[匿名内部类](https://www.notion.so/d004d8d721ea49afa641b25aac7d212e?pvs=21)