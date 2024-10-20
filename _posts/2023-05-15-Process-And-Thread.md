---
title: 进程与线程
author: 
date: 2023-05-15 11:33:00 +0800
categories: [Concurrent Programming]
tags: [Concurrent Programming]
pin: false
math: false
mermaid: false
---

## 1. 进程与线程

### 1.1 进程 process

Q: 什么是进程 ?

进程的定义，一直以来没有完美的标准。

**进程是程序的一次执行。应用程序以进程的形式，运行于操作系统之上，享受操作系统提供的服务。**

- 程序由指令和数据组成，指令要运行，数据要读写，则必须将指令加载到 CPU 中，数据加载到内存中。指令运行过程中还需要用到硬盘、网络等设备。**进程就是用来加载指令、管理内存、管理 IO 的，即进程是操作系统进行资源分配和调度的基本单位。**
- 当一个程序被运行，从硬盘加载这个程序的代码到内存，此时我们说开启了一个进程。
- 进程可以看作程序的一个实例。

进程（process）是计算机中正在运行的程序实例。每个进程都有自己的内存空间、代码和数据，并在操作系统的管理下独立地运行。进程是操作系统进行资源分配和调度的基本单位。

举个例子，当你打开一个应用程序时，计算机会为该程序创建一个进程，该进程就是运行该应用程序的实例。在这个进程中，程序的代码和数据被载入内存中，CPU 会按照代码的指令来执行程序。在运行过程中，进程可能会请求操作系统分配更多的内存或其他资源，操作系统会根据需要进行资源分配和管理。

### 1.2 线程 thread

- 一个进程内可以分到一到多个线程。
- 一个线程就是一个指令流，将指令流中的一条条指令以一定顺序交给 CPU 执行。
- Java 中，线程作为最小的调度单位，进程作为资源分配的最小单位。在 windows 中进程是不活动的，只是作为线程的容器。

线程（thread）是进程中的一个执行单元。线程本身是不会独立存在的。一个进程可以包含多个线程，每个线程都可以独立执行不同的代码，但它们**共享该进程的内存和其他资源**。与进程不同，线程的创建和销毁都是比较轻量级的操作。

**形象比喻如下**

可以把进程看作是一栋楼房，而线程就是其中的一个房间。每个房间都可以独立地完成不同的任务，但它们共享同一栋楼房的资源，例如水电、空调等。

由于**线程共享同一个进程的内存空间**，所以线程之间的通信和同步比较容易。线程可以通过共享内存或消息传递等方式来交换数据和信息，从而协同完成复杂的任务。

### 1.3 process VS thread

- 进程相互独立，而线程存在于进程中，是进程的一个子集。
- 进程拥有共享资源，如内存空间等，供其内部的线程共享。
- 进程是操作系统中进行资源分配和管理的基本单位，每个进程都有自己的内存空间、代码和数据。
- 进程间通信较为复杂：
    1. 同一台计算机的进程通信称为 IPC(Inter-process communication)
    2. 不同计算机之间的进程通信，需要通过网络，并遵守共同的协议，例如 HTTP。
- 线程通信相对简单，因为线程共享内存，比如多个线程可以访问同一个共享变量。Java 中的通信机制：volatile、等待/通知机制、join 方式、InheritableThreadLocal、MappedByteBuffer
- 轻量级上，**线程更轻量**。线程上下文切换成本低于进程，线程的创建和销毁更快，线程间的切换开销更小。

进程是代码在数据集合上的一次运行活动，是系统进行资源分配和调度的基本单位，线程则是进程的一个执行路径，一个进程中至少有一个线程，进程中的多个线程共享进程的资源。

操作系统在分配资源时是把资源分配给进程的，但是 CPU 资源比较特殊，它是被分配到线程的，因为真正要占用 CPU 运行的是线程，所以也说**线程是 CPU 分配的基本单位。**

在 Java 中，当我们启动 main 函数时其实就启动了一个 JVM 的进程，而 main 函数所在的线程就是这个进程中的一个线程，也叫主线程。

一个进程中有多个线程，多个线程**共享进程的堆和方法区资源**，但是每个线程有自己的程序计数器和栈区域。

### 1.4 进程间的通信方式

1. **信号量（Semaphore）：**信号量是一个计数器，用于多进程对共享数据的访问，解决同步相关的问题并避免竞争条件。
2. **共享内存（Shared Memory）：**多个进程可以访问同一块内存空间，需要使用信号量用来同步对共享存储的访问。
3. **管道通信（Pipes）：**管道是用于连接一个读进程和一个写进程以实现它们之间通信的一个共享文件 pipe 文件，该文件同一时间只允许一个进程访问，所以只支持**半双工通信**。
  * 匿名管道（Pipes）：用于具有亲缘关系的父子进程间或者兄弟进程之间的通信。
  * 命名管道（Named Pipes）：以磁盘文件的方式存在，可以实现本机任意两个进程通信，遵循 FIFO。
4. **消息队列（Message Queue）：**内核中存储消息的链表，由消息队列标识符标识，能在不同进程之间提供**全双工通信**，对比管道：
  * 匿名管道存在于内存中的文件；命名管道存在于实际的磁盘介质或者文件系统；消息队列存放在内核中，只有在内核重启（操作系统重启）或者显示地删除一个消息队列时，该消息队列才被真正删除
  * 读进程可以根据消息类型有选择地接收消息，而不像 FIFO 那样只能默认地接收
5. **信号（Signal）：**
  * `Ctrl + c`：发送 SIGINT 信号给前台进程组中的所有进程。常用于终止正在运行的程序；
  * `ctrl + z`：发送 SIGTSTP 信号给前台进程组中的所有进程，常用于挂起一个进程；
  * `Ctrl + \`：发送 SIGQUIT 信号给前台进程组中的所有进程，终止前台进程并生成 core 文件；
  * `kill -9`：系统发出 SIGKILL 信号，强制接收该信号的程序立即结束运行。

不同计算机之间的**进程通信**，需要通过网络，并遵守共同的协议，例如 HTTP

5. **套接字（Socket）：**与其它通信机制不同的是，可用于不同机器间的互相通信

## 2. 并行与并发

### 2.1 并行 parallel

并行（parallel）是指在**同一时刻执行多个任务或操作**的能力。在计算机中，通常使用并行技术来提高程序的执行效率和性能，特别是在处理大规模、复杂的问题时，使用并行技术可以大大缩短计算时间。

并行技术可以分为两种类型：数据并行和任务并行。

1. 数据并行是指将数据分成多个部分，然后同时对每个部分进行处理。例如，在图像处理中，可以将一张大图分成多个小块，然后在多个处理器上同时对每个小块进行处理。
2. 任务并行是指将任务分成多个子任务，然后同时执行这些子任务。例如，在分布式系统中，可以将一个复杂的任务分成多个子任务，然后在多个计算节点上同时执行这些子任务。例子：MapReduce。

并行技术需要具备良好的并发控制机制，以保证多个任务或操作之间的正确协同和同步。在实际应用中，通常采用多线程、多进程、多机器等技术来实现并行。同时，还需要考虑硬件和软件的支持，例如多核处理器、高速缓存、并行编程语言和库等。

### 2.2 并发 concurrent

并发（concurrency）是指在**同一时间间隔内执行多个任务或操作**的能力。在计算机中，并发常用于多用户、多任务、多线程等场景，用于提高计算机的资源利用率和处理效率。

与并行不同的是，并发是指多个任务或操作在时间上有重叠，但是在同一时刻只能执行其中的一个，因此它们需要通过切换执行上下文来共享 CPU 资源。例如，在操作系统中，多个进程或线程可以同时运行，但是在同一时刻只有一个进程或线程在执行，因为 CPU 资源是被轮流分配的。

并发技术需要考虑多个任务或操作之间的同步和互斥，以保证它们之间的正确协同。例如，在多线程编程中，需要使用锁、信号量、条件变量等机制来控制多个线程之间的同步和互斥。同时，还需要考虑线程安全和死锁等问题，以保证程序的正确性和稳定性。

总的来说，并发和并行是两个相关但又不同的概念，都是用于提高计算机的资源利用率和处理效率的重要技术。

单核 cpu 下，线程实际还是**串行执行**的。操作系统中有一个组件叫做任务调度器，将 cpu 的时间片（windows 下时间片最小约为 15 毫秒）分给不同的程序使用，只是由于 cpu 在线程间（时间片很短）的切换非常快，人类感觉是同时运行的。总结为一句话就是：微观串行，宏观并行。

一般会将这种 **线程轮流使用 CPU 的做法**称为并发 concurrent。

引用 Rob Pike 的一段描述：

- 并发（concurrent）是同一时间应对（dealing with）多件事情的能力。
- 并行（parallel）是同一时间动手做（doing）多件事情的能力。

**形象比喻如下**

- 家庭主妇做饭、打扫卫生、给孩子喂奶，她一个人轮流交替做这多件事，这时就是**并发**
- 家庭主妇雇了个保姆，她们一起这些事，这时既有**并发**，也有**并行**（这时会产生竞争，例如锅只有一口，一个人用锅时，另一个人就得等待）
- 雇了 3 个保姆，一个专做饭、一个专打扫卫生、一个专喂奶，互不干扰，这时是**并行**

### 2.3 Parallelism VS concurrency

并发（Concurrency）和并行（Parallelism）都是用于提高计算机的资源利用率和处理效率的重要技术，但是它们有着本质的区别。

**并发是指多个任务或操作在时间上有重叠，但是在同一时刻只能执行其中的一个**，因此它们需要通过切换执行上下文来共享 CPU 资源。例如，在操作系统中，多个进程或线程可以同时运行，但是在同一时刻只有一个进程或线程在执行，因为 CPU 资源是被轮流分配的。并发技术需要考虑多个任务或操作之间的同步和互斥，以保证它们之间的正确协同。

**并行是指在同一时刻执行多个任务或操作的能力**。在计算机中，通常使用并行技术来提高程序的执行效率和性能，特别是在处理大规模、复杂的问题时，使用并行技术可以大大缩短计算时间。并行技术可以分为两种类型：数据并行和任务并行。数据并行是指将数据分成多个部分，然后同时对每个部分进行处理。任务并行是指将任务分成多个子任务，然后同时执行这些子任务。

总的来说，简单地说，**并发是关注在时间上多个任务如何交替执行，而并行是关注在空间上多个任务如何同时执行**。并发通常应用于多任务、多用户、多线程等场景，而并行通常应用于处理大规模、复杂的问题。

**Q: 什么叫做线程的上下文切换**

**Ans:**

1. 线程是在进程中执行的独立指令流。在操作系统中，多个线程可能会在同一时间内运行，从而实现并发执行。
2. 当一个线程需要等待某些操作完成或者发生某些事件时，操作系统会将其暂停，并保存当前线程的上下文信息（比如程序计数器、寄存器、堆栈等）到内存中。这个过程被称为**线程的上下文切换**。
3. 接下来，操作系统会从调度队列中选择一个可用的线程，并将其上下文信息从内存中读入 CPU 寄存器，让这个线程继续执行。这个过程可能会发生多次，每次上下文切换都需要操作系统消耗一定的资源，所以要合理地控制线程的数量和上下文切换的次数 ➡️ 提高系统的性能。

## 3. 同步异步

<font color='red' style='font-weight:bold'>从方法调用的角度来讲：</font>

* 需要等待结果返回，才能继续运行就是**同步（Synchronized）**。
* 不需要等待结果返回，就能继续运行就是**异步（Asynchronized）**。

> 同步在多线程中还有另外一层意思，是让多个线程步调一致。
{: .prompt-tip }

<font color='red' style='font-weight:bold'>单核多核的效率提升：</font>


1. 单核 CPU 下，多线程不能实际提高程序运行的效率，只是为了能够在不同的任务之间切换，不同线程轮流使用 CPU，不至于一个线程总占用 CPU，别的线程没法干活；

2. 多核CPU可以并行执行多个线程，但能否提高程序运行效率还是要分情况的：
  * 有些任务，经过精心设计，将任务拆分，并行执行，当然可以提高程序的运行效率，但不是所有计算任务都能拆分；from 阿姆达尔定律[^Amdahl-s-law]。
  * 也不是所有任务都需要拆分，任务的目的如果不同，谈拆分和效率没啥意义；
3. IO 操作不占用 CPU，只是我们一般拷贝文件使用的是阻塞 IO，这时相当于线程虽然不占用 CPU，但需要一致等待 IO 结束，没能充分利用线程。所以才有后面的非阻塞 IO 和异步 IO 优化。

## Reference

[^Amdahl-s-law]: Amdahl's law: <https://en.wikipedia.org/wiki/Amdahl%27s_law>