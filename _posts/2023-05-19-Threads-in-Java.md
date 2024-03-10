---
title: Java 中的线程
categories: [Concurrent Programming]
tags: [Concurrent Programming]
toc: true
img_path: /assets/images/
---

## 1 创建和运行线程

每个 Java 程序一启动的时候，实际上就有一个线程在运行即主方法线程，默认就有一个主线程在运行了，如果想要在主线程之外再创建线程可以有如下方法。

**创建和启动分两步走。**

**这里有三种方法**
1. 继承 Thread 类并重写 `run()` 方法；
2. 实现 Runnable 接口的 `run()` 方法；
3. 使用 FutureTask 的方式。

### a 直接使用 Thread

```java
public class ThreadTest {

    // 继承 Thread 类并重写 run 方法
    public static class MyThread extends Thread {
        @Override
        public void run() {
            System.out.println("I am a child thread");
        }
    }

    public static void main(String[] args) {

        // 创建线程
        MyThread thread = new MyThread();

        // 启动线程
        thread.start();
    }
}
```

这里其实是**匿名内部类的写法**，创建的是 Thread 的一个子类，并且要覆盖其中的 run 方法。

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
		// run 方法内实现了要执行的任务
		@Override
		public void run() {
			log.debug("hello");
		}
};
t1.start();
```

> **注意：** 当创建完 Thread 对象后该线程并没有被启动执行，直到调用了`start()`方法后才真正启动了线程。
{: .prompt-info }

其实调用`start()`方法后线程并没有马上执行而是处于就绪状态，这个就绪状态是指该线程已经获取了除 CPU 资源外的其他资源，等待获取 CPU 资源后才会真正处于运行状态。一旦`run()`方法执行完毕，该线程就处于终止状态。

- [ ] 更新匿名内部类的写法

Q 匿名内部类的写法 [Ans](https://www.notion.so/d004d8d721ea49afa641b25aac7d212e?pvs=21)

### b 使用 Runnable 配合 Thread

把 线程 和 任务（要执行的代码）分开

1. Thread 代表线程
2. Runnable 可运行的任务（线程要执行的代码）

```java
    public static class RunnableTask implements Runnable {

        @Override
        public void run() {
            System.out.println("I am a child thread");
        }
    }

    public static void main(String[] args) throws InterruptedException {

        Runnable task = new RunnableTask();
        new Thread(task).start();
        new Thread(task).start();
    }
```

**匿名内部类的写法：**

```java
Runnable runnable = new Runnable() {
    @Override
    public void run() {
        // 要执行的任务
    }
};
// 创建线程对象
Thread t = new Thread(runnable);
// 启动线程
t.start();
```

**例如：**

```java
// 创建任务对象
Runnable task2 = new Runnable() {
    @Override
    public void run() {
        log.debug("hello");
    }
};

// 参数1 是任务对象；参数2 是线程名字，推荐此写法
Thread t2 = new Thread(task2, "t2");
t2.start();
```

**Java 8 之后可以使用 lambda 表达式精简代码**

```java
// 创建任务对象
Runnable task2 = () -> log.debug("hello");

// 参数1 是任务对象；参数2 是线程名字，推荐
Thread t2 = new Thread(task2, "t2");
t2.start();
```

- [ ]  Q lambda 表达式？ Ans

### Thread 与 Runnable 的关系

**Runnable 接口源码：只定义了一个无参数返回值的 run 方法**

```java
package java.lang;

public interface Runnable {
    void run();
}
```

JDK 中代表线程的只有 Thread 这个类，线程的执行单元就是 run 方法。

**创建线程的两种方式**所以说两种方法实现自己的业务逻辑

1. 可以通过继承 Thread 类，然后重写 run 方法来实现自己的业务逻辑
2. 也可以实现 Runnable 接口实现自己的业务逻辑

**Thread run 方法的源码**

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

**源码总结：**
- 创建线程只有一种方式即构造 Thread 类
- 实现线程的执行单元则有两种方式
    1. 重写 Thread 的 run 方法
    2. 实现 Runnable 接口的 run 方法，并且将 Runnable 实例用作构造 Thread 的参数。

使用继承方式的好处是`run()`方法内获取当前线程直接使用 this 就可以了，无需使用`Thread.currentThread()`方法；不好的地方是 Java 不支持多继承，如果继承了 Thread 类，那么就不能再继承其他类。另外任务与代码没有分离，当多个线程执行一样的任务时需要多份任务代码，而 Runnable 则没有这个限制。这两种方式都有一个缺点，就是任务没有返回值。

**总结**
1. 方法1（继承 Thread 类）是把线程和任务合并在了一起，方法2（实现 Runnable 接口）是把线程和任务分开了
2. 用 Runnable 更容易与线程池等高级 API 配合
3. 用 Runnable 让任务类脱离了 Thread 继承体系，更灵活

### c FutureTask 配合 Thread

```java
    // 创建任务类，类似 Runnable
    public static class CallerTask implements Callable<String> {

        @Override
        public String call() throws Exception {
            return "Hello";
        }
    }

    public static void main(String[] args) throws InterruptedException {
        // 创建异步任务
        FutureTask<String> futureTask = new FutureTask<>(new CallerTask());
        // 启动线程
        new Thread(futureTask).start();
        try {
            // 等待任务执行完毕，并返回结果
            String result = futureTask.get();
            System.out.println(result);
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
    }
```

如上代码中的 CallerTask 类实现了 Callable 接口的`call()`方法。在 main 函数内首先创建了一个 Futrue Task 对象（构造函数为 CallerTask 实例）然后使用创建的 FutrueTask 对象作为任务创建了一个线程并且启动它，最后通过`futureTask.get()`等待任务执行完毕并返回结果

FutureTask 能够接收 Callable 类型的参数，用来处理有返回结果的情况

lambda 表达式的写法

```java
// 创建任务对象
FutureTask<String> futureTask = new FutureTask<>(() -> {
    return "Hello";
});

// 参数1 是任务对象；参数2 是线程名字，推荐使用
new Thread(futureTask, "Task3").start();

// 主线程堵塞，同步等待 task 执行完毕的结果
String result = futureTask.get();
log.debug("结果是:{}", result);
```
### 三种方法的小结
1. 使用继承方式好处是方便传参，可以在子类里面添加成员变量，通过 set 方法设置参数或者通过构造函数进行传递。
2. 使用 Runnable 方式，则只能使用主线程里面被声明为 final 的变量。
3. Java 不支持多继承，如果继承了 Thread 类，那么子类不能再继承其他类，Runnable 则没有这个限制。
4. 前面两种方式都没办法拿到任务的返回结果，但是 FutureTask 方式可以。

## 2 查看线程

### Windows

1. 任务管理器 可以查看进程和线程数，也可以用来杀死进程
2. tasklist 查看进程
3. taskkill 杀死进程

### Linux

1. `ps -ef` 查看所有进程
2. `ps -fT -p <PID>` 查看某个进程（PID）的所有进程
3. `kill` 杀死进程
4. `top` 按大写 H 切换是否显示线程
5. `top -H -p <PID>` 查看某个进程（PID）的所有线程

### Java

1. `jps` 命令查看所有 Java 进程
2. `jstack <PID>` 查看某个Java进程（PID）的所有线程状态
3. `jconsole` 来查看某个 Java 进程中线程的运行情况（图形界面）

jconsole 远程监控配置
需要以如下方式运行你的 java 类

```console
java -Djava.rmi.server.hostname='ip地址' -Dcom.sun.management.jmxremote \
-Dcom.sun.management.jmxremote.port='连接端口' \
-Dcom.sun.management.jmxremote.ssl=是否安全连接 \
-Dcom.sun.management.jmxremote.authenticate=是否认证 java类
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

在多线程编程中，线程个数一般都大于 CPU 个数，而每个 CPU 同一时刻只能被一个线程使用，为了让用户感觉多个线程是在同时执行的， CPU 资源的分配采用了时间片轮转策略，也就是给每个线程分配一个时间片，线程在时间片内占用 CPU 执行任务。

当线程使用完时间片后，就会处于就绪状态并让出 CPU 让其他线程占用，这就是上下文切换从当前线程的上下文切换到了其他线程。


因为以下一些原因导致 CPU 不在执行当前的线程，转而执行另一个线程的代码

1. 当前线程的 CPU 时间片使用完处于就绪状态；
2. 垃圾回收；
3. 有更高优先级的线程需要运行，当前线程被其他线程中断时；
4. 线程自己调用了 sleep、yield、wait、join、park、synchronized、lock等方法。

那么就有一个问题，让出 CPU 的线程等下次轮到自己占有 CPU 时如何知道自己之前运行到哪里了？所以在切换线程上下文时需要保存当前线程的执行现场，当再次执行时根据保存的执行现场信息恢复执行现场。

当 Context Switch 发生时，需要由操作系统保存当前线程的状态，并恢复另一个线程的状态，Java 中对应的概念就是程序计数器（Program Counter Register），它的作用是记住下一条 JVM 指令的执行地址，**是线程私有的。**

1. 状态包括程序计数器、虚拟机栈中每个栈帧的信息，如局部变量、操作数栈、返回地址等
2. Context Switch 频繁发生会非常**影响性能**

## 3 Thread API

Thread API docs <https://docs.oracle.com/javase/8/docs/api/java/lang/Thread.html>

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

### wait & notify

线程通知与等待

**wait() 函数**

当一个线程调用一个共享变量`wait()`方法时，该调用线程会被阻塞挂起，到发生下面几件事情之一才返回：

1. 线程调用了该共享对象`notify()`或者`notifyAll()`方法；
2. 其他线程调用了该线程`interrupt()`方法，该线程抛出 interruptedException 异常返回。

另外需要注意的是，如果调用`wait()`方法的线程没有事先获取该对象的监视器锁，则调用`wait()`方法时调用线程会抛出 IllegalMonitorStateException 异常。

### start & run

直接上总结，区别在于 start 启动新线程，run 没有启动新线程

1. 直接调用 run 是在主线程中执行了 run，**没有启动新的线程**
2. 使用 start 是**启动新的线程**，通过新的线程间接执行 run 中的代码

### sleep & yield

Thread 类中有一个静态的 sleep 方法，当一个执行中的线程调用了 Thread 的 sleep 方法后，调用线程会暂时让出指定时间的执行权，也就是在这期间不参与 CPU 的调度，但是该线程所拥有的监视器资源，比如锁还是持有不让出的。
指定的睡眠时间到了后该函数会正常返回，线程就处于就绪状态，然后参与 CPU 的调度，获取到 CPU 资源后就可以继续运行了。如果在睡眠期间其他线程调用了该线程的`interrupt()`方法中断了该线程，则该线程会在调用 sleep 方法的地方抛出 InterruptedException 异常而返回。

**sleep**
    1. 调用 sleep 会让当前线程从 RUNNING 进入 TIMED_WAITING 状态（阻塞）
    2. 其他线程可以使用 interrupt 方法打断正在睡眠的线程，这时 sleep 方法会抛出 InterruptedException
    3. 睡眠结束后的线程未必会立刻得到执行
    4. 建议用 TimeUnit 的 sleep 代替 Thread 的 sleep 来获得更好的可读性
    5. ❗❗❗不会放弃 monitor 锁的所有权 

> 枚举 TimeUnit，对 sleep 方法提供了很好的封装，可以省去时间换算步骤。
{: .prompt-info }


```java
Thread.sleep(12257088L);
TimeUnit.HOURS.sleep(3);
TimeUnit.MINUTES.sleep(24);
TimeUnit.SECONDS.sleep(17);
TimeUnit.MILLISECONDS.sleep(88);
```

**使用 Thread.sleep 的地方可以完全使用 TimeUnit 来代替。**

**yield**
    1. 调用 yield 会让当前线程从 RUNNING 进入 RUNNABLE 就绪状态，然后调度执行其他线程
    2. 具体的实现依赖于操作系统的任务调度器

让出 CPU 执行权的 yield 方法

yield 是一个启发式方法，其会提醒调度器我愿意放弃当前的 CPU 资源，如果 CPU 的资源不紧张，则会忽略这种提醒，这个方法不太常用，yield 只是一个提示（hint），CPU 调度器并不会担保每次都能满足 yield 提示，也就是说每次 yield 想让出此时的 CPU 资源任务调度器并不是每次都能满足，如果 CPU 资源比较空闲，yield 后还是会运行当前线程，并不会让出去。

**sleep & yield 总结**
    1. sleep 会导致当前线程暂停指定的时间，没有 CPU 时间片的消耗
    2. yield 只是对 CPU 调度器的一个提示，如果 CPU 调度器没有忽略这个提示，它会导致线程上下文的切换
    3. sleep 会使线程短暂 block，会在给定的时间内释放 CPU 资源
    4. yield 会使 RUNNING 状态的 Thread 进入 RUNNABLE 状态（如果 CPU 调度器没有忽略这个提示的话）
    5. sleep 几乎百分之百完成了给定时间的休眠，而 yield 的提示并不能一定担保
    6. 一个线程 sleep 另一个线程调用 interrupt 会捕获到中断信号，而 yield 则不会

**线程优先级**
    1. 线程优先级会提示（hint）调度器优先调度该线程，但它仅仅是一个提示，调度器可以忽略它
    2. 如果 CPU 比较忙，那么优先级高的线程会获得更多的时间片，但 CPU 闲时，优先级几乎没作用

### join

等待线程执行终止的 join 方法

```java
public final void join() throws InterruptedException
public final synchronized void join(long millis, int nanos) throws InterruptedException
public final synchronized void join(long millis) throws InterruptedException
```

join 方法是一个可中断的方法，如果有线程执行了对当前线程的 interrupt 操作，它也会捕获到中断信号，并且擦除线程的 interrupt 标识

join 某个线程A（线程A.join()），会使当前线程B进入等待，直到线程A结束生命周期，或者到达给定时间，那么在此期间B线程是处于 BLOCKED 的，而不是A线程。

**大白话：**A.join() 就是当前线程B等 A 搞完事情再一起加入（join）再往下运行，此时当前线程是 BLOCKED 的。B到了 A.join() 等 A 干完事情，一起走。

### 线程中断

Java 中的线程中断是一种线程间的协作模式，通过设置线程的中断标志并不能直接终止该线程的执行，而是被中断的线程根据中断状态自行处理。

打断 sleep, wait, join 的线程，这几个方法都会让线程进入阻塞状态

1. 打断 sleep 线程，会清空打断状态
2. 打断正常运行的线程，不会清空打断状态
3. 打断 park 线程，不会清空打断状态

> 可以使用 Thread.interrupted() 清除打断状态
{: .prompt-info }

* `void interrupted()`方法：中断线程，例如，当线程 A 运行时，线程 B 可以调用线程 A 的 interrupted() 方法来设置线程的中断标志为 true 并立即返回。设置标志仅仅是为了设置标志，线程 A 实际并没有被中断，它会继续往下执行，如果线程 A 因为调用了 wait() 方法，join() 方法或者 sleep() 方法而引起的阻塞挂起，这时候若线程 B 调用线程 A 的 interrupted() 方法，线程 A 会在调用这些方法的地方会抛出 InterruptedException 异常而返回。

* `boolean isInterrupted()`方法：检测当前线程是否被中断，如果是返回 true，否则返回 false。

```java
public boolean isInterrupted() {
    // 传递 false，说明不清除中断标志
    return isInterrupted(false);
}
```

* `boolean intertupted()`方法：检测当前线程是否被中断，如果是返回 true，否则返回 false。与isInterrupted() 不同的是，该方法如果发现线程被中断，则会清除中断标志，并且该方法是 static 方法，可以通过 Thread 类直接调用。

```java
public static boolean interrupted() {
    // 清除中断标志
    return currentThread().isInterrupted(true);
}
```

### 不推荐的方法

这些方法已经过时，容易破坏同步代码块，造成线程死锁

| 方法名 | 功能说明 |
| --- | --- |
| stop() | 停止线程运行 |
| suspend() | 挂起（暂停）线程运行 |
| resume() | 恢复线程运行 |

## 4 守护线程与用户线程

Java 中的线程分为两类，分别为 daemon 线程（守护线程〉和 user 线程（用户线程）。

在 JVM 启动时会调用 main 函数，main 函数所在的钱程就是一个用户线程，其实在 JVM 内部同时还启动了好多守护线程，比如垃圾回收线程。

那么守护线程和用户线程有什么别呢？区别之一是当最后一个非守护线程结束时，JVM 正常退出，而不管当前是否有守护线程，也就是说守护线程是否结束并不影响 JVM 退出。言外之意，只要有一个用户线程还没结束，正常情况下 JVM 就不会退出。

默认情况下，Java 进程需要等待所有线程都运行结束，才会结束。有一种特殊线程叫做守护线程，只要其他非守护线程运行结束了，即使守护线程的代码没有执行完，也会强制结束。一般用于处理一些后台的工作，也叫后台线程。守护线程可以自动结束生命周期，有这种特性。

设置守护线程 t1.setDaemon(true); 

垃圾回收线程就是一种守护线程。

Q JVM 程序在什么情况下会退出？

Ans The Java Virtual Machine exits when the only threads running are all daemon threads.

So JVM 进程中，如果没有一个非守护线程，JVM会退出。

## 5 线程的生命周期

Thread.State docs <https://docs.oracle.com/javase/8/docs/api/java/lang/Thread.State.html>

### 五种状态，从操作系统层面来描述

![五种状态](Threads-in-Java/javaThread1.png)

1. **初始状态：**仅是在语言层面创建了线程对象，还未与操作系统线程关联线程
2. **可运行状态：**（就绪状态）指该线程已经被创建（与操作系统线程关联），可以由 CPU 调度执行

3. **运行状态：**指获取了 CPU 时间片运行中的状态

    - 当 CPU 时间片用完，会从【运行状态】转换至【可运行状态】，会导致线程的上下文切换

4. **阻塞状态：**

    - 如果调用了阻塞 API，如 BIO 读写文件，这是该线程实际不会用到 CPU ，会导致线程上下文切换进入【阻塞状态】
    - 等 BIO 操作完毕，会由操作系统唤醒阻塞的线程，转换至【可运行状态】
    - 与【可运行状态】的区别是，对【阻塞状态】的线程来说只要它们一直不唤醒，调度器就一直不会考虑调度它们

5. **终止状态：**表示线程已经执行完毕，声明周期已经结束，不会再转换为其它状态

### 六种状态，从 Java API 层面来描述

![Untitled](Threads-in-Java/javaThread2.png)

![根据 Thread.State 枚举，分为六种状态](Threads-in-Java/javaThread3.png)

根据 Thread.State 枚举，分为六种状态

**NEW** 线程刚被创建，但还没有调用 start() 方法之前该线程根本不存在，与 new 一个对象没有区别。

**RUNNABLE** 当调用了 start() 方法之后，并 CPU 没有立刻去执行，需要听令于 CPU 的调度。这种中间状态即可执行状态（RUNNABLE），也就是具备执行资格，但是没有真正地执行起来而是在等待 CPU 的调度。

> 注意，Java API 层面的 **RUNNABLE** 状态涵盖了 操作系统 层面的【可运行状态】、【运行状态】和【阻塞状态】（由于 BIO 导致的线程阻塞，在 Java 里无法区分发，仍然认为是可运行的）
{: .prompt-info }

**BLOCKED**，**WAITING**，**TIMED_WAITING** 都是 Java API 层面对【堵塞状态】的细分，后面会在状态转换一节详述

**TERMINATED** 当线程代码运行结束，意味着该线程的整个生命周期结束

1. 线程运行正常结束，结束生命周期
2. 线程运行出错意外结束
3. JVM Crash，导致所有的线程都结束

## 本章总结

应用方面

- 异步调用：主线程执行期间，其他线程异步执行耗时操作
- 提高效率：并行计算，缩短运算时间
- 同步等待：join 实践
- 统筹规划：合理使用线程，得到最优效果

[匿名内部类](https://www.notion.so/d004d8d721ea49afa641b25aac7d212e?pvs=21)