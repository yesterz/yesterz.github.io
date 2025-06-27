```java
➜  ~ sudo apt search mysql-server
[sudo] password for xiaohe:
Sorting... Done
Full Text Search... Done
default-mysql-server/noble 1.1.0build1 all
  MySQL database server binaries and system database setup (metapackage)

default-mysql-server-core/noble 1.1.0build1 all
  MySQL database server binaries (metapackage)

mysql-server/noble-updates,noble-security 8.0.42-0ubuntu0.24.04.1 all
  MySQL database server (metapackage depending on the latest version)

mysql-server-8.0/noble-updates,noble-security 8.0.42-0ubuntu0.24.04.1 amd64
  MySQL database server binaries and system database setup

mysql-server-core-8.0/noble-updates,noble-security 8.0.42-0ubuntu0.24.04.1 amd64
  MySQL database server binaries
➜  ~ sudo apt install mysql-server
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  libaio1t64 libcgi-fast-perl libcgi-pm-perl libclone-perl
  libencode-locale-perl libevent-pthreads-2.1-7t64 libfcgi-bin libfcgi-perl
  libfcgi0t64 libhtml-parser-perl libhtml-tagset-perl libhtml-template-
      ....
➜  ~ sudo systemctl start mysql
```



安装过程中没有让输入密码；

```java
➜  ~ systemctl status mysql
● mysql.service - MySQL Community Server
     Loaded: loaded (/usr/lib/systemd/system/mysql.service; enabled; preset: en>
     Active: active (running) since Mon 2025-06-23 16:09:01 CST; 36s ago
    Process: 2208 ExecStartPre=/usr/share/mysql/mysql-systemd-start pre (code=e>
   Main PID: 2217 (mysqld)
     Status: "Server is operational"
      Tasks: 38 (limit: 9412)
     Memory: 363.8M (peak: 379.5M)
        CPU: 883ms
     CGroup: /system.slice/mysql.service
             └─2217 /usr/sbin/mysqld

Jun 23 16:09:01 DESKTOP-THB59EH systemd[1]: Starting mysql.service - MySQL Comm>
Jun 23 16:09:01 DESKTOP-THB59EH systemd[1]: Started mysql.service - MySQL Commu>
➜  ~ mysql -uroot -p
Enter password:
ERROR 1698 (28000): Access denied for user 'root'@'localhost'

```

* 用安装的时候自动生成的密码登录上去

```shell
➜  mysql sudo cat debian.cnf
# Automatically generated for Debian scripts. DO NOT TOUCH!
[client]
host     = localhost
user     = debian-sys-maint
password = MKAwjtY7f1NeyHia
socket   = /var/run/mysqld/mysqld.sock
[mysql_upgrade]
host     = localhost
user     = debian-sys-maint
password = MKAwjtY7f1NeyHia
socket   = /var/run/mysqld/mysqld.sock
➜  mysql mysql -udebian-sys-maint -pMKAwjtY7f1NeyHia
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 9
Server version: 8.0.42-0ubuntu0.24.04.1 (Ubuntu)

Copyright (c) 2000, 2025, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> exit
Bye
➜  mysql pwd
/etc/mysql

```

