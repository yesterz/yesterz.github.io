---
title: 8个经典的Java多线程编程题目
date: 2023-08-17 22:13:00 +0800
categories: [Concurrent Programming]
tags: [Concurrent Programming]
pin: false
math: false
mermaid: false
---

## Quiz-1 

线程T1执行完才开始T2，T2执行完开始T3

要求：线程A执行完才开始线程B，线程B执行完才开始线程C

### Ans

用`join()`，`wait()`和`notify()`来实现这个逻辑。
`join()`解释：join 某个线程A（线程`A.join()`），会使当前线程B进入等待，直到线程A结束生命周期，或者到达给定时间，那么在此期间B线程是处于 BLOCKED 的，而不是A线程。

**用大白话来解释：** `A.join()` 就是当前线程B等 A 搞完事情再一起加入（join）再往下运行，此时当前线程是 BLOCKED 的。B运行到了 `A.join()` 等 A 干完事情，一起走。`join()`作用就是同步，它让线程之间的并行变为串行执行。继续刚刚的例子，B线程中调用了A线程的`join()`，就是B的代码中出现了`A.join()`，这里就表示B线程这时候就要等待A线程搞完A的事情后才继续往下执行自己的代码。

- [ ] Java join() 方法的使用

## Quiz-2 

两个线程轮流打印数字，一直到100

### Ans
 创建了两个线程**thread1**和**thread2**，它们共享一个对象锁**lock**和一个静态变量`**currentNumber**`。每个线程通过检查`**currentNumber**`的值来判断是否轮到自己打印数字。如果不是轮到自己，线程就会调用`**wait()**`方法等待，直到被唤醒。如果轮到自己打印数字，线程会打印数字、增加`**currentNumber**`的值，并调用`**notifyAll()**`方法唤醒其他等待的线程。

## Quiz-3 

写两个线程，一个线程打印1~ 52，另一个线程打印A~Z，打印顺序是12A34B…5152Z

创建2个线程，一个用于打印数字的`NumberPrinter`，另一个用于打印字母的`LetterPrinter`。这两个线程共享一个对象锁`lock`，并在循环中使用`wait()`和`notifyAll()`方法来实现线程间的同步和轮流打印。加了一个名为**printNumber**的布尔变量，用于控制哪个线程可以打印。在**NumberPrinter**线程中，只有当**printNumber**为**true**时才会打印数字。在**LetterPrinter**线程中，只有当**printNumber**为**false**时才会打印字母。

## Quiz-4 

编写一个程序，启动三个线程，三个线程的ID分别是A，B，C；，每个线程将自己的ID值在屏幕上打印5遍，打印顺序是ABCABC…

思路是用`flag`成员变量来标志哪个线程来打印，分别0，1，2，比如说A判断`flag`不是0那么就调用`wait()`进入等待状态，如果`flag`满足条件等于0，那就打印字母A，然后更新`flag`为ABC顺序的下一个要打印的标志1，并调用`notifyAll()`唤醒其他线程，线程B，C类似。

## Quiz-5 

编写10个线程，第一个线程从1加到10，第二个线程从11加20…第十个线程从91加到100，最后再把10个线程结果相加。

~~实现了多线程并行计算累加和，~~并没有实现，这里的10个线程实际上是串行执行的。主线程中，用了`join()`方法来等待每个线程的执行完成，然后才继续下一个线程的创建和等待。

下面是一个并行执行的例子。
```java
public static void main(String[] args) {

    int result = 0;
    SumThread[] threads = new SumThread[10];

    for (int i = 0; i < 10; i++) {
        threads[i] = new SumThread(i);
        threads[i].start();
    }

    for (int i = 0; i < 10; i++) {
        try {
            threads[i].join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        result = result + threads[i].sum;
    }

    System.out.println("result   " + result);
}
```

## Quiz-6 三个窗口同时卖票

三个窗口同时卖票

思路：票数是一定的，卖票这个逻辑要保证同一时刻只有一个线程可以进入卖票逻辑。

## Quiz-7 生产者消费者

生产者消费者问题（英语：Producer-consumer problem），也称有限缓冲问题（英语：Bounded-buffer problem），是一个多线程同步问题的经典案例。该问题描述了共享固定大小缓冲区的两个线程——即所谓的“生产者”和“消费者”——在实际运行时会发生的问题。生产者的主要作用是生成一定量的数据放到缓冲区中，然后重复此过程。与此同时，消费者也在缓冲区消耗这些数据。该问题的关键就是要保证生产者不会在缓冲区满时加入数据，消费者也不会在缓冲区中空时消耗数据。

[生产者消费者问题]<[生产者消费者问题-Wikipedia](https://zh.wikipedia.org/zh-hans/%E7%94%9F%E4%BA%A7%E8%80%85%E6%B6%88%E8%B4%B9%E8%80%85%E9%97%AE%E9%A2%98)>

### `synchronized` 方式

思路解释 from ChatGPT

它包含一个共享的计数变量 `count`，代表当前水果的数量。`FULL` 常量表示容器的最大容量。另外，`LOCK` 是一个共享的锁对象，用于实现线程同步。

`Producer` 内部类：这个类实现了 **Runnable** 接口，表示生产者线程。在 **run()** 方法中，生产者尝试获取 **LOCK** 锁对象，然后进入一个循环，检查容器是否已满。如果容器已满，则生产者线程等待（调用 **LOCK.wait()**），直到消费者线程消耗了一些资源后，释放锁并唤醒生产者线程。一旦容器不满，生产者向容器中添加一个资源，并打印出生产者线程名称和资源数量。最后，调用 **LOCK.notifyAll()** 通知其他等待的线程（可能是生产者或消费者）。

**Consumer** 内部类：这个类也实现了 **Runnable** 接口，表示消费者线程。在 **run()** 方法中，消费者尝试获取 **LOCK** 锁对象，然后进入一个循环，检查容器是否为空。如果容器为空，则消费者线程等待（调用 **LOCK.wait()**），直到生产者线程添加了一些资源后，释放锁并唤醒消费者线程。一旦容器不空，消费者从容器中移除一个资源，并打印出消费者线程名称和资源数量。最后，调用 **LOCK.notifyAll()** 通知其他等待的线程。

**main** 方法：在主方法中，创建了一个 **FruitPlateDemo** 对象，并创建了五个生产者线程和五个消费者线程。然后，启动这些线程，模拟生产者和消费者的并发操作。

### ReentrantLock 方式（可以保证顺序）

思路解释 from ChatGPT

1. **Demo1** 类：这个类与之前的 **FruitPlateDemo** 类相似，也包含一个共享的计数变量 **count**，代表当前资源的数量，以及一个常量 **FULL** 表示容器的最大容量。它还声明了一个 **Lock** 对象 **lock** 以及两个 **Condition** 对象 **notEmptyCondition** 和 **notFullCondition**。
2. 初始化块：在类中使用初始化块（实例初始化块）来初始化 **lock** 和 **Condition** 对象。**lock** 使用了 **ReentrantLock** 类来创建可重入锁，**notEmptyCondition** 和 **notFullCondition** 分别通过 **lock** 创建了两个条件变量。
3. **Producer** 内部类：与之前示例中的 **Producer** 类相似，这个类实现了 **Runnable** 接口，表示生产者线程。在 **run()** 方法中，首先获取 **lock** 锁，然后进入一个循环，检查容器是否已满。如果容器已满，则生产者线程等待（调用 **notFullCondition.await()**），直到消费者线程消耗了一些资源后，释放锁并唤醒生产者线程。一旦容器不满，生产者向容器中添加一个资源，并打印出生产者线程名称和资源数量。最后，调用 **notEmptyCondition.signal()** 通知等待的消费者线程。
4. **Consumer** 内部类：与之前示例中的 **Consumer** 类相似，这个类实现了 **Runnable** 接口，表示消费者线程。在 **run()** 方法中，首先获取 **lock** 锁，然后进入一个循环，检查容器是否为空。如果容器为空，则消费者线程等待（调用 **notEmptyCondition.await()**），直到生产者线程添加了一些资源后，释放锁并唤醒消费者线程。一旦容器不空，消费者从容器中移除一个资源，并打印出消费者线程名称和资源数量。最后，调用 **notFullCondition.signal()** 通知等待的生产者线程。
5. **main** 方法：在主方法中，创建了一个 **Demo1** 对象，并创建了五个生产者线程和五个消费者线程。然后，启动这些线程，模拟生产者和消费者的并发操作。
6. 
### BlockingQueue 方式

思路解释 from ChatGPT

1. **Demo2** 类：这个类与之前的示例相似，包含一个计数变量 **count** 和一个 **BlockingQueue** 接口的实现类 **ArrayBlockingQueue** 对象 **queue**，用于存储资源。
2. **main** 方法：在主方法中，创建了一个 **Demo2** 对象，并创建了五个生产者线程和五个消费者线程。然后，启动这些线程，模拟生产者和消费者的并发操作。
3. **Producer** 内部类：这个类实现了 **Runnable** 接口，表示生产者线程。在 **run()** 方法中，首先调用 **queue.put(1)** 将一个资源添加到队列中。如果队列已满，**put** 方法会阻塞直到队列有空间。然后增加 **count** 变量，并打印生产者线程名称和资源数量。
4. **Consumer** 内部类：这个类实现了 **Runnable** 接口，表示消费者线程。在 **run()** 方法中，首先调用 **queue.take()** 从队列中取出一个资源。如果队列为空，**take** 方法会阻塞直到队列有元素。然后减少 **count** 变量，并打印消费者线程名称和资源数量。
5. 
## Quiz-8

思路解释 from ChatGPT

1. **TwoArr** 类：这个类包含两个数组 **arr1** 和 **arr2**，以及一个布尔标志 **flag**。**flag** 用于控制两个线程的交替执行。
2. **print1()** 方法：这个方法在一个同步块中，使用 **synchronized** 关键字来确保线程安全。在方法中，首先使用 **while** 循环等待，直到 **flag** 变为 **false**。当 **flag** 为 **false** 时，表示轮到 **print1()** 方法执行，就开始打印 **arr1** 数组的元素，然后将 **flag** 变为 **true**，并唤醒其他等待的线程。最后，**print1()** 方法释放锁，允许其他线程进入同步块。
3. **print2()** 方法：这个方法与 **print1()** 方法类似，但是它等待的条件是 **flag** 为 **true**。当 **flag** 为 **true** 时，表示轮到 **print2()** 方法执行，就开始打印 **arr2** 数组的元素，然后将 **flag** 变为 **false**，并唤醒其他等待的线程。
4. **main** 方法：在主方法中，创建了一个 **TwoArr** 对象，然后创建两个线程分别调用 **print1()** 和 **print2()** 方法。这样两个线程会交替地打印数组元素。
5. 
## 8个题目代码实现

### Quiz-1 代码实现如下

```java
public class TestQuiz1 {
    
    public static class PrintThread extends Thread {
        PrintThread(String name) {
            super(name);
        }
        
        @Override
        public void run() {
            for (int i = 0; i < 100; i++) {
                System.out.print(getName() + ": " + i);
                System.out.printf(" ");
            }
            System.out.println();
        }
    }

    public static void main(String[] args) {
        
        PrintThread t1 = new PrintThread("A");
        PrintThread t2 = new PrintThread("B");
        PrintThread t3 = new PrintThread("C");

        try {
            t1.start();
            t1.join();

            t2.start();
            t2.join();

            t3.start();
            t3.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}

```

### Quiz-2 代码实现如下

```java
public class AlternatePrinting {
    private static final int MAX_NUMBER = 100;
    private static final Object lock = new Object();
    private static int currentNumber = 1;

    public static void main(String[] args) {
        Thread thread1 = new Thread(new NumberPrinter(1));
        Thread thread2 = new Thread(new NumberPrinter(2));

        thread1.start();
        thread2.start();
    }

    static class NumberPrinter implements Runnable {
        private final int threadNumber;

        public NumberPrinter(int threadNumber) {
            this.threadNumber = threadNumber;
        }

        @Override
        public void run() {
            while (currentNumber <= MAX_NUMBER) {
                synchronized (lock) {
                    if (currentNumber % 2 != threadNumber - 1) {
                        try {
                            lock.wait();
                        } catch (InterruptedException e) {
                            Thread.currentThread().interrupt();
                        }
                    } else {
                        System.out.println("Thread " + threadNumber + ": " + currentNumber);
                        currentNumber++;
                        lock.notifyAll();
                    }
                }
            }
        }
    }
}

```

### Quiz-3 代码实现如下

```java
public class AlternatePrinting {
    private static final Object lock = new Object();
    private static int number = 1;
    private static char letter = 'A';
    private static boolean printNumber = true;

    public static void main(String[] args) {
        Thread numberThread = new Thread(new NumberPrinter());
        Thread letterThread = new Thread(new LetterPrinter());

        numberThread.start();
        letterThread.start();
    }

    static class NumberPrinter implements Runnable {
        @Override
        public void run() {
            synchronized (lock) {
                while (number <= 26) {
                    if (printNumber) {
                        System.out.print(number++);
                        System.out.print(number++);
                        printNumber = false;
                        lock.notify();
                    } else {
                        try {
                            lock.wait();
                        } catch (InterruptedException e) {
                            Thread.currentThread().interrupt();
                        }
                    }
                }
            }
        }
    }

    static class LetterPrinter implements Runnable {
        @Override
        public void run() {
            synchronized (lock) {
                while (letter <= 'Z') {
                    if (!printNumber) {
                        System.out.print(letter++);
                        printNumber = true;
                        lock.notify();
                    } else {
                        try {
                            lock.wait();
                        } catch (InterruptedException e) {
                            Thread.currentThread().interrupt();
                        }
                    }
                }
            }
        }
    }
}

```

### Quiz-4 代码实现如下

```java
public class ABCABCABC {

    private int flag = 0;

    public synchronized void printA() {
        for(int i = 0; i < 5; i++) {
            while (flag != 0) {
                try {
                    wait();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }

            flag = 1;
            System.out.print("A");
            notifyAll();
        }
    }

    public synchronized void printB() {
        for(int i = 0; i < 5; i++) {
            while (flag != 1) {
                try {
                    wait();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }

            flag = 2;
            System.out.print("B");
            notifyAll();
        }
    }

    public synchronized void printC() {
        for(int i = 0; i < 5; i++) {
            while (flag != 2) {
                try {
                    wait();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }

            flag = 0;
            System.out.print("C");
            notifyAll();
        }
    }

    public static void main(String[] args) {

        ABCABCABC abcabcabc = new ABCABCABC();

        new Thread(new Runnable() {
            @Override
            public void run() {
                abcabcabc.printA();
            }
        }).start();


        new Thread(new Runnable() {
            @Override
            public void run() {
                abcabcabc.printB();
            }
        }).start();


        new Thread(new Runnable() {
            @Override
            public void run() {
                abcabcabc.printC();
            }
        }).start();
    }
}
```

### Quiz-5 代码实现如下

```java
public class TenThreadSum {

    public static class SumThread extends Thread{

        int forct = 0;  int sum = 0;

        SumThread(int forct){
            this.forct = forct;
        }

        @Override
        public void run() {
            for(int i = 1; i <= 10; i++){
                sum += i + forct * 10;
            }
            System.out.println(getName() + "  " + sum);
        }
    }

    public static void main(String[] args) {

        int result = 0;

        for(int i = 0; i < 10; i++){
            SumThread sumThread = new SumThread(i);
            sumThread.start();
            try {
                sumThread.join();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            result = result + sumThread.sum;
        }
        System.out.println("result   " + result);
    }
}
```

### Quiz-6 代码实现如下

```java
class Ticket {
    private int count = 1;
    public void sale() {
        while (true) {
            synchronized (this) {
                if (count > 200) {
                    System.out.println("票已经卖完啦");
                    break;
                } else {
                    System.out.println(Thread.currentThread().getName() + "卖的第 " + count++ + " 张票");
                }
                try {
                    Thread.sleep(200);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}

class SaleWindows extends Thread {
    
    private Ticket ticket;

    public SaleWindows(String name, Ticket ticket) {
        super(name);
        this.ticket = ticket;
    }

    @Override
    public void run() {
        super.run();
        ticket.sale();
    }
}

public class TicketDemo {
    public static void main(String[] args) {
        Ticket ticket = new Ticket();

        SaleWindows windows1 = new SaleWindows("窗口1", ticket);
        SaleWindows windows2 = new SaleWindows("窗口2", ticket);
        SaleWindows windows3 = new SaleWindows("窗口3", ticket);

        windows1.start();
        windows2.start();
        windows3.start();
    }
}
```

### Quiz-7 代码实现如下

#### synchronized 实现

```java
public class FruitPlateDemo {

    private final static String LOCK = "lock";

    private int count = 0;

    private static final int FULL = 10;

    public static void main(String[] args) {

        FruitPlateDemo fruitDemo1 = new FruitPlateDemo();

        for (int i = 1; i <= 5; i++) {
            new Thread(fruitDemo1.new Producer(), "生产者-" + i).start();
            new Thread(fruitDemo1.new Consumer(), "消费者-" + i).start();
        }
    }

    class Producer implements Runnable {
        @Override
        public void run() {
            for (int i = 0; i < 10; i++) {
                synchronized (LOCK) {
                    while (count == FULL) {
                        try {
                            LOCK.wait();
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                    }

                    System.out.println("生产者 " + Thread.currentThread().getName() + " 总共有 " + ++count + " 个资源");
                    LOCK.notifyAll();
                }
            }
        }
    }

    class Consumer implements Runnable {
        @Override
        public void run() {
            for (int i = 0; i < 10; i++) {
                synchronized (LOCK) {
                    while (count == 0) {
                        try {
                            LOCK.wait();
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                    }
                    System.out.println("消费者 " + Thread.currentThread().getName() + " 总共有 " + --count + " 个资源");
                    LOCK.notifyAll();
                }
            }
        }
    }
}

```

#### ReentrantLock 方式（可以保证顺序）

```java
public class Demo1 {

    private int count = 0;
    private final static int FULL = 10;
    private Lock lock;
    private Condition notEmptyCondition;
    private Condition notFullCondition;

    {
        lock = new ReentrantLock();
        notEmptyCondition = lock.newCondition();
        notFullCondition = lock.newCondition();

    }

    class Producer implements Runnable {

        @Override
        public void run() {

            for (int i = 0; i < 10; i++) {
                lock.lock();
                try {
                    while(count == FULL) {
                        try {
                            notFullCondition.await();
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                    }
                    System.out.println("生产者 " + Thread.currentThread().getName() + " 总共有 " + ++count + " 个资源");
                    notEmptyCondition.signal();
                } finally {
                    lock.unlock();
                }
            }
        }
    }

    class Consumer implements Runnable {
        @Override
        public void run() {
            for (int i = 0; i < 10; i++) {
                lock.lock();
                try {
                    while(count == 0) {
                        try {
                            notEmptyCondition.await();
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                    }
                    System.out.println("消费者 " + Thread.currentThread().getName() + " 总共有 " + --count + " 个资源");
                    notFullCondition.signal();
                } finally {
                    lock.unlock();
                }
            }
        }
    }

    public static void main(String[] args) {
        Demo1 demo1 = new Demo1();
        for (int i = 1; i <= 5; i++) {
            new Thread(demo1.new Producer(), "生产者-" + i).start();
            new Thread(demo1.new Consumer(), "消费者-" + i).start();
        }
    }
}
```

#### BlockingQueue 方式

```java
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;

public class Demo2 {

    private int count = 0;

    private BlockingQueue<Integer> queue = new ArrayBlockingQueue<>(10);

    public static void main(String[] args) {

        Demo2 demo2 = new Demo2();
        for (int i = 1; i <= 5; i++) {
            new Thread(demo2.new Producer(), "生产者-" + i).start();
            new Thread(demo2.new Consumer(), "消费者-" + i).start();
        }
    }

    class Producer implements Runnable {

        @Override
        public void run() {

            for (int i = 0; i < 10; i++) {
                try {
                    queue.put(1);
                    System.out.println("生产者 " + Thread.currentThread().getName() + " 总共有 " + ++count + " 个资源");
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    class Consumer implements Runnable {

        @Override
        public void run() {
            for (int i = 0; i < 10; i++) {
                try {
                    queue.take();
                    System.out.println("消费者 " + Thread.currentThread().getName() + " 总共有 " + --count + " 个资源");
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
```

### Quiz-8 代码实现如下

```java
public class TwoArr {

    int[] arr1 = new int[]{1, 3, 5, 7, 9};
    int[] arr2 = new int[]{2, 4, 6, 8, 10};

    boolean flag;

    public synchronized void print1(){
        for(int i= 0; i < arr1.length; i++){
            while (flag){
                try {
                    wait();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }

            flag = !flag;
            System.out.println(arr1[i]);
            notifyAll();
        }
    }

    public synchronized void print2(){
        for(int i= 0; i < arr2.length; i++){
            while (!flag){
                try {
                    wait();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }

            flag = !flag;
            System.out.println(arr2[i]);
            notifyAll();
        }
    }

    public static void main(String[] args) {

        TwoArr twoArr = new TwoArr();

        new Thread(new Runnable() {
            @Override
            public void run() {
                twoArr.print1();
            }
        }).start();

        new Thread(new Runnable() {
            @Override
            public void run() {
                twoArr.print2();
            }
        }).start();
    }

}
```