---
title: ch9 Spring AOP 一世
date: 2024-07-02 10:20:00 +0800
author: 
categories: [Cafe baby]
tags: [Spring]
pin: false
math: true
mermaid: false
img_path: /assets/images/Learning-SSH/
---

在动态代理和CGLIB的支持下，SpringAOP框架的实现经过了两代。从Spring的AOP框架第一次发布，到Spring2.0发布之前的AOP实现，是Spring第一代AOP实现。Spring2.0发布后的AOP实现是第二代。不过划分归划分，SpringAOP的底层实现机制却一直没变。唯一改变的，是各种AOP概念实体的表现形式以及Spring AOP的使用方式。

下面，我们先从第一代的Spring AOP相关的概念实体说起。

## 9.1 Spring AOP 中的 Joinpoint

之前我们已经提到，AOP的Joinpoint可以有许多种类型，如构造方法调用、字段的设置及获取、方法调用、方法执行等。但是，在SpringAOP中，仅支持方法级别的Joinpoint。更确切地说，只支持方法执行(Method Execution)类型的Joinpoint。这一点我们从8.2节就能看出来。

虽然SpringAOP仅提供方法拦截，但是在实际的开发过程中，这已经可以满足80%的开发需求了，所以，我们不用过于担心Spring AOP的能力。

Spring AOP之所以如此，主要有以下几个原因。

1. 前面说过了，$pringAOP要提供一个简单而强大的AOP框架，并不想因大而全使得框架本身过于臃肿。如果能够仅付出20%的努力，就能够得到80%的回报，这难道不是很好吗?Keep It Simple，Stupid原则指导我们抛弃旧有的EJB2时代的思想和模式，它同样适用在这里:否则，事倍功半，并不是想看到的结果。
2. 对于类中属性(Field)级别的Joinpoint，如果提供这个级别的拦截支持，那么就破坏了面向对象的封装，而且，完全可以通过对setter和getter方法的拦截达到同样的目的。
3. 如果应用需求非常特殊，完全超出了SpringAOP提供的那80%的需求支持，不妨求助于现有的其他AOP实现产品，如Aspect。目前来看，AspectJ是Java平台对AOP支持最完善的产品，同时，SpringAOP也提供了对AspectJ的支持。（不过，需要注意的是，AspectJ也不是完全支持所有类型的Joinpoint，如程序中的循环结构。部分原因应该归结为要实现这20%的需求，可能需要付出80%的工作和努力。）

## 9.2 Spring AOP 中的 Pointcut

Spring中以接口定义org.springframework.aop.Pointcut作为其AOP框架中所有Pointcut的最顶层抽象，该接口定义了两个方法用来帮助捕提系统中的相应Joinpoint，并提供了一个TruePointcut类型实例。如果Pointcut类型为TruePointcut，默认会对系统中的所有对象，以及对象上所有被支持的Joinpoint进行匹配。org.springframework.aop.Pointcut接口定义如以下代码所示：

```java
public interface Pointcut {
    ClassFilter getClassFilter();
    MethodMatcher getMethodMatcher();
    Pointcut TRUE = TruePointCut.INSTANCE;
}
```

ClassFi1ter和MethodMatcher分别用于匹配将被执行织入操作的对象以及相应的方法。之所以将类型匹配和方法匹配分开定义，是因为可以重用不同级别的匹配定义，并且可以在不同的级别或者相同的级别上进行组合操作，或者强制让某个子类只覆写(Overide)相应的方法定义等。

ClassFilter接口的作用是对Joinpoint所处的对象进行Class级别的类型匹配，其定义如下：

```java
public interface ClassFilter {
    boolean matches(Class clazz);
    ClassFilter TRUE = TrueClassFilter.INSTANCE;
}
```

当织入的目标对象的Class类型与Pointcut所规定的类型相符时，matches方法将会返回true，否则，返回fa1se，即意味着不会对这个类型的目标对象进行织入操作。比如，如果我们仅希望对系统中Foo类型的类执行织入，则可以如下这样定义c1assFilter；

```java
public class FooclassFilter {
    public boolean matches(Class clazz){
        return Foo.class.equals(clazz);
    }
}
```

当然，如果类型对我们所捕捉的Joinpoint无所调，那么Pointcut中使用的classFilter可以直接使用`ClassFilter TRUE = TrueClassFiIter.INSTANCE;`。当Pointcut中返回的classFilter类型为该类型实例时，Pointcut的匹配将会针对系统中所有的目标类以及它们的实例进行。

相对于ClassFilter的简单定义，MethodMatcher则要复杂得多。毕竟，Spring主要支持的就是方法级别的拦截————“重头戏”可不能单薄啊!MethodMatcher定义如下：

```java
public interface MethodMatcher {
    boolean matches (Method method, Class targetClass);
    boolean isRuntime();
    boolean matches(Method method, Class targetClass, Object[] args);
    MethodMatcher TRUE = TrueMethodMatcher.INSTANCE;
}
```

MethodMatcher通过重载(Overload)，定义了两个atches方法，而这两个方法的分界线就是isRuntime()方法。在对对象具体方法进行拦截的时候，可以忽略每次方法执行的时候调用者传入的参数，也可以每次都检查这些方法调用参数，以强化拦截条件。假设对以下方法进行拦截：

```java
public boolean login(String username, String password);
```

如果只想在login方法之前插入计数功能，那么login方法的参数对于Joinpoint捕捉就是可以忽略的。而如果想在用户登录的时候对某个用户做单独处理，如不让其登录或者给予特殊权限，那么这个方法的参数就是在匹配Joinpoint的时候必须要考虑的。

(1)在前一种情况下，isRuntime返回false，表示不会考虑具体Joinpoint的方法参数，这种类型的MethodMatcher称之为staticMethodMatcher。因为不用每次都检査参数，那么对于同样类型的方法匹配结果，就可以在框架内部缓存以提高性能。isRuntime方法返回false表明当前的MethodMatcher为staticMethodMatcher的时候，只有boolean matches (Method method, ClasstargetClass):方法将被执行，它的匹配结果将会成为其所属的Pointcut主要依据。

(2)当isRuntime方法返回crue时，表明该MethodMatcher将会每次都对方法调用的参数进行匹配检查，这种类型的MethodMatcher称之为DynamicMethodMatcher。因为每次都要对方法参数进行检查，无法对匹配的结果进行缓存，所以，匹配效率相对于staticMethodMatcher来说要差。而且大部分情况下，staticMethodMatcher已经可以满足需要，最好避免使用DynamicMethodMatcher类型。如果一个MethodMatcher为DynamicMethodMatcher(isRuntime()返回true)，并且当方法`boolean matches(Method method，Class targetClass);`也返回true的时候，三个参数的matches方法将被执行，以进一步检査匹配条件。如果方法`boolean matches(Method method, Class targetClass);`返回false，那么不管这个MethodMatcher是staticMethodMatcher还是DynamicMethodMatcher，该结果已经是最终的匹配结果————你可以猜得到，三个参数的matches方法那铁定是执行不了了。

在Methodnatcher类型的基础上，Pointcut可以分为两类，即staticMethodMatcherPointcut和DynamicMethodMatcherPointcut。因为StaticMethodMatcherPointcut具有明显的性能优势，所以，Spring为其提供了更多支持。图9-1给出了Spring AOP中各Pointcut类型之间的一个局部“族谱”。

在深入这个“族谱”之前，我们先来看看Spring的AOP框架提供了哪些常见的Pointcut。毕竟，谁都有点儿想“坐享其成”嘛。

### 9.2.1 常见的 Pointcut

总地来说，图9-2给出了较为常用的儿种Pointcut实现。

#### 1. NameMatchMethodPointcut

这是最简单的Pointcut实现，属于staticMethodMatcherPointcut的子类，可以根据自身指定的一组方法名称与Joinpoint处的方法的方法名称进行匹配，比如:

```java
NameMatchMethodPointcut pointcut= new NameMatchMethodPointcut ();
pointcut.setMappedName("matches");
// 或者传入多个方法名
pointcut.setMappedNames(new String[]("matches", "isRuntime"));
```

但是，NameMatchMethodPointcut无法对重载(Overload)的方法名进行匹配，因为它仅对方法名进行匹配，不会考虑参数相关信息，而且也没有提供可以指定参数匹配信息的途径。NameMatchMethodpointcut除了可以指定方法名，以对指定的Joinpoint进行匹配,还可以使用“*”通配符，实现简单的模糊匹配，如下所示:

```java
pointcut.setMappedNames(new String[] ("match*" ,"*matches" , "mat*es" ));
```

如果基于“*”通配符的NameMatchMethodPointcut依然无法满足对多个特定Joinpoint的匹配需要，那么使用正则表达式好了。

### 9.2.2 扩展 Pointcut(Customize Pointcut)

虽然我认为以上SpringAOP提供的Pointcut已经足够使用，但却无法保证一定就没有更加特殊的需求，以致于以上Pointcut类型都无法满足要求。这种情况下，我们可以扩展SpringAOP的Pointcut定义，给出自定义的Pointcut实现。

要自定义Pointcut，不用白手起家，SpringAOP已经提供了相应的扩展抽象类支持，我们只需要继承相应的抽象父类，然后实现或者覆写相应方法逻辑即可。前面已经讲过，SpringAOP的Pointcut类型可以划分为staticMethodMatcherPointcut和DynamicMethodMatcherPointcut两类。要实现自定义Pointcut，通常在这两个抽象类的基础上实现相应子类即可。

#### 1. 自定义staticMethodMatcherPointcut

StaticMethodMatcherPointcut根据自身语意，为其子类提供了如下几个方面的默认实现。

- 默认所有StaticMethodMatcherPointcut的子类的ClassFilter均为ClassFilter.TRUE,即忽略类的类型匹配。如果具体子类需要对目标对象的类型做进一步限制，可以通过publicvoid setClassFilter(ClassFilter classFilter)方法设置相应的Classrilter实现。
- 因为是staticMethodMatcherPointcut，所以，其MethodMatcher的isRuntime方法返回false，同时三个参数的matches方法抛出UnsupportedoperationException异常，以表示该方法不应该被调用到。

最终，我们需要做的就是实现两个参数的matches方法了。

如果我们想提供一个Pointcut实现，捕捉系统里数据访问层的数据访问对象中的查询方法所在的Joinpoint，那么可以实现一个staticMethodMatcherPointcut，如下：

```java
public class QueryMethodPointcut extends StaticMethodMatcherPointcut {
    public boolean matches(Method method,Class clazz) {
        return method.getName().startswith("get")
        && clazz.getPackage().getName().startsWith("...dao");
    }
}
```

很简单，不是吗？

> 注意，使用现有的Pointcut类型完全可以满足相同的需求，所以在实现自定义的Pointcut之前务必先查看一下是否已经有可用的Pointcut实现！
{: .prompt-warning }

#### 2.自定义 DynamicMethodMatcherPointcut

DynamicMethodMatcherPointcut也为其子类提供了部分便利。

- (1) getclassFi1ter()方法返回c1assFilter.TRUE，如果需要对特定的目标对象类型进行限定，子类只要覆写这个方法即可。
- (2) 对应的MethodMatcher的isRuntime总是返回true，同时，staticMethodMatcherPointcut提供了两个参数的matches方法的实现，默认直接返回crue。

要实现自定义DymamicMethodMatcherPointcut，通常情况下，我们只需要实现三个参数的matches方法逻辑即可。代码清单9-5给出了一个自定义的pKeySpecificQueryMethodPointcut实现类。

代码清单9-5 自定义的DynamicMethodMatcherPointcut实现示例

```java
public class PKeySpecificQueryMethodPointcut extends DynamicMethodMatcherPointcut {
    public boolean matches(Method method, Class clazz, Object[] args) {
        if(method,getName().startswith("get")
        && clazz.getPackage().getName().startsWith("...dao")) {
            if(!ArrayUtils.isEmpty(args)) {
                return Stringutils.equals("12345"，args[0].tostring());
            }
        }
        return false;
    }
}
```

如果愿意，我们也可以覆写一下两个参数的matches方法，这样，不用每次都得到三个参数的matches方法执行的时候才检查所有的条件。

### 9.2.3 loC 容器中的 Pointcut

Spring中的Pointcut实现都是普通的Java对象，所以，我们同样可以通过Spring的IoC容器来注册并使用它们。

如果某个Pointcut自身需要某种依赖，可以通过IoC容器为其注入。或者如果容器中的某个对象需要依赖于某个Pointcut，也可以把这个Pointcut注入到依赖对象中。不过，通常在使用Spring AOP的过程中，不会直接将某个Pointcut注册到容器，然后公开给容器中的对象使用。这一点稍后将详细讲述。只不过，需要说明的就是,将各个Pointcut以独立的形式注册到容器使用是完全合情合理的,如下所示：

```xml
<bean id="nameMatchPointcut" class="org.springframework.aop.support.NameMatchMethodPointcut">
  <property name="mappedNames">
    <list>
      <value>methodName1</value>
      <value>methodName2</value>
    </list>
  </property>
</bean>
```

## 9.3 Spring AOP 中的 Advice

Spring AOP加入了开源组织AOP Alliance（<http://aopalliance.sourceforge.net/>），目的在于标准化AOP的使用，促进各个AOP实现产品之间的可交互性。鉴于此，Spring中的Advice实现全部遵循AOPAlliance规定的接口。图9-4中就是Spring中各种Advice类型实现与AOPAliance中标准接口之间的关系(Introduction型的Advice将单独讲解)。

Advice实现了将被织入到Pointcut规定的Joinpoint处的横切逻辑。在Spring中，Advice按照其自身实例(instance)能否在目标对象类的所有实例中共享这一标准，可以划分为两大类，即per-class类型的Advice和per-instance类型的Advice。

### 9.3.1 per-class类型的 Advice

per-class类型的Advice是指，该类型的Advice的实例可以在目标对象类的所有实例之间共享。这种类型的Advice通常只是提供方法拦截的功能，不会为目标对象类保存任何状态或者添加新的特性。除了图9-4中没有列出的Introduction类型的Advice不属于per-class类型的Advice之外，图9-4中的所有Advice均属此列。

per-class类型的Advice将会是我们最常接触的Advice类型，所以，先从它们开刀！

#### 1. Before Advice

本着“由简入奢”，哦，不，是“由简入深”的原则，我们先从最简单的Advice类型————Before Advice说起。

Before Advice所实现的横切逻辑将在相应的Joinpoint之前执行，在Before Advice执行完成之后，程序执行流程将从Joinpoint处继续执行，所以Before Advice通常不会打断程序的执行流程。但是如果必要，也可以通过抛出相应异常的形式中断程序流程。

要在Spring中实现Before Advice，我们通常只需要实现org,springframework.aop.MethodBeforeAdvice接口即可，该接口定义如下：

```java
public interface MethodBeforeÃdvice extends BeforeAdvice {
    void before(Method method, Object[] args, Object target) throws Throwable;
}
```

就像我们在图9-4中所看到的那样，MethodBeforeAdvice继承了BeforeAdvice，而BeforeAdvice与AOP Alliance的Advice一样，都是标志接口，其中没有定义任何方法。

> 注意 org.springframework.aop.BeforeAdvice接口没有定义方法的另一个原因在于考虑到将来的可扩展性。如果必要，可以引入支持属性级别拦截的BeforeAdvice支持，
{: .prompt-info }

我们可以使用Before Advice进行整个系统的某些资源初始化或者其他一些准备性的工作。当然，其应用场景并非仅限于此，各位可以根据具体情况选择是否使用Before Advice。

假设我们的系统需要在文件系统的指定位置生成一些数据文件（系统实现中可能存在多处这样的位置），创建之前，我们需要首先检查这些指定位置是否存在，不存在则需要去创建它们。为了避免不必要的代码散落，我们可以为系统中相应目标类提供一个Before Advice，对文件系统的指定路径进行统一的检查或者初始化。代码清单9-6给出了用于初始化指定的资源路径的ResourceSetupBeforeAdvice定义。

代码清单9-6 ResourceSetupBeforeAdvice定义

```java
public class ResourceSetupBeforeAdvice implements MethodBeforeAdvice {

    private Resource resource;

    public ResourceSetupBeforeAdvice(Resource resource) {
        this.resource = resource;
    }

    public void before(Method method, Object[] args,Object target) throws Throwable {
        if(!resource.exists()) {
            FileUtils.forceMkdir(resource.getFile());
        }
    }
}
```

#### 2. ThrowsAdvice

Spring中以接口定义org.springframework.aop.ThrowsAdvice对应通常AOP概念中的AfterThrowingAdvice。虽然该接口没有定义任何方法，但是在实现相应的ThrowsAdvice的时候，我们的方法定义需要遵循如下规则：

```java
void afterThrowing([Method, args, target], ThrowableSubclass);
```

其中，[]中的三个参数可以省略。我们可以根据将要拦截的Throwable的不同类型，在同一个ThrowsAdvice中实现多个afterThrowing方法。框架将会使用Java反射机制(JavaReection)来调用这些方法，如代码清单9-7所示。

代码清单9-7 声明了多个afterthrowing方法的ExceptionBarrierThrowsAdvice定义

```java
public class ExceptionBarrierThrowsAdvice implements ThrowsAdvice {
    public void afterThrowing(Throwable t) {
        // 普通异常处理逻辑
    }
    public void afterThrowing(RuntimeException e) {
        // 运行时异常处理逻辑
    }
    public void afterThrowing(Method m,Object []args,Object target,ApplicationException e) {
        // 处理应用程序生成的异常
    }
}
```

ThrowsAdvice通常用于对系统中特定的异常情况进行监控，以统一的方式对所发生的异常进行处理，我们可以在一种称之为Fault Barier的模式中使用它。当然，我们更应该根据具体应用的场景来发挥ThrowsAdvice的最大能量。

能够马上想到的例子可能就是对系统中的运行时异常(RuntimeException)进行监控，一旦捕捉到异常，需要马上以某种方式通知系统的监控人员或者运营人员。假设我们通过email的方式发送通知，我们可以实现如代码清单9-8所示的一个ThrowsAdvice。

代码清单9-8 ExceptionBarrierrnrowsadvice的定义

```java
public class ExceptionBarrierThrowsAdvice implements ThrowsAdviceprivate {

    JavaMailSender mailSender;
    private String[] receiptions;

    public void afterThrowing(Method m, Object[] args, Object target, RuntimeException e) {

        final String exceptionMessage = ExceptionUtils.getFullStackTrace(e);

        getMailSender().send(new MimeMessagePreparator() { 
            @Override
            public void prepare(MimeMessage message) throws Exception { 
                MimeMessageHelper helper = new MimeMessageHelper(message);
                helper.setSubject("...");
                helper.setTo(getReceiptions());
                helper.setText(exceptionMessage);
                }
            });

        public JavaMailSender getMailsender(){
            return mailsender;
        }
        
        public void setMailSender(JavaMailSender mailSender){
            this.mailSender = mailSender;
        }

        public stringllgetReceiptions(){
            return receiptions;
        }

        public void setReceiptions(string[] receiptions) {
            this.receiptions = receiptions;
        }
    }
}
```

该hrowsAdvice实现中使用了Spring为JavaMail服务提供的抽象层，我们将在后面详细介绍该特性。你可以在当前ExceptionBarrierrhrowsAdvice的基础上进行扩展，如添加更多配置项，或者进一步丰富邮件内容。

### 9.3.2 per-instance类型的 Advice

与per-class类型的Advice不同，per-instance类型的Advice不会在目标类所有对象实例之间共享，而是会为不同的实例对象保存它们各自的状态以及相关逻辑。就拿上班族为例（或许是比较痛苦的例子，呵呵），如果员工是一类人的话，那么公司的每一名员工就是员工类的不同对象实例。每个员工上班之前，公司设置了一个per-class类型的Advice进行“上班活动”的一个拦戳，即打卡机，所有的员工都公用一个打卡机。当每个员工进入各自的位置之后，他们就会使用各自的电脑进行工作，而他们各自的电脑就好像per-instance类型的Advice一样，每个电脑保存了每个员工自己的资料。

在Spring AOP中，Introduction就是唯一的一种per-instance型Advice。

#### Introduction

Introduction可以在不改动目标类定义的情况下，为目标类添加新的属性以及行为。这就好比我们开发人员，如果公司人员紧张，没有配备测试人员，那么，通常就会给我们扣上一顶“测试人员”的帽子，让我们同时进行系统的测试工作，实际上，你还是你，只不过多了点儿事情而已。

在Spring中，为目标对象添加新的属性和行为必须声明相应的接口以及相应的实现。这样，再通过特定的拦截器将新的接口定义以及实现类中的逻辑附加到目标对象之上。之后，目标对象（确切地说是目标对象的代理对象）就拥有了新的状态和行为。这个特定的拦截器就是org.springframework.aop.IntroductionInterceptor，其定如下：

```java
public interface IntroductionInterceptor extends MethodInterceptor, DynamicIntroductionAdvice {}
public interface DynamicIntroductionAdvice extends advice {
    boolean implementsInterface(Class intf);
}
```

IntroductionInterceptor维承了MethodInterceptor以及DynamicIntroductionAdvice。通过DynamicIntroductionAdvice，我们可以界定当前的IntroductionInterceptor为哪些接口类提供相应的拦截功能。通过MethodInterceptor，IntroductionInterceptor就可以处理新添加的接口上的方法调用了。毕竟，原来的目标对象不会处理自己认为没有的东西啊。另外，通常情况下，对于IntroductionInterceptor来说，如果是新增加的接口上的方法调用，不必去调用MethodInterceptor的proceed()方法。毕竟，当前位置已经是“航程”的终点了（当前被拦截的方法实际上就是整个调用链中要最终执行的唯一方法）。

如果把每个目标对象实例看作盒装牛奶生产线上的那一盒盒牛奶的话，那么生产合格证就是新的Introduction逻辑，而IntroductionInterceptor就是把这些生产合格证贴到一盒盒牛奶上的那个“人”。

因为Introduction较之其他Advice有些特殊，所以，我们有必要从总体上看一下Spring中对Introduction的支持结构，图9-5给出了Introduction相关的类图结构。

IntroductionInterceptor是从哪里出来的，前面已经讲过了，从图9-5中也可以看出相关的继承层次关系。我们要说的是实现Introduction型的Advice的两条分支，即以DynamicIntroductionAdvice为首的动态分支和以IntroductionInfo为首的静态可配置分支。从上面DynamicIntroductionAdvice的定义中可以看出，使用DynamicIntroductionAdvice,我们可以到运行时再去判定当前Introduction可应用到的目标接口类型，而不用预先就设定。而IntroductionInfo类型则完全相反，其定义如下：

```java
public interface IntroductionInfo { 
    Class[] getInterfaces();
}
```

实现类必须返回预定的目标接口类型，这样，在对IntroductionInfo型的Introduction进行织入的时候，实际上就不需要指定目标接口类型了，因为它自身就带有这些必要的信息。

要对目标对象进行拦截并添加Introduction逻辑，我们可以直接扩展IntroductionInterceptor然后在子类的invoke方法中实现所有的拦截逻辑。不过，除非特殊状况下需要去直接扩展Introduc-tionInterceptor，大多数时候，直接使用Spring提供的两个现成的实现类就可以了。

#### DelegatingIntroductionInterceptor

从名字也可以看的出来，DelegatingIntroductionInterceptor不会自已实现将要添加到目标对象上的新的逻辑行为，而是委派(delegae)给其他实现类。不过这样也好，职责划分可以更加明确嘛！

就以简化的开发人员为例来说明DelegatingIntroductionInterceptor的用法吧！我们声明IDeveloper接口及其相关类，如代码清单9-12所示。

代码清单9-12 IDeveloper接口声明及其相关实现类定义

```java
public interface IDeveloper {
    void developSoftware();
}

public class Developer implements IDeveloper {

    public void developSoftware(){
        System.out.println("I am happy with programming.");
    }
}
```

使用DelegatingIntroductionInterceptor为Developer添加新的状态或者行为，我们可以按照如下步骤进行。

(1) 为新的状态和行为定义接口。我们要为Developer添加测试人员的职能，首先需要将需要的职能以接口定义的形式声明。这样，就有了ITester声明，如下：

```java
public interface ITester {
    boolean isBusyAsTester();
    void testSoftware();
}
```

(2) 给出新接口的实现类。接口实现类给出将要添加到目标对象的具体逻辑。当目标对象将要行使新的职能的时候，会通过该实现类寻求帮忙。代码清单9-13给出了针对ITester的实现类。

代码清单9-13 ITester的实现类定义

```java
public class Tester implements ITester {

    private boolean busyAsTester;

    public void testSoftware() {
        System.out.println("I will ensure the quality.");
    }

    public boolean isBusyAsTester() {
        return busyAsTester;
    }

    public void setBusyAsTester(boolean busyAsTester) {
        this.busyAsTester=busyAsTester;
    }
}
```

我们可以在接口实现类中添加相应的属性甚至辅助方法，就跟实现通常的业务对象一样。

(3) 通过DelegatingIntroductionInterceptor进行Introduction的拦截。有了新增加职能的接口定义以及相应实现类，使用DelegatingIntroductionInterceptor，我们就可以把具体的Inroduction拦截委托给具体的实现类来完成，如下代码演示了这一过程:

```java
ITester delegate =new Tester();
DelegatingIntroductionInterceptor interceptor = new DelegatingIntroductionInterceptor(delegate);
// 进行织入
ITester tester =(ITester)weaver.weave(developer).with(interceptor).getProxy();
tester.testSoftware();
```

(4) Introduction的最终织入过程在细节上有需要注意的地方，我们将在后面提到。虽然，Dele-gatingIntroductionInterceptor是Introduction型Advice的一个实现，但你可能料想不到的是，它其实是个“伪军”，因为它的实现根本就没有兑现Introduction作为per-instance型Advice的承诺。实际上，DelegatingIntroductionInterceptor会使用它所持有的同一个“delegate”接口实例，供同一目标类的所有实例共享使用。你想啊，就持有一个接口实现类的实例对象，它往哪里去放对应各个目标对象实例的状态啊?所以，如果要真的想严格达到Introduction型Advice所宣称的那样的效果，我们不能使用DelegatingIntroductionInterceptor，而是要使用它的兄弟，DelegatePerTargetObjectIntroductioninterceptor。

#### DelegatePerTargetObjectIntroductionInterceptor

与DelegatingIntroductionInterceptor不同，DelegatePerTargetObjectIntroductionIn-terceptor会在内部持有一个目标对象与相应Introduction逻辑实现类之间的映射关系。当每个目标对象上的新定义的按口方法被调用的时候，DelegatePerTargetObjectIntroductionInterceptor会拦截这些调用，然后以目标对象实例作为键，到它持有的那个映射关系中取得对应当前目标对象实例的Introduction实现类实例。剩下的当然就是，让当前目标对象实例吃自己家锅里的饭了。如果根据当前目标对象实例没有找到对应的Introduction实现类实例，DelegatePerTargetObjectIntroduction-Interceptor将会为其创建一个新的，然后添加到映射关系中。

使用DelegatePerTargetObjectIntroductionInterceptor与使用DelegatingIntroductionInterceptor没有太大的差别，唯一的区别可能就在于构造方式上。现在我们不是自己构造delegate接口实例，而只需要告知DelegatePerTargetObjectIntroductionInterceptor相应的delegate接口类型和对应实现类的类型。剩下的工作留给DelegatePerTargetObjectIntroductionInterceptor就可以了，如以下代码所示：

```java
DelegatePerTargetObiectIntroductionInterceptor interceptor = 
    new DelegatePerTargetObjectIntroductionInterceptor(DelegateImpl.class, IDelegate.class);
```

当然啦，如果DelegatingIntroductionInterceptor和DelegatePerTargetObjectIntroduc-tionInterceptor默认的invoke方法实现逻辑无法满足你的需求，你也可以直接扩展这两个类，覆写(Override)相应的方法。不过，不知为什么，DelegatingIntroductionInterceptor和DelegatePerTargetobjectIntroductionInterceptor自身实现上对扩展有所限制，实例变量没有提供可以公开给子类的途径，一些应该声明为protected以便子类共享的方法也没有放开，而是声明为private。DelegatingIntroductionInterceptor倒是可以通过它的无参数的构造方法进行扩展，但要求子类必须同时实现新的Introduction逻辑的接口。DelegatePerTargetObiectIntroductionInterceptor干脆就没有发现什么有用的可扩展点。所以，给我的感觉就是，直接扩展这两个类跟直接扩展IntroductionInterceptor相比，好像也没有太多优势。希望Spring Team之后能够修改这两个类以便能够更方便地进行扩展。

要扩展IntroductionInterceptor或者DelegatingIntroductionInterceptor和DelegatePerTargetObjectIntroductionInterceptor，通常是因为目标对象的行为，与新附加到目标对象的状态和行为相关联。这时，在处理两方面的方法调用的时候，就需要根据情况添加新的调用处理逻辑--假设Developer要进行开发的时候,检测到其作为Tester本身也在忙活,Developer要“罢工”我们可以实现拥有类似逻辑的IntroductionInterceptor实现，如代码清单9-14所示。

代码清单9-14 扩展DelegatingIntroductionInterceptor的示例

```java
public class TesterFeatureIntroductionInterceptor extends DelegatingIntroductionInterceptor implements Iester {

    private static final long serialVersionUD = -3387097489523045796L;
    private boolean busyAsTester;

    @0verride
    public Object invoke(MethodInvocation mi)throws Throwable {
        if(isBusyAsTester() && StringUtils.contains(mi.getMethod().getName(), "developsoftware")) {
            throw new RuntimeException("你想累死我呀?");
        }
        return super.invoke(mi);
    }

    public boolean isBusyAsTester() {
        return busyAsTester;
    }

    public void setBusyAsTester(boolean busyAsTester) { 
        this.busyAsTester =busyAsTester;
    }

    public void testsoftware() {
        System.out.println("I will ensure the qality.");
    }
}
```

最后要说的是Introduction的性能问题。与Aspect直接通过编译器将Introduction织入目标对象不同，SpringAOP采用的是动态代理机制，在性能上，Introduction型的Advice要逊色不少。如果有必要可以考虑采用AspectJ的Iritroduction实现。

## 9.4 Spring AOP 中的 Aspect

当所有的Pointcut和Advice准备好之后，就到了该把它们分门别类地装进箱子的时候了。你知道我说的箱子是什么，对吧?当然是Aspect。

在解释Aspect的概念的时候曾经提到过，Spring中最初没有完全明确的Aspect的概念，但是，这并不意味着就没有。只不过，Spring中的这个Aspect在实现和特性上有所特殊而已。

Advisor代表Spring中的Aspect，但是，与正常的Aspect不同，Advisor通常只持有一个Pointcut和一个Advice。而理论上，Aspect定义中可以有多个Pointcut和多个Advice，所以，我们可以认为Advisor是一种特殊的Aspect。

为了能够更清楚Advisor的实现结构体系，我们可以将Advisor简单划分为两个分支，一个分支以org.springframework.aop.PointcutAdvisor为首，另一个分支则以org.springframework.aop.Introductionadvisor为头儿，如图9-6所示。

### 9.4.1 Pointcutadvisor 家族

实际上，org.springframework.aop.PointcutAdvisor才是真正的定义一个Pointcut和一个Advice的Advisor，大部分的Advisor实现全都是PointcutAdvisor的“部下”（见图9-7）。

下面我们就来看-下几个常用的PointcutAdvisor实现。

#### 1. DefaultPointcutAdvisor

DefaultPointcutAdvisor是PointcutAdvisor的“大弟子”，是最通用的PointcutAdvisor实现。除了不能为其指定Introduction类型的Advice之外，剩下的任何类型的Pointcut、任何类型的Advice都可以通过DefaultPointcutAdvisor来使用。我们可以在构造DefaultPointcutAdvisor的时候，就明确指定属于当前DefaultPointcutAdvisor实例的Pointcut和Advice，也可以在DefaultPointcutAdvisor实例构造完成后，再通过setPointcut以及setAdvice方法设置相应的Pointcut和Advice（使用示例见代码清单9-15）。

代码清单9-15 DefaultPointcutAdvisor使用示例

```java
Pointeut pointcut = ...; // 任何Pointcut类型 
Advice   advice   = ...; // 除Introduction类型外的任何Advice类型

DefaultPointcutAdvisor advisor = new DefaultPointcutAdvisor(pointcut, advice);
// 或者
DefaultPointcutAdvisor advisor = new DefaultPointcutAdvisor(advice);
advisor.setPointcut(pointcut);
// 或者
DefaultPointcutAdvisor advisor = new DefaultPointcutAdvisor();
advisor.setPointcut(pointcut);
advisor.setAdvice(advice);
```

此处给出代码并不是让你在实际的环境中就这么用，而是为了演示事实的真相。实际上，Spring中任何的bean都可以通过IoC容器来管理，SpringAOP中的任何概念对此也同样适用。大多数时候，我们会通过IoC容器来注册和使用Spring AOP的各种概念实体。

通常使用Spring的IoC容器注册管理Defau1tPointcutAdvisor的情形，如代码清单9-16所示。

代码清单9-16 通过IoC容器注册管理DefaultPointcutAdvisor相关类

```xml
<bean id="pointcut" class="...">
...
</bean>

<bean id="advice" class="...">
...
</bean>

<bean id="advisor" class="org.springframework.aop.support.DefaultPointcutAdvisor">
  <property name="pointcut" ref="pointcut"/>
  <property name="advice" ref="advice"/>
</bean>
```

#### 2. NameMatchMethodPointcutAdvisor

NameMatchMethodPointcutAdvisor是细化后的DefaultPointcutAdvisor，它限定了自身可以使用的Pointcut类型为NameMatchMethodpointcut，并且外部不可更改。不过，对于使用的Advice来说，除了Introduction，其他任何类型的Advice都可以使用。

NameMatchMethodPointcutAdvisor内部持有一个NameMatchMethodPointcut类型的Pointcut实例。当通过NameMatchMethodPointcutAdvisor公开的setMappedName和setMappedNames方法设置将被拦截的方法名称的时候，实际上是在操作NameMatchMethodPointcutAdvisor所持有的这个NameMatchMethodPointcut实例。

NameMatchMethodpointcutAdvisor的使用也很简单，通过编程方式还是通过IoC容器都可以，编程方式使用示例如下:

```java
Advice advice = ...; // 任何类型的Advice，Introduction类型除外
NameMatchMethodPointcutAdvisor advisor = new NameMatchMethodPointcutAdvisor(advice);
advisor.setMappedName("methodName2Intercept");
// 或者
NameMatchMethodPointcutAdvisor advisor = new NameMatchMethodPointcutAdvisor(advice);
advisor.setMappedNames(new string[] {"method1", "method2" });
```

通过IoC容器使用的情形，见代码清单9-17。

代码清单9-17 通过IoC容器配置使用NameMatchMethodpointcutAdvisor

```xml
<bean id="advice" class="...">
</bean>

<bean id="advisor" class="org.springframework.aop.support.NameMatchMethodPointcutAdvisor">
  <property name="advice">
    <ref bean="advice"/>
  </property>
  <property name="mappedNames">
    <list>
      <value>method1</value>
    </list>
  </property>
</bean>
```

#### 3. RegexpMethodPointcutAdvisor

与NameMatchMethodPointcutAdvisor类似，RegexpMethodPointcutAdvisor也限定了自身可以使用的Pointcut的类型，即只能通过正则表达式为其设置相应的Pointcut。

RegexpMethodpointcutAdvisor自身内部持有一个AbstractRegexpMethodPointcut的实例。希望你还记得，AbstractRegexpMethodPointcut有两个实现类，即Per15RegexpMethodPointcut和JdkRegexpMethodPointcut。默认情况下，RegexpMethodPointcutAdvisor会使用JdkRegexpMethodPointcut。如果要强制使用Per15RegexpMethodPointcut，那么可以通过RegexpMethodPointcutAdvisor的setPer15(boolean)达成所愿。

RegexpMethodPointcutAdvisor提供了许多构造方法，我们可以在构造时就指定Pointcut的正则表达式匹配模式以及相应的Advice，也可以构造完成之后再指定，在使用上与其他的Advisor实现并无太多差别。我们这里只演示在IoC容器中的配置使用方式（见代码清单9-18）。

代码清单9-18 通过IoC容器配置使用RegexpMethodPointcutAdvisor示例

```xml
<bean id="advice" class="...">
...
</bean>

<bean id="advisor"class="org.springframework.aop.support.RegexpMethodPointcutAdvisor">
  <property name="pattern">
    <value>cn\.spring21\..*\.methodNamePattern</value>
  </property>
  <property name="advice">
    <ref bean="advice"/>
  </Property>
  <property name="perl5">
    <value>false</value>
  </property>
</bean>
```

关于正则表达式的更多信息可以参照JDK 1.4或者更高版本的Javadoc以及Jakarta ORO项目文档。

#### 4. DefaultBeanFactoryPointcutAdvisor

DefaultBeanFactoryPointcutAdvisor是使用比较少的一个Advisor实现，因为自身绑定到了BeanFactory,所以,要使用DefaultBeanFactoryPointcutAdvisor，我们的应用铁定要绑定到Spring的IoC容器了。而且，通常情况下，DefaultpointcutAdvisor已经完全可以满足需求。

DefaultBeanFactoryPointcutadvisor的作用是，我们可以通过容器中的Advice注册的beanName来关联对应的Advice。只有当对应的Pointcut匹配成功之后，才去实例化对应的Advice，减少了容器启动初期Advisor和Advice之间的耦合性。

要使用DefaultBeanFactoryPointcutAdvisor，我们通常需要在容器的配置文件中进行如代码清单9-19所示的配置。

代码清单9-19 DefaultBeanFactoryPointcutAdvisor使用示例

```xml
<bean id="advice" class="...">
...
</bean>

<bean id="pointcut" class="org.springframework.aop.support.NameMatchMethodPointcut">
  <property name="mappedName" value="doSth"/>
</bean>

<bean id="advisor" class="org.springframework.aop.support.DefaultBeanFactoryPointcutadvisor">
  <property name="pointcut" ref="pointcut"/>
  <property name="adviceBeanName" value="advice"/>
</bean>
```

注意，对应advice的配置属性名称为“adviceBeanName”，而它的值就对应advice的beanName。除了这一点，与DefaultPointcutAdvisor使用并无二致。

### 9.4.2 IntroductionAdvisor分支

IntroductionAdvisor与PointcutAdvisor最本质上的区别就是，IntroductionAdvisor只能应用于类级别的拦截，只能使用Introduction型的Advice，而不能像PointcutAdvisor那样，可以使用任何类型的Pointcut，以及差不多任何类型的Advice。也就是说，IntroductionAdvisor纯粹就是为Introduction而生的。

IntroductionAdvisor的类层次比较简单，只有一个默认实现DefaultIntroductionAdvisor其继承层次见图9-8。

既然IntroductionAdvisor仅限于Introduction的使用场景，那么DefaultIntroductionAdvisor的使用也比较简单，只可以指定Introduction型的Advice（即IntroductionInterceptor）以及将被拦截的接口类型。其使用示例见代码清单9-20。

代码清单9-20，DefaultIntroductionAdvisor使用示例

```xml
<bean id="introductionInterceptor" class="org.springframework.aop.support.DelegatingIntroductionInterceptor">
  <constructor-arg>
    <bean class="...DelegateImpl">
    </bean>
  </constructor-arg>
</bean>

<bean id="introductionAdvisor" class="org.springframework.aop.support.DefaultIntroductionAdvisor">
  <constructor-arg><ref bean="introductionInterceptor"/></constructor-arg>
  <constructor-arg><value>...IDelegateInterface</value></constructor-arg>
</bean>
```

我们也可以指定Advice以及一个IntroductionInfo对象类来构造DefaultIntroductionAdvisor，因为IntroductionInfo可以提供必要的目标接口类型。代码清单9-21是结合IntroductionInfo使用的DefaultIntroductionAdvisor的使用示例。

代码清单9-21 结合1ntroauctionInfo使用的Defau1tncroductionxdvisor的使用示例

```xml
<bean id="introductionInterceptor" class="org.springframework.aop.support.DelegatingIntroductionInterceptor">
  <constructor-arg>
    <bean class="...DelegateImpl">
    </bean>
  </constructor-arg>
</bean>

<bean id="introductionAdvisor" class="org.springframework.aop.support.DefaultIntroductionAdvisor">
  <constructor-arg index="0"><ref bean="introductionInterceptor"/></constructor-arg>
  <constructor-arg index="1"><ref bean="introductionInterceptor"/></constructor-arg>
</bean>
```

不用奇怪为什么我们在构造DefaultIntroductionAdvisor的时候传入两个“introducetion-Interceptor”，它们两个其实是不一样的，前者是作为Introduction型的Advice实例，后者则是作为IntroductionInfo的实例。不要忘了DelegatingIntroductionInterceptor实现了IntroducitonInfo接口哦！

### 9.4.3 ordered 的作用

系统中只存在单一的横切关注点的情况很少，大多数时候，都会有多个横切关注点需要处理，那么，系统实现中就会有多个Advisor存在。当其中的某些Advisor的Pointcut匹配了同一个Joinpoint的时候，就会在这同一个Joinpoint处执行多个Advice的横切逻辑。如果这些Advisor所关联的Advice之间没有很强的优先级依赖关系，那么谁先执行，谁后执行都不会造成任何影响。而一旦这几个需要在同一Joinpoint处执行的Advice逻辑存在优先顺序依赖的话，就需要我们来干预了，否则，系统的行为就会偏离我们的预想。

记得有一天，同事大鹏突然问我，说：“头儿，这个任务初始化的时候抛出异常但没被我们的ThrowsAdvice截获，帮看一下呗?”我心里纳闷，不能吧？査了一下Pointcut的正则表达式定义，没错啊,应该能捕获到啊。最后查到抛出异常的是应用到同一个方法的Advice所抛出的,我才猛然醒悟……

现在假设有两个Advisor，一个进行权限检查，当检查到当前调用没有权限的时候，抛出相应异常称为PermissionAuthadvisor；另一个Advisor使用一个ThrowsAdvice对系统中的所有需要检测的异常进行拦截，称其为ExceptionBarrierAdvisor。如果以如下形式声明这两个Advisor，就不会有问题：

```xml
<bean id="exceptionBarrierAdvisor" class="...ExceptionBarrierAdvisor">
...
</bean>

<bean id="pemissionAuthAdvisor" class="...PermissionAuthAdvisor">
...
</bean>
```

即使permissionAuthAdvisor的Advice抛出异常，我们的ExceptionBarrierAdvisor也可以捕获该异常并进行系统内的统一处理。而如果我们像如下这样，颠倒它们两个的声明顺序，那就有问题了：

```xml
<bean id="pemissionAuthAdvisor" Class="...PermissionAuthAdvisor">
...
</bean>

<bean id="exceptionBarrierAdvisor" class="...ExceptionBarrierAdvisor">
...
</bean>
```

在PermissionAuthAdvisor中的Advice抛出异常之后，ExceptionBarrierAdvisor并没有起作用，问题出在哪儿呢？

Spring在处理同一Joinpoint处的多个Advisor的时候，实际上会按照指定的顺序和优先级来执行它们，顺序号决定优先级，顺序号越小，优先级越高，优先级排在前面的，将被优先执行。我们可以从0或者1开始指定，因为小于0的顺序号原则上由Spring AOP框架内部使用。默认情况下，如果我们不明确指定各个Advisor的执行顺序，那么Spring会按照它们的声明顺序来应用它们，最先声明的顺序号最小但优先级最大，其次次之。

有了这些前提，我们就可以知道为什么仅颠倒两个Advisor的顺序就会造成某个Advisor失效。让我们来看图9-9。

在图9-9中，左边是正常的情况，当调用流程在permissionAuthAdvisor中出现问题时，甚至是在目标对象上出现问题时，ExceptionBarrierAdvisor会在调用流程返回的时候捕获到相应异常;而右边就是调换顺序后的结果，可以看到现在PerissionAuthAdvisor上出现问题的话，因为调用流程已经经过了ExceptionBarrierAdvisor，所以，ExceptionBarrierAdvisor根本无法捕获Permissionauthadvisor上的异常(虽然目标对象上的问题可以捕获到)。

虽然我们可以通过调整配置中各个Advisor声明的顺序来避免以上问题，但是，这并非最彻底的解决方法。最彻底的方法就是，为每个Advisor明确指定顺序号。在Spring框架中，我们可以通过让相应的Advisor以及其他顺序紧要的bean实现org.springframework.core.0rdered接口来明确指定相应顺序号。不过，从图9-7中也应该看到了，各个Advisor实现类，其实已经实现了orderea接口。我们无需自己去实现这个接口了，唯一要做的是直接在配置的时候指定顺序号。代码清单9-22中的配置为我们的两个Advisor指定了明确的顺序号，从而避免了最初问题的出现。

代码清单9-22明确指定各个Advisor的顺序号的演示

```xml
<bean id="pemissionAuthAdvisor" class="..PermissionAuthAdvisor">
  <property name="order" value="1"/>
</bean>
<bean id="exceptionBarrierAdvisor" class="...ExceptionBarrierAdvisor">
  <property name="order" value="0"/>
</bean>
```

## 9.5 Spring AOP 的织入

俗话说得好，“万事俱备，只欠东风”!各个模块我们已经实现好了，剩下的工作，就是拼装各个模块。

要进行织入，AspectJ采用ajc编译器作为它的织入器；JBOSS AOP使用自定义的ClassLoader作为它的织入器；而在Spring AOP中，使用类org.springframework.aop.framework.ProxyFactory作为织入器。

### 9.5.1 如何与 ProxyFactory 打交道

首先需要声明的是，ProxyFactory并非SpringAOP中唯一可用的织入器，而是最基本的一个织入器实现，所以，我们就从最基本的这个织入器开始，来窥探一下SpringAOP的织入过程到底是一个什
么样子。

使用proxyFactory来进行横切逻辑的织入很简单。我们知道，SpringAOP是基于代理模式的AOP实现，织入过程完成后，会返回织入了横切逻辑的目标对象的代理对象。为ProxyFactory提供必要的“生产原材料”之后，ProxyFactory就会返回那个织入完成的代理对象(如以下代码所示)

```java
ProxyFactory weaver =new ProxyFactory(yourTargetObject);
// 或者
// ProxyFactory weaver =new ProxyFactory();
// weaver.setTarget(task);
Advisor advisor = ...;
weaver.addAdvisor(advisor);
Object proxyObject = weaver.getProxy();
// 现在可以使用proxyObject了
```

使用ProxyFactory只需要指定如下两个最基本的东西。

- 第一个是要对其进行织入的目标对象。我们可以通过ProxyFactory的构造方法直接传入，也可以在ProxyFactory构造完成之后，通过相应的setter方法进行设置。
- 第二个是将要应用到目标对象的Aspect。哦，在Spring里面叫做Advisor，呵呵。不过，除了可以指定相应的Advisor之外，还可以使用如下代码，直接指定各种类型的Advice。
`weaver.addAdvice(...);`
  - 对于Introduction之外的Advice类型，ProxyFactory内部就会为这些Advice构造相应的Advisor，只不过在为它们构造的Advisor中使用的Pointcut为Pointcut.TRUE，即这些“没穿衣服”的Advice将被应用到系统中所有可识别的Joinpoint处;
  - 而如果添加的Advice类型是Introduction类型，则会根据该Introduction的具体类型进行区分如果是IntroductionInfo的子类实现，因为它本身包含了必要的描述信息，框架内部会为其构造一个DefaultIntroductionAdvisor;而如果是DynamicIntroductionAdvice的子类实现，框架内部将抛出AopConfigException异常(因为无法从DynamicIntroductionAdvice取得必要的目标对象信息)。

但是，在不同的应用场景下，我们可以指定更多ProxyFactory的控制属性，以便让ProxyFactory帮我们生成必要的代理对象。我们知道，SpringAOP在使用代理模式实现AOP的过程中采用了动态代理和CGLIB两种机制，分别对实现了某些接口的目标类和没有实现任何接口的目标类进行代理，所以，在使用ProxyFactory对目标类进行代理的时候，会通过ProxyFactory的某些行为控制属性对这两种情况进行区分。

在继续下面内容之前，有必要先设定一个简单的场景，以便大家结合实际情况来查看和分析在不同场景下，ProxyFactory在使用方式上的细微差异。假设我们的目标类型定义如下：

```java
public interface ITask { 
    void execute(TaskExecutionContext ctx);
}

public class MockTask implements ITask {

    public void execute(TaskExecutionContext ctx){
        System.out .println("task executed.");
    }
}
```

有了要拦截的目标类，还得有织入到Joinpoint处的横切逻辑，也就是要用到某个Advice实现。我们就把之前的PerformanceMethodInterceptor先拿来一用（见代码清单9-23）。

代码清单9-23 PerformanceMethodInterceptor定义

```java
public class PerformanceMethodInterceptor implements MethodInterceptor {
    
    private final Log logger = LogFactory.getLog(this.getClass());
    
    public Object invoke(MethodInvocation invocation) throws Throwable {
        StopWatch watch = new StopWatch();
        try {
            watch.start();
            return invocation.proceed();
        } finally {
            watch.stop();
        }
        if(logger.isInfoEnabled()) {
            logger.info(watch.tostring);
        }
    }
}
```

有了这些之后，让我们来看一下使用ProxyFactory对实现了ITask接口的目标类，以及没有实现任何接口的目标类如何进行代理。

#### 1. 基于接口的代理

Mockrask实现了ITask接口，要对这种实现了某些接口的目标类进行代理，我们可以为ProxyFactory明确指定代理的接口类型，如下所示：

```java
MockTask task = new MockTask();
ProxyFactory weaver =new ProxyFactory(task);
weaver.setInterfaces(new Class[] {ITask.class});
NameMatchMethodPointcutAdvisor advisor = new NameMatchMethodPointcutAdvisor();
advisor,setMappedName("execute");
advisor.setAdvice(new PerformanceMethodInterceptor());
weaver.addAdvisor(advisor);
ITask proxyObject=(ITask)weaver.getProxy();
proxyObject.execute(null);
```

通过setInterfaces()方法可以明确告知ProxyFactory，我们要对ITask接口类型进行代理。另外，在这里，我们通过NameMatchMethodPointcutAdvisor来指定Pointcut和相应的Advice(Perfor-manceMethodInterceptor)。至于什么类型的Pointcut、Advice以及Advisor，我们完全可以根据个人的喜好或者具体场景来使用，举一反三嘛!

不过，如果没有其他行为属性的干预，我们也可以不使用setInterfaces()方法明确指定具体的接口类型。这样，默认情况下，ProxyFactory只要检测到目标类实现了相应的接口，也会对目标类进行基于接口的代理，如下所示：

```java
MockTask task = new MockTask();
ProxyFactory weaver = new ProxyFactory(task);
NameMatchMethodPointcutAdvisor advisor = new NameMatchMethodPointcutAdvisor();
advisor.setMappedName("execute");
advisor.setAdvice(new PerformanceMethodInterceptor());
weaver.addAdvisor(advisor);
ITask proxyObject = (ITask)weaver.getProxy();
proxyObject.execute(null);
```

这两种形式最终的结果是等效的：

```console
task executed.
60[main]INFO ...PerformanceMethodInterceptor 0:00:00.000
```

简单点儿说，如果目标类实现了至少一个接口，不管我们有没有通过ProxyFactory的setInterfaces()方法明确指定要对特定的接口类型进行代理，只要不将ProxyFactory的optimize和proxyTargetclass两个属性的值设置为true（这两个属性稍后将谈到），那么ProxyFactory都会按照面向接口进行代理。

> 看你是否真正了解了动态代理<br/>在我们对MockTask实例进行代理之后，我们通过如下代码将取得的代理对象强制转型为ITask，然后执行execute，那么，将取得代理对象强制转型为MockTask是否可以呢？<br/>`ITask proxyObject = (ITask)weaver.getProxy();`<br/>如果你不确定，可以把这行代码改一下试试。呵呵，答案是不可以，程序最终将抛出java.lang.ClassCastException异常。我想，你已经猜到问题出在哪里了。<br/>请回头看一下图8-1，在代理模式的场景中，接口的具体实现类和这个具体实现类的代理对象是两个不同的对象，我们可以将接口实现类和它的代理对象都强制转型为接口类型，但是无法将代理对象类型强制转型为接口实现类类型。到我们的场景中就是，MockTask可以强制转型为ITask，MockTask的代理对象也可以强制转型为ITask，但是，要将代理对象强制转型为MockTask;一定会出问题的。<br/>如果我们在代码最后再添加如下一行代码，来查看代码中proxyObject的类型的话：<br/>`System.out.println(proxyObject.getclass());`<br/>就会发现结果是：<br/>`class $Proxy0`<br/>`(MockTask)java.lang.reflect.proxy`这样的强制转型，你觉得能行吗?
{: .prompt-info }

#### 2. 基于类的代理

如果目标类没有实现任何接口，那么，默认情况下，ProxyFactory会对目标类进行基于类的代理，即使用CGLIB。假设我们现在有一个对象，定义如下：

```java
public class Executable {
    public void execute() {
        System.out.println("Executable without any Interfaces");
    }
}
```

如果使用Executable作为目标对象类，那么，ProxyFactory就会对其进行基于类的代理，如下代码演示了使用ProxyFactory对Executable进行织入的过程：

```java
ProxyFactory weaver= new ProxyFactory(new Executable());
NameMatchMethodPointcutAdvisor advisor = new NameMatchMethodPointcutAdvisor();
advisor.setMappedNamne("execute");
advisor.setAdvice(new PerformanceMethodInterceptor());
weaver.addAdvisor(advisor);
Executable proxyObject = (Executable)weaver.getProxy();
proxyObiject.execute();
System.out.println(proxyObject.getClass());
```

从输出结果我们也可以看出来，最终的代理对象是基于CGLIB的:

```console
Executable without any Interfaces
2143 [main] INFO ...PerformanceMethodInterceptor  - 0:00:00.000
class ...Executable$$EnhancerByCGLIB$$9e62fc83
```

但是，即使目标对象类实现了至少一个接口，我们也可以通过proxyTargetclass属性强制ProxyFactory采用基于类的代理。以Mockrask为例，它实现了ITask接口，默认情况下ProxyFactory对其会采用基于接口的代理，但是，通过proxyTargetClass，我们可以改变这种默认行为（见如下代码）：

```java
ProxyFactory weaver = new ProxyFactory(new MockTask());
weaver.getProxyTargetClass(true);
NameMatchMethodPointcutAdvisor advisor = new NameMatchMethodPointcutAdvisor();
advisor.setMappedName("execute");
advisor.setAdvice(new PerformanceMethodInterceptor());
weaver.addAdvisor(advisor);
MockTaak proxyObject = (MockTask)weaver.getProxy();
proxyObject.execute(null);
System.out.println(proxyObject.getClass());
```

现在，我们可以直接将代理对象强制转型为MockTask类型，并且，从输出结果也可以看到，最终的代理对象是基于CGLIB的，而不是动态代理的：

```console
task executed.
311 [main] INFO  ...PerformanceMethodInterceptor  - 0:00:00.000
class  ...MockTask$$EnhancerByCGLIB$$4bf6056
```

除此之外，如果将proxyFactory的optimize属性设定为true的话，ProxyFactory也会采用基于类的代理机制。关于optimize属性的更多信息，我们将在后面给出。

总地来说，如果满足以下列出的三种情况中的任何一种，ProxyFactory将对目标类进行基于类的代理。

- 如果目标类没有实现任何接口，不管proxyTargetclass的值是什么，ProxyFactory会采用基于类的代理。
- 如果ProxyFactory的proxyTargetclass属性值被设置为true，ProxyFactory会采用基于类的代理。
- 如果ProxyFactory的optimize属性值被设置为true，ProxyFactory会采用基于类的代理。

#### 3. Introduction的织入

之所以将Introduction的织入单独列出，是因为Introduction型Advice比较特殊，如下所述。

- Introduction可以为已经存在的对象类型添加新的行为，只能应用于对象级别的拦截，而不是通常Advice的方法级别的拦截，所以，进行mtroduction的织入过程中，不需要指定Pointcut，而只需要指定目标接口类型。
- Spring的Introduction支持只能通过接口定义为当前对象添加新的行为，所以，我们需要在织入的时机，指定新织入的接口类型。

鉴于以上两点，使用ProxyFactory进行Introduction的织入代码示例如代码消单9-24所示。

代码清单9-24，使用eroxyEactory进行Introduction的织入过程示例

```java
ProxyFactory weaver= new ProxyFactory(new Developer());
weaver.setInterfaces(new Clase [] {IDeveloper.class, ITester.class});
TesterFeatureIntroductionInterceptor advice = new TesterFeatureIntroductionInterceptor();
weaver.addndvice(advice);
// DefaultIntroductionAdvisor advisor = new DefaultIntroductionAdvisor(advice, advice);
// weaver.addadvisorladvisor);

Obiect proxy = weaver.getProxy();
((ITestex)proxy).teetSoftware();
((IDeveloper)proxy).developsoftwara();
```

如果我们不使用Advisor而直接为ProxyFactory指定Advice的话，还记得ProxyFactory会如何处理的嘛?ProxyFactory会在自身内部构建相应的Advisor来使用，对吧?因为TesterFeature-IntroductionInterceptor是IntroductionInfo的子类，所以，ProxyFactory内部会创建一个默认的DefaultIntroductionAdvisor实例，就跟我们注释掉的两行代码效果一样。

对Introduction进行织入，与基于接口的代理形式有点像，但有少许差异。对Introduction进行织入新添加的接口类型必须是通过setInterfaces指定的，而原来的目标对象，是采用基于接口的代理形式还是采用基于类的代理形式，完全是可以自由选择的。上面我们通过setInterfaces同时指定了目标对象实现的接口和新添加的接口类型，在进行Imntroduction织入的同时使用了基于接口的代理形式。我们同样可以在织入Introduction的同时，使用基于类的代理形式(见代码清单9-25)。

代码清单9-25、使用proxvEactory进行基于类的代理方式的Itoduction织入过程示例

```java
ProxyFactory weaver = new ProxyFactory(new Developer());
weaver.setProxyTargetClass(true)
weaver.setInterfaceg(new Class[] {ITegter.class});
TesterFeatureIntroductionInterceptor advice = new TesterFeatureIntroductionInterceptor();
weaver.addndvice(advice):
// DefaultIntroductionÃdvisor advisor = new DefaultIntroductionAdvisor(advice, advice);
// weaver.addAdvisorladvisor)

Object proxy = weaver.getProxy();
((ITester)proxy).testSoftware();
((Developer)proxy).developSoftware();
```

我们通过weaver.setProxyTargetclass(true);强制使用了基于类的代理，所以，现在得将代理对象转型为Developer而不是IDeveloper。

从介绍Advice类型到介绍Advisor类型,针对Introduction的部分都是单独陈述的，或许你已经猜到，Introduction的Advice以及Advisor是不能跟其他Advice和Advisor混用的，要织入Introduction，你只能使用Introductionadvisor或者其子类，而不能使用其他的组合。

### 9.5.2 看清ProxyFactory 的本质

知其表而不知其里，充其量你只能算一个画匠，而不是画师；只懂得如何使用API，而不知道这些API为何如此设计，使你迈不出从“画匠”到“画师”的那一步，如果你想迈出这一步，那不妨随我看一下这ProxyFactory内部到底有何“猫腻儿”，何如？

认识proxyFactory的本质，不仅可以让我们清楚它如何实现，帮助我们在以后的系统设计中吸取宝贵的经验，而且可以进一步帮助我们更好地使用ProxyFactory。

> 注意 因为本节剩下的内容涉及的都是ProxyFactory或者Spring AOP框架的实现，所以，大部分类全部来自org.springframework.aop.framework包。
{: .prompt-tip }

要了解ProxyFactory，我们得先从它的“根”说起，即org.springframework.aop.framework.AopProxy，该接口定义如下:

```java
package org.springframework.aop.framework;

import org.springframework.lang.Nullable;

public interface AopProxy {
    Object getProxy();
    Object getProxy(@Nullable ClassLoader classLoader);
    Class<?> getProxyClass(@Nullable ClassLoader classLoader);
}
```

SpringAOP框架内使用AopProxy对使用的不同的代理实现机制进行了适度的抽象,针对不同的代理实现机制提供相应的AopProxy子类实现。目前，SpringAOP框架内提供了针对JDK的动态代理和CGLIB两种机制的AopProxy实现(见图9-10)。

当前，AopProxy有cg1ib2AopProxy和JdkDynamicAopProxy两种实现。因为动态代理需要通过InvocationHandler提供调用拦截，所以，JdkDynamicAopProxy同时实现了InvocationHandler接口。不同AopProxy实现的实例化过程采用工厂模式(确切地说是抽象工厂模式)进行封装，即通过org.springframework,aop,framework.AopProxyFactory进行。AopProxyFactory接口的定义如下所示：

```java
package org.springframework.aop.framework;

public interface AopProxyFactory {
    AopProxy createAopProxy(AdvisedSupport config) throws AopConfigException;
}
```

AopProxyFactory根据传入的Adviseasupport实例提供的相关信息，来决定生成什么类型的AopProxy。不过，具体工作会转交给AopProxyFactory的具体实现类。而实际上这个AopProxyFactory实现类现在就一个，即org.springframework.aop.framework.DefaultAopProxyFactory。

Defau1tAopProxyFactory的实现逻辑很简单，如以下伪代码所示:

```java
if (config.isOptimize() || config.isProxyTargetClass() || hasNoUserSuppliedProxyInterfaces(config)) {
// 创建Cglib2AopProxy实例，并返回;
} else {
// 创建JdkDynamicAopProxy实例，并返回;
}
```

也就是说，如果传入的Advisedsupport实例config的isOptimize或者isProxyTargetclass方法返回true，或者目标对象没有实现任何接口，则采用CGLIB生成代理对象，否则使用动态代理。还记得ProxyFactory会采用基于类的代理形式生成代理对象需要满足的条件吗?这里是一个关键点，但是走到这里，你还是无法理解为什么proxyFactory会有这种好像偶然的行为。别急，我们接着看！

AopProxyFactory需要根据createhopProxy方法传入的Advisedsupport实例信息，来构建相应的AopProxy。下面我们要看看这个Advisedsupport到底是何方神圣。

说得简单一点儿，adviseasupport其实就是一个生成代理对象所需要的信息的载体，该类相关的类层次图，见图9-11。

Advisedsupport所承载的信息可以划分为两类，一类以org.springframework.aop.frameworkProxyConfig为统领,记载生成代理对象的控制信息;一类以org.springframework.aop.frameworkAdvisea为旗帜，承载生成代理对象所需要的必要信息，如相关目标类、Advice、Advisor等。ProxyConfig其实就是一个普通的JavaBean，它定义了5个boolean型的属性，分别控制在生成代理对象的时候，应该采取哪些行为措施，下面是这5个属性的详细情况。

- proxyTargetclass。在9.5.1节的第2小节中已经提到过这个属性，如果proxyTargetclass属性设置为true，则ProxyFactory将会使用CGLIB对目标对象进行代理，默认值为false。
- optimize。该属性的主要用于告知代理对象是否需要采取进一步的优化措施，如代理对象生0成之后，即使为其添加或者移除了相应的Advice，代理对象也可以忽略这种变动。另外，我们也曾经提到，当该属性为true时，ProxyFactory会使用CGLIB进行代理对象的生成。默认情况下，该属性为false。更多信息参照Spring的Javadoc以及参考文档。
- opague。该属性用于控制生成的代理对象是否可以强制转型为Advised，默认值为fa1se，表示任何生成的代理对象都可强制转型为Aavised，我们可以通过Advisea查询代理对象的一些状态。
- exposeProxy。设置exposeProxy，可以让SpringAOP框架在生成代理对象时，将当前代理对象绑定到IhreadLoca1。如果目标对象需要访问当前代理对象，可以通过AopContextcurrentProxy()取得。该属性的用途将在后文中详细讲述。出于性能方面考虑，该属性默认值为false。
- frozen。如果将frozen设置为true，那么一旦针对代理对象生成的各项信息配置完成，则不容许更改。比如，如果ProxyFactory的设置完毕，并且fronzen为true，则不能对Advice进行任何变动，这样可以优化代理对象生成的性能。默认情况下，该值为fa1se。

要生成代理对象，只有proxyConfig提供的控制信息还不够，我们还需要生成代理对象的一些具体信息，比如，要针对哪些目标类生成代理对象，要为代理对象加入何种横切逻辑等，这些信息可以通过org.springframework.aop.framework.Advised设置或者查询。默认情况下，SpringAOP框架返回的代理对象都可以强制转型为Advised，以查询代理对象的相关信息。Advised的接口定义代码太长，我们就不在此罗列了，你可以参照它的Javadoc。简单点儿说，我们可以使用Advisea接口访问相应代理对象所持有的Advisor，进行添加Advisor、移除Advisor等相关动作。即使代理对象已经生成完毕，也可对其进行这些操作。直接操作Advised，更多时候用于测试场景，可以帮助我们检查生成的代理对象是否如所期望的那样。(有关advisea的更多信息，请参照Spring的参考文档，因为与我们的主题相关性不大，这里不进行详细讲述。)

回到之前的Advisedsupport话题，Advisedsupport继承了ProxyConfig，我们可以通过Advisedsupport设置代理对象生成的一些控制属性。Advisedsupport同时实现了Advised接口，我们也可以通过Advisedsupport设置生成代理对象相关的目标类、Advice等必要信息。这样，具体的AopProxy实现在生成代理对象时，可以从Advisedsupport这里取得所有这些必要信息。

现在回到主题ProxyFactory。AopProxy、Advisedsupport与ProxyFactory是什么关系呢？先看图9-12。

ProxyFactory集AopProxy和AdvisedSupport于一身，所以，可以通过proxyFactory设置生成代理对象所需要的相关信息，也可以通过ProxyFactory取得最终生成的代理对象。前者是Advisedsupport的职责，后者是AopProxy的职责。

为了重用相关逻辑，Spring AOP框架在实现的时候，将一些公用的逻辑抽取到了org.springframework.aop.framework.ProxyCreatorSupport中，它自身就继承了Advisedsupport，所以，生成代理对象的必要信息从其自身就可以搞到。为了简化子类生成不同类型opProxy的工作，Proxycreatorsupport内部持有一个opProxyFactory实例，默认采用的是DefaultAopProxyFactory(也可以通过构造方法或者setter方法设置其他实现，如果有的话)。DefaultAopProxyFactory的默认行为前面已经讲述过了。ProxyFactory作为一个proxyCreatorsupport自然继承了这种行为，从它的使用中我们已经领略过了。

前面已经说过了，ProxyFactory只是SpringAOP中最基本的织入器实现。实际上，ProxyFactory还有几个“兄弟”，这从ProxyCreatorsupport的继承类图(图9-13)中可以看到。

后文中将详细讲述AspectJProxyFactory。当前，我们还是先来看看ProxyFactoryBean。

### 9.5.3 容器中的织入器--ProxyFactoryBean

虽然使用ProxyFactory，可以让我们能够独立于Spring的IoC容器之外来使用Spring的AOP支持但是，将SpringAOP与Spring的IoC容器支持相结合，才是发挥SpringAOP更大作用的最佳途径。通过结合Spring的IoC容器，我们可以在容器中对Pointcut和Advice等进行管理，即使它们依赖于其他业务对象，也可以很容易地注入其中。

在IOC容器中，使用org.springframework.aop.framework.ProxyFactoryBean作为织入器，它的使用与ProxyFactory无太大差别。不过在演示ProxyFactoryBean的使用之前，我们有必要在看消了ProxyFactory本质的前提下，进一步弄明白ProxyFactoryBean的本质。

#### 1. ProxyractoryBean的本质

对于proxyFactoryBean，我们应该这样断词，即Proxy+FactoryBean，而不是ProxyFactory+ Bean。也就是说，ProxyFactoryBean本质上是一个用来生产proxy的FactoryBean。还记得I0C容器中的FactoryBean的作用吧?如果容器中的某个对象持有某个FactoryBean的引用，它取得的不是FactoryBean本身，而是FactoryBean的getobject()方法所返回的对象。所以，如果容器中某个对象依赖于ProxyFactoryBean，那么它将会使用到ProxyFactoryBean的getObject()方法所返回的代理对象，这就是ProxyFactryBean得以在容器中游刃有余的原因。

要让ProxyFactoryBean的getObject()方法返回相应目标对象类的代理对象其实很简单。因为ProxyFactoryBean继承了与ProxyFactory共有的父类ProxyCreatorSupport，而ProxyCreatorsupport基本上已经把要做的事情（如设置目标对象、配置其他部件、生成对应的AopProxy等）全部完成了。我们只需在ProxyFactoryBean的getObject()方法中通过父类的createAopProxy()取得相应的AopProxy，然后“return AopProxy.getProxy()”即可。

因为涉及FactoryBean，所以在实现getobject()时，逻辑上还得点缀一下。我们来看ProxyFactoryBean的getobject()定义(见代码清单9-26)。

代码清单9-26 ProxyEactorxBean的getobject()方法逻辑

```java
public Object getObject() throws BeansException {
    initializeAdvisorChain();
    if (isSingleton()) {
    return getsingletonInstance();
    } else {
    if (this.targetName == null) {
        logger.warn ("Using non-singleton proxies with singleton targets is often undesirable." +
        "Enable prototype proxies by setting the 'targetName' property.");
    }
    return new PrototypeInstance();
    }
}
```

FactoryBean定义中要求标明返回的对象是以singleton的scope返回，还是以prototype的scope返回。
所以，得针对这两种情况分别返回不同的代理对象，以满足pactoryBean的issingleton()方法的语义。

如果将ProxyFactoryBean的singleton属性设置为true，则proxyFactoryBean在第一次生成代理对象之后，会通过内部实例变量singletonInstance(Obiect类型)缓存生成的代理对象。之后，所有的谐求将会返回这一缓存实例，从而满足singleton的语义。反之，如果将ProxyFactoryBean的singleton属性设置为false，那么，ProxyFactoryBean每次都会重新检测各项设置，并为当前调用准备一套新的环境，然后再根据最新的环境数据，返回一个新的代理对象。因此，如果singleton属性为fa1se,在生成代理对象的性能上存在损失。如果非要这么做,请确保有充足的理由。singleton默认值为true，即返回同一个代理对象实例。

如果对ProxyFactoryBean的细节感兴趣，可以读一下proxyFactoryBean的代码。

#### 2. ProxyFactoryBean的使用

与ProxyFactory一样，通过ProxyFactoryBean，我们可以在生成目标对象的代理对象的时候，指定使用基于接口的代理还是基于类的代理方式，而且，因为它们全部继承自同一个父类，大部分可设置项目都相同。不过，ProxyFactoryBean在继承了父类proxyCreatorsupport的所有配置属性之外，还添加了几个自己独有的，如下所示。

- proxyInterfaces。如果我们要采用基于接口的代理方式，那么需要通过该属性配置相应的接口类型，这是一个Collection类型实例，所以我们可以通过配置元素\<list>来指定一个或者多个接口类型。实际上，这与通过Interfaces属性指定接口类型是等效的，我们完全可以随个人喜好来使用，虽然使用proxyInterfaces可以保持使用上的统一风格。另外，如果目标对象实现了某个或者多个接口，即使我们不通过该属性指定要代理的接口类型，ProxyFactroyBean也可以自动检测到目标对象所实现的接口，并对其进行基于接口的代理因为ProxyFactoryBean有一个autodetectInterfaces属性，该属性默认值为true，即如果没有明确指定要代理的接口类型，ProxyFactoryBean会自动检测目标对象所实现的接口类型并进行代理。
- interceptorNames。通过该属性，我们可以指定多个将要织入到目标对象的Advice、拦截器以及Advisor,而再也不用通过ProxyFactory那样的addAdvice或者addadvisor方法一个一个地添加了。因为该属性属于Collection类型，所以通常我们会使用配置元素\<list>添加需要的拦截器名称。该属性有两个特性需要提及，如以下所述。

  - 如果没有通过相应的设置目标对象的方法明确为ProxyFactoryBean设置目标对象，那么可以在interceptorNames的最后一个元素位置，放置目标对象的bean定义名称。这是个特例，大部分情况下，还是建议明确指定目标对象，而避免这种配置方式。
  - 通过在指定的interceptorNames某个元素名称之后添加*通配符，可以让ProxyFactoryBean在容器中搜寻符合条件的所有的Advisor并应用到目标对象。这些符合条件的Advisor，Spring参考文档中称之为global advisor。代码清单9-27给出了这种用法的示例。

- singleton。因为ProxyFactoryBean本质上是一个FactoryBean，所以我们可以通过singleton属性，指定每次getobject调用是返回同一个代理对象，还是返回一个新的。通常情况下是返回同一个代理对象，即singieton为true。只有在需要返回有状态的代理对象的情况下，才会将singleton设置为false，如使用Introduction的场合。

### 9.5.4 加快织入的自动化进程


## 9.6 Targetsource


### 9.6.1 可用的Targetsource 实现类


### 9.6.2 自定义TargetSource

说了这么多可以使用的Targetsource实现，大部分情况下应该够用了。不过，永远也不能排除特殊情况，我们还得做好实现自定义Targetsource的准备。

要实现自定义的Targetsource，我们可以直接扩展Targetsource接口，好在这个接口定义的方法不多，如下所示:

```java
public interface TargetSource extends TargetClassAware {
    Class getTargetClass()boolean isStatic();
    Object getTarget() throws Exception;
    void releaseTarget(Object target) throws Exception;
}
```

从下面的方法名称上，我估计各位就能猜出个大概了。

- getTargetClass()方法返回目标对象类型；
- isStatic()用于表明是否要返回同一个目标对象实例，singletonTargetSource的这个方法肯定是返回true，其他的实现根据情况，通常返回false；
- getTarget()是核心，要返回哪个目标对象实例，完全由它说了算；
- 具体调用过程的结束，如果isstatic()为false，则会调用releaserarget()以释放当前调用的目标对象。但是否需要释放，完全是由实现的需要决定的，大部分时候，该方法可以空着不实现。

为了演示Targetsource的特性以及如何实现一个argetSource，我实现了一个简单的Alterna-tiveTargetsource。它内部有一个计数器，当计数器为奇数的时候，TargetSource将针对当前调用返回第一个目标对象实例；否则，返回第二个目标对象实例。Alternativerargetsource的定义如代码清单9-45所示。

## 9.7 小结

本章我们详尽剖析了Spring AOP中的各种概念和实现原理，这些概念和实现原理是Spring AOP发布之初就确定的，是整个框架的基础。纵使框架版本如何升级，甚至为SpringAOP加入更多的特性，在升级和加入更多更多特性的过程中，也将一直秉承SpringAOP的这些理念。

了解Spring AOP框架发布之初就确立的各种概念和原理，可以帮助我们更好地理解和使用SpringAOP。甚至，可以帮助我们去扩展SpringAOP。而接下来要讲述的，就是Spring2.0之后对SpringAOP进行的扩展。
