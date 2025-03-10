---
title: 高效编程 - 线程
date: 2023-02-10 10:51:00 +0800
author:
categories: [Python]
tags: [Python]
pin: false
math: true
mermaid: false
media_subpath: /assets/images/
---

## 一、线程

### 1、概念

- 线程

  在一个进程的内部，要同时干多件事，就需要同时运行多个“子任务”，我们把进程内的这些“子任务”叫做线程

  是操作系统能够进行运算调度的最小单位。它被包含在进程之中，是进程中的实际运作单位。一条线程指的是进程中一个单一顺序的控制流，一个进程中可以并发多个线程，每条线程并行执行不同的任务。

  线程通常叫做轻型的进程。线程是共享内存空间的并发执行的多任务，每一个线程都共享一个进程的资源

  线程是最小的执行单元，而进程由至少一个线程组成。如何调度进程和线程，完全由操作系统决定，程序自己不能决定什么时候执行，执行多长时间

- 多线程

  是指从软件或者硬件上实现多个线程并发执行的技术。具有多线程能力的计算机因有硬件支持而能够在同一时间执行多于一个线程，进而提升整体处理性能。

- 主线程：

  ​	任何进程都会有一个默认的主线程  如果主线程死掉  子线也程也死掉   所以 子线程依赖于主线程

- GIL（了解）

  其他语言，CPU 是多核是支持多个线程同时执行。但在 Python 中，无论是单核还是多核，同时只能由一个线程在执行。其根源是 GIL 的存在。

  GIL 的全称是 Global Interpreter Lock(全局解释器锁)，来源是 Python 设计之初的考虑，为了数据安全所做的决定。某个线程想要执行，必须先拿到 GIL，我们可以把 GIL 看作是“通行证”，并且在一个 Python 进程中，GIL 只有一个。拿不到通行证的线程，就不允许进入 CPU 执行。

  并且由于 GIL 锁存在，Python 里一个进程永远只能同时执行一个线程(拿到 GIL 的线程才能执行)，这就是为什么在多核CPU上，Python 的多线程效率并不高的根本原因。

- 模块

  _thread模块：低级模块

  threading模块：高级模块，对 _thread 进行了封装

### 2、使用_thread 模块 去创建线程

+ 导入模块

  import  _thread

+ 开启线程

  _thread.start_new_thread(函数名,参数) 

+ 注意：
  + 参数必须为元组类型
  + 如果主线程执行完毕 子线程就会死掉
  + 如果线程不需要传参数的时候  也必须传递一个空元组占位

+ 实例

  ```python
  import win32api
  import _thread # 引入线程的模块   比较老的模块  新的 threading

  def run(i):
      win32api.MessageBox(0,"您的{}号大宝贝上线了".format(i),"来自凤姐以及陆源凯的问候",2)

  for i in range(5):
      _thread.start_new_thread(run,(i,)) # 发起多个线程  传参的情况  参数为元组
      # _thread.start_new_thread(run,()) # 发起多个线程  不传参 页需要俩个参数 第二个为空元组
  print('会先执行我')
  # 如果主线程 不死  那么 所有的次线程 就都会正常执行
  while True:
      pass
  ```

  提高效率

  ```python
  import _thread
  import time

  def run():
      for i in range(10):
          print(i,'------------')
          time.sleep(1)
  """
  for i in range(5): #50秒
      run()
  """

  for i in range(5):
      _thread.start_new_thread(run,()) # 发起五个线程去执行  时间大大缩短

  for i in range(10): # 循环10秒  计算 线程执行完毕所需要的时间  类似与一个劫停
      time.sleep(1)
  print('xxxx')
  ```



### 3、threading创建线程（重点）

+ 导入模块

  import threading

+ threading创建线程的方式

  myThread = threading.Thread(target=函数名[, args=(参数,), name="你指定的线程名称"])

  参数

  + target：指定线程执行的函数
  + name：指定当前线程的名称
  + args：传递各子线程的参数 ,(元组形式)

+ 开启线程

  myThread.start()

+ 线程等待

  myThread.join()

+ 返回当前线程对象

  + threading.current_thread()

  + threading.currentThread()

+ 获取当前线程的名称

  + threading.current_thread().name
  + threading.currentThread().getName()

+ 设置线程名

  setName()

  ```python
  Thread(target=fun).setName('name')
  ```

+ 返回主线程对象

  threading.main_thread()　　  

+ 获取当前活着的所有线程总数，包括主线程main

  threading.active_count() 或 threading.activeCount()　

+ 判断线程是不是活的，即线程是否已经结束    

  + Thread.is_alive()

  + Thread.isAlive()

+ 线程守护

  设置子线程是否随主线程一起结束

  有一个布尔值的参数，默认为 False，该方法设置子线程是否随主线程一起结束   True 一起结束

  Thread.setDaemon(True)	

  还有个要特别注意的：必须在 start() 方法调用之前设置

  ```python
  if __name__ == '__main__':
      t = Thread(target=fun, args=(1,))
      t.setDaemon(True)
      t.start()
      print('over')
  ```

+ 获取当前所有的线程名称

  ```python
  threading.enumerate()  # 返回当前包含所有线程的列表
  ```


### 4、启动线程实现多任务

```python
import time
import threading

def run1():
    # 获取线程名字
    print("启动%s子线程……"%(threading.current_thread().name))
    for i in range(5):
        print("lucky is a good man")
        time.sleep(1)

def run2(name, word):
    print("启动%s子线程……" % (threading.current_thread().name))
    for i in range(5):
        print("%s is a %s man"%(name, word))
        time.sleep(1)

if __name__ == "__main__":
    t1 = time.clock()
    # 主进程中默认有一个线程，称为主线程(父线程)
    # 主线程一般作为调度而存在，不具体实现业务逻辑

    # 创建子线程
    # name参数可以设置线程的名称，如果不设置按顺序设置为Thread-n
    th1 = threading.Thread(target=run1, name="th1")
    th2 = threading.Thread(target=run2, args=("lucky", "nice"))

    # 启动
    th1.start()
    th2.start()

    # 等待子线程结束
    th1.join()
    th2.join()

    t2 = time.clock()
    print("耗时：%.2f"%(t2-t1))
```

### 5、线程间共享数据

概述

​	多线程和多进程最大的不同在于，多进程中，同一个变量，各自有一份拷贝存在每个进程中，互不影响。而多线程中，所有变量都由所有线程共享。所以，任何一个变量都可以被任意一个线程修改，因此，线程之间共享数

据最大的危险在于多个线程同时修改一个变量，容易把内容改乱了。

```python
import time
import threading

money = 0

def run1():
    global money
    money = 1
    print("run1-----------", money)
    print("启动%s子线程……"%(threading.current_thread().name))
    for i in range(5):
        print("lucky is a good man")
        time.sleep(1)

def run2(name, word):
    print("run2-----------", money)
    print("启动%s子线程……" % (threading.current_thread().name))
    for i in range(5):
        print("%s is a %s man"%(name, word))
        time.sleep(1)

if __name__ == "__main__":
    t1 = time.clock()

    th1 = threading.Thread(target=run1, name="th1")
    th2 = threading.Thread(target=run2, args=("lucky", "nice"))

    th1.start()
    th2.start()
    th1.join()
    th2.join()

    t2 = time.clock()
    print("耗时：%.2f"%(t2-t1))
    print("main-----------", money)
```

### 6、Lock线程锁(多线程内存错乱问题)

+ 概述

  Lock 锁是线程模块中的一个类，有两个主要方法：acquire() 和 release() 当调用 acquire() 方法时，它锁定锁的执行并阻塞锁的执行，直到其他线程调用 release() 方法将其设置为解锁状态。锁帮助我们有效地访问程序中的共享资源，以防止数据损坏，它遵循互斥，因为一次只能有一个线程访问特定的资源。

+ 作用

  避免线程冲突

+ **锁：**确保了这段代码只能由一个线程从头到尾的完整执行阻止了多线程的并发执行,包含锁的某段代码实际上只能以单线程模式执行,所以效率大大的降低了 由于可以存在多个锁,不同线程持有不同的锁,并试图获取其他的锁, 可能造成死锁,导致多个线程只能挂起,只能靠操作系统强行终止

+ 注意：

  1. 当前线程锁定以后 后面的线程会等待（线程等待/线程阻塞） 
  2. 需要release 解锁以后才正常
  3. 不能重复锁定

+ 内存错乱实例

  ```python
  import threading

  i = 0

  def sum1():
      global i
      for x in range(1000000):
          i += x
          i -= x
      print('sum1', i)

  def sum2():
      global i
      for x in range(1000000):
          i += x
          i -= x
      print('sum2', i)

  if __name__ == '__main__':
      thr1 = threading.Thread(target=sum1)
      thr2 = threading.Thread(target=sum2)
      thr1.start()
      thr2.start()
      thr1.join()
      thr2.join()
      print('over')
  ```


问题：两个线程对同一数据同时进行读写，可能造成数据值的不对，我们必须保证一个线程在修改money时其他的线程一定不能修改，线程锁解决数据混乱问题

+ 线程锁Lock使用方法

  ```
  import threading
  # 创建一个锁
  lock = threading.Lock()
  lock.acquire()   #进行锁定  锁定成功返回True
  lock.release()    #进行解锁
  ```

+ Lock锁的使用:


  ```python
  import threading

  #创建一个lock对象
  lock = threading.Lock()

  #初始化共享资源
  abce = 0

  def sumOne():
      global abce

      #锁定共享资源
      lock.acquire()
      abce = abce + 1

      #释放共享资源
      lock.release()

      def sumTwo():
          global abce

          #锁定共享资源
          lock.acquire()
          abce = abce + 2

          #释放共享资源
          lock.release()

          #调用函数

          sumOne()
          sumTwo()
          print(abce)
  ```
  在上面的程序中,lock是一个锁对象,全局变量abce是一个共享资源,sumOne()和sumTwo()函数扮作两个线程,在sumOne()函数中共享资源abce首先被锁定,然后增加了1,然后abce被释放。sumTwo()函数执行类似操作。 两个函数sumOne()和sumTwo()不能同时访问共享资源abce，一次只能一个访问共享资源。

+ 解决资源混乱

  ```python
  import threading

  Lock = threading.Lock()
  i = 1
  def fun1():
      global i
      if Lock.acquire():  # 判断是否上锁  锁定成功
          for x in range(1000000):
              i += x
              i -= x
          Lock.release()
      print('fun1-----', i)

  def fun2():
      global i
      if Lock.acquire():  # 判断是否上锁  锁定成功
          for x in range(1000000):
              i += x
              i -= x
          Lock.release()
      print('fun2----', i)
    t1 = threading.Thread(target=fun1)
    t2 = threading.Thread(target=fun2)
    t1.start()
    t2.start()
    t1.join()
    t2.join()
    print('mian----',i)
  ```

+ 线程锁的简写（不需要手动解锁）

  ```python
  import threading

  i = 0
  lock = threading.Lock()

  def sum1():
      global i
      with lock:
          for x in range(1000000):
              i += x
              i -= x
      print('sum1', i)

  def sum2():
      global i
      with lock:
          for x in range(1000000):
              i += x
              i -= x
      print('sum2', i)

  if __name__ == '__main__':
      thr1 = threading.Thread(target=sum1)
      thr2 = threading.Thread(target=sum2)
      thr1.start()
      thr2.start()
      thr1.join()
      thr2.join()
      print('over')
  ```


    结果一样

### 7、Timer定时执行

+ 概述

  Timer是Thread的子类，可以指定时间间隔后在执行某个操作

+ 使用

  ```python
  import threading

  def go():
      print("走我了")

  # t = threading.Timer(秒数,函数名)
  t = threading.Timer(3,go)
  t.start()
  print('我是主线程的代码')
  ```


### 8、线程池ThreadPoolExecutor 

+ 模**块**

  concurrent.futures

+ **导入**  Executor[ɪɡˈzekjətər]

  ```python
  from concurrent.futures import ThreadPoolExecutor
  ```

+ **方法**

  + submit(fun[, args])  传入放入线程池的函数以及传参
  + map(fun[, iterable_args])  统一管理

  **区别**：

  + submit与map参数不同  submit每次都需要提交一个目标函数和对应参数 map只需要提交一次目标函数 目标函数的参数 放在一个可迭代对象（列表、字典...）里就可以

+ **使用**

  ```python
  from concurrent.futures import ThreadPoolExecutor
  import time
  # import threadpool
  #线程池 统一管理 线程

  def go(str):
      print("hello",str)
      time.sleep(2)
  name_list = ["lucky","卢yuan凯","姚青","刘佳俊","何必喆"]
  pool = ThreadPoolExecutor(5)  #控制线程的并发数
  ```


  

+   线程池运行的方式

    方式一

    ```python
     # 逐一传参扔进线程池
        for i in name_list:
            pool.submit(go, i)
    ```

+   简写

    ```python
        all_task = [pool.submit(go, i) for i in name_list]
    ```

+   方式二

    ```python
        # 统一放入进程池使用
        pool.map(go, name_list)
        # 多个参数
        # pool.map(go, name_list1, name_list2...)
    ```
        **map(fn, *iterables, timeout=None)**
        fn： 第一个参数 fn 是需要线程执行的函数；
        
        iterables：第二个参数接受一个可迭代对象；
        
        timeout： 第三个参数 timeout 跟 wait() 的 timeout 一样，但由于 map 是返回线程执行的结果，如果 timeout小于线程执行时间会抛异常 TimeoutError。
        
        **注意：**使用 map 方法，无需提前使用 submit 方法，map 方法与 python 高阶函数 map 的含义相同，都是将序列中的每个元素都执行同一个函数。

+   **获取返回值**

    + 方式一

      ```python
      import random
      from concurrent.futures import ThreadPoolExecutor, as_completed
      import time
      # import threadpool
      #线程池 统一管理 线程

      def go(str):
          print("hello", str)
          time.sleep(random.randint(1, 4))
          return str
      name_list = ["lucky","卢yuan凯","姚青","刘佳俊","何必喆"]
      pool = ThreadPoolExecutor(5)  #控制线程的并发数
      all_task = [pool.submit(go, i) for i in name_list]
      # 统一放入进程池使用
      for future in as_completed(all_task):
          print("finish the task")
          obj_data = future.result()
          print("obj_data is ", obj_data)
      ```

      **as_completed**

      当子线程中的任务执行完后，使用 result() 获取返回结果

       该方法是一个生成器，在没有任务完成的	时候，会一直阻塞，除非设置了 timeout。 当有某个任务完成的时候，会yield这个任务，就能执行for循环下面的语句，然后继续阻塞住，循环到所有任务结束，同时，先完成的任务会先返回给主线程

+   方式二

    ```python
        for result in pool.map(go, name_list):
            print("task:{}".format(result))
    ```

+   wait 等待线程执行完毕 在继续向下执行

    ```python
        from concurrent.futures import ThreadPoolExecutor, wait
        import time

        # 参数times用来模拟下载的时间
        def down_video(times):
            time.sleep(times)
            print("down video {}s finished".format(times))
            return times
        executor = ThreadPoolExecutor(max_workers=2)
        #通过submit函数提交执行的函数到线程池中，submit函数立即返回，不阻塞
        task1 = executor.submit(down_video, (3))
        task2 = executor.submit(down_video, (1))
        # done方法用于判定某个任务是否完成
        print("任务1是否已经完成：", task1.done())
        time.sleep(4)
        print(wait([task1, task2]))
        print('wait')
        print("任务1是否已经完成：", task1.done())
        print("任务1是否已经完成：", task2.done())
        #result方法可以获取task的执行结果
        print(task1.result())
    ```

+   **线程池与线程对比**

    线程池是在程序运行开始，创建好的n个线程，并且这n个线程挂起等待任务的到来。而多线程是在任务到来得时候进行创建，然后执行任务。
      线程池中的线程执行完之后不会回收线程，会继续将线程放在等待队列中；多线程程序在每次任务完成之后会回收该线程。
      由于线程池中线程是创建好的，所以在效率上相对于多线程会高很多。
      线程池也在高并发的情况下有着较好的性能；不容易挂掉。多线程在创建线程数较多的情况下，很容易挂掉。


### 9、队列模块queue

+ 导入队列模块

  import queue

+ 概述

  queue是python标准库中的线程安全的队列（FIFO）实现,提供了一个适用于多线程编程的先进先出的数据结构，即队列，用来在生产者和消费者线程之间的信息传递

+ 基本FIFO队列

  queue.Queue(maxsize=0)

  FIFO即First in First Out,先进先出。Queue提供了一个基本的FIFO容器，使用方法很简单,**maxsize是个整数**，指明了队列中能存放的数据个数的上限。一旦达到上限，插入会导致阻塞，直到队列中的数据被消费掉。如果**maxsize小于或者等于0**，队列大小没有限制。

  举个栗子：

  ```python
    import queue

    q = queue.Queue()

    for i in range(5):
        q.put(i)

    while not q.empty():
        print q.get()
  ```


+ 一些常用方法 

  + task_done()

    ​	意味着之前入队的一个任务已经完成。由队列的消费者线程调用。每一个get()调用得到一个任务，接下来的task_done()调用告诉队列该任务已经处理完毕。

    ​	如果当前一个join()正在阻塞，它将在队列中的所有任务都处理完时恢复执行（即每一个由put()调用入队的任务都有一个对应的task_done()调用）。

  + join()

    ​阻塞调用线程，直到队列中的所有任务被处理掉。

    只要有数据被加入队列，未完成的任务数就会增加。当消费者线程调用task_done()（意味着有消费者取得任务并完成任务），未完成的任务数就会减少。当未完成的任务数降到0，join()解除阻塞。

  + put(item[, block[, timeout]])

    将item放入队列中。

    + 如果可选的参数block为True且timeout为空对象（默认的情况，阻塞调用，无超时）。
    + 如果timeout是个正整数，阻塞调用进程最多timeout秒，如果一直无空空间可用，抛出Full异常（带超时的阻塞调用）。
    + 如果block为False，如果有空闲空间可用将数据放入队列，否则立即抛出Full异常
    + 其非阻塞版本为`put_nowait`等同于`put(item, False)`

  + get([block[, timeout]])

    ​从队列中移除并返回一个数据。block跟timeout参数同`put`方法

    ​其非阻塞方法为 `get_nowait()` 相当与 `get(False)`

  + empty()

    ​如果队列为空，返回True,反之返回False

### 10、案例

http://www.boxofficecn.com/boxofficecn

我们抓取从1994年到2021年的电影票房.

```python
import requests
from lxml import etree
from concurrent.futures import ThreadPoolExecutor


def get_page_source(url):
    resp = requests.get(url)
    resp.encoding = 'utf-8'
    return resp.text


def parse_html(html):
    try:
        tree = etree.HTML(html)
        trs = tree.xpath("//table/tbody/tr")[1:]
        result = []
        for tr in trs:
            year = tr.xpath("./td[2]//text()")
            year = year[0] if year else ""
            name = tr.xpath("./td[3]//text()")
            name = name[0] if name else ""
            money = tr.xpath("./td[4]//text()")
            money = money[0] if money else ""
            d = (year, name, money)
            if any(d):
                result.append(d)
        return result
    except Exception as e:
        print(e)  # 调bug专用


def download_one(url, f):
    page_source = get_page_source(url)
    data = parse_html(page_source)
    for item in data:
        f.write(",".join(item))
        f.write("\n")


def main():
    f = open("movie.csv", mode="w", encoding='utf-8')
    lst = [str(i) for i in range(1994, 2022)]
    with ThreadPoolExecutor(10) as t:
        # 方案一
        # for year in lst:
        #     url = f"http://www.boxofficecn.com/boxoffice{year}"
        #     # download_one(url, f)
        #     t.submit(download_one, url, f)

        # 方案二
        t.map(download_one, (f"http://www.boxofficecn.com/boxoffice{year}" for year in lst), (f for i in range(len(lst))))


if __name__ == '__main__':
    main()
```



## 二、进程VS线程

- 多任务的实现原理

  首先，要实现多任务，通常我们会设计Master-Worker模式，Master负责分配任务，Worker负责执行任务，因此，多任务环境下，通常是一个Master，多个Worker。

  如果用多进程实现Master-Worker，主进程就是Master，其他进程就是Worker。

  如果用多线程实现Master-Worker，主线程就是Master，其他线程就是Worker。

- 多进程

  主进程就是Master，其他进程就是Worker

  - 优点

    稳定性高：多进程模式最大的优点就是稳定性高，因为一个子进程崩溃了，不会影响主进程和其他子进程。（当然主进程挂了所有进程就全挂了，但是Master进程只负责分配任务，挂掉的概率低）著名的Apache最早就是采用多进程模式。

  - 缺点

    创建进程的代价大：在Unix/Linux系统下，用fork调用还行，在Windows下创建进程开销巨大

    操作系统能同时运行的进程数也是有限的：在内存和CPU的限制下，如果有几千个进程同时运行，操作系统连调度都会成问题

- 多线程

  主线程就是Master，其他线程就是Worker

  - 优点

    多线程模式通常比多进程快一点，但是也快不到哪去

    在Windows下，多线程的效率比多进程要高

  - 缺点

    任何一个线程挂掉都可能直接造成整个进程崩溃：所有线程共享进程的内存。在Windows上，如果一个线程执行的代码出了问题，你经常可以看到这样的提示：“该程序执行了非法操作，即将关闭”，其实往往是某个线程出了问题，但是操作系统会强制结束整个进程

- 计算密集型 vs IO密集型

  - 计算密集型（多进程适合计算密集型任务）

    要进行大量的计算，消耗CPU资源，比如计算圆周率、对视频进行高清解码等等，全靠CPU的运算能力。这种计算密集型任务虽然也可以用多任务完成，但是任务越多，花在任务切换的时间就越多，CPU执行任务的效率就越低，所以，要最高效地利用CPU，计算密集型任务同时进行的数量应当等于CPU的核心数

  - IO密集型 （线程适合IO密集型任务）

    涉及到网络、磁盘IO的任务都是IO密集型任务，这类任务的特点是CPU消耗很少，任务的大部分时间都在等待IO操作完成（因为IO的速度远远低于CPU和内存的速度）。对于IO密集型任务，任务越多，CPU效率越高，但也有一个限度。常见的大部分任务都是IO密集型任务，比如Web应用

- GIL

  多线程存在GIL锁，同一时刻只能有一条线程执行；在多进程中，每一个进程都有独立的GIL，不会发生GIL冲突；但在这个例子中，爬虫属于IO密集型，多进程适用于CPU计算密集型，所以用时较长，速度慢于多线程并发。


