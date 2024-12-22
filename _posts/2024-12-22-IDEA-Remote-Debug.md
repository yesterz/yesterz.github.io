
参考：<https://www.jetbrains.com/help/idea/tutorial-remote-debug.html>

## Introspecting SSH server

```shell
Successfully connected to root@8.134.173.217:22

> pwd
/root
Command finished with exit code 0
> pwd
/root
Command finished with exit code 0


Checking rsync connection...
/usr/bin/rsync -n -e "ssh -p 22 -i /home/risk/.ssh/id_ed25519" root@8.134.173.217:

dr-xr-x---          4,096 2024/12/22 18:34:49 .
-rw-------         34,247 2024/12/22 18:34:02 .bash_history
-rw-r--r--             18 2013/12/29 10:26:31 .bash_logout
-rw-r--r--            176 2013/12/29 10:26:31 .bash_profile
-rw-r--r--            176 2013/12/29 10:26:31 .bashrc

-rw-r--r--            100 2013/12/29 10:26:31 .cshrc
-rw-------             35 2024/11/27 09:47:04 .lesshst
-rw-------          4,235 2024/12/09 22:28:59 .mysql_history
-rw-r--r--            206 2024/11/27 08:49:32 .pydistutils.cfg
-rw-------            407 2024/11/28 23:57:07 .rediscli_history
-rw-r--r--            129 2013/12/29 10:26:31 .tcshrc
-rw-------          7,568 2024/12/22 18:34:49 .viminfo
-rw-r--r--              0 2024/12/06 21:29:38 1125.md
-rw-r--r--     29,131,968 2024/12/21 23:04:14 Snipaste-2.10.3-x86_64.AppImage
-rw-r--r--          3,255 2024/12/06 21:29:38 cjkc.md
-rw-r--r--         16,276 2024/12/07 21:54:15 dbdump2ecs.db
-rw-r--r--     75,324,256 2024/10/24 21:34:21 docker-27.3.1.tgz
-rw-r--r--        114,868 2024/12/06 21:29:38 erjbvi.md
-rw-r--r--            835 2024/11/27 15:08:08 install.md
-rw-r--r--             60 2024/11/27 10:13:12 j.log
-rw-r--r--    182,799,609 2024/06/05 13:45:57 jdk-17.0.12_linux-x64_bin.tar.gz
-rw-r--r--     96,008,718 2024/10/30 21:30:25 jenkins.war
-rw-r--r--     34,590,180 2024/11/06 03:57:12 jetty-home-12.0.15.tar.gz
-rw-r--r--    465,097,732 2024/09/17 17:12:51 mysql-8.4.3.tar.gz
-rw-r--r--    490,502,884 2024/09/18 16:38:06 mysql-boost-8.0.40.tar.gz
-rw-r--r--      2,487,287 2022/04/27 21:39:00 redis-6.2.7.tar.gz
drwx------          4,096 2024/06/28 12:35:16 .cache
drwxr-xr-x          4,096 2024/11/27 10:12:35 .jenkins
drwxr-xr-x          4,096 2024/06/28 12:35:06 .pip
drwxr-----          4,096 2024/11/30 08:47:34 .pki

drwx------          4,096 2024/12/22 18:34:49 .ssh
drwxr-xr-x          4,096 2024/11/27 09:33:08 jdk-17.0.12
drwxr-xr-x          4,096 2024/12/07 01:37:59 mysql-8.0.40
drwxr-xr-x          4,096 2024/11/30 08:55:42 nginx
drwxrwxr-x          4,096 2022/04/27 21:31:52 redis-6.2.7
drwxr-xr-x          4,096 2024/12/07 21:33:39 yunxiao

Process finished with exit code 0


Starting introspection for Java...
> pwd
/root
Command finished with exit code 0
> echo ${SHELL}
/bin/bash
Command finished with exit code 0
> echo ${JAVA_HOME}
/opt/jdk-17.0.12
Command finished with exit code 0
> pwd
/root
Command finished with exit code 0
> java -version
java version "17.0.12" 2024-07-16 LTS
Java(TM) SE Runtime Environment (build 17.0.12+8-LTS-286)
Java HotSpot(TM) 64-Bit Server VM (build 17.0.12+8-LTS-286, mixed mode, sharing)
Command finished with exit code 0

Introspection completed
```