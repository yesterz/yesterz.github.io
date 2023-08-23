# ch5 共享模型之内存

# Java 内存模型

JMM 即 Java Memory Model，它定义了主存，工作内存抽象概念，底层对应着 CPU寄存器、缓存、硬件内存、CPU 指令优化等。

JMM 体现在以下几个方面

- 原子性 - 保证指令不会受到线程上下文切换的影响
- 可见性 - 保证指令不会受 CPU 缓存影响
- 有序性 - 保证指令不会受 CPU 指令并行优化的影响

# 可见性

- 退不出的循环

main 线程对 run 变量的修改对于 t 线程不可见，导致了 t 线程无法停止：

```java
static boolean run = true;
public static void main(String[] args) {
		Thread t = new Thread(() -> {
				while(run) {
						// ....
				}
		});
		t.start();
		sleep(1);
		run = false; // 线程 t 不会如预想的停下来
}
```

**分析原因：**

1. 初始状态，t 线程刚开始从主内存读取了 run 的值到工作内存
2. 因为 t 线程要频繁从主内存读取 run 的值，JIT 编译器会将 run 的值缓存至自己工作中的高速缓存中，减少对主存中 run 的访问，提高效率
3. 1 秒之后，main 线程修改了 run 的值，并同步至主存，而 t 是从自己工作内存中的高速缓存中读取这个变量的值，结果永远是旧值

**解决办法：**

使用 `volatile` 关键字

它用来修饰成员变量和静态成员变量，他可以避免线程从自己的工作缓存中查找变量的值，必须到主存中获取它的值，线程操作 volatile 变量都是之间操作主存

## 可见性 VS 原子性

前面例子体现的实际就是可见性，它保证的是在多个线程之间，一个线程对 volatile 变量的修改对另一个线程可见，不能保证原子性，仅用在一个写线程，多个读线程的情况

```java
getstatic run // 线程 t 获取 run true 
getstatic run // 线程 t 获取 run true 
getstatic run // 线程 t 获取 run true 
getstatic run // 线程 t 获取 run true 
putstatic run // 线程 main 修改 run 为 false， 仅此一次
getstatic run // 线程 t 获取 run false
```

比较一下之前我们将线程安全时举的例子：两个线程一个 i++ 一个 i-- ，只能保证看到最新值，不能解决指令交错

```java
// 假设i的初始值为0 
getstatic i // 线程2-获取静态变量i的值 线程内i=0 
getstatic i // 线程1-获取静态变量i的值 线程内i=0 
iconst_1 // 线程1-准备常量1 
iadd // 线程1-自增 线程内i=1 
putstatic i // 线程1-将修改后的值存入静态变量i 静态变量i=1 
iconst_1 // 线程2-准备常量1 
isub // 线程2-自减 线程内i=-1 
putstatic i // 线程2-将修改后的值存入静态变量i 静态变量i=-1
```

> **注意** synchronized 语句块既可以保证代码块的原子性，也同时保证代码块内变量的可见性。但缺点是 synchronized 是属于重量级操作，性能相对更低
> 

**Q** 如果在前面示例的死循环中加入 System.out.pringln() 会发现即使不加 volatile 修饰符，线程 t 也能正确看到对 run 变量修改了，想一想为什么？

**Ans** 

在多线程编程中，当一个线程对共享变量进行修改时，其他线程并不保证立即看到这个修改，这是由于线程之间的内存可见性问题。

然而，当你在死循环中添加了**`System.out.println()`**语句时，这实际上会引入一个隐含的同步操作。在Java中，**`System.out`**是一个**`PrintStream`**对象，它的**`println()`**方法是同步的。同步方法会导致线程在进入该方法之前将本地内存中的数据与主内存中的数据进行同步，而在退出方法时再将本地内存中的数据刷新回主内存。这样，由于同步操作的影响，其他线程将能够看到在同步块内所做的修改。

这就解释了为什么你观察到的现象是即使没有使用**`volatile`**修饰符，线程**`t`**也能正确看到对**`run`**变量的修改。但是需要注意的是，这种依赖于隐含同步操作的方式并不可靠，它依赖于特定的实现细节和运行时环境，并且不能保证在所有情况下都能正确工作。

为了确保线程之间的可见性和正确性，建议使用**`volatile`**修饰符或其他同步机制（如**`synchronized`**、**`Lock`**等），这样可以明确地指示线程在访问共享变量时进行同步操作，而不依赖于隐含的同步操作。这样可以更可靠地保证多线程之间的通信和数据一致性。

## 原理之 CPU 缓存结构

### CPU 缓存结构

![Untitled](/assets/images/MemoryImages/Untitled.png)

查看 CPU 缓存 `lscpu`

![黑马老师提供的](/assets/images/MemoryImages/Untitled%201.png)

黑马老师提供的

![自己电脑的wsl](/assets/images/MemoryImages/Untitled%202.png)

自己电脑的wsl

速度比较

| 从 CPU 到 | 大约需要的时钟周期 |
| --- | --- |
| 寄存器 | 1 cycle |
| L1 | 3~4 cycle |
| L2 | 10~20 cycle |
| L3 | 40~45 cycle |
| 内存 | 120~240 cycle |

查看 CPU 缓存行

```java
cat /sys/devices/system/cpu/cpu0/cache/index0/coherency_line_size
```

![Untitled](/assets/images/MemoryImages/Untitled%203.png)

CPU 拿到的内存地址格式是这样的

```java
[高位组标记][低位索引][偏移量]
```

![Untitled](/assets/images/MemoryImages/Untitled%204.png)

### CPU 缓存读

读取数据流程如下

1. 判断低位，计算在缓存中的索引
2. 判断是否有效
    1. 0 去内存读取新数据更新缓存行
    2. 1 再对比高位组标记是否一致
        1. 一致，根据偏移量返回缓存数据
        2. 不一致，去内存读取新数据更新缓存行

### CPU 缓存原理

MESI 协议

1. E、S、M 状态的缓存行都可以满足 CPU 的读请求
2. E 状态的缓存行，有写请求，会将状态改为 M，这时并不触发向主存的写
3. E 状态的缓存行，必须监听该缓存行的读操作，如果有，要变为 S 状态
4. M 状态的缓存行，必须监听该缓存行的读操作，如果有，先将其他缓存（S 状态）中该缓存行变成 I 状态（即 [f. 的流程](https://www.notion.so/ch5-f8cd735f94f64692b1a22ebb18e2895f?pvs=21)），写入主存，自己变为 S 状态
5. S 状态的缓存行，有写请求，走 [d. 的流程](https://www.notion.so/ch5-f8cd735f94f64692b1a22ebb18e2895f?pvs=21)
6. S 状态的缓存行，必须监听该缓存行的失效操作，如果有，自己变为 I 状态
7. I 状态的缓存行，有读请求，必须从主存读取

![Untitled](/assets/images/MemoryImages/Untitled%205.png)

![Untitled](/assets/images/MemoryImages/Untitled%206.png)

没看懂的两张图

## 内存屏障

Memory Barrier（Memory Fence）

- 可见性
    - 写屏障（sfence）保证在该屏障之前的，对共享变量的改动，都同步到主存中
    - 而读屏障（lfence）保证在该屏障之后，对共享变量的读取，加载的是主存中最新数据
- 有序性
    - 写屏障会确保指令重排序时，不会将写屏障之前的代码排在写屏障之后
    - 读屏障会确保指令重排序时，不会将读屏障之后的代码排在读屏障之前

![Untitled](/assets/images/MemoryImages/Untitled%207.png)

# 有序性

JVM 会在不影响正确性的前提下，可以调整语句的执行顺序，思考下面一段代码

```java
static int i;
static int j;

// 在某个线程内执行如下赋值操作
i = ...;
j = ...;
```

可以看到，至于是先执行 i 还是 先执行 j，对最终的结果不会产生影响。所以，上面代码真正执行时，既可以是

```java
i = ...;
j = ...;
```

也可以是

```java
j = ...;
i = ...;
```

这种特性称之为“指令重排”，多线程下“指令重排”会影响正确性。为什么要有指令重排这项优化呢？从 CPU 执行指令的原理来理解

## 原理之指令级并行【TODO】

## volatile 修饰的变量，可以禁用指令重排

## 原理之 volatile

volatile 的底层实现原理是内存屏障，Memory Barrier（Memory Fence）

1. 对 volatile 变量的写指令后会加入写屏障
2. 对 volatile 变量的读指令前会加入读屏障

### **如何保证可见性**

写屏障（sfence）保证在该屏障之前的，对共享变量的改动，都同步到主存当中

```java
public void actor2(I_Result r) {
		num = 2;
		ready = true; // ready 是 volatile 赋值带写屏障
		// 写屏障
}
```

而读屏障（lfence）保证在该屏障之后，对共享变量的读取，加载的是主存中最新数据

```java
public void actor1(I_Result r) {
		// 读屏障
		// ready 是 volatile 读取值带读屏障
		if(ready) {
				r.r1 = num + num;
		} else {
				r.r1 = 1;
		}
}
```

![Untitled](/assets/images/MemoryImages/Untitled%208.png)

### 如何保证有序性

写屏障会确保指令重排序时，不会将写屏障之前的代码排在屏障之后

```java
public void actor2(I_Result r) {
		num = 2;
		ready = true; // ready 是 volatile 赋值带写屏障
		// 写屏障
}
```

读屏障会确保指令重排序时，不会将读屏障之后的代码排在读屏障之前

```java
public void actor1(I_Reasult) {
		// 读屏障
		// ready 是 volatile 读取值带读屏障
		if(ready) {
				r.r1 = num + num;
		} else {
				r.r1 = 1;
		}
}
```

![Untitled](/assets/images/MemoryImages/Untitled%209.png)

还是那句话，不能解决指令交错：

1. 写屏障仅仅是保证之后的读能读到最新的结果，但不能保证读跑到它前面去
2. 而有序性的保证也只是保证了本线程内相关代码不被重排序

![Untitled](/assets/images/MemoryImages/Untitled%2010.png)

### dcl问题 (double-check locking)

以著名的 double-checked locking 单例模式为例

```java
public final class Singleton {
    private Singleton() { }
    private static Singleton INSTANCE = null;
    public static Singleton getInstance() {
        if(INSTANCE == null) { // t2
            // 首次访问会同步，而之后的使用没有 synchronized
            synchronized(Singleton.class) {
                if (INSTANCE == null) { // t1
                    INSTANCE = new Singleton();
                }
            }
        }
        return INSTANCE;
    }
}
```

以上实现特点是：

1. 懒惰实例化
2. 首次使用 getInstance() 才使用 synchronized 加锁，后续使用时无需加锁
3. 有隐含的，但很关键的一点：第一个 if 使用了 INSTANCE 变量，是在同步块之外

但在多线程环境下，上面代码有问题 INSTANCE 的读取值什么的操作会发生指令重排

### double-checked locking 解决

```java
public final class Singleton {
    private Singleton() { }
    private static volatile Singleton INSTANCE = null;
    public static Singleton getInstance() {
        // 实例没创建，才会进入内部的 synchronized 代码块
        if(INSTANCE == null) {
            // 首次访问会同步，而之后的使用没有 synchronized
            synchronized(Singleton.class) { // t2
                // 也许有其他线程已经创建实例，所以再次判断
                if (INSTANCE == null) { // t1
                    INSTANCE = new Singleton();
                }
            }
        }
        return INSTANCE;
    }
}
```

字节码上看不出来 volatile 指令的效果

```java
// -------------------------------------> 加入对 INSTANCE 变量的读屏障
0: getstatic #2 // Field INSTANCE:Lcn/itcast/n5/Singleton;
3: ifnonnull 37
6: ldc #3 // class cn/itcast/n5/Singleton
8: dup
9: astore_0
10: monitorenter -----------------------> 保证原子性、可见性
11: getstatic #2 // Field INSTANCE:Lcn/itcast/n5/Singleton;
14: ifnonnull 27
17: new #3 // class cn/itcast/n5/Singleton
20: dup
21: invokespecial #4 // Method "<init>":()V
24: putstatic #2 // Field INSTANCE:Lcn/itcast/n5/Singleton;
// -------------------------------------> 加入对 INSTANCE 变量的写屏障
27: aload_0
28: monitorexit ------------------------> 保证原子性、可见性
29: goto 37
32: astore_1
33: aload_0
34: monitorexit
35: aload_1
36: athrow
37: getstatic #2 // Field INSTANCE:Lcn/itcast/n5/Singleton;
40: areturn
```

如上面的注释内容所示，读写 volatile 变量时会加入内存屏障（Memory Barrier（Memory Fence）），保证下面两点：

1. 可见性
    1. 写屏障（sfence）保证在该屏障之前的 t1 对共享变量的改动，都同步到主存当中
    2. 而读屏障（lfence）保证在该屏障之后 t2 对共享变量的读取，加载的是主存中最新数据
2. 有序性
    1. 写屏障会确保指令重排序时，不会将写屏障之前的代码排在写屏障之后
    2. 读屏障会确保指令重排序时，不会将读屏障之后的代码排在读屏障之前
3. 更底层是读写变量时使用 lock 指令来多核 CPU 之间的可见性与有序性

![Untitled](/assets/images/MemoryImages/Untitled%2011.png)

## happens-before 原则

happens-before 规定了对共享变量的**写**操作对其它线程的**读**操作可见，它是可见性与有序性的一套规则总结，抛开以下 happens-before 规则，JMM 并不能保证一个线程对共享变量的写，对于其它线程对该共享变量的读可见

- 线程解锁 m 之前对变量的写，对于接下来对 m 加锁的其它线程对该变量的读可见

```java
static int x;
static object m = new Object();

new Thread(() -> {
		synchronized(m) {
				x = 10;
		}
}, "t1").start();

new Thread(() -> {
		synchronized(m) {
				System.out.println(x);
		}
}, "t2").start();
```

- 线程对 volatile 变量的写，对接下来其它线程对该变量的读可见

```java
volatile static int x;

new Thread(() -> {
		x = 10;
}, "t1").start();

new Thread(() -> {
		System.out.println(x);
}, "t2").start();
```

- 线程 start 前对变量的写，对该线程开始后对该变量的读可见

```java
static int x;
x = 10;
new Thread(() -> {
		System.out.println(x);
}, "t2").start();
```

- 线程结束前对变量的写，对其它线程得知它结束后的读可见（比如其它线程调用 t1.isAlive() 或 t1.join() 等待它结束）

```java
static int x;
Thread t1 = new Thread(() -> {
		x = 10;
}, "t1");
t1.start();
t1.join();
System.out.println(x);
```

- 线程 t1 打断 t2（interrupt）前对变量的写，对于其它线程得知 t2 被打断后对变量的读可见（通过 t2.interrupted 或 t2.isInterrupted ）

```java
static int x;
public static void main(String[] args) {
		Thread t2 = new Thread(()->{
				while(true) {
						if(Thread.currentThread().isInterrupted()) {
								System.out.println(x);
								break;
						} // end if
				} // end while
		},"t2");
		t2.start();
		new Thread(()->{
				sleep(1);
				x = 10;
				t2.interrupt();
		},"t1").start();

		 while(!t2.isInterrupted()) {
				 Thread.yield();
		 } // end while
		 System.out.println(x);
} // end main
```

- 对变量默认值（0，false，null）的写，对其它线程对该变量的读可见
- 具有传递性，如果 [x hb→ y](https://www.notion.so/ch5-f8cd735f94f64692b1a22ebb18e2895f?pvs=21) 并且 y hb→ z 那么有 x hb→ z，配合 volatile 的防指令重排，有下面的例子

```java
volatile static int x;
static int y;

new Thread(() -> {
		y = 10;
		x = 20;
},"t1").start();

new Thread(() -> {
		// x=20 对 t2 可见，同时 y=10 也对 t2 可见
		System.out.println(x);
},"t2").start();
```

> 变量都是指的是成员变量或静态成员变量
> 

**Q** happens-before 规则，有什么

**Ans** 

happens-before 规则是一种在多线程编程中用于描述操作顺序和可见性的规则。它定义了对于不同线程执行的操作，哪些操作一定在另一些操作之前发生，并且哪些操作的结果对于另一些操作可见。

具体来说，以下是 happens-before 规则的几个关键点：

1. 程序顺序规则：同一个线程内的操作，按照程序的书写顺序执行，因此后面的操作 happens-before 前面的操作。
2. volatile 变量规则：对一个 volatile 变量的写操作 happens-before 后续对该变量的读操作，因为 volatile 变量的写入操作对其他线程是立即可见的。
3. 锁规则：对于一个锁的解锁操作 happens-before 后续对该锁的加锁操作，因为解锁操作的发生意味着该锁中的所有操作都已完成，加锁操作需要等待这些操作完成后才能开始。
4. 线程启动规则：一个线程的启动操作 happens-before 该线程内的任意操作。
5. 线程终止规则：一个线程内的任意操作 happens-before 该线程的终止操作。
6. 中断规则：一个线程内的中断操作 happens-before 该线程检查到中断事件的发生。
7. 线程终止后规则：一个线程的终止操作 happens-before 任何其他线程检查到该线程已经终止的操作。

了解 happens-before 规则可以帮助开发者在编写多线程程序时更好地控制操作的执行顺序和可见性，避免出现不一致的问题。

**Q** x hb→ y 是什么意思

**Ans** 

"x hb→ y" 是一个表示 happens-before（先行发生）关系的符号表示法。

在多线程并发编程中，happens-before关系用于描述事件之间的顺序关系。如果事件 x happens-before 事件 y，则可以推断出 x 在时间上先于 y 发生。

具体地，x hb→ y 表示事件 x happens-before 事件 y。这意味着在多线程环境下，如果事件 x hb→ y，则对于所有线程来说，观察到事件 x 发生的结果将在观察到事件 y 发生的结果之前可见。

happens-before关系可以通过以下方式建立：

1. 程序顺序规则：同一个线程中，按照程序的顺序，前一个操作 happens-before 后一个操作。
2. 监视器锁规则：对一个监视器锁的解锁操作 happens-before 后续对同一个监视器锁的加锁操作。
3. volatile变量规则：对一个 volatile 变量的写操作 happens-before 后续对同一个 volatile 变量的读操作。
4. 线程启动规则：线程的启动操作 happens-before 该线程中的任意操作。
5. 线程终止规则：线程的所有操作 happens-before 其他线程检测到该线程已经终止。
6. 中断规则：对线程 interrupt() 方法的调用 happens-before 被中断线程的代码检测到中断事件的发生。
7. 终结规则：一个对象的构造函数的结束 happens-before 该对象的 finalize() 方法的开始。
8. 传递性：如果事件 A hb→ 事件 B，并且事件 B hb→ 事件 C，则可以推断事件 A hb→ 事件 C。

"happens-before" 关系是并发编程中的一个重要概念，它帮助我们理解和推断多线程程序中各个操作之间的顺序关系，以确保程序的正确性和可靠性。

# ch5 章节小结 如图

![Untitled](/assets/images/MemoryImages/Untitled%2012.png)