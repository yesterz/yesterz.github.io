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

## 饿汉式

```java
public final class Singleton {

    private byte[] data = new byte[1024];
    
    private static Singleton instance = new Singleton();

    private Singleton() {}

    public static Singleton getInstance() {
        return instance;
    }
}
```

饿汉式，在类一开始初始化就立即把单例对象创建出来。`instance`是一个类变量，在类初始化过程中会被收集进`<clinit>()`中，`<clinit>()`保证百分百同步，不会在多线程的情况下被实例化两次。

但是`instance`被`ClassLoader`加载后可能很长一段时间才被使用，`instance`实例所开辟的堆内存会驻留很久，要是用不到这个实例则会造成内存浪费。

## 懒汉式

<font color='red' style='font-weight:bold' font-family='Consolas'>Lazy initialization: if null then new</font>

```java
public final class Singleton {
    
    private byte[] data = new byte[1024];

    private static Singleton instance = null;

    private Singleton() {}

    public static Singleton getInstance() {

        if (null == instance) {
            instance == new Singleton();
        }
        return instance;
    }
}
```

如果 new 一次 singleton 开销很大的时候，所以我们就采用懒汉式。但是在多线程环境下，会导致`instance`被实例化一次以上，不唯一。也就是说两个线程同时看到`instance==null`，这时候`instance`就会保证不了单例的唯一性了。

## 懒汉式 + 同步方法

```java
public final class Singleton {

    private byte[] data = new byte[1024];

    private static Singleton instance = null;

    private Singleton() {}

    public static synchronized Singleton getInstance() {

        if (null == instance) {
            instance = new Singleton();
        }
        return instance;
    }
}
```

满足了懒加载，又能保证`instance`实例的唯一性，但是`synchronized`关键字天生的排他性导致了`getInstance`方法只能在同一时刻被一个线程访问，性能差。

## Double-Check Lock(DCL)

It's thread-safe.

```java
public final class Singleton {

    private byte[] data = new byte[1024];
    
    private static volatile Singleton instance = null;

    Connection conn;

    Socket socket;

    private Singleton() {
        this.conn; // initialize conn
        this.socket; // initialize socket
    }
    
    public static Singleton getInstance() {

        if(null == instance) {
            synchronized(Singleton.class) {         
                if (null == instance) { 
                    instance = new Singleton();
                }
            }
        }
        return instance;
    } // end of getInstance
} // end Singleton
```

如果不加`volatile`关键字，在初始化`instance`创建实例后，另一个线程看到了`instance != null`即可返回并使用类的实例变量`conn`或`socket`，但是会有一种情况发生就是这时候这俩还没创建完成，未完成初始化的实例调用其方法就会抛出空指针异常。

出现的原因可能是 JVM 运行时指令重排序和 Happens-Before 规则，极有可能时`instance`最先被实例化。不过加上`volatile`关键字就能防止这种重排序的方式。

## Enum

```java
public enum Singleton {
    
    private byte[] data = new byte[1024];
    
    INSTANCE;

    public static void whateverMethod() {}
}
```

使用枚举的方式实现单例模式是《Effective Java》作者力推的方式，在很多优秀的开源代码中经常可以看到使用枚举方式实现单例模式的(身影)，举类型不允许被继承，同样是线程安全的且只能被实例化一次，但是枚举类型不能够懒加载，对`Singleton`主动使用，比如调用其中的静态方法则`INSTANCE`会立即得到实例化。

## Holder 方式

```java
public final class Singleton {

    private byte[] data = new byte[1024];

    private Singleton() {}

    private static class SingletonHolder {
        private static Singleton instance = new Singleton();
    }

    public static Singleton getInstance() {
        return SingletonHolder.instance;
    }
}
```

在`Singleton`类中并没有`instance`的静态成员，而是将其放到了静态内部类`Holder`之中，因此在`Singleton`类的初始化过程中并不会创建`Singleton`的实例，`Holder`类中定义了`Singleton`的静态变量，并且直接进行了实例化，当`Holder`被主动引用的时候则会创建`Singleton`的实例，`Singleton`实例的创建过程在 Java 程序编译时期收集至`<clinit>()`方法中，该方法又是同步方法，同步方法可以保证内存的可见性、JVM指令的顺序性和原子性 Holder 方式的单例设计是最好的设计之一，也是目前使用比较广的设计之一。

## 综上改造

```java
public class Singleton {

    private byte[] data = new byte[1024];

    private Singleton() {}

    private enum EnumHolder {

        INSTANCE;
        private Singleton instance;

        EnumHolder() {
            this.instance = new Singleton();
        }

        private Singleton getSingleton() {
            return instance;
        }
    }

    public static Singleton getInstance() {

        return EnumHolder.INSTANCE.getInstance();
    }
}
```
