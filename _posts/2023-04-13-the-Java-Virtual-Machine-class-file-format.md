---
title: 类文件结构
date: 2023-04-13 21:09:00 +0800
author: 
categories: [JVM]
tags: [JVM]
pin: false
math: false
mermaid: false
---

Owner: better

This chapter describes the class file format of the Java Virtual Machine. <https://docs.oracle.com/javase/specs/jvms/se8/html/jvms-4.html>

## 什么是类文件？

与平台无关，与语言无关，统一程序存储格式——字节码 Byte Code，仅仅与 Class文件 这种特定的二进制文件格式所关联。

## Class 类文件的结构

```console
ClassFile {
    u4             magic;
    u2             minor_version;
    u2             major_version;
    u2             constant_pool_count;
    cp_info        constant_pool[constant_pool_count-1];
    u2             access_flags;
    u2             this_class;
    u2             super_class;
    u2             interfaces_count;
    u2             interfaces[interfaces_count];
    u2             fields_count;
    field_info     fields[fields_count];
    u2             methods_count;
    method_info    methods[methods_count];
    u2             attributes_count;
    attribute_info attributes[attributes_count];
}
```

![这张表由表6-1所示的数据项按严格顺序排列构成。](ch6%20%E7%B1%BB%E6%96%87%E4%BB%B6%E7%BB%93%E6%9E%84%200e3ae0a321dd497eb7a55638567afdff/Untitled.png)

这张表由表6-1所示的数据项按严格顺序排列构成。

- Class 文件是一组以**8个字节为基础单位的⼆进制流**
    
    各个数据项⽬严格按照顺序紧凑地排列在⽂件之中，中间没有添加任何分隔符，这使得整个Class⽂件中存储的内容⼏乎全部是程序运⾏的必要数据，没有空隙存在。当遇到需要占⽤8个字节以上空间的数据项时，则会按照⾼位在前的⽅式分割成若⼲个8个字节进⾏存储。
    
- Class 文件格式采用一种类似与C语言结构体的伪结构来存储数据，伪结构中只有两种数据类型 1 无符号数 2 表
    1. 无符号数：为基本类型，以u1、u2、u4、u8来分别代表表1个字节、2个字节、4个字节和8个字节的⽆符号数，⽆符号数可以⽤来描述数字、索引引⽤、数量值或者按照UTF-8编码构成字符串值。
    2. 表：是由多个无符号数或者其他表作为数据项构成的符合数据类型，习惯性的以”_info”结尾。表用于描述有层次关系的符合结构的数据，整个Class文件本质上也可以视作是一张表。

## 魔数与Class文件的版本

- 每个Class⽂件的头4个字节被称为魔数(Magic Number)，它的唯⼀作⽤是确定这个⽂件是否为⼀个能被虚拟机接受的Class⽂件。值为0xCAFEBABE ( 咖啡宝⻉ ? ) 。
- 紧接着魔数的4个字节存储的是Class⽂件的版本号: 第5和第6个字节是次版本号(Minor Version)，第7和第8个字节是主版本号(Major Version)。

注意：⾼版本的JDK能向下兼容以前版本的Class⽂件，但不能运⾏以后版本的Class⽂件

## 常量池

紧接着主、次版本号之后的是常量池⼊⼝，常量池可以⽐喻为Class⽂件⾥的资源仓库，它是Class⽂件结构中与其他项⽬关联最多的数据，通常也是占⽤Class⽂件空间最⼤的数据项⽬之⼀，另外，它还是在Class⽂件中第⼀个出现的表类型数据项⽬。

常量池中主要存放两⼤类常量: 字⾯量(Literal)和符号引⽤(Symbolic References)。字⾯量⽐较接近于Java语⾔层⾯的常量概念，如⽂本字符串、被声明为final的常量值等。⽽符号引⽤则属于编译原理⽅⾯的概念，主要包括下⾯⼏类常量

1. 被模块导出或者开放的包 Package
2. 类和接口的全限定名 Fully Qualified Name
3. 字段的名称和描述符 Descriptor
4. 方法的名称和描述符
5. 方法句柄和方法类型 Method Handle、Method Type、Invoke Dynamic
6. 动态调用点和动态常量 Dynamically-Computed Call Site、Dynamically-Computed Constant

**Q 字面量是啥？**

Ans ***字面量***是指由字母，数字等构成的字符串或者数值，它只能作为右值出现,(右值是指等号右边的值，如：int a=123这里的a为左值，123为右值。) from Baidu

**Q 符号引用又是啥？**

Ans 编译时实际上不知道实际要访问的内存地址是什么，所有用符号引用来代替

> 符号引用（Symbolic References）：符号引用以一组符号来描述所引用的目标，符号可以是任何形式的字面量，只要使用时能够无歧义的定位到目标即可。例如，在Class文件中它以CONSTANT_Class_info、CONSTANT_Fieldref_info、CONSTANT_Methodref_info等类型的常量出现。符号引用与虚拟机的内存布局无关，引用的目标并不一定加载到内存中。在[Java](https://lib.csdn.net/base/javaee)中，一个java类将会编译成一个class文件。**在编译时，java类并不知道所引用的类的实际地址，因此只能使用符号引用来代替。**比如org.simple.People类引用了org.simple.Language类，在编译时People类并不知道Language类的实际内存地址，因此只能使用符号org.simple.Language（假设是这个，当然实际中是由类似于CONSTANT_Class_info的常量来表示的）来表示Language类的地址。各种虚拟机实现的内存布局可能有所不同，但是它们能接受的符号引用都是一致的，因为符号引用的字面量形式明确定义在Java虚拟机规范的Class文件格式中。
> 

所以运行时常量池里面装的东西到底是啥——符号引用和字面量

当虚拟机做类加载时，将会从常量池获得对应的符号引⽤，再在类创建时或运⾏时解析、翻译到
具体的内存地址之中。

## 访问标志

在常量池结束之后，紧接着的2个字节代表访问标志(access_flags)，这个标志⽤于**识别⼀些类或者接⼝层次的访问信息**，包括：

1. 这个Class是类还是接⼝; 是否定义为public类型；
2. 是否定义为abstract类型；
3. 如果是类的话，是否被声明为final；

等等。

* **Table** Class access and property modifiers

| Flag Name      | Value | Interpretation                                                |
|----------------|-------|---------------------------------------------------------------|
| ACC_PUBLIC     | 0x0001| Declared public; may be accessed from outside its package.    |
| ACC_FINAL      | 0x0010| Declared final; no subclasses allowed.                        |
| ACC_SUPER      | 0x0020| Treat superclass methods specially when invoked by the invokespecial instruction. |
| ACC_INTERFACE  | 0x0200| Is an interface, not a class.                                 |
| ACC_ABSTRACT   | 0x0400| Declared abstract; must not be instantiated.                  |
| ACC_SYNTHETIC  | 0x1000| Declared synthetic; not present in the source code.           |
| ACC_ANNOTATION | 0x2000| Declared as an annotation type.                               |
| ACC_ENUM       | 0x4000| Declared as an enum type.                                     |
| ACC_MODULE     | 0x8000| Is a module, not a class or interface.                        |

access_flags 中一共有 16 个标志位可以使用，当前只定义了其中 9 个，没有使用到的标志位要求一律为零。

## The Java Virtual Machine Instruction Set

The Java Virtual Machine Instruction Set <https://docs.oracle.com/javase/specs/jvms/se8/html/jvms-6.html>