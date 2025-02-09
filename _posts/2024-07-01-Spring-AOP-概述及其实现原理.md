
任何AOP的实现产品都是在构筑实业，没有这些AOP产品的支持，一切AOP的理论和概念都是空中楼阁。Spring AOP就是这个群体中的一员。

Spring AOP是Spring核心框架的重要组成部分，通常认为它与Spring的IoC容器以及Spring框架对其他JavaEE服务的集成共同组成了Spring框架的“质量三角”，足见其地位之重要(见图8-1)。

Spring AOP采用Java作为AOP的实现语言(AOL)，较之像Aspect那种语言扩展型的AOP实现，SpringAOP可以更快捷地融入开发过程，学习曲线相对要平滑得多。而且，SpringAOP的设计哲学也是简单而强大。它不打算将所有的AOP需求全部囊括在内，而是要以有限的20%的AOP支持，来满足80%的AOP需求。如果觉得Spring AOP无法满足你所需要的那80%之外的需求，那么求助于Aspect好了，SpringAOP对AspectJ也提供了很好的集成。

Spring AOP的AOL语言为Java。所以，在Java语言的基础之上，Spring AOP对AOP的概念进行了适当的抽象和实现，使得每个AOP的概念都可以落到实处。而这些概念的抽象和实现，都是以我们所熟悉的Java语言的结构呈现在我们面前的。

SpringAOP从最初的框架发布以来，一直保持稳定的AOP模型。即使2.0引入了AspectJ的支持，但总的设计和实现依然延续最初的设想，也就是使用动态代理机制，构建基于Java语言的简单而强大的AOP框架。

在详细介绍SpringAOP王国的“各位公民”（AOP概念实体）之前，我们有必要先看一下这个“王国”是如何运作的。现在就开始吧!

## 8.2 Spring AOP 的实现机制

SpringAOP属于第二代AOP，采用动态代理机制和字节码生成技术实现。与最初的AspectJ采用编译器将横切逻辑织入目标对象不同，动态代理机制和字节码生成都是在运行期间为目标对象生成一个代理对象，而将横切逻辑织入到这个代理对象中，系统最终使用的是织入了横切逻辑的代理对象，而不是真正的目标对象。

为了理解这种差别以及最终可以达到的效果，我们有必要先从动态代理机制的根源————代理模式(Proxy Pattern)开始说起…

### 8.2.1 设计模式之代理模式

说到代理，我们大家应该并不陌生，现在伴随房地产的春风而繁荣的房地产中介就是一种代理。我们偶尔使用的网络代理，也是一种代理，还有许多许多，我就不一一列举了。代理处于访问者与被访问者之间，可以隔离这两者之间的直接交互，访问者与代理打交道就好像在跟被访问者在打交道一样，因为代理通常几乎会全权拥有被代理者的职能，代理能够处理的访问请求就不必要劳烦被访问者来处理了。从这个角度来说，代理可以减少被访问者的负担。另外，即使代理最终要将访问请求转发给真正的被访问者，它也可以在转发访问请求之前或者之后加入特定的逻辑，比如安全访问限制，或者，像房产中介那样抽取一定的中介赞等。

在软件系统中，代理机制的实现有现成的设计模式支持，就叫代理模式。在代理模式中，通常涉及4种角色，如图8-2所示。

- ISubject。该接口是对被访问者或者被访问资源的抽象。在严格的设计模式中，这样的抽象接口是必须的，但往宽了说，某些场景下不使用类似的统一抽象接口也是可以的。
- SubjectImpl。被访问者或者被访问资源的具体实现类。如果你要访问某位明星，那么SubjectImp1就是你想访问的明星;如果你要买房子，那么subjectImpl就是房主…
- SubjectProxy，被访问者或者被访问资源的代理实现类，该类持有一个subject接口的具体实例。在这个场景中，我们要对subjectImp1进行代理，那么SubjectProxy现在持有的就是SubjectImpl的实例。
- Client。代表访问者的抽象角色，Client将会访问ISubject类型的对象或者资源。在这个场景中，Client将会请求具体的SubjectImp1实例，但Client无法直接请求其真正要访问的资源SubjectImpl，而是必须要通过Isubject资源的访问代理类subjectproxy进行。

subjectImp1和subjectProxy都实现了相同的接口ISubject，而subjectProxy内部持有SubjectImpl的引用。当Client通过reguest()请求服务的时候，SubjectProxy将转发该请求给subjectImp1。从这个角度来说，subjectproxy反而有多此一举之嫌了。不过，subjectproxy的作用不只局限于请求的转发，更多时候是对请求添加更多访问限制。subjectImp1和subjectProxy之间的调用关系，如图8-3所示。

在将请求转发给被代理对象subjectImp1之前或者之后，都可以根据情况插入其他处理逻辑，比如在转发之前记录方法执行开始时间，在转发之后记录结束时间，这样就能够对subjectImpl的reguest()执行的时间进行检测。或者，可以只在转发之后对subjectImp1的request()方法返回结果进行覆盖，返回不同的值。甚至，可以不做请求转发，这样，就不会有subjectImp1的访问发生。如果你不希望某人访问你的subjectImpl，这种场景正好适合。

代理对象subjectProxy就像是subjectImp1的影子,只不过这个影子通常拥有更多的功能。如果subiectImpl是系统中的Joinpoint所在的对象，即目标对象，那么就可以为这个目标对象创建一个代理对象，然后将横切逻辑添加到这个代理对象中。当系统使用这个代理对象运行的时候，原有逻辑的实现和横切逻辑就完全融合到一个系统中。如图8-4所示。

SpringAOP本质上就是采用这种代理机制实现的，但是，具体实现细节上有所不同，让我们来看一下为什么。

假设要对系统中所有的reguest()方法进行拦截，在每天午夜0点到次日6点之间，request调用不被接受，那么，我们应该为SubjectImp1提供一个servicecontrolsubjectProxy，以添加这种横切逻辑。这样就有了代码清单8-1的serviceControlsubjectProxy定义。

代码清单8-1 ServicecontrolsubjectProxy

```java
public class ServiceControlSubjectProxy implements ISubject{private static final Logger = LogFactory.getLog(ServiceControlSubjectProxy.class);private ISubject subject;public LogSubjectProxy(ISubject s)
this.subiect s:
public string request(){
TimeOfDay startTime= new TimeOfDay(0.0.0);TimeOfDay endTime=new TimeofDay(5.59.59);TimeOfDay currentrime =new TimeofDay()iif (currentTime.isAfter(startTime)&s currentTime.isBefore(endrime) )
return null:
String originalResult=subject.request()ireturn"Proxy:"+originalResult;
}
}
```

之后，我们使用该serviceControlsubjectProxy代替subjectImpl使用，如以下代码所示:

```java
ISubject target =new SubjectImpl();
ISubject finalSubject * new ServiceControlSubjectProxy(target);
finalSubiect.request();
// 访问控制相关逻辑已经包含在请求的处理逻辑中
```

但是，系统中可不一定就ISubject的实现类有reguest()方法，IRequestab1e接口以及相应实现类可能也有request()方法，它们也是我们需要横切的关注点。IReguestable及其实现类见代码清单8-2。

代码清单8-2 IRequestable及其实现类定义

```java
public interface IRequestable {
    void request();
}
// 实现类
public class RecuestableImpl impiements IRequestable {
    public void reguest() {
        System.out.printin("request processed in RequestableImpl");
    }
}
```

为了能够为IRequestable相应实现类也织入以上的横切逻辑，我们又得提供对应的代理对象，如代码清单8-3所示。

代码清单8-3ServiceControlRequestableProxy定义

```java
public class ServiceControlRequestableProxy implements IRequestable(private static final Logger = logFactory.getLog(ServiceControlRequestableProxy.class);private IRequestable recestable;public LogSubjectProxy(IRequestable requestable)
this,requestable =requestable;
public void recuest(){TimeOfDay startTimenewTimeOfDay(0,0，0):TimeOfDay endTime =new imeOfDay(5.59,59);TimeofDay currentTime =new TimeofDay()iif (currentTime.isAfter(startTime) && currentTime.isBefore(endTime) )
return;
requestable.request();
```

并且将该代理对象而不是目标对象绑定到系统中，如以下代码所示：

```java
IRequestable target=new RequestableImpl();IRequestable proxy=new ServiceControlRequestableProxy(target);proxy.recuesti);
//横切逻辑现在已经织入到代理对象中
```

发现问题了没有？虽然Joinpoint相同(request()方法的执行)，但是对应的目标对象类型是不一样的。针对不一样的目标对象类型，我们要为其单独实现一个代理对象。而实际上，这些代理对象所要添加的横切逻辑是一样的。当系统中存在成百上千的符合Pointcut匹配条件的目标对象时(悲观点说，目标对象类型都不同)，我们就要为这成百上千的目标对象创建成百上千的代理对象，不用我再往下讲了吧?这么玩会死人的！

这种为对应的目标对象创建静态代理的方法，原理上是可行的，但具体应用上存在问题，所以要寻找其他方法，以避免刚刚碰到的窘境……

### 8.2.2 动态代理

JDK1.3之后引入了一种称之为动态代理(DynamicProxy)的机制。使用该机制，我们可以为指定的接口在系统运行期间动态地生成代理对象，从而帮助我们走出最初使用静态代理实现AOP的窘境。

动态代理机制的实现主要由一个类和一个接口组成，即java.lang.reflect.Proxy类和java.1ang.reflect.InvocationHàndler接口。下面，让我们看一下，如何使用动态代理来实现之前的'request服务时间控制”功能。虽然要为ISubject和IReguestable两种类型提供代理对象，但因为代理对象中要添加的横切逻辑是一样的，所以，我们只需要实现一个InvocationHanaler就可以了，其定义见代码清单8-4。

代码清单8-4 RequestetrlInvocationHandler定义

```java
public class RequestCtrlInvocationHandler implements Invocationandler {private static final Log logger = LogFactory.getLog(ReguestCtrlInvocationHandler.class);private Object target;
public RequestCtrlInvocationHandler(0bject target)
this,target =target;
public object invoke(Object proxy,Method method, Object[] args)throws Throwable{if (method.getName().equals ("request"))
TimeOfDay startTime :new TimeOfDay(0,0，0)TimeOfDay endTime=new TimeOfDay(5,59，59)TimeOfDay currentTime=new TimeOfDay();if(currentTime,isAfter(startTime)&& currentTime.isBefore(endTime))
logger.warn("service is not available now.");return null;
return method.invoke(target,args):
return null;
```

然后，我们就可以使用proxy类，根据RequestctrlInvocationHandler的逻辑，为ISubject和IRequestable两种类型生成相应的代理对象实例，见代码清单8-5。

代码清单8-5 使用Proxy和Requestctzonnana1er创建不同类型目标对象的动态代理

```java
ISubject subject=(ISubject)Proxy.newProxyInstance(ProxyRunner.class.getClassLoader()new Class{]{ISubject.class}new RequestCtrlInvocationHandler(new SubjectImpl()));subject.request();
IRequestable reguestable=(IRequestable)Proxy.newProxyInstance(ProxyRunner.class.getClassLoader()new Class!]{IRequestable.class}，new RequestCtrlInvocationHandler(new RequestableImpl()));requestable,recuest();
```

即使还有更多的日标对象类型,只要它们依然织入的横切逻辑相同,用ReguestctrlInvocation-Handler一个类并通过proxy为它们生成相应的动态代理实例就可以满足要求。当Proxy动态生成的代理对象上相应的接口方法被调用时，对应的InvocationHandler就会拦截相应的方法调用，并进行相应处理。

InvocationHandler就是我们实现横切逻辑的地方，它是横切逻辑的载体，作用跟Advice是一样的。所以，在使用动态代理机制实现AOP的过程中，我们可以在InvocationHandler的基础上细化程序结构，并根据Advice的类型,分化出对应不同Advice类型的程序结构。我们将在稍后看到SpringAOF中的不同Advice类型实现以及结构规格。

动态代理虽好，但不能满足所有的需求。因为动态代理机制只能对实现了相应Interface的类使用,如果某个类没有实现任何的Interface，就无法使用动态代理机制为其生成相应的动态代理对象。虽然面向接口编程应该是提倡的做法，但不排除其他的编程实践。对于没有实现任何Interface的目标对象，我们需要寻找其他方式为其动态的生成代理对象。

默认情况下，如果Spring AOP发现目标对象实现了相应Interface，则采用动态代理机制为其生成代理对象实例。而如果目标对象没有实现任何Interface，SpringAOP会尝试使用一个称为CGLIB(Code Generation Library)的开源的动态字节码生成类库，为目标对象生成动态的代理对象实例。

> 提示 你可以通过参考java.lang,reflect.Proxy和java,lang.reflect,InvocationHandler的Javadoc获取更多有关动态代理的信息。JavaReflectionInAction(Manning,2005)一书对Java的Reflection机制进行了详尽的阐述，其中有一章专门讲解了动态代理机制，不妨一读。
{: .prompt-tip }

### 8.2.3 动态字节码生成

使用动态字节码生成技术扩展对象行为的原理是，我们可以对目标对象进行继承扩展，为其生成相应的子类，而子类可以通过覆写来扩展父类的行为，只要将横切逻辑的实现放到子类中，然后让系统使用扩展后的目标对象的子类，就可以达到与代理模式相同的效果了。subclassinstanceofSuperclass == true，不是吗?(图8-5演示了一个使用CGLIB进行对象行为扩展的示例。)

但是，使用继承的方式来扩展对象定义，也不能像静态代理模式那样，为每个不同类型的目标对象都单独创建相应的扩展子类。所以，我们要借助于CGLIB这样的动态字节码生成库，在系统运行期间动态地为目标对象生成相应的扩展子类。

为了演示CGLIB的使用以及最终可以达到的效果，我们定义的目标类如下所示:

```java
public class Requestablepublic void request(){
    System.out.println("rq in Requestable""without implementint any interface")
}
```

CGLB可以对实现了某种接口的类，或者没有实现任何接口的类进行扩展。但我们已经说过，可以使用动态代理机制来扩展实现了某种接口的目标类，所以，这里主要演示没有实现任何接口的目标类是如何使用CGLIB来进行扩展的。

要对Reguestable类进行扩展，首先需要实现一个net.sf.cglib.proxy.Cal1back。不过更多的时候，我们会直接使用net.sf.cglib.proxy.MethodInterceptor接口(MethodInterceptor扩展了ca11back接口)。代码清单8-6给出了针对我们的Requestable所提供的Cal1back实现。

代码清单8-6 RequestCtrlCa11back类定义

```java
private static final og logger=
public class RequestCtrlCallback implements MethodIntercepto
LogFactory.getLog(RequestCtrlCallback.class);
public Object intercept (Object object,Method method, Object[] args,MethodProxy proxy)throws Throwable(if(method.getName().equals("request"))
TimeOfDay startTime =new TimeofDay(0,0,0);TimeOfDay endTimenew TimeOfDay(5,59,59);TimeOfDay currentTime=new TimefDay():if(currentTime.isAfter(startTime)&& currentTime.isBefore(endTime) )
logger.warn("service is not available now.");return null;
return proxy.invokeSuper(object,args);
return null;
```

这样，ReguestctrlCallback就实现了对reguest()方法请求进行访问控制的逻辑。现在我们要通过CGLIB的Enhancer为目标对象动态地生成一个子类，并将Reguestctrlca1lback中的横切逻辑附加到该子类中，代码如下所示:

```java
Enhancer enhancer = new Enhancer();
enhancer.setSuperclass(Requestable.class);enhancer.setCallback(new RequestCtrlCallback());
Requestable proxy=(Requestable)enhancer.create();proxy.request();
```

通过为enhancer指定需要生成的子类对应的父类，以及ca11back实现，enhancer最终为我们生成了需要的代理对象实例。

使用CGLIB对类进行扩展的唯一限制就是无法对final方法进行覆写。

> 注意 有关CGLIB的更多信息，请参照CGLB的官方网站<http://cglib.sourceforge.net>。不过，能够找到的文档不是很多，这个应该算CGLIB的缺憾吧。我觉得读其代码或许更切实际一些。
{: .prompt-info }

## 8.3 小结

在进入Spring AOP的腹地之前，我们先对SpringAOP的概况进行了介绍。接着，一起探索了SpringAOP的实现机制，包括最原始的代理模式，直至最终的动态代理与动态字节码生成。

在了解这些内容之后，我们将深入了解Spring AOP的方方面面，先从Spring AOP的最初版本说起……….