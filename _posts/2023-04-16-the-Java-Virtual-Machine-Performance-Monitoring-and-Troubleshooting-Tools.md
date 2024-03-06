---
title: 性能监控与故障处理工具
date: 2023-04-16 21:09:00 +0800
author: 
categories: [JVM]
tags: [JVM]
pin: false
math: false
mermaid: false
---

# 虚拟机性能监控与故障处理工具

给一个系统定位问题的时候， 知识、 经验是关键基础， 数据是依据， 工具是运用知识处理数据的手段。这里说的数据包括但不限于异常堆栈、 虚拟机运行日志、 垃圾收集器日志、 线程快照（threaddump/javacore文件） 、 堆转储快照（heapdump/hprof文件） 等。恰当地使用虚拟机故障处理、分析的工具可以提升我们分析数据、 定位并解决问题的效率， 但我们在学习工具前， 也应当意识到工具永远都是知识技能的一层包装， 没有什么工具是“秘密武器”， 拥有了就能“包治百病”。


## 基础故障处理

jdk/bin目录：命令行工具，编译、运行、打包、部署、签名、调试、监控、运维

```shell
# risk@DESKTOP-0VC22M5:/usr/lib/jvm$ tree . java-11-openjdk-amd64/ -L 1
.
├── default-java -> java-1.11.0-openjdk-amd64
├── java-1.11.0-openjdk-amd64 -> java-11-openjdk-amd64
├── java-11-openjdk-amd64
└── openjdk-11
java-11-openjdk-amd64/
├── bin
├── conf
├── docs -> ../../../share/doc/openjdk-11-jre-headless
├── include
├── jmods
├── legal
├── lib
├── man
└── release

8 directories, 1 file

```

### jps：虚拟机进程状况工具

可以列出正在运行的虚拟机进程，并显示虚拟机执行主类（Main Class，main()函数所在的类）名称以及这些进程的本地虚拟机唯一ID（LVMID，Local Virtual Machine Identifier）

```shell
# risk@DESKTOP-0VC22M5:/usr/lib/jvm$ jps -h
usage: jps [--help]
       jps [-q] [-mlvV] [<hostid>]

Definitions:
    <hostid>:      <hostname>[:<port>]
    -? -h --help -help: Print this help message and exit.
```

### jstat：虚拟机统计信息监视工具

jstat（JVM Statistics Monitoring Tool）是用于监视虚拟机各种运行状态信息的命令行工具。它可以显示本地或者远程虚拟机进程中的类加载、内存、垃圾收集、即时编译等运行时数据，在没有GUI图形界面、只提供了纯文本控制台环境的服务器上，它将是运行期定位虚拟机性能问题的常用工具。

```shell
# risk@DESKTOP-0VC22M5:/usr/lib/jvm$ jstat -h
Usage: jstat --help|-options
       jstat -<option> [-t] [-h<lines>] <vmid> [<interval> [<count>]]

Definitions:
  <option>      An option reported by the -options option
  <vmid>        Virtual Machine Identifier. A vmid takes the following form:
                     <lvmid>[@<hostname>[:<port>]]
                Where <lvmid> is the local vm identifier for the target
                Java virtual machine, typically a process id; <hostname> is
                the name of the host running the target Java virtual machine;
                and <port> is the port number for the rmiregistry on the
                target host. See the jvmstat documentation for a more complete
                description of the Virtual Machine Identifier.
  <lines>       Number of samples between header lines.
  <interval>    Sampling interval. The following forms are allowed:
                    <n>["ms"|"s"]
                Where <n> is an integer and the suffix specifies the units as
                milliseconds("ms") or seconds("s"). The default units are "ms".
  <count>       Number of samples to take before terminating.
  -J<flag>      Pass <flag> directly to the runtime system.
  -? -h --help  Prints this help message.
  -help         Prints this help message.
```

### jinfo：Java配置信息工具

jinfo（Configuration Info for Java）的作用是实时查看和调整虚拟机各项参数

```shell
risk@DESKTOP-0VC22M5:/usr/lib/jvm$ jinfo -h
Usage:
    jinfo <option> <pid>
       (to connect to a running process)

where <option> is one of:
    -flag <name>         to print the value of the named VM flag
    -flag [+|-]<name>    to enable or disable the named VM flag
    -flag <name>=<value> to set the named VM flag to the given value
    -flags               to print VM flags
    -sysprops            to print Java system properties
    <no option>          to print both VM flags and system properties
    -? | -h | --help | -help to print this help message
```

### jmap：Java内存映像工具

jmap（Memory Map for Java）命令用于生成堆转储快照（一般称为heapdump或dump文件），它还可以查询finalize执行队列、Java堆和方法区的详细信息，如空间使用率、当前用的是哪种收集器等。

```shell
# risk@DESKTOP-0VC22M5:/usr/lib/jvm$ jmap -h
Usage:
    jmap -clstats <pid>
        to connect to running process and print class loader statistics
    jmap -finalizerinfo <pid>
        to connect to running process and print information on objects awaiting finalization
    jmap -histo[:live] <pid>
        to connect to running process and print histogram of java object heap
        if the "live" suboption is specified, only count live objects
    jmap -dump:<dump-options> <pid>
        to connect to running process and dump java heap
    jmap -? -h --help
        to print this help message

    dump-options:
      live         dump only live objects; if not specified,
                   all objects in the heap are dumped.
      format=b     binary format
      file=<file>  dump heap to <file>
      parallel=<number>  parallel threads number for heap iteration:
                         parallel=0 default behavior, use predefined number of threads
                         parallel=1 disable parallel heap iteration
                         parallel=<N> use N threads for parallel heap iteration

    Example: jmap -dump:live,format=b,file=heap.bin <pid>
```

### jhat：虚拟机堆转储快照分析工具

JDK提供jhat（JVM Heap Analysis Tool）命令与jmap搭配使用，来分析jmap生成的堆转储快照。

**jdk8?**

### jstack：Java堆栈跟踪工具

jstack（Stack Trace for Java）命令用于生成虚拟机当前时刻的线程快照（一般称为threaddump或者javacore文件）。

线程快照就是当前虚拟机内每一条线程正在执行的方法堆栈的集合，生成线程快照的目的通常是定位线程出现长时间停顿的原因，如线程间死锁、死循环、请求外部资源导致的长时间挂起等，都是导致线程长时间停顿的常见原因。

线程出现停顿时通过jstack来查看各个线程的调用堆栈，就可以获知没有响应的线程到底在后台做些什么事情，或者等待着什么资源

```shell
risk@DESKTOP-0VC22M5:/usr/lib/jvm$ jstack -?
Usage:
    jstack [-l][-e] <pid>
        (to connect to running process)

Options:
    -l  long listing. Prints additional information about locks
    -e  extended listing. Prints additional information about threads
    -? -h --help -help to print this help message
```

## 可视化故障处理

### JHSDB：基于服务性代理的调试工具

JHSDB是一款基于服务性代理（Serviceability Agent，SA）实现的进程外调试工具。服务性代理是HotSpot虚拟机中一组用于映射Java虚拟机运行信息的、主要基于Java语言（含少量JNI代码）实现的API集合。

### JConsole：Java监视与管理控制台

JConsole（Java Monitoring and Management Console）是一款基于JMX（Java Manage-ment Extensions）的可视化监视、管理工具。

它的主要功能是通过JMX的MBean（Managed Bean）对系统进行信息收集和参数动态调整。

JMX是一种开放性的技术，不仅可以用在虚拟机本身的管理上，还可以运行于虚拟机之上的软件中，典型的如中间件大多也基于JMX来实现管理与监控。虚拟机对JMX MBean的访问也是完全开放的，可以使用代码调用API、支持JMX协议的管理控制台，或者其他符合JMX规范的软件进行访问。

### VisualVM：多合-故障处理工具

VisualVM（All-in-One Java Troubleshooting Tool）是功能最强大的运行监视和故障处理程序之一

VisualVM还有一个很大的优点：不需要被监视的程序基于特殊Agent去运行，因此它的通用性很强，对应用程序实际性能的影响也较小，使得它可以直接应用在生产环境中

### Java Mission Control：可持续在线的监控工具

用于持续收集数据的JFR（Java Flight Recorder）飞行记录仪

用于监控Java虚拟机的JMC（Java Mission Control）

现在的JMC不仅可以下载到独立程序，更常见的是作为Eclipse的插件来使用。JMC与虚拟机之间同样采取JMX协议进行通信，JMC一方面作为JMX控制台，显示来自虚拟机MBean提供的数据；另一方面作为JFR的分析工具，展示来自JFR的数据。

## Alibaba Arthas

阿里巴巴Arthas详解 <https://github.com/alibaba/arthas/>