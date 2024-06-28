
我们前面说过，Spring 的 IoC 容器是一个 IoC Service Provider，但是，这只是它被冠以 IoC 之名的部分原因，我们不能忽略的是“容器”。Spring 的 IoC 容器是一个提供 IoC 支持的轻量级容器，除了基本的 IoC 支持，它作为轻量级容器还提供了 IoC 之外的支持。如在 Spring 的 IoC 容器之上，Spring 还提供了相应的 AOP 框架支持、企业级服务集成等服务。Spring 的 IoC 容器和 IoC Service Provider 所提供的服务之间存在一定的交集，二者的关系如图4-1所示。

[] Spring 的 IoC 容器和 IoC Service Provider 之间的关系

> 注意 本章将主要关注Spring的IoC容器提供的IoC相关支持以及衍生的部分高级特性。而IoC容器提供的其他服务将在后继章节中陆续阐述
{: .prompt-danger }

Spring 提供了两种容器类型：BeanFactory 和 ApplicationContext。

* BeanFactory

基础类型 IoC 容器，提供完整的 IoC 服务支持。如果没有特殊指定，默认采用延迟初始化策略（lazy-load）。只有当客户端对象需要访问容器中的某个受管对象的时候，才对该受管对象进行初始化以及依赖注入操作。所以，相对来说，容器启动初期速度较快，所需要的资源有限。对于资源有限，并且功能要求不是很严格的场景，BeanFactory 是比较合适的 IoC 容器选择。

* ApplicationContext

ApplicationContext 在 BeanFactory 的基础上构建，是相对比较高级的容器实现，除了拥有 BeanFactory 的所有支持，ApplicationContext 还提供了其他高级特性，比如事件发布、国际化信息支持等，这些会在后面详述。ApplicationContext 所管理的对象，在该类型容器启动之后，默认全部初始化并绑定完成。所以，相对于 BeanFactory 来说，ApplicationContext 要求更多的系统资源，同时，因为在启动时就完成所有初始化，容器启动时间较之 BeanFactory 也会长一些。在那些系统资源充足，并且要求更多功能的场景中，ApplicationContext 类型的容器是比较合适的选择。

通过图 4-2，我们可以对 BeanFactory 和 ApplicationContext 之间的关系有一个更清晰的认识

> 注意 ApplicationContext 间接继承自 BeanFactory，所以说它是构建于 BeanFactory 之上的 IoC 容器。此外，你应该注意到了，ApplicationContext 还继承了其他三个接口，它们之间的关系，我们将在第5章中详细说明。另外，在没有特殊指明的情况下，以 BeanFactory 为中心所讲述的内容同样适用于 ApplicationContext，这一点需要明确一下，二者有差别的地方会在合适的位置给出解释。
{: .prompt-tip }

BeanFactory，顾名思义，就是生产 Bean 的工厂。当然，严格来说，这个“生产过程”可能不像说起来那么简单。既然 Spring 框架提倡使用 POJO，那么把每个业务对象看作一个 JavaBean 对象，或许更容易理解为什么 Spring 的 IoC 基本容器会起这么一个名字。作为 Spring 提供的基本的 IoC 容器，BeanFactory 可以完成作为 IoC Service Provider 的所有职责，包括业务对象的注册和对象间依赖关系的绑定。

BeanFactory 就像一个汽车生产厂。你从其他汽车零件厂商或者自己的零件生产部门取得汽车零件送入这个汽车生产厂，最后，只需要从生产线的终点取得成品汽车就可以了。相似地，将应用所需的所有业务对象交给 BeanFactory 之后，剩下要做的，就是直接从 BeanFactory 取得最终组装完成并且可用的对象。至于这个最终业务对象如何组装，你不需要关心，BeanFactory 会帮你搞定。

所以，对于客户端来说，与 BeanFactory 打交道其实很简单。最基本地，BeanFactory 肯定会公开一个取得组装完成的对象的方法接口，就像代码清单 4-1 中真正的 BeanFactory 的定义所展示的那样。

代码清单 16 4-1 BeanFactory 的定义

```java
package org.springframework.beans.factory;

public interface BeanFactory {

	String FACTORY_BEAN_PREFIX = "&";

    Object getBean(String name) throws BeansException;

    <T> T getBean(String name, Class<T> requiredType) throws BeansException;
    Object getBean(String name, Object... args) throws BeansException;
    <T> T getBean(Class<T> requiredType) throws BeansException;
    <T> T getBean(Class<T> requiredType, Object... args) throws BeansException;
    <T> ObjectProvider<T> getBeanProvider(Class<T> requiredType);
	<T> ObjectProvider<T> getBeanProvider(ResolvableType requiredType);

	boolean containsBean(String name);
	boolean isSingleton(String name) throws NoSuchBeanDefinitionException;
	boolean isPrototype(String name) throws NoSuchBeanDefinitionException;
	boolean isTypeMatch(String name, ResolvableType typeToMatch) throws NoSuchBeanDefinitionException;
	boolean isTypeMatch(String name, Class<?> typeToMatch) throws NoSuchBeanDefinitionException;

	@Nullable
	Class<?> getType(String name) throws NoSuchBeanDefinitionException;

    @Nullable
	Class<?> getType(String name, boolean allowFactoryBeanInit) throws NoSuchBeanDefinitionException;

    String[] getAliases(String name);
} 
```

上面代码中的方法基本上都是查询相关的方法，例如，取得某个对象的方法（getBean）、查询某个对象是否存在于容器中的方法（containsBean），或者取得某个 bean 的状态或者类型的方法等。因为通常情况下，对于独立的应用程序，只有主入口类才会跟容器的API直接耦合。

## 4.1 拥有 BeanFactory 之后的生活

确切地说，拥有BeanFactory之后的生活没有太大的变化。当然，我的意思是看起来没有太大的变化。到底引入BeanFactory后的生活是什么样子，让我们一起来体验一下吧！ 

依然“拉拉扯扯的事情”。对于应用程序的开发来说，不管是否引入BeanFactory之类的轻量级容器，应用的设计和开发流程实际上没有太大改变。换句话说，针对系统和业务逻辑，该如何设计和实现当前系统不受是否引入轻量级容器的影响。对于我们的FX新闻系统，我们还是会针对系统需求，分别设计相应的接口和实现类。前后唯一的不同，就是对象之间依赖关系的解决方式改变了。这就是所谓的“拉拉扯扯的事情”。之前我们的系统业务对象需要自己去“拉”（Pull）所依赖的业务对象，有了BeanFactory之类的IoC容器之后，需要依赖什么让BeanFactory为我们推过来（Push）就行了。所以，简单点儿说，拥有BeanFactory之后，要使用IoC模式进行系统业务对象的开发。（实际上，即使不使用BeanFactory之类的轻量级容器支持开发，开发中也应该尽量使用IoC模式。）

代码清单 4-2 演示了FX新闻系统初期的设计和实现框架代码

```java
// 1-设计 FXNewsProvider 类用于普遍的新闻处理
public class FXNewsProvider { 
    ... 
} 
// 2-设计 IFXNewsListener 接口抽象各个新闻社不同的新闻获取方式，并给出相应实现类
public interface IFXNewsListener { 
    ... 
} 
// 以及
public class DowJonesNewsListener implements IFXNewsListener { 
    ... 
} 
// 3-设计 IFXNewsPersister 接口抽象不同数据访问方式，并实现相应的实现类
public interface IFXNewsPersister { 
    ... 
} 
// 以及
public class DowJonesNewsPersister implements IFXNewsPersister { 
    ... 
} 
```

BeanFactory 会说，这些让我来干吧。既然使用 IoC 模式开发的业务对象现在不用自己操心如何解决相互之间的依赖关系，那么肯定得找人来做这个工作。毕竟，工作最终是要有人来做的，大家都不动手，那工作就不能进行了。当 BeanFactory 说这些事情让它来做的时候，可能没有告诉你它会怎么来做这个事情。不过没关系，稍后我会详细告诉你它是如何做的。通常情况下，它会通过常用的 XML 文件来注册并管理各个业务对象之间的依赖关系，就像代码清单 4-3 所演示的那样。

代码清单 4-3 使用 BeanFactory 的XML配置方式实现业务对象间的依赖管理

```xml
<beans>
    <bean id="djNewsProvider" class="..FXNewsProvider"> 
        <constructor-arg index="0"> 
            <ref bean="djNewsListener"/> 
        </constructor-arg> 
        <constructor-arg index="1">  
            <ref bean="djNewsPersister"/> 
        </constructor-arg> 
    </bean> 
 ... 
</beans>
```

拉响启航的汽笛。在BeanFactory出现之前，我们通常会直接在应用程序的入口类的main方法中，自己实例化相应的对象并调用之，如以下代码所示：

```java
    FXNewsProvider newsProvider = new FXNewsProvider(); 
    newsProvider.getAndPersistNews(); 
```

不过，现在既然有了 BeanFactory，我们通常只需将“生产线图纸”交给 BeanFactory，让 BeanFactory 为我们生产一个 FXNewsProvider，如以下代码所示：

```java
    BeanFactory container = new XmlBeanFactory(new ClassPathResource("配置文件路径")); 
    FXNewsProvider newsProvider = (FXNewsProvider)container.getBean("djNewsProvider"); 
    newsProvider.getAndPersistNews(); 
```

或者如以下代码所示：

```java
    ApplicationContext container = new ClassPathXmlApplicationContext("配置文件路径"); 
    FXNewsProvider newsProvider = (FXNewsProvider)container.getBean("djNewsProvider"); 
    newsProvider.getAndPersistNews();
```

亦或如以下代码所示：

```java
    ApplicationContext container = new FileSystemXmlApplicationContext("配置文件路径"); 
    FXNewsProvider newsProvider = (FXNewsProvider)container.getBean("djNewsProvider"); 
    newsProvider.getAndPersistNews(); 
```

这就是拥有 BeanFactory 后的生活。当然，这只是使用 BeanFactory 后开发流程的一个概览而已，具体细节请容我慢慢道来。

## 4.2 BeanFactory 的对象注册与依赖绑定方式

BeanFactory 作为一个 IoC Service Provider，为了能够明确管理各个业务对象以及业务对象之间的依赖绑定关系，同样需要某种途径来记录和管理这些信息。上一章在介绍 IoC Service Provider 时，我们提到通常会有三种方式来管理这些信息。而 BeanFactory 几乎支持所有这些方式，很令人兴奋，不是吗？ 

### 4.2.1 直接编码方式

其实，把编码方式单独提出来称作一种方式并不十分恰当。因为不管什么方式，最终都需要编码才能“落实”所有信息并付诸使用。不过，通过这些代码，起码可以让我们更加清楚 BeanFactory 在底层是如何运作的。下面来看一下我们的FX新闻系统相关类是如何注册并绑定的（见代码清单4-4）。 

代码清单4-4 通过编码方式使用BeanFactory实现FX新闻相关类的注册及绑定

```java
public static void main(String[] args) {
    DefaultListableBeanFactory beanRegistry = new DefaultListableBeanFactory();
    BeanFactory container = (BeanFactory)bindViaCode(beanRegistry);
    FXNewsProvider newsProvider = (FXNewsProvider)container.getBean("djNewsProvider");
    newsProvider.getAndPersistNews();
}

public static BeanFactory bindViaCode(BeanDefinitionRegistry registry) {
    AbstractBeanDefinition newsProvider = new RootBeanDefinition(FXNewsProvider.class,true);
    AbstractBeanDefinition newsListener = new RootBeanDefinition(DowJonesNewsListener.class, true);
    AbstractBeanDefinition newsPersister = new RootBeanDefinition(DowJonesNewsPersister.class, true);
    // 将bean定义注册到容器中
    registry.registerBeanDefinition("djNewsProvider", newsProvider);
    registry.registerBeanDefinition("djListener", newsListener);
    registry.registerBeanDefinition("djPersister", newsPersister);
    // 指定依赖关系
    // 1. 可以通过构造方法注入方式
    ConstructorArgumentValues argValues = new ConstructorArgumentValues(); 
    argValues.addIndexedArgumentValue(0, newsListener); 
    argValues.addIndexedArgumentValue(1, newsPersister); 
    newsProvider.setConstructorArgumentValues(argValues); 
    // 2. 或者通过setter方法注入方式
    MutablePropertyValues propertyValues = new MutablePropertyValues(); 
    propertyValues.addPropertyValue(new ropertyValue("newsListener", newsListener)); 
    propertyValues.addPropertyValue(new PropertyValue("newPersistener", newsPersister)); 
    newsProvider.setPropertyValues(propertyValues); 
    // 绑定完成
    return (BeanFactory)registry; 
} 
```

> 在Spring的术语中，把BeanFactory需要使用的对象注册和依赖绑定信息称为Configuration Metadata。我们这里所展示的，实际上就是组织这些Configuration Metadata的各种方式。因此这个标题才这么长
{: .prompt-warning }

BeanFactory 只是一个接口，我们最终需要一个该接口的实现来进行实际的Bean的管理，efaultListableBeanFactory 就是这么一个比较通用的 BeanFactory 实现类。DefaultListableBeanFactory除了间接地实现了 BeanFactory 接口，还实现了 BeanDefinitionRegistry 接口，该接口才是在BeanFactory的实现中担当Bean注册管理的角色。基本上，BeanFactory接口只定义如何访问容器内管理的Bean的方法，各个BeanFactory的具体实现类负责具体Bean的注册以及管理工作。BeanDefinitionRegistry接口定义抽象了Bean的注册逻辑。通常情况下，具体的BeanFactory实现类会实现这个接口来管理Bean的注册。

它们之间的关系如图4-3所示。

打个比方说，BeanDefinitionRegistry就像图书馆的书架，所有的书是放在书架上的。虽然你还书或者借书都是跟图书馆（也就是BeanFactory，或许BookFactory可能更好些）打交道，但书架才是图书馆存放各类图书的地方。所以，书架相对于图书馆来说，就是它的“BookDefinitionRegistry”。 11 每一个受管的对象，在容器中都会有一个BeanDefinition的实例（instance）与之相对应，该BeanDefinition的实例负责保存对象的所有必要信息，包括其对应的对象的class类型、是否是抽象类、构造方法参数以及其他属性等。当客户端向BeanFactory请求相应对象的时候，BeanFactory会通过这些信息为客户端返回一个完备可用的对象实例。RootBeanDefinition和ChildBeanDefinition是BeanDefinition的两个主要实现类。

现在，我们再来看这段绑定代码，应该就有“柳暗花明”的感觉了。

在 main 方法中，首先构造一个 DefaultListableBeanFactory 作为 BeanDefinitionRegistry，然后将其交给bindViaCode方法进行具体的对象注册和相关依赖管理，然后通过bindViaCode返回的BeanFactory取得需要的对象，最后执行相应逻辑。在我们的实例里，当
然就是取得FXNewsProvider进行新闻的处理。

在bindViaCode方法中，首先针对相应的业务对象构造与其相对应的BeanDefinition，使用了 RootBeanDefinition 作 为 BeanDefinition 的实现类。构造完成后，将这些BeanDefinition注册到通过方法参数传进来的BeanDefinitionRegistry中。之后，因为我们的FXNewsProvider是采用的构造方法注入，所以，需要通过ConstructorArgumentValues为其注入相关依赖。在这里为了同时说明setter方法注入，也同时展示了在Spring中如何使用代码实现setter方法注入。如果要运行这段代码，需要把setter方法注入部分的4行代码注释掉。最后，以BeanFactory的形式返回已经注册并绑定了所有相关业务对象的BeanDefinitionRegistry实例

> 小心 最后一行的强制类型转换是有特定场景的。因为传入的DefaultListableBeanFactory同时实现了BeanFactory和BeanDefinitionRegistry接口，所以，这样做强制类型转换不会出现问题。但需要注意的是，单纯的BeanDefinitionRegistry是无法强制转换到BeanFactory类型的！
{: .prompt-warning}

### 4.2.2 外部配置文件方式

Spring的IoC容器支持两种配置文件格式：Properties文件格式和XML文件格式。当然，如果你愿意也可以引入自己的文件格式，前提是真的需要。
采用外部配置文件时，Spring的IoC容器有一个统一的处理方式。通常情况下，需要根据不同的外部配置文件格式，给出相应的BeanDefinitionReader实现类，由BeanDefinitionReader的相应实现类负责将相应的配置文件内容读取并映射到BeanDefinition，然后将映射后的BeanDefinition注册到一个BeanDefinitionRegistry，之后，BeanDefinitionRegistry即完成Bean的注册和加载。

当然，大部分工作，包括解析文件格式、装配BeanDefinition之类的工作，都是由BeanDefinitionReader的相应实现类来做的，BeanDefinitionRegistry只不过负责保管而已。整个过程类似于如下代码： 

```java
    BeanDefinitionRegistry beanRegistry = <某个BeanDefinitionRegistry实现类通常为DefaultListableBeanFactory>; 
    BeanDefinitionReader beanDefinitionReader = new BeanDefinitionReaderImpl(beanRegistry); 
    beanDefinitionReader.loadBeanDefinitions("配置文件路径"); 
    // 现在我们就取得了一个可用的BeanDefinitionRegistry实例
```
1. Properties配置格式的加载

Spring提供了org.springframework.beans.factory.support.PropertiesBeanDefinitionReader类用于Properties格式配置文件的加载，所以，我们不用自己去实现BeanDefinitionReader，只要根据该类的读取规则，提供相应的配置文件即可。

对于FXNews系统的业务对象，我们采用如下文件内容（见代码清单4-5）进行配置加载。

代码清单4-5 Properties格式表达的依赖注入配置内容

```plaintext
djNewsProvider.(class)=..FXNewsProvider 
# ----------通过构造方法注入的时候------------- 
djNewsProvider.$0(ref)=djListener 
djNewsProvider.$1(ref)=djPersister 
# ----------通过setter方法注入的时候--------- 
# djNewsProvider.newsListener(ref)=djListener 
# djNewsProvider.newPersistener(ref)=djPersister

djListener.(class)=..impl.DowJonesNewsListener

djPersister.(class)=..impl.DowJonesNewsPersister
```

这些内容是特定于Spring的PropertiesBeanDefinitionReader的，要了解更多内容，请参照 Spring的API参考文档。我们可以很容易地看明白代码清单4-5中的配置内容所要表达的意思。

- djNewsProvider作为beanName，后面通过.(class)表明对应的实现类是什么，实际上使用djNewsProvider.class=...的形式也是可以的，但Spring 1.2.6之后不再提倡使用，而提倡使用.(class)的形式。其他两个类的注册，djListener和djPersister，也是相同的道理。
- 通过在表示beanName的名称后添加.$[number]后缀的形式，来表示当前beanName对应的对象需要通过构造方法注入的方式注入相应依赖对象。在这里，我们分别将构造方法的第一个参数和第二个参数对应到djListener和djPersister。需要注意的一点，就是$0和$1后面的(ref)，(ref)用来表示所依赖的是引用对象，而不是普通的类型。如果不加(ref)，PropertiesBeanDefinitionReader会将djListener和djPersister作为简单的String类型进行注入，异常自然不可避免啦。
- FXNewsProvider采用的是构造方法注入，而为了演示setter方法注入在Properties配置文件中又是一个什么样子，以便于你更全面地了解基于Properties文件的配置方式，我们在下面增加了setter方法注入的例子，不过进行了注释。实际上，与构造方法注入最大的区别就是，它不使用数字顺序来指定注入的位置，而使用相应的属性名称来指定注入。newsListener和newPersistener恰好就是我们的FXNewsProvider类中所声明的属性名称。这印证了之前在比较构造方法注入和setter方法注入方式不同时提到的差异，即构造方法注入无法通过参数名称来标识注入的确切位置，而setter方法注入则可以通过属性名称来明确标识注入。与在Properties中表达构造方法注入一样，同样需要注意，如果属性名称所依赖的是引用对象，那么一定不要忘了(ref)。

当这些对象之间的注册和依赖注入信息都表达清楚之后，就可以将其加载到BeanFactory而付诸使用了。而这个加载过程实际上也就像我们之前总体上所阐述的那样，代码清单4-6中的内容再次演示了类似的加载过程。

代码清单4-6 加载Properties配置的BeanFactory的使用演示 

```java
public static void main(String[] args) {

    DefaultListableBeanFactory beanRegistry = new DefaultListableBeanFactory();
    BeanFactory container = (BeanFactory)bindViaPropertiesFile(beanRegistry);
    FXNewsProvider newsProvider = (FXNewsProvider)container.getBean("djNewsProvider");
    newsProvider.getAndPersistNews(); 
} 

public static BeanFactory bindViaPropertiesFile(BeanDefinitionRegistry registry) {

    PropertiesBeanDefinitionReader reader = new PropertiesBeanDefinitionReader(registry);
    reader.loadBeanDefinitions("classpath:../../binding-config.properties");

    return (BeanFactory)registry; 
}
```

基于Properties的加载方式就是这么简单，所有的信息配置到Properties文件即可，不用再通过冗长的代码来完成对象的注册和依赖绑定。这些工作就交给相应的BeanDefinitionReader来做吧！哦，我的意思是，让给PropertiesBeanDefinitionReader来做。

> 注意 Spring提供的PropertiesBeanDefinitionReader是按照Spring自己的文件配置规则进行加载的，而同样的道理，你也可以按照自己的规则来提供相应的Properties配置文件。只不过，现在需要实现你自己的“PropertiesBeanDefinitionReader”来读取并解析。这当然有“重新发明轮子”之嫌，不过，如果你只是想试验一下，也可以尝试哦。无非就是按照自己的规则把各个业务对象信息读取后，将编码方式的代码改造一下放到你自己的“PropertiesBeanDefinitionReader”而已。
{: .prompt-info }

2. XML配置格式的加载

XML配置格式是Spring支持最完整，功能最强大的表达方式。当然，一方面这得益于XML良好的语意表达能力；另一方面，就是Spring框架从开始就自始至终保持XML配置加载的统一性。同Properties配置加载类似，现在只不过是转而使用XML而已。Spring 2.x之前，XML配置文件采用DTD（Document Type Definition）实现文档的格式约束。2.x之后，引入了基于XSD（XML Schema Definition）的约束方式。不过，原来的基于DTD的方式依然有效，因为从DTD转向XSD只是“形式”上的转变，所以，后面的大部分讲解还会沿用DTD的方式，只有必要时才会给出特殊说明。

如果FX新闻系统对象按照XML配置方式进行加载的话，配置文件内容如代码清单4-7所示。

代码清单4-7 FX新闻系统相关类对应XML格式的配置内容

```xml
<?xml version="1.0" encoding="UTF-8"?> 
<!DOCTYPE beans PUBLIC "-//SPRING//DTD BEAN//EN" "http://www.springframework.org/dtd/spring-beans.dtd"> 
<beans> 
    <bean id="djNewsProvider" class="..FXNewsProvider"> 
        <constructor-arg index="0"> 
            <ref bean="djNewsListener"/> 
        </constructor-arg> 
        <constructor-arg index="1"> 
            <ref bean="djNewsPersister"/> 
        </constructor-arg> 
    </bean> 

    <bean id="djNewsListener" class="..impl.DowJonesNewsListener"> 
    </bean> 

    <bean id="djNewsPersister" class="..impl.DowJonesNewsPersister"> 
    </bean> 
</beans> 
```

我想这段内容不需要特殊说明吧，应该比Properties文件的内容要更容易理解。如果想知道这些内容背后的更多玄机，往后看吧！

有了XML配置文件，我们需要将其内容加载到相应的BeanFactory实现中，以供使用，如代码清单4-8所示。

代码清单4-8 加载XML配置文件的BeanFactory的使用演示

```java
public static void main(String[] args) {

    DefaultListableBeanFactory beanRegistry = new DefaultListableBeanFactory(); 
    BeanFactory container = (BeanFactory)bindViaXMLFile(beanRegistry); 
    FXNewsProvider newsProvider = (FXNewsProvider)container.getBean("djNewsProvider"); 
    newsProvider.getAndPersistNews(); 
} 

public static BeanFactory bindViaXMLFile(BeanDefinitionRegistry registry) { 

    XmlBeanDefinitionReader reader = new XmlBeanDefinitionReader(registry); 
    reader.loadBeanDefinitions("classpath:../news-config.xml");

    return (BeanFactory)registry; 
    // 或者直接
    //return new XmlBeanFactory(new ClassPathResource("../news-config.xml")); 
}
```

与为Properties配置文件格式提供PropertiesBeanDefinitionReader相对应，Spring同样为XML格式的配置文件提供了现成的BeanDefinitionReader实现，即XmlBeanDefinitionReader。XmlBeanDefinitionReader负责读取Spring指定格式的XML配置文件并解析，之后将解析后的文件内容映射到相应的BeanDefinition，并加载到相应的BeanDefinitionRegistry中（在这里是efaultListableBeanFactory）。这时，整个BeanFactory就可以放给客户端使用了。

除了提供XmlBeanDefinitionReader用于XML格式配置文件的加载，Spring还在DefaultListableBeanFactory的基础上构建了简化XML格式配置加载的XmlBeanFactory实现。从以上代码最后注释掉的一行，你可以看到使用了XmlBeanFactory之后，完成XML的加载和BeanFactory的初始化是多么简单。

> **注意** 当然，如果你愿意，就像Properties方式可以扩展一样，XML方式的加载同样可以扩展。虽然XmlBeanFactory基本上已经十分完备了，但如果出于某种目的，XmlBeanFactory或者默认的XmlBeanDefinitionReader所使用的XML格式无法满足需要的话，你同样可以通过扩展XmlBeanDefinitionReader或者直接实现自己的BeanDefinitionReader来达到自定义XML配置文件加载的目的。Spring的可扩展性为你服务！ 
{: .prompt-info }

### 4.2.3 注解方式

可能你没有注意到，我在提到BeanFactory所支持的对象注册与依赖绑定方式的时候，说的是BeanFactory“几乎”支持IoC Service Provider可能使用的所有方式。之所以这么说，有两个原因。 

- 在Spring 2.5发布之前，Spring框架并没有正式支持基于注解方式的依赖注入；
- Spring 2.5发布的基于注解的依赖注入方式，如果不使用classpath-scanning功能的话，仍然部分依赖于“基于XML配置文件”的依赖注入方式。

另外，注解是Java 5之后才引入的，所以，以下内容只适用于应用程序使用了Spring 2.5以及Java 5或者更高版本的情况之下。

如果要通过注解标注的方式为FXNewsProvider注入所需要的依赖，现在可以使用@Autowired以及@Component对相关类进行标记。代码清单4-9演示了FXNews相关类使用指定注解标注后的情况。

代码清单4-9 使用指定注解标注后的FXNews相关类

```java
@Component 
public class FXNewsProvider { 
    @Autowired
    private IFXNewsListener newsListener; 
    @Autowired 
    private IFXNewsPersister newPersistener; 
 
    public FXNewsProvider(IFXNewsListener newsListner,IFXNewsPersister newsPersister) { 
        this.newsListener = newsListner; 
        this.newPersistener = newsPersister; 
    } 
    ... 
} 

@Component 
public class DowJonesNewsListener implements IFXNewsListener { 
... 
} 

@Component 
public class DowJonesNewsPersister implements IFXNewsPersister { 
... 
} 
```

@Autowired是这里的主角，它的存在将告知Spring容器需要为当前对象注入哪些依赖对象。而@Component则是配合Spring 2.5中新的classpath-scanning功能使用的。现在我们只要再向Spring的配置文件中增加一个“触发器”，使用@Autowired和@Component标注的类就能获得依赖对象的注入了。代码清单4-10给出的正是针对这部分功能的配置内容。

代码清单4-10 配置使用classpath-scanning功能

```xml
<?xml version="1.0" encoding="UTF-8"?> 
<beans xmlns="http://www.springframework.org/schema/beans"  
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  
xmlns:context="http://www.springframework.org/schema/context"  
xmlns:tx="http://www.springframework.org/schema/tx"  
xsi:schemaLocation="http://www.springframework.org/schema/beans  
http://www.springframework.org/schema/beans/spring-beans-2.5.xsd  
http://www.springframework.org/schema/context  
http://www.springframework.org/schema/context/spring-context-2.5.xsd  
http://www.springframework.org/schema/tx  
http://www.springframework.org/schema/tx/spring-tx-2.5.xsd"> 
    <context:component-scan base-package="cn.spring21.project.base.package"/> 
</beans> 
```

\<context:component-scan/>会到指定的包（package）下面扫描标注有@Component的类，如果找到，则将它们添加到容器进行管理，并根据它们所标注的@Autowired为这些类注入符合条件的依赖对象。

在以上所有这些工作都完成之后，我们就可以像通常那样加载配置并执行当前应用程序了，如以下代码所示：

```java
public static void main(String[] args) { 
    ApplicationContext ctx = new ClassPathXmlApplicationContext("配置文件路径"); 
    FXNewsProvider newsProvider = (FXNewsProvider)container.getBean("FXNewsProvider"); 
    newsProvider.getAndPersistNews(); 
}
```
 
本章最后将详细讲解Spring 2.5新引入的“基于注解的依赖注入”。当前的内容只是让我们先从总体上有一个大概的印象，所以，不必强求自己现在就完全理解它们。

> 注意 Google Guice是一个完全基于注解方式、提供依赖注入服务的轻量级依赖注入框架，可以 从Google Guice的站点获取有关这个框架的更多信息。
{: .prompt-tip }

## 4.3 BeanFactory的XML之旅

XML格式的容器信息管理方式是Spring提供的最为强大、支持最为全面的方式。从Spring的参考文档到各Spring相关书籍，都是按照XML的配置进行说明的，这部分内容可以让你充分领略到Spring的IoC容器的魅力，以致于我们也不得不带你初次或者再次踏上Spring的XML之旅。

### 4.3.1 \<beans>和\<bean>

所有使用 XML 文件进行配置信息加载的 Spring IoC 容器，包括 BeanFactory 和ApplicationContext的所有XML相应实现，都使用统一的XML格式。在Spring 2.0版本之前，这种格式由Spring提供的DTD规定，也就是说，所有的Spring容器加载的XML配置文件的头部，都需要以下形式的DOCTYPE声明： 

```xml
<?xml version="1.0" encoding="UTF-8"?> 
<!DOCTYPE beans PUBLIC "-//SPRING//DTD BEAN//EN" "http://www.springframework.org/dtd/spring-beans.dtd"> 
<beans> 
 ... 
</beans>
```

从Spring 2.0版本之后，Spring在继续保持向前兼容的前提下，既可以继续使用DTD方式的DOCTYPE进行配置文件格式的限定，又引入了基于XML Schema的文档声明。所以，Spring 2.0之后，同样可以使用代码清单4-11所展示的基于XSD的文档声明。

代码清单 12 4-11 基于XSD的Spring配置文件文档声明

```xml
<beans xmlns="http://www.springframework.org/schema/beans" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:util="http://www.springframework.org/schema/util"  
xmlns:jee="http://www.springframework.org/schema/jee"  
xmlns:lang="http://www.springframework.org/schema/lang"  
xmlns:aop="http://www.springframework.org/schema/aop"  
xmlns:tx="http://www.springframework.org/schema/tx"  
xsi:schemaLocation="http://www.springframework.org/schema/beans  
http://www.springframework.org/schema/beans/spring-beans-2.0.xsd  
http://www.springframework.org/schema/util  
http://www.springframework.org/schema/util/spring-util-2.0.xsd  
http://www.springframework.org/schema/jee  
http://www.springframework.org/schema/jee/spring-jee-2.0.xsd  
http://www.springframework.org/schema/lang 
http://www.springframework.org/schema/lang/spring-lang-2.0.xsd  
http://www.springframework.org/schema/aop  
http://www.springframework.org/schema/aop/spring-aop-2.0.xsd  
http://www.springframework.org/schema/tx  
http://www.springframework.org/schema/tx/spring-tx-2.0.xsd">
</beans> 
```

不过，不管使用哪一种形式的文档声明，实际上限定的元素基本上是相同的。让我们从最顶层的元素开始，看一下这两种文档声明都限定了哪些元素吧！

所有注册到容器的业务对象，在Spring中称之为Bean。所以，每一个对象在XML中的映射也自然而然地对应一个叫做\<bean>的元素。既然容器最终可以管理所有的业务对象，那么在XML中把这些叫做\<bean>的元素组织起来的，就叫做\<beans>。多个\<bean>组成一个\<beans>很容易理解，不是吗？

#### 1. \<beans>之唯我独尊

\<beans>是XML配置文件中最顶层的元素，它下面可以包含0或者1个\<description>和多个
\<bean>以及\<import>或者\<alias>，如图4-4所示。 

图4-4 \<beans>与下一层元素的关系

\<beans>作为所有\<bean>的“统帅”，它拥有相应的属性（attribute）对所辖的\<bean>进行统一的默认行为设置，包括如下几个。

- default-lazy-init。其值可以指定为true或者false，默认值为false。用来标志是否对所有的\<bean>进行延迟初始化。
- default-autowire。可以取值为no、byName、byType、constructor以及autodetect。默认值为no，如果使用自动绑定的话，用来标志全体bean使用哪一种默认绑定方式。
- default-dependency-check。可以取值none、objects、simple以及all，默认值为none，即不做依赖检查。
- default-init-method。如果所管辖的\<bean>按照某种规则，都有同样名称的初始化方法的话，可以在这里统一指定这个初始化方法名，而不用在每一个\<bean>上都重复单独指定。
- default-destroy-method。与default-init-method相对应，如果所管辖的bean有按照某种规则使用了相同名称的对象销毁方法，可以通过这个属性统一指定。

> **注意** 当然，如果你不清楚上面这些默认的属性具体有什么用，那也不必着急。在看完对\<bean>的讲解之后，再回头来看，就会明了多了。给出这些信息，是想让你知道，如果在某个场景下需要对大部分\<bean>都重复设置某些行为的话，可以回头看一下，利用\<beans>是否可以减少这种不必要的工作。
{: .prompt-tip }

#### 2. \<description>、\<import>和\<alias>

之所以把这几个元素放到一起讲解，是因为通常情况下它们不是必需的。不过，了解一下也没什么不好，不是吗？

- \<description> 

可以通过\<description>在配置的文件中指定一些描述性的信息。通常情况下，该元素是省略的。当然，如果愿意，\<description>随时可以为我们效劳。

- \<import> 

通常情况下，可以根据模块功能或者层次关系，将配置信息分门别类地放到多个配置文件中。在想加载主要配置文件，并将主要配置文件所依赖的配置文件同时加载时，可以在这个主要的配置文件中通过\<import>元素对其所依赖的配置文件进行引用。比如，如果A.xml中的\<bean>定义可能依赖B.xml中的某些<bean>定义，那么就可以在A.xml中使用\<import>将B.xml引入到A.xml，以类似于\<import resource="B.xml"/>的形式。

但是，这个功能在我看来价值不大，因为容器实际上可以同时加载多个配置，没有必要非通过一个配置文件来加载所有配置。不过，或许在有些场景中使用这种方式比较方便也说不定。

- \<alias>

可以通过\<alias>为某些\<bean>起一些“外号”（别名），通常情况下是为了减少输入。比如，假设有个\<bean>，它的名称为dataSourceForMasterDatabase，你可以为其添加一个\<alias>，像这样\<alias name="dataSourceForMasterDatabase" alias="masterDataSource"/>。以后通过dataSourceForMasterDatabase或者masterDataSource来引用这个\<bean>都可以，只要你觉得方便就行。

### 4.3.2 孤孤单单一个人

哦，错了，是孤孤单单一个Bean。每个业务对象作为个体，在Spring的XML配置文件中是与\<bean>元素一一对应的。窥一斑而知全豹，只要我们了解单个的业务对象是如何配置的，剩下的就可以“依葫芦画瓢”了。所以，让我们先从最简单的单一对象配置开始吧！如下代码演示了最基础的对象配置形式：

```xml
    <bean id="djNewsListener" class="..impl.DowJonesNewsListener">
    </bean>
```

- id属性

通常，每个注册到容器的对象都需要一个唯一标志来将其与“同处一室”的“兄弟们”区分开来，就好像我们每一个人都有一个身份证号一样（重号的话就比较麻烦）。通过id属性来指定当前注册对象的beanName是什么。这里，通过id指定beanName为djNewsListener。实际上，并非任何情况下都需要指定每个\<bean>的id，有些情况下，id可以省略，比如后面会提到的内部\<bean>以及不需要根据beanName明确依赖关系的场合等。

除了可以使用id来指定\<bean>在容器中的标志，还可以使用name属性来指定\<bean>的别名（alias）。比如，以上定义，我们还可以像如下代码这样，为其添加别名： 

```xml
<bean id="djNewsListener" 
    name="/news/djNewsListener,dowJonesNewsListener" 
    class="..impl.DowJonesNewsListener"> 
</bean>
```

与id属性相比，name属性的灵活之处在于，name可以使用id不能使用的一些字符，比如/。而且还可以通过逗号、空格或者冒号分割指定多个name。name的作用跟使用\<alias>为id指定多个别名基本相同： 

```xml
<alias name="djNewsListener" alias="/news/djNewsListener"/> 
<alias name="djNewsListener" alias="dowJonesNewsListener"/>
```

- class属性

每个注册到容器的对象都需要通过\<bean>元素的class属性指定其类型，否则，容器可不知道这个对象到底是何方神圣。在大部分情况下，该属性是必须的。仅在少数情况下不需要指定，如后面将提到的在使用抽象配置模板的情况下。

### 4.3.3 Help Me, Help You

> 这句话是Warcraft中女巫的一句台词，这里用这句话来类比多个\<bean>之间的关系：互相依赖，互相帮助以完成同一目标。
{: .prompt-tip }

在大部分情况下，你不太可能选择单独“作战”，业务对象也是；各个业务对象之间会相互协作来更好地完成同一使命。这时，各个业务对象之间的相互依赖就是无法避免的。对象之间需要相互协作，在横向上它们存在一定的依赖性。而现在我们就是要看一下，在Spring的IoC容器的XML配置中，应该如何表达这种依赖性。

既然业务对象现在都符合IoC的规则，那么要了解的表达方式其实也很简单，无非就是看一下构造方法注入和setter方法注入通过XML是如何表达的而已。那么，让我们开始吧！

#### 1. 构造方法注入的XML之道

按照Spring的IoC容器配置格式，要通过构造方法注入方式，为当前业务对象注入其所依赖的对象，需要使用\<constructor-arg>。正常情况下，如以下代码所示：

```xml
<bean id="djNewsProvider" class="..FXNewsProvider"> 
    <constructor-arg> 
        <ref bean="djNewsListener"/> 
    </constructor-arg> 
    <constructor-arg> 
        <ref bean="djNewsPersister"/> 
    </constructor-arg> 
</bean>
```

对于\<ref>元素，稍后会进行详细说明。这里你只需要知道，通过这个元素来指明容器将为djNewsProvider这个\<bean>注入通过\<ref>所引用的Bean实例。这种方式可能看起来或者编写起来不是很简洁，最新版本的Spring也支持配置简写形式，如以下代码所示：

```xml
<bean id="djNewsProvider" class="..FXNewsProvider"> 
 <constructor-arg ref="djNewsListener"/> 
 <constructor-arg ref="djNewsPersister"/> 
</bean>
```

简洁多了不是嘛？其实，无非就是表达方式不同而已，实际达到的效果是一样的。

有些时候，容器在加载XML配置的时候，因为某些原因，无法明确配置项与对象的构造方法参数列表的一一对应关系，就需要请\<constructor-arg>的type或者index属性出马。比如，对象存在多个构造方法，当参数列表数目相同而类型不同的时候，容器无法区分应该使用哪个构造方法来实例化对象，或者构造方法可能同时传入最少两个类型相同的对象。

- type属性

假设有一个对象定义如代码清单4-12所示。

代码清单4-12 随意声明的一个业务对象定义

```java
public class MockBusinessObject { 

    private String dependency1; 
    private int dependency2; 

    public MockBusinessObject(String dependency) { 
        this.dependency1 = dependency; 
    } 

    public MockBusinessObject(int dependency) {
        this.dependency2 = dependency; 
    } 

    ... 
 
    @Override 
    public String toString() { 
        return new ToStringBuilder(this)
        .append("dependency1", dependency1)
        .append("dependency2", dependency2).toString(); 
    } 
}
```

该类声明了两个构造方法，分别都只是传入一个参数，且参数类型不同。这时，我们可以进行配置，如以下代码所示：

```xml
<bean id="mockBO" class="..MockBusinessObject"> 
    <constructor-arg> 
        <value>111111</value> 
    </constructor-arg> 11 </bean>
```

如果从BeanFactory取得该对象并调用toString()查看的话，我们会发现Spring调用的是第一个构造方法，因为输出是如下内容：

..MockBusinessObject@f73c1[dependency1=111111,dependency2=0] 
 
但是，如果我们想调用的却是第二个传入int类型参数的构造方法，又该如何呢？可以使用type属性，通过指定构造方法的参数类型来解决这一问题，配置内容如下代码所示：

```xml
<bean id="mockBO" class="..MockBusinessObject"> 
    <constructor-arg type="int"> 
        <value>111111</value> 
    </constructor-arg> 
</bean>
```

现在，我们得到了自己想要的对象实例，如下的控制台输出信息印证了这一点： 

..MockBusinessObject@f73c1[dependency1=<null>,dependency2=111111] 

- index属性

当某个业务对象的构造方法同时传入了多个类型相同的参数时，Spring又该如何将这些配置中的信息与实际对象的参数一一对应呢？好在，如果配置项信息和对象参数可以按照顺序初步对应的话，Spring还是可以正常工作的，如代码清单4-13所示。

代码清单4-13 随意声明的一个业务对象定义

```java
public class MockBusinessObject { 

    private String dependency1; 
    private String dependency2; 

    public MockBusinessObject(String dependency1,String dependency2) { 
        this.dependency1 = dependency1; 
        this.dependency2 = dependency2; 
    } 
    ... 
 
    @Override 
    public String toString() { 
        return new ToStringBuilder(this)
        .append("dependency1", dependency1)
        .append("dependency2", dependency2).toString(); 
    } 
}
```

并且，配置内容如以下代码所示：

```xml
<bean id="mockBO" class="..MockBusinessObject"> 
    <constructor-arg value="11111"/> 
    <constructor-arg value="22222"/> 
</bean>
``` 

那么，我们可以得到如下对象：

..MockBusinessObject@1ef8cf3[dependency1=11111,dependency2=22222]

但是，如果要让“11111”作为对象的第二个参数，而将“22222”作为第一个参数来构造对象，又该如何呢？好！可以颠倒配置项，如以下代码所示：

```xml
<bean id="mockBO" class="..MockBusinessObject"> 
    <constructor-arg value="22222"/> 
    <constructor-arg value="11111"/> 
</bean>
```

不过，还有一种方式，那就是像如下代码所示的那样，使用index属性：

```xml
<bean id="mockBO" class="..MockBusinessObject"> 
    <constructor-arg index="1" value="11111"/> 
    <constructor-arg index="0" value="22222"/> 
</bean>
```

这时，同样可以得到想要的对象实例，以下控制台输出表明了这一点：

..MockBusinessObject@ecd7e[dependency1=22222,dependency2=11111]

> 注意 index属性的取值从0开始，与一般的数组下标取值相同。所以，指定的第一个参数的index应该是0，第二个参数的index应该是1，依此类推。
{: .prompt-info }

#### 2. setter方法注入的XML之道

与构造方法注入可以使用\<constructor-arg>注入配置相对应，Spring为setter方法注入提供了\<property>元素。

\<property>有一个name属性（attribute），用来指定该\<property>将会注入的对象所对应的实例变量名称。之后通过value或者ref属性或者内嵌的其他元素来指定具体的依赖对象引用或者值，如以下代码所示：

```xml
<bean id="djNewsProvider" class="..FXNewsProvider"> 
    <property name="newsListener"> 
        <ref bean="djNewsListener"/> 
    </property> 
    <property name="newPersistener"> 
        <ref bean="djNewsPersister"/> 
    </property> 
</bean>
```

当然，如果只是使用\<property>进行依赖注入的话，请确保你的对象提供了默认的构造方法，也就是一个参数都没有的那个。

以上配置形式还可以简化为如下形式： 

```xml
<bean id="djNewsProvider" class="..FXNewsProvider"> 
    <property name="newsListener" ref="djNewsListener"/> 
    <property name="newPersistener" ref="djNewsPersister"/> 
</bean>
```

使用\<property>的setter方法注入和使用\<constructor-arg>的构造方法注入并不是水火不容的。实际上，如果需要，可以同时使用这两个元素：

```xml
<bean id="mockBO" class="..MockBusinessObject"> 
    <constructor-arg value="11111"/> 
    <property name="dependency2" value="22222"/> 
</bean>
```

当然，现在需要MockBusinessObject提供一个只有一个String类型参数的构造方法，并且为dependency2提供了相应的setter方法。代码清单4-14演示了符合条件的一个业务对象定义。

代码清单4-14 随意声明的一个同时支持构造方法注入和setter方法注入的对象定义

```java
public class MockBusinessObject { 

    private String dependency1; 
    private String dependency2; 
 
public MockBusinessObject(String dependency) { 
    this.dependency1 = dependency; 
} 

public void setDependency2(String dependency2) { 
    this.dependency2 = dependency2; 
} 
 ... 
}
```

#### 3. \<property>和\<constructor-arg>中可用的配置项

之前我们看到，可以通过在\<property>和\<constructor-arg>这两个元素内部嵌套\<value>或者\<ref>，来指定将为当前对象注入的简单数据类型或者某个对象的引用。不过，为了能够指定多种注入类型，Spring还提供了其他的元素供我们使用，这包括bean、ref、idref、value、null、list、set、map、props。下面我们来逐个详细讲述它们。

> **提示** 以下涉及的所有内嵌元素，对于 以下涉及的所有内嵌元素，对于\<property> \<property>和\<constructor-arg> \<constructor-arg>都是通用的。
{: .prompt-tip }

(1) \<value>。可以通过value为主体对象注入简单的数据类型，不但可以指定String类型的数据，而且可以指定其他Java语言中的原始类型以及它们的包装器（wrapper）类型，比如int、Integer等。容器在注入的时候，会做适当的转换工作（我们会在后面揭示转换的奥秘）。你之前已经见过如何使用\<value>了，不过让我们通过如下代码来重新认识一下它：

```xml
<constructor-arg> 
    <value>111111</value> 
</constructor-arg> 
<property name="attributeName"> 
    <value>222222</value> 
</property> 
```

当然，如果愿意，你也可以使用如下的简化形式（不过这里的value是以上一层元素的属性身份出现）： 

```xml
<constructor-arg value="111111"/> 
<property name="attributeName" value="222222"/> 
```

需要说明的是，\<value>是最“底层”的元素，它内部不能再嵌套使用其他元素了。

(2) \<ref>。使用ref来引用容器中其他的对象实例，可以通过ref的local、parent和bean属性来指定引用的对象的beanName是什么。代码清单4-15演示了ref及其三个对应属性的使用情况。

代码清单4-15 \<ref>及其local、parent和bean属性的使用

```xml
constructor-arg> 
    <ref local="djNewsPersister"/> 
</constructor-arg>
```

或者

```xml
<constructor-arg> 
    <ref parent="djNewsPersister"/> 
</constructor-arg> 
```

或者

```xml
<constructor-arg> 
    <ref bean="djNewsPersister"/> 
</constructor-arg> 
```

local、parent和bean的区别在于：

- local只能指定与当前配置的对象在同一个配置文件的对象定义的名称（可以获得XML解析器的id约束验证支持）；
- parent则只能指定位于当前容器的父容器中定义的对象引用；
- bean则基本上通吃，所以，通常情况下，直接使用bean来指定对象引用就可以了。

\<ref>的定义为\<!ELEMENT ref EMPTY>，也就是说，它下面没有其他子元素可用了，别硬往人家肚子里塞东西哦。

> **注意** BeanFactory可以分层次（通过实现HierarchicalBeanFactory接口），容器A在初始化的时候，可以首先加载容器B中的所有对象定义，然后再加载自身的对象定义，这样，容器B就成为了容器A的父容器，容器A可以引用容器B中的所有对象定义：<br\>BeanFactory parentContainer = new XmlBeanFactory(new ClassPathResource("父容器配置文件路径"));<br\>BeanFactory childContainer = new XmlBeanFactory(new ClassPathResource("子容器配置文件路径"),parentContainer);<br\>childContainer中定义的对象，如果通过parent指定依赖，则只能引用parentContainer中的对象定义。
{: .prompt-info }

(3) \<idref>。如果要为当前对象注入所依赖的对象的名称，而不是引用，那么通常情况下，可以使用\<value>来达到这个目的，使用如下形式：

```xml
<property name="newsListenerBeanName">
    <value>djNewsListener</value> 
</property>
```

但这种场合下，使用idref才是最为合适的。因为使用idref，容器在解析配置的时候就可以帮你检查这个beanName到底是否存在，而不用等到运行时才发现这个beanName对应的对象实例不存在。毕竟，输错名字的问题很常见。以下代码演示了idref的使用：

```xml
<property name="newsListenerBeanName"> 
    <idref bean="djNewsListener"/> 
</property>
```

这段配置跟上面使用\<value>达到了相同的目的，不过更加保险。如果愿意，也可以通过local而不是bean来指定最终值，不过，bean比较大众化哦。

(4) 内部\<bean>。使用\<ref>可以引用容器中独立定义的对象定义。但有时，可能我们所依赖的对象只有当前一个对象引用，或者某个对象定义我们不想其他对象通过\<ref>引用到它。这时，我们可以使用内嵌的\<bean>，将这个私有的对象定义仅局限在当前对象。对于FX新闻系统的DowJonesNewsListener而言，实际上只有道琼斯的FXNewsProvider会使用它。而且，我们也不想让其他对象引用到它。为此完全可以像代码清单4-16这样，将它配置为内部\<bean>的形式。 

代码清单4-16 内部\<bean>的配置演示

```xml
<bean id="djNewsProvider" class="..FXNewsProvider"> 
    <constructor-arg index="0"> 
        <bean class="..impl.DowJonesNewsListener"> 
        </bean> 
    </constructor-arg> 11 
    <constructor-arg index="1"> 
        <ref bean="djNewsPersister"/> 
    </constructor-arg> 
</bean>
```

这样，该对象实例就只有当前的djNewsProvider可以使用，其他对象无法取得该对象的引用。
 
> **注意** 因为就只有当前对象引用内部\<bean>所指定的对象，所以，内部\<bean>的id不是必须的。当然，如果你愿意指定id，那也是无所谓的。
{: .prompt-info }

如下所示：

```xml
<constructor-arg index="0"> 
    <bean id="djNewsListener" class="..impl.DowJonesNewsListener">
    </bean> 
</constructor-arg>
```

内部\<bean>的配置只是在位置上有所差异，但配置项上与其他的\<bean>是没有任何差别的。也就是说，\<bean>内嵌的所有元素，内部\<bean>的\<bean>同样可以使用。如果内部\<bean>对应的对象还依赖于其他对象，你完全可以像其他独立的\<bean>定义一样为其配置相关依赖，没有任何差别。

(5) \<list>。\<list>对应注入对象类型为java.util.List及其子类或者数组类型的依赖对象。通过\<list>可以有序地为当前对象注入以collection形式声明的依赖。代码清单4-17给出了一个使用\<list>的实例演示。

代码清单4-17 使用\<list>进行依赖注入的对象定义以及相关配置内容

```java
public class MockDemoObject { 
    private List param1; 
    private String[] param2; 
    ... 
    // 相应的setter和getter方法
    ... 
}
```

配置类似于

```xml
<property name="param1"> 
    <list> 
        <value> something</value> 
        <ref bean="someBeanName"/> 
        <bean class="..."/> 
    </list> 
</property> 
<property name="param2"> 
    <list> 
        <value>stringValue1</value> 
        <value>stringValue2</value> 
    </list> 
</property>
```

> 注意，\<list>元素内部可以嵌套其他元素，并且可以像param1所展示的那样夹杂配置。但是，从好的编程实践来说，这样的处理并不恰当，除非你真的知道自己在做什么！（以上只是出于演示的目的才会如此配置）。
{: .prompt-tip }

(6) \<set>。如果说\<list>可以帮你有序地注入一系列依赖的话，那么\<set>就是无序的，而且，对于set来说，元素的顺序本来就是无关紧要的。\<set>对应注入Java Collection中类型为java.util.Set或者其子类的依赖对象。代码清单4-18演示了通常情况下\<set>的使用场景。

代码清单4-18 使用\<set>进行依赖注入的对象定义以及相关配置内容

```java
public class MockDemoObject { 
    private Set valueSet; 
    // 必要的setter和getter方法
    ... 
}
```

配置类似于

```xml
<property name="valueSet"> 
    <set> 
        <value> something</value> 
        <ref bean="someBeanName"/> 
        <bean class="..."/> 
        <list> 
        ... 
        </list> 
    </set> 
</property>
```

例子就是例子，只是为了给你演示这个元素到底有多少能耐。从配置上来说，这样多层嵌套、多元素混杂配置是完全没有问题的。不过，各位在具体编程实践的时候可要小心了。如果你真的想这么夹杂配置的话，不好意思，估计ClassCastException会很愿意来亲近你，而这跟容器或者配置一点儿关系也没有。

(7) \<map>。与列表（list）使用数字下标来标识元素不同，映射（map）可以通过指定的键（key） 来获取相应的值。如果说在\<list>中混杂不同元素不是一个好的实践（方式）的话，你就应该求助\<map>。\<map>与\<list>和\<set>的相同点在于，都是为主体对象注入Collection类型的依赖，不同点在于它对应注入java.util.Map或者其子类类型的依赖对象。代码清单4-19演示了\<map>的通常使用场景。

代码清单4-19 使用\<map>进行依赖注入的对象定义以及相关配置内容

```java
public class MockDemoObject { 
    private Map mapping; 
    // 必要的setter和getter方法
    ... 
}
```

配置类似于

```xml
<property name="mapping"> 
    <map>
        <entry key="strValueKey"> 
            <value>something</value> 
        </entry> 
    <entry> 
    <key>objectKey</key> 
    <ref bean="someObject"/> 
    </entry>
    <entry key-ref="lstKey"> 
    <list> 
    ... 
    </list> 
    </entry> 
    ... 
    </map> 
</property> 
```

对于\<map>来说，它可以内嵌任意多个\<entry>，每一个\<entry>都需要为其指定一个键和一个值，就跟真正的java.util.Map所要求的一样。

- 指定entry的键。可以使用\<entry>的属性——key或者key-ref来指定键，也可以使用\<entry>的内嵌元素\<key>来指定键，这完全看个人喜好，但两种方式可以达到相同的效果。在\<key>内部，可以使用以上提到的任何元素来指定键，从简单的\<value>到复杂的Collection，只要映射需要，你可以任意发挥。
- 指定entry对应的值。\<entry>内部可以使用的元素，除了\<key>是用来指定键的，其他元素可以任意使用，来指定entry对应的值。除了之前提到的那些元素，还包括马上就要谈到的\<props>。如果对应的值只是简单的原始类型或者单一的对象引用，也可以直接使用\<entry>的value或者value-ref这两个属性来指定，从而省却多敲入几个字符的工作量。

> **注意** key属性用于指定通常的简单类型的键，而key-ref则用于指定对象的引用作为键。
{: .prompt-info }

所以，如果你不想敲那么些字符，可以像代码清单4-20所展示的那样使用\<map>进行依赖注入的配置。

代码清单4-20 简化版的\<map>配置使用演示

```java
public class MockDemoObject { 
    private Map mapping; 
    // 必要的setter和getter方法
    ... 
}
```

配置类似于

```xml
<property name="valueSet"> 
    <map> 
    <entry key="strValueKey" value="something"/> 
    <entry key-ref="" value-ref="someObject"/> 
    <entry key-ref="lstKey"> 
        <list> 
        ... 
        </list> 
    </entry> 
    ... 
    </map> 
</property> 
```

(8) \<props>。\<props>是简化后了的\<map>，或者说是特殊化的map，该元素对应配置类型为java.util.Properties的对象依赖。因为Properties只能指定String类型的键（key）和值，所以，\<props>的配置简化很多，只有固定的格式，见代码清单4-21。 

代码清单4-21 使用\<props>进行依赖注入的场景演示

```java
public class MockDemoObject 
{ 
 private Properties emailAddrs; 
 // 必要的setter和getter方法
 ... 
} 
```

配置类似于

```xml
<property name="valueSet"> 
    <props> 
        <prop key="author">fujohnwang@gmail.com</prop> 
        <prop key="support">support@spring21.cn</prop> 
        ... 
    </props> 
</property>
```

每个\<props>可以嵌套多个\<prop>，每个\<prop>通过其key属性来指定键，在\<prop>内部直接指定其所对应的值。\<prop>内部没有任何元素可以使用，只能指定字符串，这个是由java.util.Properties的语意决定的。

(9) \<null/>。最后一个提到的元素是\<null/>，这是最简单的一个元素，因为它只是一个空元素，而且通常使用到它的场景也不是很多。对于String类型来说，如果通过value以这样的方式指定注入，即\<value>\</value>，那么，得到的结果是""，而不是null。所以，如果需要为这个string对应的值注入null的话，请使用\<null/>。当然，这并非仅限于String类型，如果某个对象也有类似需求，请不要犹豫。代码清单4-22演示了一个使用\<null/>的简单场景。

代码清单4-22 使用\<null/>进行依赖注入的简单场景演示

```java
public class MockDemoObject { 
    private String param1; 
    private Object param2; 
    // 必要的setter和getter方法
    ... 
} 
```

配置为

```xml
<property name="param1"> 
    <null/> 
</property>
<property name="param2"> 
    <null/> 
</property>
```

实际上就相当于

```java
public class MockDemoObject { 

    private String param1=null; 6 
    private Object param2=null; 
    // 必要的setter和getter方法
    ... 
}
```

虽然这里看起来没有太大意义！

#### 4. depends-on

通常情况下，可以直接通过之前提到的所有元素，来显式地指定bean之间的依赖关系。这样，容器在初始化当前bean定义的时候，会根据这些元素所标记的依赖关系，首先实例化当前bean定义所依赖的其他bean定义。但是，如果某些时候，我们没有通过类似\<ref>的元素明确指定对象A依赖于对象B的话，如何让容器在实例化对象A之前首先实例化对象B呢？ 

考虑以下所示代码：

```java
public class SystemConfigurationSetup { 
 static 11 
 { 
 DOMConfigurator.configure("配置文件路径"); 
12 // 其他初始化代码
 } 
 ... 
} 
```

系统中所有需要日志记录的类，都需要在这些类使用之前首先初始化log4j。那么，就会非显式地依赖于SystemConfigurationSetup的静态初始化块。如果ClassA需要使用log4j，那么就必须在bean定义中使用depends-on来要求容器在初始化自身实例之前首先实例化SystemConfigurationSetup，以保证日志系统的可用，如下代码演示的正是这种情况： 

```xml
<bean id="classAInstance" class="...ClassA" depends-on="configSetup"/> 
<bean id="configSetup" class="SystemConfigurationSetup"/> 
```

举log4j在静态代码块（static block）中初始化的例子在实际系统中其实不是很合适，因为通常在应用程序的主入口类初始化日志就可以了。这里主要是给出depends-on可能的使用场景，大部分情况下，是那些拥有静态代码块初始化代码或者数据库驱动注册之类的场景。如果说ClassA拥有多个类似的非显式依赖关系，那么，你可以在ClassA的depends-on中通过逗号分割各个beanName，如下代码所示：

```xml
<bean id="classAInstance" class="...ClassA" depends-on="configSetup,configSetup2,..."/> 
<bean id="configSetup" class="SystemConfigurationSetup"/> 
<bean id="configSetup2" class="SystemConfigurationSetup2"/> 
```

#### 5. autowire

除了可以通过配置明确指定bean之间的依赖关系，Spirng还提供了根据bean定义的某些特点将相
互依赖的某些bean直接自动绑定的功能。通过\<bean>的autowire属性，可以指定当前bean定义采用某
种类型的自动绑定模式。这样，你就无需手工明确指定该bean定义相关的依赖关系，从而也可以免去
一些手工输入的工作量。
Spring提供了5种自动绑定模式，即no、byName、byType、constructor和autodetect，下面是
它们的具体介绍。

- no 

容器默认的自动绑定模式，也就是不采用任何形式的自动绑定，完全依赖手工明确配置各个bean
之间的依赖关系，以下代码演示的两种配置是等效的： 
\<bean id="beanName" class="..."/> 
或者
\<bean id="beanName" class="..." autowire="no"/> 

- byName 

按照类中声明的实例变量的名称，与XML配置文件中声明的bean定义的beanName的值进行匹配，
相匹配的bean定义将被自动绑定到当前实例变量上。这种方式对类定义和配置的bean定义有一定的限
制。假设我们有如下所示的类定义： 

```java
public class Foo 
{ 
 private Bar emphasisAttribute; 
 ... 
 // 相应的setter方法定义
} 
public class Bar 
{ 
 ... 
} 
```

那么应该使用如下代码所演示的自动绑定定义，才能达到预期的目的： 

```xml
<bean id="fooBean" class="...Foo" autowire="byName"></bean>
<bean id="emphasisAttribute" class="...Bar"></bean> 
```

需要注意两点：第一，我们并没有明确指定fooBean的依赖关系，而仅指定了它的autowire属性为byName；第二，第二个bean定义的id为emphasisAttribute，与Foo类中的实例变量名称相同。

- byType 

如果指定当前bean定义的autowire模式为byType，那么，容器会根据当前bean定义类型，分析其相应的依赖对象类型，然后到容器所管理的所有bean定义中寻找与依赖对象类型相同的bean定义，然后将找到的符合条件的bean自动绑定到当前bean定义。

对于byName模式中的实例类Foo来说，容器会在其所管理的所有bean定义中寻找类型为Bar的bean定义。如果找到，则将找到的bean绑定到Foo的bean定义；如果没有找到，则不做设置。但如果找到多个，容器会告诉你它解决不了“该选用哪一个”的问题，你只好自己查找原因，并自己修正该问题。所以，byType只能保证，在容器中只存在一个符合条件的依赖对象的时候才会发挥最大的作用，如果容器中存在多个相同类型的bean定义，那么，不好意思，采用手动明确配置吧！ 

指定byType类型的autowire模式与byName没什么差别，只是autowire的值换成byType而已，可以参考如下代码：

```xml
<bean id="fooBean" class="...Foo" autowire="byType"></bean> 
<bean id="anyName" class="...Bar"></bean> 
```

- constructor 6 

byName和byType类型的自动绑定模式是针对property的自动绑定，而constructor类型则是针对构造方法参数的类型而进行的自动绑定，它同样是byType类型的绑定模式。不过，constructor是匹配构造方法的参数类型，而不是实例属性的类型。与byType模式类似，如果找到不止一个符合条件的bean定义，那么，容器会返回错误。使用上也与byType没有太大差别，只不过是应用到需要使用构造方法注入的bean定义之上，代码清单4-23给出了一个使用construtor模式进行自动绑定的简单场景演示。

代码清单4-23 construtor类型自动绑定的使用场景演示

```java
public class Foo { 
    
    private Bar bar;

    public Foo(Bar arg) { 
        this.bar = arg; 
    } 
    ... 
} 
```

相应配置为 

```xml
<bean id="foo" class="...Foo" autowire="constructor"/> 
<bean id="bar" class="...Bar"> </bean> 
```

- autodetect 

这种模式是byType和constructor模式的结合体，如果对象拥有默认无参数的构造方法，容器会优先考虑byType的自动绑定模式。否则，会使用constructor模式。当然，如果通过构造方法注入绑定后还有其他属性没有绑定，容器也会使用byType对剩余的对象属性进行自动绑定。

**小心**<br/>a. 手工明确指定的绑定关系总会覆盖自动绑定模式的行为。<br/>b. 自动绑定只应用于“原生类型、String类型以及Classes类型以外”的对象类型，对“原生类型、String类型和Classes类型”以及“这些类型的数组”应用自动绑定是无效的。
{: .prompt-warning}


自动绑定与手动明确绑定

自动绑定和手动明确绑定各有利弊。自动绑定的优点有如下两点。 

(1) 某种程度上可以有效减少手动敲入配置信息的工作量。
(2) 某些情况下，即使为当前对象增加了新的依赖关系，但只要容器中存在相应的依赖对象，就不需要更改任何配置信息。

自动绑定的缺点有如下几点。

(1) 自动绑定不如明确依赖关系一目了然。我们可以根据明确的依赖关系对整个系统有一个明确的认识，但使用自动绑定的话，就可能需要在类定义以及配置文件之间，甚至各个配置文件之间来回转换以取得相应的信息。

(2) 某些情况下，自动绑定无法满足系统需要，甚至导致系统行为异常或者不可预知。根据类型（byType）匹配进行的自动绑定，如果系统中增加了另一个相同类型的bean定义，那么整个系统就会崩溃；根据名字（byName）匹配进行的自动绑定，如果把原来系统中相同名称的bean定义类型给换掉，就会造成问题，而这些可能都是在不经意间发生的。

(3) 使用自动绑定，我们可能无法获得某些工具的良好支持，比如Spring IDE。

通常情况下，只要有良好的XML编辑器支持，我不会介意多敲那几个字符。起码自己可以对整个系统的行为有完全的把握。当然，任何事物都不绝对，只要根据相应场景找到合适的就可以。

噢，对了，差点儿忘了！作为所有\<bean>的统帅，\<beans>有一个default-autowire属性，它可以帮我们省去为多个\<bean>单独设置autowire属性的麻烦，default-autowire的默认值为no，即不进行自动绑定。如果想让系统中所有的\<bean>定义都使用byType模式的自动绑定，我们可以使用如下配置内容：

```xml
<beans default-autowire="byType">
 <bean id="..." class="..."/> 
 ... 
</beans> 
```

#### 6. dependency-check

我们可以使用每个\<bean>的dependency-check属性对其所依赖的对象进行最终检查，就好像电影里每队美国大兵上战场之前，带队的军官都会朝着士兵大喊“检查装备，check，recheck”是一个道理。该功能主要与自动绑定结合使用，可以保证当自动绑定完成后，最终确认每个对象所依赖的对象是否按照所预期的那样被注入。当然，并不是说不可以与平常的明确绑定方式一起使用。

该功能可以帮我们检查每个对象某种类型的所有依赖是否全部已经注入完成，不过可能无法细化到具体的类型检查。但某些时候，使用setter方法注入就是为了拥有某种可以设置也可以不设置的灵活性，所以，这种依赖检查并非十分有用，尤其是在手动明确绑定依赖关系的情况下。

与军官会让大兵检查枪支弹药和防弹衣等不同装备一样，可以通过dependency-check指定容器帮我们检查某种类型的依赖，基本上有如下4种类型的依赖检查。

- none。不做依赖检查。将dependency-check指定为none跟不指定这个属性等效，所以，还是
不要多敲那几个字符了吧。默认情况下，容器以此为默认值。
- simple。如果将dependency-check的值指定为simple，那么容器会对简单属性类型以及相
关的collection进行依赖检查，对象引用类型的依赖除外。
- object。只对对象引用类型依赖进行检查。
- all。将simple和object相结合，也就是说会对简单属性类型以及相应的collection和所有对象引用类型的依赖进行检查。

总地来说，控制得力的话，这个依赖检查的功能我们基本可以不考虑使用。

#### 7. lazy-init

延迟初始化（lazy-init）这个特性的作用，主要是可以针对ApplicationContext容器的bean初始化行为施以更多控制。与BeanFactory不同，ApplicationContext在容器启动的时候，就会马上对所有的“singleton的bean定义”①进行实例化操作。通常这种默认行为是好的，因为如果系统有问题的话，可以在第一时间发现这些问题，但有时，我们不想某些bean定义在容器启动后就直接实例化，可能出于容器启动时间的考虑，也可能出于其他原因的考虑。总之，我们想改变某个或者某些bean定义在ApplicationContext容器中的默认实例化时机。这时，就可以通过\<bean>的lazy-init属性来控制这种初始化行为，如下代码所示： 

```xml
<bean id="lazy-init-bean" class="..." lazy-init="true"/> 
<bean id="not-lazy-init-bean" class="..."/> 
```

这样，ApplicationContext容器在启动的时候，只会默认实例化not-lazy-init-bean而不会实例化lazy-init-bean。

当然，仅指定lazy-init-bean的lazy-init为true，并不意味着容器就一定会延迟初始化该bean的实例。如果某个非延迟初始化的bean定义依赖于lazy-init-bean，那么毫无疑问，按照依赖决计的顺序，容器还是会首先实例化lazy-init-bean，然后再实例化后者，如下代码演示了这种相互牵连导致延迟初始化失败的情况：

```xml
<bean id="lazy-init-bean" class="..." lazy-init="true"/>
<bean id="not-lazy-init-bean" class="...">
  <property name="propName">
    <ref bean="lazy-init-bean"/>
  </property>
</bean> 
```

虽然lazy-init-bean是延迟初始化的，但因为依赖它的not-lazy-init-bean并不是延迟初始化，所以lazy-init-bean还是会被提前初始化，延迟初始化的良好打算“泡汤”。如果我们真想保证lazy-init-bean一定会被延迟初始化的话，就需要保证依赖于该bean定义的其他bean定义也同样设置为延迟初始化。在bean定义很多时，好像工作量也不小哦。不过不要忘了，\<beans>可是所有\<bean>的统领啊，让它一声令下吧！如代码清单4-24所演示的，在顶层由\<beans>统一控制延迟初始化行为即可。

代码清单4-24 通过\<beans>设置统一的延迟初始化行为

```xml
<beans default-lazy-init="true"> 
  <bean id="lazy-init-bean" class="..."/> 
  <bean id="not-lazy-init-bean" class="..."> 
    <property name="propName"> 
    <ref bean="lazy-init-bean"/> 
  </property> 
  </bean> 
  ... 
</beans> 
```


这样我们就不用每个\<bean>都设置一遍，省事儿多了不是吗？ 

### 4.3.4 继承？我也会！

除了单独存在的bean以及多个bean之间的横向依赖关系，我们也不能忽略“纵向上”各个bean之间的关系。确切来讲，我其实是想说“类之间的继承关系”。不可否认，继承可是在面向对象界声名远扬啊。

假设我们某一天真的需要对FXNewsProvider使用继承进行扩展，那么可能会声明如下代码所示的子类定义： 

```java
class SpecificFXNewsProvider extends FXNewsProvider { 
    private IFXNewsListener newsListener; 
    private IFXNewsPersister newPersistener; 
    ... 
} 
```

实际上，我们想让该子类与FXNewsProvider使用相同的IFXNewsPersister，即DowJonesNewsPersister，那么可以使用如代码清单4-25所示的配置。

代码清单4-25 使用同一个IFXNewsPersister依赖对象的FXNewsProvider和SpecificFXNewsProvider配置内容 

```xml
<bean id="superNewsProvider" class="..FXNewsProvider"> 
 <property name="newsListener"> 
 <ref bean="djNewsListener"/> 
 </property> 
 <property name="newPersistener"> 
 <ref bean="djNewsPersister"/> 
 </property> 
</bean> 
<bean id="subNewsProvider" class="..SpecificFXNewsProvider"> 
 <property name="newsListener"> 
 <ref bean="specificNewsListener"/> 
 </property> 
 <property name="newPersistener"> 
 <ref bean="djNewsPersister"/> 
 </property> 
</bean> 
```

但实际上，这种配置存在冗余，而且也没有表现两者之间的纵向关系。所以，我们可以引入XML中的bean的“继承”配置，见代码清单4-26。 

代码清单4-26 使用继承关系配置的FXNewsProvider和SpecificFXNewsProvider

```xml
<bean id="superNewsProvider" class="..FXNewsProvider"> 
 <property name="newsListener"> 
 <ref bean="djNewsListener"/> 
 </property> 
 <property name="newPersistener"> 
 <ref bean="djNewsPersister"/> 
 </property> 
</bean> 
<bean id="subNewsProvider" parent="superNewsProvider" 
 class="..SpecificFXNewsProvider"> 
 <property name="newsListener"> 
 <ref bean="specificNewsListener"/> 
 </property> 
</bean> 
```

我们在声明subNewsProvider的时候，使用了parent属性，将其值指定为superNewsProvider，这样就继承了superNewsProvider定义的默认值，只需要将特定的属性进行更改，而不要全部又重新定义一遍。

parent属性还可以与abstract属性结合使用，达到将相应bean定义模板化的目的。比如，我们还可以像代码清单4-27所演示的这样声明以上类定义。

代码清单4-27 使用模板化配置形式配置FXNewsProvider和SpecificFXNewsProvider

```xml
<bean id="newsProviderTemplate" abstract="true"> 
 <property name="newPersistener"> 
 <ref bean="djNewsPersister"/> 
 </property> 
</bean> 
<bean id="superNewsProvider" parent="newsProviderTemplate" class="..FXNewsProvider"> 
 <property name="newsListener"> 
 <ref bean="djNewsListener"/> 
 </property> 
</bean> 
 <bean id="subNewsProvider" parent="newsProviderTemplate" class="..SpecificFXNewsProvider"> 
 <property name="newsListener"> 
 <ref bean="specificNewsListener"/> 
 </property>
 </bean> 
```

newsProviderTemplate的bean定义通过abstract属性声明为true，说明这个bean定义不需要实例化。实际上，这就是之前提到的可以不指定class属性的少数场景之一（当然，同时指定class和abstract="true"也是可以的）。该bean定义只是一个配置模板，不对应任何对象。superNewsProvider和subNewsProvider通过parent指向这个模板定义，就拥有了该模板定义的所有属性配置。当多个bean定义拥有多个相同默认属性配置的时候，你会发现这种方式可以带来很大的便利。

另外，既然这里提到abstract，对它就多说几句。容器在初始化对象实例的时候，不会关注将abstract属性声明为true的bean定义。如果你不想容器在初始化的时候实例化某些对象，那么可以将其abstract属性赋值true，以避免容器将其实例化。对于ApplicationContext容器尤其如此，因为默认情况下，ApplicationContext会在容器启动的时候就对其管理的所有bean进行实例化，只有标志为abstract的bean除外。

### 4.3.5 bean 的 scope

BeanFactory除了拥有作为IoC Service Provider的职责，作为一个轻量级容器，它还有着其他一些职责，其中就包括对象的生命周期管理。 

本节主要讲述容器中管理的对象的scope这个概念。多数中文资料在讲解bean的scope时喜欢用“作用域”这个名词，应该还算贴切吧。不过，我更希望告诉你scope这个词到底代表什么意思，至于你怎么称呼它反而不重要。

scope用来声明容器中的对象所应该处的限定场景或者说该对象的存活时间，即容器在对象进入其相应的scope之前，生成并装配这些对象，在该对象不再处于这些scope的限定之后，容器通常会销毁这些对象。打个比方吧！我们都是处于社会（容器）中，如果把中学教师作为一个类定义，那么当容器初始化这些类之后，中学教师只能局限在中学这样的场景中；中学，就可以看作中学教师的scope。

Spring容器最初提供了两种bean的scope类型：singleton和prototype，但发布2.0之后，又引入了另外三种scope类型，即request、session和global session类型。不过这三种类型有所限制，只能在Web应用中使用。也就是说，只有在支持Web应用的ApplicationContext中使用这三个scope才是合理的。 

我们可以通过使用\<bean>的singleton或者scope属性来指定相应对象的scope，其中，scope属性只能在XSD格式的文档声明中使用，类似于如下代码所演示的形式： 

DTD: 

\<bean id="mockObject1" class="...MockBusinessObject" singleton="false"/> 

XSD: 

\<bean id="mockObject2" class="...MockBusinessObject" scope="prototype"/> 

让我们来看一下容器提供的这几个scope是如何限定相应对象的吧！ 

1. singleton 

配置中的bean定义可以看作是一个模板，容器会根据这个模板来构造对象。但是要根据这个模板构造多少对象实例，又该让这些构造完的对象实例存活多久，则由容器根据bean定义的scope语意来决定。标记为拥有singleton scope的对象定义，在Spring的IoC容器中只存在一个实例，所有对该对象的引用将共享这个实例。该实例从容器启动，并因为第一次被请求而初始化之后，将一直存活到容器退出，也就是说，它与IoC容器“几乎”拥有相同的“寿命”。

图4-5是Spring参考文档中所给出的singleton的bean的实例化和注入语意演示图例，或许可以更形
象地说明问题。

图4-5 singleton scope 

需要注意的一点是，不要因为名字的原因而与GoF①所提出的Singleton模式相混淆，二者的语意是不同的：标记为singleton的bean是由容器来保证这种类型的bean在同一个容器中只存在一个共享实例；而Singleton模式则是保证在同一个Classloader中只存在一个这种类型的实例。

可以从两个方面来看待singleton的bean所具有的特性。

- 对象实例数量。singleton类型的bean定义，在一个容器中只存在一个共享实例，所有对该类型bean的依赖都引用这一单一实例。这就好像每个幼儿园都会有一个滑梯一样，这个幼儿园的小朋友共同使用这一个滑梯。而对于该幼儿园容器来说，滑梯实际上就是一个singleton的bean。
- 对象存活时间。singleton类型bean定义，从容器启动，到它第一次被请求而实例化开始，只要容器不销毁或者退出，该类型bean的单一实例就会一直存活。

通常情况下，如果你不指定bean的scope，singleton便是容器默认的scope，所以，下面三种配置形式实际上达成的是同样的效果： 

```xml
<!-- DTD or XSD --> 
<bean id="mockObject1" class="...MockBusinessObject"/> 
 <!-- DTD --> 
<bean id="mockObject1" class="...MockBusinessObject" singleton="true"/> 
<!-- XSD --> 
<bean id="mockObject1" class="...MockBusinessObject" scope="singleton"/> 
```

2. prototype 
针对声明为拥有prototype scope的bean定义，容器在接到该类型对象的请求的时候，会每次都重新
生成一个新的对象实例给请求方。虽然这种类型的对象的实例化以及属性设置等工作都是由容器负责
的，但是只要准备完毕，并且对象实例返回给请求方之后，容器就不再拥有当前返回对象的引用，请
求方需要自己负责当前返回对象的后继生命周期的管理工作，包括该对象的销毁。也就是说，容器每
次返回给请求方一个新的对象实例之后，就任由这个对象实例“自生自灭”了。
6 
7 
让我们继续幼儿园的比喻，看看prototype在这里应该映射到哪些事物。儿歌里好像有句“排排坐，
分果果”，我们今天要分苹果咯！将苹果的bean定义的scope声明为prototype，在每个小朋友领取苹果
的时候，我们都是分发一个新的苹果给他。发完之后，小朋友爱怎么吃怎么吃，爱什么时候吃什么时
候吃。但是，吃完后要记得把果核扔到果皮箱哦！而如果你把苹果的bean定义的scope声明为singleton
会是什么情况呢？如果第一个小朋友比较谦让，那么他可能对这个苹果只咬一口，但是下一个小朋友
吃多少就不知道了。当吃得只剩一个果核的时候，下一个来吃苹果的小朋友肯定要哭鼻子的。
8 
9 
10 
所以，对于那些请求方不能共享使用的对象类型，应该将其bean定义的scope设置为prototype。这
样，每个请求方可以得到自己对应的一个对象实例，而不会出现上面“哭鼻子”的现象。通常，声明
为prototype的scope的bean定义类型，都是一些有状态的，比如保存每个顾客信息的对象。 11 
从Spring 参考文档上的这幅图片（见图4-6），你可以再次了解一下拥有prototype scope的bean定
义，在实例化对象并注入依赖的时候，它的具体语意是个什么样子。 12 
13 
14 
15 
16 
17 
52 Spring 的 IoC 容器
图4-6 prototype scope 
你用以下形式来指定某个bean定义的scope为prototype类型，效果是一样的： 
<!-- DTD --> 
<bean id="mockObject1" class="...MockBusinessObject" singleton="false"/> 
<!-- XSD --> 
<bean id="mockObject1" class="...MockBusinessObject" scope="prototype"/> 
3. request、session和global session 
这三个scope类型是Spirng 2.0之后新增加的，它们不像之前的singleton和prototype那么“通用”，
因为它们只适用于Web应用程序，通常是与XmlWebApplicationContext共同使用，而这些将在第6
部分详细讨论。不过，既然它们也属于scope的概念，这里就简单提几句。
注意 只能使用scope 属性才能指定这三种“bean的scope类型”。也就是说，你不得不使用基
于XSD文档声明的XML配置文件格式。
 request 
request通常的配置形式如下： 
\<bean id="requestProcessor" class="...RequestProcessor" scope="request"/> 
Spring容器，即XmlWebApplicationContext会为每个HTTP请求创建一个全新的RequestProcessor对象供当前请求使用，当请求结束后，该对象实例的生命周期即告结束。当同时有10个HTTP
请求进来的时候，容器会分别针对这10个请求返回10个全新的RequestProcessor对象实例，且它们
之间互不干扰。从不是很严格的意义上说，request可以看作prototype的一种特例，除了场景更加具体
之外，语意上差不多。
 session 
对于Web应用来说，放到session中的最普遍的信息就是用户的登录信息，对于这种放到session中
的信息，我们可使用如下形式指定其scope为session： 
<bean id="userPreferences" class="com.foo.UserPreferences" scope="session"/> 
Spring容器会为每个独立的session创建属于它们自己的全新的UserPreferences对象实例。与
4.3 TBeanFactoryT 的 XML 之旅 53 
request相比，除了拥有session scope的bean的实例具有比request scope的bean可能更长的存活时间，其
他方面真是没什么差别。
 global session 
还是userPreferences，不过scope对应的值换一下，如下所示： 2 
\<bean id="userPreferences" class="com.foo.UserPreferences" scope="globalSession"/> 
global session只有应用在基于portlet的Web应用程序中才有意义，它映射到portlet的global范围的 3 
session。如果在普通的基于servlet的Web应用中使用了这个类型的scope，容器会将其作为普通的session
类型的scope对待。 4 
4. 自定义scope类型
在Spring 2.0之后的版本中，容器提供了对scope的扩展点，这样，你可以根据自己的需要或者应
用的场景，来添加自定义的scope类型。需要说明的是，默认的singleton和prototype是硬编码到代码中
的，而request、session和global session，包括自定义scope类型，则属于可扩展的scope行列，它们都实
现了 rg.springframework.beans.factory.config.Scope
5 
接口，该接口定义如下： 6 o 
public interface Scope { 
Object get(String name, ObjectFactory objectFactory); 7 
 Object remove(String name); 
void registerDestructionCallback(String name, Runnable callback); 8 
 String getConversationId(); 
9 } 
要实现自己的scope类型，首先需要给出一个Scope接口的实现类，接口定义中的4个方法并非都
是必须的，但get和remove方法必须实现。我们可以看一下http://www.jroller.com/eu/entry/implementing 
_efficinet_id_generator中提到的一个ThreadScope的实现（见代码清单4-28）。 10 
代码清单 11 4-28 自定义的ThreadScope的定义
public class ThreadScope implements Scope { 
12 private final ThreadLocal threadScope = new ThreadLocal() { 
 protected Object initialValue() { 
 return new HashMap(); 
 } 13 
14 
 }; 
 
 public Object get(String name, ObjectFactory objectFactory) { 
 Map scope = (Map) threadScope.get(); 
 Object object = scope.get(name); 
 if(object==null) { 
 object = objectFactory.getObject(); 
 scope.put(name, object); 15 
 } 
 return object; 
16 } 
 public Object remove(String name) { 
 Map scope = (Map) threadScope.get(); 
17 return scope.remove(name); 
 } 
54 Spring 的 IoC 容器
 public void registerDestructionCallback(String name, Runnable callback) { 
 } 
 ... 
} 
更多Scope相关的实例，可以参照同一站点的一篇文章“More fun with Spring scopes”（http://jroller. 
com/eu/entry/more_fun_with_spring_scopes），其中提到PageScope的实现。
有了Scope的实现类之后，我们需要把这个Scope注册到容器中，才能供相应的bean定义使用。通
常情况下，我们可以使用ConfigurableBeanFactory的以下方法注册自定义scope： 
void registerScope(String scopeName, Scope scope); 
其中，参数scopeName就是使用的bean定义可以指定的名称，比如Spring框架默认提供的自定义scope
类型request或者session。参数scope即我们提供的Scope实现类实例。
对于以上的ThreadScope，如果容器为BeanFactory类型（当然，更应该实现ConfigurableBeanFactory），我们可以通过如下方式来注册该Scope：
Scope threadScope = new ThreadScope(); 
beanFactory.registerScope("thread",threadScope); 
之后，我们就可以在需要的bean定义中直接通过“thread”名称来指定该bean定义对应的scope
为以上注册的ThreadScope了，如以下代码所示： 
\<bean id="beanName" class="..." scope="thread"/> 
除了直接编码调用ConfigurableBeanFactory的registerScope来注册scope，Spring还提供了
一个专门用于统一注册自定义scope的BeanFactoryPostProcessor实现（有关BeanFactoryPostProcessor的更多细节稍后将详述），即org.springframework.beans.factory.config.CustomScopeConfigurer。对于ApplicationContext来说，因为它可以自动识别并加载BeanFactoryPostProcessor，所以我们就可以直接在配置文件中，通过这个CustomScopeConfigurer注册来ThreadScope（如代码清单4-29所示）。
代码清单4-29 使用CustomScopeConfigurer注册自定义scope 
<bean class="org.springframework.beans.factory.config.CustomScopeConfigurer"> 
 <property name="scopes"> 
 <map> 
 <entry key="thread" value="com.foo.ThreadScope"/> 
 </map> 
 </property> 
</bean> 
在以上工作全部完成之后，我们就可以在自己的bean定义中使用这个新增加到容器的自定义scope
“thread”了，如下代码演示了通常情况下“thread”自定义scope的使用： 
<bean id="beanName" class="..." scope="thread"> 
 <aop:scoped-proxy/> 
</bean> 
由于\<aop:scoped-proxy/>涉及Spring AOP相关知识，这里不会详细讲述。需要注意的是，使用
了自定义scope的bean定义，需要该元素来为其在合适的时间创建和销毁相应的代理对象实例。对于
request、session和global session来说，也是如此。

### 4.3.6 工厂方法与 FactoryBean 

在强调“面向接口编程”的同时，有一点需要注意：虽然对象可以通过声明接口来避免对特定接
口实现类的过度耦合，但总归需要一种方式将声明依赖接口的对象与接口实现类关联起来。否则，只
依赖一个不做任何事情的接口是没有任何用处的。假设我们有一个像代码清单4-30所声明的Foo类，
它声明了一个BarInterface依赖。 2 
代码清单4-30 依赖于某一BarInterface接口的Foo类定义 
3 public class Foo 
{ 
private BarInterface barInstance; 
 public Foo() 4 
 { 
 // 我们应该避免这样做
5 // instance = new BarInterfaceImpl(); 
 } 
 // ... 
}
如果该类是由我们设计并开发的，那么还好说，我们可以通过依赖注入，让容器帮助我们解除接 6 
口与实现类之间的耦合性。但是，有时，我们需要依赖第三方库，需要实例化并使用第三方库中的相
关类，这时，接口与实现类的耦合性需要其他方式来避免。 7 
通常的做法是通过使用工厂方法（Factory Method）模式，提供一个工厂类来实例化具体的接口
实现类，这样，主体对象只需要依赖工厂类，具体使用的实现类有变更的话，只是变更工厂类，而主
体对象不需要做任何变动。代码清单4-31演示了这种做法。 8 
代码清单4-31 使用了工厂方法模式的Foo类可能定义 9 
public class Foo 
{ 
10 private BarInterface barInterface; 
 public Foo() 
 { 
 // barInterface = BarInterfaceFactory.getInstance(); 
 // 或者 11 
 // barInterface = new BarInterfaceFactory().getInstance(); 
 } 
12 ... 
}
针对使用工厂方法模式实例化对象的方式，Spring的IoC容器同样提供了对应的集成支持。我们所
要做的，只是将工厂类所返回的具体的接口实现类注入给主体对象（这里是Foo）。 13 
14 
17 
15 
16 
注意 有关工厂方法模式的信息，可以参考设计模式方面的书籍或者网上有关资源。
1. 静态工厂方法（Static Factory Method）
假设某个第三方库发布了BarInterface，为了向使用该接口的客户端对象屏蔽以后可能对
BarInterface实现类的变动，同时还提供了一个静态的工厂方法实现类StaticBarInterfaceFactory，代码如下： 
public class StaticBarInterfaceFactory 
{ 
 public static BarInterface getInstance() 
 { 
56 Spring 的 IoC 容器
 return new BarInterfaceImpl(); 
 } 
} 
为了将该静态工厂方法类返回的实现注入Foo，我们使用以下方式进行配置（通过setter方法注入
方式为Foo注入BarInterface的实例）： 
<bean id="foo" class="...Foo"> 
 <property name="barInterface"> 
 <ref bean="bar"/> 
 </property> 
</bean> 
<bean id="bar" class="...StaticBarInterfaceFactory" factory-method="getInstance"/> 
class指定静态方法工厂类，factory-method指定工厂方法名称，然后，容器调用该静态方法工
厂类的指定工厂方法（getInstance），并返回方法调用后的结果，即BarInterfaceImpl的实例。
也就是说，为foo注入的bar实际上是BarInterfaceImpl的实例，即方法调用后的结果，而不是静态
工厂方法类（StaticBarInterfaceFactory）。我们可以实现自己的静态工厂方法类返回任意类型
的对象实例，但工厂方法类的类型与工厂方法返回的类型没有必然的相同关系。
某些时候，有的工厂类的工厂方法可能需要参数来返回相应实例，而不一定非要像我们的
getInstance()这样没有任何参数。对于这种情况，可以通过\<constructor-arg>来指定工厂方法需
要的参数，比如现在StaticBarInterfaceFactory需要其他依赖来返回某个BarInterface的实现，
其定义可能如下： 
public class StaticBarInterfaceFactory 
{ 
 public static BarInterface getInstance(Foobar foobar) 
 { 
 return new BarInterfaceImpl(foobar); 
 } 
} 
为了让包含方法参数的工厂方法能够预期返回相应的实现类实例，我们可以像代码清单4-32所演
示的那样，通过\<constructor-arg>为工厂方法传入相应参数。
代码清单4-32 使用\<constructor-arg>调用含有参数的工厂方法
<bean id="foo" class="...Foo"> 
 <property name="barInterface"> 
 <ref bean="bar"/> 
 </property> 
</bean> 
<bean id="bar" class="...StaticBarInterfaceFactory" factory-method="getInstance"> 
 <constructor-arg> 
 <ref bean="foobar"/> 
 </constructor-arg> 
</bean> 
<bean id="foobar" class="...FooBar"/> 
唯一需要注意的就是，针对静态工厂方法实现类的bean定义，使用\<constructor-arg>传入的是
工厂方法的参数，而不是静态工厂方法实现类的构造方法的参数。（况且，静态工厂方法实现类也没
有提供显式的构造方法。） 
4.3 TBeanFactoryT 的 XML 之旅 57 
2. 非静态工厂方法（Instance Factory Method）
既然可以将静态工厂方法实现类的工厂方法调用结果作为bean注册到容器中，我们同样可以针对
基于工厂类实例的工厂方法调用结果应用相同的功能，只不过，表达方式可能需要稍微变一下。
现在为BarInterface提供非静态的工厂方法实现类，该类定义如下代码所示： 2 
public class NonStaticBarInterfaceFactory 
3 { 
public BarInterface getInstance() 
 { 
 return new BarInterfaceImpl(); 
4 } 
 ... 
}
因为工厂方法为非静态的，我们只能通过某个NonStaticBarInterfaceFactory实例来调用该方 5 
法（哦，错了，是容器来调用），那么也就有了如下的配置内容： 
6 <bean id="foo" class="...Foo"> 
 <property name="barInterface"> 
 <ref bean="bar"/> 
 </property> 
</bean> 7 
<bean id="barFactory" class="...NonStaticBarInterfaceFactory"/> 
8 <bean id="bar" factory-bean="barFactory" factory-method="getInstance"/> 
NonStaticBarInterfaceFactory是作为正常的bean注册到容器的，而bar的定义则与静态工厂方
法的定义有些不同。现在使用factory-bean属性来指定工厂方法所在的工厂类实例，而不是通过
class属性来指定工厂方法所在类的类型。指定工厂方法名则相同，都是通过factory-method属性进
行的。
9 
10 
如果非静态工厂方法调用时也需要提供参数的话，处理方式是与静态的工厂方法相似的，都可以
通过\<constructor-arg>来指定方法调用参数。 11 3. FactoryBean
FactoryBean是Spring容器提供的一种可以扩展容器对象实例化逻辑的接口，请不要将其与容器
名称BeanFactory相混淆。FactoryBean，其主语是Bean，定语为Factory，也就是说，它本身与其他注
册到容器的对象一样，只是一个Bean而已，只不过，这种类型的Bean本身就是生产对象的工厂
（Factory）。
12 
13 
14 
当某些对象的实例化过程过于烦琐，通过XML配置过于复杂，使我们宁愿使用Java代码来完成这
个实例化过程的时候，或者，某些第三方库不能直接注册到Spring容器的时候，就可以实现org.springframework.beans.factory.FactoryBean接口，给出自己的对象实例化逻辑代码。当然，不使用FactoryBean，而像通常那样实现自定义的工厂方法类也是可以的。不过，FactoryBean可是Spring提供
的对付这种情况的“制式装备”①哦！ 15 
17 
16 
 
要实现并使 用自己的 FactoryBean其实很简单， org.springframework.beans.factory. 
FactoryBean只定义了三个方法，如以下代码所示： 
public interface FactoryBean { 
① 制式装备通常指正规军使用的标准装备。
58 Spring 的 IoC 容器
 Object getObject() throws Exception; 
 Class getObjectType(); 
 boolean isSingleton(); 
} 
getObject()方法会返回该FactoryBean“生产”的对象实例，我们需要实现该方法以给出自己
的对象实例化逻辑；getObjectType()方法仅返回getObject()方法所返回的对象的类型，如果预先
无法确定，则返回null；isSingleton()方法返回结果用于表明，工厂方法（getObject()）所“生
产”的对象是否要以singleton形式存在于容器中。如果以singleton形式存在，则返回true，否则返回false； 
如果我们想每次得到的日期都是第二天，可以实现一个如代码清单4-33所示的FactoryBean。 
代码清单4-33 NextDayDateFactoryBean的定义代码
import org.joda.time.DateTime; 
import org.springframework.beans.factory.FactoryBean; 
public class NextDayDateFactoryBean implements FactoryBean { 
 public Object getObject() throws Exception { 
 return new DateTime().plusDays(1); 
 } 
 public Class getObjectType() { 
 return DateTime.class; 
 } 
 public boolean isSingleton() { 
 return false; 
 } 
} 
很简单的实现，不是嘛？ 
要使用NextDayDateFactoryBean，只需要如下这样将其注册到容器即可：
<bean id="nextDayDateDisplayer" class="...NextDayDateDisplayer"> 
 <property name="dateOfNextDay"> 
 <ref bean="nextDayDate"/> 
 </property> 
</bean> 
 
<bean id="nextDayDate" class="...NextDayDateFactoryBean"> 
</bean> 
配置上看不出与平常的bean定义有何不同，不过，只有当我们看到NextDayDateDisplayer的定
义的时候，才会知道FactoryBean的魔力到底在哪。NextDayDateDisplayer的定义如下： 
public class NextDayDateDisplayer 
{ 
 private DateTime dateOfNextDay; 
 // 相应的setter方法
 // ... 
} 
看到了嘛？NextDayDateDisplayer所声明的依赖dateOfNextDay的类型为DateTime，而不是
NextDayDateFactoryBean。也就是说FactoryBean类型的bean定义，通过正常的id引用，容器返回
4.3 TBeanFactoryT 的 XML 之旅 59 
的是FactoryBean所“生产”的对象类型，而非FactoryBean实现本身。
如果一定要取得FactoryBean本身的话，可以通过在bean定义的id之前加前缀&来达到目的。代
码清单4-34展示了获取FactoryBean本身与获取FactoryBean“生产”的对象之间的差别。
2 
代码清单4-34 使用&获取FactoryBean的实例演示
Object nextDayDate = container.getBean("nextDayDate"); 
assertTrue(nextDayDate instanceof DateTime); 3 
Object factoryBean = container.getBean("&nextDayDate"); 
4 assertTrue(factoryBean instanceof FactoryBean); 
assertTrue(factoryBean instanceof NextDayDateFactoryBean); 
Object factoryValue = ((FactoryBean)factoryBean).getObject(); 
5 assertTrue(factoryValue instanceof DateTime); 
assertNotSame(nextDayDate, factoryValue); 
assertEquals(((DateTime)nextDayDate).getDayOfYear(),((DateTime)factoryValue).getDayOfYear()); 
6 
Spring容器内部许多地方了使用FactoryBean。下面是一些比较常见的FactoryBean实现，你可
以参照FactoryBean的Javadoc以了解更多内容。 
 JndiObjectFactoryBean 7 
 LocalSessionFactoryBean 
8  SqlMapClientFactoryBean 
 ProxyFactoryBean 
 TransactionProxyFactoryBean 9 

### 4.3.7 偷梁换柱之术

在学习以下内容之前，先提一下有关 10 bean的scope的使用“陷阱”，特别是prototype在容器中的使
用，以此引出本节将要介绍的Spring容器较为独特的功能特性：方法注入（Method Injection）以及方
法替换（Method Replacement）。 11 我们知道，拥有prototype类型scope的bean，在请求方每次向容器请求该类型对象的时候，容器都
会返回一个全新的该对象实例。为了简化问题的叙述，我们直接将FX News系统中的FXNewsBean定义
注册到容器中，并将其scope设置为prototype。因为它是有状态的类型，每条新闻都应该是新的独
立个体；同时，我们给出MockNewsPersister类，使其实现IFXNewsPersister接口，以模拟注入
FXNewsBean实例后的情况。这样，我们就有了代码清单4-35所展示的类声明和相关配置。
12 
13 
14 
代码清单4-35 MockNewsPersister的定义以及相关配置
public class MockNewsPersister implements IFXNewsPersister { 
 private FXNewsBean newsBean; 
 
public void persistNews(FXNewsBean bean) { 
 persistNewes(); 15 
 } 
 public void persistNews() 
16 { 
 System.out.println("persist bean:"+getNewsBean()); 
 } 
 public FXNewsBean getNewsBean() { 
17 return newsBean; 
 } 
60 Spring 的 IoC 容器
 public void setNewsBean(FXNewsBean newsBean) { 
 this.newsBean = newsBean; 
 } 
} 
配置为
<bean id="newsBean" class="..domain.FXNewsBean" singleton="false"> 
</bean> 
<bean id="mockPersister" class="..impl.MockNewsPersister"> 
 <property name="newsBean"> 
 <ref bean="newsBean"/> 
 </property> 
</bean> 
当多次调用MockNewsPersister的persistNews时，你猜会得到什么结果？如下代码可以帮助我
们揭开答案：
BeanFactory container = new XmlBeanFactory(new ClassPathResource("..")); 
MockNewsPersister persister = (MockNewsPersister)container.getBean("mockPersister"); 
persister.persistNews(); 
persister.persistNews(); 
输出：
persist bean:..domain.FXNewsBean@1662dc8
persist bean:..domain.FXNewsBean@1662dc8 
从输出看，对象实例是相同的，而这与我们的初衷是相悖的。因为每次调用persistNews都会调
用getNewsBean()方法并返回一个FXNewsBean实例，而FXNewsBean实例是prototype类型的，因此每
次不是应该输出不同的对象实例嘛？ 
好了，问题实际上不是出在FXNewsBean的scope类型是否是prototype的，而是出在实例的取得方
式上面。虽然FXNewsBean拥有prototype类型的scope，但当容器将一个FXNewsBean的实例注入
MockNewsPersister之后，MockNewsPersister就会一直持有这个FXNewsBean实例的引用。虽然每
次输出都调用了getNewsBean()方法并返回了 FXNewsBean 的实例，但实际上每次返回的都是
MockNewsPersister持有的容器第一次注入的实例。这就是问题之所在。换句话说，第一个实例注入
后，MockNewsPersister再也没有重新向容器申请新的实例。所以，容器也不会重新为其注入新的
FXNewsBean类型的实例。
知道原因之后，我们就可以解决这个问题了。解决问题的关键在于保证getNewsBean()方法每次
从容器中取得新的FXNewsBean实例，而不是每次都返回其持有的单一实例。
1. 方法注入
Spring容器提出了一种叫做方法注入（Method Injection）的方式，可以帮助我们解决上述问题。
我们所要做的很简单，只要让getNewsBean方法声明符合规定的格式，并在配置文件中通知容器，当
该方法被调用的时候，每次返回指定类型的对象实例即可。方法声明需要符合的规格定义如下：
\<public|protected> [abstract] \<return-type> theMethodName(no-arguments); 
也就是说，该方法必须能够被子类实现或者覆写，因为容器会为我们要进行方法注入的对象使用
Cglib动态生成一个子类实现，从而替代当前对象。既然我们的getNewsBean()方法已经满足以上方法
声明格式，剩下唯一要做的就是配置该类，配置内容如下所示： 
<bean id="newsBean" class="..domain.FXNewsBean" singleton="false"> 
</bean> 
<bean id="mockPersister" class="..impl.MockNewsPersister"> 
<lookup-method name="getNewsBean" bean="newsBean"/> 
</bean> 
4.3 TBeanFactoryT 的 XML 之旅 61 
通过\<lookup-method>的name属性指定需要注入的方法名，bean属性指定需要注入的对象，当
getNewsBean方法被调用的时候，容器可以每次返回一个新的FXNewsBean类型的实例。所以，这个时
候，我们再次检查执行结果，输出的实例引用应该是不同的： 
persist bean:..domain.FXNewsBean@18aaa1e 2 
persist bean:..domain.FXNewsBean@a6aeed 
哇噢，很帅不是吗？ 3 
注意 FXNewsBean的取得实际上可以在相应方法中按需要自行实例化，而不一定非要注册到
容器中，从容器中获取。我们只是为了引入prototype的使用“陷阱”以及方法注入功能，才将
FXNewsBean以prototype类型注册到容器中供使用。当然，如果愿意你也可以以这种方式使用。
在最终输出的结果中，对象引用的数字不一定就是上面的那样。因为每次注入的实例是不同的，
所以对应实例的数字也可能不同。在此只需要关注每次同时输出的结果是否相同即可说明问
题。
4 
5 
6 
2. 殊途同归 
除了使用方法注入来达到“每次调用都让容器返回新的对象实例”的目的，还可以使用其他方式 7 
达到相同的目的。下面给出其他两种解决类似问题的方法，供读者参考。
 使用BeanFactoryAware接口
我们知道，即使没有方法注入，只要在实现 8 getNewsBean()方法的时候，能够保证每次调用BeanFactory的getBean("newsBean")，就同样可以每次都取得新的FXNewsBean对象实例。现在，我们唯
一需要的，就是让MockNewsPersister拥有一个BeanFactory的引用。 9 
Spring框架提供了一个BeanFactoryAware接口，容器在实例化实现了该接口的bean定义的过程
中，会自动将容器本身注入该bean。这样，该bean就持有了它所处的BeanFactory的引用。BeanFactoryAware的定义如下代码所示： 10 
public interface BeanFactoryAware { 
void setBeanFactory(BeanFactory beanFactory) throws BeansException; 11 
}
我们让MockNewsPersister实现该接口以持有其所处的BeanFactory的引用，这样MockNewsPersister的定义如代码清单4-36所示。 12 
代码清单4-36 实现了BeanFactoryAware接口的MockNewsPersister及相关配置 13 
14 
public class MockNewsPersister implements IFXNewsPersister,BeanFactoryAware { 
private BeanFactory beanFactory; 
 
public void setBeanFactory(BeanFactory bf) throws BeansException { 
 this.beanFactory = bf; 
 } 
15 public void persistNews(FXNewsBean bean) { 
 persistNews(); 
 } 
public void persistNews() 
 { 16 System.out.println("persist bean:"+getNewsBean()); 
 } 
17 public FXNewsBean getNewsBean() { 
 return beanFactory.getBean("newsBean"); 
62 Spring 的 IoC 容器
 } 
} 
配置简化为
<bean id="newsBean" class="..domain.FXNewsBean" singleton="false"> 
</bean> 
<bean id="mockPersister" class="..impl.MockNewsPersister"> 
</bean> 
如此，可以预见到，输出的结果将与我们所预期的相同： 
persist bean:..domain.FXNewsBean@121cc40 
persist bean:..domain.FXNewsBean@1e893df 
实际上，方法注入动态生成的子类，完成的是与以上类似的逻辑，只不过实现细节上不同而已。
 使用ObjectFactoryCreatingFactoryBean
ObjectFactoryCreatingFactoryBean是Spring提供的一个FactoryBean实现，它返回一个
ObjectFactory实例。从ObjectFactoryCreatingFactoryBean返回的这个ObjectFactory实例可以
为我们返回容器管理的相关对象。实际上， ObjectFactoryCreatingFactoryBean 实现了
BeanFactoryAware接口，它返回的ObjectFactory实例只是特定于与Spring容器进行交互的一个实现
而已。使用它的好处就是，隔离了客户端对象对BeanFactory的直接引用。
现在，我们使用ObjectFactory取得FXNewsBean的实例，代码清单4-37给出了对应这种方式的
MockNewsPersister实现声明。
代码清单4-37 使用ObjectFactory的MockNewsPersister定义
public class MockNewsPersister implements IFXNewsPersister { 
private ObjectFactory newsBeanFactory; 
 
 public void persistNews(FXNewsBean bean) { 
 persistNews(); 
 } 
 public void persistNews() 
 { 
 System.out.println("persist bean:"+getNewsBean()); 
 } 
 public FXNewsBean getNewsBean() { 
 return newsBeanFactory.getObject(); 
 } 
 public void setNewsBeanFactory(ObjectFactory newsBeanFactory) { 
 this.newsBeanFactory = newsBeanFactory; 
 } 
} 
有了以上的类定义之后，我们应该为MockNewsPersister注入相应的ObjectFactory，这也正是
ObjectFactoryCreatingFactoryBean闪亮登场的时候，代码清单4-38给出了对应的配置内容。

代码清单4-38 使用ObjectFactoryCreatingFactoryBean的相关配置

```java
<bean id="newsBean" class="..domain.FXNewsBean" singleton="false"> 
</bean> 
<bean id="newsBeanFactory" class="org.springframework.beans.factory.config.  
ObjectFactoryCreatingFactoryBean"> 
 <property name="targetBeanName"> 
 <idref bean="newsBean"/> 
 </property> 
</bean> 
<bean id="mockPersister" class="..impl.MockNewsPersister"> 
4.3 TBeanFactoryT 的 XML 之旅 63 
 <property name="newsBeanFactory"> 
 <ref bean="newsBeanFactory"/> 
 </property> 
</bean> 
```

看，真有效！ 2 
persist bean:..domain.FXNewsBean@ecd7e 
persist bean:..domain.FXNewsBean@1d520c4 
3 
提示 也可以使用ServiceLocatorFactoryBean来代替ObjectFactoryCreatingFactoryBean，该FactoryBean可以让我们自定义工厂接口，而不用非要使用Spring的ObjectFactory。
可以参照该类定义的Javadoc取得更多信息，Javadoc中有详细的实例，足够让你了解该类的使
用和功能。
4 
5 
3. 方法替换
与方法注入只是通过相应方法为主体对象注入依赖对象不同，方法替换更多体现在方法的实现层
面上，它可以灵活替换或者说以新的方法实现覆盖掉原来某个方法的实现逻辑。基本上可以认为，方
法替换可以帮助我们实现简单的方法拦截功能。要知道，我们现在可是在不知不觉中迈上了AOP的大
道哦！ 
6 
7 
假设某天我看FXNewsProvider不爽，想替换掉它的getAndPersistNews方法默认逻辑，这时，
我就可以用方法替换将它的原有逻辑给替换掉。 8 
小心 这里只是为了演示方法替换（Method Replacement）的功能，不要真的这么做。要使用
也要用在好的地方，对吧？ 9 
首先，我们需要给出org.springframework.beans.factory.support.MethodReplacer的实现
类，在这个类中实现将要替换的方法逻辑。假设我们只是简单记录日志，打印简单信息，那么就可以
给出一个类似代码清单4-39所示的MethodReplacer实现类。
10 
11 代码清单4-39 FXNewsProviderMethodReplacer类的定义
public class FXNewsProviderMethodReplacer implements MethodReplacer { 
12 
private static final transient Log logger =  
 LogFactory.getLog(FXNewsProviderMethodReplacer.class); 
13 
14 
 
public Object reimplement(Object target, Method method, Object[] args)  
 throws Throwable { 
 logger.info("before executing method["+method.getName()+ 
 "] on Object["+target.getClass().getName()+"]."); 
 
 System.out.println("sorry,We will do nothing this time."); 
 
 logger.info("end of executing method["+method.getName()+  15 
 "] on Object["+target.getClass().getName()+"]."); 
 return null; 
16 } 
}
有了要替换的逻辑之后，我们就可以把这个逻辑通过<replaced-method>配置到FXNewsProvider的bean定义中，使其生效，配置内容如代码清单4-40所示。 17 
64 Spring 的 IoC 容器
代码清单4-40 FXNewsProvider中使用方法替换的相关配置

```java
<bean id="djNewsProvider" class="..FXNewsProvider"> 
 <constructor-arg index="0"> 
 <ref bean="djNewsListener"/> 
 </constructor-arg> 
 <constructor-arg index="1"> 
 <ref bean="djNewsPersister"/> 
 </constructor-arg> 
<replaced-method name="getAndPersistNews" replacer="providerReplacer"> 
 </replaced-method> 
</bean> 
<bean id="providerReplacer" class="..FXNewsProviderMethodReplacer"> 
</bean> 
<!--其他bean配置--> 
...
```

现在，你猜调用FXNewsProvider的getAndPersistNews方法后，会得到什么结果？输出结果如
下所示：
771 [main] INFO ..FXNewsProviderMethodReplacer 
 - before executing method[getAndPersistNews] 
 on Object[..FXNewsProvider$$EnhancerByCGLIB$$3fa709d3]. 
sorry,We will do nothing this time. 
771 [main] INFO ..FXNewsProviderMethodReplacer 
 - end of executing method[getAndPersistNews] 
 on Object[..FXNewsProvider$$EnhancerByCGLIB$$3fa709d3]. 
我们把FXNewsProvider的getAndPersistNews方法逻辑给完全替换掉了。现在该方法基本上什
么也没做，哇……
最后需要强调的是，这种方式刚引入的时候执行效率不是很高。而且，当你充分了解并应用Spring 
AOP之后，我想你也不会再回头求助这个特色功能。不过，怎么说这也是一个选择，场景合适的话，
为何不用呢？ 
哦，如果要替换的方法存在参数，或者对象存在多个重载的方法，可以在\<replaced-method>内
部通过\<arg-type>明确指定将要替换的方法参数类型。祝“替换”愉快！ 

## 4.4 容器背后的秘密

子曰：学而不思则罔。除了了解Spring的IoC容器如何使用，了解Spring的IoC容器都提供了哪些功能，我们也应该想一下，Spring的IoC容器内部到底是如何来实现这些的呢？虽然我们不太可能“重新发明轮子”，但是，如图4-7（该图摘自Spring官方参考文档）所示的那样，只告诉你“Magic Happens Here”，你是否就能心满意足呢？

好，如果你的答案是“不”（我当然认为你说的是“不想一直被蒙在鼓里”），那么就随我一起来探索一下这个“黑匣子”里面到底有些什么……

### 4.4.1 “战略性观望”

Spring的IoC容器所起的作用，就像图4-7所展示的那样，它会以某种方式加载Configuration Metadata（通常也就是XML格式的配置信息），然后根据这些信息绑定整个系统的对象，最终组装成一个可用的基于轻量级容器的应用系统。

Spring的IoC容器实现以上功能的过程，基本上可以按照类似的流程划分为两个阶段，即容器启动阶段和Bean实例化阶段，如图4-8所示。

Spring的IoC容器在实现的时候，充分运用了这两个实现阶段的不同特点，在每个阶段都加入了相
应的容器扩展点，以便我们可以根据具体场景的需要加入自定义的扩展逻辑。

图4-8 容器功能实现的各个阶段

#### 1. 容器启动阶段

容器启动伊始，首先会通过某种途径加载Configuration MetaData。除了代码方式比较直接，在大部分情况下，容器需要依赖某些工具类（BeanDefinitionReader）对加载的Configuration MetaData进行解析和分析，并将分析后的信息编组为相应的BeanDefinition，最后把这些保存了bean定义必要信息的BeanDefinition，注册到相应的BeanDefinitionRegistry，这样容器启动工作就完成了。

图4-9演示了这个阶段的主要工作。

图4-9 XML配置信息到BeanDefinition的映射

总地来说，该阶段所做的工作可以认为是准备性的，重点更加侧重于对象管理信息的收集。当然，一些验证性或者辅助性的工作也可以在这个阶段完成。

#### 2. Bean实例化阶段

经过第一阶段，现在所有的bean定义信息都通过BeanDefinition的方式注册到了BeanDefinitionRegistry中。当某个请求方通过容器的getBean方法明确地请求某个对象，或者因依赖关系容器需要隐式地调用getBean方法时，就会触发第二阶段的活动。

该阶段，容器会首先检查所请求的对象之前是否已经初始化。如果没有，则会根据注册的BeanDefinition所提供的信息实例化被请求对象，并为其注入依赖。如果该对象实现了某些回调接口，也会根据回调接口的要求来装配它。当该对象装配完毕之后，容器会立即将其返回请求方使用。如果说第一阶段只是根据图纸装配生产线的话，那么第二阶段就是使用装配好的生产线来生产具体的产品了。

### 4.4.2 插手“容器的启动”

Spring提供了一种叫做BeanFactoryPostProcessor的容器扩展机制。该机制允许我们在容器实例化相应对象之前，对注册到容器的BeanDefinition所保存的信息做相应的修改。这就相当于在容器实现的第一阶段最后加入一道工序，让我们对最终的BeanDefinition做一些额外的操作，比如修改其中bean定义的某些属性，为bean定义增加其他信息等。

如果要自定义实现BeanFactoryPostProcessor，通常我们需要实现org.springframework.beans.factory.config.BeanFactoryPostProcessor接口。同时，因为一个容器可能拥有多个BeanFactoryPostProcessor，这个时候可能需要实现类同时实现Spring的org.springframework.core.Ordered接口，以保证各个BeanFactoryPostProcessor可以按照预先设定的顺序执行（如果顺序紧要的话）。但是，因为Spring已经提供了几个现成的BeanFactoryPostProcessor实现类，所以，大多时候，我们很少自己去实现某个BeanFactoryPostProcessor。其中，org.springframework.beans.factory.config.PropertyPlaceholderConfigurer和org.springframework.beans.factory.config.Property OverrideConfigurer是两个比较常用的BeanFactoryPostProcessor。另外，为了处理配置文件中的数据类型与真正的业务对象所定义的数据类型转换，Spring还允许我们通过org.springframework.beans.factory.config.CustomEditorConfigurer来注册自定义的PropertyEditor以补助容器中默认的PropertyEditor。可以参考BeanFactoryPostProcessor的Javadoc来了解更多其实现子类的情况。

我们可以通过两种方式来应用 BeanFactoryPostProcessor，分别针对基本的 IoC 容器BeanFactory和较为先进的容器ApplicationContext。 


对于BeanFactory来说，我们需要用手动方式应用所有的BeanFactoryPostProcessor，代码清单4-41演示了具体的做法。

代码清单4-41 手动装配BeanFactory使用的BeanFactoryPostProcessor

```java
// 声明将被后处理的BeanFactory实例
ConfigurableListableBeanFactory beanFactory = new XmlBeanFactory(new ClassPathResource("...")); 
3 // 声明要使用的BeanFactoryPostProcessor 
PropertyPlaceholderConfigurer propertyPostProcessor = new PropertyPlaceholderConfigurer(); 
propertyPostProcessor.setLocation(new ClassPathResource("...")); 
// 执行后处理操作
propertyPostProcessor.postPro 4 cessBeanFactory(beanFactory);
```

如果拥有多个BeanFactoryPostProcessor，我们可以添加更多类似的代码来应用所有的这些BeanFactoryPostProcessor。

对于ApplicationContext来说，情况看起来要好得多。因为ApplicationContext会自动识别配置文件中的BeanFactoryPostProcessor并应用它，所以，相对于BeanFactory，在ApplicationContext中加载并应用BeanFactoryPostProcessor，仅需要在XML配置文件中将这些BeanFactoryPostProcessor简单配置一下即可。只要如代码清单4-42所示，将相应BeanFactoryPostProcessor实现类添加到配置文件，ApplicationContext将自动识别并应用它。

代码清单4-42 通过ApplicationContext使用BeanFactoryPostProcessor

```xml
<beans> 
 <bean class="org.springframework.beans.factory.config.PropertyPlaceholderConfigurer"> 
 <property name="locations"> 
 <list> 
 <value>conf/jdbc.properties</value> 
 <value>conf/mail.properties</value> 
 </list>
 </property> 
 </bean> 
 ... 
</beans>
```
 
下面让我们看一下Spring提供的这几个BeanFactoryPostProcessor实现都可以完成什么功能。

#### 1. PropertyPlaceholderConfigurer
通常情况下，我们不想将类似于系统管理相关的信息同业务对象相关的配置信息混杂到XML配置文件中，以免部署或者维护期间因为改动繁杂的XML配置文件而出现问题。我们会将一些数据库连接信息、邮件服务器等相关信息单独配置到一个properties文件中，这样，如果因系统资源变动的话，只需要关注这些简单properties配置文件即可。

PropertyPlaceholderConfigurer允许我们在XML配置文件中使用占位符（PlaceHolder），并将这些占位符所代表的资源单独配置到简单的properties文件中来加载。以数据源的配置为例，使用了PropertyPlaceholderConfigurer之后（这里沿用代码清单4-42的配置内容），可以在XML配置文件中按照代码清单4-43所示的方式配置数据源，而不用将连接地址、用户名和密码等都配置到XML中。

代码清单4-43 使用了占位符的数据源配置

```xml
<bean id="dataSource" class="org.apache.commons.dbcp.BasicDataSource"  
destroy-method="close"> 
 <property name="url"> 
 <value>${jdbc.url}</value> 
 </property> 
 <property name="driverClassName"> 
 <value>${jdbc.driver}</value> 
 </property> 
 <property name="username"> 
 <value>${jdbc.username}</value> 
 </property> 
 <property name="password"> 
 <value>${jdbc.password}</value> 
 </property> 
 <property name="testOnBorrow"> 
 <value>true</value> 
 </property> 
 <property name="testOnReturn"> 
 <value>true</value> 
 </property> 
 <property name="testWhileIdle"> 
 <value>true</value> 
 </property> 
 <property name="minEvictableIdleTimeMillis"> 
 <value>180000</value> 
 </property> 
 <property name="timeBetweenEvictionRunsMillis"> 
 <value>360000</value> 
 </property> 
 <property name="validationQuery"> 
 <value>SELECT 1</value> 
 </property> 
 <property name="maxActive"> 
 <value>100</value> 
 </property> 
</bean> 
```

如果你使用过Ant或者Velocity等工具，就会发现${property}之类的表达很熟悉。现在，所有这些占位符所代表的资源，都放到了jdbc.properties文件中，如下所示：

```plaintext
jdbc.url=jdbc:mysql://server/MAIN?useUnicode=true&characterEncoding=ms932&  
failOverReadOnly=false&roundRobinLoadBalance=true 
jdbc.driver=com.mysql.jdbc.Driver 
jdbc.username=your username 
jdbc.password=your password
```

基本机制就是之前所说的那样。当BeanFactory在第一阶段加载完成所有配置信息时，BeanFactory中保存的对象的属性信息还只是以占位符的形式存在，如${jdbc.url}、${jdbc.driver}。当PropertyPlaceholderConfigurer作为BeanFactoryPostProcessor被应用时，它会使用properties配置文件中的配置信息来替换相应BeanDefinition中占位符所表示的属性值。这样，当进入容器实现的第二阶段实例化bean时，bean定义中的属性值就是最终替换完成的了。

PropertyPlaceholderConfigurer不单会从其配置的properties文件中加载配置项，同时还会检查Java的System类中的Properties，可以通过setSystemPropertiesMode()或者setSystemPropertiesModeName()来控制是否加载或者覆盖System相应Properties的行为。PropertyPlaceholderConfigurer提供了YSTEM_PROPERTIES_MODE_FALLBACK、SYSTEM_PROPERTIES_MODE_NEVER和SYSTEM_PROPERTIES_MODE_OVERRIDE三种模式。默认采用的是SYSTEM_PROPERTIES_ MODE_FALLBACK，即如果properties文件中找不到相应配置项，则到System的Properties中查找，我们还可以选择不检查System的Properties或者覆盖它。更多信息请参照PropertyPlaceholderConfigurer的Javadoc文档。

#### 2. PropertyOverrideConfigurer

PropertyPlaceholderConfigurer可以通过占位符，来明确表明bean定义中的property与properties文件中的各配置项之间的对应关系。如果说PropertyPlaceholderConfigurer做的这些是“明事”的话，那相对来说，PropertyOverrideConfigurer所做的可能就有点儿“神不知鬼不觉”了。

可以通过PropertyOverrideConfigurer对容器中配置的任何你想处理的bean定义的property信息进行覆盖替换。这听起来比较抽象，我们还是给个例子吧！比如之前的dataSource定义中，maxActive的值为100，如果我们觉得100不合适，那么可以通过PropertyOverrideConfigurer在其相应的properties文件中做如下所示配置，把100这个值给覆盖掉，如将其配置为200： 

dataSource.maxActive=200

这样，当容器实例化对象的时候，该 6 dataSource对象对应的maxActive值就是200，而不是原来XML配置中的100。也就是说，PropertyOverrideConfigurer的properties文件中的配置项，覆盖掉了原来XML中的bean定义的property信息。但这样的活动，只看XML配置的话，你根本看不出哪个bean定义的哪个property会被覆盖替换掉，只有查看PropertyOverrideConfigurer指定的properties配置文件才会了解。基本上，这种覆盖替换对于bean定义来说是透明的。

如果要对容器中的某些bean定义的property信息进行覆盖，我们需要按照如下规则提供一个PropertyOverrideConfigurer使用的配置文件： 

beanName.propertyName=value 

也就是说，properties文件中的键是以XML中配置的bean定义的beanName为标志开始的（通常就是id指定的值），后面跟着相应被覆盖的property的名称，比如上面的maxActive。下面是针对dataSource定义给出的PropertyOverrideConfigurer的propeties文件配置信息： 

```plaintext
# pool-adjustment.properties 11 
dataSource.minEvictableIdleTimeMillis=1000 
dataSource.maxActive=50 
```

这样，当按照如下代码，将PropertyOverrideConfigurer加载到容器之后，dataSource原来定义的默认值就会被pool-adjustment.properties文件中的信息所覆盖： 

```xml
<bean class="org.springframework.beans.factory.config.PropertyOverrideConfigurer"> 
    <property name="location" value="pool-adjustment.properties"/> 
</bean>
```
pool-adjustment.properties中没有提供的配置项将继续使用原来XML配置中的默认值。

当容器中配置的多个PropertyOverrideConfigurer对同一个bean定义的同一个property值进行处理的时候，最后一个将会生效。

配置在properties文件中的信息通常都以明文表示，PropertyOverrideConfigurer的父类PropertyResourceConfigurer提供了一个protected类型的方法convertPropertyValue，允许子类覆盖这个方法对相应的配置项进行转换，如对加密后的字符串解密之后再覆盖到相应的bean定义中。当然，既然PropertyPlaceholderConfigurer也同样继承了PropertyResourceConfigurer，我们也可以针对PropertyPlaceholderConfigurer应用类似的功能。
 
#### 3. CustomEditorConfigurer

其他两个BeanFactoryPostProcessor都是通过对BeanDefinition中的数据进行变更以达到某种目的。与它们有所不同，CustomEditorConfigurer是另一种类型的BeanFactoryPostProcessor实现，它只是辅助性地将后期会用到的信息注册到容器，对BeanDefinition没有做任何变动。

我们知道，不管对象是什么类型，也不管这些对象所声明的依赖对象是什么类型，通常都是通过XML（或者properties甚至其他媒介）文件格式来配置这些对象类型。但XML所记载的，都是String类型，即容器从XML格式的文件中读取的都是字符串形式，最终应用程序却是由各种类型的对象所构成。要想完成这种由字符串到具体对象的转换（不管这个转换工作最终由谁来做），都需要这种转换规则相关的信息，而CustomEditorConfigurer就是帮助我们传达类似信息的。

Spring内部通过JavaBean的PropertyEditor来帮助进行String类型到其他类型的转换工作。只要为每种对象类型提供一个 PropertyEditor ，就可以根据该对象类型取得与其相对应的PropertyEditor来做具体的类型转换。Spring容器内部在做具体的类型转换的时候，会采用JavaBean框架内默认的PropertyEditor搜寻逻辑，从而继承了对原生类型以及java.lang.String.java.awt.Color和java.awt.Font等类型的转换支持。同时，Spring框架还提供了自身实现的一些PropertyEditor，这些PropertyEditor大部分都位于org.springframework.beans.ropertyeditors包下。以下是这些Spring提供的部分PropertyEditor的简要说明。

- StringArrayPropertyEditor。该PropertyEditor会将符合CSV格式的字符串转换成String[]数组的形式，默认是以逗号（，）分隔的字符串，但可以指定自定义的字符串分隔符。ByteArrayPropertyEditor、CharArrayPropertyEditor等都属于类似功能的PropertyEditor，参照Javadoc可以取得相应的详细信息。
- ClassEditor。根据String类型的class名称，直接将其转换成相应的Class对象，相当于通过Class.forName(String)完成的功效。可以通过String[]数组的形式传入需转换的值，以达到与提供的ClassArrayEditor同样的目的。
- FileEditor。Spring提供的对应java.io.File类型的PropertyEditor。同属于对资源进行定位的PropertyEditor还有InputStreamEditor、URLEditor等。
- LocaleEditor。针对java.util.Locale类型的PropertyEditor，格式可以参照LocaleEditor和Locale的Javadoc说明。
- PatternEditor。针对Java SE 1.4之后才引入的java.util.regex.Pattern的PropertyEditor，格式可以参照java.util.regex.Pattern类的Javadoc。

以上这些PropertyEditor，容器通常会默认加载使用，所以，即使我们不告诉容器应该如何对这些类型进行转换，容器同样可以正确地完成工作。但当我们需要指定的类型没有包含在以上所提到的PropertyEditor之列的时候，就需要给出针对这种类型的PropertyEditor实现，并通过CustomEditorConfigurer告知容器，以便容器在适当的时机使用到适当的PropertyEditor。

- 自定义PropertyEditor

通常情况下，对于Date类型，不同的Locale、不同的系统在表现形式上存在不同的需求。如系统这个部分需要以yyyy-MM-dd的形式表现日期，系统那个部分可能又需要以yyyyMMdd的形式对日期进行转换。虽然可以使用Spring提供的CustomDateEditor，不过为了能够演示自定义PropertyEditor的详细流程，在此我们有必要“重新发明轮子”！

下面是对自定义PropertyEditor实现的简单介绍。

给出针对特定对象类型的PropertyEditor实现。

假设需要对yyyy/MM/dd形式的日期格式转换提供支持。虽然可以直接让PropertyEditor实现类去实现java.beans.PropertyEditor接口，不过，通常情况下，我们可以直接继承java.beans.PropertyEditorSupport类以避免实现java.beans.PropertyEditor接口的所有方法。就好像这次，我们仅仅 让 DatePropertyEditor 完成从 String 到 java.util.Date 的转换，只需要实现setAsText(String)方法，而其他方法一概不管。该自定义PropertyEditor类定义如代码清单4-44所示。

清单4-44 DatePropertyEditor定义

```java
public class DatePropertyEditor
 private Stri
 
 @Override 
 public void setAsText(String text) throws IllegalArgumentException { 
 DateTimeFormatter dateTimeFormatter = DateTimeFormat.forPattern(ge
 Date dateValue = dateTi
 setValue(dateValue); 
 } 
 public String getDatePatt
 return datePattern; 
 } 
 public void setDatePattern(String d
 th
 } 
} 
```

如果仅仅是支持单向的从String到相应对象类型的转换，只要覆如果想支持双向转换，需要同时考虑getAsText()方法的覆写。

通过CustomEditorConfigurer注册自定义的PropertyEditor

如果有类似于DateFoo这样的类对java.util.Date所示的形式 类配置到容器中。


代码 ateFoo的定义声明以及相关配置
e() { 
ate date) { 
is.date = date; 
Foo"> 
10/16</value> 
清单4-45 D
类声明类似于
public class DateFoo {
 private Date date; 
 public Date getDat
 return date; 
 } 
 public void setDate(D
 th
 } 
} 
配置类似于

```xml
<bean id="dateFoo" class="...Date">
    <property name="date"> 
        <value>2007</value>
    </property> 
</bean> 
```

但是，默认情况下，Spring容器找不到合适的PropertyEditor将字符串“2007/10/16”转换成对
72 Spring 的 IoC 容器
象所声明的java.util.Date类型。所以，我们通过CustomEditorConfigurer将刚实现的DatePropertyEditor注册到容器，以告知容器按照DatePropertyEditor的形式进行String到java.util. 
Date
BeanFactory，就需要通过编码手动应用
Cust
("...")); 
ePropertyEditor()); 
- 
FactoryPostProcessor 所示。 
类型的转换工作。
如果使用的容器是BeanFactory的实现，比如Xml
omEditorConfigurer到容器，类似如下形式： 

```java
XmlBeanFactory beanFactory = new XmlBeanFactory(new ClassPathResource
// 
CustomEditorConfigurer ceConfigurer = new CustomEditorConfigurer(); 
Map customerEditors = new HashMap(); 
customerEditors.put(java.util.Date.class, new Dat
ceConfigurer.setCustomEditors(customerEditors); 
// 
ceConfigurer.postProcessBeanFactory(beanFactory); 
```

但如果使用的是ApplicationContext相应实现，因为ApplicationContext会自动识别Bean
并应用，所以只需要在相应配置文件中配置一下，如代码清单4-46
代码
s.factory.config.CustomEditorConfigurer"> 
erty> 
="...DatePropertyEditor"> 
MM/dd</value> 
work.beans. 
清单4-47给出了相应的实例。

清单4-46 使用CustomEditorConfigurer注册自定义DatePropertyEditor到容器

```xml
<bean class="org.springframework.bean
 <property name="customEditors"> 
 <map> 
 <entry key="java.util.Date"> 
 <ref bean="datePropertyEditor"/> 
 </entry> 
 </map> 
</prop
</bean> 
<bean id="datePropertyEditor" class
 <property name="datePattern"> 
 <value>yyyy/
 </property> 
</bean>
```

Spring 2.0之前通常是通过CustomEditorConfigurer的customEditors属性来指定自定义的
PropertyEditor。2.0之后，比较提倡使用propertyEditorRegistrars属性来指定自定义的PropertyEditor。不过，这样我们就需要再多做一步工作，就是给出一个org.springframe
PropertyEditorRegistrar的实现。这也很简单，代码
代码
mplements PropertyEditorRegistrar { 
Registry.registerCustomEditor(java.util.Date.class, getPropertyEditor()); 
pertyEditor() { 
turn propertyEditor; 
tor propertyEditor) { 
is.propertyEditor = propertyEditor; 
清单4-47 DatePropertyEditorRegistrar定义
public class DatePropertyEditorRegistrar i
 private PropertyEditor propertyEditor; 
 
 public void registerCustomEditors(PropertyEditorRegistry peRegistry) { 
 pe
 } 
 public PropertyEditor getPro
 re
} 
 public void setPropertyEditor(PropertyEdi
 th
 
} 
这样，2.0之后所提倡的注册自定义PropertyEditor的方式，如代码清单4-48所示。
} 
代码清单4-48 通过CustomEditorConfigurer的propertyEditorRegistrars注册自定义
 
onfig.CustomEditorConfigurer"> 
me="propertyEditorRegistrars"> 
n="datePropertyEditorRegistrar"/> 
erty> 
bean> 
 class="...DatePropertyEditorRegistrar"> 
atePropertyEditor"/> 
erty> 
bean> 
="...DatePropertyEditor"> 
MM/dd</value> 
有其他扩展类型的PropertyEditor，可以在propertyEditorRegistrars的\<list>中一
并指定。
解 的一生
（容器启动阶段）
的活
an方
被
springframework.context.support. 
的getBean()方法第一次被调用时，不管是显式的还是隐式的，Bean实例化阶段的活动才会被触发，
PropertyEditor

```
<bean class="org.springframework.beans.factory.c
 <property na
 <list> 
 <ref bea
 </list> 
 </prop
</
<bean id="datePropertyEditorRegistrar"
 <property name="propertyEditor"> 
 <ref bean="d
 </prop
</
<bean id="datePropertyEditor" class
 <property name="datePattern"> 
 <value>yyyy/
 </property> 
</bean> 
```

要是还有其他扩展类型的PropertyEditor，可以在propertyEditorRegistrars的\<list>中一并指定。

### 4.4.3 了解 bean 的一生

在已经可以借助于BeanFactoryPostProcessor来干预Magic实现的第一个阶段动之后，我们就可以开始探索下一个阶段，即bean实例化阶段的实现逻辑了。

容器启动之后，并不会马上就实例化相应的bean定义。我们知道，容器现在仅仅拥有所有对象的BeanDefinition来保存实例化阶段将要用的必要信息。只有当请求方通过BeanFactory的getBean()方法来请求某个对象实例的时候，才有可能触发Bean实例化阶段的活动。BeanFactory的getBean()方法可以被客户端对象显式调用，也可以在容器内部隐式地被调用。隐式调用有如下两种情况。 

- 对于BeanFactory来说，对象实例化默认采用延迟初始化。通常情况下，当对象A被请求而需要第一次实例化的时候，如果它所依赖的对象B之前同样没有被实例化，那么容器会先实例化对象A所依赖的对象。这时容器内部就会首先实例化对象B，以及对象 A依赖的其他还没有实例化的对象。这种情况是容器内部调用getBean()，对于本次请求的请求方是隐式的。
- ApplicationContext启动之后会实例化所有的bean定义，这个特性在本书中已经多次提到。但ApplicationContext在实现的过程中依然遵循Spring容器实现流程的两个阶段，只不过它会在启动阶段的活动完成之后，紧接着调用注册到该容器的所有bean定义的实例化方法getBean()。这就是为什么当你得到ApplicationContext类型的容器引用时，容器内所有对象已经被全部实例化完成。不信你查一下类org.AbstractApplicationContext的refresh()方法。

之所以说getBean()方法是有可能触发Bean实例化阶段的活动，是因为只有当对应某个bean定义第二次被调用则会直接返回容器缓存的第一次实例化完的对象实例（prototype类型bean除外）。当getBean()方法内部发现该bean定义之前还没有被实例化之后，会通过createBean()方法来进行具体的对象实例化，实例化过程如图4-10所示。

图4-10 Bean的实例化过程

Spring容器将对其所管理的对象全部给予统一的生命周期管理，这些被管理的对象完全摆脱了原来那种“new完后被使用，脱离作用域后即被回收”的命运。下面我们将详细看一看现在的每个bean在容器中是如何走过其一生的。

> **提示** 可以在org.springframework.beans.factory.support.AbstractBeanFactory类的代码中查看到getBean()方法的完整实现逻辑，可以在其子类org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory的代码中一窥createBean()方法的全貌。
{: .prompt-tip }

#### 1. Bean的实例化与BeanWrapper

容器在内部实现的时候，采用“策略模式（Strategy Pattern）”来决定采用何种方式初始化bean实例。通常，可以通过反射或者CGLIB动态字节码生成来初始化相应的bean实例或者动态生成其子类。

org.springframework.beans.factory.support.InstantiationStrategy定义是实例化策略的抽象接口，其直接子类SimpleInstantiationStrategy实现了简单的对象实例化功能，可以通过反射来实例化对象实例，但不支持方法注入方式的对象实例化。CglibSubclassingInstantiationStrategy继承了SimpleInstantiationStrategy的以反射方式实例化对象的功能，并且通过CGLIB的动态字节码生成功能，该策略实现类可以动态生成某个类的子类，进而满足了方法注入所需的对象实例化需求。默认情况下，容器内部采用的是CglibSubclassingInstantiationStrategy。

容器只要根据相应bean定义的BeanDefintion取得实例化信息，结合CglibSubclassingInstantiationStrategy以及不同的bean定义类型，就可以返回实例化完成的对象实例。但是，返回方式上有些“点缀”。不是直接返回构造完成的对象实例，而是以BeanWrapper对构造完成的对象实例进行包裹，返回相应的BeanWrapper实例。

至此，第一步结束。

BeanWrapper接口通常在Spring框架内部使用，它有一个实现类org.springframework.beans.BeanWrapperImpl。其作用是对某个bean进行“包裹”，然后对这个“包裹”的bean进行操作，比如设置或者获取bean的相应属性值。而在第一步结束后返回BeanWrapper实例而不是原先的对象实例，就是为了第二步“设置对象属性”。

BeanWrapper定义继承了org.springframework.beans.PropertyAccessor接口，可以以统一的方式对对象属性进行访问；BeanWrapper定义同时又直接或者间接继承了PropertyEditorRegistry和TypeConverter接口。不知你是否还记得CustomEditorConfigurer？当把各种PropertyEditor注册给容器时，知道后面谁用到这些PropertyEditor吗？对，就是BeanWrapper！在第一步构造完成对象之后，Spring会根据对象实例构造一个BeanWrapperImpl实例，然后将之前CustomEditorConfigurer注册的PropertyEditor复制一份给BeanWrapperImpl实例（这就是BeanWrapper同时又是PropertyEditorRegistry的原因）。这样，当BeanWrapper转换类型、设置对象属性值时，就不会无从下手了。

使用BeanWrapper对bean实例操作很方便，可以免去直接使用Java反射API（Java Reflection API）操作对象实例的烦琐。来看一段代码（见代码清单4-49），之后我们就会更加清楚Spring容器内部是如何设置对象属性的了！

代码清单4-49 使用BeanWrapper操作对象

```java
Object provider = Class.forName("package.name.FXNewsProvider").newInstance(); 
Object listener = Class.forName("package.name.DowJonesNewsListener").newInstance(); 
Object persister = Class.forName("package.name.DowJonesNewsPersister").newInstance(); 
BeanWrapper newsProvider = new BeanWrapperImpl(provider); 
newsProvider.setPropertyValue("newsListener", listener); 
newsProvider.setPropertyValue("newPersistener", persister); 
assertTrue(newsProvider.getWrappedInstance() instanceof FXNewsProvider); 
assertSame(provider, newsProvider.getWrappedInstance()); 
assertSame(listener, newsProvider.getPropertyValue("newsListener")); 
assertSame(persister, newsProvider.getPropertyValue("newPersistener")); 
```

我想有了BeanWrapper的帮助，你不会想直接使用Java反射API来做同样事情的。代码清单4-50演示了同样的功能，即直接使用Java反射API是如何实现的（忽略了异常处理相关代码）。 

代码清单4-50 直接使用Java反射API操作对象

```java
Object provider = Class.forName("package.name.FXNewsProvider").newInstance(); 
Object listener = Class.forName("package.name.DowJonesNewsListener").newInstance(); 
Object persister = Class.forName("package.name.DowJonesNewsPersister").newInstance(); 

Class providerClazz = provider.getClass(); 
Field listenerField = providerClazz.getField("newsListener"); 
listenerField.set(provider, listener); 
Field persisterField = providerClazz.getField("newsListener"); 
persisterField.set(provider, persister); 
assertSame(listener, listenerField.get(provider)); 
assertSame(persister, persisterField.get(provider));
```

如果你觉得没有太大差别，那是因为没有看到紧随其后的那些异常（exception）还有待处理！

#### 2. 各色的Aware接口

当对象实例化完成并且相关属性以及依赖设置完成之后，Spring容器会检查当前对象实例是否实现了一系列的以Aware命名结尾的接口定义。如果是，则将这些Aware接口定义中规定的依赖注入给当前对象实例。

这些Aware接口为如下几个。

- org.springframework.beans.factory.BeanNameAware。如果Spring容器检测到当前对象实例实现了该接口，会将该对象实例的bean定义对应的beanName设置到当前对象实例。
- org.springframework.beans.factory.BeanClassLoaderAware。如果容器检测到当前对象实例实现了该接口，会将对应加载当前bean的Classloader注入当前对象实例。默认会使用加载org.springframework.util.ClassUtils类的Classloader。
- org.springframework.beans.factory.BeanFactoryAware。在介绍方法注入的时候，我们提到过使用该接口以便每次获取prototype类型bean的不同实例。如果对象声明实现了BeanFactoryAware接口，BeanFactory容器会将自身设置到当前对象实例。这样，当前对象实例就拥有了一个BeanFactory容器的引用，并且可以对这个容器内允许访问的对象按照需要进行访问。

以上几个Aware接口只是针对BeanFactory类型的容器而言，对于ApplicationContext类型的容器，也存在几个Aware相关接口。不过在检测这些接口并设置相关依赖的实现机理上，与以上几个接口处理方式有所不同，使用的是下面将要说到的BeanPostProcessor方式。不过，设置Aware接口这一步与BeanPostProcessor是相邻的，把这几个接口放到这里一起提及，也没什么不可以的。

对于ApplicationContext类型容器，容器在这一步还会检查以下几个Aware接口并根据接口定义
设置相关依赖。

- org.springframework.context.ResourceLoaderAware 。 ApplicationContext 实现了Spring的ResourceLoader接口（后面会提及详细信息）。当容器检测到当前对象实例实现了ResourceLoaderAware接口之后，会将当前ApplicationContext自身设置到对象实例，这样当前对象实例就拥有了其所在ApplicationContext容器的一个引用。
- org.springframework.context.ApplicationEventPublisherAware。ApplicationContext作为一个容器，同时还实现了ApplicationEventPublisher接口，这样，它就可以作为ApplicationEventPublisher来使用。所以，当前ApplicationContext容器如果检测到当前实例化的对象实例声明了ApplicationEventPublisherAware接口，则会将自身注入当前对象。
- org.springframework.context.MessageSourceAware。ApplicationContext通过MessageSource接口提供国际化的信息支持，即I18n（Internationalization）。它自身就实现了MessageSource接口，所以当检测到当前对象实例实现了MessageSourceAware接口，则会将自身注入当前对象实例。
- org.springframework.context.ApplicationContextAware。 如果ApplicationContext容器检测到当前对象实现了ApplicationContextAware接口，则会将自身注入当前对象实例。

#### 3. BeanPostProcessor

BeanPostProcessor的概念容易与BeanFactoryPostProcessor的概念混淆。但只要记住BeanPostProcessor是存在于对象实例化阶段，而BeanFactoryPostProcessor则是存在于容器启动阶段，这两个概念就比较容易区分了。

与BeanFactoryPostProcessor通常会处理容器内所有符合条件的BeanDefinition类似，BeanPostProcessor会处理容器内所有符合条件的实例化后的对象实例。该接口声明了两个方法，分别在两个不同的时机执行，见如下代码定义： 

```java
public interface BeanPostProcessor {
    Object postProcessBeforeInitialization(Object bean, String beanName) throws  BeansException; 
    Object postProcessAfterInitialization(Object bean, String beanName) throws   BeansException; 
}
```

postProcessBeforeInitialization()方法是图4-10中BeanPostProcessor前置处理这一步将会执行的方法，postProcessAfterInitialization()则是对应图4-10中BeanPostProcessor后置处理那一步将会执行的方法。BeanPostProcessor的两个方法中都传入了原来的对象实例的引用，这为我们扩展容器的对象实例化过程中的行为提供了极大的便利，我们几乎可以对传入的对象实例执行任何的操作。

通常比较常见的使用BeanPostProcessor的场景，是处理标记接口实现类，或者为当前对象提供代理实现。在图4-10的第三步中，ApplicationContext对应的那些Aware接口实际上就是通过BeanPostProcessor的方式进行处理的。当ApplicationContext中每个对象的实例化过程走到BeanPostProcessor前置处理这一步时，ApplicationContext容器会检测到之前注册到容器的ApplicationContextAwareProcessor这个BeanPostProcessor的实现类，然后就会调用其postProcessBeforeInitialization()方法，检查并设置Aware相关依赖。ApplicationContextAwareProcessor的postProcessBeforeInitialization()代码很简单明了，见代码清单4-51。

代码清单4-51 postProcessBeforeInitialization方法定义 8 

```java
public Object postProcessBeforeInitialization(Object bean, String beanName) throws  
BeansException { 
9 if (bean instanceof ResourceLoaderAware) { 
 ((ResourceLoaderAware) bean).setResourceLoader(this.applicationContext); 
 } 
 if (bean instanceof ApplicationEventPublisherAware) { 
 ((ApplicationEventPublisherAware) bean).setApplicationEventPublisher  
 (this.applicationContext); 
 } 
if (bean instanceof MessageSourceAware) { 
 ((MessageSourceAware) bean).setMessageSource(this.applicationContext); 
 } 
 if (bean instanceof ApplicationContextAware) { 
 ((ApplicationContextAware) bean).setApplicationContext(this.applicationContext); 
 } 
 return bean; 
}
```

除了检查标记接口以便应用自定义逻辑，还可以通过BeanPostProcessor对当前对象实例做更多的处理。比如替换当前对象实例或者字节码增强当前对象实例等。Spring的AOP则更多地使用BeanPostProcessor来为对象生成相应的代理对象，如org.springframework.aop.framework.autoproxy.BeanNameAutoProxyCreator。我们将在Spring AOP部分详细介绍该类和AOP相关概念。BeanPostProcessor是容器提供的对象实例化阶段的强有力的扩展点。为了进一步演示它的强大威力，我们有必要实现一个自定义的BeanPostProcessor。

- 自定义BeanPostProcessor

假设系统中所有的IFXNewsListener实现类需要从某个位置取得相应的服务器连接密码，而且系统中保存的密码是加密的，那么在IFXNewsListener发送这个密码给新闻服务器进行连接验证的时候，首先需要对系统中取得的密码进行解密，然后才能发送。我们将采用BeanPostProcessor技术，对所有的IFXNewsListener的实现类进行统一的解密操作。

(1) 标注需要进行解密的实现类

为了能够识别那些需要对服务器连接密码进行解密的IFXNewsListener实现，我们声明了接口PasswordDecodable，并要求相关IFXNewsListener实现类实现该接口。PasswordDecodable接口声明以及相关的IFXNewsListener实现类定义见代码清单4-52。

代码清单4-52 PasswordDecodable接口声明以及相关的IFXNewsListener实现类

```java
public interface PasswordDecodable { 
 String getEncodedPassword(); 
 void setDecodedPassword(String password); 
} 
public class DowJonesNewsListener implements IFXNewsListener,PasswordDecodable { 
 private String password; 
 
 public String[] getAvailableNewsIds() { 
 // 省略
 } 
 public FXNewsBean getNewsByPK(String newsId) { 
 // 省略
 } 
 public void postProcessIfNecessary(String newsId) { 
 // 省略
 } 
 public String getEncodedPassword() { 
 return this.password; 
 } 
 public void setDecodedPassword(String password) { 
 this.password = password; 
 } 
} 
```

(2) 实现相应的BeanPostProcessor对符合条件的Bean实例进行处理

我们通过PasswordDecodable接口声明来区分将要处理的对象实例①，当检查到当前对象实例实现了该接口之后，就会从当前对象实例取得加密后的密码，并对其解密。然后将解密后的密码设置回当前对象实例。之后，返回的对象实例所持有的就是解密后的密码，逻辑如代码清单4-53所示。

代码清单4-53 用于解密的自定义BeanPostProcessor实现类

```java
public class PasswordDecodePostProcessor implements BeanPostProcessor { 
 public Object postProcessAfterInitialization(Object object, String beanName) 
 throws BeansException { 
 return object; 
 } 
 public Object postProcessBeforeInitialization(Object object, String beanName) 
 throws BeansException { 
 if(object instanceof PasswordDecodable) 
 
① 如果有其他方式可以区分将要处理的对象实例，那么声明类似的标记接口（Marker Interface）就不是必须的。
4.4 容器背后的秘密 79 
 { 
 String encodedPassword = ((PasswordDecodable)object).getEncodedPassword(); 
 String decodedPassword = decodePassword(encodedPassword); 
 ((PasswordDecodable)object).setDecodedPassword(decodedPassword); 
2 } 
 return object; 
 } 
 private String decodePassword(String encodedPassword) { 
 // 实现解码逻辑 3 
 return encodedPassword; 
 } 
4 }
```

(3) 将自定义的BeanPostProcessor注册到容器

只有将自定义的BeanPostProcessor实现类告知容器，容器才会在合适的时机应用它。所以，我们需要将PasswordDecodePostProcessor注册到容器。

对于BeanFactory类型的容器来说，我们需要通过手工编码的方式将相应的BeanPostProcessor注册到容器，也就是调用ConfigurableBeanFactory的addBeanPostProcessor()方法，见如下代码：

```java
ConfigurableBeanFactory beanFactory = new XmlBeanFactory(new ClassPathResource(...)); 
beanFactory.addBeanPostProcessor(new PasswordDecodePostProcessor()); 
... 7 
// getBean();
```

对于ApplicationContext容器来说，事情则方便得多，直接将相应的BeanPostProcessor实现类通过通常的XML配置文件配置一下即可。ApplicationContext容器会自动识别并加载注册到容器的BeanPostProcessor，如下配置内容将我们的PasswordDecodePostProcessor注册到容器：

```xml
<beans> 
 <bean id="passwordDecodePostProcessor" class="package.name.PasswordDecodePostProcessor"> 
 <!--如果需要，注入必要的依赖--> 
 </bean>
 ... 
</beans> 
```

合理利用BeanPostProcessor这种Spring的容器扩展机制，将可以构造强大而灵活的应用系统。

> 提示 实际上，有一种特殊类型的BeanPostProcessor我们没有提到，它的执行时机与通常的 BeanPostProcessor 不同。<br/>org.springframework.beans.factory.config.InstantiationAwareBeanPostProcessor接口可以在对象的实例化过程中导致某种类似于电路“短路”的效果。实际上，并非所有注册到Spring容器内的bean定义都是按照图4-10的流程实例化的。在所有的步骤之前，也就是实例
化bean对象步骤之前，容器会首先检查容器中是否注册有InstantiationAwareBeanPostProcessor类型的BeanPostProcessor。如果有，首先使用相应的InstantiationAwareBeanPostProcessor来构造对象实例。构造成功后直接返回构造完成的对象实例，而不会按照“正规的流程”继续执行。这就是它可能造成“短路”的原因。<br/>不过，通常情况下都是Spring容器内部使用这种特殊类型的BeanPostProcessor做一些动态对象代理等工作，我们使用普通的BeanPostProcessor实现就可以。这里简单提及一下，目的是让大家有所了解。
{: .prompt-tip }

#### 4. InitializingBean和init-method

org.springframework.beans.factory.InitializingBean是容器内部广泛使用的一个对象生命周期标识接口，其定义如下：

```java
public interface InitializingBean { 
 void afterPropertiesSet() throws Exception; 
}
```

该接口定义很简单，其作用在于，在对象实例化过程调用过“BeanPostProcessor的前置处理”之后，会接着检测当前对象是否实现了InitializingBean接口，如果是，则会调用其afterPropertiesSet()方法进一步调整对象实例的状态。比如，在有些情况下，某个业务对象实例化完成后，还不能处于可以使用状态。这个时候就可以让该业务对象实现该接口，并在方法afterPropertiesSet()中完成对该业务对象的后续处理。

虽然该接口在Spring容器内部广泛使用，但如果真的让我们的业务对象实现这个接口，则显得Spring容器比较具有侵入性。所以，Spring还提供了另一种方式来指定自定义的对象初始化操作，那就是在XML配置的时候，使用\<bean>的init-method属性。

通过init-method，系统中业务对象的自定义初始化操作可以以任何方式命名，而不再受制于InitializingBean的afterPropertiesSet()。如果系统开发过程中规定：所有业务对象的自定义初始化操作都必须以init()命名，为了省去挨个\<bean>的设置init-method这样的烦琐，我们还可以通过最顶层的\<beans>的default-init-method统一指定这一init()方法名。

一般，我们是在集成第三方库，或者其他特殊的情况下，才会需要使用该特性。比如，ObjectLab提供了一个外汇系统交易日计算的开源实现——ObjectLabKit，系统在使用它提供的DateCalculator时，封装类会通过一个自定义的初始化方法来为这些DateCalculator提供计算交易日所需要排除的休息日信息。代码清单4-54给出了封装类的部分代码。

代码清单4-54 DateCalculator封装类定义 

```java
public class FXTradeDateCalculator { 
 public static final DateTimeFormatter FRONT_DATE_FORMATTER =  
 DateTimeFormat.forPattern("yyyyMMdd"); 
 private static final Set<LocalDate> holidaySet =  
 new HashSet<LocalDate>(); 
 private static final String holidayKey = "JPY"; 
 private SqlMapClientTemplate sqlMapClientTemplate; 
 public FXTradeDateCalculator(SqlMapClientTemplate sqlMapClientTemplate) { 
 this.sqlMapClientTemplate = sqlMapClientTemplate; 
 } 
 public void setupHolidays() { 
 List holidays = getSystemHolidays(); 
 if(!ListUtils.isEmpty(holidays)) { 
 for(int i=0,size=holidays.size();i<size;i++) { 
 String holiday = (String)holidays.get(i); 
 LocalDate date =  
 FRONT_DATE_FORMATTER.parseDateTime(holiday).toLocalDate(); 
 holidaySet.add(date); 
 } 
 } 
 LocalDateKitCalculatorsFactory  
2 .getDefaultInstance().registerHolidays(holidayKey, holidaySet); 
 } 
 public DateCalculator<LocalDate> getForwardDateCalculator() 
 { 
 return LocalDateKitCalculatorsFactory   3 
 .getDefaultInstance()  
 .getDateCalculator(holidayKey, HolidayHandlerType.FORWARD); 
4 } 
 public DateCalculator<LocalDate> getBackwardDateCalculator() 
5 { 
 return LocalDateKitCalculatorsFactory  
 .getDefaultInstance()  
 .getDateCalculator(holidayKey, HolidayHandlerType.BACKWARD); 
 } 6 
 public List getSystemHolidays() 
 { 
7 return getSqlMapClientTemplate()  
 .queryForList("CommonContext.holiday", null); 
 } 
}
```

为了保证getForwardDateCalculator()和getBackwardDateCalculator()方法返回的DateCalculator已经将休息日考虑进去，在这两个方法被调用之前，我们需要setupHolidays()首先被调用，以保证将休息日告知DateCalculator，使它能够在计算交易日的时候排除掉这些休息日的日期。因此，我们需要在配置文件中完成类似代码清单4-55所示的配置，以保证在对象可用之前，setupHolidays()方法会首先被调用。

代码清单4-55 使用init-method保证封装类的初始化方法得以执行

```java
<beans> 11 
 <bean id="tradeDateCalculator" class="FXTradeDateCalculator" init-method="setupHolidays"> 
 <constructor-arg> 
 <ref bean="sqlMapClientTemplate"/> 
 </constructor-arg> 
 </bean> 

 
 <bean id="sqlMapClientTemplate"  
 class="org.springframework.orm.ibatis.SqlMapClientTemplate"> 
 ... 
 </bean> 
 
 ... 
</beans>
```

当然，我们也可以让FXTradeDateCalculator实现InitializingBean接口，然后将setupHolidays()方法的逻辑转移到afterPropertiesSet()方法。不过，相对来说还是采用init-method的方式比较灵活，并且没有那么强的侵入性。

可以认为在InitializingBean和init-method中任选其一就可以帮你完成类似的初始化工作。除非……，除非你真的那么“幸运”，居然需要在同一个业务对象上按照先后顺序执行两个初始化方 Spring 的 IoC 容器法。这个时候，就只好在同一对象上既实现InitializingBean的afterPropertiesSet()，又提供自定义初始化方法啦！

#### 5. DisposableBean与destroy-method

当所有的一切，该设置的设置，该注入的注入，该调用的调用完成之后，容器将检查singleton类型的bean实例，看其是否实现了org.springframework.beans.factory.DisposableBean接口。或者其对应的bean定义是否通过\<bean>的destroy-method属性指定了自定义的对象销毁方法。如果是，就会为该实例注册一个用于对象销毁的回调（Callback），以便在这些singleton类型的对象实例销毁之前，执行销毁逻辑。

与InitializingBean和init-method用于对象的自定义初始化相对应，DisposableBean和destroy-method为对象提供了执行自定义销毁逻辑的机会。

最常见到的该功能的使用场景就是在Spring容器中注册数据库连接池，在系统退出后，连接池应该关闭，以释放相应资源。代码清单4-56演示了通常情况下使用destroy-method处理资源释放的数据源注册配置。

代码清单4-56 使用了自定义销毁方法的数据源配置定义

```xml
<bean id="dataSource" class="org.apache.commons.dbcp.BasicDataSource" estroy-method="close"> 
    <property name="url"> 
        <value>${jdbc.url}</value> 
    </property> 
    <property name="driverClassName"> 
        <value>${jdbc.driver}</value> 
    </property> 
    <property name="username"> 
        <value>${jdbc.username}</value> 
    </property> 
    <property name="password"> 
        <value>${jdbc.password}</value> 
    </property> 
    ... 
</bean>
```

不过，这些自定义的对象销毁逻辑，在对象实例初始化完成并注册了相关的回调方法之后，并不会马上执行。回调方法注册后，返回的对象实例即处于使用状态，只有该对象实例不再被使用的时候，才会执行相关的自定义销毁逻辑，此时通常也就是Spring容器关闭的时候。但Spring容器在关闭之前，不会聪明到自动调用这些回调方法。所以，需要我们告知容器，在哪个时间点来执行对象的自定义销毁方法。

对于 **BeanFactory 容器**来说。我们需要在独立应用程序的主程序退出之前，或者其他被认为是合适的情况下（依照应用场景而定），如代码清单4-57所示，调用ConfigurableBeanFactory提供的destroySingletons()方法销毁容器中管理的所有singleton类型的对象实例。

代码清单4-57 使用ConfigurableBeanFactory的destroySingletons()方法触发销毁对象行为

```java
public class ApplicationLauncher 
{ 
 public static void main(String[] args) { 
 BasicConfigurator.configure(); 
 BeanFactory container = new XmlBeanFactory(new ClassPathResource("...")); 
 BusinessObject bean = (BusinessObject)container.getBean("..."); 
 bean.doSth(); 
((ConfigurableListableBeanFactory)container).destroySingletons(); 
 // 应用程序退出，容器关闭
 } 
} 
```

如果不能在合适的时机调用destroySingletons()，那么所有实现了DisposableBean接口的对象实例或者声明了destroy-method的bean定义对应的对象实例，它们的自定义对象销毁逻辑就形同虚设，因为根本就不会被执行！

对于ApplicationContext容器来说。道理是一样的。但AbstractApplicationContext为我们提供了registerShutdownHook()方法，该方法底层使用标准的Runtime类的addShutdownHook()方式来调用相应bean对象的销毁逻辑，从而保证在Java虚拟机退出之前，这些singtleton类型的bean对象实例的自定义销毁逻辑会被执行。当然AbstractApplicationContext注册的shutdownHook不只是调用对象实例的自定义销毁逻辑，也包括ApplicationContext相关的事件发布等，代码清单4-58演示了该方法的使用。

代码清单4-58 使用registerShutdownHook()方法注册并触发对象销毁逻辑回调行为

```java
public class ApplicationLauncher 
{ 
 public static void main(String[] args) { 
 BasicConfigurator.configure(); 
 BeanFactory container = new ClassPathXmlApplicationContext("..."); 
 ((AbstractApplicationContext)container).registerShutdownHook(); 
 BusinessObject bean = (BusinessObject)container.getBean("..."); 
 bean.doSth(); 
 // 应用程序退出，容器关闭
 } 
}
``` 
 
同样的道理，在 Spring 2.0引入了自定义scope之后，使用自定义scope的相关对象实例的销毁逻辑，也应该在合适的时机被调用执行。不过，所有这些规则不包含prototype类型的bean实例，因为 prototype 对象实例在容器实例化并返回给请求方之后，容器就不再管理这种类型对象实例的生命周期了。 

至此，bean走完了它在容器中“光荣”的一生。 

## 4.5 小结

Spring的IoC容器主要有两种，即BeanFactory和ApplicationContext。本章伊始，首先对这两种容器做了总体上的介绍，然后转入本章的重点，也就是Spring的BeanFactory基础容器。

我们从对比使用BeanFactory开发前后的差别开始，阐述了BeanFactory作为一个具体的IoC Service Provider，它是如何支持各种对象注册以及依赖关系绑定的。XML自始至终都是Spring的IoC容器支持最完善的Configuration Metadata提供方式。所以，我们接着从XML入手，深入挖掘了BeanFactory（以及ApplicationContext）的各种潜力。

对于充满好奇心的我们，不会只停留在会使用BeanFactory进行开发这一层面。所以，最后我们又一起探索了BeanFactory（当然，也是ApplicationContext）实现背后的各种奥秘。BeanFactory 是Spring提供的基础IoC容器，但并不是Spring提供的唯一IoC容器。ApplicationContext构建于BeanFactory之上，提供了许多BeanFactory之外的特性。下一章，我们将一起走入ApplicationContext的世界。