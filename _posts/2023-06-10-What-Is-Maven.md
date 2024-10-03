---
title: Maven项目依赖管理
date: 2023-06-10 12:59:00 +0800
author: 
categories: [Maven]
tags: [Maven]
pin: false
math: true
mermaid: false
---

Maven Central Repository

1. <https://central.sonatype.com/>
2. <https://mvnrepository.com/>

## **一、** Maven概述

### 1.1 为什么要使用Maven

1. 不需要开发人员到处下载或寻找jar包![](/assets/images/MavenImages/why-mvn0.jpg)
2. jar包版本冲突和依赖的问题轻松解决
3. 节省开发人员在编译、打包、部署、测试上的时间消耗

![](/assets/images/MavenImages/why-mvn1.jpg)



![](/assets/images/MavenImages/why-mvn2.jpg)



![](/assets/images/MavenImages/why-mvn3.jpg)

### 1.2 什么是Maven

![](/assets/images/MavenImages/ant-logo.gif)

目前无论使用IDEA还是Eclipse等其他IDE，使用里面ANT工具。ANT工具帮助我们进行编译，打包运行等工作。

Apache基于ANT进行了升级，研发出了全新的自动化构建工具Maven。（ANT有的功能MAVEN都有，只是使用起来更加方便了）。

Maven工具基于POM（Project Object Model，项目对象模型）模式实现的。在Maven中每个项目都相当于是一个对象，对象（项目）和对象（项目）之间是有关系的。关系包含了：依赖、继承、聚合，实现Maven项目可以更加方便的实现导jar包、拆分项目等效果。

Maven 是跨平台的，这意味着无论是在 Windows 上，还是在 Linux 或者 Mac 上，都可以使用同样的命令。

Maven 还有一个优点，它能帮助我们标准化构建过程。在 Maven 之前，十个项目可能有十种构建方式。有了 Maven 之后，所有项目的构建命令都是标准化。

Maven 还为全世界的 Java 开发者提供了一个免费的中央仓库，在其中几乎可以找到任何的流行开源类库。

### 1.3 Maven的作用

1. Maven 统一集中管理好所有的依赖包，不需要程序员再去寻找。对应第三方组件用到的共同 jar，Maven 自动解决重复和冲突问题。
2. Maven 可以统一每个项目的构建过程，实现不同项目的兼容性管理。

3. Maven 作为一个开放的架构，提供了公共接口，方便同第三方插件集成。程序员可以将自己需要的插件，动态地集成到 Maven，从而扩展新的管理功能。

### 1.4 Maven工程类型

1. POM工程
 POM工程是逻辑工程。用在聚合工程中，或者父级工程用来做jar包的版本控制。
2. JAR工程
 创建一个 Java Project，在打包时会将项目打成jar包。
3. WAR工程
 创建一个Web Project，在打包时会将项目打成war包。

## 二、Maven下载安装及与IDEA的整合

### 2.1 Maven下载安装

1. 检查JDK的环境变量（Maven是java语言开发的需要JDK的支持）

  ```sh
  C:\Users\Administrator>echo %JAVA_HOME%
  D:\devsoft\Java\jdk1.8.0_161
  C:\Users\Administrator>echo %PATH%
  D:\devsoft\Java\jdk1.8.0_161\bin;D:\devsoft\Java\jdk1.8.0_161\jre\bin;
  ```

2. 下载 Maven  https://maven.apache.org/download.cgi

3. 下载后解压到D:\devsoft\目录下（目录中最好不要出现中文和空格）。

4. 配置Maven的环境变量

	```
	变量名：MAVEN_HOME
	变量值：D:\devsoft\apache-maven-3.8.2
	
	变量path中添加 %MAVEN_HOME%\bin
	```

5. 检查Maven是否安装正确

```shell
C:\Users\Administrator>mvn -v
Apache Maven 3.8.2 (ea98e05a04480131370aa0c110b8c54cf726c06f)
Maven home: D:\devsoft\apache-maven-3.8.2
Java version: 1.8.0_161, vendor: Oracle Corporation, runtime: D:\devsoft\Java\jdk1.8.0_161\jre
Default locale: zh_CN, platform encoding: GBK
OS name: "windows 10", version: "10.0", arch: "amd64", family: "windows"
```

```shell
➜  ~ mvn -v
Apache Maven 3.6.3
Maven home: /usr/share/maven
Java version: 17.0.12, vendor: Ubuntu, runtime: /usr/lib/jvm/java-17-openjdk-amd64
Default locale: zh_CN, platform encoding: UTF-8
OS name: "linux", version: "5.15.153.1-microsoft-standard-wsl2", arch: "amd64", family: "unix"
```

### 2.2 IDEA整合Maven

#### 2.2.1 IDEA下载安装和破解

IDEA下载：https://www.jetbrains.com/idea/download/#section=windows

**注意安装时将老版本先卸载掉。**

双击安装-> 一直 下一步->安装完后启动->使用30天->随便创建一个java项目->将破解包ide-eval-resetter-2.1.14.zip拖入到IDEA界面上->重启IDEA

#### 2.2.2 IDEA整合Maven

在Idea中默认已经整合了Maven。由于Idea的版本不同，所整合的Maven的版本也不同。

如果需要更换其他版本可在Idea中进行配置。

![img](/assets/images/MavenImages/wps1.jpg)

## 三、Maven仓库与配置

### 3.1 Maven仓库是什么

Maven仓库是基于简单文件系统存储的，集中化管理Java API资源（构件）的一个服务。仓库中的任何一个构件都有其唯一的坐标，根据这个坐标可以定义其在仓库中的唯一存储路径，这要得益于 Maven 的[坐标机制](https://tangyanbo.iteye.com/blog/1503946)，任何 Maven项目使用任何一个构件的方式都是完全相同的，Maven 可以在某个位置统一存储所有的 Maven 项目共享的构件，这个统一的位置就是仓库，项目构建完毕后生成的构件也可以安装或者部署到仓库中，供其它项目使用。

坐标：坐标有三个部分构成，如果一个部分不同那么表示的就是不同的jar。

Group Id:   公司名，多用公司网址倒写 比如：com.github

Artifact Id:  项目名 b比如：mavenDemo

Version:    版本 

```xml
<!-- https://mvnrepository.com/artifact/org.apache.zookeeper/zookeeper -->
<dependency>
    <groupId>org.apache.zookeeper</groupId>
    <artifactId>zookeeper</artifactId>
    <version>3.7.0</version>
</dependency>
```

对于Maven来说，仓库分为两类：本地仓库和中央仓库。

#### 3.1.1 中央仓库

中央仓库是互联网上的服务器,是Maven提供的最大的仓库，里面拥有最全的jar包资源。默认是Maven自己的网络服务器，但是由于访问速度较慢，我们一般都配置成国内的镜像中央仓库如阿里镜像或者是华为镜像。

Maven中央仓库访问页面：https://mvnrepository.com/

阿里镜像：https://maven.aliyun.com

#### 3.1.2 本地仓库

本地仓库指用户电脑中的文件夹,该文件夹中包含了自己下载的构件(jar包)。文件夹结构为groupid分级的文件夹/artifactid文件夹/version文件夹/包含jar包。

D:\devsoft\mvnRepo382\com\itbaizhan\mavenDemo\1.0-SNAPSHOT

### 3.2 仓库的访问优先级

1. 本地仓库

	第一访问本地仓库。

2. 远程仓库-中央仓库

  中央仓库是Maven官方提供的远程仓库，在本地仓库无法获取资源的时候，直接访问中央仓库。并将中央仓库中的资源下载到本地仓库，这样下次在其它maven项目中使用该资源便可以从本地仓库中获取了。但是由于中央仓库在国外的服务器上，下载速度太慢了，所以工作中通常使用国内的镜像仓库。

  ![img](/assets/images/MavenImages/wps2.jpg)

3. 远程仓库-镜像仓库

	镜像仓库是Maven开发过程中的首选远程仓库，在本地仓库无法获取资源的时候，直接访问镜像仓库
	
	 ![](/assets/images/MavenImages/wps2-1.jpg)

 

### 3.3 配置Maven

在maven安装包的解压目录（D:\devsoft\apache-maven-3.8.2）下的conf/settings.xml文件中做以下配置：

#### 3.3.1 配置本地仓库

本地仓库是开发者本地电脑中的一个目录，用于存储从远程仓库下载的构件(jar包)。默认的本地仓库是${user.home}/.m2/repository。用户可使用settings.xml文件修改本地仓库。具体内容如下：

```xml
<!-- 配置本地仓库的地址 -->
<localRepository>D:\devsoft\mvnRepo382</localRepository>
```

#### 3.3.2 配置镜像仓库

如果仓库A可以提供仓库B存储的所有内容，那么就可以认为A是B的一个镜像。例如：在国内直接连接中央仓库下载依赖，由于一些特殊原因下载速度非常慢。这时，我们可以使用阿里云提供的镜像https://maven.aliyun.com/repository/public来替换中央仓库https://repol.maven.org/maven2/。修改maven的setting.xml文件，具体内容如下：

```xml
<mirror>
  <!-- 指定镜像ID -->	
  <id>aliyunmaven</id>
  <!-- 匹配镜像仓库。-->
  <mirrorOf>*</mirrorOf>
  <!-- 指定镜像名称 -->
  <name>阿里云公共仓库</name>
  <!-- 指定镜像路径 -->
  <url>https://maven.aliyun.com/repository/public</url>
</mirror>
```



#### 3.3.3 配置JDK

```xml
<profile>			
    <id>jdk-1.8</id>			
    <activation>				
        <activeByDefault>true</activeByDefault>				
        <jdk>1.8</jdk>			
    </activation>			
    <properties>			
        <maven.compiler.source>1.8</maven.compiler.source>					 
        <maven.compiler.target>1.8</maven.compiler.target>
        <maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion>			
    </properties>	
</profile>
```



### 3.4 IDEA整合Maven设置更新

![](/assets/images/MavenImages/idea-mvn.jpg)

破解版IDEA的Maven配置有时候会出现还原的情况，将D:\devsoft\apache-maven-3.8.2\conf\settings.xml复制一份，替换C:\Users\Administrator\.m2\settings.xml。

## 四、Maven项目创建和目录介绍

### 4.1 在IDEA中创建Maven工程

​![](/assets/images/MavenImages/wps3_1.jpg)

![img](/assets/images/MavenImages/wps3.jpg) 

![img](/assets/images/MavenImages/wps4.jpg) 

![img](/assets/images/MavenImages/wps5.jpg)        

![img](/assets/images/MavenImages/wps6.jpg)

### 4.2 Maven项目目录介绍

- src 包含了项目所有的源代码和资源文件以及测试代码。

- src/main/java 这个目录下储存java源代码

- src/main/resources 储存主要的资源文件。比如spring的xml配置文件和log4j的properties文件。

- src/test/java 存放测试代码，比如基于JUNIT的测试代码一般就放在这个目录下面

- target 编译后内容放置的文件夹


- pom.xml 是Maven的基础配置文件，也是Maven项目核心配置文件，用于配置项项目的基本信息，项目的继承关系，项目类型，依赖管理，依赖注入，插件管理，插件注入等等


> --mavenDemo 项目名
>
> ​     --.idea 项目的配置，自动生成的，不需要关注。 
>
> ​     --src  
>
> ​           -- main 实际开发内容   
>
> ​                       --java 写包和java代码，此文件默认只编译.java文件   
>
> ​                       --resource 所有配置文件。最终编译把配置文件放入到classpath中。  
>
> ​           -- test     
>
> ​                       --java 测试时使用，自己写测试类或junit工具等 
>
> ​        pom.xml 整个maven项目所有配置内容。

## 五、POM模型

### 5.1 依赖关系

Maven 一个核心的特性就是依赖管理。当我们处理多模块的项目（包含成百上千个模块或者子项目），模块间的依赖关系就变得非常复杂，管理也变得很困难。针对此种情形，Maven 提供了一种高度控制的方法。

通俗理解：依赖谁就是将谁的jar包添加到本项目中。可以依赖中央仓库的jar，也可以依赖当前开发中其他项目打包后的jar包。

在当前项目的pom.xml文件 根元素project下的 dependencies标签中，配置依赖信息，可以包含多个 dependence元素，以声明多个依赖。每个依赖dependence标签都应该包含以下元素：groupId, artifactId, version : 依赖的基本坐标， 对于任何一个依赖来说，基本坐标是最重要的， Maven根据坐标才能找到需要的依赖。

```xml
<dependencies>   
    <dependency>
        <groupId>org.apache.zookeeper</groupId>
        <artifactId>zookeeper</artifactId>
        <version>3.7.0</version>
    </dependency> 
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-context</artifactId>
        <version>5.2.4.RELEASE</version>
    </dependency>
</dependencies>
```

 

#### 5.1.1 依赖的传递性

依赖传递性是Maven2.0的新特性。假设你的项目依赖于一个jar包，而这个jar包又依赖于其他jar包。你不必自己去找出所有这些依赖，你只需要加上你直接依赖的jar包的坐标，Maven会隐式的把这些jar包间接依赖的库也加入到你的项目中。这个特性是靠解析从远程仓库中获取的依赖jar包的项目文件实现的。这些项目的所有依赖都会加入到项目中这就是依赖传递性。

如果A依赖了B，那么C依赖A时会自动把A和B都导入进来。比如：mavenDemo依赖了Zookeeper，Zookeeper又依赖netty，那么mavenDemo项目中导入Zookeeper之后，会将Zookeeper和netty相关jar包都导入进来。

![](/assets/images/MavenImages/zk-netty.jpg)

创建A项目后，选择IDEA最右侧Maven面板lifecycle，双击install后就会把项目安装到本地仓库中，其他项目就可以通过坐标引用此项目。

位置：D:\devsoft\mvnRepo382\com\itbaizhan\mavenDemo\1.0-SNAPSHOT\mavenDemo-1.0-SNAPSHOT.jar

#### 5.1.2 依赖相同资源的依赖原则

**第一原则：最短路径优先原则**

“最短路径优先”意味着项目依赖关系树中路径最短的版本会被使用。例如，假设A、B、C之间的依赖关系是A->B->C->D(2.0)和A->E->(D1.0)，那么D(1.0)会被使用，因为A通过E到D的路径更短。

![](/assets/images/MavenImages/ylyz1.jpg)

**第二原则：最先声明原则**

依赖调解第一原则不能解决所有问题，比如这样的依赖关系：A–>B–>Y(1.0)，A–>C–>Y(2.0)，Y(1.0)和Y(2.0)的依赖路径长度是一样的，都为2。那么到底谁会被解析使用呢？在maven2.0.8及之前的版本中，这是不确定的，但是maven2.0.9开始，为了尽可能避免构建的不确定性，maven定义了依赖调解的第二原则：第一声明者优先。在依赖路径长度相等的前提下，在POM中依赖声明的顺序决定了谁会被解析使用。顺序最靠前的那个依赖优胜。

![](/assets/images/MavenImages/ylyz2.jpg)

#### 4.1.3 排除依赖

exclusions： 用来排除传递性依赖 其中可配置多个exclusion标签，每个exclusion标签里面对应的有groupId, artifactId两项基本元素。

```xml
<dependency>   
    <groupId>org.springframework</groupId>   
    <artifactId>spring-context</artifactId>   
    <version>5.2.4.RELEASE</version>   
</dependency>
```

![](/assets/images/MavenImages/exclusions_no.jpg)

使用exclusions排除依赖spring-aop：

```xml
<dependency>   
    <groupId>org.springframework</groupId>   
    <artifactId>spring-context</artifactId>   
    <version>5.2.4.RELEASE</version>   
    <exclusions>     
        <exclusion>       
            <groupId>org.springframework</groupId>       
            <artifactId>spring-aop</artifactId>     
        </exclusion>   
    </exclusions> 
</dependency>
```

![](/assets/images/MavenImages/exclusions.jpg)

排除后依赖的spring-aop就不再出现了。

#### 4.1.4 依赖范围

```xml
<dependency>   
    <groupId>org.springframework</groupId>   
    <artifactId>spring-context</artifactId>   
    <version>5.2.4.RELEASE</version>   
    <scope>compile</scope>
</dependency>
```

scope属性可取值

1. compile

	​		这是默认范围。如果没有指定，就会使用该依赖范围。表示该依赖在编译和运行时生效。在项目打包时会将该依赖包含进去。

2. provided

	​		可以参与编译，测试，运行等周期，但是不会被打包到最终的artifact中。典型的例子是servlet-api，编译和测试项目的时候需要该依赖，但在项目打包的时候，由于容器已经提供，就不需要Maven重复地引入一遍(如：servlet-api)

3. runtime

	​		runtime范围表明编译时不需要生效，而只在运行时生效。典型的例子是JDBC驱动实现，项目主代码的编译只需要JDK提供的JDBC接口，只有在执行测试或者运行项目的时候才需要实现上述接口的具体JDBC驱动。

4. test

  test范围表明使用此依赖范围的依赖，只在编译测试代码和运行测试的时候需要，应用的正常运行不需要此类依赖。典型的例子就是JUnit，它只有在编译测试代码及运行测试的时候才需要。

  ```xml
  <dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>4.11</version>
    <scope>test</scope>
  </dependency>
  ```

  

5. system

  ​       如果有些你依赖的jar包没有Maven坐标的，它完全不在Maven体系中，这时候你可以把它下载到本地硬盘，然后通过system来引用。

  ​       <font color='red'>不推荐使用system，因为一个项目的pom.xml如果使用了scope为system的depend后，会导致传递依赖中断，即所有其他依赖本项目的项目都无法传递依赖了。</font>

  ![](/assets/images/MavenImages/scope.jpg)

  
  
  ​		


#### 5.1.5 依赖管理

Maven提供了一个机制来集中管理依赖信息，叫做依赖管理元素`<dependencyManagement>`。假设你有许多项目继承自同一个公有的父项目，那可以把所有依赖信息放在一个公共的POM文件中并且在子POM中简单的引用该构件即可。

```xml
<properties>
  <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
  <maven.compiler.source>1.8</maven.compiler.source>
  <maven.compiler.target>1.8</maven.compiler.target>
  <spring-context.version>5.2.4.RELEASE</spring-context.version>
</properties>
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-context</artifactId>
      <version>${spring-context.version}</version>
    </dependency>
  </dependencies>
</dependencyManagement>
```



### 5.2 继承关系

#### 5.2.1 什么是继承关系

Maven中的继承跟Java中的继承概念一样，需要有父项目以及子项目。我们可以将项目中的依赖和插件配置提取出来在父项目中集中定义，从而更方便的管理项目的依赖以及插件。注意父项目类型一定为POM类型。

创建maven项目parent（src目录可以删除）

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="https://maven.apache.org/POM/4.0.0"
         xmlns:xsi="https://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.itbaizhan</groupId>
    <artifactId>parent</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>pom</packaging>
    <properties>
        <spring-context.version>5.2.4.RELEASE</spring-context.version>
        <spring-web.version>5.2.4.RELEASE</spring-web.version>
    </properties>
    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework</groupId>
                <artifactId>spring-context</artifactId>
                <version>${spring-context.version}</version>
            </dependency>
            <dependency>
                <groupId>org.springframework</groupId>
                <artifactId>spring-web</artifactId>
                <version>${spring-web.version}</version>
            </dependency>
        </dependencies>
    </dependencyManagement>
</project>
```

创建子项目child

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="https://maven.apache.org/POM/4.0.0"
         xmlns:xsi="https://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>com.itbaizhan</groupId>
        <artifactId>parent</artifactId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <artifactId>child</artifactId>
    <version>1.0-SNAPSHOT</version>
    <dependencies>
        <!-- 按需引入 -->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context</artifactId>
        </dependency>
    </dependencies>
</project>
```



#### 5.2.2 继承的优点

1. 依赖或插件的统一管理（在parent中定义，需要变更dependency版本时，只需要修改一处）。

2. 代码简洁（子model只需要指定groupId，artifactId即可）。
3. dependencyManagement是“按需引入”，即子model不会继承parent中 dependencyManagement所有预定义的dependency。



### 5.3 Maven中的多继承

在Maven中对于继承采用的也是单一继承，也就是说一个子项目只能有一个父项目，但是有的时候我们项目可能需要从更多的项目中继承，那么我们可以在子项目中通过添加<dependencyManagement>标记来实现多继承。在子项目的<dependencyManagement>中每个<dependency>标记就一个父工程定义，同时还需要添加<type>标记，值为pom。添加<scope>标记，值为import。

parenta项目的pom.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="https://maven.apache.org/POM/4.0.0"
         xmlns:xsi="https://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.itbaizhan</groupId>
    <artifactId>parenta</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>pom</packaging>

    <properties>
        <spring-context.version>5.2.4.RELEASE</spring-context.version>
    </properties>
    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework</groupId>
                <artifactId>spring-context</artifactId>
                <version>${spring-context.version}</version>
            </dependency>
        </dependencies>
    </dependencyManagement>
    
</project>
```

parentb项目的pom.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="https://maven.apache.org/POM/4.0.0"
         xmlns:xsi="https://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.itbaizhan</groupId>
    <artifactId>parentb</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>pom</packaging>

    <properties>
        <spring-web.version>5.2.4.RELEASE</spring-web.version>
    </properties>
    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework</groupId>
                <artifactId>spring-web</artifactId>
                <version>${spring-web.version}</version>
            </dependency>
        </dependencies>
    </dependencyManagement>
</project>
```

子项目的pom.xml

```xml
<dependencyManagement>
    <dependencies>
        <!--父项目a-->
        <dependency>
            <groupId>com.itbaizhan</groupId>
            <artifactId>parenta</artifactId>
            <version>1.0-SNAPSHOT</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
        <!--父项目b-->
        <dependency>
            <groupId>com.itbaizhan</groupId>
            <artifactId>parentb</artifactId>
            <version>1.0-SNAPSHOT</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
     <dependencies>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-web</artifactId>
        </dependency>
    </dependencies>
</dependencyManagement>
```



### 5.4 聚合关系

Maven的聚合特性可以帮助我们把多个项目基于多个模块聚合在一起，这样能够更加方便项目的管理。

前提：继承。

聚合包含了继承的特性。

聚合时多个项目的本质还是一个项目。这些项目被一个大的父项目包含。且这时父项目类型为pom类型。同时在父项目的pom.xml中出现<modules>表示包含的所有子模块。

```xml
<!-- 来自于hadoop-3.2.1-src/pom.xml -->
<modules>
    <module>hadoop-project</module>
    <module>hadoop-project-dist</module>
    <module>hadoop-assemblies</module>
    <module>hadoop-maven-plugins</module>
    <module>hadoop-common-project</module>
    <module>hadoop-hdfs-project</module>
    <module>hadoop-yarn-project</module>
    <module>hadoop-mapreduce-project</module>
    <module>hadoop-tools</module>
    <module>hadoop-dist</module>
    <module>hadoop-minicluster</module>
    <module>hadoop-client-modules</module>
    <module>hadoop-build-tools</module>
    <module>hadoop-cloud-storage-project</module>
</modules>

<!-- 来自于hadoop-3.2.1-src/hadoop-project/pom.xml -->
  <modelVersion>4.0.0</modelVersion>
  <parent>
    <groupId>org.apache.hadoop</groupId>
    <artifactId>hadoop-main</artifactId>
    <version>3.2.1</version>
  </parent>
  <artifactId>hadoop-project</artifactId>
  <version>3.2.1</version>
```

自己创建的moduleDemo：

```xml
<modules>
    <module>module1</module>
    <module>module2</module>
</modules>
```

即使在idea中，也可以使用聚合在一个窗口创建多个项目。

**删除聚合模块步骤**

右键模块--> remove module

 ![](/assets/images/MavenImages/wp7.jpg)

右键项目 --> delete

 ![](/assets/images/MavenImages/wps8.jpg)

在父项目中pom.xml中<modules>中删除模块名

```xml
<groupId>com.itbaizhan</groupId>
    <artifactId>moduleDemo</artifactId>
    <version>1.0-SNAPSHOT</version>
    <modules>
        <module>module1</module>
        <module>module2</module> <!-- 删除改行配置 -->
    </modules>
    <packaging>pom</packaging>
```

 

## 六、Maven中的常见插件

### 6.1 Maven内置插件

Maven自身拥有很多内置插件，每一个内置插件都代表了Maven的一种行为。Maven在管理项目整个生命周期时，在不同的阶段处理的过程都是使用插件来具体完成。如：构建项目时使用构建插件、编译项目时使用编译插件、清除构建使用清除构建的插件、测试项目时使用测试插件、打包时使用资源拷贝插件以及打包插件。

maven插件更多信息见：https://maven.apache.org/plugins/index.html

我们可以在不同阶段使用Maven中的不同命令来触发不同的插件来执行不同的工作。换言之，Maven的插件是需要依赖命令来执行的。

Maven在管理插件时也是通过坐标的概念和管理依赖的方式相同，通过坐标来定位唯一的一个插件。

现在在很多的IDE中都已经把Maven的常用命令通过界面中的按钮来体现，我们只要点击相应的按钮就等同于执行了相应的命令。

![](/assets/images/MavenImages/mvn_plugin.jpg)

#### 6.1.1 配置编译插件

**1.在setings.xml中配置全局编译插件**

```xml
<profile>
	<!-- 定义的编译器插件ID，全局唯一 -->
	<id>jdk-1.8</id>
	<!-- 插件标记，activeByDefault 默认编译器，jdk提供编译器版本 -->
	<activation>
		<activeByDefault>true</activeByDefault>
		<jdk>1.8</jdk>
	</activation>
	<!-- 配置信息source-源信息，target-字节码信息，compilerVersion-编译过程版本 -->
	<properties>
		<maven.compiler.source>1.8</maven.compiler.source>
		<maven.compiler.target>1.8</maven.compiler.target>
		<maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion>
	</properties>
</profile>
```

 

**2.在pom.xml文件中配置局部的编译插件**

在一般情况下，我们不需要额外配置Maven的内置插件，除非我们需要对插件做额外配置时才需要配置内置插件。如果我们重新配置了内置插件，那么则以我们配置的为主。

Maven的插件配置需要在pom.xml文件中的<build>标签中使用<plugins>来配置。

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
            <version>3.8.0</version>
            <configuration>
                <source>1.8</source>
                <target>1.8</target>
                <encoding>UTF-8</encoding>
            </configuration>
        </plugin>
    </plugins>
</build>
```

 

#### 6.1.2 资源拷贝插件

Maven在打包时默认只将src/main/resources里的配置文件拷贝到项目中并做打包处理，而非resource目录下的配置文件在打包时不会添加到项目中。我们在使用MyBatis时，如果接口与Mapper文件在同一个目录中，在默认的情况下Maven打包的时候，对于src/main/java目录只打包源代码，而不会打包其他文件。所以Mapper文件不会打包到最终的jar文件夹中，也不会输出到target文件夹中，此时运行代码操作数据库时会报异常。

解决方案：

1）将Mapper文件放入到resources目录中。

2）配置资源拷贝插件，指定其拷贝文件的位置。

```xml
<resources>
    <resource>
        <directory>src/main/java</directory>
        <includes>
            <include>**/*.xml</include>
        </includes>
    </resource>
    <resource>
        <directory>src/main/resources</directory>
        <includes>
            <include>**/*.xml</include>
            <include>**/*.properties</include>
        </includes>
    </resource>
</resources>
```



### 6.2 扩展插件Tomcat插件

Tomcat插件是Maven的扩展插件，其作用是为基于Maven开发的Web项目提供一个内置的Tomcat支持，这样我们在开发阶段可以不在依赖外部的Tomcat来运行Web项目，该插件目前使用的Tomcat版本为Tomcat7。该插件的作用很强大，除了提供了Tomcat以外，还可以通过该插件实现项目的远程热部署。

```xml
<!-- 配置Tomcat插件 -->
<plugin>
    <groupId>org.apache.tomcat.maven</groupId>
    <artifactId>tomcat7-maven-plugin</artifactId>
    <version>2.2</version>
    <configuration>
        <!-- 配置Tomcat监听端口 -->
        <port>8080</port>
        <!-- 配置项目的访问路径(Application Context) -->
        <path>/</path>
    </configuration>
</plugin>
```

 

 

### 6.3 插件管理

在Maven中提供了和依赖管理相同的方式用于来管理插件，我们可以在父工程中声明插件，然后在具体的子项目中按需引入不同的插件。

#### 6.3.1 父工程POM

```xml
<build>
    <pluginManagement>
        <plugins>
            <plugin>
                <groupId>org.apache.tomcat.maven</groupId>
                <artifactId>tomcat7-maven-plugin</artifactId>
                <version>2.2</version>
            </plugin>
        </plugins>
    </pluginManagement>
</build>
```

 

#### 6.3.2 子工程POM

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.tomcat.maven</groupId>
            <artifactId>tomcat7-maven-plugin</artifactId>
            <configuration>
                <!-- 配置Tomcat监听端口 -->
                <port>8080</port>
                <!-- 配置项目的访问路径(Application Context) -->
                <path>/</path>
            </configuration>
        </plugin>
    </plugins>
</build>
```



## 七、 Maven常用命令

1. clean

	清除已编译信息。 

	删除工程中的target目录。

2. validate

  验证项目是否正确

3. compile

  只编译。 javac命令。

4. test

  用于执行项目的测试。如果在test目录下含有测试代码，那么Maven在执行install命令会先去执行test命令将所有的test目录下的测试代码执行一遍，如果有测试代码执行失败，那么install命令将会终止。

5. package

  打包。 包含编译，打包两个功能。

6. verify

  运行任何检查，验证包是否有效且达到质量标准。

7. install

  本地安装， 包含编译，打包，安装到本地仓库

  编译 - javac

  打包 - jar， 将java代码打包为jar文件

  安装到本地仓库 - 将打包的jar文件，保存到本地仓库目录中。

8. site

  项目站点文档创建的处理，该命令需要配置插件。

9. deploy

  远程部署命令。

## 八、 Maven项目命名规范

官网的命名规范说明

https://maven.apache.org/guides/mini/guide-naming-conventions.html

1. groupId

	groupId定义当前Maven项目隶属的实际项目。groupId应该遵循Java的包名称规则使用反向域名,例如com.itbaizhan。或者以反向域名开头加项目的名称。例如com.itbaizhan.example，此id前半部分com.itbaizhan代表此项目隶属的组织或公司，example部分代表项目的名称。

2. artifactId

	artifactId是构件ID，该元素定义实际项目中的一个Maven项目或者是子模块的名称，如官方约定中所说，构建名称必须小写字母，没有其他的特殊字符，推荐使用“实际项目名称－模块名称”的方式定义，例如：hadoop-common、hadoop-hdfs等。

3. version

	可以选择带有数字和点（1.0、1.1、1.0.1，...）的任何典型版本。不要使用日期指定当前构件的版本。默认版本为1.0-SNAPSHOT



 

## 九、 基于Maven创建war工程

1. 创建maven项目

2. 创建webapp文件夹

	* 在src/main下新建webapp文件夹
	* 在webapp下新建WEB-INF文件夹
	* 在WEB-INF下新建web.xml

	```xml
	<?xml version="1.0" encoding="UTF-8"?>
	<web-app xmlns="https://xmlns.jcp.org/xml/ns/javaee"
	         xmlns:xsi="https://www.w3.org/2001/XMLSchema-instance"
	         xsi:schemaLocation="https://xmlns.jcp.org/xml/ns/javaee https://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
	         version="4.0">
	</web-app>
	```

	![](/assets/images/MavenImages/wps37.jpg)

3. 配置web模块

	如果不配置会导致无法新建jsp文件

	菜单File --> Project Structure  (或者按快捷键Ctrl+Alt+Shift+S)

	![](/assets/images/MavenImages/ps1.jpg)

	进入如下界面：

	![](/assets/images/MavenImages/ps2.jpg)

	![](/assets/images/MavenImages/ps3.jpg)

	

4. 配置pom.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="https://maven.apache.org/POM/4.0.0"
         xmlns:xsi="https://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.itbaizhan</groupId>
    <artifactId>webdemo</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>war</packaging>
    <dependencies>
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>javax.servlet-api</artifactId>
            <version>3.1.0</version>
            <scope>provided</scope>
        </dependency>
        <dependency>
            <groupId>javax.servlet.jsp</groupId>
            <artifactId>jsp-api</artifactId>
            <version>2.2</version>
            <scope>provided</scope>
        </dependency>
        <dependency>
            <groupId>jstl</groupId>
            <artifactId>jstl</artifactId>
            <version>1.2</version>
        </dependency>
    </dependencies>
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.tomcat.maven</groupId>
                <artifactId>tomcat7-maven-plugin</artifactId>
                <version>2.2</version>
                <configuration>
                    <path>/</path>
                    <port>8080</port>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```

 

 

## 十、 Tomcat热部署

热部署是指，在外部的Tomcat容器运行过程中，动态实现war工程的部署，或者重新部署的功能。我们可以使用Maven的Tomcat插件实现远程热部署，具体命令为： tomcat7:deploy或tomcat7:redeploy。其中deploy代表第一次部署war工程；redeploy代表Tomcat容器中已有同名应用，本次操作为重新部署同名war工程。

实现热部署需要远程访问Tomcat容器，所以需要开启Tomcat的用户认证机制。在Tomcat中，对于支持远程热部署的用户需要拥有相应的权限。

1. Tomcat权限介绍

![img](/assets/images/MavenImages/wps42.jpg) 

- `manager-gui` -允许访问HTML GUI和状态页面
- `manager-script` - 允许访问文本界面和状态页面
- `manager-jmx` - 允许访问jmx代理和状态页面
- `manager-status`- 仅允许访问状态页面

2. 在Tomcat中添加用户并分配权限

修改Tomcat中的conf/tomcat-users.xml文件的配置

```xml
<role rolename="manager-gui"/>
<role rolename="manager-script"/>
<user username="tomcat" password="tomcat" roles="manager-gui,manager-script"/>
```

 

3. 配置Tomcat插件实现热部署

修改项目POM文件中的Tomcat插件，添加配置信息。

```xml
<!-- 配置Tomcat插件 -->
<plugin>
    <groupId>org.apache.tomcat.maven</groupId>
    <artifactId>tomcat7-maven-plugin</artifactId>
    <version>2.2</version>
    <configuration>
        <!-- 上传的war包解压后的路径 -->
        <path>/ROOT</path>
        <!-- 将war上传哪个服务器上，除了IP和端口可以修改外其它内容不变-->
        <url>https://192.168.20.102:8080/manager/text</url>
        <!-- 为tomcat 配置的用户名和密码 -->
        <username>tomcat</username>
        <password>tomcat</password>
    </configuration>
</plugin>
```