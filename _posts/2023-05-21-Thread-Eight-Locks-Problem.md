---
title: 线程八锁问题
author: 
date: 2023-05-21 11:33:00 +0800
categories: [Concurrent Programming]
tags: [Concurrent Programming]
pin: false
math: false
mermaid: false
---

所谓的“线程八锁”，其实就是看 synchronized 锁住的是哪个对象

## 情况1：12 或 21都是有可能的，就看cpu先调度哪个线程

```java
@Slf4j(topic = "c.Number")
class Number{
    public synchronized void a() {
        log.debug("1");
    }
    public synchronized void b() {
        log.debug("2");
    }
}
​
public static void main(String[] args) {
    Number n1 = new Number();
    new Thread(()->{ n1.a(); }).start();
    new Thread(()->{ n1.b(); }).start();
}
```

## 情况2：1s后12，或 2 1s后 1 ，还是看cpu先调度哪个线程

```java
@Slf4j(topic = "c.Number")
class Number{
    public synchronized void a() {
        sleep(1); //睡眠1秒
        log.debug("1");
    }
    public synchronized void b() {
        log.debug("2");
    }
}
​
public static void main(String[] args) {
    Number n1 = new Number();
    new Thread(()->{ n1.a(); }).start();
    new Thread(()->{ n1.b(); }).start();
}
```

## 情况3：3 1s后 12 、 23 1s后 1 、 32 1s后 1，3肯定是最开始的打印的，就看1或2谁先打印

```java
@Slf4j(topic = "c.Number")
class Number{
    public synchronized void a() {
        sleep(1);//睡眠1秒
        log.debug("1");
    }
    public synchronized void b() {
        log.debug("2");
    }
    public void c() { // 未加锁
        log.debug("3");
    }
}
​
public static void main(String[] args) {
    Number n1 = new Number();
    new Thread(()->{ n1.a(); }).start();
    new Thread(()->{ n1.b(); }).start();
    new Thread(()->{ n1.c(); }).start();
}
```

## 情况4：2 1s 后 1，没有互斥，同时运行，2先打印，sleep 1秒后打印1

```java
@Slf4j(topic = "c.Number")
class Number{
    public synchronized void a() {
        sleep(1);//睡眠1秒
        log.debug("1");
    }
    public synchronized void b() {
        log.debug("2");
    }
}
​
public static void main(String[] args) {
    Number n1 = new Number();
    Number n2 = new Number();
    new Thread(()->{ n1.a(); }).start();
    new Thread(()->{ n2.b(); }).start();
}
```

## 情况5：2 1s 后 1，锁住的对象不同，所以和题4一样，不存在互斥。

```java
@Slf4j(topic = "c.Number")
class Number{
    public static synchronized void a() {
        sleep(1);//睡眠1秒
        log.debug("1");
    }
    public synchronized void b() {
        log.debug("2");
    }
}
​
public static void main(String[] args) {
    Number n1 = new Number();
    new Thread(()->{ n1.a(); }).start();
    new Thread(()->{ n1.b(); }).start();
}
```

## 情况6：1s 后12， 或 2 1s后 1，还是看cpu先调度哪个线程

```java
@Slf4j(topic = "c.Number")
class Number{
    public static synchronized void a() {
        sleep(1);//睡眠1秒
        log.debug("1");
    }
    public static synchronized void b() {
        log.debug("2");
    }
}
​
public static void main(String[] args) {
    Number n1 = new Number();
    new Thread(()->{ n1.a(); }).start();
    new Thread(()->{ n1.b(); }).start();
}
```

## 情况7：2 1s 后 1，锁住的对象不同，所以和题4一样，不存在互斥。

```java
@Slf4j(topic = "c.Number")
class Number{
    public static synchronized void a() {
        sleep(1);// 睡眠1秒
        log.debug("1");
    }
    public synchronized void b() {
        log.debug("2");
    }
}
​
public static void main(String[] args) {
    Number n1 = new Number();
    Number n2 = new Number();
    new Thread(()->{ n1.a(); }).start();
    new Thread(()->{ n2.b(); }).start();
}
```

## 情况8：1s 后12， 或 2 1s后 1，锁着的同一个对象，还是看cpu先调度哪个线程

```java
@Slf4j(topic = "c.Number")
class Number{
    public static synchronized void a() {
        sleep(1); // 睡眠1秒
        log.debug("1");
    }
    public static synchronized void b() {
        log.debug("2");
    }
}
​
public static void main(String[] args) {
    Number n1 = new Number();
    Number n2 = new Number();
    new Thread(()->{ n1.a(); }).start();
    new Thread(()->{ n2.b(); }).start();
}
```