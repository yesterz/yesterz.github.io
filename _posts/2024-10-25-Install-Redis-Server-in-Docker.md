---
title: Docker 安装 Redis
categories: [Uncategorized]
tags: [Uncategorized]
toc: true
img_path: 
---

官方镜像库地址：<https://hub.docker.com/_/redis?tab=tags>

## 安装

```shell
➜  ~ docker pull redis
Using default tag: latest
latest: Pulling from library/redis
a480a496ba95: Pull complete
89511e3ccef2: Pull complete
4ca428e0bb5e: Pull complete
41cc262fb5bb: Pull complete
228fc9e0b0ff: Pull complete
23d1d45ab415: Pull complete
4f4fb700ef54: Pull complete
6adf9ee29d6f: Pull complete
Digest: sha256:a06cea905344470eb49c972f3d030e22f28f632c1b4f43bbe4a26a4329dd6be5
Status: Downloaded newer image for redis:latest
docker.io/library/redis:latest
➜  ~ docker images
REPOSITORY                        TAG       IMAGE ID       CREATED       SIZE
redis                             latest    f02a7f566928   3 weeks ago   117MB
➜  ~

```

## 运行

```shell
➜  ~ docker run --name rds -p 6379:6379 -d redis
ae603439ff6f11f069da5ef63547f04ad7916b24590d7c444b5ed8d4dbe6ef10
➜  ~ docker ps
CONTAINER ID   IMAGE     COMMAND                   CREATED         STATUS         PORTS                                    NAMES
ae603439ff6f   redis     "docker-entrypoint.s…"   4 seconds ago   Up 2 seconds   0.0.0.0:6379->6379/tcp, :::6379->6379/tcp   rds
➜  ~ docker exec -it rds /bin/bash
root@ae603439ff6f:/data# redis-cli
127.0.0.1:6379> ping
PONG
➜  ~ docker exec -it rds /usr/local/bin/redis-cli
127.0.0.1:6379> ping
PONG
127.0.0.1:6379>

```

## 另一种方法

```shell
➜  ~ docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' rds
172.17.0.2
➜  ~ redis-cli -h # 没装 Redis tools
➜  ~ apt install redis-tools
E: 无法打开锁文件 /var/lib/dpkg/lock-frontend - open (13: 权限不够)
E: 无法获取 dpkg 前端锁 (/var/lib/dpkg/lock-frontend)，请查看您是否正以 root 用户运行？
➜  ~ sudo apt install redis-tools
➜  ~ # 省略安装过程
➜  ~ redis-cli -h 172.17.0.2
172.17.0.2:6379> ping
PONG
172.17.0.2:6379>

```

(end)
