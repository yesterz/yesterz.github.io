---
title: Redis 源码安装 & 单机模拟集群搭建
author: someone
date: 2024-11-29 00:06:00 +0800
categories: [Uncategorized]
tags: [Uncategorized]
pin: false
math: false
mermaid: false
---

* Download page <https://redis.io/downloads/>
* Index of /releases <https://download.redis.io/releases/>

## 源码安装Redis

下载 Redis 源码压缩包，执行 make 命令来编译出二进制可执行文件：

```shell
[root@iZ7xv0pw76zi75nqelv576Z ~]# wget https://download.redis.io/releases/redis-6.2.7.tar.gz
--2024-11-28 19:25:52--  https://download.redis.io/releases/redis-6.2.7.tar.gz
Resolving download.redis.io (download.redis.io)... 45.60.125.1
Connecting to download.redis.io (download.redis.io)|45.60.125.1|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 2487287 (2.4M) [application/octet-stream]
Saving to: ‘redis-6.2.7.tar.gz’

100%[==============================================================================>] 2,487,287   5.71MB/s   in 0.4s

2024-11-28 19:25:53 (5.71 MB/s) - ‘redis-6.2.7.tar.gz’ saved [2487287/2487287]

[root@iZ7xv0pw76zi75nqelv576Z ~]# tar xzf redis-6.2.7.tar.gz
[root@iZ7xv0pw76zi75nqelv576Z ~]# cd redis-6.2.7/
[root@iZ7xv0pw76zi75nqelv576Z redis-6.2.7]# make
cd src && make all
make[1]: Entering directory `/root/redis-6.2.7/src'
    CC Makefile.dep
# ......
    CC redis-benchmark.o
    LINK redis-benchmark
    INSTALL redis-check-rdb
    INSTALL redis-check-aof

Hint: It's a good idea to run 'make test' ;)

make[1]: Leaving directory `/root/redis-6.2.7/src'
[root@iZ7xv0pw76zi75nqelv576Z redis-6.2.7]#
```

编译后，源码和可执行目录会混在一起（./bin），make install 将上一个步骤编译完成的内容安装到预定的目录中，从而完成安装。

```shell
[root@iZ7xv0pw76zi75nqelv576Z redis-6.2.7]# ls
00-RELEASENOTES  BUGS  CONDUCT  CONTRIBUTING  COPYING  deps  INSTALL  Makefile  MANIFESTO  README.md  redis.conf  runtest  runtest-cluster  runtest-moduleapi  runtest-sentinel  sentinel.conf  src  tests  TLS.md  utils
[root@iZ7xv0pw76zi75nqelv576Z redis-6.2.7]# make install PREFIX=/opt/redis
cd src && make install
make[1]: Entering directory `/root/redis-6.2.7/src'

Hint: It's a good idea to run 'make test' ;)

    INSTALL redis-server
    INSTALL redis-benchmark
    INSTALL redis-cli
make[1]: Leaving directory `/root/redis-6.2.7/src'
[root@iZ7xv0pw76zi75nqelv576Z redis-6.2.7]#


```



## 单机模拟搭建集群

* master: 0, 1, 2

* slave: 3, 4, 5

```shell
[root@iZ7xv0pw76zi75nqelv576Z conf]# vim redis7010.conf
[root@iZ7xv0pw76zi75nqelv576Z conf]# cp redis7010.conf redis7011.conf
[root@iZ7xv0pw76zi75nqelv576Z conf]# cp redis7010.conf redis7012.conf
[root@iZ7xv0pw76zi75nqelv576Z conf]# cp redis7010.conf redis7013.conf
[root@iZ7xv0pw76zi75nqelv576Z conf]# cp redis7010.conf redis7014.conf
[root@iZ7xv0pw76zi75nqelv576Z conf]# cp redis7010.conf redis7015.conf
[root@iZ7xv0pw76zi75nqelv576Z conf]# cat redis7010.conf
port 7010

pidfile /var/run/redis_7010.pid
logfile "/tmp/redis/logs/7010.log"
dir "/opt/redis/data/"
dbfilename dump-7010.rdb

# Cluster Config
daemonize yes
cluster-enabled yes
cluster-config-file nodes-7010.conf
cluster-node-timeout 15000
appendonly yes
appendfilename "appendonly-7010.aof"
[root@iZ7xv0pw76zi75nqelv576Z conf]#

```

vim全局替换`:%s/7010/7015`

```shell
[root@iZ7xv0pw76zi75nqelv576Z redis]# ./bin/redis-server conf/redis7010.conf
[root@iZ7xv0pw76zi75nqelv576Z redis]# ./bin/redis-server conf/redis7011.conf
[root@iZ7xv0pw76zi75nqelv576Z redis]# ./bin/redis-server conf/redis7012.conf
[root@iZ7xv0pw76zi75nqelv576Z redis]# ./bin/redis-server conf/redis7013.conf
[root@iZ7xv0pw76zi75nqelv576Z redis]# ./bin/redis-server conf/redis7014.conf
[root@iZ7xv0pw76zi75nqelv576Z redis]# ./bin/redis-server conf/redis7015.conf
[root@iZ7xv0pw76zi75nqelv576Z redis]# ps aux | grep redis
root     20041  0.1  0.0 162524  3288 pts/2    Sl+  20:35   0:14 ./bin/redis-server 127.0.0.1:6379
root     20050  0.0  0.2  25056  7820 pts/3    S+   20:35   0:00 ./bin/redis-cli
root     22014  0.0  0.2  25056  7820 pts/8    S+   21:36   0:00 ./bin/redis-cli
root     26620  0.1  0.0 162520  3056 ?        Ssl  23:43   0:00 ./bin/redis-server *:7010 [cluster]
root     26632  0.1  0.0 162520  3052 ?        Ssl  23:43   0:00 ./bin/redis-server *:7011 [cluster]
root     26638  0.1  0.0 162520  3052 ?        Ssl  23:43   0:00 ./bin/redis-server *:7012 [cluster]
root     26644  0.0  0.0 162520  3052 ?        Ssl  23:43   0:00 ./bin/redis-server *:7013 [cluster]
root     26650  0.0  0.0 162520  3060 ?        Ssl  23:43   0:00 ./bin/redis-server *:7014 [cluster]
root     26662  0.0  0.0 162520  3052 ?        Ssl  23:43   0:00 ./bin/redis-server *:7015 [cluster]
root     26668  0.0  0.0 112832  1028 pts/0    S+   23:43   0:00 grep --color=auto redis
[root@iZ7xv0pw76zi75nqelv576Z redis]#

```

创建集群随机主从节点

```shell
[root@iZ7xv0pw76zi75nqelv576Z redis]# ./bin/redis-cli --cluster create 127.0.0.1:7010 127.0.0.1:7011 127.0.0.1:7012 127.0.0.1:7013 127.0.0.1:7014 127.0.0.1:7015 --cluster-replicas 1
>>> Performing hash slots allocation on 6 nodes...
Master[0] -> Slots 0 - 5460
Master[1] -> Slots 5461 - 10922
Master[2] -> Slots 10923 - 16383
Adding replica 127.0.0.1:7014 to 127.0.0.1:7010
Adding replica 127.0.0.1:7015 to 127.0.0.1:7011
Adding replica 127.0.0.1:7013 to 127.0.0.1:7012
>>> Trying to optimize slaves allocation for anti-affinity
[WARNING] Some slaves are in the same host as their master
M: 2df2426c5a78262a3eebaa7c769f187911475ae9 127.0.0.1:7010
   slots:[0-5460] (5461 slots) master
M: 27930eede9393e04b438608e8d3aabffd5544608 127.0.0.1:7011
   slots:[5461-10922] (5462 slots) master
M: 13116f2b7895064d4a925225f2f84f9164cb58f2 127.0.0.1:7012
   slots:[10923-16383] (5461 slots) master
S: e388fca3643ba66341a0ae35b45fcc01d110d07b 127.0.0.1:7013
   replicates 27930eede9393e04b438608e8d3aabffd5544608
S: a02190fea6392393712284f7e2e81a36defd4540 127.0.0.1:7014
   replicates 13116f2b7895064d4a925225f2f84f9164cb58f2
S: 9b59b1b2b7a7e5e26feb3a7ff137e9acd1d8b599 127.0.0.1:7015
   replicates 2df2426c5a78262a3eebaa7c769f187911475ae9
Can I set the above configuration? (type 'yes' to accept): yes
>>> Nodes configuration updated
>>> Assign a different config epoch to each node
>>> Sending CLUSTER MEET messages to join the cluster
Waiting for the cluster to join
.
>>> Performing Cluster Check (using node 127.0.0.1:7010)
M: 2df2426c5a78262a3eebaa7c769f187911475ae9 127.0.0.1:7010
   slots:[0-5460] (5461 slots) master
   1 additional replica(s)
M: 27930eede9393e04b438608e8d3aabffd5544608 127.0.0.1:7011
   slots:[5461-10922] (5462 slots) master
   1 additional replica(s)
M: 13116f2b7895064d4a925225f2f84f9164cb58f2 127.0.0.1:7012
   slots:[10923-16383] (5461 slots) master
   1 additional replica(s)
S: a02190fea6392393712284f7e2e81a36defd4540 127.0.0.1:7014
   slots: (0 slots) slave
   replicates 13116f2b7895064d4a925225f2f84f9164cb58f2
S: 9b59b1b2b7a7e5e26feb3a7ff137e9acd1d8b599 127.0.0.1:7015
   slots: (0 slots) slave
   replicates 2df2426c5a78262a3eebaa7c769f187911475ae9
S: e388fca3643ba66341a0ae35b45fcc01d110d07b 127.0.0.1:7013
   slots: (0 slots) slave
   replicates 27930eede9393e04b438608e8d3aabffd5544608
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
[root@iZ7xv0pw76zi75nqelv576Z redis]#

```

以集群方式连接 ，redis客户端通过cluster info查看集群信息，通过cluster nodes查看节点信息

PS: -a 密码

   -c 集群方式（要加-c，不然节点之间无法自动跳转）

```shell
[root@iZ7xv0pw76zi75nqelv576Z ~]# redis-cli -p 7010 -c
127.0.0.1:7010> CLUSTER info
cluster_state:ok
cluster_slots_assigned:16384
cluster_slots_ok:16384
cluster_slots_pfail:0
cluster_slots_fail:0
cluster_known_nodes:6
cluster_size:3
cluster_current_epoch:6
cluster_my_epoch:1
cluster_stats_messages_ping_sent:480
cluster_stats_messages_pong_sent:531
cluster_stats_messages_sent:1011
cluster_stats_messages_ping_received:526
cluster_stats_messages_pong_received:480
cluster_stats_messages_meet_received:5
cluster_stats_messages_received:1011
127.0.0.1:7010> set A 11
-> Redirected to slot [6373] located at 127.0.0.1:7011
OK
127.0.0.1:7011>

```

redis-cli --cluster info 查看集群状态

```shell
[root@iZ7xv0pw76zi75nqelv576Z ~]# redis-cli --cluster info 127.0.0.1:7010
127.0.0.1:7010 (2df2426c...) -> 0 keys | 5461 slots | 1 slaves.
127.0.0.1:7011 (27930eed...) -> 1 keys | 5462 slots | 1 slaves.
127.0.0.1:7012 (13116f2b...) -> 0 keys | 5461 slots | 1 slaves.
[OK] 1 keys in 3 masters.
0.00 keys per slot on average.
[root@iZ7xv0pw76zi75nqelv576Z ~]# redis-cli --cluster info 127.0.0.1:7011
127.0.0.1:7011 (27930eed...) -> 1 keys | 5462 slots | 1 slaves.
127.0.0.1:7012 (13116f2b...) -> 0 keys | 5461 slots | 1 slaves.
127.0.0.1:7010 (2df2426c...) -> 0 keys | 5461 slots | 1 slaves.
[OK] 1 keys in 3 masters.
0.00 keys per slot on average.
[root@iZ7xv0pw76zi75nqelv576Z ~]# redis-cli --cluster info 127.0.0.1:7012
127.0.0.1:7012 (13116f2b...) -> 0 keys | 5461 slots | 1 slaves.
127.0.0.1:7011 (27930eed...) -> 1 keys | 5462 slots | 1 slaves.
127.0.0.1:7010 (2df2426c...) -> 0 keys | 5461 slots | 1 slaves.
[OK] 1 keys in 3 masters.
0.00 keys per slot on average.
[root@iZ7xv0pw76zi75nqelv576Z ~]# redis-cli --cluster info 127.0.0.1:7013
127.0.0.1:7011 (27930eed...) -> 1 keys | 5462 slots | 1 slaves.
127.0.0.1:7012 (13116f2b...) -> 0 keys | 5461 slots | 1 slaves.
127.0.0.1:7010 (2df2426c...) -> 0 keys | 5461 slots | 1 slaves.
[OK] 1 keys in 3 masters.
0.00 keys per slot on average.
[root@iZ7xv0pw76zi75nqelv576Z ~]# redis-cli --cluster info 127.0.0.1:7014
127.0.0.1:7010 (2df2426c...) -> 0 keys | 5461 slots | 1 slaves.
127.0.0.1:7011 (27930eed...) -> 1 keys | 5462 slots | 1 slaves.
127.0.0.1:7012 (13116f2b...) -> 0 keys | 5461 slots | 1 slaves.
[OK] 1 keys in 3 masters.
0.00 keys per slot on average.
[root@iZ7xv0pw76zi75nqelv576Z ~]# redis-cli --cluster info 127.0.0.1:7015
127.0.0.1:7010 (2df2426c...) -> 0 keys | 5461 slots | 1 slaves.
127.0.0.1:7011 (27930eed...) -> 1 keys | 5462 slots | 1 slaves.
127.0.0.1:7012 (13116f2b...) -> 0 keys | 5461 slots | 1 slaves.
[OK] 1 keys in 3 masters.
0.00 keys per slot on average.
[root@iZ7xv0pw76zi75nqelv576Z ~]#

```

redis-cli –cluster 参数参考

```shell
[root@iZ7xv0pw76zi75nqelv576Z ~]# redis-cli --cluster help
Cluster Manager Commands:
  create         host1:port1 ... hostN:portN
                 --cluster-replicas <arg>
  check          host:port
                 --cluster-search-multiple-owners
  info           host:port
  fix            host:port
                 --cluster-search-multiple-owners
                 --cluster-fix-with-unreachable-masters
  reshard        host:port
                 --cluster-from <arg>
                 --cluster-to <arg>
                 --cluster-slots <arg>
                 --cluster-yes
                 --cluster-timeout <arg>
                 --cluster-pipeline <arg>
                 --cluster-replace
  rebalance      host:port
                 --cluster-weight <node1=w1...nodeN=wN>
                 --cluster-use-empty-masters
                 --cluster-timeout <arg>
                 --cluster-simulate
                 --cluster-pipeline <arg>
                 --cluster-threshold <arg>
                 --cluster-replace
  add-node       new_host:new_port existing_host:existing_port
                 --cluster-slave
                 --cluster-master-id <arg>
  del-node       host:port node_id
  call           host:port command arg arg .. arg
                 --cluster-only-masters
                 --cluster-only-replicas
  set-timeout    host:port milliseconds
  import         host:port
                 --cluster-from <arg>
                 --cluster-from-user <arg>
                 --cluster-from-pass <arg>
                 --cluster-from-askpass
                 --cluster-copy
                 --cluster-replace
  backup         host:port backup_directory
  help

For check, fix, reshard, del-node, set-timeout you can specify the host and port of any working node in the cluster.

Cluster Manager Options:
  --cluster-yes  Automatic yes to cluster commands prompts

[root@iZ7xv0pw76zi75nqelv576Z ~]#

```

