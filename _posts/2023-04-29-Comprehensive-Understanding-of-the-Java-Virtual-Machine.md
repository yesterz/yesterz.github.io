---
title: 深入理解 Java 虚拟机
date: 2023-04-29 21:09:00 +0800
author: 
categories: [JVM]
tags: [JVM]
pin: false
math: false
mermaid: true
img_path: /assets/images/
---

![The Standard Structure of the Java Virtual Machine (JVM)](Comprehensive-Understanding-of-the-Java-Virtual-Machine/The-Standard-Structure-of-the-Java-Virtual-Machine.png)

## Java 代码的执行


### 源码编译机制

- [ ] javac 编译源码为 class 文件的步骤

**Sun JDK 中采用 javac 将 Java 源码编译为 class 文件，这个过程包含三个步骤：**

1. 分析和输入到符号表（Parse and Enter）

    Parse 过程所做的为词法和语法分析。词法分析（com.sun.tools.javac.parser.Scanner）要完成的是将代码字符串转变为token序列（例如`Token.EQ(name:=)`）；语法分析（com.sun.tools.javac.parser.Parser）要完成的是根据语法由 token 序列生成抽象语法树 。

    Enter（com.sun.tools.javac.comp.Enter）过程为将符号输入到符号表，通常包括确定类的超类型和接口、根据需要添加默认构造器、将类中出现的符号输入类自身的符号表中等。

2. 注解处理（Annotation Processing）

    该步骤主要用于处理用户自定义的 annotation，可能带来的好处是基于 annotation 来生成附加的代码或进行一些特殊的检查，从而节省一些共用的代码的编写，例如当采用 Lombok 时，可编写如下代码：

    ```java
    public class User{  
        private @Getter String username;  
    } 
    ```

    编译时引入 Lombok 对`User.java`进行编译后，再通过 javap 查看 class 文件可看到自动生成了`public String getUsername()`方法。

此功能基于 JSR 269 ，在Sun JDK 6中提供了支持，在 Annotation Processing 进行后，再次进入 Parse and Enter 步骤。

3. 语义分析和生成 class 文件（Analyse and Generate）

    Analyse 步骤基于抽象语法树进行一系列的语义分析，包括将语法树中的名字、表达式等元素与变量、方法、类型等联系到一起；检查变量使用前是否已声明；推导泛型方法的类型参数；检查类型匹配性；进行常量折叠；检查所有语句都可到达；检查所有 checked exception 都被捕获或抛出；检查变量的确定性赋值（例如有返回值的方法必须确定有返回值）；检查变量的确定性不重复赋值（例如声明为 final 的变量等）；解除语法糖（消除`if(false) {…}`形式的无用代码；将泛型 Java 转为普通 Java；将含有语法糖的语法树改为含有简单语言结构的语法树，例如 foreach 循环、自动装箱/拆箱等）等。

    在完成了语义分析后，开始生成 class 文件（com.sun.tools.javac.jvm.Gen），生成的步骤为：
    * 首先将实例成员初始化器收集到构造器中，将静态成员初始化器收集为`<clinit>()`；
    * 接着将抽象语法树生成字节码，采用的方法为后序遍历语法树，并进行最后的少量代码转换（例如 String 相加转变为 StringBuilder 操作）；
    * 最后从符号表生成 class 文件。

    上面简单介绍了基于javac如何将java源码编译为class文件 ，除javac外，还可通过ECJ（Eclipse Compiler for Java） 或Jikes 等编译器来将Java源码编译为class文件。


**一个class文件包含了以下信息。**

1. 结构信息

    包括 class 文件格式版本号及各部分的数量与大小的信息。

2. 元数据

    简单来说，可以认为元数据对应的就是 Java 源码中"声明"与"常量"的信息，主要有：类/继承的超类/实现的接口的声明信息、域（Field）与方法声明信息和常量池。

3. 方法信息

    简单来说，可以认为方法信息对应的就是 Java 源码中"语句"与"表达式"对应的信息，主要有：字节码、异常处理器表、求值栈与局部变量区大小、求值栈的类型记录、调试用符号信息。

### 类加载机制

源码编译为 class 文件后，即可放入 JVM 中执行。执行时 JVM 首先要做的是装载 class 文件，这个机制通常称为类加载机制。

类加载机制是指 .class 文件加载到 JVM，并形成 Class 对象的机制，之后应用就可对 Class 对象进行实例化并调用，类加载机制可在运行时动态加载外部的类、远程网络下载过来的 class 文件等。除了该动态化的优点外，还可通过 JVM 的类加载机制来达到类隔离的效果，例如 Application Server 中通常要避免两个应用的类互相干扰。

JVM 将类加载过程划分为三个步骤：装载、链接和初始化。装载和链接过程完成后，即将二进制的字节码转换为Class 对象；初始化过程不是加载类时必须触发的，但最迟必须在初次主动使用对象前执行，其所作的动作为给静态变量赋值、调用`<clinit>()`等。

在完成将 class 文件信息加载到 JVM 并产生 Class 对象后，就可执行 Class 对象的静态方法或实例化对象进行调用了。在源码编译阶段将源码编译为 JVM 字节码，JVM 字节码是一种中间代码的方式，要由 JVM 在运行期对其进行解释并执行，这种方式称为字节码解释执行方式。

#### 1-装载（Load）

装载过程负责找到二进制字节码并加载至 JVM 中，JVM 通过类的全限定名（com.bluedavy.HelloWorld）及类加载器（ClassLoaderA实例）完成类的加载，同样，也采用以上两个元素来标识一个被加载了的类：类的全限定名+ClassLoader 实例 ID。类名的命名方式如下：

1. 对于接口或非数组型的类，其名称即为类名，此种类型的类由所在的 ClassLoader 负责加载；
2. 对于数组型的类，其名称为"["+（基本类型或L+引用类型类名;），例如`byte[] bytes=new byte[512]`，该bytes 的类名为：`[B; Object[] bjects=new Object[10]`，objects的类名则为：`[Ljava.lang.Object;`，数组型类中的元素类型由所在的 ClassLoader 负责加载，但数组类则由 JVM 直接创建。

#### 2-链接（Link）

**链接过程负责对二进制字节码的格式进行校验、初始化装载类中的静态变量及解析类中调用的接口、类。**

二进制字节码的格式校验遵循 Java Class File Format（具体请参见 JVM 规范）规范，如果格式不符合，则抛出 VerifyError；校验过程中如果碰到要引用到其他的接口和类，也会进行加载；如果加载过程失败，则会抛出 NoClassDefFoundError。

在完成了校验后，JVM 初始化类中的静态变量，并将其值赋为默认值。

最后对类中的所有属性、方法进行验证，以确保其要调用的属性、方法存在，以及具备相应的权限（例如 public、private 域权限等）。如果这个阶段失败，可能会造成 NoSuchMethodError、NoSuchFieldError 等错误信息。

#### 3-初始化（Initialize）

初始化过程即执行类中的静态初始化代码、构造器代码及静态属性的初始化，在以下四种情况下初始化过程会被触发执行：
1. 调用了new；
2. 反射调用了类中的方法；
3. 子类调用了初始化；
4. JVM启动过程中指定的初始化类。

在执行初始化过程之前，首先必须完成链接过程中的校验和准备阶段，解析阶段则不强制。

JVM 的类加载通过 ClassLoader 及其子类来完成，分为`Bootstrap ClassLoader`、`Extension ClassLoader`、`System ClassLoader`及`User-Defined ClassLoader`。这4种 ClassLoader 的关系如下图所示。

![The ClassLoader Inheritance Hierarchy](Comprehensive-Understanding-of-the-Java-Virtual-Machine/The-ClassLoader-Inheritance-Hierarchy.png)

1. Bootstrap ClassLoader

Sun JDK 采用 C++ 实现了此类，此类并非 ClassLoader 的子类，在代码中没有办法拿到这个对象，Sun JDK 启动时会初始化此 ClassLoader，并由 ClassLoader 完成`$JAVA_HOME`中`jre/lib/rt.jar`里所有 class 文件的加载，jar 中包含了 Java 规范定义的所有接口及实现。

2. Extension ClassLoader

JVM 用此 ClassLoader 来加载扩展功能的一些 jar 包，例如 Sun JDK 中目录下有 dns 工具 jar 包等，在Sun JDK 中 ClassLoader 对应的类名为 ExtClassLoader。

3. System ClassLoader

JVM 用此 ClassLoader 来加载启动参数中指定的 Classpath 中的 jar 包及目录，在 Sun JDK 中 ClassLoader 对应的类名 为AppClassLoader。

4. User-Defined ClassLoader

`User-Defined ClassLoader`是Java开发人员继承 ClassLoader 抽象类自行实现的 ClassLoader，基于自定义的 ClassLoader 可用于加载非 Classpath 中（例如从网络上下载的 jar 或二进制）的 jar 及目录、还可以在加载之前对 class 文件做一些动作，例如解密等。

JVM 的 ClassLoader 采用的是树形结构，除`BootstrapClassLoader`外，其他的 ClassLoader 都会有 parent ClassLoader，`User-Defined ClassLoader`默认的 parent ClassLoader 为`System ClassLoader`。加载类时通常按照树形结构的原则来进行，也就是说，首先应从 parent ClassLoader 中尝试进行加载，当 parent 中无法加载时，应再尝试从`System ClassLoader`中进行加载，`System ClassLoader`同样遵循此原则，在找不到的情况下会自动从其 parent ClassLoader 中进行加载。值得注意的是，由于 JVM 是采用类名加 Classloader 的实例来作为 Class 加载的判断的，因此加载时不采用上面的顺序也是可以的，例如加载时不去 parent ClassLoader 中寻找，而只在当前的 ClassLoader 中寻找，会造成树上多个不同的 ClassLoader 中都加载了某 Class，并且这些 Class 的实例对象都不相同，JVM 会保证同一个 ClassLoader 实例对象中只能加载一次同样名称的 Class，因此可借助此来实现类隔离的需求，但有时也会带来困惑，例如 ClassCastException。因此在加载类的顺序上要根据需求合理把握，尽量保证从根到最下层的 ClassLoader 上的 Class 只加载了一次。

ClassLoader 抽象类提供了几个关键的方法：

* loadClass

此方法负责加载指定名字的类，ClassLoader 的实现方法为先从已经加载的类中寻找，如没有，则继续从 parent ClassLoader 中寻找；如仍然没找到，则从 System ClassLoader 中寻找，最后再调用 findClass 方法来寻找，如果要改变类的加载顺序，则可覆盖此方法；如果加载顺序相同，则可通过覆盖 findClass 来做特殊的处理，例如解密、固定路径寻找等。当通过寻找类的过程仍然未获取 Class 对象时，则抛出 ClassNotFoundExcepiton。

如果类需要 resolve，则调用 resolveClass 进行链接。

* findLoadedClass

此方法负责从当前 ClassLoader 实例对象的缓存中寻找已加载的类，调用的为 native 的方法。

* findClass

此方法直接抛出 ClassNotFoundException，因此需要通过覆盖 loadClass 或此方法来以自定义的方式加载相应的类。

* findSystemClass

此方法负责从`System ClassLoader`中寻找类，如未找到，则继续从`Bootstrap ClassLoader`中寻找，如仍然未找到，则返回 null。

* defineClass

此方法负责将二进制的字节码转换为Class对象。

* resolveClass

此方法负责完成Class对象的链接，如已链接过，则会直接返回。

根据上面的描述，在实际的应用中，JVM 类加载过程会抛出这样那样的异常，这些情况下掌握各种异常产生的原因是最为重要的，下面来看类加载方面的常见异常。

1. ClassNotFoundException
2. NoClassDefFoundError
3. LinkageError
4. ClassCastException

### 类执行机制


#### 字节码解释执行


#### 编译执行

#### 反射执行

## JVM 内存管理

### 内存管理

### 内存分配

### 内存回收

### JVM 内存状况查看方法和分析工具

## 线程资源同步及交互机制

### 线程资源同步机制


### 线程交互机制


### 线程状态及分析

