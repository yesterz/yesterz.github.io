
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


### 9.2.3 loC 容器中的 Pointcut


## 9.3 Spring AOP 中的 Advice


### 9.3.1 per-class类型的 Advice


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