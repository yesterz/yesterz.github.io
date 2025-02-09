虽然业务对象可以通过IoC方式声明相应的依赖，但是最终仍然需要通过某种角色或者服务将这些相互依赖的对象绑定到一起，而IoC Service Provider就对应IoC场景中的这一角色。

IoC Service Provider在这里是一个抽象出来的概念，它可以指代任何将IoC场景中的业务对象绑定到一起的实现方式。它可以是一段代码，也可以是一组相关的类，甚至可以是比较通用的IoC框架或者IoC容器实现。比如，可以通过以下代码（见代码清单3-1）绑定与新闻相关的对象。

代码清单3-1 FXNewsProvider相关依赖绑定代码

```java
IFXNewsListener newsListener = new DowJonesNewsListener(); 
IFXNewsPersister newsPersister = new DowJonesNewsPersister(); 
FXNewsProvider newsProvider = new FXNewsProvider(newsListener,newsPersister); 
newsProvider.getAndPersistNews(); 
```

这段代码就可以认为是这个场景中的IoC Service Provider，只不过比较简单，而且目的也过于单一罢了。要将系统中几十、几百甚至数以千计的业务对象绑定到一起，采用这种方式显然是不切实际的。通用性暂且不提，单单是写这些绑定代码也会是一种很糟糕的体验。不过，好在现在许多开源产品通过各种方式为我们做了这部分工作。所以，目前来看，我们只需要使用这些产品提供的服务就可以了。Spring 的IoC容器就是一个提供依赖注入服务的IoC Service Provider。

## 3.1 IoC Service Provider 的职责

IoC Service Provider的职责相对来说比较简单，主要有两个：业务对象的构建管理和业务对象间的依赖绑定。

* 业务对象的构建管理。在IoC场景中，业务对象无需关心所依赖的对象如何构建如何取得，但这部分工作始终需要有人来做。所以，IoC Service Provider需要将对象的构建逻辑从客户端对象那里剥离出来，以免这部分逻辑污染业务对象的实现。

* 业务对象间的依赖绑定。对于IoC Service Provider来说，这个职责是最艰巨也是最重要的，这是它的最终使命之所在。如果不能完成这个职责，那么，无论业务对象如何的“呼喊”，也不会得到依赖对象的任何响应（最常见的倒是会收到一个NullPointerException）。IoC Service Provider通过结合之前构建和管理的所有业务对象，以及各个业务对象间可以识别的依赖关系，将这些对象所依赖的对象注入绑定，从而保证每个业务对象在使用的时候，可以处于就绪状态。

## 3.2 IoC Service Provider如何管理对象间的依赖关系

前面我们说过，被注入对象可以通过多种方式通知IoC Service Provider为其注入相应依赖。但问题在于，收到通知的IoC Service Provider是否就一定能够完全领会被注入对象的意图，并及时有效地为其提供想要的依赖呢？有些时候，事情可能并非像我们所想象的那样理所当然。

还是拿酒吧的例子说事儿，不管是常客还是初次光顾，你都可以点自己需要的饮料，以任何方式通知服务生都可以。要是侍者经验老道，你需要的任何饮品他都知道如何为你调制并提供给你。可是，如果服务生刚入行又会如何呢？当他连啤酒、鸡尾酒都分不清的时候，你能指望他及时地将你需要的饮品端上来吗？

服务生最终必须知道顾客点的饮品与库存饮品的对应关系，才能为顾客端上适当的饮品。对于为被注入对象提供依赖注入的IoC Service Provider来说，它也同样需要知道自己所管理和掌握的被注入对象和依赖对象之间的对应关系。

IoC Service Provider不是人类，也就不能像酒吧服务生那样通过大脑来记忆和存储所有的相关信息。所以，它需要寻求其他方式来记录诸多对象之间的对应关系。比如：

1. 它可以通过最基本的文本文件来记录被注入对象和其依赖对象之间的对应关系；
2. 它也可以通过描述性较强的XML文件格式来记录对应信息；
3. 它还可以通过编写代码的方式来注册这些对应信息；
4. 甚至，如果愿意，它也可以通过语音方式来记录对象间的依赖注入关系（“嗨，它要一个这种类型的对象，拿这个给它”）。

那么，实际情况下，各种具体的IoC Service Provider实现又是通过哪些方式来记录“服务信息”的呢？

我们可以归纳一下，当前流行的IoC Service Provider产品使用的注册对象管理信息的方式主要有以下几种。

### 3.2.1 直接编码方式

当前大部分的IoC容器都应该支持直接编码方式，比如PicoContainer、Spring、Avalon等。在容器启动之前，我们就可以通过程序编码的方式将被注入对象和依赖对象注册到容器中，并明确它们相互之间的依赖注入关系。代码清单3-2中的伪代码演示了这样一个过程。

代码清单3-2 直接编码方式管理对象间的依赖注入关系

```java
IoContainer container = ...; 
container.register(FXNewsProvider.class, new FXNewsProvider()); 
container.register(IFXNewsListener.class, new DowJonesNewsListener()); 
// ... 
FXNewsProvider newsProvider = (FXNewsProvider)container.get(FXNewsProvider.class); newProvider.getAndPersistNews(); 
```

通过为相应的类指定对应的具体实例，可以告知IoC容器，当我们要这种类型的对象实例时，请将容器中注册的、对应的那个具体实例返回给我们。

如果是接口注入，可能伪代码看起来要多一些。不过，道理上是一样的，只不过除了注册相应对象，还要将“注入标志接口”与相应的依赖对象绑定一下，才能让容器最终知道是一个什么样的对应关系，如代码清单3-3所演示的那样。

代码清单3-3 直接编码形式管理基于接口注入的依赖注入关系

```java
IoContainer container = ...; 
container.register(FXNewsProvider.class, new FXNewsProvider()); 
container.register(IFXNewsListener.class, new DowJonesNewsListener()); 
// ... 
container.bind(IFXNewsListenerCallable.class, container.get(IFXNewsListener.class)); 
// ... 
FXNewsProvider newsProvider = (FXNewsProvider)container.get(FXNewsProvider.class); newProvider.getAndPersistNews(); 
```

通过bind方法将“被注入对象”（由IFXNewsListenerCallable接口添加标志）所依赖的对象，绑定为容器中注册过的IFXNewsListener类型的对象实例。容器在返回FXNewsProvider对象实例之前，会根据这个绑定信息，将IFXNewsListener注册到容器中的对象实例注入到“被注入对象”——FXNewsProvider中，并最终返回已经组装完毕的FXNewsProvider对象。

所以，通过程序编码让最终的IoC Service Provider（也就是各个IoC框架或者容器实现）得以知晓服务的“奥义”，应该是管理依赖绑定关系的最基本方式。

### 3.2.2 配置文件方式

这是一种较为普遍的依赖注入关系管理方式。像普通文本文件、properties文件、XML文件等，都可以成为管理依赖注入关系的载体。不过，最为常见的，还是通过XML文件来管理对象注册和对象间依赖关系，比如Spring IoC容器和在PicoContainer基础上扩展的NanoContainer，都是采用XML文件来管理和保存依赖注入信息的。对于我们例子中的FXNewsProvider来说，也可以通过Spring配置文件的方式（见代码清单3-4）来配置和管理各个对象间的依赖关系。

代码清单3-4 通过Spring的配置方式来管理FXNewsProvider的依赖注入关系

```xml
<!-- News Provider Configuration -->
<bean id="newsProvider" class="..FXNewsProvider">
    <property name="newsListener">
        <ref bean="djNewsListener"/>
    </property>
    <property name="newPersistener">
        <ref bean="djNewsPersister"/>
    </property>
</bean>

<!-- Dow Jones News Listener Implementation -->
<bean id="djNewsListener" 
      class="..impl.DowJonesNewsListener">
</bean>

<!-- Dow Jones News Persister Implementation -->
<bean id="djNewsPersister" 
      class="..impl.DowJonesNewsPersister">
</bean>
```

最后，我们就可以像代码清单3-5所示的那样，通过“newsProvider”这个名字，从容器中取得已经组装好的FXNewsProvider并直接使用。

代码清单3-5 从读取配置文件完成对象组装的容器中获取FXNewsProvider并使用

```java
... 
container.readConfigurationFiles(...); 
FXNewsProvider newsProvider = (FXNewsProvider)container.getBean("newsProvider"); newsProvider.getAndPersistNews(); 
```

### 3.2.3 元数据方式

这种方式的代表实现是Google Guice，这是Bob Lee在Java 5的注解和Generic的基础上开发的一套IoC框架。我们可以直接在类中使用元数据信息来标注各个对象之间的依赖关系，然后由Guice框架根据这些注解所提供的信息将这些对象组装后，交给客户端对象使用。代码清单3-6演示了使用Guice的相应注解标注后的FXNewsProvider定义。

代码清单3-6 使用Guice的注解标注依赖关系后的FXNewsProvider定义

```java
public class FXNewsProvider {
    private IFXNewsListener newsListener;
    private IFXNewsPersister newPersistener;

    @Inject
    public FXNewsProvider(IFXNewsListener listener, IFXNewsPersister persister) {
        this.newsListener = listener;
        this.newPersistener = persister;
    }
    // ...
}
```

通过@Inject，我们指明需要IoC ServiceProvider通过构造方法注入方式，为FXNewsProvider注入其所依赖的对象。至于余下的依赖相关信息，在Guice中是由相应的Module来提供的，代码清单3-7给出了FXNewsProvider所使用的Module实现。

代码清单3-7 FXNewsProvider所使用的Module实现

```java
public class NewsBindingModule extends AbstractModule {
    
    @Override
    protected void configure() {
        bind(IFXNewsListener.class)
            .to(DowJonesNewsListener.class)
            .in(Scopes.SINGLETON);
        
        bind(IFXNewsPersister.class)
            .to(DowJonesNewsPersister.class)
            .in(Scopes.SINGLETON);
    }
}
```

通过Module指定进一步的依赖注入相关信息之后，我们就可以直接从Guice那里取得最终已经注入完毕，并直接可用的对象了（见代码清单3-8）。

代码清单3-8 从Guice获取并使用最终绑定完成的FXNewsProvider

```java
Injector injector = Guice.createInjector(new NewsBindingModule()); 
FXNewsProvider newsProvider = injector.getInstance(FXNewsProvider.class); newsProvider.getAndPersistNews(); 
```

当然，注解最终也要通过代码处理来确定最终的注入关系，从这点儿来说，注解方式可以算作编码方式的一种特殊情况。

## 3.3 小结

本章就IoC场景中的主要角色IoC Service Provider给出了言简意赅的介绍。讨论了IoC Service Provider的基本职责，以及它常用的几种依赖关系管理方式。

应该说，IoC Service Provider只是为了简化概念而提出的一个一般性的概念。下一章，我们将由一般到特殊，一起深入了解一个特定的IoC Service Provider实现产品，即Spring提供的IoC容器。