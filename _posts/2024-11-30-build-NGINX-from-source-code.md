---
title: Nginx源码安装
author: someone
date: 2024-11-30 22:45:00 +0800
categories: [Uncategorized]
tags: [Uncategorized]
pin: false
math: false
mermaid: false
---

nginx ("*engine x*") is an HTTP web server, reverse proxy, content cache, load balancer, TCP/UDP proxy server, and mail proxy server. 

nginx（“*engine x*”）是一个 HTTP Web 服务器、反向代理、内容缓存、负载均衡器、TCP/UDP 代理服务器和邮件代理服务器。

* nginx <https://nginx.org/>*

* nginx: download <https://nginx.org/en/download.html>

  * Mainline Version：主线版本

  * Stable Version：稳定版本

  * Legacy Version：旧版本

源码安装：<https://github.com/nginx/nginx?tab=readme-ov-file#building-from-source>

```shell
[root@iZ7xv0pw76zi75nqelv576Z ~]# git clone https://github.com/nginx/nginx.git
Cloning into 'nginx'...
remote: Enumerating objects: 69934, done.
remote: Counting objects: 100% (199/199), done.
remote: Compressing objects: 100% (105/105), done.
remote: Total 69934 (delta 132), reused 113 (delta 93), pack-reused 69735 (from 1)
Receiving objects: 100% (69934/69934), 71.71 MiB | 13.58 MiB/s, done.
Resolving deltas: 100% (53531/53531), done.
[root@iZ7xv0pw76zi75nqelv576Z ~]#

```

尝试安装

```shell
[root@iZ7xv0pw76zi75nqelv576Z nginx]# cd ..
[root@iZ7xv0pw76zi75nqelv576Z ~]# cd nginx/
[root@iZ7xv0pw76zi75nqelv576Z nginx]# ls
auto  CODE_OF_CONDUCT.md  conf  contrib  CONTRIBUTING.md  docs  LICENSE  misc  README.md  SECURITY.md  src
[root@iZ7xv0pw76zi75nqelv576Z nginx]# auto/configure \
> --prefix=/opt/nginx \
> --with-http_ssl_module \
> --user=nginx \
> --group=nginx
checking for OS
 + Linux 3.10.0-1160.119.1.el7.x86_64 x86_64
checking for C compiler ... found
 + using GNU C compiler
 + gcc version: 4.8.5 20150623 (Red Hat 4.8.5-44) (GCC)
checking for gcc -pipe switch ... found
checking for -Wl,-E switch ... found
checking for gcc builtin atomic operations ... found
checking for C99 variadic macros ... found
checking for gcc variadic macros ... found
checking for gcc builtin 64 bit byteswap ... found
checking for unistd.h ... found
checking for inttypes.h ... found
checking for limits.h ... found
checking for sys/filio.h ... not found
checking for sys/param.h ... found
checking for sys/mount.h ... found
checking for sys/statvfs.h ... found
checking for crypt.h ... found
checking for Linux specific features
checking for epoll ... found
checking for EPOLLRDHUP ... found
checking for EPOLLEXCLUSIVE ... not found
checking for eventfd() ... found
checking for O_PATH ... found
checking for sendfile() ... found
checking for sendfile64() ... found
checking for sys/prctl.h ... found
checking for prctl(PR_SET_DUMPABLE) ... found
checking for prctl(PR_SET_KEEPCAPS) ... found
checking for capabilities ... found
checking for crypt_r() ... found
checking for sys/vfs.h ... found
checking for BPF sockhash ... not found
checking for SO_COOKIE ... not found
checking for UDP_SEGMENT ... not found
checking for poll() ... found
checking for /dev/poll ... not found
checking for kqueue ... not found
checking for crypt() ... not found
checking for crypt() in libcrypt ... found
checking for F_READAHEAD ... not found
checking for posix_fadvise() ... found
checking for O_DIRECT ... found
checking for F_NOCACHE ... not found
checking for directio() ... not found
checking for statfs() ... found
checking for statvfs() ... found
checking for dlopen() ... not found
checking for dlopen() in libdl ... found
checking for sched_yield() ... found
checking for sched_setaffinity() ... found
checking for SO_SETFIB ... not found
checking for SO_REUSEPORT ... found
checking for SO_ACCEPTFILTER ... not found
checking for SO_BINDANY ... not found
checking for IP_TRANSPARENT ... found
checking for IP_BINDANY ... not found
checking for IP_BIND_ADDRESS_NO_PORT ... found
checking for IP_RECVDSTADDR ... not found
checking for IP_SENDSRCADDR ... not found
checking for IP_PKTINFO ... found
checking for IPV6_RECVPKTINFO ... found
checking for IP_MTU_DISCOVER ... found
checking for IPV6_MTU_DISCOVER ... found
checking for IP_DONTFRAG ... not found
checking for IPV6_DONTFRAG ... not found
checking for TCP_DEFER_ACCEPT ... found
checking for TCP_KEEPIDLE ... found
checking for TCP_FASTOPEN ... found
checking for TCP_INFO ... found
checking for accept4() ... found
checking for int size ... 4 bytes
checking for long size ... 8 bytes
checking for long long size ... 8 bytes
checking for void * size ... 8 bytes
checking for uint32_t ... found
checking for uint64_t ... found
checking for sig_atomic_t ... found
checking for sig_atomic_t size ... 4 bytes
checking for socklen_t ... found
checking for in_addr_t ... found
checking for in_port_t ... found
checking for rlim_t ... found
checking for uintptr_t ... uintptr_t found
checking for system byte ordering ... little endian
checking for size_t size ... 8 bytes
checking for off_t size ... 8 bytes
checking for time_t size ... 8 bytes
checking for AF_INET6 ... found
checking for setproctitle() ... not found
checking for pread() ... found
checking for pwrite() ... found
checking for pwritev() ... found
checking for strerrordesc_np() ... not found
checking for sys_nerr ... found
checking for localtime_r() ... found
checking for clock_gettime(CLOCK_MONOTONIC) ... found
checking for posix_memalign() ... found
checking for memalign() ... found
checking for mmap(MAP_ANON|MAP_SHARED) ... found
checking for mmap("/dev/zero", MAP_SHARED) ... found
checking for System V shared memory ... found
checking for POSIX semaphores ... not found
checking for POSIX semaphores in libpthread ... found
checking for struct msghdr.msg_control ... found
checking for ioctl(FIONBIO) ... found
checking for ioctl(FIONREAD) ... found
checking for struct tm.tm_gmtoff ... found
checking for struct dirent.d_namlen ... not found
checking for struct dirent.d_type ... found
checking for sysconf(_SC_NPROCESSORS_ONLN) ... found
checking for sysconf(_SC_LEVEL1_DCACHE_LINESIZE) ... found
checking for openat(), fstatat() ... found
checking for getaddrinfo() ... found
checking for PCRE2 library ... not found
checking for PCRE library ... not found
checking for PCRE library in /usr/local/ ... not found
checking for PCRE library in /usr/include/pcre/ ... not found
checking for PCRE library in /usr/pkg/ ... not found
checking for PCRE library in /opt/local/ ... not found
checking for PCRE library in /opt/homebrew/ ... not found

auto/configure: error: the HTTP rewrite module requires the PCRE library.
You can either disable the module by using --without-http_rewrite_module
option, or install the PCRE library into the system, or build the PCRE library
statically from the source with nginx by using --with-pcre=<path> option.

[root@iZ7xv0pw76zi75nqelv576Z nginx]#

```

解决办法：

```shell
yum -y install gcc make automake pcre-devel zlib zlib-devel openssl openssl-devel
```

终端输出：

```shell
[root@iZ7xv0pw76zi75nqelv576Z nginx]# yum -y install gcc make automake pcre-devel zlib zlib-devel openssl openssl-devel
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
Package gcc-4.8.5-44.el7.x86_64 already installed and latest version
Package 1:make-3.82-24.el7.x86_64 already installed and latest version
Package zlib-1.2.7-21.el7_9.x86_64 already installed and latest version
Package 1:openssl-1.0.2k-26.el7_9.x86_64 already installed and latest version
Resolving Dependencies
--> Running transaction check
---> Package automake.noarch 0:1.13.4-3.el7 will be installed
--> Processing Dependency: autoconf >= 2.65 for package: automake-1.13.4-3.el7.noarch
--> Processing Dependency: perl(Thread::Queue) for package: automake-1.13.4-3.el7.noarch
--> Processing Dependency: perl(TAP::Parser) for package: automake-1.13.4-3.el7.noarch
---> Package openssl-devel.x86_64 1:1.0.2k-26.el7_9 will be installed
--> Processing Dependency: krb5-devel(x86-64) for package: 1:openssl-devel-1.0.2k-26.el7_9.x86_64
---> Package pcre-devel.x86_64 0:8.32-17.el7 will be installed
---> Package zlib-devel.x86_64 0:1.2.7-21.el7_9 will be installed
--> Running transaction check
---> Package autoconf.noarch 0:2.69-11.el7 will be installed
--> Processing Dependency: perl(Data::Dumper) for package: autoconf-2.69-11.el7.noarch
---> Package krb5-devel.x86_64 0:1.15.1-55.el7_9 will be installed
--> Processing Dependency: libkadm5(x86-64) = 1.15.1-55.el7_9 for package: krb5-devel-1.15.1-55.el7_9.x86_64
--> Processing Dependency: libverto-devel for package: krb5-devel-1.15.1-55.el7_9.x86_64
--> Processing Dependency: libselinux-devel for package: krb5-devel-1.15.1-55.el7_9.x86_64
--> Processing Dependency: libcom_err-devel for package: krb5-devel-1.15.1-55.el7_9.x86_64
--> Processing Dependency: keyutils-libs-devel for package: krb5-devel-1.15.1-55.el7_9.x86_64
---> Package perl-Test-Harness.noarch 0:3.28-3.el7 will be installed
---> Package perl-Thread-Queue.noarch 0:3.02-2.el7 will be installed
--> Running transaction check
---> Package keyutils-libs-devel.x86_64 0:1.5.8-3.el7 will be installed
---> Package libcom_err-devel.x86_64 0:1.42.9-19.el7 will be installed
---> Package libkadm5.x86_64 0:1.15.1-55.el7_9 will be installed
---> Package libselinux-devel.x86_64 0:2.5-15.el7 will be installed
--> Processing Dependency: libsepol-devel(x86-64) >= 2.5-10 for package: libselinux-devel-2.5-15.el7.x86_64
--> Processing Dependency: pkgconfig(libsepol) for package: libselinux-devel-2.5-15.el7.x86_64
---> Package libverto-devel.x86_64 0:0.2.5-4.el7 will be installed
---> Package perl-Data-Dumper.x86_64 0:2.145-3.el7 will be installed
--> Running transaction check
---> Package libsepol-devel.x86_64 0:2.5-10.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================================================================
 Package                              Arch                    Version                            Repository                Size
================================================================================================================================
Installing:
 automake                             noarch                  1.13.4-3.el7                       base                     679 k
 openssl-devel                        x86_64                  1:1.0.2k-26.el7_9                  updates                  1.5 M
 pcre-devel                           x86_64                  8.32-17.el7                        base                     480 k
 zlib-devel                           x86_64                  1.2.7-21.el7_9                     updates                   50 k
Installing for dependencies:
 autoconf                             noarch                  2.69-11.el7                        base                     701 k
 keyutils-libs-devel                  x86_64                  1.5.8-3.el7                        base                      37 k
 krb5-devel                           x86_64                  1.15.1-55.el7_9                    updates                  273 k
 libcom_err-devel                     x86_64                  1.42.9-19.el7                      base                      32 k
 libkadm5                             x86_64                  1.15.1-55.el7_9                    updates                  180 k
 libselinux-devel                     x86_64                  2.5-15.el7                         base                     187 k
 libsepol-devel                       x86_64                  2.5-10.el7                         base                      77 k
 libverto-devel                       x86_64                  0.2.5-4.el7                        base                      12 k
 perl-Data-Dumper                     x86_64                  2.145-3.el7                        base                      47 k
 perl-Test-Harness                    noarch                  3.28-3.el7                         base                     302 k
 perl-Thread-Queue                    noarch                  3.02-2.el7                         base                      17 k

Transaction Summary
================================================================================================================================
Install  4 Packages (+11 Dependent packages)

Total download size: 4.5 M
Installed size: 11 M
Downloading packages:
(1/15): automake-1.13.4-3.el7.noarch.rpm                                                                 | 679 kB  00:00:00
(2/15): autoconf-2.69-11.el7.noarch.rpm                                                                  | 701 kB  00:00:00
(3/15): keyutils-libs-devel-1.5.8-3.el7.x86_64.rpm                                                       |  37 kB  00:00:00
(4/15): libcom_err-devel-1.42.9-19.el7.x86_64.rpm                                                        |  32 kB  00:00:00
(5/15): libsepol-devel-2.5-10.el7.x86_64.rpm                                                             |  77 kB  00:00:00
(6/15): libkadm5-1.15.1-55.el7_9.x86_64.rpm                                                              | 180 kB  00:00:00
(7/15): krb5-devel-1.15.1-55.el7_9.x86_64.rpm                                                            | 273 kB  00:00:00
(8/15): libselinux-devel-2.5-15.el7.x86_64.rpm                                                           | 187 kB  00:00:00
(9/15): openssl-devel-1.0.2k-26.el7_9.x86_64.rpm                                                         | 1.5 MB  00:00:00
(10/15): libverto-devel-0.2.5-4.el7.x86_64.rpm                                                           |  12 kB  00:00:00
(11/15): pcre-devel-8.32-17.el7.x86_64.rpm                                                               | 480 kB  00:00:00
(12/15): perl-Data-Dumper-2.145-3.el7.x86_64.rpm                                                         |  47 kB  00:00:00
(13/15): perl-Test-Harness-3.28-3.el7.noarch.rpm                                                         | 302 kB  00:00:00
(14/15): perl-Thread-Queue-3.02-2.el7.noarch.rpm                                                         |  17 kB  00:00:00
(15/15): zlib-devel-1.2.7-21.el7_9.x86_64.rpm                                                            |  50 kB  00:00:00
--------------------------------------------------------------------------------------------------------------------------------
Total                                                                                           7.7 MB/s | 4.5 MB  00:00:00
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : keyutils-libs-devel-1.5.8-3.el7.x86_64                                                                      1/15
  Installing : zlib-devel-1.2.7-21.el7_9.x86_64                                                                            2/15
  Installing : libcom_err-devel-1.42.9-19.el7.x86_64                                                                       3/15
  Installing : pcre-devel-8.32-17.el7.x86_64                                                                               4/15
  Installing : libsepol-devel-2.5-10.el7.x86_64                                                                            5/15
  Installing : libselinux-devel-2.5-15.el7.x86_64                                                                          6/15
  Installing : perl-Thread-Queue-3.02-2.el7.noarch                                                                         7/15
  Installing : perl-Test-Harness-3.28-3.el7.noarch                                                                         8/15
  Installing : perl-Data-Dumper-2.145-3.el7.x86_64                                                                         9/15
  Installing : autoconf-2.69-11.el7.noarch                                                                                10/15
  Installing : libkadm5-1.15.1-55.el7_9.x86_64                                                                            11/15
  Installing : libverto-devel-0.2.5-4.el7.x86_64                                                                          12/15
  Installing : krb5-devel-1.15.1-55.el7_9.x86_64                                                                          13/15
  Installing : 1:openssl-devel-1.0.2k-26.el7_9.x86_64                                                                     14/15
  Installing : automake-1.13.4-3.el7.noarch                                                                               15/15
  Verifying  : 1:openssl-devel-1.0.2k-26.el7_9.x86_64                                                                      1/15
  Verifying  : libselinux-devel-2.5-15.el7.x86_64                                                                          2/15
  Verifying  : libverto-devel-0.2.5-4.el7.x86_64                                                                           3/15
  Verifying  : libkadm5-1.15.1-55.el7_9.x86_64                                                                             4/15
  Verifying  : autoconf-2.69-11.el7.noarch                                                                                 5/15
  Verifying  : perl-Data-Dumper-2.145-3.el7.x86_64                                                                         6/15
  Verifying  : perl-Test-Harness-3.28-3.el7.noarch                                                                         7/15
  Verifying  : perl-Thread-Queue-3.02-2.el7.noarch                                                                         8/15
  Verifying  : libsepol-devel-2.5-10.el7.x86_64                                                                            9/15
  Verifying  : pcre-devel-8.32-17.el7.x86_64                                                                              10/15
  Verifying  : krb5-devel-1.15.1-55.el7_9.x86_64                                                                          11/15
  Verifying  : libcom_err-devel-1.42.9-19.el7.x86_64                                                                      12/15
  Verifying  : automake-1.13.4-3.el7.noarch                                                                               13/15
  Verifying  : zlib-devel-1.2.7-21.el7_9.x86_64                                                                           14/15
  Verifying  : keyutils-libs-devel-1.5.8-3.el7.x86_64                                                                     15/15

Installed:
  automake.noarch 0:1.13.4-3.el7            openssl-devel.x86_64 1:1.0.2k-26.el7_9        pcre-devel.x86_64 0:8.32-17.el7
  zlib-devel.x86_64 0:1.2.7-21.el7_9

Dependency Installed:
  autoconf.noarch 0:2.69-11.el7             keyutils-libs-devel.x86_64 0:1.5.8-3.el7   krb5-devel.x86_64 0:1.15.1-55.el7_9
  libcom_err-devel.x86_64 0:1.42.9-19.el7   libkadm5.x86_64 0:1.15.1-55.el7_9          libselinux-devel.x86_64 0:2.5-15.el7
  libsepol-devel.x86_64 0:2.5-10.el7        libverto-devel.x86_64 0:0.2.5-4.el7        perl-Data-Dumper.x86_64 0:2.145-3.el7
  perl-Test-Harness.noarch 0:3.28-3.el7     perl-Thread-Queue.noarch 0:3.02-2.el7

Complete!
[root@iZ7xv0pw76zi75nqelv576Z nginx]# auto/configure --prefix=/opt/nginx --with-http_ssl_module --user=nginx --group=nginx
checking for OS
 + Linux 3.10.0-1160.119.1.el7.x86_64 x86_64
checking for C compiler ... found
 + using GNU C compiler
 + gcc version: 4.8.5 20150623 (Red Hat 4.8.5-44) (GCC)
checking for gcc -pipe switch ... found
checking for -Wl,-E switch ... found
checking for gcc builtin atomic operations ... found
checking for C99 variadic macros ... found
checking for gcc variadic macros ... found
checking for gcc builtin 64 bit byteswap ... found
checking for unistd.h ... found
checking for inttypes.h ... found
checking for limits.h ... found
checking for sys/filio.h ... not found
checking for sys/param.h ... found
checking for sys/mount.h ... found
checking for sys/statvfs.h ... found
checking for crypt.h ... found
checking for Linux specific features
checking for epoll ... found
checking for EPOLLRDHUP ... found
checking for EPOLLEXCLUSIVE ... not found
checking for eventfd() ... found
checking for O_PATH ... found
checking for sendfile() ... found
checking for sendfile64() ... found
checking for sys/prctl.h ... found
checking for prctl(PR_SET_DUMPABLE) ... found
checking for prctl(PR_SET_KEEPCAPS) ... found
checking for capabilities ... found
checking for crypt_r() ... found
checking for sys/vfs.h ... found
checking for BPF sockhash ... not found
checking for SO_COOKIE ... not found
checking for UDP_SEGMENT ... not found
checking for poll() ... found
checking for /dev/poll ... not found
checking for kqueue ... not found
checking for crypt() ... not found
checking for crypt() in libcrypt ... found
checking for F_READAHEAD ... not found
checking for posix_fadvise() ... found
checking for O_DIRECT ... found
checking for F_NOCACHE ... not found
checking for directio() ... not found
checking for statfs() ... found
checking for statvfs() ... found
checking for dlopen() ... not found
checking for dlopen() in libdl ... found
checking for sched_yield() ... found
checking for sched_setaffinity() ... found
checking for SO_SETFIB ... not found
checking for SO_REUSEPORT ... found
checking for SO_ACCEPTFILTER ... not found
checking for SO_BINDANY ... not found
checking for IP_TRANSPARENT ... found
checking for IP_BINDANY ... not found
checking for IP_BIND_ADDRESS_NO_PORT ... found
checking for IP_RECVDSTADDR ... not found
checking for IP_SENDSRCADDR ... not found
checking for IP_PKTINFO ... found
checking for IPV6_RECVPKTINFO ... found
checking for IP_MTU_DISCOVER ... found
checking for IPV6_MTU_DISCOVER ... found
checking for IP_DONTFRAG ... not found
checking for IPV6_DONTFRAG ... not found
checking for TCP_DEFER_ACCEPT ... found
checking for TCP_KEEPIDLE ... found
checking for TCP_FASTOPEN ... found
checking for TCP_INFO ... found
checking for accept4() ... found
checking for int size ... 4 bytes
checking for long size ... 8 bytes
checking for long long size ... 8 bytes
checking for void * size ... 8 bytes
checking for uint32_t ... found
checking for uint64_t ... found
checking for sig_atomic_t ... found
checking for sig_atomic_t size ... 4 bytes
checking for socklen_t ... found
checking for in_addr_t ... found
checking for in_port_t ... found
checking for rlim_t ... found
checking for uintptr_t ... uintptr_t found
checking for system byte ordering ... little endian
checking for size_t size ... 8 bytes
checking for off_t size ... 8 bytes
checking for time_t size ... 8 bytes
checking for AF_INET6 ... found
checking for setproctitle() ... not found
checking for pread() ... found
checking for pwrite() ... found
checking for pwritev() ... found
checking for strerrordesc_np() ... not found
checking for sys_nerr ... found
checking for localtime_r() ... found
checking for clock_gettime(CLOCK_MONOTONIC) ... found
checking for posix_memalign() ... found
checking for memalign() ... found
checking for mmap(MAP_ANON|MAP_SHARED) ... found
checking for mmap("/dev/zero", MAP_SHARED) ... found
checking for System V shared memory ... found
checking for POSIX semaphores ... not found
checking for POSIX semaphores in libpthread ... found
checking for struct msghdr.msg_control ... found
checking for ioctl(FIONBIO) ... found
checking for ioctl(FIONREAD) ... found
checking for struct tm.tm_gmtoff ... found
checking for struct dirent.d_namlen ... not found
checking for struct dirent.d_type ... found
checking for sysconf(_SC_NPROCESSORS_ONLN) ... found
checking for sysconf(_SC_LEVEL1_DCACHE_LINESIZE) ... found
checking for openat(), fstatat() ... found
checking for getaddrinfo() ... found
checking for PCRE2 library ... not found
checking for PCRE library ... found
checking for PCRE JIT support ... found
checking for OpenSSL library ... found
checking for zlib library ... found
creating objs/Makefile

Configuration summary
  + using system PCRE library
  + using system OpenSSL library
  + using system zlib library

  nginx path prefix: "/opt/nginx"
  nginx binary file: "/opt/nginx/sbin/nginx"
  nginx modules path: "/opt/nginx/modules"
  nginx configuration prefix: "/opt/nginx/conf"
  nginx configuration file: "/opt/nginx/conf/nginx.conf"
  nginx pid file: "/opt/nginx/logs/nginx.pid"
  nginx error log file: "/opt/nginx/logs/error.log"
  nginx http access log file: "/opt/nginx/logs/access.log"
  nginx http client request body temporary files: "client_body_temp"
  nginx http proxy temporary files: "proxy_temp"
  nginx http fastcgi temporary files: "fastcgi_temp"
  nginx http uwsgi temporary files: "uwsgi_temp"
  nginx http scgi temporary files: "scgi_temp"

[root@iZ7xv0pw76zi75nqelv576Z nginx]#

```

make 编译

```shell
[root@iZ7xv0pw76zi75nqelv576Z nginx]# make
make -f objs/Makefile
make[1]: Entering directory `/root/nginx'
cc -c -pipe  -O -W -Wall -Wpointer-arith -Wno-unused-parameter -Werror -g  -I src/core -I src/event -I src/event/modules -I src/event/quic -I src/os/unix -I objs \
        -o objs/src/core/nginx.o \
        src/core/nginx.c
cc -c -pipe  -O -W -Wall -Wpointer-arith -Wno-unused-parameter -Werror -g  -I src/core -I src/event -I src/event/modules -I src/event/quic -I src/os/unix -I objs \
        -o objs/src/core/ngx_log.o \
        src/core/ngx_log.c
cc -c -pipe  -O -W -Wall -Wpointer-arith -Wno-unused-parameter -Werror -g  -I src/core -I src/event -I src/event/modules -I src/event/quic -I src/os/unix -I objs \
        -o objs/src/core/ngx_palloc.o \
        src/core/ngx_palloc.c
cc -c -pipe  -O -W -Wall -Wpointer-arith -Wno-unused-parameter -Werror -g  -I src/core -I src/event -I src/event/modules -I src/event/quic -I src/os/unix -I objs \
        -o objs/src/core/ngx_array.o \
        src/core/ngx_array.c
cc -c -pipe  -O -W -Wall -Wpointer-arith -Wno-unused-parameter -Werror -g  -I src/core -I src/event -I src/event/modules -I src/event/quic -I src/os/unix -I objs \
        -o objs/src/core/ngx_list.o \
        src/core/ngx_list.c
cc -c -pipe  -O -W -Wall -Wpointer-arith -Wno-unused-parameter -Werror -g  -I src/core -I src/event -I src/event/modules -I src/event/quic -I src/os/unix -I objs \
        -o objs/src/core/ngx_hash.o \
        src/core/ngx_hash.c
cc -c -pipe  -O -W -Wall -Wpointer-arith -Wno-unused-parameter -Werror -g  -I src/core -I src/event -I src/event/modules -I src/event/quic -I src/os/unix -I objs \
        -o objs/src/core/ngx_buf.o \
        src/core/ngx_buf.c
cc -c -pipe  -O -W -Wall -Wpointer-arith -Wno-unused-paramet
# ...... 一堆make输出
objs/src/http/modules/ngx_http_try_files_module.o \
objs/src/http/modules/ngx_http_auth_basic_module.o \
objs/src/http/modules/ngx_http_access_module.o \
objs/src/http/modules/ngx_http_limit_conn_module.o \
objs/src/http/modules/ngx_http_limit_req_module.o \
objs/src/http/modules/ngx_http_geo_module.o \
objs/src/http/modules/ngx_http_map_module.o \
objs/src/http/modules/ngx_http_split_clients_module.o \
objs/src/http/modules/ngx_http_referer_module.o \
objs/src/http/modules/ngx_http_rewrite_module.o \
objs/src/http/modules/ngx_http_ssl_module.o \
objs/src/http/modules/ngx_http_proxy_module.o \
objs/src/http/modules/ngx_http_fastcgi_module.o \
objs/src/http/modules/ngx_http_uwsgi_module.o \
objs/src/http/modules/ngx_http_scgi_module.o \
objs/src/http/modules/ngx_http_memcached_module.o \
objs/src/http/modules/ngx_http_empty_gif_module.o \
objs/src/http/modules/ngx_http_browser_module.o \
objs/src/http/modules/ngx_http_upstream_hash_module.o \
objs/src/http/modules/ngx_http_upstream_ip_hash_module.o \
objs/src/http/modules/ngx_http_upstream_least_conn_module.o \
objs/src/http/modules/ngx_http_upstream_random_module.o \
objs/src/http/modules/ngx_http_upstream_keepalive_module.o \
objs/src/http/modules/ngx_http_upstream_zone_module.o \
objs/ngx_modules.o \
-ldl -lpthread -lcrypt -lpcre -lssl -lcrypto -ldl -lpthread -lz \
-Wl,-E
sed -e "s|%%PREFIX%%|/opt/nginx|" \
        -e "s|%%PID_PATH%%|/opt/nginx/logs/nginx.pid|" \
        -e "s|%%CONF_PATH%%|/opt/nginx/conf/nginx.conf|" \
        -e "s|%%ERROR_LOG_PATH%%|/opt/nginx/logs/error.log|" \
        < docs/man/nginx.8 > objs/nginx.8
make[1]: Leaving directory `/root/nginx'

```

make install

```shell
[root@iZ7xv0pw76zi75nqelv576Z nginx]# make install
make -f objs/Makefile install
make[1]: Entering directory `/root/nginx'
test -d '/opt/nginx' || mkdir -p '/opt/nginx'
test -d '/opt/nginx/sbin' \
        || mkdir -p '/opt/nginx/sbin'
test ! -f '/opt/nginx/sbin/nginx' \
        || mv '/opt/nginx/sbin/nginx' \
                '/opt/nginx/sbin/nginx.old'
cp objs/nginx '/opt/nginx/sbin/nginx'
test -d '/opt/nginx/conf' \
        || mkdir -p '/opt/nginx/conf'
cp conf/koi-win '/opt/nginx/conf'
cp conf/koi-utf '/opt/nginx/conf'
cp conf/win-utf '/opt/nginx/conf'
test -f '/opt/nginx/conf/mime.types' \
        || cp conf/mime.types '/opt/nginx/conf'
cp conf/mime.types '/opt/nginx/conf/mime.types.default'
test -f '/opt/nginx/conf/fastcgi_params' \
        || cp conf/fastcgi_params '/opt/nginx/conf'
cp conf/fastcgi_params \
        '/opt/nginx/conf/fastcgi_params.default'
test -f '/opt/nginx/conf/fastcgi.conf' \
        || cp conf/fastcgi.conf '/opt/nginx/conf'
cp conf/fastcgi.conf '/opt/nginx/conf/fastcgi.conf.default'
test -f '/opt/nginx/conf/uwsgi_params' \
        || cp conf/uwsgi_params '/opt/nginx/conf'
cp conf/uwsgi_params \
        '/opt/nginx/conf/uwsgi_params.default'
test -f '/opt/nginx/conf/scgi_params' \
        || cp conf/scgi_params '/opt/nginx/conf'
cp conf/scgi_params \
        '/opt/nginx/conf/scgi_params.default'
test -f '/opt/nginx/conf/nginx.conf' \
        || cp conf/nginx.conf '/opt/nginx/conf/nginx.conf'
cp conf/nginx.conf '/opt/nginx/conf/nginx.conf.default'
test -d '/opt/nginx/logs' \
        || mkdir -p '/opt/nginx/logs'
test -d '/opt/nginx/logs' \
        || mkdir -p '/opt/nginx/logs'
test -d '/opt/nginx/html' \
        || cp -R docs/html '/opt/nginx'
test -d '/opt/nginx/logs' \
        || mkdir -p '/opt/nginx/logs'
make[1]: Leaving directory `/root/nginx'
[root@iZ7xv0pw76zi75nqelv576Z nginx]#

```

尝试启动nginx

```shell
[root@iZ7xv0pw76zi75nqelv576Z nginx]# /opt/nginx/sbin/nginx
nginx: [emerg] getpwnam("nginx") failed
[root@iZ7xv0pw76zi75nqelv576Z nginx]# sudo /opt/nginx/sbin/nginx
nginx: [emerg] getpwnam("nginx") failed
[root@iZ7xv0pw76zi75nqelv576Z nginx]# ps aux | grep nginx
root     28435  0.0  0.0 112812   980 pts/6    S+   09:02   0:00 grep --color=auto nginx
[root@iZ7xv0pw76zi75nqelv576Z nginx]# cd /opt/nginx/
[root@iZ7xv0pw76zi75nqelv576Z nginx]# ls
conf  html  logs  sbin
[root@iZ7xv0pw76zi75nqelv576Z nginx]# adduser  --no-create-home  --system  --user-group --shell /bin/false   nginx
[root@iZ7xv0pw76zi75nqelv576Z nginx]# sbin/nginx
[root@iZ7xv0pw76zi75nqelv576Z nginx]# ps aux | grep nginx
root     28545  0.0  0.0  46020  1136 ?        Ss   09:05   0:00 nginx: master process sbin/nginx
nginx    28546  0.0  0.0  46468  1880 ?        S    09:05   0:00 nginx: worker process
root     28554  0.0  0.0 112812   980 pts/6    S+   09:05   0:00 grep --color=auto nginx
[root@iZ7xv0pw76zi75nqelv576Z nginx]#

```

curl localhost

```shell
[root@iZ7xv0pw76zi75nqelv576Z nginx]# curl localhost
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
[root@iZ7xv0pw76zi75nqelv576Z nginx]#

```

curl 8.134.173.217

```shell
➜  ~ curl http://8.134.173.217/
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
➜  ~

```

至此安装完成
