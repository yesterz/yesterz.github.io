---
title: Linux 环境变量
categories: [Uncategorized]
tags: [Uncategorized]
toc: true
media_subpath: 
---

## 一. 环境变量的概念

Linux 的变量可分为两类：环境变量和本地变量

- 环境变量：或者称为全局变量，存在于所有的shell 中，在你登陆系统的时候就已经有了相应的系统定义的环境变量了。Linux 的环境变量具有继承性，即子shell 会继承父shell 的环境变量。
- 本地变量：当前shell 中的变量，很显然本地变量中肯定包含环境变量。Linux 的本地变量的非环境变量不具备继承性。

Linux 中环境变量的文件

当你进入系统的时候，Linux 就会为你读入系统的环境变量，Linux 中有很多记载环境变量的文件，它们被系统读入是按照一定的顺序的。

- 1.`/etc/profile`

此文件为系统的环境变量，它为每个用户设置环境信息，当用户第一次登录时，该文件被执行。并从 `/etc/profile.d`目录的配置文件中搜集shell 的设置。这个文件，是任何用户登陆操作系统以后都会读取的文件（如果用户的shell 是 `csh` 、`tcsh` 、`zsh` ，则不会读取此文件），用于获取系统的环境变量，只在登陆的时候读取一次。 (假设用户使用的是BASH )

- 2.`/etc/bashrc`

在执行完 `/etc/profile` 内容之后，如果用户的 SHELL 运行的是 bash ，那么接着就会执行此文件。另外，当每次一个新的 bash shell 被打开时，该文件被读取。每个使用 bash 的用户在登陆以后执行完 `/etc/profile` 中内容以后都会执行此文件，在新开一个 bash 的时候也会执行此文件。因此，如果你想让每个使用 bash 的用户每新开一个 bash 和每次登陆都执行某些操作，或者给他们定义一些新的环境变量，就可以在这个里面设置。

- 3.`~/.bash_profile`

每个用户都可使用该文件输入专用于自己使用的 shell 信息。当用户登录时，该文件仅仅执行一次，默认情况下，它设置一些环境变量，执行用户的 `.bashrc` 文件。单个用户此文件的修改只会影响到他以后的每一次登陆系统。因此，可以在这里设置单个用户的特殊的环境变量或者特殊的操作，那么它在每次登陆的时候都会去获取这些新的环境变量或者做某些特殊的操作，但是仅仅在登陆时。

- 4.`~/.bashrc`

该文件包含专用于单个人的 bash shell 的 bash 信息，当登录时以及每次打开一个新的 shell 时，该文件被读取。单个用户此文件的修改会影响到他以后的每一次登陆系统和每一次新开一个 bash。因此，可以在这里设置单个用户的特殊的环境变量或者特殊的操作，那么每次它新登陆系统或者新开一个 bash ，都会去获取相应的特殊的环境变量和特殊操作。

- 5.`~/.bash_logout`

当每次退出系统( 退出bash shell) 时, 执行该文件。

用户登录后加载 `profile`和 `bashrc`的流程如下：

```bash
1)/etc/profile --> /etc/profile.d/*.sh
2)$HOME/.bash_profile --> $HOME/.bashrc --> /etc/bashrc
```

bash首先执行 `/etc/profile`脚本，`/etc/profile`脚本先依次执行 `/etc/profile.d/*.sh`。

随后bash会执行用户主目录下的 `.bash_profile`脚本，`.bash_profile`脚本会执行用户主目录下的 `.bashrc`脚本，

而 `.bashrc`脚本会执行 `/etc/bashrc`脚本。至此，所有的环境变量和初始化设定都已经加载完成。

bash随后调用 `terminfo`和 `inputrc`，完成终端属性和键盘映射的设定。

### 1. 含义

程序（操作系统命令和应用程序）的执行都需要运行环境，这个环境是由多个环境变量组成的。

### 2. 分类

- 1.按生效的范围分类。

系统环境变量：公共的，对全部的用户都生效。

用户环境变量：用户私有的、自定义的个性化设置，只对该用户生效。

- 2.按生存周期分类。

永久环境变量：在环境变量脚本文件中配置，用户每次登录时会自动执行这些脚本，相当于永久生效。

临时环境变量：使用时在Shell中临时定义，退出Shell后失效。

- 3.Linux环境变量

Linux环境变量也称之为Shell环境变量，以下划线和字母打头，由下划线、字母（区分大小写）和数字组成，习惯上使用大写字母，例如 `PATH`、`HOSTNAME`、`LANG`等。

## 二. 常用的环境变量

### 1. 查看环境变量

- 1.`env`命令

在Shell下，用 `env`命令查看当前用户全部的环境变量。

```markdown
[root@k8smaster ~]# env
XDG_SESSION_ID=668
GUESTFISH_INIT=\e[1;34m
HOSTNAME=k8smaster
TERM=xterm
SHELL=/bin/bash
HISTSIZE=1000
SSH_CLIENT=192.168.172.1 52033 22
SSH_TTY=/dev/pts/0
USER=root
LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:*.flac=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.axa=01;36:*.oga=01;36:*.spx=01;36:*.xspf=01;36:
GUESTFISH_PS1=\[\e[1;32m\]><fs>\[\e[0;31m\] 
MAIL=/var/spool/mail/root
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
PWD=/root
LANG=en_US.UTF-8
GUESTFISH_OUTPUT=\e[0m
PS1=\[\e[1;32m\][\[\e[36m\]\u\[\e[m\]@\[\e[1;31m\]\H \[\e[1;35m\]\w\[\e[32m\]]\[\e[36m\]\$ \[\e[m\]
HISTCONTROL=ignoredups
SHLVL=1
HOME=/root
LOGNAME=root
SSH_CONNECTION=192.168.172.1 52033 192.168.172.103 22
LESSOPEN=||/usr/bin/lesspipe.sh %s
PROMPT_COMMAND=history 1|tail -1|sed "s/^[ ]\+[0-9]\+  //"|sed "s/$/\"/">> $HISTDIR
XDG_RUNTIME_DIR=/run/user/0
GUESTFISH_RESTORE=\e[0m
HISTTIMEFORMAT="TIME": "%F %T" , "LoginIP": "192.168.172.1" , "TTY": "pts/0" , "LoginUser": "root" , "CMD": "
_=/usr/bin/env
OLDPWD=/etc/profile.d
```

用 `env`命令的时候，满屏显示了很多环境变量，不方便查看，可以用 `grep`筛选。

```bash
env|grep 环境变量名
```

例如查看环境变量名中包含 `PATH`的环境变量。

```ruby
[root@k8smaster ~]# env|grep PATH
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
```

- 2.echo命令

```bash
echo $环境变量名

eg:
[root@k8smaster ~]# echo $LANG
en_US.UTF-8

[root@k8smaster ~]# echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
```

注意：符号 `$`不能缺少，这是语法规定。

### 2. 常用的环境变量

- 1.`PATH`

可执行程序的搜索目录，可执行程序包括Linux系统命令和用户的应用程序。

```bash
[root@k8smaster ~]# echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
```

- 2.`LANG`

Linux系统的语言、地区、字符集。

```csharp
[root@k8smaster ~]# echo $LANG
en_US.UTF-8
```

- 3.`HOSTNAME`

服务器的主机名。

```csharp
[root@k8smaster ~]# echo $HOSTNAME
k8smaster
```

- 4.`SHELL`

用户当前使用的SHELL解析器。

```bash
[root@k8smaster ~]# echo $SHELL
/bin/bash
```

- 5.`HISTSIZE`

保存历史命令的数目。

```bash
echo $HISTSIZE
1000
```

- 6.`USER`

当前登录用户的用户名。

```csharp
[root@k8smaster ~]# echo $USER
root
```

- 7.`HOME`

当前登录用户的主目录。

```bash
[root@k8smaster ~]# echo $HOME
/root
```

- 8.`PWD`

当前工作目录。

```bash
[root@k8smaster /etc/profile.d]# echo $PWD  
/etc/profile.d
```

- 9.`LD_LIBRARY_PATH`

C/C++语言动态链接库文件搜索的目录，它不是Linux缺省的环境变量，但对C/C++程序员来说非常重要。

- 10.`CLASSPATH`

JAVA语言库文件搜索的目录，它也不是Linux缺省的环境变量，但对JAVA程序员来说非常重要。

## 三. 设置环境变量

### 1. 设置临时环境变量

```bash
变量名='值'
export 变量名
```

或

```bash
export 变量名='值'
```

如果环境变量的值没有空格等特殊符号，可以不用单引号包含。

* 示例

```csharp
[root@k8smaster ~]# export TEST_HOME=/test
[root@k8smaster ~]# echo $TEST_HOME
/test

[root@k8smaster ~]# TEST_DATA=/data
[root@k8smaster ~]# export TEST_DATA
[root@k8smaster ~]# echo $TEST_DATA
/data
```

采用 `export`设置的环境变量，在退出shell后就会失效，下次登录时需要重新设置。如果希望环境变量永久生效，需要在登录脚本文件中配置。

### 2. 设置永久环境变量

系统环境变量对全部的用户生效，设置系统环境变量有三种方法。

- 1.在 `/etc/profile`文件中设置

用户登录时执行 `/etc/profile`文件中设置系统的环境变量。但是，Linux不建议在 `/etc/profile`文件中设置系统环境变量。

- 2.在 `/etc/profile.d`目录中增加环境变量脚本文件，这是Linux推荐的方法。

`/etc/profile`在每次启动时会执行 `/etc/profile.d`下全部的脚本文件。`/etc/profile.d`比 `/etc/profile`好维护，不想要什么变量直接删除 `/etc/profile.d`下对应的 shell 脚本即可。

`/etc/profile.d`目录下有很多脚本文件，例如：

```yaml
[root@k8smaster /etc/profile.d]# ll
total 80
-rw-r--r--. 1 root root  771 Apr 11  2018 256term.csh
-rw-r--r--. 1 root root  841 Apr 11  2018 256term.sh
-rw-r--r--. 1 root root  660 Apr  1  2020 bash_completion.sh
-rw-r--r--. 1 root root  196 Mar 25  2017 colorgrep.csh
-rw-r--r--. 1 root root  201 Mar 25  2017 colorgrep.sh
-rw-r--r--. 1 root root 1741 Apr 11  2018 colorls.csh
-rw-r--r--. 1 root root 1606 Apr 11  2018 colorls.sh
-rw-r--r--. 1 root root   80 Apr 11  2018 csh.local
-rw-r--r--  1 root root  264 Oct  2  2020 guestfish.sh
-rw-r--r--. 1 root root 1706 Apr 11  2018 lang.csh
-rw-r--r--. 1 root root 2703 Apr 11  2018 lang.sh
-rw-r--r--. 1 root root  123 Jul 31  2015 less.csh
-rw-r--r--. 1 root root  121 Jul 31  2015 less.sh
-rw-r--r--. 1 root root   81 Apr 11  2018 sh.local
-rw-r--r--. 1 root root  105 Dec 16  2020 vim.csh
-rw-r--r--. 1 root root  269 Dec 16  2020 vim.sh
-rw-r--r--. 1 root root  164 Jan 28  2014 which2.csh
-rw-r--r--. 1 root root  169 Jan 28  2014 which2.sh
-rwxr-xr-x  1 root root 4510 Jul 20 17:24 zz-ssh-login-info.sh
```

在以上示例中，`/etc/profile.d`目录中的 `zz-ssh-login-info.sh`是打开一个新终端时会显示的系统信息的shell脚本，内容如下：

```bash
[root@k8smaster /etc/profile.d]# cat zz-ssh-login-info.sh 
#!/bin/sh
#
# @Time    : 2020-02-04
# @Author  : lework
# @Desc    : ssh login banner

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH
shopt -q login_shell && : || return 0
echo -e "\033[0;32m
 ██╗  ██╗ █████╗ ███████╗
 ██║ ██╔╝██╔══██╗██╔════╝
 █████╔╝ ╚█████╔╝███████╗
 ██╔═██╗ ██╔══██╗╚════██║
 ██║  ██╗╚█████╔╝███████║
 ╚═╝  ╚═╝ ╚════╝ ╚══════ by kainstall\033[0m"

# os
upSeconds="$(cut -d. -f1 /proc/uptime)"
secs=$((${upSeconds}%60))
mins=$((${upSeconds}/60%60))
hours=$((${upSeconds}/3600%24))
days=$((${upSeconds}/86400))
UPTIME_INFO=$(printf "%d days, %02dh %02dm %02ds" "$days" "$hours" "$mins" "$secs")

if [ -f /etc/redhat-release ] ; then
    PRETTY_NAME=$(< /etc/redhat-release)

elif [ -f /etc/debian_version ]; then
   DIST_VER=$(</etc/debian_version)
   PRETTY_NAME="$(grep PRETTY_NAME /etc/os-release | sed -e 's/PRETTY_NAME=//g' -e  's/"//g') ($DIST_VER)"

else
    PRETTY_NAME=$(cat /etc/*-release | grep "PRETTY_NAME" | sed -e 's/PRETTY_NAME=//g' -e 's/"//g')
fi

if [[ -d "/system/app/" && -d "/system/priv-app" ]]; then
    model="$(getprop ro.product.brand) $(getprop ro.product.model)"

elif [[ -f /sys/devices/virtual/dmi/id/product_name ||
        -f /sys/devices/virtual/dmi/id/product_version ]]; then
    model="$(< /sys/devices/virtual/dmi/id/product_name)"
    model+=" $(< /sys/devices/virtual/dmi/id/product_version)"

elif [[ -f /sys/firmware/devicetree/base/model ]]; then
    model="$(< /sys/firmware/devicetree/base/model)"

elif [[ -f /tmp/sysinfo/model ]]; then
    model="$(< /tmp/sysinfo/model)"
fi

MODEL_INFO=${model}
KERNEL=$(uname -srmo)
USER_NUM=$(who -u | wc -l)
RUNNING=$(ps ax | wc -l | tr -d " ")

# disk
totaldisk=$(df -h -x devtmpfs -x tmpfs -x debugfs -x aufs -x overlay --total 2>/dev/null | tail -1)
disktotal=$(awk '{print $2}' <<< "${totaldisk}")
diskused=$(awk '{print $3}' <<< "${totaldisk}")
diskusedper=$(awk '{print $5}' <<< "${totaldisk}")
DISK_INFO="\033[0;33m${diskused}\033[0m of \033[1;34m${disktotal}\033[0m disk space used (\033[0;33m${diskusedper}\033[0m)"

# cpu
cpu=$(awk -F':' '/^model name/ {print $2}' /proc/cpuinfo | uniq | sed -e 's/^[ \t]*//')
cpun=$(grep -c '^processor' /proc/cpuinfo)
cpuc=$(grep '^cpu cores' /proc/cpuinfo | tail -1 | awk '{print $4}')
cpup=$(grep '^physical id' /proc/cpuinfo | wc -l)
CPU_INFO="${cpu} ${cpup}P ${cpuc}C ${cpun}L"

# get the load averages
read one five fifteen rest < /proc/loadavg
LOADAVG_INFO="\033[0;33m${one}\033[0m / ${five} / ${fifteen} with \033[1;34m$(( cpun*cpuc ))\033[0m core(s) at \033[1;34m$(grep '^cpu MHz' /proc/cpuinfo | tail -1 | awk '{print $4}')\033 MHz"

# mem
MEM_INFO="$(cat /proc/meminfo | awk '/MemTotal:/{total=$2/1024/1024;next} /MemAvailable:/{use=total-$2/1024/1024; printf("\033[0;33m%.2fGiB\033[0m of \033[1;34m%.2fGiB\033[0m RAM used (\033[0;33m%.2f%%\033[0m)",use,total,(use/total)*100);}')"

# network
# extranet_ip=" and $(curl -s ip.cip.cc)"
IP_INFO="$(ip a|grep -E '^[0-9]+: em*|^[0-9]+: eno*|^[0-9]+: enp*|^[0-9]+: ens*|^[0-9]+: eth*|^[0-9]+: wlp*' -A2|grep inet|awk -F ' ' '{print }'|cut -f1 -d/|xargs echo)"

# Container info
CONTAINER_INFO="$(sudo /usr/bin/crictl ps -a -o yaml 2> /dev/null | awk '/^  state: /{gsub("CONTAINER_", "", $NF) ++S[$NF]}END{for(m in S) printf "%s%s:%s ",substr(m,1,1),tolower(substr(m,2)),S[m]}')Images:$(sudo /usr/bin/crictl images -q 2> /dev/null | wc -l)"

# info
echo -e "
 Information as of: \033[1;34m$(date +"%Y-%m-%d %T")\033[0m
 
 \033[0;1;31mProduct\033[0m............: ${MODEL_INFO}
 \033[0;1;31mOS\033[0m.................: ${PRETTY_NAME}
 \033[0;1;31mKernel\033[0m.............: ${KERNEL}
 \033[0;1;31mCPU\033[0m................: ${CPU_INFO}

 \033[0;1;31mHostname\033[0m...........: \033[1;34m$(hostname)\033[0m
 \033[0;1;31mIP Addresses\033[0m.......: \033[1;34m${IP_INFO}\033[0m

 \033[0;1;31mUptime\033[0m.............: \033[0;33m${UPTIME_INFO}\033[0m
 \033[0;1;31mMemory\033[0m.............: ${MEM_INFO}
 \033[0;1;31mLoad Averages\033[0m......: ${LOADAVG_INFO}
 \033[0;1;31mDisk Usage\033[0m.........: ${DISK_INFO} 

 \033[0;1;31mUsers online\033[0m.......: \033[1;34m${USER_NUM}\033[0m
 \033[0;1;31mRunning Processes\033[0m..: \033[1;34m${RUNNING}\033[0m
 \033[0;1;31mContainer Info\033[0m.....: ${CONTAINER_INFO}
"
```

效果如下：

```yaml
Last login: Thu Nov  3 13:56:49 2022 from 192.168.172.1

 ██╗  ██╗ █████╗ ███████╗
 ██║ ██╔╝██╔══██╗██╔════╝
 █████╔╝ ╚█████╔╝███████╗
 ██╔═██╗ ██╔══██╗╚════██║
 ██║  ██╗╚█████╔╝███████║
 ╚═╝  ╚═╝ ╚════╝ ╚══════ by kainstall

 Information as of: 2022-11-03 16:33:13
 
 Product............: VMware Virtual Platform None
 OS.................: CentOS Linux release 7.5.1804 (Core) 
 Kernel.............: Linux 3.10.0-862.el7.x86_64 x86_64 GNU/Linux
 CPU................: Intel(R) Core(TM) i7-10510U CPU @ 1.80GHz 2P 1C 2L

 Hostname...........: k8smaster
 IP Addresses.......: inet 192.168.172.103

 Uptime.............: 5 days, 13h 51m 05s
 Memory.............: 1.16GiB of 3.84GiB RAM used (30.14%)
 Load Averages......: 0.23 / 0.43 / 0.48 with 2 core(s) at 2303.999Hz
 Disk Usage.........: 6.3G of 98G disk space used (7%) 

 Users online.......: 3
 Running Processes..: 144
 Container Info.....: Exited:2 Running:7 Images:20
```

3）在 `/etc/bashrc`文件中设置环境变量。

该文件配置的环境变量将会影响全部用户使用的bash shell。但是，Linux也不建议在 `/etc/bashrc`文件中设置系统环境变量。

### 3. 用户环境变量

用户环境变量只对当前用户生效，设置用户环境变量也有多种方法。

在用户的主目录，有几个隐藏文件，用 `ls`是看不见的，用 `ls .bash*`可以看见。

```mipsasm
[root@k8smaster ~]# ls .bash*
.bash_history  .bash_logout  .bash_profile  .bashrc
```

- 1.`.bash_profile（推荐首选）`

当用户登录时执行，每个用户都可以使用该文件来配置专属于自己的环境变量。

- 2.`.bashrc`

当用户登录时以及每次打开新的Shell时该文件都将被读取，不推荐在里面配置用户专用的环境变量，因为每开一个Shell，该文件都会被读取一次，效率肯定受影响。

- 3.`.bash_logout`

当每次退出系统（退出bash shell）时执行该文件。

- 4.`.bash_history`

保存了当前用户使用过的历史命令。

### 4. 环境变量脚本文件的执行顺序

环境变量脚本文件的执行顺序如下：

```
/etc/profile` --> `/etc/profile.d` --> `/etc/bashrc` --> `用户的.bash_profile` --> `用户的.bashrc
```

同名的环境变量，如果在多个脚本中有配置，以最后执行的脚本中的配置为准。

还有一个问题需要注意，在 `/etc/profile`中执行了 `/etc/profile.d`的脚本，代码如下：

```bash
for i in /etc/profile.d/*.sh /etc/profile.d/sh.local ; do
    if [ -r "$i" ]; then
        if [ "${-#*i}" != "$-" ]; then
            . "$i"
        else
            . "$i" >/dev/null
        fi
    fi
done
```

所以，`/etc/profile.d`和 `/etc/profile`的执行顺序还要看代码怎么写。

四.重要环境变量的详解

#### PATH

可执行程序的搜索目录，可执行程序包括Linux系统命令和用户的应用程序。如果可执行程序的目录不在PATH指定的目录中，执行时需要指定目录。

- 1.PATH环境变量存放的是目录列表，目录之间用冒号 `:`分隔，最后的圆点 `.`表示当前目录。

```bash
export PATH=目录1:目录2:目录3:......目录n:.
```

- 2.PATH缺省包含了Linux系统命令所在的目录（`/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin`），如果不包含这些目录，Linux的常用命令也无法执行（要输入绝对路径才能执行）。

```cmake
[root@k8smaster ~]# /usr/bin/ls 
daemonset  elastic-stack  filebeat-daemonset  filebeat-kubernetes.yaml  loki  sidecar  sidecar-test  test
[root@k8smaster ~]# ls
daemonset  elastic-stack  filebeat-daemonset  filebeat-kubernetes.yaml  loki  sidecar  sidecar-test  test
```

- 3.在用户的 `.bash_profile`文件中，会对PATH进行扩充，如下：

```bash
PATH=$PATH:$HOME/bin
export PATH
```

- 4.如果PATH变量中没有包含圆点 `.`，执行当前目录下的程序需要加 `./`或使用绝对路径。

#### LANG

LANG环境变量存放的是Linux系统的语言、地区、字符集，它不需要系统管理员手工设置，`/etc/profile`会调用 `/etc/profile.d/lang.sh`脚本完成对LANG的设置。

CentOS6.x 字符集配置文件在 `/etc/syscconfig/i18n`文件中。

CentOS7.x 字符集配置文件在 `/etc/locale.conf`文件中。内容如下：

```csharp
[root@k8smaster ~]# cat /etc/locale.conf 
LANG="en_US.UTF-8"
[root@k8smaster ~]# echo $LANG
en_US.UTF-8
```

#### LD_LIBRARY_PATH

C/C++语言动态链接库文件搜索的目录，它不是Linux缺省的环境变量，但对C/C++程序员来说非常重要。

LD_LIBRARY_PATH 环境变量存放的也是目录列表，目录之间用冒号 `:`分隔，最后的圆点 `.`表示当前目录，与 PATH 的格式相同。

```bash
export LD_LIBRARY_PATH=目录1:目录2:目录3:......目录n:.
```

#### CLASSPATH

JAVA 语言库文件搜索的目录，它也不是 Linux 缺省的环境变量，但对 JAVA 程序员来说非常重要。

CLASSPATH 环境变量存放的也是目录列表，目录之间用冒号 `:`分隔，最后的圆点 `.`表示当前目录，与 PATH 的格式相同。

## 五.  环境变量的生效

- 1.在Shell下，用 `export`设置的环境变量对当前Shell立即生效，Shell退出后失效。
- 2.在脚本文件中设置的环境变量不会立即生效，退出Shell后重新登录时才生效，或者用 `source`命令让它立即生效，例如：`source /etc/profile`

## 六. 应用经验

虽然设置环境变量的方法有多种，但是建议系统环境变量建议在 `/etc/profile.d`目录中配置，用户环境变量在用户的 `.bash_profile`中配置，不建议在其它脚本文件中配置环境变量，会增加运维的麻烦，容易出错。
