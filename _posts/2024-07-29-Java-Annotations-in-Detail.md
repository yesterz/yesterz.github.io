---
title: 遇到的一些注解整理
date: 2024-07-29 08:36:00 +0800
author: 
categories: []
tags: []
pin: false
math: false
mermaid: false
---

```java
@SpringBootApplication
public class SingleProjectApplication {

    public static void main(String[] args) {
        SpringApplication.run(SingleProjectApplication.class, args);
    }

}
```

## @SpringBootApplication

开启Spring的组件扫描和Spring Boot的自动配置功能。

@SpringBootApplication将三个有用的注解组合在了一起。

1. Spring的@configuration：标明该类使用Spring基于Java的配置。我们会更倾向于使用基于Java而不是XML的配置。
2. Spring的@ComponentScan：启用组件扫描，这样你写的Web控制器类和其他组件才能被自动发现并注册为Spring应用程序上下文里的Bean。一个简单的SpringMVC控制器，使用@Controller进行注解，这样组件扫描才能找到它。
3. Spring Boot的@EnableAutoConfiguration：这一行配置开启了Spring Boot自动配置的魔力，让你不用再写成篇的配置了。

## @RestController

@RestController是 Spring Framework 中的一个注解，用于标记一个类为 RESTful Web 服务的控制器。这个注解是 `@Controller` 和 `@ResponseBody` 注解的组合，它告诉 Spring 这个类将处理 HTTP 请求，并且它的方法返回值应该被转换为响应体中的 JSON 或 XML 格式，而不是视图模板。

具体来说：

- `@Controller` 注解表明这个类是一个控制器，它可以处理 HTTP 请求。
- `@ResponseBody` 注解表明控制器的方法返回的内容会直接写入 HTTP 响应体，而不是作为视图名称来渲染视图。

当你在一个类上使用 `@RestController` 注解时，这意味着该类中的所有方法都会自动返回响应体数据，而不是试图查找视图模板。这非常适合构建 RESTful API，因为这些 API 通常直接返回数据给客户端，而不是 HTML 页面。

```java
    @Autowired
    private StudentService service;
```

## @Autowired

`@Autowired` 是 Spring 框架中的一个注解，用于实现依赖注入（Dependency Injection, DI）。这个注解可以放在类的字段、构造器或方法参数上，指示 Spring 容器自动为该元素提供所需的依赖对象。

Spring 容器负责管理应用程序中的对象及其依赖关系。使用 `@Autowired` 可以简化对象之间的依赖配置，无需显式地创建对象实例或设置属性。

## @RequestMapping

`@RequestMapping` 是 Spring MVC 和 Spring WebFlux 框架中的一个核心注解，用于映射 HTTP 请求到具体的处理方法上。它是一个类级或方法级的注解，可以用来指定哪些 URL 路径、HTTP 方法等条件与特定的控制器类或方法关联。

`@RequestMapping` 注解可以应用在类级别，也可以应用在方法级别。当应用在类级别时，它定义了一组基础路径，这些路径会与方法级别的 `@RequestMapping` 或其他请求映射注解（如 `@GetMapping`, `@PostMapping` 等）结合使用。

### 常见的请求映射注解

- `@RequestMapping`: 最通用的映射注解，可以指定多种请求类型和路径。
- `@GetMapping`: 映射 GET 请求。
- `@PostMapping`: 映射 POST 请求。
- `@PutMapping`: 映射 PUT 请求。
- `@DeleteMapping`: 映射 DELETE 请求。
- `@PatchMapping`: 映射 PATCH 请求。

### `@RequestMapping` 的主要属性

- `value` 或 `path`: 指定请求路径。
- `method`: 指定 HTTP 方法。
- `params`: 指定查询参数的条件。
- `headers`: 指定请求头的条件。
- `consumes`: 指定请求体可以接受的 MIME 类型。
- `produces`: 指定响应体可以提供的 MIME 类型。

## @Mapper

`@Mapper` 注解是 MyBatis 和 MyBatis-Plus 框架中的一个注解，用于定义接口作为 MyBatis 的映射器（mapper）。这个注解通常用于 Java 接口上，表示该接口将被 MyBatis 识别为一个映射器，可以用来执行 SQL 查询、插入、更新和删除等操作。

在 MyBatis 中，你可以通过 XML 文件或注解的方式来定义映射规则。使用 `@Mapper` 注解是一种基于注解的方式，它可以让你在不编写 XML 文件的情况下定义 CRUD 操作。

### MyBatis 中的 `@Mapper` 注解

在 MyBatis 中，你可以使用 `@Mapper` 注解来标注一个接口，然后在这个接口中定义 SQL 操作的方法签名。MyBatis 会根据这些方法签名生成对应的 SQL 语句。

## @Select

```java
@Select("SELECT * from student where id=#{id} and is_deleted=0")
Student getById(@Param("id") BigInteger id);
```

`getById()` 方法使用 `@Select` 注解定义了一个 SQL 查询语句。

## @Update

```java
@Update("update student set is_deleted=1, update_time=#{time} where id=#{id} limit 1")
int delete(@Param("id") BigInteger id, @Param("time") Integer time);
```

`delete()`方法使用`@Update` 注解用于定义更新语句。可以使用它来定义一个 SQL 更新语句。

## @Param

`@Param` 注解在 MyBatis 和 MyBatis-Plus 中用于指定方法参数的名字，以便在 SQL 语句中引用这些参数。当方法中有多个参数时，使用 `@Param` 注解可以避免参数名称的歧义，并且确保 SQL 语句中的占位符与方法参数一一对应。

### 如何使用 `@Param` 注解

当你在映射器接口的方法中定义 SQL 语句时，如果方法有多个参数，你需要使用 `@Param` 注解来为每个参数命名。这些命名后的参数将在 SQL 语句中通过 `#{paramName}` 的形式引用。

## @Service

`@Service` 注解是 Spring 框架中的一个注解，用于标记一个类作为业务逻辑层（Business Logic Layer，BLL）的服务组件。这个注解是一个立体注解（stereotype annotation），它告诉 Spring 容器这个类是一个服务层的 bean，可以被自动装配到其他的 bean 中。

### `@Service` 注解的作用

1. **Bean 注册**：

    - `@Service` 注解将一个类标记为一个 Spring bean，这意味着 Spring 容器会管理这个类的实例化、依赖注入和生命周期。
2. **自动装配**：

    - 当一个类被标记为 `@Service` 时，Spring 容器可以通过依赖注入机制自动将它装配到其他需要它的类中。
3. **组件分类**：

    - `@Service` 注解有助于将代码组织到不同的层次中，通常用于业务逻辑层。这有助于代码的可维护性和可读性。

## @Resource

`@Resource` 注解是 Java 的一种注解，用于在 Java 类中进行依赖注入。它是由 JSR-250 规范定义的，并且在 Java Persistence API (JPA) 和 Java EE 中得到了广泛的应用。`@Resource` 注解可以用来注入任何类型的资源，包括 EJBs、连接池、消息目的地等。在 Spring 框架中，`@Resource` 注解也被支持，并且可以用来替代 `@Autowired` 注解来进行依赖注入。

### `@Resource` 注解的特点

1. **名称匹配**：

    - `@Resource` 注解可以通过名称来匹配 bean，如果没有指定名称，则默认使用字段名或 setter 方法名作为匹配名称。
2. **类型匹配**：

    - 如果没有找到匹配名称的 bean，`@Resource` 会尝试通过类型匹配来找到合适的 bean。
3. **注入方式**：

    - `@Resource` 可以用于字段注入或 setter 方法注入。
4. **兼容性**：

    - `@Resource` 不仅适用于 Spring，也适用于 Java EE 环境。
