---
title: 后端服务启停脚本
author: 
date: 2024-12-02 11:17:06 +0800
categories: [Uncategorized]
tags: [Uncategorized]
pin: false
math: true
mermaid: true
---

后端服务的启停脚本一般具备4个功能：

1. 启动服务
2. 停止服务
3. 查看服务当前状态
4. 重启服务

```shell
#!/bin/bash
source /etc/init.d/functions
GREEN='\033[1;32m' # 绿色
RES='\033[0m'
SRV="daemon"
# daemon程序的绝对路径
PROG="/usr/bin/$SRV"
# 锁文件
LOCK_FILE="/home/backend/lock/$SRV"
RET=0
# 服务启动函数
function start() {
    mkdir -p /home/backend/lock
    # 锁文件不存在，说明服务没有启动
    if [ ! -f $LOCK_FILE]; then
        echo -n $"Starting $PROG: "
        # 启动服务，success和failure函数是系统封装的shell函数，success函数在终端输出
        # “[OK]”，failure函数则在终端输出“[FAILED]”
        $PROG && success || failure
        RET=$?
        # 创建锁文件
        touch $LOCK_FILE
        echo
    else 
        # 获取服务进程id，如果获取成功，则表明服务已经在运行，否则启动服务
        PID=$(pidof $PROG)
        if [ ! -z "$PID"] ; then
            echo -e "$SRV(${GREEN}$PID${RES}) is already running..."
        else 
            # 服务进程id不存在，启动服务
            echo -n $"Starting $PROG: "
            $PROG && success || failure
            RES=$?
            echo
        fi
    fi
    return $RET
}

# 服务停止函数
function stop() {
    # 锁文件不存在，说明服务已经停止
    if [ ! -f $LOCK_FILE ]; then
        echo "$SRV is stopped"
        return $RET
    else
        echo -n $"Stopping $PROG: "
        # killproc函数是系统封装好的shell函数，用于停止服务
        killproc $PROG
        RET=$?
        # 删除锁文件
        rm -rf $LOCK_FILE
        echo
        return $RET
    fi
}

# 服务重启函数
function restart() {
    stop # 先停止服务
    start # 再重新启动服务
}

# 服务状态查看函数
function status() {
    if [ ! -f $LOCK_FILE ] ; then
        echo "$SRV is stopped"
    else
        PID=$(pidof $PROG)
        if [ -z "$PID" ] ; then
            echo "$SRV is dead but locked"
        else
            echo -e "$SRV(${GREEN}$PID${RES}) is running..."
        fi
    fi
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    status)
        status
        ;;
    *)
        # Usage
        echo $"Usage: $0 {start|stop|restart|status} [Backend service options]"
        exit 1
esac
exit $RET
```

## 加载系统自带的 shell 函数

服务启停脚本开头的“source /etc/init.d/functions”命令用于导入系统自带的定义在/etcinit.d/functions 脚本文件中的 shell 函数，以便在后面的 shell 脚本中调用这些函数。在服务启停脚本中，我们可以使用success和failure 函数，这两个函数分别用于向终端输出“[OK ]”和“[FAILED]”。

## 服务相关变量声明

这部分最常见的变量包括带绝对路径的服务名和锁文件。其中，锁文件用于判断服务是否被正常停止。当服务启动成功时，就会创建锁文件;而当服务被停止时，就会删除锁文件。也就是说，如果服务异常退出或者被手动“强杀”的话，锁文件是不会被删除的。因此，当服务不存在时，可以通过判断锁文件是否存在，来判断服务是否被正常停止。

除了刚才提到的常见变量，不同的服务可能还需要再配置一些其他特定的变量，这些变量的具体配置需要根据具体的服务来确定。例如，某个服务可能需要配置日志文件路径等。因此，在编写服务启停脚本时，需要根据具体的服务需求，配置相应的变量和参数,以便更好地管理和维护服务。

## 服务启动函数

start 函数用于启动服务。start 函数的逻辑如下:先判断锁文件是否存在，如果锁文件不存在，则表明服务没有启动，这时执行服务启动命令以启动服务，并创建锁文件。如果锁文件存在，则表明服务启动过但没有被停止，这时再判断服务是否存在。如果服务存在,则输出服务已经在运行中的提示信息，否则执行服务启动命令。

## 服务停止函数

stop函数用于停止服务。stop数的辑如下:先判断锁文件是否存在，如果锁文件不存在，则表明服务已经被停止，输出服务已经被停止的提示信息。如果锁文件存在，则表明服务没有被停止，这时执行服务停止命令以停止服务，最后删除锁文件。

## 服务重启函数

restant 函数用于重启服务。restart 函数的逻辑非常简单，就是先调用stop函数来停止服务，再调用start 函数来启动服务。

## 服务状态查看函数

status函数用于查看服务的状态，服务存在三种状态。

* 当锁文件不存在时，表明服务已经被停止。
* 当锁文件存在但服务不存在时，表明服务是异常退出的或是被手动“强杀”的。面
* 锁文件存在且服务正常运行。

## case 语句

case语句的逻辑简单明了，就是根据服务启停脚本携带的不同参数，执行不同的函数服务启停脚本有两种使用方式:一种是直接执行脚本，比如/etc/init.d/daemond start;另种是通过 service 命令来启动，比如service daemond start，service 命令会自动执行脚本/etcinit.d/daemond 并把 start 参数传递给这个脚本。

通过上面的介绍，我们发现编写服务启停脚本并不难，只需要按照逻辑写好不同的部分即可。不同服务启停脚本的主要差异体现在启停命令的不同，而其他部分的逻辑大体相同。因此，在编写服务启停脚本时，可以先参考其他已有的脚本，再根据具体的服务需求进行相应的修改和调整。
