---
title: Singleton pattern
date: 2023-11-19 17:17:00 +0800
author: 
categories: [Object-Oriented Design]
tags: [OOD]
pin: false
math: false
mermaid: false
---

## Example:

饿汉式，在类一开始初始化就立即把单例对象创建出来

```java
public class Singleton {
    
    private static final Singleton INSTANCE = new Singleton();

    private Singleton() {}

    public static Singleton getInstance() {
        return INSTANCE;
    }
}
```

## Double-Check Lock(DCL)

It's thread-safe.

```java
public final class Singleton {
    
    private Singleton() { }
    
    private static volatile Singleton INSTANCE = null;
    
    public static Singleton getInstance() {
        // 实例没创建，才会进入内部的 synchronized 代码块
        if(INSTANCE == null) {
            // 首次访问会同步，而之后的使用没有 synchronized
            synchronized(Singleton.class) { // t2
                // 也许有其他线程已经创建实例，所以再次判断
                if (INSTANCE == null) { // t1
                    INSTANCE = new Singleton();
                }
            }
        }
        return INSTANCE;
    } // end of getInstance
} // end Singleton
```

## Lazy initialization + Thread-safe

Lazy initialization: if null then new

如果 new 一次 singleton 开销很大的时候，所以我们就采用懒汉式

```java
public class Singleton {

    private static volatile Singleton instance = null;

    private Singleton() {}

    public static Singleton getInstance() {
        if (instance == null) {
            synchronized(Singleton.class) {
                if (instance == null) {
                    instance = new Singleton();
                }
            }
        }
        return instance;
    }
}
```

## Enum

```java
public enum Singleton {
    INSTANCE;
    public void whateverMethod() {}
}
```

## 静态内部类的写法

```java
public class Singleton {
    private static class SingletonHolder {
        private static final Singleton INSTANCE = new Singleton();
    }

    private Singleton() {}

    public static final Singleton getInstance() {
        return SingletonHolder.INSTANCE;
    }
}
```