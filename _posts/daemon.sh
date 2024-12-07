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
    echo $"Usage: $0 {start|stop|restart|status}"
    exit 1
esac
exit $RET