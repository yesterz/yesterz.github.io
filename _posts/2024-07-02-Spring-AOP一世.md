
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

    public boolean login(String username,Sring password);

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

pointcut.setMappedNames(new String[] ("match*" ,"*matches" , "mat*es" ));

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

    (1) getclassFi1ter()方法返回c1assFilter.TRUE，如果需要对特定的目标对象类型进行限定，子类只要覆写这个方法即可。

    (2) 对应的MethodMatcher的isRuntime总是返回true，同时，staticMethodMatcherPointcut提供了两个参数的matches方法的实现，默认直接返回crue。

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

    void afterThrowing([Method, args, target], ThrowableSubclass);

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


## 9.4 Spring AOP 中的 Aspect


### 9.4.1 Pointcutadvisor 家族


### 9.4.2 IntroductionAdvisor分支


### 9.4.3 ordered 的作用


## 9.5 Spring AOP 的织入


### 9.5.1 如何与 ProxyFactory 打交道


### 9.5.2 看清ProxyFactory 的本质


### 9.5.3 容器中的织入器--ProxyFactoryBean


### 9.5.4 加快织入的自动化进程


## 9.6 Targetsource


### 9.6.1 可用的Targetsource 实现类


### 9.6.2 自定义TargetSource


## 9.2 小结

本章我们详尽剖析了Spring AOP中的各种概念和实现原理，这些概念和实现原理是Spring AOP发布之初就确定的，是整个框架的基础。纵使框架版本如何升级，甚至为SpringAOP加入更多的特性，在升级和加入更多更多特性的过程中，也将一直秉承SpringAOP的这些理念。

了解Spring AOP框架发布之初就确立的各种概念和原理，可以帮助我们更好地理解和使用SpringAOP。甚至，可以帮助我们去扩展SpringAOP。而接下来要讲述的，就是Spring2.0之后对SpringAOP进行的扩展。