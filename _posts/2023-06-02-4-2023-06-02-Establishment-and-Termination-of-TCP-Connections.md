---
title: TCP连接的建立和释放
date: 2023-06-02 21:09:00 +0800
categories: [Computer Networking]
tags: [Computer Networking]
author: ltfy
pin: false
math: false
mermaid: false
---

# 【网络协议 4】TCP连接的建立和释放✅

## **TCP首部格式**

先看TCP报文段的格式，如下;

![Untitled](%E3%80%90%E7%BD%91%E7%BB%9C%E5%8D%8F%E8%AE%AE%204%E3%80%91TCP%E8%BF%9E%E6%8E%A5%E7%9A%84%E5%BB%BA%E7%AB%8B%E5%92%8C%E9%87%8A%E6%94%BE%E2%9C%85%20db6d624de9d44697bd4c5705b447e2ba/Untitled.png)

TCP报文段首部的前20个字节是固定的，后面有4N字节是根据需要而增加的选项。因此TCP报文段的最小长度为20个字节。

首部固定部分的各字段的意义如下：

1、源端口和目的端口：加上IP首部的源IP地址和目的IP地址，确定唯一的一个TCP连接。另外通过目的端口来决定TCP将数据报交付于那个应用程序，从而实现TCP的分用功能。

2、序号：占4个字节，序号的范围为[0,4284967296]。由于TCP是面向字节流的，在一个TCP连接中传送的字节流中的每一个字节都按顺序编号，首部中的序号字段则是指本报文段所发送的数据的第一个字节的序号。另外，序号是循环使用的，当序号增加到最大值时，下一个序号就又回到了0。

3、确认号：当ACK标志位为1时有效，表示期望收到的下一个报文段的第一个数据字节的序号。确认号为N，则表明到序号N-1为止的所有数据字节都已经被正确地接收到了。

4、头部长度：TCP报文段的头部长度，它指出TCP报文段的数据部分的起始位置与TCP报文段的起始位置的距离。头部长度占4个字节，但它的单位是32位字，即以4字节为计算单位，因此头部长度的最大值为15*4=60个字节，这就意味着选项的长度不超过40个字节。

5、保留位：必须为0.

6、下面的六个控制位说明报文段的性质：

- URG：与首部中的紧急指针字段配合使用。URG为1时，表明紧急指针字段有效，发送应用进程告诉发送方的TCP有紧急数据要传送，于是发送方TCP就把紧急数据插入到本报文段数据的最前面，而其后面仍是普通数据。
- ACK：仅当ACK=1时确认号字段才有效，当ACK=0时，确认号无效。TCP规定，在连接建立后所有的传送报文段都必须把ACK置1。
- PSH：如果发送的报文段中PSH为1，则接收方接受到该报文段后，直接将其交付给应用进程，而不再等待整个缓存都填满后再向上交付。
- RST：复位标志，RST=1时，表明TCP连接中出现严重差错，必须释放连接，然后重新建立运输连接。
- SYN：同步序号，用来发起一个连接。当SYN=1而ACK=0时，表明这是一个连接请求报文段，若对方同意建立连接，则应在响应的报文段中使SYN=1和ACK=1。
- FIN：用来释放一个连接。当FIN=1时，表明此报文段的发送方的数据已发送完毕，并要求释放连接。

7、窗口：接收方让发送方下次发送报文段时设置的发送窗口的大小。

8、校验和：校验的字段范围包括首部和数据这两部分。

9、紧急指针：紧急指针当URG=1时才有效，它指出本报文段中的紧急数据的字节数。值得注意的是，即使窗口为0时，也可发送紧急数据。

10、选项与填充：选项应该为4字节的整数倍，否则用0填充。最常见的可选字段是最长报文大小MSS（Maximum Segment Size），每个连接方通常都在通信的第一个报文段中指明这个选项。它指明本端所能接收的最大长度的报文段。该选项如果不设置，默认为536（20+20+536=576字节的IP数据报），其中ip首部和tcp首部各20个字节，而internet 上标准的MTU （最小）为576B。

## **TCP连接的建立**

下图为TCP三次握手连接的建立过程：

服务端的TCP进程先创建传输控制块TCB，准备接受客户端进程的连接请求，然后服务端进程处于LISTEN状态，等待客户端的连接请求，如有，则作出响应。

1、客户端的TCP进程也首先创建传输控制模块TCB，然后向服务端发出连接请求报文段，该报文段首部中的SYN=1，ACK=0，同时选择一个初始序号seq=i。TCP规定，SYN=1的报文段不能携带数据，但要消耗掉一个序号。这时，TCP客户进程进入SYN—SENT（同步已发送）状态，这是TCP连接的第一次握手。

2、服务端收到客户端发来的请求报文后，如果同意建立连接，则向客户端发送确认。确认报文中的SYN=1，ACK=1，确认号ack=i+1，同时为自己选择一个初始序号seq=j。同样该报文段也是SYN=1的报文段，不能携带数据，但同样要消耗掉一个序号。这时，TCP服务端进入SYN—RCVD（同步收到）状态，这是TCP连接的第二次握手。

3、TCP客户端进程收到服务端进程的确认后，还要向服务端给出确认。确认报文段的ACK=1，确认号ack=j+1，而自己的序号为seq=i+1。TCP的标准规定，ACK报文段可以携带数据，但如果不携带数据则不消耗序号，因此，如果不携带数据，则下一个报文段的序号仍为seq=i+1。这时，TCP连接已经建立，客户端进入ESTABLISHED（已建立连接）状态。这是TCP连接的第三次握手，可以看出第三次握手客户端已经可以发送携带数据的报文段了。

当服务端收到确认后，也进入ESTABLISHED（已建立连接）状态。

**双方同时主动连接的TCP连接建立过程**    正常情况下，传输连接都是由一方主动发起的，但也有可能双方同时主动发起连接，此时就会发生连接碰撞，最终只有一个连接能够建立起来。因为所有连接都是由它们的端点进行标识的。如果第一个连接请求建立起一个由套接字（x,y）标识的连接，而第二个连接也建立了这样一个连接，那么在TCP实体内部只有一个套接字表项。当出现同时发出连接请求时，则两端几乎在同时发送一个SYN字段置1的数据段，并进入SYN_SENT状态。当每一端收到SYN数据段时，状态变为SYN_RCVD，同时它们都再发送SYN字段置1，ACK字段置1的数据段，对收到的SYN数据段进行确认。当双方都收到对方的SYN+ACK数据段后，便都进入ESTABLISHED状态。图10-39显示了这种同时发起连接的连接过程，但最终建立的是一个TCP连接，而不是两个，这点要特别注意。

[https://img-blog.csdn.net/20140608204101328?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbnNfY29kZQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast](https://img-blog.csdn.net/20140608204101328?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbnNfY29kZQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

从图中可以看出，一个双方同时打开的传输连接需要交换4数据段，比正常的传输连接建立所进行的三次握手多交换一个数据段。此外要注意的是，此时我们没有将任何一端称为客户或服务器，因为每一端既是客户又是服务器。

为什么一定要进行三次握手呢？

前两次的握手很显然是必须的，主要是最后一次，即客户端收到服务端发来的确认后为什么还要想服务端再发送一次确认呢？这主要是为了防止已失效的请求报文段突然又传送到了服务端而产生连接的误判。

考虑如下的情况：客户端发送了一个连接请求报文段到服务端，但是在某些网络节点上长时间滞留了，而后客户端又超时重发了一个连接请求报文段该服务端，而后正常建立连接，数据传输完毕，并释放了连接。如果这时候第一次发送的请求报文段延迟了一段时间后，又到了服务端，很显然，这本是一个早已失效的报文段，但是服务端收到后会误以为客户端又发出了一次连接请求，于是向客户端发出确认报文段，并同意建立连接。假设不采用三次握手，这时服务端只要发送了确认，新的连接就建立了，但由于客户端比你更没有发出建立连接的请求，因此不会理会服务端的确认，也不会向服务端发送数据，而服务端却认为新的连接已经建立了，并在一直等待客户端发送数据，这样服务端就会一直等待下去，直到超出保活计数器的设定值，而将客户端判定为出了问题，才会关闭这个连接。这样就浪费了很多服务器的资源。而如果采用三次握手，客户端就不会向服务端发出确认，服务端由于收不到确认，就知道客户端没有要求建立连接，从而不建立该连接。

![Untitled](%E3%80%90%E7%BD%91%E7%BB%9C%E5%8D%8F%E8%AE%AE%204%E3%80%91TCP%E8%BF%9E%E6%8E%A5%E7%9A%84%E5%BB%BA%E7%AB%8B%E5%92%8C%E9%87%8A%E6%94%BE%E2%9C%85%20db6d624de9d44697bd4c5705b447e2ba/Untitled%202.png)

## **TCP连接的释放**

下图为TCP四次挥手的释放过程：

![Untitled](%E3%80%90%E7%BD%91%E7%BB%9C%E5%8D%8F%E8%AE%AE%204%E3%80%91TCP%E8%BF%9E%E6%8E%A5%E7%9A%84%E5%BB%BA%E7%AB%8B%E5%92%8C%E9%87%8A%E6%94%BE%E2%9C%85%20db6d624de9d44697bd4c5705b447e2ba/Untitled%203.png)

数据传输结束后，通信的双方都可以释放连接，并停止发送数据。假设现在客户端和服务端都处于ESTABLISHED状态。

1、客户端A的TCP进程先向服务端发出连接释放报文段，并停止发送数据，主动关闭TCP连接。释放连接报文段中FIN=1，序号为seq=u，该序号等于前面已经传送过去的数据的最后一个字节的序号加1。这时，A进入FIN—WAIT-1（终止等待1）状态，等待B的确认。TCP规定，FIN报文段即使不携带数据，也要消耗掉一个序号。这是TCP连接释放的第一次挥手。

2、B收到连接释放报文段后即发出确认释放连接的报文段，该报文段中，ACK=1，确认号为ack=u+1，其自己的序号为v，该序号等于B前面已经传送过的数据的最后一个字节的序号加1。然后B进入CLOSE—WAIT（关闭等待）状态，此时TCP服务器进程应该通知上层的应用进程，因而A到B这个方向的连接就释放了，这时TCP处于半关闭状态，即A已经没有数据要发了，但B若发送数据，A仍要接受，也就是说从B到A这个方向的连接并没有关闭，这个状态可能会持续一些时间。这是TCP连接释放的第二次挥手。

3、A收到B的确认后，就进入了FIN—WAIT（终止等待2）状态，等待B发出连接释放报文段，如果B已经没有要向A发送的数据了，其应用进程就通知TCP释放连接。这时B发出的链接释放报文段中，FIN=1，确认号还必须重复上次已发送过的确认号，即ack=u+1，序号seq=w，因为在半关闭状态B可能又发送了一些数据，因此该序号为半关闭状态发送的数据的最后一个字节的序号加1。这时B进入LAST—ACK（最后确认）状态，等待A的确认，这是TCP连接的第三次挥手。

4、A收到B的连接释放请求后，必须对此发出确认。确认报文段中，ACK=1，确认号ack=w+1，而自己的序号seq=u+1，而后进入TIME—WAIT（时间等待）状态。这时候，TCP连接还没有释放掉，必须经过时间等待计时器设置的时间2MSL后，A才进入CLOSED状态，时间MSL叫做最长报文寿命，RFC建议设为2分钟，因此从A进入TIME—WAIT状态后，要经过4分钟才能进入到CLOSED状态，而B只要收到了A的确认后，就进入了CLOSED状态。二者都进入CLOSED状态后，连接就完全释放了，这是TCP连接的第四次挥手。

## **双方主动关闭的TCP连接释放流程**

与可以双方同时建立TCP传输连接一样，TCP传输连接关闭也可以由双方同时主动进行（正常情况下都是由一方发送第一个FIN数据段进行主动连接关闭，另一方被动接受连接关闭）

![Untitled](%E3%80%90%E7%BD%91%E7%BB%9C%E5%8D%8F%E8%AE%AE%204%E3%80%91TCP%E8%BF%9E%E6%8E%A5%E7%9A%84%E5%BB%BA%E7%AB%8B%E5%92%8C%E9%87%8A%E6%94%BE%E2%9C%85%20db6d624de9d44697bd4c5705b447e2ba/Untitled%204.png)

当两端对应的网络应用层进程同时调用CLOSE原语，发送FIN数据段执行关闭命令时，两端均从ESTABLISHED状态转变为FIN WAIT 1状态。任意一方收到对端发来的FIN数据段后，其状态均由FIN WAIT 1转变到CLOSING状态，并发送最后的ACK数据段。当收到最后的ACK数据段后，状态转变化TIME_WAIT，在等待2MSL后进入到CLOSED状态，最终释放整个TCP传输连接。

为什么A在TIME—WAIT状态必须等待2MSL时间呢？

1、为了保证A发送的最后一个ACK报文段能够到达B。该ACK报文段很有可能丢失，因而使处于在LIST—ACK状态的B收不到对已发送的FIN+ACK报文段的确认，B可能会重传这个FIN+ACK报文段，而A就在这2MSL时间内收到这个重传的FIN+ACK报文段，接着A重传一次确认，重新启动2MSL计时器，最后A和B都进入CLOSED状态。如果A在TIME—WAIT状态不等待一段时间就直接释放连接，到CLOSED状态，那么久无法收到B重传的FIN+ACK报文段，也就不会再发送一次确认ACK报文段，B就无法正常进入CLOSED状态。

2、防止已失效的请求连接出现在本连接中。在连接处于2MSL等待时，任何迟到的报文段将被丢弃，因为处于2MSL等待的、由该插口（插口是IP和端口对的意思，socket）定义的连接在这段时间内将不能被再用，这样就可以使下一个新的连接中不会出现这种旧的连接之前延迟的报文段。

补充：

当客户端执行主动关闭并进入TIME—WAIT是正常的，服务端执行被动关闭，不会进入TIME—WAIT状态，这说明，如果终止了一个客户程序，并立即重启该客户程序，则新的客户程序将不再重用相同的本地端口，而是使用新的端口，这不会带来什么问题，因为客户端使用本地端口，而并不关心这个端口是多少。但对于服务器来说，情况就不同了，服务器总是用我们熟知的端口，那么在2MSL时间内，重启服务器就会出错，为了避免这个错误，服务器给出了一个平静时间的概念，这是说在2MSL时间内，虽然可以重新启动服务器，但是这个服务器还是要平静的等待2MSL时间的过去才能进行下一次连接。

[https://www.bilibili.com/video/BV1c4411d7jb?p=64&vd_source=12c3091e309a1b86c26e458bebc7b10d](https://www.bilibili.com/video/BV1c4411d7jb?p=64&vd_source=12c3091e309a1b86c26e458bebc7b10d)