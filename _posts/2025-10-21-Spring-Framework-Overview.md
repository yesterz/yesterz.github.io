# Spring Framework Overview

Spring makes it easy to create Java enterprise applications. It provides everything you need to embrace the Java language in an enterprise environment, with support for Groovy and Kotlin as alternative languages on the JVM, and with the flexibility to create many kinds of architectures depending on an application’s needs. As of Spring Framework 6.0, Spring requires Java 17+.

Spring supports a wide range of application scenarios. In a large enterprise, applications often exist for a long time and have to run on a JDK and application server whose upgrade cycle is beyond the developer’s control. Others may run as a single jar with the server embedded, possibly in a cloud environment. Yet others may be standalone applications (such as batch or integration workloads) that do not need a server.

Spring is open source. It has a large and active community that provides continuous feedback based on a diverse range of real-world use cases. This has helped Spring to successfully evolve over a very long time.

Spring 让创建 Java 企业级应用变得简单。它提供了在企业环境中使用 Java 语言所需的一切，同时支持将 Groovy 和 Kotlin 作为 JVM 上的替代语言，并能根据应用程序的需求灵活构建多种架构。从 Spring Framework 6.0 开始，Spring 要求使用 Java 17 或更高版本。

Spring 支持广泛的应用场景。在大型企业中，应用程序往往需要长期运行，并且必须在开发者无法控制的升级周期下的 JDK 和应用服务器上运行。另一些应用可能以单一 jar 包的形式运行，内嵌服务器，可能部署在云环境中。还有一些可能是不需要服务器的独立应用程序（如批处理或集成任务）。

Spring 是开源的。它拥有庞大且活跃的社区，该社区基于丰富多样的实际应用场景，持续提供反馈。这也帮助 Spring 在很长一段时间内成功演进。

说明：

1. make it easy to do something → 让做某事变得简单 / 便于做某事
2. embrace the Java language in an enterprise environment → 在企业环境中使用 Java 语言

3. alternative languages on the JVM → JVM 上的替代语言（如 Groovy、Kotlin）

4. flexibility to create many kinds of architectures → 灵活构建多种架构

5. requires Java 17+ → 要求使用 Java 17 或更高版本

6. run as a single jar with the server embedded → 以单一 jar 包形式运行，内嵌服务器

7. standalone applications → 独立应用程序（不依赖外部服务器，比如批处理或集成任务）

8. open source → 开源的

9. continuous feedback based on real-world use cases → 基于真实应用场景的持续反馈

## What We Mean by "Spring"

The term "Spring" means different things in different contexts. It can be used to refer to the Spring Framework project itself, which is where it all started. Over time, other Spring projects have been built on top of the Spring Framework. Most often, when people say "Spring", they mean the entire family of projects. This reference documentation focuses on the foundation: the Spring Framework itself.

The Spring Framework is divided into modules. Applications can choose which modules they need. At the heart are the modules of the core container, including a configuration model and a dependency injection mechanism. Beyond that, the Spring Framework provides foundational support for different application architectures, including messaging, transactional data and persistence, and web. It also includes the Servlet-based Spring MVC web framework and, in parallel, the Spring WebFlux reactive web framework.

A note about modules: Spring Framework’s jars allow for deployment to the module path (Java Module System). For use in module-enabled applications, the Spring Framework jars come with `Automatic-Module-Name` manifest entries which define stable language-level module names (`spring.core`, `spring.context`, etc.) independent from jar artifact names. The jars follow the same naming pattern with `-` instead of `.` – for example, `spring-core` and `spring-context`. Of course, Spring Framework’s jars also work fine on the classpath.

术语 “Spring” 在不同的语境中具有不同的含义。它可以用来指代 Spring Framework 项目本身，也就是一切的起源。随着时间的推移，其他 Spring 项目也相继构建在 Spring Framework 之上。大多数情况下，当人们说 “Spring” 时，他们指的是整个 Spring 项目家族。而本参考文档聚焦于基础：即 Spring Framework 本身。

Spring Framework 是由多个模块组成的。应用程序可以根据需要选择所需的模块。其核心是 核心容器（core container）模块，其中包括一个配置模型和一个依赖注入机制。除此之外，Spring Framework 还为不同的应用架构提供了基础支持，包括消息传递、事务性数据与持久化、以及 Web 开发。它还包括基于 Servlet 的 Spring MVC Web 框架，以及与之并列的 Spring WebFlux 响应式 Web 框架。

关于模块的说明：
Spring Framework 的 JAR 包支持部署到 模块路径（module path，即 Java 模块系统）。为了在启用了模块功能的应用程序中使用，Spring Framework 的 JAR 包带有 Automatic-Module-Name 清单条目（manifest entries），这些条目定义了与 JAR 工件名称无关的、稳定的语言级别模块名称（例如：spring.core、spring.context 等）。这些 JAR 包遵循与模块名相同的命名规则，使用短横线 “-” 而不是点号 “.”，例如：spring-core 和 spring-context。当然，Spring Framework 的 JAR 包在传统的 类路径（classpath） 上也能正常工作。

说明：

- **The term "Spring" means different things in different contexts.**

  → 术语“Spring”在不同语境中具有不同含义。

- **the Spring Framework project itself, which is where it all started.**

  → Spring Framework 项目本身，也就是一切的起源。

- **other Spring projects have been built on top of the Spring Framework.**

  → 其他 Spring 项目构建在 Spring Framework 之上。

- **the entire family of projects**

  → 整个 Spring 项目家族 / Spring 生态系统

- **The Spring Framework is divided into modules.**

  → Spring Framework 由多个模块组成。

- **core container（核心容器）**

  → Spring 的核心模块，包括 IoC 容器、配置模型和依赖注入机制。

- **configuration model and a dependency injection mechanism**

  → 配置模型和依赖注入机制

- **foundational support for different application architectures**

  → 为不同应用架构提供基础支持

- **messaging, transactional data and persistence, and web**

  → 消息传递、事务性数据与持久化、以及 Web 开发

- **Servlet-based Spring MVC web framework**

  → 基于 Servlet 的 Spring MVC Web 框架（传统同步 Web 开发）

- **Spring WebFlux reactive web framework**

  → Spring WebFlux 响应式 Web 框架（支持响应式编程）

- **module path（模块路径）**

  → Java 9 引入的模块系统（JPMS, Java Platform Module System）中的模块路径

- **Automatic-Module-Name**

  → JAR 清单文件（MANIFEST.MF）中用于定义模块名称的条目，即使没有完整的 module-info.java，也能让 JAR 以模块方式工作

- **jar artifact names vs. module names**

  → JAR 包工件名称（如 spring-core-6.1.0.jar）与语言级模块名称（如 spring.core）是分开的

- **on the classpath**

  → 在传统的类路径（非模块化环境）下运行，依然兼容

## History of Spring and the Spring Framework

Spring came into being in 2003 as a response to the complexity of the early [J2EE](https://en.wikipedia.org/wiki/Java_Platform,_Enterprise_Edition) specifications. While some consider Java EE and its modern-day successor Jakarta EE to be in competition with Spring, they are in fact complementary. The Spring programming model does not embrace the Jakarta EE platform specification; rather, it integrates with carefully selected individual specifications from the traditional EE umbrella:

- Servlet API ([JSR 340](https://www.jcp.org/en/jsr/detail?id=340))
- WebSocket API ([JSR 356](https://www.jcp.org/en/jsr/detail?id=356))
- Concurrency Utilities ([JSR 236](https://www.jcp.org/en/jsr/detail?id=236))
- JSON Binding API ([JSR 367](https://www.jcp.org/en/jsr/detail?id=367))
- Bean Validation ([JSR 303](https://www.jcp.org/en/jsr/detail?id=303))
- JPA ([JSR 338](https://www.jcp.org/en/jsr/detail?id=338))
- JMS ([JSR 914](https://www.jcp.org/en/jsr/detail?id=914))
- as well as JTA/JCA setups for transaction coordination, if necessary.

The Spring Framework also supports the Dependency Injection ([JSR 330](https://www.jcp.org/en/jsr/detail?id=330)) and Common Annotations ([JSR 250](https://www.jcp.org/en/jsr/detail?id=250)) specifications, which application developers may choose to use instead of the Spring-specific mechanisms provided by the Spring Framework. Originally, those were based on common `javax` packages.

As of Spring Framework 6.0, Spring has been upgraded to the Jakarta EE 9 level (for example, Servlet 5.0+, JPA 3.0+), based on the `jakarta` namespace instead of the traditional `javax` packages. With EE 9 as the minimum and EE 10 supported already, Spring is prepared to provide out-of-the-box support for the further evolution of the Jakarta EE APIs. Spring Framework 6.0 is fully compatible with Tomcat 10.1, Jetty 11 and Undertow 2.3 as web servers, and also with Hibernate ORM 6.1.

Over time, the role of Java/Jakarta EE in application development has evolved. In the early days of J2EE and Spring, applications were created to be deployed to an application server. Today, with the help of Spring Boot, applications are created in a devops- and cloud-friendly way, with the Servlet container embedded and trivial to change. As of Spring Framework 5, a WebFlux application does not even use the Servlet API directly and can run on servers (such as Netty) that are not Servlet containers.

Spring continues to innovate and to evolve. Beyond the Spring Framework, there are other projects, such as Spring Boot, Spring Security, Spring Data, Spring Cloud, Spring Batch, among others. It’s important to remember that each project has its own source code repository, issue tracker, and release cadence. See [spring.io/projects](https://spring.io/projects) for the complete list of Spring projects.

Spring 与 Spring Framework 的历史

Spring 诞生于 2003 年，旨在应对早期 J2EE 规范的复杂性。尽管有些人将 Java EE 及其现代继任者 Jakarta EE 视作与 Spring 竞争，实际上二者是互补的。Spring 的编程模型并不拥抱整个 Jakarta EE 平台规范，而是有选择地与传统的 EE 伞形规范中的个别规范进行集成，包括：Servlet API（JSR 340）、WebSocket API（JSR 356）、Concurrency Utilities（JSR 236）、JSON Binding API（JSR 367）、Bean Validation（JSR 303）、JPA（JSR 338）、JMS（JSR 339），以及在需要时的 JTA/JCA 事务编排。Spring Framework 还支持 Dependency Injection（JSR 330） 与 Common Annotations（JSR 250） 规范，应用开发者可以选择使用这些标准而非 Spring 特有的机制。这些接口最初都基于通用的 javax 包。

自 Spring Framework 6.0 起，Spring 已升级到 Jakarta EE 9 级别（例如 Servlet 5.0+、JPA 3.0+），基于 jakarta 命名空间而非传统的 javax 包。以 EE 9 为最低版本并已支持 EE 10，Spring 为 Jakarta EE API 的进一步演进做好了开箱即用的准备。Spring Framework 6.0 完全兼容 Tomcat 10.1、Jetty 11 和 Undertow 2.3 作为 Web 服务器，同时也与 Hibernate ORM 6.1 兼容。

随着时间推移，Java/Jakarta EE 在应用开发中的角色发生了演变。在 J2EE 与早期 Spring 的年代，应用通常面向在应用服务器上部署。而如今，借助 Spring Boot，应用以 DevOps 和 云 友好的方式创建，Servlet 容器内嵌且易于更换。自 Spring Framework 5 起，WebFlux 应用甚至不再直接使用 Servlet API，并且可以在非 Servlet 容器（如 Netty）上运行。

Spring 持续创新与演进。在 Spring Framework 之外，还拥有其他项目，例如 Spring Boot、Spring Security、Spring Data、Spring Cloud、Spring Batch 等。需要记住的是，每个项目都有其独立的源代码仓库、问题跟踪器和发布节奏。完整的 Spring 项目列表请参见 spring.io/projects。

## Design Philosophy

When you learn about a framework, it’s important to know not only what it does but what principles it follows. Here are the guiding principles of the Spring Framework:

- Provide choice at every level. Spring lets you defer design decisions as late as possible. For example, you can switch persistence providers through configuration without changing your code. The same is true for many other infrastructure concerns and integration with third-party APIs.
- Accommodate diverse perspectives. Spring embraces flexibility and is not opinionated about how things should be done. It supports a wide range of application needs with different perspectives.
- Maintain strong backward compatibility. Spring’s evolution has been carefully managed to force few breaking changes between versions. Spring supports a carefully chosen range of JDK versions and third-party libraries to facilitate maintenance of applications and libraries that depend on Spring.
- Care about API design. The Spring team puts a lot of thought and time into making APIs that are intuitive and that hold up across many versions and many years.
- Set high standards for code quality. The Spring Framework puts a strong emphasis on meaningful, current, and accurate javadoc. It is one of very few projects that can claim clean code structure with no circular dependencies between packages.

设计哲学

在学习一个框架时，不仅要了解它能做什么，还要明白它所遵循的原则。以下是 Spring Framework 的指导原则：

• 在每个层级提供选择：Spring 尽可能将设计决策推迟。例如，你可以通过配置在运行期切换持久化提供者，而无需修改代码。对许多其他基础设施关注点以及与第三方 API 的集成也是如此。  

• 兼顾多元视角：Spring 强调灵活性，不对“应该如何做”强加意见。它以不同视角支持广泛的应用需求。  

• 保持强向后兼容性：Spring 的演进经过精心管理，尽量减少版本间的破坏性变更。Spring 支持经过审慎挑选的 JDK 版本与第三方库范围，以便维护依赖 Spring 的应用与库。  

• 重视 API 设计：Spring 团队投入大量时间与思考，打造直观且能在多个版本与多年间保持稳定的 API。  

• 对代码质量设定高标准：Spring Framework 强调有意义、最新且准确的 javadoc。它是少数能够宣称代码结构清晰、且包之间无循环依赖的项目之一。

## Feedback and Contributions

For how-to questions or diagnosing or debugging issues, we suggest using Stack Overflow. Click [here](https://stackoverflow.com/questions/tagged/spring+or+spring-mvc+or+spring-aop+or+spring-jdbc+or+spring-r2dbc+or+spring-transactions+or+spring-annotations+or+spring-jms+or+spring-el+or+spring-test+or+spring+or+spring-orm+or+spring-jmx+or+spring-cache+or+spring-webflux+or+spring-rsocket?tab=Newest) for a list of the suggested tags to use on Stack Overflow. If you’re fairly certain that there is a problem in the Spring Framework or would like to suggest a feature, please use the [GitHub Issues](https://github.com/spring-projects/spring-framework/issues).

If you have a solution in mind or a suggested fix, you can submit a pull request on [Github](https://github.com/spring-projects/spring-framework). However, please keep in mind that, for all but the most trivial issues, we expect a ticket to be filed in the issue tracker, where discussions take place and leave a record for future reference.

For more details see the guidelines at the [CONTRIBUTING](https://github.com/spring-projects/spring-framework/tree/main/CONTRIBUTING.md), top-level project page.

反馈与贡献

如果您有关于 “如何做” 的问题，或者需要 诊断或调试问题，我们建议您使用 Stack Overflow。点击此处查看在 Stack Overflow 上建议使用的标签列表。  
如果您比较确定 Spring Framework 中存在问题，或者希望提出新功能建议，请使用 GitHub Issues（问题追踪系统）。

如果您已经有了解决方案或修复建议，可以在 GitHub 上提交 Pull Request（拉取请求）。但请注意，除了非常简单的问题之外，我们期望您先在 问题追踪系统（issue tracker） 中提交一个问题（ticket），以便进行讨论并为未来留下记录。

更多详情请参阅 CONTRIBUTING 文档（位于顶级项目页面）中的相关指南。

## Getting Started

If you are just getting started with Spring, you may want to begin using the Spring Framework by creating a [Spring Boot](https://spring.io/projects/spring-boot/)-based application. Spring Boot provides a quick (and opinionated) way to create a production-ready Spring-based application. It is based on the Spring Framework, favors convention over configuration, and is designed to get you up and running as quickly as possible.

You can use [start.spring.io](https://start.spring.io/) to generate a basic project or follow one of the ["Getting Started" guides](https://spring.io/guides), such as [Getting Started Building a RESTful Web Service](https://spring.io/guides/gs/rest-service/). As well as being easier to digest, these guides are very task focused, and most of them are based on Spring Boot. They also cover other projects from the Spring portfolio that you might want to consider when solving a particular problem.

快速入门

如果您刚开始接触 Spring，您可能希望先通过创建一个基于 Spring Boot 的应用程序来开始使用 Spring Framework。Spring Boot 提供了一种快速（且具有倾向性） 的方式来创建一个开箱即用、可直接投入生产的 Spring 应用程序。它基于 Spring Framework，推崇“约定优于配置”，并旨在让您尽可能快地上手并运行项目。

您可以使用 https://start.spring.io 来生成一个基础项目，或者按照某个 “快速入门”指南（例如《构建一个 RESTful Web 服务的入门指南》）进行操作。这些指南不仅更易于理解，而且任务导向性很强，其中大多数都基于 Spring Boot。此外，它们还会介绍 Spring 产品组合中的其他项目，这些项目在解决特定问题时也值得您考虑。