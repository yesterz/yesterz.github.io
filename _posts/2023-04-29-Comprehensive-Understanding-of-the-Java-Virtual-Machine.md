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

    JVM 用此 ClassLoader 来加载启动参数中指定的 Classpath 中的 jar 包及目录，在 Sun JDK 中 ClassLoader 对应的类名为 AppClassLoader。

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

    这是最常见的异常，产生这个异常的原因为在当前的ClassLoader 中加载类时未找到类文件，对位于System ClassLoader的类很容易判断，只要加载的类不在Classpath中，而对位于 User-DefinedClassLoader 的类则麻烦些，要具体查看这个 ClassLoader加载类的过程，才能判断此 ClassLoader 要从什么位置加载到此类。
    
    例如直接在代码中执行 Class.forName(“com.bluedavy.A”)，而当前类的 classloader 下根本就没有该类所在的jar或没有该class 文件，就会抛出ClassNotFoundException。

2. NoClassDefFoundError

    该异常较之 ClassNotFoundException更难处理一些,造成此异常的主要原因是加载的类中引用到的另外的类不存在，例如要加载A，而A中调用了B，B不存在或当前ClassLoader 没法加载B，就会抛出这个异常。

    例如有一段这样的代码：

    ```java
    public class A {
        private B b = new B();
    }
    ```

    当采用Class.forName加载A时，虽能找到A.class，但此时B.class不存在，则会抛出NoClassDefFoundError。
    
    因此，对于这个异常，须先查看是加载哪个类时报出的，然后再确认该类中引用的类是否存在于当前ClassLoader能加载到的位置。

3. LinkageError

    该异常在自定义 ClassLoader 的情况下更容易出现，主要原因是此类已经在 ClassLoader 加载过了重复地加载会造成该异常，因此要注意避免在并发的情况下出现这样的问题。

    由于JVM 的这个保护机制，使得在JVM中没办法直接更新一个已经 load 的 Class，只能创建一个新的 ClassLoader来加载更新的Class,然后将新的请求转入该ClassLoader 中来获取类,这也是JVM中不好实现动态更新的原因之一，而其他更多的原因是对象状态的复制、依赖的设置等。

4. ClassCastException

    该异常有多种原因，在JDK5支持泛型后，合理使用泛型可相对减少此异常的触发。这些原因中比较难查的是两个A对象由不同的ClassLoader 加载的情况,这时如果将其中某个A对象造型成另外一个A对象，也会报出ClassCastException。

### 类执行机制

    在完成将 class 文件信息加载到JVM 并产生 Class 对象后，就可执行 Class 对象的静态方法或实例化对象进行调用了。在源码编译阶段将源码编译为 JVM 字节码，JVM 字节码是一种中问代码的方式，要由 JVM 在运行期对其进行解释并执行，这种方式称为字节码解释执行方式。

#### 字节码解释执行

由于采用的为中间码的方式，JVM 有一套自己的指令，对于面向对象的语言而言，最重要的是执行方法的指令，JVM 采用了 invokestatic、invokevirtual、invokeinterface 和 invokespecial 四个指令来执行不同的方法调用。invokestatic对应的是调用static方法，invokevirual 对应的是调用对象实例的方法,invokeinterface 对应的是调用接口的方法，invokespecial 对应的是调用 private 方法和编译源码后生成的<init>方法，此方法为对象实例化时的初始化方法，例如下面一段代码：

```java
public class Demo{

    public void execute(){
        A.execute();
        A a=new A();
        a.bar();
        IFoo bnew B();
        b.bar();
    }
}

class A{

    public static int execute(){
        return 1+2;
    }

    public int bar(){
        return 1+2;
    }
}

class B implements IFoo{

    public int bar(){
        return 1+2;
    }
    
    public interface IFoo{
        public int bar();
    }
}
```

通过javac 编译上面的代码后，使用javap -c Demo 查看其 execute 方法的字节码：

```console
```

从以上例子可看到 invokestatic、invokespecial、invokevirtual及invokeinterface 四种指令对应调用方法的情况。

Sun JDK 基于栈的体系结构来执行字节码，基于栈方式的好处为代码紧凑，体积小。

线程在创建后，都会产生程序计数器(PC)(或称为PCregisters)和栈(Siack)；PC存放了下条要执行的指令在方法内的偏移量；栈中存放了栈帧(StackFrame)，每个方法每次调用都会产生栈帧。栈帧主要分为局部变量区和操作数栈两部分，局部变量区用于存放方法中的局部变量和参数，操作数栈中用于存放方法执行过程中产生的中间结果，栈帧中还会有一些杂用空间，例如指向方法已解析的常量池的引用、其他一些 VM 内部实现需要的数据等，结构如图3.5所示。

[] TODO

下面来看一个方法执行时过程的例子，代码如下:

[] TODO

1. 指令解释执行

对于方法的指令解释执行，执行方式为经典冯·诺依曼体系中的 FDX 循环方式，即获取下一条指令，解码并分派，然后执行。在实现 FDX 循环时有 switch-threading、token-threading、direct-threadingsubroutine-threading、inline-threading 等多种方式。

switch-threading 是一种最简方式的实现，代码大致如下:

以上方式很简单地实现了FDX的循环方式，但这种方式的问题是每次执行完都得重新回到循环开始点，然后重新获取下一条指令，并继续switch，这导致了大部分时间都花费在了跳转和获取下一条指令上，而真正业务逻辑的代码非常短。

token-threading 在上面的基础上稍做了改进，改进后的代码大致如下：

这种方式较之 switch-threading方式而言，冗余了fctch 和 dispatch，消耗的内存最会大一些，但由于去除了switch，因此性能会稍好一些。

其他 direct-threading、inline-hreading等做了更多的优化，Sun JDK的重点为编译成机器码，并没有在解释器上做太复杂的处理,因此采用了token-threading方式。为了让解释执行能更加高效,Sun JDK还做了一些其他的优化，主要有:栈顶缓存(top-of-stackcaching)和部分帧共享。

2. 栈顶缓存

在方法的执行过程中，可看到有很多操作要将值放入操作数栈，这导致了寄存器和内存要不断地交换数据，SunJDK采用了一个栈顶缓存，即将本来位于操作数栈顶的值直接缓存在寄存器上，这对于大部分只需要一个值的操作而言，无须将数据放入操作数栈，可直接在寄存器计算，然后放回操作数栈。

3. 部分栈帧共享

当一个方法调用另外一个方法时，通常传入另一方法的参数为已存放在操作数栈的数据。SunJDK在此做了一个优化，就是当调用方法时，后一方法可将前一方法的操作数栈作为当前方法的局部变量从而节省数据 copy 带来的消耗。

另外，在解释执行时，对于一些特殊的情况会直接执行机器指令，例如 Math.sin、UnsafecompareAndSwapInt 等。

#### 编译执行

解释执行的效率较低，为提升代码的执行性能，SunJDK提供将字节码编译为机器码的支持，编译在运行时进行，通常称为JT编译器。SunJDK 在执行过程中对执行频率高的代码进行编译，对执行不频繁的代码则继续采用解释的方式，因此 Sun JDK 又称为 Hotspot VM，在编译上 Sun JDK 提供了两种模式:clientcompiler(-client)和servercompiler(-server)。

client compiler 又称为C1”，较为轻量级，只做少量性能开销比高的优化，它占用内存较少，适合于泉面交互式应用。在寄存器分配策略上，JDK6以后采用的为线性扫描寄存器分配算法"，在其他方面的优化主要有：方法内联、去虚拟化、冗余削除等。

1. 方法内联

对于 Java 类面向对象的语言，通常要调用多个方法来完成功能。执行时，要经历多次参数传递、返回值传递及跳转等,于是C1采取了方法内联的方式，即把调用到的方法的指令直接植入当前方法中。例如一段这样的代码：

当编译时，如 bar2 代码编译后的字节数小于等于 35 字节"，那么，会演变成类似这样的结构"”：

可在 debug 版本的 JDK 的启动参数加上-XX:+PrintInlining 来查看方法内联的信息。

方法内联除带来以上好处外，还能够辅助进行以下冗余削除等优化。

2. 去虚拟化

去虚拟化是指在装载 class 文件后，进行类层次的分析，如发现类中的方法只提供一个实现类，那么对于调用了此方法的代码，也可进行方法内联，从而提升执行的性能。例如一段这样的代码：

3. 冗余削除

冗余削除是指在编译时，根据运行时状况进行代码折叠或削除，例如一段这样的代码：

如 log.isDebugEnabled 返回的为 false，在执行C1编译后，这段代码就演变成类似下面的结构:

public void execute(){// do something

这是为什么会在有些代码编写规则上写不要直接调用log.debug，而要先判断的原因。

Server compiler 又称为C2"，较为重量级，C2采用了大量的传统编译优化技巧来进行优化，占用内存相对会多一些，适合于服务器端的应用。和C1不同的主要是寄存器分配策略及优化的范围，寄存器分配策略上 C2采用的为传统的图着色寄存器分配算法"":由于C2会收集程序的运行信息，因此其优化的范围更多在于全局的优化，而不仅仅是一个方法块的优化。收集的信息主要有:分支的跳转/不跳转的频率、某条指令上出现过的类型、是否出现过空值、是否出现过异常。


逃逸分析"是C2进行很多优化的基础，逃逸分析是指根据运行状况来判断方法中的变量是否会被外部读取。如不会则认为此变量是逃逸的，基于逃逸分析C2在编译时会做标量替换、栈上分配和同步削除等优化。

1. 标量替换

标量替换的意思简单来说就是用标量替换聚合量。例如有这么一段代码:

之后基于此可以继续做几余削除。
这种方式能带来的好处是，如果创建的对象并未用到其中的全部变量，则可以节省一定的内存。
而对于代码执行而言，由于无须去找对象的引用，也会更快一些。

2. 栈上分配

在上面的例子中,如果p没有逃逸,那么C2会选择在栈上直接创建 Point 对象实例,而不是在JVM堆上。在栈上分配的好处一方面是更加快速，另一方面是回收时随着方法的结束，对象也被回收了，这也是栈上分配的概念。

3. 同步削除

同步削除是指如果发现同步的对象未逃逸,那也没有同步的必要了,在C2编译时会直接去掉同步。例如有这么一段代码：

除了基于逃逸分析的这些外，C2还会基于其拥有的运行信息来做其他的优化，例如编译分支频率执行高的代码等。

运行后 C1、C2编译出来的机器码如果不再符合优化条件，则会进行逆优化(deoptimization)，也就是回到解释执行的方式，例如基于类层次分析编译的代码，当有新的相应的接口实现类加入时，就执行逆优化。

除了 C1、C2外，还有一种较为特殊的编译为:OSR(OnStackReplace)16。OSR 编译和 C1、C2最主要的不同点在于 OSR 编译只替换循环代码体的入口，而C1、C2 替换的是方法调用的入口，因此在 OSR 编译后会出现的现象是方法的整段代码被编译了，但只有在循环代码体部分才执行编译后的机器码，其他部分则仍然是解释执行方式。

默认情况下，Sun JDK根据机器配置来选择client或 server 模式，当机器配置 CPU超过2核且内存超过 2GB 即默认为 seryer 模式，但在 32位 Windows机器上始终选择的都是client 模式时，也可在启动时通过增加-cient或-server 来强制指定，在JDK7中可能会引入多层编译的支持。多层编译是指在-server 的模式下采用如下方式进行编译:

解释器不再收集运行状况信息，只用于启动并触发C1编译:

C1编译后生成带收集运行信息的代码:

C2编译，基于C1编译后代码收集的运行信息来进行激进优化,当激进优化的假设不成立时，再退回使用 C1编译的代码。

从以上介绍来看，SunJDK为提升程序执行的性能，在C1和C2上做了很多的努力，其他各种实现的 JVM 也在编译执行上做了很多的优化，例如在 IBMJ9、Oracle JRockit 中做了内联、逃逸分析等"?Sun JDK之所以未选择在启动时即编译成机器码，有几方面的原因:

1. 静态编译并不能根据程序的运行状况来优化执行的代码，C2 这种方式是根据运行状况来进行动态编译的，例如分支判断、逃逸分析等，这些措施会对提升程序执行的性能会起到很大的帮助，在静态编译的情况下是无法实现的。给C2收集运行数据越长的时间，编译出来的代码会越优:

2. 解释执行比编译执行更节省内存;

3. 启动时解释执行的启动速度比编译再启动更快。

但程序在未编译期间解释执行方式会比较慢，因此需要取一个权衡值，在SunJDK中主要依据方法上的两个计数器是否超过阀值，其中一个计数器为调用计数器，即方法被调用的次数;另一个计数器为回边计数器，即方法中循环执行部分代码的执行次数。下面将介绍两个计数器对应的值。

CompileThreshold

该值是指当方法被调用多少次后，就编译为机器码。在client模式下默认为1500次，在server 模式下默认为 10000次，可通过在启动时添加-XX:CompileThreshold=10 000来设置该值。

OnStackReplacePercentage

该值为用于计算是否触发 OSR编译的值，默认情况下 client 模式时为933,server 模式下为140,该值可通过在启动时添加-XX:OnStackReplacePercentage=140来设置，在client 模式时，计算规则为CompileThreshold*(OnStackReplacePercentage/100)，在server 模式时，计算规则为(CompileThreshold(OnStackReplacePercentage - interpreterProflePercentage)/100。

InterpreterProflePercentage 的默认值为33，当方法上的回边计数器到达这个值时，即触发后台的OSR编译，并将方法上累积的调用计数器设置为CompileThreshold 的值，同时将回边计数器设置为CompileThreshold/2的值，一方面是为了避免OSR 编译频繁触发;另一方面是以便当方法被再次调用时即触发正常的编译，当累积的回边计数器的值再次达到该值时，先检查OSR编译是否完成。如果OSR编译完成，则在执行循环体的代码时进入编译后的代码:如果OSR编译未完成，则继续把当前回边计数器的累积值再减掉一些，从这些描述可看出，默认情况下对于回边的情况，server 模式下只要回边次数达到10700次，就会触发 OSR编译。用以下一段示例代码来模拟编译的触发。

以上代码采用java-server 方式执行，当main 中第一次调用f0o.bar 时，bar 方法上的调用计数器为1，回边计数器为0:当bar 方法中的循环执行完毕时，bar 方法的调用计数器仍然为1，回边计数器则为 10700，达到触发 OSR编译的条件，于是触发 OSR 编译，并将 bar 方法的调用计数器设置为 10 000,回边计数器设置为5000。

当 main 中第二次调用 foo.bar 时，jdk 发现 bar 方法的调用次数已超过 compileThreshold，于是在后台执行 JT 编译，并继续解释执行// some bar code,进入循环时，先检査 OSR 编译是否完成。如果完成则执行编译后的代码，如果未编译完成，则继续解释执行。

当 main 中第三次调用 f0o.bar 时，如果此时 JT 编译已完成，则进入编译后的代码:如果编译未完成，则继续按照上面所说的方式执行。

由于Sun JDK的这个特性，在对Java代码进行性能测试时，要尤其注意是否事先做了足够次数的调用，以保证测试是公平的;对于高性能的程序而言，也应考虑在程序提供给用户访问前，自行进行一定的调用，以保证关键功能的性能。

#### 反射执行

反射执行是Java的亮点之一，基于反射可动态调用某对象实例中对应的方法、访问查看对象的属性等，无需在编写代码时就确定要创建的对象。这使得Java可以很灵活地实现对象的调用，例如 MVC框架中通常要调用实现类中的 execute 方法，但框架在编写时是无法知道实现类的。在 Java 中则可以通过反射机制直接去调用应用实现类中的execute 方法，代码示例如下:

Class actionClass-Class.forName(外部实现类)
Method method=actionClass.getMethod("execute”,nul1);
Obiect aetion=actionClass.newInstance();
method.invoke(action，nul1)

这种方式对于框架之类的代码而言非常重要，反射和直接创建对象实例，调用方法的最大不同在于创建的过程、方法调用的过程是动态的。这也使得采用反射生成执行方法调用的代码并不像直接调用实例对象代码，编译后就可直接生成对对象方法调用的字节码，而是只能生成调用IVM反射实现的字节码了。

要实现动态的调用，最直接的方法就是动态生成字节码，并加载到JVM中执行，SunJDK采用的即为这种方法，来看看在 Sun JDK 中以上反射代码的关键执行过程。

Class actionClass=Class.forName(外部实现美):

调用本地方法，使用调用者所在的 ClassLoader 来加载创建出的Class 对象:

校验Class是否为public 类型，以确定类的执行权限，如不是public 类型的，则直接抛出SecurityException.

调用 privateGetDeclaredMethods来获取 Class 中的所有方法,在privateGetDeclaredMethods 对 Class 中所有方法集合做了缓存，第一次会调用本地方法去获取。
扫描方法集合列表中是否有相同方法名及参数类型的方法，如果有，则复制生成一个新的Method对象返回;如果没有，则继续扫描父类、父接口中是否有该方法;如果仍然没找到方法，则抛出NoSuchMethodException，代码如下:
0bject action=actionClass.newInstance()
校验 Class是否为public 类型，如果权限不足，则直接抛出 SecurityException。
如果没有缓存的构造器对象，则调用本地方法获取构造器，并复制生成一个新的构造器对象，放入缓存;如果没有空构造器，则抛出InstantiationException。
校验构造器对象的权限。
执行构造器对象的 newlnstance 方法。
判断构造器对象的 ncwInstance方法是否有缓存的ConstructorAccessor对象，如果没有，则调用sun.reflect.ReflectionFactory生成新的ConstructorAccessor对象。
判断 sun,reflect.RefectionFactory是否需要调用本地代码，可通过 sun.refect.nolnflation=true 来设置为不调用本地代码。在不调用本地代码的情况下，可转交给MethodAccessorGenerator 米处理。本地代码调用的情况在此不进行阐述。

MethodAccessorGenerator中的generate 方法根据 Java Class 格式规范生成字节码，字节码中包括ConstructorAccessor 对象需要的 newInstance方法。该newInstance 方法对应的指令为invokespecial，所需参数则从外部压入，生成的Constructor类的名字以sunreflect/ GeneratedSerializationConstructorAccessoi或 sun/reflect/GeneratedConstructorAccessor 开头，后面跟随一个累计创建对象的次数。

在生成字节码后将其加载到当前的Classloader中，并实例化，完成ConstnuctorAccessor 对象的创建过程，并将此对象放入构造器对象的缓存中。

执行获取的 constructorAccessor.newlnstance，这步和标准的方法调用没有任何区别。

method.invoke(action，null);

这步的执行过程和上一步基本类似，只是在生成字节码时方法改为了invoke，其调用目标改为了传入对象的方法，同时类名改为了:sun/reflect/GeneratedMethodAccessor。

综上所述，执行一段反射执行的代码后，在 debug里査看 Method对象中的 MethodAccessor 对象引用(参数为-Dsun.refect.nolnfation=tnue，否则要默认执行 15 次反射调用后才能动态生成字节码)，如图3.6 所示:

SunJDK 采用以上方式提供反射的实现，提升代码编写的灵活性，但也可以看出，其整个过程比直接编译成字节码的调用复杂很多，因此性能比直接执行的慢一些。SunJDK中反射执行的性能会随着JDK版本的提升越来越好，到JDK6后差距就不大了，但要注意的是，getMethod相对比较耗性能，一方面是权限的校验，另一方面是所有方法的扫描及Method对象的复制，因此在使用反射调用多的系统中应缓存 getMethod 返回的 Method 对象，而 method.invoke 的性能则仅比直接调用低一点。一段对比直接执行、反射执行性能的程序如下所示:

执行后显示的性能如下(执行环境:Intel Duo CPU E8400 3G windows 7,Sun JDK 1.6.0 18，启动参数为-server-Xms128M-Xmx128M):
直接调用消耗的时间为5毫秒:

不缓存 Method，反射调用消耗的时间为11毫秒:

缓存 Method，反射调用消耗的时间为6毫秒。在启动参数上增加-Xint米禁止JIT编译，执行上面代码，结果为:

直接调用消耗的时间为133秒:

不缓存 Method，反射调用消耗的时间为215 毫秒:

缓存 Method，反射调用消耗的时间为150毫秒。对比这段测试结果也可看出，C2编译后代码的执行速度得到了大幅提升


## JVM 内存管理

Java 不需要开发人员来显式分配内存和回收内存，而是由JVM来自动管理内存的分配及回收（称为垃圾回收、Garbage Collection或GC），这对开发人员来说确实大大降低了编写程序的难度，但副作用可能是在不知不觉中浪费了很多内存，导致 JVM 花费很多时间进行内存的回收。另外还可能会带来的副作用是由于不清楚 JVM 内存的分配和回收机制，造成内存泄露，最终导致 JVM 内存不够用。因此对于 Java 开发人员而言，不能因为JVM 自动内存管理就不掌握内存分配和回收的知识了。除了内存的分配及回收外，还须掌握跟踪分析 JVM 内存的使用状况，以便更加准确地判断程序的运行状况及进行性能的调优。

### 内存空间

SunJDK 在实现时遵照 JVM 规范，将内存空间划分为方法区、堆、本地方法栈、PC寄存器及 JVM方法栈，如图3.7所示。

#### 方法区

方法区存放了要加载的类的信息(名称、修饰符等)、类中的静态变量、类中定义为 final 类型的常量、类中的 Field 信息、类中的方法信息，当开发人员在程序中通过 Class对象的 getName、isInterface等方法来获取信息时，这些数据都来源于方法区域。方法区域也是全局共享的，在一定条件下它也会被 GC，当方法区域要使用的内存超过其允许的大小时，会抛出OutOfMemory的错误信息。

在 Sun JDK 中这块区域对应 Permanet Generation，又称为持久代，默认最小值为16MB，最大值为64MB，可通过-XX:PermSize 及-XX:MaxPermSize 米指定最小值和最大值。

#### 堆

堆用于存储对象实例及数组值,可以认为Java 中所有通过 new 创建的对象的内存都在此分配,Heap中对象所占用的内存由GC进行回收，在32位操作系统上最大为2GB，在64位操作系统上则没有限制，其大小可通过-Xms和-Xmx 来控制，-Xms为JVM 启动时申请的最小 Heap内存，默认为物理内存的 1/64但小于1GB;-Xmx为JVM 可申请的最大 Heap 内存，默认为物理内存的1/4但小于 1GB，默认当空余堆内存小于 40%时，JVM 会增大 Heap 到-Xmx 指定的大小，可通过-XX:MinHeapFreeRatio

来指定这个比例:当空余堆内存大于70%时，JVM 会减小Hcap的大小到-Xms 指定的大小，可通过-XX:MaxHeapFreeRatio=来指定这个比例,对于运行系统而言，为避免在运行时频繁调整 Heap 的大小通常将-Xms 和-Xmx的值设成一样。

为了让内存回收更加高效，SunJDK从12开始对堆采用了分代管理的方式，如图3.8所示。

**1. 新生代(New Generation)**

大多数情况下 Java 程序中新建的对象都从新生代分配内存，新生代由Eden Space 和两块相同大小的 Survivor Space(通常又称为S0和Sl或From 和 To)构成，可通过-Xmn 参数来指定新生代的大小，也可通过-XX:SurvivorRatio来调整 Eden Space及 Survivor Space 的大小。不同的 GC方式会以不同的方式按此值来划分 EdenSpace和 SurvivorSpace，有些GC方式还会根据运行状况来动态调整 Eden、S0、S1的大小。

**2.旧生代(Old Generation 或 Tenuring Generation )**

用于存放新生代中经过多次垃圾回收仍然存活的对象，例如缓存对象，新建的对象也有可能在旧生代上直接分配内存。主要有两种状况(由不同的GC实现来决定):一种为大对象，可通过在启动参数上设置-XX:PretenureSizeThreshold=1024(单位为字节，默认值为0)来代表当对象超过多大时就不在新生代分配，而是真接在旧生代分配，此参数在新生代采用ParalelScavengeGC时无效，ParalleScavengeGC会根据运行状况决定什么对象直接在旧生代上分配内存;另一种为大的数组对象，且数组中无引用外部对象。

旧生代所占用的内存大小为-Xmx对应的值减去-Xmn对应的值。

#### 本地方法栈

本地方法栈用于支持 native方法的执行，存储了每个 native方法调用的状态，在 Sun JDK 的实现中本地方法栈和 JVM 方法栈是同一个。

#### PC 寄存器和 JVM 方法栈

每个线程均会创建PC寄存器和JVM方法栈，PC寄存器占用的可能为CPU寄存器或操作系统内存，IVM 方法栈占用的为操作系统内存，JVM方法栈为线程私有，其在内存分配上非常高效。当方法运行完毕时，其对应的栈帧所占用的内存也会自动释放。

当JVM 方法栈空间不足时，会抛出 StackOver0owError 的错误，在 Sun JDK 中可以通过-Xss 米指定其大小，例如如下代码:

### 内存分配

Java 对象所占用的内存主要从堆上进行分配，堆是所有线程共享的，因此在堆上分配内存时需要进行加锁，这导致了创建对象开销比较大。当堆上空间不足时，会触发GC，如果GC后空间仍然不足，则抛出 OutOfMemory 错误信息。

Sun JDK为了提升内存分配的效率，会为每个新创建的线程在新生代的Eden Space 上分配一块独立的空间，这块空间称为TLAB(Thread Local Allocation Bufer)，其大小由JVM 根据运行情况计算而得，可通过-XX:TLABWasteTargetPercent来设置TLAB 可占用的 Eden Space 的百分比，默认值为 1%。JVM 将根据这个比率、线程数量及线程是否频繁分配对象来给每个线程分配合适大小的TLAB 空间"在 TLAB 上分配内存时不需要加锁，因此JVM 在给线程中的对象分配内存时会尽量在 TLAB 上分配,如果对象过大或 TLAB 空间已用完，则仍然在堆上进行分配。因此在编写Java 程序时，通常多个小的对象比大的对象分配起来更加高效，可通过在启动参数上增加-XX:+PrintTLAB来查看TLAB 空间的使用情况'9。

在分配细节上取决于GC的实现，后续GC的实现章节会继续介绍，除了从堆上分配及从 TLAB 上分配外，还有一种是基于逃逸分析直接在栈上进行分配的方式，此方式已在前文中提及。

### 内存回收

#### 收集器

JVM 通过 GC来回收堆和方法区中的内存，GC的基本原理首先会找到程序中不再被使用的对象，然后回收这些对象所占用的内存，通常采用收集器的方式实现GC，主要的收集器有引用计数收集器和跟踪收集器。

1. 引用计数收集器

引用计数收集器采用的为分散式的管理方式，通过计数器记录对象是否被引用。当计数器为零时，说明此对象已经不再被使用，于是可进行回收，如图3.9 所示。

在图3.9中，当ObjectA释放了对ObjectB的引用后，ObjectB的引用计数器即为0，此时可回收ObjectB 所占用的内存。

引用计数需要在每次对象赋值时进行引用计数器的增减，它有一定的消耗。另外，引用计数器对于循环引用的场景没有办法实现回收，例如上面的例子中，如果ObjectB和ObjectC互相引用，那么即使 ObjectA 释放了对 ObjectB、ObjectC 的引用，也无法回收 ObjectB、ObjectC，因此对于 Java 这种面向对象的会形成复杂引用关系的语言而言，引用计数收集器不是非常适合，SuJDK在实现GC时也未采用这种方式。

2. 跟踪收集器

跟踪收集器采用的为集中式的管理方式，全局记录数据的引用状态。基于一定条件的触发(例如定时、空间不足时)，执行时需要从根集合来扫描对象的引用关系，这可能会造成应用程序暂停，主要有复制(Copying)、标记-清除(Mark-Sweep)和标记-压缩(Mark-Compact)三种实现算法。

复制(Copying)

复制采用的方式为从根集合扫描出存活的对象，并将找到的存活对象复制到一块新的完全未使用的空间中，如图 3.10所示。

复制收集器方式仅需从根集合扫描所有存活的对象，当要回收的空间中存活对象较少时，复制算法会比较高效，其带来的成本是要增加一块空的内存空间及进行对象的移动。

标记-清除(Mark-Sweep)

标记-清除采用的方式为从根集合开始扫描，对存活的对象进行标记，标记完毕后，再扫描整个空间中未标记的对象，并进行回收，如图 3.11所示。

标记-清除动作不需要进行对象的移动，且仅对其不存活的对象进行处理。在空间中存活对象较多的情况下较为高效，但由于标记-清除采用的为直接回收不存活对象所占用的内存，因此会造成内存碎片。

标记-压缩(Mark-Compact)

标记-压缩采用和标记-清除一样的方式对存活的对象进行标记，但在清除时则不同。在回收不存活对象所占用的内存空间后，会将其他所有存活对象都往左端空闲的空间进行移动，并更新引用其对象的指针，如图 3.12所示。

标记-压缩在标记-清除的基础上还须进行对象的移动，成本相对更高，好处则是不产生内存碎片。

#### Sun JDK 中可用的 GC

以上三种跟踪收集器各有优缺点，Sun JDK根据运行的Java程序进行分析，认为程序中大部分对象的存活时间都是较短的，少部分对象是长期存活的。基于这个分析，SunJDK将IVM堆划分为了新生代和旧生代，并基于新生代和旧生代中对象存活时间的特征提供了不同的GC实现，如图3.13 所示

新生代可用 GC

SunJDK 认为新生代中的对象通常存活时间较短,因此选择了基于Copying 算法来实现对新生代对象的回收，根据以上 Copying 算法的介绍，在执行复制时，需要一块未使用的空间来存放存活的对象这是新生代又被划分为Eden、S0和S1三块空间的原因。EdenSpace存放新创建的对象，S0或S1的其中一块用于在 Minor GC 触发时作为复制的目标空间，当其中一块为复制的目标空间时，另一块中的内容则会被清空。因此通常又将S0、S1称为From Space和ToSpace，SunJDK提供了串行 GC、并行回收GC和并行 GC三种方式来回收新生代对象所占用的内存，对新生代对象所占用的内存进行的GC又通常称为 Minor GC。

1.串行 GC(Serial GC)

当采用串行GC 时，SurvivorRatio的值对应 cden space/survivor space，SurvivorRatio 默认为8，例如当-Xmn 设置为10MB时，采用串行GC，edenspace即为8MB，两个survivor space各 IMB。新生代分配内存采用的为空闲指针(bump-the-pointer)的方式，指针保持最后一个分配的对象在新生代内存区间的位置，当有新的对象要分配内存时，只须检查剩余的空间是否够存放新的对象，够则更新指针，并创建对象，不够则触发 MinorGC。
按照 Copying 算法，GC首先需要从根集合扫描出存活的对象，对于Minor GC而言，其目标为扫描出在新生代中存活的对象。SunJDK认为以下对象为根集合对象:当前运行线程的栈上引用的对象、常量及静态(static)变量、传到本地方法中，还没有被本地方法释放的对象引用。

如果 Minor GC仅从以上这些根集合对象中扫描新生代中的存活对象，则当旧生代中的对象引用了新生代的对象时会出现问题，但旧生代通常比较大。为提高性能，不可能每次MinorGC的时候去扫描整个旧生代，SunJDK采用了rememberset 的方式来解决这个问题。

Sun JDK在进行对象赋值时，如果发现赋值的为一个对象引用，则产生 write barrier，然后检查需要赋值的对象是否在旧生代及赋值的对象引用是否指向新生代:如果满足条件，则在rememberset 做个标记，SunJDK采用了CardTable来实现remember set。

因此，对于 Minor GC而言，完整的根集合为SunJDK认为的根集合对象加上remember set 中标记的对象，在确认根集合对象后，即可进行扫描来寻找存活的对象。为了避免在扫描过程中引用关系变化,Sun JDK采用了暂停应用的方式,SunJDK在编译代码时为每段方法注入了SafePoint,通常 SafePoint位于方法中循环的结束点及方法执行完毕的点，在暂停应用时需要等待所有的用户线程进入SafcPoint,在用户线程进入 SafePoint后，如果发现此时要执行MinorGC，则将其内存页设置为不可读的状态，从而实现暂停用户线程的执行。

在对象引用关系上，除了默认的强引用外，SunJDK还提供了软引用(SoReference)、弱引用(WeakReference)和虚引用(PhantomReference)三种引用



### JVM 内存状况查看方法和分析工具

## 线程资源同步及交互机制

Java 程序采用多线程的方式来支撑大量的并发请求处理，程序在多线程方式执行的情况下，复杂程度远高于单线程串行执行的程序。尤其是在多核或多 CPU 系统中，多线程执行的程序所带来的最明显的问题是线程之间共同管理的资源的竞争及线程之间的交互。JVM 的线程实现及调度方式(抢占式、协作式)取决于操作系统，超出了本书范围，本节中仅介绍 JVM 线程资源同步机制和线程之间的交互机制。

### 线程资源同步机制


### 线程交互机制

线程之间除了会产生资源的竞争外，还会有交互的需求。例如最典型的连接池，连接池中通常都会有 get 和retum 两个方法，retum 的时候需要将连接返回到缓存列表中，并将可使用的连接数加 1,而 get 方法在判断可使用的连接数已经到了0后，需要进入一个等待状态，当有连接返回到连接池时，应该通知下 get 方法，不需要再等待了，如果没有这个交互机制，就只能在 get 方法中不断轮循判断可使用的连接数的值了。JVM 提供waitnotify/notifyAIl方式来支持这类需求，在基于Object的waitnotify/notifyA1l 实现连接池时，典型的代码如下：

调用 Object 的 wait 方法可以让当前线程进入等待状态,只有当其他线程调用了此 Object的 notify、或 notiyAI 方法，或者 wait(亳秒数)到达了指定的时间后，才会被激活继续执行，notify 只是随机找wait 此 Object的一个线程,而 notify A! 则是通知 wait 此Object的所有线程。在 SunJDK中，object.wait还有可能被假唤醒，因此通过在 object.wait 被唤醒后，应再次确认需要等待的状态是否变更了。如果未变更，则继续进入 wait 状态，这种做法通称为double check，一段示例代码如下:

当线程调用了对象的 wait 方法后，JVM 线程执行引擎会将此线程放入一个 wait sets 中，并释放此对象的锁，在wait sets中的线程将不会被 JVM 线程执行引擎调度执行;当其他线程调用了此对象的notify 方法时,会从 wait sets 中随机找一个等待在此对象上的线程,并将其从 wait sets 中删除,这样JVM线程执行引擎就可以再次调度执行此线程了:当调用的为notifyA1l方法时，则会删除 wait sets 上所有等待在此对象上的线程，删除完毕后释放对象锁。

在Sun JDK 5.0的版本中，增加了并发包，其中提供了更多的方式来支持线程间的交互，例如Semphore 的 acquire 和 release、 Condition 的await 和 signal、 CountDownLatch 的await 和 countDown 等。

### 线程状态及分析

JVM 把线程分为几种不同的状态，并根据状态放入不同的sets中来进行调度。线程在创建完毕后进入 new 状态，调用了线程的 stant 方法后线程进入 Runnable 状态，放入JVM 的可运行线程队列中等待获取 CPU的执行权:JVM 按线程优先级及时间分片、轮循的方式来执行 Runnable 状态的线程。当线程进入 stan 代码段,开始执行时,其线程状态转变为 Running;线程在执行过程中如果执行了 sleepwait、ioin，或者进入了 I0 阻寒、锁等待时，则进入 Wait或 Blocked 状态，在这种状况下线程放弃 CPU的使用权，进入 wait sets 或锁 sets 中，直到 wait 结束、线程被唤醒或获取到锁，在这些情况下线程也再次进入 Runnable状态;在线程执行完毕后，线程就从可运行线程队列中删除了，JVM 线程的状态转变如图 3.24 所示。