---
title: 使用 Spring 构建 REST 服务
date: 2025-08-25 16:28:00 +0800
author: 
categories: [Spring Guidess]
tags: [Spring Guides, REST APIs]
pin: false
math: false
mermaid: false
---



REST has quickly become the de facto standard for building web services on the web because REST services are easy to build and easy to consume.

REST 很快就成为了构建 Web 服务的事实标准，因为 REST 服务既易于构建，又易于使用。

A much larger discussion can be had about how REST fits in the world of microservices. However, for this tutorial, we look only at building RESTful services.

关于 REST 在微服务世界中的作用，可以展开更大篇幅的讨论。不过在本教程里，我们只关注如何构建 RESTful 服务。

Why REST? REST embraces the precepts of the web, including its architecture, benefits, and everything else. This is no surprise, given that its author (Roy Fielding) was involved in probably a dozen specs which govern how the web operates.

为什么选择 REST？REST 遵循了 Web 的基本原则，包括它的架构、优势以及其他所有特性。这也不奇怪，因为它的作者（Roy Fielding）参与过大约十几项规范的制定，而这些规范决定了 Web 的运行方式。

What benefits? The web and its core protocol, HTTP, provide a stack of features:

有哪些好处呢？Web 以及它的核心协议 HTTP 提供了一整套功能：

- Suitable actions (`GET`, `POST`, `PUT`, `DELETE`, and others) 

  适用的操作（如 `GET`、`POST`、`PUT`、`DELETE` 等）

- Caching 

  缓存

- Redirection and forwarding 

  重定向和转发

- Security (encryption and authentication) 

  安全性（包括加密和身份认证）

These are all critical factors when building resilient services. However, that is not all. The web is built out of lots of tiny specs. This architecture lets it easily evolve without getting bogged down in "standards wars".

在构建高可用服务时，这些都是关键因素。不过，这还不是全部。Web 是由很多小的规范组成的，这种架构让它能够轻松演进，而不会被‘标准之争’拖住。

Developers can draw upon third-party toolkits that implement these diverse specs and instantly have both client and server technology at their fingertips.

开发者可以利用实现了这些各种规范的第三方工具包，马上就能掌握客户端和服务端的技术。

By building on top of HTTP, REST APIs provide the means to build:

通过建立在 HTTP 之上，REST API 提供了构建以下内容的手段：

- Backwards compatible APIs 

  向后兼容的 API

- Evolvable APIs 

  可演进的 API

- Scaleable services 

  可扩展的服务

- Securable services 

  可保障安全的服务

- A spectrum of stateless to stateful services 

  从无状态到有状态的一系列服务

Note that REST, however ubiquitous, is not a standard *per se* but an approach, a style, a set of *constraints* on your architecture that can help you build web-scale systems. This tutorial uses the Spring portfolio to build a RESTful service while takin advantage of the stackless features of REST.

需要注意的是，虽然 REST 无处不在，但它本身并不是一个标准，而是一种方法、一种风格、一组架构上的约束，能够帮助你构建大规模的 Web 系统。本教程使用 Spring 系列框架来构建 RESTful 服务，同时利用 REST 的无状态特性。

## Getting Started

To get started, you need:

要开始，你需要准备以下内容：

- A favorite text editor or IDE, such as:
  - [IntelliJ IDEA](https://www.jetbrains.com/idea/)
  - [VSCode](https://code.visualstudio.com/)
- [Java 17](https://www.oracle.com/java/technologies/downloads/) or later

As we work through this tutorial, we use [Spring Boot](https://spring.io/projects/spring-boot). Go to [Spring Initializr](https://start.spring.io/) and add the following dependencies to a project:

在本教程中，我们使用 [Spring Boot](https://spring.io/projects/spring-boot)。打开 [Spring Initializr](https://start.spring.io/)，给项目添加以下依赖：

- Spring Web
- Spring Data JPA
- H2 Database

Change the Name to "Payroll" and then choose **Generate Project**. A `.zip` file downloads. Unzip it. Inside, you should find a simple, Maven-based project that includes a `pom.xml` build file. (Note: You can use Gradle. The examples in this tutorial will be Maven-based.)

把项目名称改成 `Payroll`，然后点击 **Generate Project**。系统会下载一个 `.zip` 文件。解压后，你会看到一个基于 Maven 的简单项目，其中包含一个 `pom.xml` 构建文件。（注意：你也可以用 Gradle，不过本教程里的示例都是基于 Maven 的。）

To complete the tutorial, you could start a new project from scratch or you could look at the [solution repository](https://github.com/spring-guides/tut-rest) in GitHub.

要完成本教程，你可以从头创建一个新项目，也可以查看 GitHub 上的 [解决方案仓库](https://github.com/spring-guides/tut-rest)。

If you choose to create your own blank project, this tutorial walks you through building your application sequentially. You do not need multiple modules.

如果你选择自己创建一个空白项目，本教程会一步步带你构建应用程序。你不需要多个模块。

Rather than providing a single, final solution, the [completed GitHub repository](https://github.com/spring-guides/tut-rest) uses modules to separate the solution into four parts. The modules in the GitHub solution repository build on one another, with the `links` module containing the final solution. The modules map to the following headers:

与直接提供一个完整的最终解决方案不同，GitHub 上的 [完整仓库](https://github.com/spring-guides/tut-rest) 使用了模块，把解决方案分成四个部分。GitHub 仓库里的模块是逐步递进的，其中 `links` 模块包含最终解决方案。这些模块对应以下标题：

- [The Story So Far (nonrest)](https://spring.io/guides/tutorials/rest#_the_story_so_far) 

  到目前为止的进展

- [Spring HATEOAS (rest)](https://spring.io/guides/tutorials/rest#_spring_hateoas) 

  Spring HATEOAS

- [Simplifying Link Creation (evolution)](https://spring.io/guides/tutorials/rest#_simplifying_link_creation) 

  简化链接创建

- [Building links into your REST API (links)](https://spring.io/guides/tutorials/rest#_building_links_into_your_rest_api) 

  在 REST API 中构建链接（links）

## The Story so Far

This tutorial starts by building up the code in the [`nonrest` module](https://github.com/spring-guides/tut-rest/tree/main/nonrest).

本教程会先从 [`nonrest` 模块](https://github.com/spring-guides/tut-rest/tree/main/nonrest) 开始逐步构建代码。

We start off with the simplest thing we can construct. In fact, to make it as simple as possible, we can even leave out the concepts of REST. (Later on, we add REST, to understand the difference.)

我们从能构建的最简单的东西开始。实际上，为了尽可能简单，我们甚至可以先不考虑 REST 的概念。（稍后我们会加入 REST，以便理解它的不同之处。）

Big picture: We are going to create a simple payroll service that manages the employees of a company. We store employee objects in a (H2 in-memory) database, and access them (through something called JPA). Then we wrap that with something that allows access over the internet (called the Spring MVC layer).

整体来看，我们要创建一个简单的薪资（payroll）服务，用来管理员工信息。我们会把员工对象存到一个 H2 内存数据库里，并通过 JPA 来访问。然后，再用 Spring MVC 这一层把它包装起来，让它能够通过网络访问。

The following code defines an `Employee` in our system.

下面的代码定义了我们系统中的一个 `Employee`（员工）。

* nonrest/src/main/java/payroll/Employee.java

```java
package wiki.yesterz.payroll;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;

import java.util.Objects;

@Entity
public class Empolyee {

    private @Id @GeneratedValue Long id;
    private String name;
    private String role;

    Empolyee() {}

    Empolyee(String name, String role) {
        this.name = name;
        this.role = role;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Empolyee empolyee)) return false;
        return Objects.equals(this.id, empolyee.id) && Objects.equals(this.name, empolyee.name)
                && Objects.equals(this.role, empolyee.role);
    }

    @Override
    public int hashCode() {
        return Objects.hash(this.id, this.name, this.role);
    }

    @Override
    public String toString() {
        return "Empolyee{" +
                "id=" + this.id +
                ", name='" + this.name + '\'' +
                ", role='" + this.role + '\'' +
                '}';
    }
}

```

Despite being small, this Java class contains much:

虽然这个 Java 类很小，但它包含的内容不少：

- `@Entity` is a JPA annotation to make this object ready for storage in a JPA-based data store.

  `@Entity` 是一个 JPA 注解，用来让这个对象可以存储到基于 JPA 的数据存储中。

- `id`, `name`, and `role` are attributes of our `Employee` domain object. `id` is marked with more JPA annotations to indicate that it is the primary key and is automatically populated by the JPA provider.

  `id`、`name` 和 `role` 是 `Employee` 域对象的属性。其中 `id` 加了额外的 JPA 注解，用来标识它是主键，并且由 JPA 提供者自动生成。

- A custom constructor is created when we need to create a new instance but do not yet have an `id`.

  当我们需要创建一个新实例但还没有 `id` 时，会使用自定义构造函数。

With this domain object definition, we can now turn to [Spring Data JPA](https://spring.io/guides/gs/accessing-data-jpa/) to handle the tedious database interactions.

有了这个域对象定义后，我们现在可以使用 [Spring Data JPA](https://spring.io/guides/gs/accessing-data-jpa/) 来处理繁琐的数据库操作了。

Spring Data JPA repositories are interfaces with methods that support creating, reading, updating, and deleting records against a back end data store. Some repositories also support data paging and sorting, where appropriate. Spring Data synthesizes implementations based on conventions found in the naming of the methods in the interface.

Spring Data JPA 的仓库（repository）是一些接口，里面的方法支持对后台数据存储进行创建、读取、更新和删除操作。有些仓库还支持分页和排序（在适用的情况下）。Spring Data 会根据接口中方法命名的约定，自动生成具体实现。

There are multiple repository implementations besides JPA. You can use [Spring Data MongoDB](https://spring.io/projects/spring-data-mongodb#overview), [Spring Data Cassandra](https://spring.io/projects/spring-data-cassandra#overview), and others. This tutorial sticks with JPA.

除了 JPA，还有多种仓库实现可用。你可以使用 [Spring Data MongoDB](https://spring.io/projects/spring-data-mongodb#overview)、[Spring Data Cassandra](https://spring.io/projects/spring-data-cassandra#overview) 等等。但本教程仍然使用 JPA。

Spring makes accessing data easy. By declaring the following `EmployeeRepository` interface, we can automatically:

Spring 让访问数据变得很简单。通过声明下面的 `EmployeeRepository` 接口，我们就可以自动实现以下功能：

- Create new employees

  创建新员工

- Update existing employees

  更新已有员工

- Delete employees

  删除员工

- Find employees (one, all, or search by simple or complex properties)

  查找员工（单个、全部，或按简单/复杂属性搜索）



* nonrest/src/main/java/payroll/EmployeeRepository.java

```java
package wiki.yesterz.payroll;

import org.springframework.data.jpa.repository.JpaRepository;

interface EmployeeRepository extends JpaRepository<Empolyee, Long> {
}

```

To get all this free functionality, all we have to do is declare an interface that extends Spring Data JPA’s `JpaRepository`, specifying the domain type as `Employee` and the `id` type as `Long`.

要获得所有这些免费功能，我们只需要声明一个接口，继承 Spring Data JPA 的 `JpaRepository`，并指定域对象类型为 `Employee`，`id` 类型为 `Long`。

Spring Data’s [repository solution](https://docs.spring.io/spring-data/jpa/reference/repositories.html) makes it possible to sidestep data store specifics and, instead, solve a majority of problems by using domain-specific terminology.

Spring Data 的 [仓库解决方案](https://docs.spring.io/spring-data/jpa/reference/repositories.html) 让我们可以绕过具体的数据存储细节，而是用领域特定的术语来解决大部分问题。

Believe it or not, this is enough to launch an application! A Spring Boot application is, at a minimum, a `public static void main` entry-point and the `@SpringBootApplication` annotation. This tells Spring Boot to help out wherever possible.

信不信由你，仅这些就足够启动一个应用了！一个 Spring Boot 应用，至少需要一个 `public static void main` 入口方法和 `@SpringBootApplication` 注解。这会告诉 Spring Boot 尽可能地帮你处理各种事务。



* nonrest/src/main/java/payroll/PayrollApplication.java

```java
package wiki.yesterz.payroll;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class PayrollApplication {

    public static void main(String[] args) {
        SpringApplication.run(PayrollApplication.class, args);
    }

}

```

`@SpringBootApplication` is a meta-annotation that pulls in **component scanning**, **auto-configuration**, and **property support**. We do not dive into the details of Spring Boot in this tutorial. However, in essence, it starts a servlet container and serves up our service.

`@SpringBootApplication` 是一个元注解，它包含了 **组件扫描**、**自动配置** 和 **属性支持**。本教程不会深入讲解 Spring Boot 的细节。不过，简单来说，它会启动一个 Servlet 容器，并提供我们的服务。

An application with no data is not very interesting, so we preload that it has data. The following class gets loaded automatically by Spring:

没有数据的应用就没什么意思，所以我们预先加载一些数据。下面这个类会被 Spring 自动加载：



* nonrest/src/main/java/payroll/LoadDatabase.java

```java
package wiki.yesterz.payroll;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class LoadDatabase {

    private static final Logger log = LoggerFactory.getLogger(LoadDatabase.class);

    @Bean
    CommandLineRunner initDatabase(EmployeeRepository repository) {
        return args -> {
            log.info("Preloading " + repository.save(new Empolyee("Bilbo Baggins", "burglar")));
            log.info("Preloading " + repository.save(new Empolyee("Frodo Baggins", "thief")));
        };
    }
}

```



What happens when it gets loaded?

当它被加载时，会发生什么呢？

- Spring Boot runs ALL `CommandLineRunner` beans once the application context is loaded.

  Spring Boot 会在应用上下文加载完成后，运行所有的 CommandLineRunner Bean。

- This runner requests a copy of the `EmployeeRepository` you just created.

  这个 Runner 会获取你刚创建的 EmployeeRepository 的一个实例。

- The runner creates two entities and stores them.

  Runner 会创建两个实体并存储起来。

Right-click and **Run** `PayRollApplication`, and you get:

右键点击并运行 `PayRollApplication`，你会看到：

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Fragment of console output showing preloading of data</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;">...
20yy-08-09 11:36:26.169  INFO 74611 --- [main] payroll.LoadDatabase : Preloading Employee(id=1, name=Bilbo Baggins, role=burglar)
20yy-08-09 11:36:26.174  INFO 74611 --- [main] payroll.LoadDatabase : Preloading Employee(id=2, name=Frodo Baggins, role=thief)
...</pre></div></div></div></details>

```plaintext
...
2025-08-25T17:43:08.788+08:00  INFO 64048 --- [payroll] [           main] wiki.yesterz.payroll.LoadDatabase        : Preloading Empolyee{id=1, name='Bilbo Baggins', role='burglar'}
2025-08-25T17:43:08.790+08:00  INFO 64048 --- [payroll] [           main] wiki.yesterz.payroll.LoadDatabase        : Preloading Empolyee{id=2, name='Frodo Baggins', role='thief'}
...
```

This is not the **whole** log, but only the key bits of preloading data.

这不是完整的日志，只是显示数据预加载的关键部分。

## HTTP is the Platform

To wrap your repository with a web layer, you must turn to Spring MVC. Thanks to Spring Boot, you need add only a little code. Instead, we can focus on actions:

要给你的仓库加上 Web 层，就需要用到 Spring MVC。多亏了 Spring Boot，你只需写很少的代码。这样，我们就可以专注于具体操作了：



* nonrest/src/main/java/payroll/EmployeeController.java

```java
package wiki.yesterz.payroll;

import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class EmployeeController {

    private final EmployeeRepository repository;

    EmployeeController(EmployeeRepository repository) {
        this.repository = repository;
    }

    // Aggregate root
    // tag::get-aggregate-root[]
    @GetMapping("/employees")
    List<Empolyee> all() {
        return repository.findAll();
    }
    // end::get-aggregate-root[]

    @PostMapping("/employees")
    Empolyee newEmployee(@RequestBody Empolyee newEmployee) {
        return repository.save(newEmployee);
    }

    // Single item

    @GetMapping("/employees/{id}")
    Empolyee one(@PathVariable Long id) {

        return repository.findById(id)
                .orElseThrow(() -> new EmployeeNotFoundException(id));
    }

    @PutMapping("/employees/{id}")
    Empolyee replaceEmployee(@RequestBody Empolyee newEmployee, @PathVariable Long id) {

        return repository.findById(id)
                .map(employee -> {
                    employee.setName(newEmployee.getName());
                    employee.setRole(newEmployee.getRole());
                    return repository.save(employee);
                })
                .orElseGet(() -> {
                    return repository.save(newEmployee);
                });
    }

    @DeleteMapping("/employees/{id}")
    void deleteEmployee(@PathVariable Long id) {
        repository.deleteById(id);
    }

}

```

- `@RestController` indicates that the data returned by each method is written straight into the response body instead of rendering a template.

  `@RestController` 表明每个方法返回的数据会直接写入响应体，而不是渲染模板。

- An `EmployeeRepository` is injected by constructor into the controller.

  `EmployeeRepository` 会通过构造函数注入到控制器中。

- We have routes for each operation (`@GetMapping`, `@PostMapping`, `@PutMapping` and `@DeleteMapping`, corresponding to HTTP `GET`, `POST`, `PUT`, and `DELETE` calls). (We recommend reading each method and understanding what they do.)

  我们为每个操作都设置了路由（`@GetMapping`、`@PostMapping`、`@PutMapping` 和 `@DeleteMapping`，分别对应 HTTP 的 `GET`、`POST`、`PUT` 和 `DELETE` 请求）。建议逐个阅读方法，理解它们的功能。

- `EmployeeNotFoundException` is an exception used to indicate when an employee is looked up but not found.

  `EmployeeNotFoundException` 是一个异常，用于表示查找员工时未找到的情况。



* nonrest/src/main/java/payroll/EmployeeNotFoundException.java

```java
package wiki.yesterz.payroll;

public class EmployeeNotFoundException extends RuntimeException {

    EmployeeNotFoundException(Long id) {
        super("Could not find employee " + id);
    }
}

```

When an `EmployeeNotFoundException` is thrown, this extra tidbit of Spring MVC configuration is used to render an **HTTP 404** error:

当抛出 `EmployeeNotFoundException` 时，这段额外的 Spring MVC 配置会用来返回 **HTTP 404** 错误：



* nonrest/src/main/java/payroll/EmployeeNotFoundAdvice.java

```java
package wiki.yesterz.payroll;

import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import static org.springframework.http.HttpStatus.NOT_FOUND;

@RestControllerAdvice
public class EmployeeNotFoundAdvice {

    @ExceptionHandler(EmployeeNotFoundException.class)
    @ResponseStatus(NOT_FOUND)
    String employeeNotFoundHandler(EmployeeNotFoundException ex) {
        return ex.getMessage();
    }
}

```

- `@RestControllerAdvice` signals that this advice is rendered straight into the response body.

  `@RestControllerAdvice` 表示这个 advice 会直接写入响应体。

- `@ExceptionHandler` configures the advice to only respond when an `EmployeeNotFoundException` is thrown.

  `@ExceptionHandler` 配置这个 advice，仅在抛出 `EmployeeNotFoundException` 时生效。

- `@ResponseStatus` says to issue an `HttpStatus.NOT_FOUND` — that is, an **HTTP 404** error.

  `@ResponseStatus` 指定返回 `HttpStatus.NOT_FOUND`，也就是 **HTTP 404** 错误。

- The body of the advice generates the content. In this case, it gives the message of the exception.

  advice 的主体负责生成内容，这里会返回异常的消息。

To launch the application, you can right-click the `public static void main` in `PayRollApplication` and select **Run** from your IDE.

要启动应用程序，你可以在 `PayRollApplication` 中右键点击 `public static void main`，然后在 IDE 中选择 **Run**。

Alternatively, Spring Initializr creates a Maven wrapper, so you can run the following command:

或者，Spring Initializr 会创建一个 Maven 包装器，你可以运行以下命令：

```shell
$ ./mvnw clean spring-boot:run
```

Alternatively, you can use your installed Maven version, as follows:

或者，你也可以使用自己安装的 Maven，命令如下：

```shell
$ mvn clean spring-boot:run
```

When the app starts, you can immediately interrogate it, as follows:

当应用启动后，你可以立即对它进行测试，方法如下：

```shell
$ curl -v localhost:8080/employees
```

Doing so yields the following:

这样操作会得到如下结果：

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Details</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;">*   Trying ::1...
* TCP_NODELAY set
* Connected to localhost (::1) port 8080 (#0)
&gt; GET /employees HTTP/1.1
&gt; Host: localhost:8080
&gt; User-Agent: curl/7.54.0
&gt; Accept: */*
&gt;
&lt; HTTP/1.1 200
&lt; Content-Type: application/json;charset=UTF-8
&lt; Transfer-Encoding: chunked
&lt; Date: Thu, 09 Aug 20yy 17:58:00 GMT
&lt;
* Connection #0 to host localhost left intact
[{"id":1,"name":"Bilbo Baggins","role":"burglar"},{"id":2,"name":"Frodo Baggins","role":"thief"}]</pre></div></div></div></details>

You can see the pre-loaded data in a compacted format.

你可以看到以压缩格式显示的预加载数据。

Now try to query a user that doesn’t exist, as follows:

```
$ curl -v localhost:8080/employees/99
```

When you do so, you get the following output:

现在试着查询一个不存在的用户，方法如下：

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Details</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;">*   Trying ::1...
* TCP_NODELAY set
* Connected to localhost (::1) port 8080 (#0)
&gt; GET /employees/99 HTTP/1.1
&gt; Host: localhost:8080
&gt; User-Agent: curl/7.54.0
&gt; Accept: */*
&gt;
&lt; HTTP/1.1 404
&lt; Content-Type: text/plain;charset=UTF-8
&lt; Content-Length: 26
&lt; Date: Thu, 09 Aug 20yy 18:00:56 GMT
&lt;
* Connection #0 to host localhost left intact
Could not find employee 99</pre></div></div></div></details>
This message nicely shows an **HTTP 404** error with the custom message: `Could not find employee 99`.

这个提示很直观，返回了一个 **HTTP 404** 错误，并带上了自定义消息：`Could not find employee 99`。

It is not hard to show the currently coded interactions.

展示目前已经编写好的交互并不难。

If you use Windows command prompt to issue cURL commands, the following command probably does not work properly. You must either pick a terminal that support single-quoted arguments, or use double quotation marks and then escape the quotation marks inside the JSON.

如果你在 **Windows 命令提示符** 中执行 `cURL` 命令，下列命令可能无法正常运行。 你必须选择一个支持 **单引号参数** 的终端，或者改用 **双引号** 并对 JSON 内部的引号进行转义。

To create a new `Employee` record, use the following command in a terminal (the `$` at the beginning signifies that what follows it is a terminal command):

要创建一个新的 `Employee` 记录，可以在终端里运行如下命令（开头的 `$` 表示这是一个终端命令）：

```shell
$ curl -X POST localhost:8080/employees -H 'Content-type:application/json' -d '{"name": "Samwise Gamgee", "role": "gardener"}'
```

Then it stores the newly created employee and sends it back to us:

然后它会把新创建的员工保存下来，并将其返回给我们：

```shell
{"id":3,"name":"Samwise Gamgee","role":"gardener"}
```

You can update the user. For example, you can change the role:

你可以更新用户。例如，你可以修改其角色：

```shell
$ curl -X PUT localhost:8080/employees/3 -H 'Content-type:application/json' -d '{"name": "Samwise Gamgee", "role": "ring bearer"}'
```

Now we can see the change reflected in the output:

现在我们可以在输出中看到修改已经生效：

```shell
{"id":3,"name":"Samwise Gamgee","role":"ring bearer"}
```

The way you construct your service can have significant impacts. In this situation, we said **update**, but **replace** is a better description. For example, if the name was NOT provided, it would instead get nulled out.

构建服务的方式会产生重要影响。在这个例子中，我们用了 **update（更新）**，但其实 **replace（替换）** 更贴切。 比如，如果没有提供名字，它就会被置为 `null`。

Finally, you can delete users, as follows:

最后，你可以删除用户，方法如下：

```shell
$ curl -X DELETE localhost:8080/employees/3

# Now if we look again, it's gone
$ curl localhost:8080/employees/3
Could not find employee 3
```

This is all well and good, but do we have a RESTful service yet? (The answer is no.)

这样做当然没问题，但我们现在有真正的 RESTful 服务了吗？（答案是否定的。）

What’s missing?

缺少了什么呢？

## What Makes a Service RESTful?

So far, you have a web-based service that handles the core operations that involve employee data. However, that is not enough to make things "RESTful".

到目前为止，你有了一个基于 Web 的服务，可以处理与员工数据相关的核心操作。不过，这还不足以让服务成为真正的 ‘RESTful’。

- Pretty URLs, such as`/employees/3`, aren’t REST.

  像 /employees/3 这样的漂亮 URL，并不是 REST。

- Merely using `GET`, `POST`, and so on is not REST.

  仅仅使用 GET、POST 等方法，也不算 REST。

- Having all the CRUD operations laid out is not REST.

  把所有 CRUD 操作都列出来，也不算 REST。

In fact, what we have built so far is better described as **RPC** (**Remote Procedure Call**), because there is no way to know how to interact with this service. If you published this today, you wouldd also have to write a document or host a developer’s portal somewhere with all the details.

实际上，到目前为止我们构建的服务更适合称为 **RPC（远程过程调用）**，因为没有办法知道如何与这个服务交互。如果你今天就发布它，还得写一份文档，或者在某个地方搭建开发者门户，把所有细节都提供出来。

This statement of Roy Fielding’s may further lend a clue to the difference between **REST** and **RPC**:

Roy Fielding 的这句话或许能进一步揭示 **REST** 与 **RPC** 之间的区别：

> I am getting frustrated by the number of people calling any HTTP-based interface a REST API. Today’s example is the SocialSite REST API. That is RPC. It screams RPC. There is so much coupling on display that it should be given an X rating.
>
> 我对那么多人把任何基于 HTTP 的接口都叫 REST API 感到很无语。今天的例子是 SocialSite REST API。那其实是 RPC，完全是 RPC。耦合度太高了，简直可以打 X 级评分。
>
> What needs to be done to make the REST architectural style clear on the notion that hypertext is a constraint? In other words, if the engine of application state (and hence the API) is not being driven by hypertext, then it cannot be RESTful and cannot be a REST API. Period. Is there some broken manual somewhere that needs to be fixed?
>
> 要如何才能让 REST 架构风格明确一点，即超文本是它的约束条件呢？换句话说，如果应用状态的引擎（以及 API）不是由超文本驱动的，那它就不能算 RESTful，也不能叫 REST API。就是这样。难道哪里有一份破损的手册需要修正吗？
>
> — Roy Fielding
> https://roy.gbiv.com/untangled/2008/rest-apis-must-be-hypertext-driven

The side effect of nnot including hypermedia in our representations is that clients must hard-code URIs to navigate the API. This leads to the same brittle nature that predated the rise of e-commerce on the web. It signifies that our JSON output needs a little help.

如果我们的资源表示中没有包含超媒体，客户端就必须硬编码 URI 来访问 API。这会导致和电子商务兴起前 Web 上一样的脆弱情况。这也说明，我们的 JSON 输出需要一些改进。

## Spring HATEOAS

Now we can introduce [Spring HATEOAS](https://spring.io/projects/spring-hateoas), a Spring project aimed at helping you write hypermedia-driven outputs. To upgrade your service to being RESTful, add the following to your build:

现在我们可以引入 [Spring HATEOAS](https://spring.io/projects/spring-hateoas)，这是一个帮助你生成超媒体驱动输出的 Spring 项目。要把你的服务升级为真正的 RESTful，只需在构建配置中添加以下内容：

If you are following along in the [solution repository](https://github.com/spring-guides/tut-rest), the next section switches to the [rest module](https://github.com/spring-guides/tut-rest/tree/main/rest).

如果你在跟着 [解决方案仓库](https://github.com/spring-guides/tut-rest) 操作，下一部分会切换到 [rest 模块](https://github.com/spring-guides/tut-rest/tree/main/rest)。

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Adding Spring HATEOAS to<span>&nbsp;</span><code style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(54, 54, 54); font-size: 15px; font-weight: 400; padding: 10px; background: rgb(255, 255, 255); border: 1px solid rgb(225, 225, 232); overflow-x: auto; white-space: nowrap;">dependencies</code><span>&nbsp;</span>section of<span>&nbsp;</span><code style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(54, 54, 54); font-size: 15px; font-weight: 400; padding: 10px; background: rgb(255, 255, 255); border: 1px solid rgb(225, 225, 232); overflow-x: auto; white-space: nowrap;">pom.xml</code></summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre class="prettyprint highlight" style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;"><code data-lang="xml" class="hljs twig" style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(51, 51, 51); font-size: 15px; font-weight: 400; padding: 0px; background: rgb(255, 255, 255); display: block; overflow-x: auto; border: none; white-space: pre-wrap; word-break: break-word;"><button aria-live="Copy" class="button is-spring is-copy" style="box-sizing: inherit; margin: 0px; font-family: BlinkMacSystemFont, -apple-system, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;Fira Sans&quot;, &quot;Droid Sans&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; align-items: center; appearance: none; border: 2px solid rgb(17, 17, 17); border-radius: 0px; box-shadow: none; display: inline-block; font-size: 9px; height: auto; justify-content: center; line-height: 20px; padding: 0px 5px; position: absolute; vertical-align: top; user-select: none; background: transparent; color: rgb(17, 17, 17); cursor: pointer; text-align: center; white-space: nowrap; font-weight: 700; overflow: hidden; text-transform: uppercase; transition: color 0.2s ease-in-out; z-index: 0; right: 5px; top: 5px;">Copy</button><span class="xml" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;"><span class="hljs-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(51, 51, 51);">&lt;<span class="hljs-name" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(99, 163, 92);">dependency</span>&gt;</span>
	<span class="hljs-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(51, 51, 51);">&lt;<span class="hljs-name" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(99, 163, 92);">groupId</span>&gt;</span>org.springframework.boot<span class="hljs-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(51, 51, 51);">&lt;/<span class="hljs-name" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(99, 163, 92);">groupId</span>&gt;</span>
	<span class="hljs-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(51, 51, 51);">&lt;<span class="hljs-name" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(99, 163, 92);">artifactId</span>&gt;</span>spring-boot-starter-hateoas<span class="hljs-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(51, 51, 51);">&lt;/<span class="hljs-name" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(99, 163, 92);">artifactId</span>&gt;</span>
<span class="hljs-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(51, 51, 51);">&lt;/<span class="hljs-name" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(99, 163, 92);">dependency</span>&gt;</span></span></code></pre></div></div></div></details>
```xml
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-hateoas</artifactId>
</dependency>
```



This tiny library gives us the constructs that define a RESTful service and then render it in an acceptable format for client consumption.

这个小型库为我们提供了定义 RESTful 服务的构件，然后以客户端可接受的格式呈现它。

A critical ingredient to any RESTful service is adding [links](https://tools.ietf.org/html/rfc8288) to relevant operations. To make your controller more RESTful, add links like the following to the existing `one` method in `EmployeeController`:

任何 RESTful 服务的关键元素之一是为相关操作添加 [链接](https://tools.ietf.org/html/rfc8288)。为了让你的控制器更符合 REST 风格，可以在 `EmployeeController` 中现有的 `one` 方法里添加如下链接：



* Getting a single item resource

```java
@GetMapping("/employees/{id}")
EntityModel<Employee> one(@PathVariable Long id) {

  Employee employee = repository.findById(id) //
      .orElseThrow(() -> new EmployeeNotFoundException(id));

  return EntityModel.of(employee, //
      linkTo(methodOn(EmployeeController.class).one(id)).withSelfRel(),
      linkTo(methodOn(EmployeeController.class).all()).withRel("employees"));
}

```



You also need to include new imports:

你还需要添加新的导入语句：

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Details</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre class="prettyprint highlight" style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;"><code data-lang="java" class="hljs css" style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(51, 51, 51); font-size: 15px; font-weight: 400; padding: 0px; background: rgb(255, 255, 255); display: block; overflow-x: auto; border: none; white-space: pre-wrap; word-break: break-word;"><button aria-live="Copy" class="button is-spring is-copy" style="box-sizing: inherit; margin: 0px; font-family: BlinkMacSystemFont, -apple-system, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;Fira Sans&quot;, &quot;Droid Sans&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; align-items: center; appearance: none; border: 2px solid rgb(17, 17, 17); border-radius: 0px; box-shadow: none; display: inline-block; font-size: 9px; height: auto; justify-content: center; line-height: 20px; padding: 0px 5px; position: absolute; vertical-align: top; user-select: none; background: transparent; color: rgb(17, 17, 17); cursor: pointer; text-align: center; white-space: nowrap; font-weight: 700; overflow: hidden; text-transform: uppercase; transition: color 0.2s ease-in-out; z-index: 0; right: 5px; top: 5px;">Copy</button><span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> <span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">org</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.springframework</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.hateoas</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.EntityModel</span>;
<span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> <span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">static</span> <span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">org</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.springframework</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.hateoas</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.server</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.mvc</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.WebMvcLinkBuilder</span>.*;</code></pre></div></div></div></details>
This tutorial is based on Spring MVC and uses the static helper methods from `WebMvcLinkBuilder` to build these links. If you are using Spring WebFlux in your project, you must instead use `WebFluxLinkBuilder`.

本教程基于 Spring MVC，并使用 `WebMvcLinkBuilder` 的静态辅助方法来构建这些链接。如果你的项目使用的是 Spring WebFlux，则必须使用 `WebFluxLinkBuilder`。

This is very similar to what we had before, but a few things have changed:

这和之前的情况非常相似，但有一些变化：

- The return type of the method has changed from `Employee` to `EntityModel<Employee>`. `EntityModel<T>` is a generic container from Spring HATEOAS that includes not only the data but a collection of links.

  方法的返回类型从 `Employee` 改为 `EntityModel<Employee>`。`EntityModel<T>` 是 Spring HATEOAS 提供的泛型容器，它不仅包含数据，还包含一组链接。

- `linkTo(methodOn(EmployeeController.class).one(id)).withSelfRel()` asks that Spring HATEOAS build a link to the `one` method of `EmployeeController` and flag it as a [self](https://www.iana.org/assignments/link-relations/link-relations.xhtml) link.

  `linkTo(methodOn(EmployeeController.class).one(id)).withSelfRel()` 会让 Spring HATEOAS 构建指向 `EmployeeController` 中 `one` 方法的链接，并将其标记为 [self](https://www.iana.org/assignments/link-relations/link-relations.xhtml) 链接。

- `linkTo(methodOn(EmployeeController.class).all()).withRel("employees")` asks Spring HATEOAS to build a link to the aggregate root, `all()`, and call it "employees".

  `linkTo(methodOn(EmployeeController.class).all()).withRel("employees")` 会让 Spring HATEOAS 构建指向聚合根 `all()` 方法的链接，并命名为 "employees"。

What do we mean by "build a link?" One of Spring HATEOAS’s core types is `Link`. It includes a **URI** and a **rel** (relation). Links are what empower the web. Before the World Wide Web, other document systems would render information or links, but it was the linking of documents WITH this kind of relationship metadata that stitched the web together.

构建一个链接’是什么意思呢？Spring HATEOAS 的核心类型之一是 `Link`。它包含一个 **URI** 和一个 **rel**（关系）。链接正是让 Web 发挥作用的关键。在万维网出现之前，其他文档系统也会显示信息或链接，但正是带有这种关系元数据的文档链接，把整个 Web 连接了起来。

Roy Fielding encourages building APIs with the same techniques that made the web successful, and links are one of them.

Roy Fielding 鼓励用那些让 Web 成功的技术来构建 API，而链接就是其中之一。

If you restart the application and query the employee record of *Bilbo*, you get a slightly different response than earlier:

如果你重启应用程序并查询 *Bilbo* 的员工记录，你会得到比之前稍微不同的响应：

> **Curling prettier**
> When your curl output gets more complex it can become hard to read. Use this or [other tips](https://stackoverflow.com/q/27238411/5432315) to prettify the json returned by curl:
> 当你的 curl 输出变得更复杂时，可能会难以阅读。可以使用这个方法或其他 技巧
 来美化 curl 返回的 JSON：
> `json_pp`
{: .prompt-tip }

```shell
# The indicated part pipes the output to json_pp and asks it to make your JSON pretty. (Or use whatever tool you like!)
#                                  v------------------v
curl -v localhost:8080/employees/1 | json_pp
```

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">RESTful representation of a single employee</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre class="prettyprint highlight" style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;"><code data-lang="javascript" class="hljs json" style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(51, 51, 51); font-size: 15px; font-weight: 400; padding: 0px; background: rgb(255, 255, 255); display: block; overflow-x: auto; border: none; white-space: pre-wrap; word-break: break-word;"><button aria-live="Copy" class="button is-spring is-copy" style="box-sizing: inherit; margin: 0px; font-family: BlinkMacSystemFont, -apple-system, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;Fira Sans&quot;, &quot;Droid Sans&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; align-items: center; appearance: none; border: 2px solid rgb(17, 17, 17); border-radius: 0px; box-shadow: none; display: inline-block; font-size: 9px; height: auto; justify-content: center; line-height: 20px; padding: 0px 5px; position: absolute; vertical-align: top; user-select: none; background: transparent; color: rgb(17, 17, 17); cursor: pointer; text-align: center; white-space: nowrap; font-weight: 700; overflow: hidden; text-transform: uppercase; transition: color 0.2s ease-in-out; z-index: 0; right: 5px; top: 5px;">Copy</button>{
  <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"id"</span>: <span class="hljs-number" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(0, 92, 197);">1</span>,
  <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"name"</span>: <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"Bilbo Baggins"</span>,
  <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"role"</span>: <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"burglar"</span>,
  <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"_links"</span>: {
    <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"self"</span>: {
      <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"href"</span>: <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"http://localhost:8080/employees/1"</span>
    },
    <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"employees"</span>: {
      <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"href"</span>: <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"http://localhost:8080/employees"</span>
    }
  }
}</code></pre></div></div></div></details>

This decompressed output shows not only the data elements you saw earlier (`id`, `name`, and `role`) but also a `_links` entry that contains two URIs. This entire document is formatted using [HAL](http://stateless.co/hal_specification.html).

HAL is a lightweight [mediatype](https://tools.ietf.org/html/draft-kelly-json-hal-08) that allows encoding not only data but also hypermedia controls, alerting consumers to other parts of the API to which they can navigate. In this case, there is a "self" link (kind of like a `this` statement in code) along with a link back to the **aggregate root**.

To make the aggregate root also be more RESTful, you want to include top level links while also including any RESTful components within.

So we modify the following (located in the `nonrest` module of the completed code):

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Getting an aggregate root</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre class="prettyprint highlight" style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;"><code data-lang="java" class="hljs kotlin" style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(51, 51, 51); font-size: 15px; font-weight: 400; padding: 0px; background: rgb(255, 255, 255); display: block; overflow-x: auto; border: none; white-space: pre-wrap; word-break: break-word;"><button aria-live="Copy" class="button is-spring is-copy" style="box-sizing: inherit; margin: 0px; font-family: BlinkMacSystemFont, -apple-system, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;Fira Sans&quot;, &quot;Droid Sans&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; align-items: center; appearance: none; border: 2px solid rgb(17, 17, 17); border-radius: 0px; box-shadow: none; display: inline-block; font-size: 9px; height: auto; justify-content: center; line-height: 20px; padding: 0px 5px; position: absolute; vertical-align: top; user-select: none; background: transparent; color: rgb(17, 17, 17); cursor: pointer; text-align: center; white-space: nowrap; font-weight: 700; overflow: hidden; text-transform: uppercase; transition: color 0.2s ease-in-out; z-index: 0; right: 5px; top: 5px;">Copy</button><span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@GetMapping(<span class="hljs-meta-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">"/employees"</span>)</span>
List&lt;Employee&gt; all() {
  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> repository.findAll();
}</code></pre></div></div></div></details>

We want the following (located in the `rest` module of the completed code):

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Getting an aggregate root<span>&nbsp;</span><strong style="box-sizing: inherit; color: inherit; font-weight: inherit;">resource</strong></summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre class="prettyprint highlight" style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;"><code data-lang="java" class="hljs kotlin" style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(51, 51, 51); font-size: 15px; font-weight: 400; padding: 0px; background: rgb(255, 255, 255); display: block; overflow-x: auto; border: none; white-space: pre-wrap; word-break: break-word;"><button aria-live="Copy" class="button is-spring is-copy" style="box-sizing: inherit; margin: 0px; font-family: BlinkMacSystemFont, -apple-system, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;Fira Sans&quot;, &quot;Droid Sans&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; align-items: center; appearance: none; border: 2px solid rgb(17, 17, 17); border-radius: 0px; box-shadow: none; display: inline-block; font-size: 9px; height: auto; justify-content: center; line-height: 20px; padding: 0px 5px; position: absolute; vertical-align: top; user-select: none; background: transparent; color: rgb(17, 17, 17); cursor: pointer; text-align: center; white-space: nowrap; font-weight: 700; overflow: hidden; text-transform: uppercase; transition: color 0.2s ease-in-out; z-index: 0; right: 5px; top: 5px;">Copy</button><span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@GetMapping(<span class="hljs-meta-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">"/employees"</span>)</span>
CollectionModel&lt;EntityModel&lt;Employee&gt;&gt; all() {

  List&lt;EntityModel&lt;Employee&gt;&gt; employees = repository.findAll().stream()
      .map(employee -&gt; EntityModel.of(employee,
          linkTo(methodOn(EmployeeController<span class="hljs-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">.<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">class</span>).<span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">one</span></span>(employee.getId())).withSelfRel(),
          linkTo(methodOn(EmployeeController<span class="hljs-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">.<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">class</span>).<span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">all</span></span>()).withRel(<span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"employees"</span>)))
      .collect(Collectors.toList());

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> CollectionModel.of(employees, linkTo(methodOn(EmployeeController<span class="hljs-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">.<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">class</span>).<span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">all</span></span>()).withSelfRel());
}</code></pre></div></div></div></details>

That method, which used to be merely `repository.findAll()`, is "all grown up."" Not to worry. Now we can unpack it.

`CollectionModel<>` is another Spring HATEOAS container. It is aimed at encapsulating collections of resources instead of a single resource entity, such as `EntityModel<>` from earlier. `CollectionModel<>`, too, lets you include links.

Do not let that first statement slip by. What does "encapsulating collections" mean? Collections of employees?

Not quite.

Since we are talking REST, it should encapsulate collections of **employee resources**.

That is why you fetch all the employees but then transform them into a list of `EntityModel<Employee>` objects. (Thanks Java Streams!)

If you restart the application and fetch the aggregate root, you can see what it looks like now:

```
curl -v localhost:8080/employees | json_pp
```

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">RESTful representation of a collection of employee resources</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre class="prettyprint highlight" style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;"><code data-lang="javascript" class="hljs json" style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(51, 51, 51); font-size: 15px; font-weight: 400; padding: 0px; background: rgb(255, 255, 255); display: block; overflow-x: auto; border: none; white-space: pre-wrap; word-break: break-word;"><button aria-live="Copy" class="button is-spring is-copy" style="box-sizing: inherit; margin: 0px; font-family: BlinkMacSystemFont, -apple-system, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;Fira Sans&quot;, &quot;Droid Sans&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; align-items: center; appearance: none; border: 2px solid rgb(17, 17, 17); border-radius: 0px; box-shadow: none; display: inline-block; font-size: 9px; height: auto; justify-content: center; line-height: 20px; padding: 0px 5px; position: absolute; vertical-align: top; user-select: none; background: transparent; color: rgb(17, 17, 17); cursor: pointer; text-align: center; white-space: nowrap; font-weight: 700; overflow: hidden; text-transform: uppercase; transition: color 0.2s ease-in-out; z-index: 0; right: 5px; top: 5px;">Copy</button>{
  <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"_embedded"</span>: {
    <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"employeeList"</span>: [
      {
        <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"id"</span>: <span class="hljs-number" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(0, 92, 197);">1</span>,
        <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"name"</span>: <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"Bilbo Baggins"</span>,
        <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"role"</span>: <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"burglar"</span>,
        <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"_links"</span>: {
          <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"self"</span>: {
            <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"href"</span>: <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"http://localhost:8080/employees/1"</span>
          },
          <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"employees"</span>: {
            <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"href"</span>: <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"http://localhost:8080/employees"</span>
          }
        }
      },
      {
        <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"id"</span>: <span class="hljs-number" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(0, 92, 197);">2</span>,
        <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"name"</span>: <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"Frodo Baggins"</span>,
        <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"role"</span>: <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"thief"</span>,
        <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"_links"</span>: {
          <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"self"</span>: {
            <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"href"</span>: <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"http://localhost:8080/employees/2"</span>
          },
          <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"employees"</span>: {
            <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"href"</span>: <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"http://localhost:8080/employees"</span>
          }
        }
      }
    ]
  },
  <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"_links"</span>: {
    <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"self"</span>: {
      <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"href"</span>: <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"http://localhost:8080/employees"</span>
    }
  }
}</code></pre></div></div></div></details>

For this aggregate root, which serves up a collection of employee resources, there is a top-level **"self"** link. The **"collection"** is listed underneath the **"_embedded"** section. This is how HAL represents collections.

Each individual member of the collection has their information as well as related links.

What is the point of adding all these links? It makes it possible to evolve REST services over time. Existing links can be maintained while new links can be added in the future. Newer clients may take advantage of the new links, while legacy clients can sustain themselves on the old links. This is especially helpful if services get relocated and moved around. As long as the link structure is maintained, clients can still find and interact with things.

## Simplifying Link Creation

If you are following along in the [solution repository](https://github.com/spring-guides/tut-rest), the next section switches to the [evolution module](https://github.com/spring-guides/tut-rest/tree/main/evolution).

In the code earlier, did you notice the repetition in single employee link creation? The code to provide a single link to an employee, as well as to create an "employees" link to the aggregate root, was shown twice. If that raised a concern, good! There’s a solution.

You need to define a function that converts `Employee` objects to `EntityModel<Employee>` objects. While you could easily code this method yourself, Spring HATEOAS’s `RepresentationModelAssembler` interface does the work for you. Create a new class `EmployeeModelAssembler`:

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">evolution/src/main/java/payroll/EmployeeModelAssembler.java</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre class="prettyprint highlight" style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;"><code data-lang="java" class="hljs kotlin" style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(51, 51, 51); font-size: 15px; font-weight: 400; padding: 0px; background: rgb(255, 255, 255); display: block; overflow-x: auto; border: none; white-space: pre-wrap; word-break: break-word;"><button aria-live="Copy" class="button is-spring is-copy" style="box-sizing: inherit; margin: 0px; font-family: BlinkMacSystemFont, -apple-system, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;Fira Sans&quot;, &quot;Droid Sans&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; align-items: center; appearance: none; border: 2px solid rgb(17, 17, 17); border-radius: 0px; box-shadow: none; display: inline-block; font-size: 9px; height: auto; justify-content: center; line-height: 20px; padding: 0px 5px; position: absolute; vertical-align: top; user-select: none; background: transparent; color: rgb(17, 17, 17); cursor: pointer; text-align: center; white-space: nowrap; font-weight: 700; overflow: hidden; text-transform: uppercase; transition: color 0.2s ease-in-out; z-index: 0; right: 5px; top: 5px;">Copy</button><span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">package</span> payroll;

<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.*;

<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> org.springframework.hateoas.EntityModel;
<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> org.springframework.hateoas.server.RepresentationModelAssembler;
<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> org.springframework.stereotype.Component;

<span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@Component</span>
<span class="hljs-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;"><span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">class</span> <span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">EmployeeModelAssembler</span> <span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">implements</span> <span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">RepresentationModelAssembler</span>&lt;<span class="hljs-type" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">Employee, EntityModel&lt;Employee</span>&gt;&gt; </span>{

  <span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@Override</span>
  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">public</span> EntityModel&lt;Employee&gt; toModel(Employee employee) {

    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> EntityModel.of(employee, <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
        linkTo(methodOn(EmployeeController<span class="hljs-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">.<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">class</span>).<span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">one</span></span>(employee.getId())).withSelfRel(),
        linkTo(methodOn(EmployeeController<span class="hljs-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">.<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">class</span>).<span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">all</span></span>()).withRel(<span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"employees"</span>));
  }
}</code></pre></div></div></div></details>

This simple interface has one method: `toModel()`. It is based on converting a non-model object (`Employee`) into a model-based object (`EntityModel<Employee>`).

All the code you saw earlier in the controller can be moved into this class. Also, by applying Spring Framework’s `@Component` annotation, the assembler is automatically created when the app starts.

Spring HATEOAS’s abstract base class for all models is `RepresentationModel`. However, for simplicity, we recommend using `EntityModel<T>` as your mechanism to easily wrap all POJOs as models.

To leverage this assembler, you have only to alter the `EmployeeController` by injecting the assembler in the constructor:

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Injecting EmployeeModelAssembler into the controller</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre class="prettyprint highlight" style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;"><code data-lang="java" class="hljs kotlin" style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(51, 51, 51); font-size: 15px; font-weight: 400; padding: 0px; background: rgb(255, 255, 255); display: block; overflow-x: auto; border: none; white-space: pre-wrap; word-break: break-word;"><button aria-live="Copy" class="button is-spring is-copy" style="box-sizing: inherit; margin: 0px; font-family: BlinkMacSystemFont, -apple-system, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;Fira Sans&quot;, &quot;Droid Sans&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; align-items: center; appearance: none; border: 2px solid rgb(17, 17, 17); border-radius: 0px; box-shadow: none; display: inline-block; font-size: 9px; height: auto; justify-content: center; line-height: 20px; padding: 0px 5px; position: absolute; vertical-align: top; user-select: none; background: transparent; color: rgb(17, 17, 17); cursor: pointer; text-align: center; white-space: nowrap; font-weight: 700; overflow: hidden; text-transform: uppercase; transition: color 0.2s ease-in-out; z-index: 0; right: 5px; top: 5px;">Copy</button><span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@RestController</span>
<span class="hljs-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;"><span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">class</span> <span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">EmployeeController</span> </span>{

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">private</span> <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">final</span> EmployeeRepository repository;

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">private</span> <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">final</span> EmployeeModelAssembler assembler;

  EmployeeController(EmployeeRepository repository, EmployeeModelAssembler assembler) {

    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.repository = repository;
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.assembler = assembler;
  }

  ...

}</code></pre></div></div></div></details>

From here, you can use that assembler in the single-item employee method `one` that already exists in `EmployeeController`:

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Getting single item resource using the assembler</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;">	@GetMapping("/employees/{id}")
	EntityModel&lt;Employee&gt; one(@PathVariable Long id) {

		Employee employee = repository.findById(id) //
				.orElseThrow(() -&gt; new EmployeeNotFoundException(id));
	
		return assembler.toModel(employee);
	}</pre></div></div></div></details>

This code is almost the same, except that, instead of creating the `EntityModel<Employee>` instance here, you delegate it to the assembler. Maybe that is not impressive.

Applying the same thing in the aggregate root controller method is more impressive. This change is also to the `EmployeeController` class:

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Getting aggregate root resource using the assembler</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre class="prettyprint highlight" style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;"><code data-lang="java" class="hljs kotlin" style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(51, 51, 51); font-size: 15px; font-weight: 400; padding: 0px; background: rgb(255, 255, 255); display: block; overflow-x: auto; border: none; white-space: pre-wrap; word-break: break-word;"><button aria-live="Copy" class="button is-spring is-copy" style="box-sizing: inherit; margin: 0px; font-family: BlinkMacSystemFont, -apple-system, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;Fira Sans&quot;, &quot;Droid Sans&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; align-items: center; appearance: none; border: 2px solid rgb(17, 17, 17); border-radius: 0px; box-shadow: none; display: inline-block; font-size: 9px; height: auto; justify-content: center; line-height: 20px; padding: 0px 5px; position: absolute; vertical-align: top; user-select: none; background: transparent; color: rgb(17, 17, 17); cursor: pointer; text-align: center; white-space: nowrap; font-weight: 700; overflow: hidden; text-transform: uppercase; transition: color 0.2s ease-in-out; z-index: 0; right: 5px; top: 5px;">Copy</button><span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@GetMapping(<span class="hljs-meta-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">"/employees"</span>)</span>
CollectionModel&lt;EntityModel&lt;Employee&gt;&gt; all() {

  List&lt;EntityModel&lt;Employee&gt;&gt; employees = repository.findAll().stream() <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
      .map(assembler::toModel) <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
      .collect(Collectors.toList());

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> CollectionModel.of(employees, linkTo(methodOn(EmployeeController<span class="hljs-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">.<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">class</span>).<span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">all</span></span>()).withSelfRel());
}</code></pre></div></div></div></details>

The code is, again, almost the same. However, you get to replace all that `EntityModel<Employee>` creation logic with `map(assembler::toModel)`. Thanks to Java method references, it is super easy to plug in and simplify your controller.

A key design goal of Spring HATEOAS is to make it easier to do The Right Thing™. In this scenario, that means adding hypermedia to your service without hard coding a thing.

At this stage, you have created a Spring MVC REST controller that actually produces hypermedia-powered content. Clients that do not speak HAL can ignore the extra bits while consuming the pure data. Clients that do speak HAL can navigate your empowered API.

But that is not the only thing needed to build a truly RESTful service with Spring.

## Evolving REST APIs

With one additional library and a few lines of extra code, you have added hypermedia to your application. But that is not the only thing needed to make your service RESTful. An important facet of REST is the fact that it is neither a technology stack nor a single standard.

REST is a collection of architectural constraints that, when adopted, make your application much more resilient. A key factor of resilience is that when you make upgrades to your services, your clients do not suffer downtime.

In the "olden" days, upgrades were notorious for breaking clients. In other words, an upgrade to the server required an update to the client. In this day and age, hours or even minutes of downtime spent doing an upgrade can cost millions in lost revenue.

Some companies require that you present management with a plan to minimize downtime. In the past, you could get away with upgrading at 2:00 a.m. on a Sunday when load was at a minimum. But in today’s Internet-based e-commerce with international customers in other time zones, such strategies are not as effective.

[SOAP-based services](https://www.tutorialspoint.com/soap/what_is_soap.htm) and [CORBA-based services](https://www.corba.org/faq.htm) were incredibly brittle. It was hard to roll out a server that could support both old and new clients. With REST-based practices, it is much easier, especially using the Spring stack.

### Supporting Changes to the API

Imagine this design problem: You have rolled out a system with this `Employee`-based record. The system is a major hit. You have sold your system to countless enterprises. Suddenly, the need for an employee’s name to be split into `firstName` and `lastName` arises.

Uh oh. You did not think of that.

Before you open up the `Employee` class and replace the single field `name` with `firstName` and `lastName`, stop and think. Does that break any clients? How long will it take to upgrade them? Do you even control all the clients accessing your services?

Downtime = lost money. Is management ready for that?

There is an old strategy that precedes REST by years.

> Never delete a column in a database.

— Unknown

You can always add columns (fields) to a database table. But do not take one away. The principle in RESTful services is the same.

Add new fields to your JSON representations, but do not take any away. Like this:

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">JSON that supports multiple clients</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre class="prettyprint highlight" style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;"><code data-lang="javascript" class="hljs json" style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(51, 51, 51); font-size: 15px; font-weight: 400; padding: 0px; background: rgb(255, 255, 255); display: block; overflow-x: auto; border: none; white-space: pre-wrap; word-break: break-word;"><button aria-live="Copy" class="button is-spring is-copy" style="box-sizing: inherit; margin: 0px; font-family: BlinkMacSystemFont, -apple-system, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;Fira Sans&quot;, &quot;Droid Sans&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; align-items: center; appearance: none; border: 2px solid rgb(17, 17, 17); border-radius: 0px; box-shadow: none; display: inline-block; font-size: 9px; height: auto; justify-content: center; line-height: 20px; padding: 0px 5px; position: absolute; vertical-align: top; user-select: none; background: transparent; color: rgb(17, 17, 17); cursor: pointer; text-align: center; white-space: nowrap; font-weight: 700; overflow: hidden; text-transform: uppercase; transition: color 0.2s ease-in-out; z-index: 0; right: 5px; top: 5px;">Copy</button>{
  <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"id"</span>: <span class="hljs-number" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(0, 92, 197);">1</span>,
  <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"firstName"</span>: <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"Bilbo"</span>,
  <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"lastName"</span>: <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"Baggins"</span>,
  <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"role"</span>: <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"burglar"</span>,
  <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"name"</span>: <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"Bilbo Baggins"</span>,
  <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"_links"</span>: {
    <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"self"</span>: {
      <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"href"</span>: <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"http://localhost:8080/employees/1"</span>
    },
    <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"employees"</span>: {
      <span class="hljs-attr" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">"href"</span>: <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"http://localhost:8080/employees"</span>
    }
  }
}</code></pre></div></div></div></details>

This format shows `firstName`, `lastName`, and `name`. While it sports duplication of information, the purpose is to support both old and new clients. That means you can upgrade the server without requiring clients to upgrade at the same time. This is good move that should reduce downtime.

Not only should you show this information in both the "old way" and the "new way", but you should also process incoming data both ways.

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Employee record that handles both "old" and "new" clients</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre class="prettyprint highlight" style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;"><code data-lang="java" class="hljs kotlin" style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(51, 51, 51); font-size: 15px; font-weight: 400; padding: 0px; background: rgb(255, 255, 255); display: block; overflow-x: auto; border: none; white-space: pre-wrap; word-break: break-word;"><button aria-live="Copy" class="button is-spring is-copy" style="box-sizing: inherit; margin: 0px; font-family: BlinkMacSystemFont, -apple-system, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;Fira Sans&quot;, &quot;Droid Sans&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; align-items: center; appearance: none; border: 2px solid rgb(17, 17, 17); border-radius: 0px; box-shadow: none; display: inline-block; font-size: 9px; height: auto; justify-content: center; line-height: 20px; padding: 0px 5px; position: absolute; vertical-align: top; user-select: none; background: transparent; color: rgb(17, 17, 17); cursor: pointer; text-align: center; white-space: nowrap; font-weight: 700; overflow: hidden; text-transform: uppercase; transition: color 0.2s ease-in-out; z-index: 0; right: 5px; top: 5px;">Copy</button><span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">package</span> payroll;

<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> java.util.Objects;

<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> jakarta.persistence.Entity;
<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> jakarta.persistence.GeneratedValue;
<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> jakarta.persistence.Id;

<span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@Entity</span>
<span class="hljs-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;"><span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">class</span> <span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">Employee</span> </span>{

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">private</span> <span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@Id</span> <span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@GeneratedValue</span> <span class="hljs-built_in" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">Long</span> id;
  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">private</span> String firstName;
  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">private</span> String lastName;
  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">private</span> String role;

  Employee() {}

  Employee(String firstName, String lastName, String role) {

    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.firstName = firstName;
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.lastName = lastName;
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.role = role;
  }

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">public</span> String getName() {
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.firstName + <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">" "</span> + <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.lastName;
  }

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">public</span> void setName(String name) {
    String[] parts = name.split(<span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">" "</span>);
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.firstName = parts[<span class="hljs-number" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(0, 92, 197);">0</span>];
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.lastName = parts[<span class="hljs-number" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(0, 92, 197);">1</span>];
  }

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">public</span> <span class="hljs-built_in" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">Long</span> getId() {
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.id;
  }

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">public</span> String getFirstName() {
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.firstName;
  }

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">public</span> String getLastName() {
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.lastName;
  }

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">public</span> String getRole() {
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.role;
  }

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">public</span> void setId(<span class="hljs-built_in" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">Long</span> id) {
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.id = id;
  }

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">public</span> void setFirstName(String firstName) {
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.firstName = firstName;
  }

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">public</span> void setLastName(String lastName) {
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.lastName = lastName;
  }

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">public</span> void setRole(String role) {
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.role = role;
  }

  <span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@Override</span>
  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">public</span> boolean equals(Object o) {

    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">if</span> (<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span> == o)
      <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> <span class="hljs-literal" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(0, 134, 179);">true</span>;
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">if</span> (!(o instanceof Employee))
      <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> <span class="hljs-literal" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(0, 134, 179);">false</span>;
    Employee employee = (Employee) o;
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> Objects.equals(<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.id, employee.id) &amp;&amp; Objects.equals(<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.firstName, employee.firstName)
        &amp;&amp; Objects.equals(<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.lastName, employee.lastName) &amp;&amp; Objects.equals(<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.role, employee.role);
  }

  <span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@Override</span>
  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">public</span> int hashCode() {
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> Objects.hash(<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.id, <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.firstName, <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.lastName, <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.role);
  }

  <span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@Override</span>
  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">public</span> String toString() {
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"Employee{"</span> + <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"id="</span> + <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.id + <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">", firstName='"</span> + <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.firstName + <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">'\''</span> + <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">", lastName='"</span> + <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.lastName
        + <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">'\''</span> + <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">", role='"</span> + <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.role + <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">'\''</span> + <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">'}'</span>;
  }
}</code></pre></div></div></div></details>

This class is similar to the previous version of `Employee`, with a few changes:

- Field `name` has been replaced by `firstName` and `lastName`.
- A "virtual" getter for the old `name` property, `getName()`, is defined. It uses the `firstName` and `lastName` fields to produce a value.
- A "virtual" setter for the old `name` property, `setName()`, is also defined. It parses an incoming string and stores it into the proper fields.

Of course, not change to your API is as simple as splitting a string or merging two strings. But itis surely not impossible to come up with a set of transforms for most scenarios, right?

Do not forget to change how you preload your database (in `LoadDatabase`) to use this new constructor.`Copylog.info("Preloading " + repository.save(new Employee("Bilbo", "Baggins", "burglar"))); log.info("Preloading " + repository.save(new Employee("Frodo", "Baggins", "thief")));`

#### Proper Responses

Another step in the right direction involves ensuring that each of your REST methods returns a proper response. Update the POST method (`newEmployee`) in the `EmployeeController`:

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">POST that handles "old" and "new" client requests</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre class="prettyprint highlight" style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;"><code data-lang="java" class="hljs kotlin" style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(51, 51, 51); font-size: 15px; font-weight: 400; padding: 0px; background: rgb(255, 255, 255); display: block; overflow-x: auto; border: none; white-space: pre-wrap; word-break: break-word;"><button aria-live="Copy" class="button is-spring is-copy" style="box-sizing: inherit; margin: 0px; font-family: BlinkMacSystemFont, -apple-system, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;Fira Sans&quot;, &quot;Droid Sans&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; align-items: center; appearance: none; border: 2px solid rgb(17, 17, 17); border-radius: 0px; box-shadow: none; display: inline-block; font-size: 9px; height: auto; justify-content: center; line-height: 20px; padding: 0px 5px; position: absolute; vertical-align: top; user-select: none; background: transparent; color: rgb(17, 17, 17); cursor: pointer; text-align: center; white-space: nowrap; font-weight: 700; overflow: hidden; text-transform: uppercase; transition: color 0.2s ease-in-out; z-index: 0; right: 5px; top: 5px;">Copy</button><span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@PostMapping(<span class="hljs-meta-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">"/employees"</span>)</span>
ResponseEntity&lt;?&gt; newEmployee(<span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@RequestBody</span> Employee newEmployee) {

  EntityModel&lt;Employee&gt; entityModel = assembler.toModel(repository.save(newEmployee));

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> ResponseEntity <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
      .created(entityModel.getRequiredLink(IanaLinkRelations.SELF).toUri()) <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
      .body(entityModel);
}</code></pre></div></div></div></details>

You also need to add the imports:

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Details</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre class="prettyprint highlight" style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;"><code data-lang="java" class="hljs css" style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(51, 51, 51); font-size: 15px; font-weight: 400; padding: 0px; background: rgb(255, 255, 255); display: block; overflow-x: auto; border: none; white-space: pre-wrap; word-break: break-word;"><button aria-live="Copy" class="button is-spring is-copy" style="box-sizing: inherit; margin: 0px; font-family: BlinkMacSystemFont, -apple-system, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;Fira Sans&quot;, &quot;Droid Sans&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; align-items: center; appearance: none; border: 2px solid rgb(17, 17, 17); border-radius: 0px; box-shadow: none; display: inline-block; font-size: 9px; height: auto; justify-content: center; line-height: 20px; padding: 0px 5px; position: absolute; vertical-align: top; user-select: none; background: transparent; color: rgb(17, 17, 17); cursor: pointer; text-align: center; white-space: nowrap; font-weight: 700; overflow: hidden; text-transform: uppercase; transition: color 0.2s ease-in-out; z-index: 0; right: 5px; top: 5px;">Copy</button><span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> <span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">org</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.springframework</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.hateoas</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.IanaLinkRelations</span>;
<span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> <span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">org</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.springframework</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.http</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.ResponseEntity</span>;</code></pre></div></div></div></details>

- The new `Employee` object is saved, as before. However, the resulting object is wrapped in the `EmployeeModelAssembler`.
- Spring MVC’s `ResponseEntity` is used to create an **HTTP 201 Created** status message. This type of response typically includes a **Location** response header, and we use the URI derived from the model’s self-related link.
- Additionally, the model-based version of the saved object is returned.

With these tweaks in place, you can use the same endpoint to create a new employee resource and use the legacy `name` field:

```
$ curl -v -X POST localhost:8080/employees -H 'Content-Type:application/json' -d '{"name": "Samwise Gamgee", "role": "gardener"}' | json_pp
```

The output is as follows:

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Details</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;">&gt; POST /employees HTTP/1.1
&gt; Host: localhost:8080
&gt; User-Agent: curl/7.54.0
&gt; Accept: */*
&gt; Content-Type:application/json
&gt; Content-Length: 46
&gt;
&lt; Location: http://localhost:8080/employees/3
&lt; Content-Type: application/hal+json;charset=UTF-8
&lt; Transfer-Encoding: chunked
&lt; Date: Fri, 10 Aug 20yy 19:44:43 GMT
&lt;
{
  "id": 3,
  "firstName": "Samwise",
  "lastName": "Gamgee",
  "role": "gardener",
  "name": "Samwise Gamgee",
  "_links": {
    "self": {
      "href": "http://localhost:8080/employees/3"
    },
    "employees": {
      "href": "http://localhost:8080/employees"
    }
  }
}</pre></div></div></div></details>

This not only has the resulting object rendered in HAL (both `name` as well as `firstName` and `lastName`), but also the **Location** header populated with `http://localhost:8080/employees/3`. A hypermedia-powered client could opt to "surf" to this new resource and proceed to interact with it.

The PUT controller method (`replaceEmployee`) in `EmployeeController` needs similar tweaks:

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Handling a PUT for different clients</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre class="prettyprint highlight" style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;"><code data-lang="java" class="hljs kotlin" style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(51, 51, 51); font-size: 15px; font-weight: 400; padding: 0px; background: rgb(255, 255, 255); display: block; overflow-x: auto; border: none; white-space: pre-wrap; word-break: break-word;"><button aria-live="Copy" class="button is-spring is-copy" style="box-sizing: inherit; margin: 0px; font-family: BlinkMacSystemFont, -apple-system, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;Fira Sans&quot;, &quot;Droid Sans&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; align-items: center; appearance: none; border: 2px solid rgb(17, 17, 17); border-radius: 0px; box-shadow: none; display: inline-block; font-size: 9px; height: auto; justify-content: center; line-height: 20px; padding: 0px 5px; position: absolute; vertical-align: top; user-select: none; background: transparent; color: rgb(17, 17, 17); cursor: pointer; text-align: center; white-space: nowrap; font-weight: 700; overflow: hidden; text-transform: uppercase; transition: color 0.2s ease-in-out; z-index: 0; right: 5px; top: 5px;">Copy</button><span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@PutMapping(<span class="hljs-meta-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">"/employees/{id}"</span>)</span>
ResponseEntity&lt;?&gt; replaceEmployee(<span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@RequestBody</span> Employee newEmployee, <span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@PathVariable</span> <span class="hljs-built_in" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">Long</span> id) {

  Employee updatedEmployee = repository.findById(id) <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
      .map(employee -&gt; {
        employee.setName(newEmployee.getName());
        employee.setRole(newEmployee.getRole());
        <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> repository.save(employee);
      }) <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
      .orElseGet(() -&gt; {
        <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> repository.save(newEmployee);
      });

  EntityModel&lt;Employee&gt; entityModel = assembler.toModel(updatedEmployee);

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> ResponseEntity <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
      .created(entityModel.getRequiredLink(IanaLinkRelations.SELF).toUri()) <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
      .body(entityModel);
}</code></pre></div></div></div></details>

The `Employee` object built by the `save()` operation is then wrapped in the `EmployeeModelAssembler` to create an `EntityModel<Employee>` object. Using the `getRequiredLink()` method, you can retrieve the `Link` created by the `EmployeeModelAssembler` with a `SELF` rel. This method returns a `Link`, which must be turned into a `URI` with the `toUri` method.

Since we want a more detailed HTTP response code than **200 OK**, we use Spring MVC’s `ResponseEntity` wrapper. It has a handy static method (`created()`) where we can plug in the resource’s URI. It is debatable whether **HTTP 201 Created** carries the right semantics, since we do not necessarily "create" a new resource. However, it comes pre-loaded with a **Location** response header, so we use it. Restart your application, run the following command, and observe the results:

```
$ curl -v -X PUT localhost:8080/employees/3 -H 'Content-Type:application/json' -d '{"name": "Samwise Gamgee", "role": "ring bearer"}' | json_pp
```

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Details</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;">* TCP_NODELAY set
* Connected to localhost (::1) port 8080 (#0)
&gt; PUT /employees/3 HTTP/1.1
&gt; Host: localhost:8080
&gt; User-Agent: curl/7.54.0
&gt; Accept: */*
&gt; Content-Type:application/json
&gt; Content-Length: 49
&gt;
&lt; HTTP/1.1 201
&lt; Location: http://localhost:8080/employees/3
&lt; Content-Type: application/hal+json;charset=UTF-8
&lt; Transfer-Encoding: chunked
&lt; Date: Fri, 10 Aug 20yy 19:52:56 GMT
{
	"id": 3,
	"firstName": "Samwise",
	"lastName": "Gamgee",
	"role": "ring bearer",
	"name": "Samwise Gamgee",
	"_links": {
		"self": {
			"href": "http://localhost:8080/employees/3"
		},
		"employees": {
			"href": "http://localhost:8080/employees"
		}
	}
}</pre></div></div></div></details>

That employee resource has now been updated and the location URI has been sent back. Finally, update the DELETE operation (`deleteEmployee`) in `EmployeeController`:

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Handling DELETE requests</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre class="prettyprint highlight" style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;"><code data-lang="java" class="hljs css" style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(51, 51, 51); font-size: 15px; font-weight: 400; padding: 0px; background: rgb(255, 255, 255); display: block; overflow-x: auto; border: none; white-space: pre-wrap; word-break: break-word;"><button aria-live="Copy" class="button is-spring is-copy" style="box-sizing: inherit; margin: 0px; font-family: BlinkMacSystemFont, -apple-system, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;Fira Sans&quot;, &quot;Droid Sans&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; align-items: center; appearance: none; border: 2px solid rgb(17, 17, 17); border-radius: 0px; box-shadow: none; display: inline-block; font-size: 9px; height: auto; justify-content: center; line-height: 20px; padding: 0px 5px; position: absolute; vertical-align: top; user-select: none; background: transparent; color: rgb(17, 17, 17); cursor: pointer; text-align: center; white-space: nowrap; font-weight: 700; overflow: hidden; text-transform: uppercase; transition: color 0.2s ease-in-out; z-index: 0; right: 5px; top: 5px;">Copy</button>@<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">DeleteMapping</span>("/<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">employees</span>/{<span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">id</span>}")
<span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">ResponseEntity</span>&lt;?&gt; <span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">deleteEmployee</span>(@<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">PathVariable</span> Long id) {

  <span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">repository</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.deleteById</span>(<span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">id</span>);

  <span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> <span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">ResponseEntity</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.noContent</span>()<span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.build</span>();
}</code></pre></div></div></div></details>

This returns an **HTTP 204 No Content** response. Restart your application, run the following command, and observe the results:

```
$ curl -v -X DELETE localhost:8080/employees/1
```

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Details</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;">* TCP_NODELAY set
* Connected to localhost (::1) port 8080 (#0)
&gt; DELETE /employees/1 HTTP/1.1
&gt; Host: localhost:8080
&gt; User-Agent: curl/7.54.0
&gt; Accept: */*
&gt;
&lt; HTTP/1.1 204
&lt; Date: Fri, 10 Aug 20yy 21:30:26 GMT</pre></div></div></div></details>

Making changes to the fields in the `Employee` class requires coordination with your database team, so that they can properly migrate existing content into the new columns.

You are now ready for an upgrade that does not disturb existing clients while newer clients can take advantage of the enhancements.

By the way, are you worried about sending too much information over the wire? In some systems where every byte counts, evolution of APIs may need to take a backseat. However, you should not pursue such premature optimization until you measure the impact of your changes.

## Building links into your REST API

If you are following along in the [solution repository](https://github.com/spring-guides/tut-rest), the next section switches to the [links module](https://github.com/spring-guides/tut-rest/tree/main/links).

So far, you have built an evolvable API with bare bones links. To grow your API and better serve your clients, you need to embrace the concept of **Hypermedia as the Engine of Application State**.

What does that mean? This section explores it in detail.

Business logic inevitably builds up rules that involve processes. The risk of such systems is we often carry such server-side logic into clients and build up strong coupling. REST is about breaking down such connections and minimizing such coupling.

To show how to cope with state changes without triggering breaking changes in clients, imagine adding a system that fulfills orders.

As a first step, define a new `Order` record:

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">links/src/main/java/payroll/Order.java</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre class="prettyprint highlight" style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;"><code data-lang="java" class="hljs kotlin" style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(51, 51, 51); font-size: 15px; font-weight: 400; padding: 0px; background: rgb(255, 255, 255); display: block; overflow-x: auto; border: none; white-space: pre-wrap; word-break: break-word;"><button aria-live="Copy" class="button is-spring is-copy" style="box-sizing: inherit; margin: 0px; font-family: BlinkMacSystemFont, -apple-system, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;Fira Sans&quot;, &quot;Droid Sans&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; align-items: center; appearance: none; border: 2px solid rgb(17, 17, 17); border-radius: 0px; box-shadow: none; display: inline-block; font-size: 9px; height: auto; justify-content: center; line-height: 20px; padding: 0px 5px; position: absolute; vertical-align: top; user-select: none; background: transparent; color: rgb(17, 17, 17); cursor: pointer; text-align: center; white-space: nowrap; font-weight: 700; overflow: hidden; text-transform: uppercase; transition: color 0.2s ease-in-out; z-index: 0; right: 5px; top: 5px;">Copy</button><span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">package</span> payroll;

<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> java.util.Objects;

<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> jakarta.persistence.Entity;
<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> jakarta.persistence.GeneratedValue;
<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> jakarta.persistence.Id;
<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> jakarta.persistence.Table;

<span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@Entity</span>
<span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@Table(name = <span class="hljs-meta-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">"CUSTOMER_ORDER"</span>)</span>
<span class="hljs-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;"><span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">class</span> <span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">Order</span> </span>{

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">private</span> <span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@Id</span> <span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@GeneratedValue</span> <span class="hljs-built_in" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">Long</span> id;

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">private</span> String description;
  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">private</span> Status status;

  Order() {}

  Order(String description, Status status) {

    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.description = description;
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.status = status;
  }

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">public</span> <span class="hljs-built_in" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">Long</span> getId() {
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.id;
  }

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">public</span> String getDescription() {
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.description;
  }

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">public</span> Status getStatus() {
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.status;
  }

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">public</span> void setId(<span class="hljs-built_in" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">Long</span> id) {
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.id = id;
  }

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">public</span> void setDescription(String description) {
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.description = description;
  }

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">public</span> void setStatus(Status status) {
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.status = status;
  }

  <span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@Override</span>
  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">public</span> boolean equals(Object o) {

    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">if</span> (<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span> == o)
      <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> <span class="hljs-literal" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(0, 134, 179);">true</span>;
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">if</span> (!(o instanceof Order))
      <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> <span class="hljs-literal" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(0, 134, 179);">false</span>;
    Order order = (Order) o;
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> Objects.equals(<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.id, order.id) &amp;&amp; Objects.equals(<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.description, order.description)
        &amp;&amp; <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.status == order.status;
  }

  <span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@Override</span>
  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">public</span> int hashCode() {
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> Objects.hash(<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.id, <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.description, <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.status);
  }

  <span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@Override</span>
  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">public</span> String toString() {
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"Order{"</span> + <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"id="</span> + <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.id + <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">", description='"</span> + <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.description + <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">'\''</span> + <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">", status="</span> + <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.status + <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">'}'</span>;
  }
}</code></pre></div></div></div></details>

- The class requires a JPA `@Table` annotation that changes the table’s name to `CUSTOMER_ORDER` because `ORDER` is not a valid name for table.
- It includes a `description` field as well as a `status` field.

Orders must go through a certain series of state transitions from the time a customer submits an order and it is either fulfilled or cancelled. This can be captured as a Java `enum` called `Status`:

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">links/src/main/java/payroll/Status.java</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre class="prettyprint highlight" style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;"><code data-lang="java" class="hljs java" style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(51, 51, 51); font-size: 15px; font-weight: 400; padding: 0px; background: rgb(255, 255, 255); display: block; overflow-x: auto; border: none; white-space: pre-wrap; word-break: break-word;"><button aria-live="Copy" class="button is-spring is-copy" style="box-sizing: inherit; margin: 0px; font-family: BlinkMacSystemFont, -apple-system, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;Fira Sans&quot;, &quot;Droid Sans&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; align-items: center; appearance: none; border: 2px solid rgb(17, 17, 17); border-radius: 0px; box-shadow: none; display: inline-block; font-size: 9px; height: auto; justify-content: center; line-height: 20px; padding: 0px 5px; position: absolute; vertical-align: top; user-select: none; background: transparent; color: rgb(17, 17, 17); cursor: pointer; text-align: center; white-space: nowrap; font-weight: 700; overflow: hidden; text-transform: uppercase; transition: color 0.2s ease-in-out; z-index: 0; right: 5px; top: 5px;">Copy</button><span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">package</span> payroll;

<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">enum</span> Status {

  IN_PROGRESS, <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
  COMPLETED, <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
  CANCELLED
}</code></pre></div></div></div></details>

This `enum` captures the various states an `Order` can occupy. For this tutorial, we keep it simple.

To support interacting with orders in the database, you must define a corresponding Spring Data repository called `OrderRepository`:

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Spring Data JPA’s<span>&nbsp;</span><code style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(54, 54, 54); font-size: 15px; font-weight: 400; padding: 10px; background: rgb(255, 255, 255); border: 1px solid rgb(225, 225, 232); overflow-x: auto; white-space: nowrap;">JpaRepository</code><span>&nbsp;</span>base interface</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre class="prettyprint highlight" style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;"><code data-lang="java" class="hljs php" style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(51, 51, 51); font-size: 15px; font-weight: 400; padding: 0px; background: rgb(255, 255, 255); display: block; overflow-x: auto; border: none; white-space: pre-wrap; word-break: break-word;"><button aria-live="Copy" class="button is-spring is-copy" style="box-sizing: inherit; margin: 0px; font-family: BlinkMacSystemFont, -apple-system, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;Fira Sans&quot;, &quot;Droid Sans&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; align-items: center; appearance: none; border: 2px solid rgb(17, 17, 17); border-radius: 0px; box-shadow: none; display: inline-block; font-size: 9px; height: auto; justify-content: center; line-height: 20px; padding: 0px 5px; position: absolute; vertical-align: top; user-select: none; background: transparent; color: rgb(17, 17, 17); cursor: pointer; text-align: center; white-space: nowrap; font-weight: 700; overflow: hidden; text-transform: uppercase; transition: color 0.2s ease-in-out; z-index: 0; right: 5px; top: 5px;">Copy</button><span class="hljs-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;"><span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">interface</span> <span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">OrderRepository</span> <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">extends</span> <span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">JpaRepository</span>&lt;<span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">Order</span>, <span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">Long</span>&gt; </span>{
}</code></pre></div></div></div></details>

We also need to create a new exception class called `OrderNotFoundException`:

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Details</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre class="prettyprint highlight" style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;"><code data-lang="java" class="hljs java" style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(51, 51, 51); font-size: 15px; font-weight: 400; padding: 0px; background: rgb(255, 255, 255); display: block; overflow-x: auto; border: none; white-space: pre-wrap; word-break: break-word;"><button aria-live="Copy" class="button is-spring is-copy" style="box-sizing: inherit; margin: 0px; font-family: BlinkMacSystemFont, -apple-system, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;Fira Sans&quot;, &quot;Droid Sans&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; align-items: center; appearance: none; border: 2px solid rgb(17, 17, 17); border-radius: 0px; box-shadow: none; display: inline-block; font-size: 9px; height: auto; justify-content: center; line-height: 20px; padding: 0px 5px; position: absolute; vertical-align: top; user-select: none; background: transparent; color: rgb(17, 17, 17); cursor: pointer; text-align: center; white-space: nowrap; font-weight: 700; overflow: hidden; text-transform: uppercase; transition: color 0.2s ease-in-out; z-index: 0; right: 5px; top: 5px;">Copy</button><span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">package</span> payroll;

<span class="hljs-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;"><span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">class</span> <span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">OrderNotFoundException</span> <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">extends</span> <span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">RuntimeException</span> </span>{

  OrderNotFoundException(Long id) {
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">super</span>(<span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"Could not find order "</span> + id);
  }
}</code></pre></div></div></div></details>

With this in place, you can now define a basic `OrderController` with the required imports:

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Import Statements</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre class="prettyprint highlight" style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;"><code data-lang="java" class="hljs css" style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(51, 51, 51); font-size: 15px; font-weight: 400; padding: 0px; background: rgb(255, 255, 255); display: block; overflow-x: auto; border: none; white-space: pre-wrap; word-break: break-word;"><button aria-live="Copy" class="button is-spring is-copy" style="box-sizing: inherit; margin: 0px; font-family: BlinkMacSystemFont, -apple-system, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;Fira Sans&quot;, &quot;Droid Sans&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; align-items: center; appearance: none; border: 2px solid rgb(17, 17, 17); border-radius: 0px; box-shadow: none; display: inline-block; font-size: 9px; height: auto; justify-content: center; line-height: 20px; padding: 0px 5px; position: absolute; vertical-align: top; user-select: none; background: transparent; color: rgb(17, 17, 17); cursor: pointer; text-align: center; white-space: nowrap; font-weight: 700; overflow: hidden; text-transform: uppercase; transition: color 0.2s ease-in-out; z-index: 0; right: 5px; top: 5px;">Copy</button><span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> <span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">java</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.util</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.List</span>;
<span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> <span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">java</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.util</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.stream</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.Collectors</span>;

<span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> <span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">static</span> <span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">org</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.springframework</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.hateoas</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.server</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.mvc</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.WebMvcLinkBuilder</span>.*;

<span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> <span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">org</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.springframework</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.hateoas</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.CollectionModel</span>;
<span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> <span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">org</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.springframework</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.hateoas</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.EntityModel</span>;
<span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> <span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">org</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.springframework</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.http</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.ResponseEntity</span>;
<span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> <span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">org</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.springframework</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.web</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.bind</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.annotation</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.GetMapping</span>;
<span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> <span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">org</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.springframework</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.web</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.bind</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.annotation</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.PathVariable</span>;
<span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> <span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">org</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.springframework</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.web</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.bind</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.annotation</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.PostMapping</span>;
<span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> <span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">org</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.springframework</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.web</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.bind</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.annotation</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.RequestBody</span>;
<span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> <span class="hljs-selector-tag" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">org</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.springframework</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.web</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.bind</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.annotation</span><span class="hljs-selector-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">.RestController</span>;</code></pre></div></div></div></details>

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">links/src/main/java/payroll/OrderController.java</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre class="prettyprint highlight" style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;"><code data-lang="java" class="hljs kotlin" style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(51, 51, 51); font-size: 15px; font-weight: 400; padding: 0px; background: rgb(255, 255, 255); display: block; overflow-x: auto; border: none; white-space: pre-wrap; word-break: break-word;"><button aria-live="Copy" class="button is-spring is-copy" style="box-sizing: inherit; margin: 0px; font-family: BlinkMacSystemFont, -apple-system, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;Fira Sans&quot;, &quot;Droid Sans&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; align-items: center; appearance: none; border: 2px solid rgb(17, 17, 17); border-radius: 0px; box-shadow: none; display: inline-block; font-size: 9px; height: auto; justify-content: center; line-height: 20px; padding: 0px 5px; position: absolute; vertical-align: top; user-select: none; background: transparent; color: rgb(17, 17, 17); cursor: pointer; text-align: center; white-space: nowrap; font-weight: 700; overflow: hidden; text-transform: uppercase; transition: color 0.2s ease-in-out; z-index: 0; right: 5px; top: 5px;">Copy</button><span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@RestController</span>
<span class="hljs-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;"><span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">class</span> <span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">OrderController</span> </span>{

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">private</span> <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">final</span> OrderRepository orderRepository;
  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">private</span> <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">final</span> OrderModelAssembler assembler;

  OrderController(OrderRepository orderRepository, OrderModelAssembler assembler) {

    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.orderRepository = orderRepository;
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">this</span>.assembler = assembler;
  }

  <span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@GetMapping(<span class="hljs-meta-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">"/orders"</span>)</span>
  CollectionModel&lt;EntityModel&lt;Order&gt;&gt; all() {

    List&lt;EntityModel&lt;Order&gt;&gt; orders = orderRepository.findAll().stream() <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
        .map(assembler::toModel) <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
        .collect(Collectors.toList());
    
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> CollectionModel.of(orders, <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
        linkTo(methodOn(OrderController<span class="hljs-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">.<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">class</span>).<span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">all</span></span>()).withSelfRel());
  }

  <span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@GetMapping(<span class="hljs-meta-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">"/orders/{id}"</span>)</span>
  EntityModel&lt;Order&gt; one(<span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@PathVariable</span> <span class="hljs-built_in" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">Long</span> id) {

    Order order = orderRepository.findById(id) <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
        .orElseThrow(() -&gt; new OrderNotFoundException(id));
    
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> assembler.toModel(order);
  }

  <span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@PostMapping(<span class="hljs-meta-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">"/orders"</span>)</span>
  ResponseEntity&lt;EntityModel&lt;Order&gt;&gt; newOrder(<span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@RequestBody</span> Order order) {

    order.setStatus(Status.IN_PROGRESS);
    Order newOrder = orderRepository.save(order);
    
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> ResponseEntity <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
        .created(linkTo(methodOn(OrderController<span class="hljs-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">.<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">class</span>).<span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">one</span></span>(newOrder.getId())).toUri()) <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
        .body(assembler.toModel(newOrder));
  }
}</code></pre></div></div></div></details>

- It contains the same REST controller setup as the controllers you have built so far.
- It injects both an `OrderRepository` and a (not yet built) `OrderModelAssembler`.
- The first two Spring MVC routes handle the aggregate root as well as a single item `Order` resource request.
- The third Spring MVC route handles creating new orders, by starting them in the `IN_PROGRESS` state.
- All the controller methods return one of Spring HATEOAS’s `RepresentationModel` subclasses to properly render hypermedia (or a wrapper around such a type).

Before building the `OrderModelAssembler`, we should discuss what needs to happen. You are modeling the flow of states between `Status.IN_PROGRESS`, `Status.COMPLETED`, and `Status.CANCELLED`. A natural thing when serving up such data to clients is to let the clients make the decision about what they can do, based on this payload.

But that would be wrong.

What happens when you introduce a new state in this flow? The placement of various buttons on the UI would probably be erroneous.

What if you changed the name of each state, perhaps while coding international support and showing locale-specific text for each state? That would most likely break all the clients.

Enter **HATEOAS** or **Hypermedia as the Engine of Application State**. Instead of clients parsing the payload, give them links to signal valid actions. Decouple state-based actions from the payload of data. In other words, when **CANCEL** and **COMPLETE** are valid actions, you should dynamically add them to the list of links. Clients need to show users the corresponding buttons only when the links exist.

This decouples clients from having to know when such actions are valid, reducing the risk of the server and its clients getting out of sync on the logic of state transitions.

Having already embraced the concept of Spring HATEOAS `RepresentationModelAssembler` components, the `OrderModelAssembler` is the perfect place to capture the logic for this business rule:

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">links/src/main/java/payroll/OrderModelAssembler.java</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre class="prettyprint highlight" style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;"><code data-lang="java" class="hljs kotlin" style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(51, 51, 51); font-size: 15px; font-weight: 400; padding: 0px; background: rgb(255, 255, 255); display: block; overflow-x: auto; border: none; white-space: pre-wrap; word-break: break-word;"><button aria-live="Copy" class="button is-spring is-copy" style="box-sizing: inherit; margin: 0px; font-family: BlinkMacSystemFont, -apple-system, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;Fira Sans&quot;, &quot;Droid Sans&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; align-items: center; appearance: none; border: 2px solid rgb(17, 17, 17); border-radius: 0px; box-shadow: none; display: inline-block; font-size: 9px; height: auto; justify-content: center; line-height: 20px; padding: 0px 5px; position: absolute; vertical-align: top; user-select: none; background: transparent; color: rgb(17, 17, 17); cursor: pointer; text-align: center; white-space: nowrap; font-weight: 700; overflow: hidden; text-transform: uppercase; transition: color 0.2s ease-in-out; z-index: 0; right: 5px; top: 5px;">Copy</button><span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">package</span> payroll;

<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.*;

<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> org.springframework.hateoas.EntityModel;
<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> org.springframework.hateoas.server.RepresentationModelAssembler;
<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> org.springframework.stereotype.Component;

<span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@Component</span>
<span class="hljs-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;"><span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">class</span> <span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">OrderModelAssembler</span> <span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">implements</span> <span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">RepresentationModelAssembler</span>&lt;<span class="hljs-type" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">Order, EntityModel&lt;Order</span>&gt;&gt; </span>{

  <span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@Override</span>
  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">public</span> EntityModel&lt;Order&gt; toModel(Order order) {

    <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">// Unconditional links to single-item resource and aggregate root</span>
    
    EntityModel&lt;Order&gt; orderModel = EntityModel.of(order,
        linkTo(methodOn(OrderController<span class="hljs-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">.<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">class</span>).<span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">one</span></span>(order.getId())).withSelfRel(),
        linkTo(methodOn(OrderController<span class="hljs-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">.<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">class</span>).<span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">all</span></span>()).withRel(<span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"orders"</span>));
    
    <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">// Conditional links based on state of the order</span>
    
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">if</span> (order.getStatus() == Status.IN_PROGRESS) {
      orderModel.add(linkTo(methodOn(OrderController<span class="hljs-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">.<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">class</span>).<span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">cancel</span></span>(order.getId())).withRel(<span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"cancel"</span>));
      orderModel.add(linkTo(methodOn(OrderController<span class="hljs-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">.<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">class</span>).<span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">complete</span></span>(order.getId())).withRel(<span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"complete"</span>));
    }
    
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> orderModel;
  }
}</code></pre></div></div></div></details>

This resource assembler always includes the **self** link to the single-item resource as well as a link back to the aggregate root. However, it also includes two conditional links to `OrderController.cancel(id)` as well as `OrderController.complete(id)` (not yet defined). These links are shown only when the order’s status is `Status.IN_PROGRESS`.

If clients can adopt HAL and the ability to read links instead of simply reading the data of plain old JSON, they can trade in the need for domain knowledge about the order system. This naturally reduces coupling between client and server. It also opens the door to tuning the flow of order fulfillment without breaking clients in the process.

To round out order fulfillment, add the following to the `OrderController` for the `cancel` operation:

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Creating a "cancel" operation in the OrderController</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre class="prettyprint highlight" style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;"><code data-lang="java" class="hljs kotlin" style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(51, 51, 51); font-size: 15px; font-weight: 400; padding: 0px; background: rgb(255, 255, 255); display: block; overflow-x: auto; border: none; white-space: pre-wrap; word-break: break-word;"><button aria-live="Copy" class="button is-spring is-copy" style="box-sizing: inherit; margin: 0px; font-family: BlinkMacSystemFont, -apple-system, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;Fira Sans&quot;, &quot;Droid Sans&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; align-items: center; appearance: none; border: 2px solid rgb(17, 17, 17); border-radius: 0px; box-shadow: none; display: inline-block; font-size: 9px; height: auto; justify-content: center; line-height: 20px; padding: 0px 5px; position: absolute; vertical-align: top; user-select: none; background: transparent; color: rgb(17, 17, 17); cursor: pointer; text-align: center; white-space: nowrap; font-weight: 700; overflow: hidden; text-transform: uppercase; transition: color 0.2s ease-in-out; z-index: 0; right: 5px; top: 5px;">Copy</button><span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@DeleteMapping(<span class="hljs-meta-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">"/orders/{id}/cancel"</span>)</span>
ResponseEntity&lt;?&gt; cancel(<span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@PathVariable</span> <span class="hljs-built_in" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">Long</span> id) {

  Order order = orderRepository.findById(id) <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
      .orElseThrow(() -&gt; new OrderNotFoundException(id));

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">if</span> (order.getStatus() == Status.IN_PROGRESS) {
    order.setStatus(Status.CANCELLED);
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> ResponseEntity.ok(assembler.toModel(orderRepository.save(order)));
  }

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> ResponseEntity <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
      .status(HttpStatus.METHOD_NOT_ALLOWED) <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
      .header(HttpHeaders.CONTENT_TYPE, MediaTypes.HTTP_PROBLEM_DETAILS_JSON_VALUE) <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
      .body(Problem.create() <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
          .withTitle(<span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"Method not allowed"</span>) <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
          .withDetail(<span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"You can't cancel an order that is in the "</span> + order.getStatus() + <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">" status"</span>));
}</code></pre></div></div></div></details>

It checks the `Order` status before letting it be cancelled. If it is not a valid state, it returns an [RFC-7807](https://tools.ietf.org/html/rfc7807) `Problem`, a hypermedia-supporting error container. If the transition is indeed valid, it transitions the `Order` to `CANCELLED`.

Now we need to add this to the `OrderController` as well for order completion:

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Creating a "complete" operation in the OrderController</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre class="prettyprint highlight" style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;"><code data-lang="java" class="hljs kotlin" style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(51, 51, 51); font-size: 15px; font-weight: 400; padding: 0px; background: rgb(255, 255, 255); display: block; overflow-x: auto; border: none; white-space: pre-wrap; word-break: break-word;"><button aria-live="Copy" class="button is-spring is-copy" style="box-sizing: inherit; margin: 0px; font-family: BlinkMacSystemFont, -apple-system, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;Fira Sans&quot;, &quot;Droid Sans&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; align-items: center; appearance: none; border: 2px solid rgb(17, 17, 17); border-radius: 0px; box-shadow: none; display: inline-block; font-size: 9px; height: auto; justify-content: center; line-height: 20px; padding: 0px 5px; position: absolute; vertical-align: top; user-select: none; background: transparent; color: rgb(17, 17, 17); cursor: pointer; text-align: center; white-space: nowrap; font-weight: 700; overflow: hidden; text-transform: uppercase; transition: color 0.2s ease-in-out; z-index: 0; right: 5px; top: 5px;">Copy</button><span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@PutMapping(<span class="hljs-meta-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">"/orders/{id}/complete"</span>)</span>
ResponseEntity&lt;?&gt; complete(<span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@PathVariable</span> <span class="hljs-built_in" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">Long</span> id) {

  Order order = orderRepository.findById(id) <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
      .orElseThrow(() -&gt; new OrderNotFoundException(id));

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">if</span> (order.getStatus() == Status.IN_PROGRESS) {
    order.setStatus(Status.COMPLETED);
    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> ResponseEntity.ok(assembler.toModel(orderRepository.save(order)));
  }

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> ResponseEntity <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
      .status(HttpStatus.METHOD_NOT_ALLOWED) <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
      .header(HttpHeaders.CONTENT_TYPE, MediaTypes.HTTP_PROBLEM_DETAILS_JSON_VALUE) <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
      .body(Problem.create() <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
          .withTitle(<span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"Method not allowed"</span>) <span class="hljs-comment" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">//</span>
          .withDetail(<span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"You can't complete an order that is in the "</span> + order.getStatus() + <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">" status"</span>));
}</code></pre></div></div></div></details>

This implements similar logic to prevent an `Order` status from being completed unless in the proper state.

Let’s update `LoadDatabase` to pre-load some `Order` objectss along with the `Employee` objects it was loading before.

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Updating the database pre-loader</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre class="prettyprint highlight" style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;"><code data-lang="java" class="hljs java" style="box-sizing: inherit; -webkit-font-smoothing: auto; font-family: Monaco, monospace; color: rgb(51, 51, 51); font-size: 15px; font-weight: 400; padding: 0px; background: rgb(255, 255, 255); display: block; overflow-x: auto; border: none; white-space: pre-wrap; word-break: break-word;"><button aria-live="Copy" class="button is-spring is-copy" style="box-sizing: inherit; margin: 0px; font-family: BlinkMacSystemFont, -apple-system, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, Cantarell, &quot;Fira Sans&quot;, &quot;Droid Sans&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; align-items: center; appearance: none; border: 2px solid rgb(17, 17, 17); border-radius: 0px; box-shadow: none; display: inline-block; font-size: 9px; height: auto; justify-content: center; line-height: 20px; padding: 0px 5px; position: absolute; vertical-align: top; user-select: none; background: transparent; color: rgb(17, 17, 17); cursor: pointer; text-align: center; white-space: nowrap; font-weight: 700; overflow: hidden; text-transform: uppercase; transition: color 0.2s ease-in-out; z-index: 0; right: 5px; top: 5px;">Copy</button><span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">package</span> payroll;

<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> org.slf4j.Logger;
<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> org.slf4j.LoggerFactory;
<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> org.springframework.boot.CommandLineRunner;
<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> org.springframework.context.annotation.Bean;
<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">import</span> org.springframework.context.annotation.Configuration;

<span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@Configuration</span>
<span class="hljs-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;"><span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">class</span> <span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">LoadDatabase</span> </span>{

  <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">private</span> <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">static</span> <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">final</span> Logger log = LoggerFactory.getLogger(LoadDatabase<span class="hljs-class" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">.<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">class</span>)</span>;

  <span class="hljs-meta" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(150, 152, 150);">@Bean</span>
  <span class="hljs-function" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">CommandLineRunner <span class="hljs-title" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(111, 66, 193);">initDatabase</span><span class="hljs-params" style="box-sizing: inherit; font-style: inherit; font-weight: inherit;">(EmployeeRepository employeeRepository, OrderRepository orderRepository)</span> </span>{

    <span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">return</span> args -&gt; {
      employeeRepository.save(<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">new</span> Employee(<span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"Bilbo"</span>, <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"Baggins"</span>, <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"burglar"</span>));
      employeeRepository.save(<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">new</span> Employee(<span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"Frodo"</span>, <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"Baggins"</span>, <span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"thief"</span>));
    
      employeeRepository.findAll().forEach(employee -&gt; log.info(<span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"Preloaded "</span> + employee));


​      
​      orderRepository.save(<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">new</span> Order(<span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"MacBook Pro"</span>, Status.COMPLETED));
​      orderRepository.save(<span class="hljs-keyword" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(215, 58, 73);">new</span> Order(<span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"iPhone"</span>, Status.IN_PROGRESS));
​    
​      orderRepository.findAll().forEach(order -&gt; {
​        log.info(<span class="hljs-string" style="box-sizing: inherit; font-style: inherit; font-weight: inherit; color: rgb(3, 47, 98);">"Preloaded "</span> + order);
​      });
​      
​    };
  }
}</code></pre></div></div></div></details>

Now you can test. Restart your application to make sure you are running the latest code changes. To use the newly minted order service, you can perform a few operations:

```
$ curl -v http://localhost:8080/orders | json_pp
```

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Details</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;">{
  "_embedded": {
    "orderList": [
      {
        "id": 3,
        "description": "MacBook Pro",
        "status": "COMPLETED",
        "_links": {
          "self": {
            "href": "http://localhost:8080/orders/3"
          },
          "orders": {
            "href": "http://localhost:8080/orders"
          }
        }
      },
      {
        "id": 4,
        "description": "iPhone",
        "status": "IN_PROGRESS",
        "_links": {
          "self": {
            "href": "http://localhost:8080/orders/4"
          },
          "orders": {
            "href": "http://localhost:8080/orders"
          },
          "cancel": {
            "href": "http://localhost:8080/orders/4/cancel"
          },
          "complete": {
            "href": "http://localhost:8080/orders/4/complete"
          }
        }
      }
    ]
  },
  "_links": {
    "self": {
      "href": "http://localhost:8080/orders"
    }
  }
}</pre></div></div></div></details>

This HAL document immediately shows different links for each order, based upon its present state.

- The first order, being **COMPLETED**, only has the navigational links. The state transition links are not shown.
- The second order, being **IN_PROGRESS**, additionally has the **cancel** link as well as the **complete** link.

Now try cancelling an order:

```
$ curl -v -X DELETE http://localhost:8080/orders/4/cancel | json_pp
```

You may need to replace the number 4 in the preceding URL, based on the specific IDs in your database. That information can be found from the previous `/orders` call.

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Details</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;">&gt; DELETE /orders/4/cancel HTTP/1.1
&gt; Host: localhost:8080
&gt; User-Agent: curl/7.54.0
&gt; Accept: */*
&gt;
&lt; HTTP/1.1 200
&lt; Content-Type: application/hal+json;charset=UTF-8
&lt; Transfer-Encoding: chunked
&lt; Date: Mon, 27 Aug 20yy 15:02:10 GMT
&lt;
{
  "id": 4,
  "description": "iPhone",
  "status": "CANCELLED",
  "_links": {
    "self": {
      "href": "http://localhost:8080/orders/4"
    },
    "orders": {
      "href": "http://localhost:8080/orders"
    }
  }
}</pre></div></div></div></details>

This response shows an **HTTP 200** status code, indicating that it was successful. The response HAL document shows that order in its new state (`CANCELLED`). Also, the state-altering links gone.

Now try the same operation again:

```
$ curl -v -X DELETE http://localhost:8080/orders/4/cancel | json_pp
```

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Details</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;">* TCP_NODELAY set
* Connected to localhost (::1) port 8080 (#0)
&gt; DELETE /orders/4/cancel HTTP/1.1
&gt; Host: localhost:8080
&gt; User-Agent: curl/7.54.0
&gt; Accept: */*
&gt;
&lt; HTTP/1.1 405
&lt; Content-Type: application/problem+json
&lt; Transfer-Encoding: chunked
&lt; Date: Mon, 27 Aug 20yy 15:03:24 GMT
&lt;
{
  "title": "Method not allowed",
  "detail": "You can't cancel an order that is in the CANCELLED status"
}</pre></div></div></div></details>

You can see an **HTTP 405 Method Not Allowed** response. **DELETE** has become an invalid operation. The `Problem` response object clearly indicates that you are not allowed to "cancel" an order already in the "CANCELLED" status.

Additionally, trying to complete the same order also fails:

```
$ curl -v -X PUT localhost:8080/orders/4/complete | json_pp
```

<details open="" style="box-sizing: inherit;"><summary class="title" style="box-sizing: inherit; word-break: break-word; color: rgb(54, 54, 54); font-size: 17px; font-weight: 700; line-height: 1.125; margin-bottom: 0.5rem; padding-top: 1.5rem;">Details</summary><div class="content" style="box-sizing: inherit;"><div class="listingblock" style="box-sizing: inherit; margin: 1rem 0px;"><div class="content" style="box-sizing: inherit;"><pre style="box-sizing: inherit; margin: 0px; padding: 10px; -webkit-font-smoothing: auto; font-family: Monaco, monospace; overflow-wrap: normal; background: rgb(255, 255, 255); color: rgb(74, 74, 74); font-size: 15px; overflow-x: auto; white-space: pre; border: 1px solid rgb(225, 225, 232); position: relative;">* TCP_NODELAY set
* Connected to localhost (::1) port 8080 (#0)
&gt; PUT /orders/4/complete HTTP/1.1
&gt; Host: localhost:8080
&gt; User-Agent: curl/7.54.0
&gt; Accept: */*
&gt;
&lt; HTTP/1.1 405
&lt; Content-Type: application/problem+json
&lt; Transfer-Encoding: chunked
&lt; Date: Mon, 27 Aug 20yy 15:05:40 GMT
&lt;
{
  "title": "Method not allowed",
  "detail": "You can't complete an order that is in the CANCELLED status"
}</pre></div></div></div></details>

With all this in place, your order fulfillment service is capable of conditionally showing what operations are available. It also guards against invalid operations.

By using the protocol of hypermedia and links, clients can be made sturdier and be less likely to break simply because of a change in the data. Spring HATEOAS eases building the hypermedia you need to serve to your clients.

## Summary

Throughout this tutorial, you have engaged in various tactics to build REST APIs. As it turns out, REST is not just about pretty URIs and returning JSON instead of XML.

Instead, the following tactics help make your services less likely to break existing clients you may or may not control:

- Do not remove old fields. Instead, support them.
- Use rel-based links so clients need not hard code URIs.
- Retain old links as long as possible. Even if you have to change the URI, keep the rels so that older clients have a path to the newer features.
- Use links, not payload data, to instruct clients when various state-driving operations are available.

It may appear to be a bit of effort to build up `RepresentationModelAssembler` implementations for each resource type and to use these components in all of your controllers. However, this extra bit of server-side setup (made easy thanks to Spring HATEOAS) can ensure the clients you control (and more importantly, those you do not control) can upgrade with ease as you evolve your API.

This concludes our tutorial on how to build RESTful services using Spring. Each section of this tutorial is managed as a separate subproject in a single github repo:

- **nonrest** — Simple Spring MVC app with no hypermedia
- **rest** — Spring MVC + Spring HATEOAS app with HAL representations of each resource
- **evolution** — REST app where a field is evolved but old data is retained for backward compatibility
- **links** — REST app where conditional links are used to signal valid state changes to clients

To view more examples of using Spring HATEOAS, see https://github.com/spring-projects/spring-hateoas-examples.

To do some more exploring, check out the following video by Spring teammate Oliver Drotbohm:

<iframe src="https://www.youtube.com/embed/WDBUlu_lYas?rel=0" frameborder="0" allowfullscreen="" style="box-sizing: inherit; margin: 0px; padding: 0px; border: 0px;"></iframe>

Want to write a new guide or contribute to an existing one? Check out our [contribution guidelines](https://github.com/spring-guides/getting-started-guides/wiki).

All guides are released with an ASLv2 license for the code, and an [Attribution, NoDerivatives creative commons license](http://creativecommons.org/licenses/by-nd/3.0/) for the writing.
