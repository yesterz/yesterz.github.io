---
title: 协程
date: 2023-02-13 10:51:00 +0800
author:
categories: [Python]
tags: [Python]
pin: false
math: true
mermaid: false
media_subpath: /assets/images/
---


## 一、协程

### 概念

- 协程

  又称微线程(纤程)，是一种用户态的轻量级线程

- 子程序

  在所有的语言中都是层级调用的，比如A中调用B，B在执行过程中调用C，C执行完返回，B执行完返回，最后是A执行完毕。这是通过栈实现的，一个函数就是一个执行的子程序，子程序的调用总是有一个入口、一次返回，调用的顺序是明确的

- 理解协程

  普通理解：线程是系统级别的，它们是由操作系统调度。协程是程序级别，由程序员根据需求自己调度。我们把一个线程中的一个个函数称为子程序，那么一个子程序在执行的过程中可以中断去执行别的子程序，这就是协程。也就是说同一个线程下的一段代码1执行执行着就中断，然后去执行另一段代码2，当再次回来执行代码1时，接着从之前的中断的位置继续向下执行

- 优点

  a、最大的优势就是协程极高的执行效率。因为子程序切换不是线程切换，而是由程序自身控制，因此，没有线程切换的开销，和多线程比，线程数量越多，协程的性能优势就越明显。

  b、不需要多线程的锁机制，因为只有一个线程，也不存在同时写变量冲突，在协程中控制共享资源不加锁，只需要判断状态就好了，所以执行效率比多线程高很多。

- 缺点

  a、无法利用多核CPU，协程的本质是单个线程，它不能同时将多个CPU的多个核心使用上，失去了标准线程使用多CPU的能力。

  b、进行阻塞操作(操作IO)会阻塞整个程序



## 二、同步与异步

### 1、同步与异步的概念

- 前言

  Python 由于 GIL（全局锁）的存在，不能发挥多核的优势，其性能一直饱受诟病。然而在IO密集型的网络编程里，异步处理比同步处理能提升成百上千倍的效率

  IO 密集型就是磁盘的读取数据和输出数据非常大的时候就是属于 IO 密集型
  由于IO操作的运行时间远远大于cpu、内存运行时间，所以任务的大部分时间都是在等待IO操作完成，IO的特点是cpu消耗小，所以，IO任务越多，cpu效率越高，当然不是越多越好，有一个极限值。

- 同步

  指完成事务的逻辑，先执行第一个事务，如果阻塞了，会一直等待，直到这个事务完成，再执行第二个事务，顺序执行

- 异步

  是和同步相对的，异步是指在处理调用这个事务的之后，不会等待这个事务的处理结果，直接处理第二个事务去了，通过状态、通知、回调来通知调用者处理结果

### 2、同步与异步代码

- 同步

  ```python
  import time

  def run(index):
      print("lucky is a good man", index)
      time.sleep(2)
      print("lucky is a nice man", index)

  for i in range(1, 5):
      run(i)
  ```

- 异步

  说明：后面的课程中会使用到asyncio模块，现在的目的是使同学们理解异步思想

  ```python
  import time
  import asyncio

  async def run(i):
      print("lucky is a good man", i)
      # 模拟一个耗时IO
      await asyncio.sleep(2)
      print("lucky is a nice man", i)

  if __name__ == "__main__":
      loop = asyncio.get_event_loop()
      tasks = []
      t1 = time.time()
      for url in range(1, 5):
          coroutine = run(url)
          task = asyncio.ensure_future(coroutine)
          tasks.append(task)
      loop.run_until_complete(asyncio.wait(tasks))
      t2 = time.time()
      print("总耗时：%.2f" % (t2 - t1))
  ```

  ## 三、asyncio 模块

  ### 1、概述

  - asyncio 模块

    是python3.4版本引入的标准库，直接内置了对异步IO的操作

  - 编程模式

    是一个消息循环，我们从asyncio模块中直接获取一个EventLoop的引用，然后把需要执行的协程扔到EventLoop中执行，就实现了异步IO

  - 说明

    到目前为止实现协程的不仅仅只有asyncio,tornado和gevent都实现了类似功能

  - 关键字的说明

    | 关键字         | 说明                                       |
    | ----------- | ---------------------------------------- |
    | event_loop  | 消息循环，程序开启一个无限循环，把一些函数注册到事件循环上，当满足事件发生的时候，调用相应的协程函数 |
    | coroutine   | 协程对象，指一个使用async关键字定义的函数，它的调用不会立即执行函数，而是会返回一个协程对象。协程对象需要注册到事件循环，由事件循环调用 |
    | task        | 任务，一个协程对象就是一个原生可以挂起的函数，任务则是对协程进一步封装，其中包含了任务的各种状态 |
    | async/await | python3.5用于定义协程的关键字，async定义一个协程，await用于挂起阻塞的异步调用接口 |


### 2、asyncio 基本使用

- 定义一个协程

  ```python
  import asyncio
  import time

  # 通过async关键字定义了一个协程，协程是不能直接运行的，需要将协程放到消息循环中
  async def run(x):
      print("waiting：%d"%x)
      await asyncio.sleep(x)
      print("结束run")

      #得到一个协程对象
      coroutine = run(2)
      asyncio.run(coroutine)
  ```

- 等同于

  ```python
  import asyncio
  import time

  # 通过async关键字定义了一个协程，协程是不能直接运行的，需要将协程放到消息循环中
  async def run(x):
  print("waiting：%d"%x)
  await asyncio.sleep(x)
  print("结束run")

  #得到一个协程对象
  coroutine = run(2)
  # 创建一个消息循环
  loop = asyncio.get_event_loop()
  # 将协程对象加入到消息循环
  loop.run_until_complete(coroutine)
  ```

- 创建一个任务


  ```python
  import asyncio
  import time

  async def run(x):
      print("waiting：%d"%x)
      await asyncio.sleep(x)
      print("结束run")

      coroutine = run(2)
      #创建任务
      task = asyncio.ensure_future(coroutine)

      loop = asyncio.get_event_loop()

      # 将任务加入到消息循环
      loop.run_until_complete(task)
  ```


- 阻塞和await

  async可以定义协程，使用await可以针对耗时操作进行挂起，就与生成器的yield一样，函数交出控制权。协程遇到await，消息循环会挂起该协程，执行别的协程，直到其他协程也会挂起或者执行完毕，在进行下一次执行

- 获取返回值

  ```python
  import time
  import asyncio

  async def run(url):
      print("开始向'%s'要数据……"%(url))
      # 向百度要数据，网络IO
      await asyncio.sleep(5)
      data = "'%s'的数据"%(url)
      print("给你数据")
      return data

  # 定义一个回调函数
  def call_back(future):
      print("call_back:", future.result())

  coroutine = run("百度")
  # 创建一个任务对象
  task = asyncio.ensure_future(coroutine)

  # 给任务添加回调，在任务结束后调用回调函数
  task.add_done_callback(call_back)

  loop = asyncio.get_event_loop()
  loop.run_until_complete(task)
  ```


  

### 3、多任务

- 同步

  同时请求"百度", "阿里", "腾讯", "新浪"四个网站，假设响应时长均为2秒

  ```python
  import time

  def run(url):
      print("开始向'%s'要数据……"%(url))
      # 向百度要数据，网络IO
      time.sleep(2)
      data = "'%s'的数据"%(url)
      return data

  if __name__ == "__main__":
      t1 = time.time()
      for url in ["百度", "阿里", "腾讯", "新浪"]:
          print(run(url))
      t2 = time.time()
      print("总耗时：%.2f"%(t2-t1))
  ```

- 异步

  同时请求"百度", "阿里", "腾讯", "新浪"四个网站，假设响应时长均为2秒

  使用ensure_future创建多任务

  ```python
  import time
  import asyncio

  async def run(url):
      print("开始向'%s'要数据……"%(url))
      await asyncio.sleep(2)
      data = "'%s'的数据"%(url)
      return data

  def call_back(future):
      print("call_back:", future.result())

  if __name__ == "__main__":
      loop = asyncio.get_event_loop()
      tasks = []
      t1 = time.time()
      
      for url in ["百度", "阿里", "腾讯", "新浪"]:
          coroutine = run(url)
          task = asyncio.ensure_future(coroutine)
          task.add_done_callback(call_back)
          tasks.append(task)
          
      # 同时添加4个异步任务
      # asyncio.wait(tasks) 将任务的列表又变成 <coroutine object wait at 0x7f80f43408c0>
      loop.run_until_complete(asyncio.wait(tasks))

      t2 = time.time()
      print("总耗时：%.2f" % (t2 - t1))
  ```

  + 封装成异步函数

    ```python
    import time
    import asyncio
    async def run(url):
        print("开始向'%s'要数据……" % (url))
        await asyncio.sleep(2)
        data = "'%s'的数据" % (url)
        return data
    def call_back(future):
        print("call_back:", future.result())

    async def main():
        tasks = []
        t1 = time.time()

        for url in ["百度", "阿里", "腾讯", "新浪"]:
            coroutine = run(url)
            task = asyncio.ensure_future(coroutine)
            task.add_done_callback(call_back)
            tasks.append(task)

        # 同时添加4个异步任务
        await asyncio.wait(tasks)
        t2 = time.time()
        print("总耗时：%.2f" % (t2 - t1))

    if __name__ == "__main__":
        loop = asyncio.get_event_loop()
        loop.run_until_complete(main())

    ```

  使用loop.create_task创建多任务

  ```python
  import time
  import asyncio
  async def run(url):
        print("开始向'%s'要数据……" % (url))
    await asyncio.sleep(2)
    data = "'%s'的数据" % (url)
    return data
  def call_back(future):
        print("call_back:", future.result())
  if name == "main":
    loop = asyncio.get_event_loop()
    tasks = []
    t1 = time.time()

    for url in ["百度", "阿里", "腾讯", "新浪"]:
        coroutine = run(url)
        # task = asyncio.ensure_future(coroutine)
        task = loop.create_task(coroutine)
        task.add_done_callback(call_back)
        tasks.append(task)
        # 同时添加4个异步任务
    loop.run_until_complete(asyncio.wait(tasks))

    t2 = time.time()
    print("总耗时：%.2f" % (t2 - t1))
  ```


+   封装成异步函数

    ```python
    import time
    import asyncio
    async def run(url):
        print("开始向'%s'要数据……" % (url))
        await asyncio.sleep(2)
        data = "'%s'的数据" % (url)
        return data
      
    def call_back(future):
        print("call_back:", future.result())
        
        
    async def main():
        tasks = []
        t1 = time.time()
        for url in ["百度", "阿里", "腾讯", "新浪"]:
            coroutine = run(url)
            task = loop.create_task(coroutine)
            task.add_done_callback(call_back)
            tasks.append(task)
        # 同时添加4个异步任务
        await asyncio.wait(tasks)
        t2 = time.time()
        print("总耗时：%.2f" % (t2 - t1))

    if __name__ == "__main__":
      	# asyncio.run(main())
        loop = asyncio.get_event_loop()
        loop.run_until_complete(main())
    ```

  使用asyncio.create_task创建多任务

```python
  import time
  import asyncio


  async def run(url):
      print("开始向'%s'要数据……" % (url))
      await asyncio.sleep(2)
      data = "'%s'的数据" % (url)
      return data


  def call_back(future):
      print("call_back:", future.result())


  async def main():
      tasks = []
      t1 = time.time()
      for url in ["百度", "阿里", "腾讯", "新浪"]:
          coroutine = run(url)
          task = asyncio.create_task(coroutine)
          task.add_done_callback(call_back)
          tasks.append(task)
      # 同时添加4个异步任务
      await asyncio.wait(tasks)
      t2 = time.time()
      print("总耗时：%.2f" % (t2 - t1))

  if __name__ == "__main__":
      # asyncio.run(main())
      loop = asyncio.get_event_loop()
      loop.run_until_complete(main())
```

  ​

### 4、Task 概念及用法

+ Task，是 python 中与事件循环进行交互的一种主要方式。

  创建 Task，意思就是把协程封装成 Task 实例，并追踪协程的 运行 / 完成状态，用于未来获取协程的结果。

+ Task 核心作用: 在事件循环中添加多个并发任务;

  具体来说，是通过 asyncio.create_task() 创建 Task，让协程对象加入事件循环中，等待被调度执行。

  **注意:**Python 3.7 以后的版本支持 asyncio.create_task() ，在此之前的写法为 loop.create_task() ，开发过程中需要注意代码写 法对不同版本 python 的兼容性。

+ 需要指出的是，协程封装为 Task 后不会立马启动，当某个代码 await 这个 Task 的时候才会被执行。

  当多个 Task 被加入一个 task_list 的时候，添加 Task 的过程中 Task 不会执行，必须要用 `await asyncio.wait() `或 `await asyncio.gather()` 将 Task 对象加入事件循环中异步执行。

+ 一般在开发中，常用的写法是这样的:

  -- 先创建 task_list 空列表;
  -- 然后用 asyncio.create_task() 创建 Task;

  -- 再把 Task 对象加入 task_list ;

  -- 最后使用 await asyncio.wait 或 await asyncio.gather 将 Task 对象加入事件循环中异步执行。

  **注意:** 创建 Task 对象时，除了可以使用 asyncio.create_task() 之外，还可以用最低层级的 loop.create_task() 或 asyncio.ensure_future() ，他们都可以用来创建 Task 对象，其中关于 ensure_future 相关内容本文接下来会一起讲。

+ Task 简单用法

```python
import asyncio

async def func():
    print(1)
    await asyncio.sleep(2)
    print(2)
    return "test"


async def main():
    print("main start")

    # python 3.7及以上版本的写法
    task1 = asyncio.create_task(func())
    task2 = asyncio.create_task(func())

    # python3.7以前的写法
    # task1 = asyncio.ensure_future(func())
    # task2 = asyncio.ensure_future(func())
    print("main end")

    ret1 = await task1
    ret2 = await task2

    print(ret1, ret2)


# python3.7以后的写法
asyncio.run(main())

# python3.7以前的写法
# loop = asyncio.get_event_loop()
# loop.run_until_complete(main())

"""
在创建task的时候，就将创建好的task添加到了时间循环当中，所以说必须得有时间循环，才可以创建task，否则会报错
"""
```

+ task用法实例

  ```python
  import asyncio
  import arrow

  def current_time():
      '''
      获取当前时间
      :return:
      '''
      cur_time = arrow.now().to('Asia/Shanghai').format('YYYY-MM-DD HH:mm:ss')
      return cur_time
    
  async def func(sleep_time):
      func_name_suffix = sleep_time # 使用 sleep_time (函数 I/O 等待时长)作为函数名后缀，以区分任务对象
      print(f"[{current_time()}] 执行异步函数 {func.name}-{func_name_suffix}")
      await asyncio.sleep(sleep_time)
      print(f"[{current_time()}]函数{func.name}-{func_name_suffix} 执行完毕")
      return f"【[{current_time()}] 得到函数 {func.name}-{func_name_suffix} 执行结果】"

  async def run():
      task_list = []
      for i in range(5):
        task = asyncio.create_task(func(i))
        task_list.append(task)
        done, pending = await asyncio.wait(task_list)
        for done_task in done:
          print((f"[{current_time()}]得到执行结果 {done_task.result()}"))
    def main():
        loop = asyncio.get_event_loop()
        loop.run_until_complete(run())

  if name == 'main':
        main()
  ```

+ 代码执行结果如下:

  ```python
  /usr/local/bin/python3.7 /Users/xialigang/PycharmProjects/爬虫/123.py
  [2022-07-01 16:44:57] 执行异步函数 func-0
  [2022-07-01 16:44:57] 执行异步函数 func-1
  [2022-07-01 16:44:57] 执行异步函数 func-2
  [2022-07-01 16:44:57] 执行异步函数 func-3
  [2022-07-01 16:44:57] 执行异步函数 func-4
  [2022-07-01 16:44:57]函数func-0 执行完毕
  [2022-07-01 16:44:58]函数func-1 执行完毕
  [2022-07-01 16:44:59]函数func-2 执行完毕
  [2022-07-01 16:45:00]函数func-3 执行完毕
  [2022-07-01 16:45:01]函数func-4 执行完毕
  [2022-07-01 16:45:01]得到执行结果 【[2022-07-01 16:44:59] 得到函数 func-2 执行结果】
  [2022-07-01 16:45:01]得到执行结果 【[2022-07-01 16:44:57] 得到函数 func-0 执行结果】
  [2022-07-01 16:45:01]得到执行结果 【[2022-07-01 16:45:00] 得到函数 func-3 执行结果】
  [2022-07-01 16:45:01]得到执行结果 【[2022-07-01 16:44:58] 得到函数 func-1 执行结果】
  [2022-07-01 16:45:01]得到执行结果 【[2022-07-01 16:45:01] 得到函数 func-4 执行结果】

  Process finished with exit code 0
  ```

### 5、协程嵌套与返回值

使用async可以定义协程，协程用于耗时的io操作，我们也可以封装更多的io操作过程，这样就实现了嵌套的协程，即一个协程中await了另外一个协程，如此连接起来

![2020-01-1317_34_29](Coroutine/2020-01-1317_34_29.png)

```python
import time
import asyncio

async def run(url):
    print("开始向'%s'要数据……"%(url))
    await asyncio.sleep(2)
    data = "'%s'的数据"%(url)
    return data

def call_back(future):
    print("call_back:", future.result())

async def main():
    tasks = []
    for url in ["百度", "阿里", "腾讯", "新浪"]:
        coroutine = run(url)
        task = asyncio.ensure_future(coroutine)
        # task.add_done_callback(call_back)
        tasks.append(task)

    # #1、可以没有回调函数
    # dones, pendings = await asyncio.wait(tasks)
    # #处理数据，类似回调，建议使用回调
    # for t in dones:
    #     print("数据：%s"%(t.result()))

    # #2、可以没有回调函数
    # results = await asyncio.gather(*tasks)
    # # 处理数据，类似回调，建议使用回调
    # for result in results:
    #     print("数据：%s"%(result))


    # 3、有无回调函数均可以
    # return await asyncio.wait(tasks)


    # 4、有无回调函数均可以
    # return await asyncio.gather(*tasks)



if __name__ == "__main__":
    t1 = time.time()
    loop = asyncio.get_event_loop()
    #1、
    # loop.run_until_complete(main())
    # asyncio.run(main()) # 等同于上面两行代码

    #2、
    # loop.run_until_complete(main())

    # # 3、
    # dones, pendings = loop.run_until_complete(main())
    # #处理数据，类似回调，建议使用回调
    # for t in dones:
    #     print("数据：%s"%(t.result()))

    # 4、
    # results = loop.run_until_complete(main())
    # for result in results:
    #     print("数据：%s"%(result))

    t2 = time.time()
    print("总耗时：%.2f" % (t2 - t1))
```

+ asyncio.wait和asyncio.gather的异同

  1. 异同点综述

  相同:从功能上看， asyncio.wait 和 asyncio.gather 实现的效果是相同的，都是把所有 Task 任务结果收集起来。

  不同: asyncio.wait 会返回两个值: done 和 pending ， done 为已完成的协程 Task ， pending 为超时未完成的协程 Task ，需通过 future.result 调用 Task 的 result ;而 asyncio.gather 返回的是所有已完成 Task 的 result ，不需要再进行调用或其他操作，就可以得到全部结果。

  2. asyncio.wait 用法:

  最常见的写法是: `await asyncio.wait(task_list) 。`

  ```python
  import asyncio
  import arrow

  def current_time():
      '''
      获取当前时间
      :return:
       '''
      cur_time = arrow.now().to('Asia/Shanghai').format('YYYY-MM-DD HH:mm:ss')
      return cur_time

  async def func(sleep_time):
      func_name_suffix = sleep_time # 使用 sleep_time (函数 I/O 等待时长)作为函数名后缀，以区分任务对象
      print(f"[{current_time()}] 执行异步函数 {func.__name__}-{func_name_suffix}")
      await asyncio.sleep(sleep_time)
      print(f"[{current_time()}]函数{func.__name__}-{func_name_suffix} 执行完毕")
      return f"【[{current_time()}] 得到函数 {func.__name__}-{func_name_suffix} 执行结果】"

  async def run():
      task_list = []
      for i in range(5):
          task = asyncio.create_task(func(i))
          task_list.append(task)

      done, pending = await asyncio.wait(task_list)
      for done_task in done:
          print((f"[{current_time()}]得到执行结果 {done_task.result()}"))

  def main():
      loop = asyncio.get_event_loop()
      loop.run_until_complete(run())

  if __name__ == '__main__':
      main()
  ```

  代码执行结果如下:

  ```python
  /usr/local/bin/python3.7 /Users/xialigang/PycharmProjects/爬虫/123.py
  [2022-07-04 15:31:47] 执行异步函数 func-0
  [2022-07-04 15:31:47] 执行异步函数 func-1
  [2022-07-04 15:31:47] 执行异步函数 func-2
  [2022-07-04 15:31:47] 执行异步函数 func-3
  [2022-07-04 15:31:47] 执行异步函数 func-4
  [2022-07-04 15:31:47]函数func-0 执行完毕
  [2022-07-04 15:31:48]函数func-1 执行完毕
  [2022-07-04 15:31:49]函数func-2 执行完毕
  [2022-07-04 15:31:50]函数func-3 执行完毕
  [2022-07-04 15:31:51]函数func-4 执行完毕
  [2022-07-04 15:31:51]得到执行结果 【[2022-07-04 15:31:49] 得到函数 func-2 执行结果】
  [2022-07-04 15:31:51]得到执行结果 【[2022-07-04 15:31:47] 得到函数 func-0 执行结果】
  [2022-07-04 15:31:51]得到执行结果 【[2022-07-04 15:31:50] 得到函数 func-3 执行结果】
  [2022-07-04 15:31:51]得到执行结果 【[2022-07-04 15:31:48] 得到函数 func-1 执行结果】
  [2022-07-04 15:31:51]得到执行结果 【[2022-07-04 15:31:51] 得到函数 func-4 执行结果】

  Process finished with exit code 0
  ```

  3. asyncio.gather 用法:

  最常见的用法是: `await asyncio.gather(*task_list)` ，注意这里 `task_list` 前面有一个 `* `。

  ```python
  import asyncio
  import arrow

  def current_time():
      '''
      获取当前时间
      :return:
       '''
      cur_time = arrow.now().to('Asia/Shanghai').format('YYYY-MM-DD HH:mm:ss')
      return cur_time

  async def func(sleep_time):
      func_name_suffix = sleep_time # 使用 sleep_time (函数 I/O 等待时长)作为函数名后缀，以区分任务对象
      print(f"[{current_time()}] 执行异步函数 {func.__name__}-{func_name_suffix}")
      await asyncio.sleep(sleep_time)
      print(f"[{current_time()}]函数{func.__name__}-{func_name_suffix} 执行完毕")
      return f"【[{current_time()}] 得到函数 {func.__name__}-{func_name_suffix} 执行结果】"

  async def run():
      task_list = []
      for i in range(5):
          task = asyncio.create_task(func(i))
          task_list.append(task)

      results = await asyncio.gather(*task_list)
      for result in results:
          print((f"[{current_time()}]得到执行结果 {result}"))

  def main():
      loop = asyncio.get_event_loop()
      loop.run_until_complete(run())

  if __name__ == '__main__':
      main()
  ```

  代码执行结果如下:

  ```python
  /usr/local/bin/python3.7 /Users/xialigang/PycharmProjects/爬虫/123.py
  [2022-07-04 15:33:24] 执行异步函数 func-0
  [2022-07-04 15:33:24] 执行异步函数 func-1
  [2022-07-04 15:33:24] 执行异步函数 func-2
  [2022-07-04 15:33:24] 执行异步函数 func-3
  [2022-07-04 15:33:24] 执行异步函数 func-4
  [2022-07-04 15:33:24]函数func-0 执行完毕
  [2022-07-04 15:33:25]函数func-1 执行完毕
  [2022-07-04 15:33:26]函数func-2 执行完毕
  [2022-07-04 15:33:27]函数func-3 执行完毕
  [2022-07-04 15:33:28]函数func-4 执行完毕
  [2022-07-04 15:33:28]得到执行结果 【[2022-07-04 15:33:24] 得到函数 func-0 执行结果】
  [2022-07-04 15:33:28]得到执行结果 【[2022-07-04 15:33:25] 得到函数 func-1 执行结果】
  [2022-07-04 15:33:28]得到执行结果 【[2022-07-04 15:33:26] 得到函数 func-2 执行结果】
  [2022-07-04 15:33:28]得到执行结果 【[2022-07-04 15:33:27] 得到函数 func-3 执行结果】
  [2022-07-04 15:33:28]得到执行结果 【[2022-07-04 15:33:28] 得到函数 func-4 执行结果】

  Process finished with exit code 0
  ```



## 四、aiohttp 与 aiofiles

### 1、安装与使用

```console
pip install aiohttp 
```

### 2、简单实例使用

aiohttp 的自我介绍中就包含了客户端和服务器端，所以我们分别来看下客户端和服务器端的简单实例代码。

客户端：

```python
import aiohttp
import asyncio

async def fetch(session, url):
    async with session.get(url) as response:
        return await response.text()


async def main():
    async with aiohttp.ClientSession() as session:
        html = await fetch(session, "http://httpbin.org/headers")
        print(html)

asyncio.run(main())


"""输出结果：
{
  "headers": {
    "Accept": "*/*", 
    "Accept-Encoding": "gzip, deflate", 
    "Host": "httpbin.org", 
    "User-Agent": "Python/3.7 aiohttp/3.6.2"
  }
}
"""
```

这个代码是不是很简单，一个函数用来发起请求，另外一个函数用来下载网页。

### 3、入门

简单示范

首先是学习客户端，也就是用来发送http请求的用法。首先看一段代码，会在代码中讲述需要注意的地方：

```python
import aiohttp
import asyncio

async def main():
    async with aiohttp.ClientSession() as session:
        async with session.get('http://httpbin.org/get') as resp:
            print(resp.status)
            print(await resp.text())

asyncio.run(main())
```

代码解释：

在网络请求中，一个请求就是一个会话，然后**aiohttp**使用的是**ClientSession**来管理会话，所以第一个重点，看一下**ClientSession**:

```python
class ClientSession:
    """First-class interface for making HTTP requests."""
```

在源码中，这个类的注释是使用HTTP请求接口的第一个类。然后上面的代码就是实例化一个*ClientSession*类然后命名为session，然后用session去发送请求。这里有一个坑，那就是`ClientSession.get()`协程的必需参数只能是`str`类和`yarl.URL`的实例。

当然这只是get请求，其他的请求都是支持的：

```python
session.post('http://httpbin.org/post', data='data')
session.get('http://httpbin.org/get')
```

### 4、在URL中传递参数

有时候在发起网络请求的时候需要附加一些参数到url中，这一点也是支持的。

```python
import aiohttp
import asyncio

async def main():
    async with aiohttp.ClientSession() as session:
        params = {'key1': 'value1', 'key2': 'value2'}
        async with session.get('http://httpbin.org/get',
                               params=params) as resp:
            print(resp.url)

asyncio.run(main())
```

我们可以通过`params`参数来指定要传递的参数，

同时如果需要指定一个键对应多个值的参数，那么`MultiDict`就在这个时候起作用了。你可以传递两个元祖列表来作为参数：

```python
import aiohttp
import asyncio

async def main():
    async with aiohttp.ClientSession() as session:
        params = [('key', 'value1'), ('key', 'value2')]

        async with session.get('http://httpbin.org/get',
                               params=params) as r:
            expect = 'http://httpbin.org/get?key=value2&key=value1'
            # assert str(r.url) == expect
            print(r.url)
asyncio.run(main())
```



### 5、读取响应内容

我们可以读取到服务器的响应状态和响应内容，这也是使用请求的一个很重要的部分。通过`status`来获取响应状态码，`text()`来获取到响应内容，当然也可以之计指明编码格式为你想要的编码格式：

```python
async def main():
    async with aiohttp.ClientSession() as session:
        async with session.get('http://httpbin.org/get') as resp:
            print(resp.status)
            print(await resp.text(encoding=utf-8))
            
"""输出结果：
200
<!doctype html>
<html lang="zh-CN">
<head>
......

"""
```

### 6、非文本内容格式

对于网络请求，有时候是去访问一张图片，这种返回值是二进制的也是可以读取到的：

```python
await resp.read()
```

将`text()`方法换成`read()`方法就好。

### 7、请求的自定义

*ClientResponse（客户端响应）*对象含有request_info(请求信息)，主要是*url*和*headers*信息。 *raise_for_status*结构体上的信息会被复制给ClientResponseError实例。

#### (1) 自定义Headers

有时候做请求的时候需要自定义headers，主要是为了让服务器认为我们是一个浏览器。然后就需要我们自己来定义一个headers：

```python
headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
                      "AppleWebKit/537.36 (KHTML, like Gecko)"
                      " Chrome/78.0.3904.108 Safari/537.36"
    }
await session.post(url, headers=headers)
```

#### (2) 如果出现ssl验证失败的处理

```python
import aiohttp
import asyncio
from aiohttp import TCPConnector


async def main():
    async with aiohttp.ClientSession(connector=TCPConnector(ssl=False)) as session:
		pass
asyncio.run(main())
```

#### (3) 自定义cookie

发送你自己的cookies给服务器，你可以为ClientSession对象指定cookies参数:

```python
url = 'http://httpbin.org/cookies'
cookies = {'cookies_are': 'working'}
async with ClientSession(cookies=cookies) as session:
    async with session.get(url) as resp:
        assert await resp.json() == {
           "cookies": {"cookies_are": "working"}}
```

#### (4) 使用代理

有时候在写爬虫的时候需要使用到代理，所以*aiohttp*也是支持使用代理的，我们可以在发起请求的时候使用代理，只需要使用关键字`proxy`来指明就好，但是有一个很难受的地方就是它只支持`http`代理，不支持**HTTPS**代理。使用起来大概是这样：

```python
proxy = "http://127.0.0.1:10809
async with aiohttp.ClientSession(headers=headers) as session:
  async with session.get(url=login_url, proxy=proxy) as response:
    resu = await response.text()
```

使用起来大概是这样，然后代理记得改成自己的。



### 8、aiofiles 文件读写

#### 8.1 概述

平常使用的file操作模式为同步，并且为线程阻塞。当程序I/O[并发](https://so.csdn.net/so/search?q=并发&spm=1001.2101.3001.7020)次数高的时候，CPU被阻塞，形成闲置。

线程开启文件读取异步模式

用线程（Thread）方式来解决。硬盘缓存可以被多个线程访问，因此通过不同线程访问文件可以部分解决。但此方案涉及线程开启关闭的开销，而且不同线程间数据交互比较麻烦。

```python
from threading import Thread
for file in list_file:
     tr = Thread(target=file.write, args=(data,))
     tr.start()
```

使用已编写好的第三方插件-aiofiles，支持异步模式

使用aio插件来开启文件的非阻塞异步模式。

#### 8.2 安装方法

```python
pip install aiofiles
```

这个插件的使用和python原生open 一致，而且可以支持异步迭代

#### 8.3 实例

打开文件

```python
import asyncio
import aiofiles

async def main():
    async with aiofiles.open('first.m3u8', mode='r') as f:
        contents = await f.read()
        print(contents)

if __name__ == '__main__':
    asyncio.run(main())
```

迭代

```python
import asyncio
import aiofiles

async def main():
    async with aiofiles.open('filename') as f:
        async for line in f:
            print(line)

if __name__ == '__main__':
    asyncio.run(main())
```



### 9、并发控制

semaphore，控制并发

```
semaphore = asyncio.Semaphore(10) 
```

实例

```python
#!/usr/bin/python

import asyncio
import os
import aiofiles
import aiohttp
import requests
from bs4 import BeautifulSoup


def get_page_source(web):
    headers = {
        'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36'
    }
    response = requests.get(web, headers=headers)
    response.encoding = 'utf-8'
    return response.text


def parse_page_source(html):
    book_list = []
    soup = BeautifulSoup(html, 'html.parser')
    a_list = soup.find_all('div', attrs={'class': 'mulu-list quanji'})
    for a in a_list:
        a_list = a.find_all('a')
        for href in a_list:
            chapter_url = href['href']
            book_list.append(chapter_url)
    return book_list


def get_book_name(book_page):
    book_number = book_page.split('/')[-1].split('.')[0]
    book_chapter_name = book_page.split('/')[-2]
    return book_number, book_chapter_name


async def aio_download_one(chapter_url, signal):
    number, c_name = get_book_name(chapter_url)
    for c in range(10):
        try:
            async with signal:
                async with aiohttp.ClientSession() as session:
                    async with session.get(chapter_url) as resp:
                        page_source = await resp.text()
                        soup = BeautifulSoup(page_source, 'html.parser')
                        chapter_name = soup.find('h1').text
                        p_content = soup.find('div', attrs={'class': 'neirong'}).find_all('p')
                        content = [p.text + '\n' for p in p_content]
                        chapter_content = '\n'.join(content)
                        if not os.path.exists(f'{book_name}/{c_name}'):
                            os.makedirs(f'{book_name}/{c_name}')
                        async with aiofiles.open(f'{book_name}/{c_name}/{number}_{chapter_name}.txt', mode="w",
                                                 encoding='utf-8') as f:
                            await f.write(chapter_content)
                        print(chapter_url, "下载完毕!")
                        return ""
        except Exception as e:
            print(e)
            print(chapter_url, "下载失败!, 重新下载. ")
    return chapter_url


async def aio_download(url_list):
    tasks = []
    semaphore = asyncio.Semaphore(10)
    for h in url_list:
        tasks.append(asyncio.create_task(aio_download_one(h, semaphore)))
    await asyncio.wait(tasks)


if __name__ == '__main__':
    url = 'https://www.51shucheng.net/daomu/guichuideng'
    book_name = '鬼吹灯'
    if not os.path.exists(book_name):
        os.makedirs(book_name)
    source = get_page_source(url)
    href_list = parse_page_source(source)
    loop = asyncio.get_event_loop()
    loop.run_until_complete(aio_download(href_list))
    loop.close()
```

> 需要注意，当前对于Windows系统可能会有报错，原因出在文件名称有特殊字符，可以将特殊字符进行替换后即可
{: .prompt-info }