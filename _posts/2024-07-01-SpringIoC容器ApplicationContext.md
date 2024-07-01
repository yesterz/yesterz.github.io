
作为Spring提供的较之BeanFactory更为先进的IoC容器实现，ApplicationContext除了拥有BeanFactory支持的所有功能之外，还进一步扩展了基本容器的功能，包括BeanFactoryPostProcessor、BeanPostProcessor以及其他特殊类型bean的自动识别、容器启动后bean实例的自动初始化、国际化的信息支持、容器内事件发布等。真是“青出于蓝而胜于蓝”啊！ 

Spring为基本的BeanFactory类型容器提供了XmlBeanFactory实现。相应地，它也为ApplicationContext类型容器提供了以下几个常用的实现。

- org.springframework.context.support.FileSystemXmlApplicationContext。在默认情况下，从文件系统加载bean定义以及相关资源的ApplicationContext实现。
- org.springframework.context.support.ClassPathXmlApplicationContext。在默认情况下，从Classpath加载bean定义以及相关资源的ApplicationContext实现。
- org.springframework.web.context.support.XmlWebApplicationContext。Spring提供的用于Web应用程序的ApplicationContext实现，我们将在第六部分更多地接触到它。

更多实现可以参照org.springframework.context.ApplicationContext接口定义的Javadoc，这里不再赘述。

第4章中说明了ApplicationContext所支持的大部分功能。下面主要围绕ApplicationContext较之BeanFactory特有的一些特性展开讨论，即国际化（I18n）信息支持、统一资源加载策略以及容器内事件发布等。

## 统一资源加载策略

要搞清楚Spring为什么提供这么一个功能，还是从Java SE提供的标准类java.net.URL说起比较好。URL全名是Uniform Resource Locator（统一资源定位器），但多少有些名不副实的味道。

首先，说是统一资源定位，但基本实现却只限于网络形式发布的资源的查找和定位工作，基本上只提供了基于HTTP、FTP、File等协议（sun.net.www.protocol包下所支持的协议）的资源定位功能。虽然也提供了扩展的接口，但从一开始，其自身的“定位”就已经趋于狭隘了。实际上，资源这个词的范围比较广义，资源可以任何形式存在，如以二进制对象形式存在、以字节流形式存在、以文件形式存在等；而且，资源也可以存在于任何场所，如存在于文件系统、存在于Java应用的Classpath中，甚至存在于URL可以定位的地方。

其次，从某些程度上来说，该类的功能职责划分不清，资源的查找和资源的表示没有一个清晰的界限。当前情况是，资源查找后返回的形式多种多样，没有一个统一的抽象。理想情况下，资源查找完成后，返回给客户端的应该是一个统一的资源抽象接口，客户端要对资源进行什么样的处理，应该由资源抽象接口来界定，而不应该成为资源的定位者和查找者同时要关心的事情。 

所以，在这个前提下，Spring提出了一套基于org.springframework.core.io.Resource和org.springframework.core.io.ResourceLoader接口的资源抽象和加载策略。

### Spring中的Resource

Spring框架内部使用org.springframework.core.io.Resource接口作为所有资源的抽象和访问接口，我们之前在构造BeanFactory的时候已经接触过它，如下代码： 

    ```java
    BeanFactory beanFactory = new XmlBeanFactory(new ClassPathResource("..."));
    // ... 
    ```

其中ClassPathResource就是Resource的一个特定类型的实现，代表的是位于Classpath中的资源。Resource接口可以根据资源的不同类型，或者资源所处的不同场合，给出相应的具体实现。Spring框架在这个理念的基础上，提供了一些实现类（可以在org.springframework.core.io包下找到这些实现类）。

    - ByteArrayResource。将字节（byte）数组提供的数据作为一种资源进行封装，如果通过InputStream形式访问该类型的资源，该实现会根据字节数组的数据，构造相应的ByteArrayInputStream并返回。 
    - ClassPathResource。该实现从Java应用程序的ClassPath中加载具体资源并进行封装，可以使用指定的类加载器（ClassLoader）或者给定的类进行资源加载。
    - FileSystemResource。对java.io.File类型的封装，所以，我们可以以文件或者URL的形式对该类型资源进行访问，只要能跟File打的交道，基本上跟FileSystemResource也可以。 
    - UrlResource。通过java.net.URL进行的具体资源查找定位的实现类，内部委派URL进行具体的资源操作。 
    - InputStreamResource。将给定的InputStream视为一种资源的Resource实现类，较为少用。可能的情况下，以ByteArrayResource以及其他形式资源实现代之。

如果以上这些资源实现还不能满足要求，那么我们还可以根据相应场景给出自己的实现，只需实现org.springframework.core.io.Resource接口就是了。代码清单5-1给出了该接口的定义。

代码清单5-1 Resource接口定义

    ```java
    public interface Resource extends InputStreamSource {

        boolean exists(); 
        boolean isOpen(); 
        URL getURL() throws IOException; 
        File getFile() throws IOException;

        Resource createRelative(String relativePath) throws IOException; 
        String getFilename(); 
        String getDescription(); 
    } 
    
    public interface InputStreamSource { 
        InputStream getInputStream() throws IOException; 
    } 
    ```

该接口定义了7个方法，可以帮助我们查询资源状态、访问资源内容，甚至根据当前资源创建新的相对资源。不过，要真想实现自定义的Resource，倒是真没必要直接实现该接口，我们可以继承org.springframework.core.io.AbstractResource抽象类，然后根据当前具体资源特征，覆盖相应的方法就可以了。什么？让我给个实现的例子？算了吧，目前我还没碰到这样的需求。呵呵！要真的碰上了，你只要知道有这么“一出儿”就行了。

### ResourceLoader，“更广义的URL”

资源是有了，但如何去查找和定位这些资源，则应该是ResourceLoader的职责所在了。org.springframework.core.io.ResourceLoader接口是资源查找定位策略的统一抽象，具体的资源查找定位策略则由相应的ResourceLoader实现类给出。我想，把ResourceLoader称作统一资源定位器或许才更恰当一些吧！ResourceLoader定义如下：

    ```java
    public interface ResourceLoader { 

        String CLASSPATH_URL_PREFIX = ResourceUtils.CLASSPATH_URL_PREFIX; 
        Resource getResource(String location); 
        ClassLoader getClassLoader(); 
    }
    ```

    其中最主要的就是Resource getResource(String location);方法，通过它，我们就可以根据指定的资源位置，定位到具体的资源实例。

#### 1. 可用的ResourceLoader 

- DefaultResourceLoader

ResourceLoader有一个默认的实现类，即org.springframework.core.io.DefaultResourceLoader，该类默认的资源查找处理逻辑如下。

(1) 首先检查资源路径是否以classpath:前缀打头，如果是，则尝试构造ClassPathResource类型资源并返回。

(2) 否则，(a) 尝试通过URL，根据资源路径来定位资源，如果没有抛出MalformedURLException，有则会构造UrlResource类型的资源并返回；(b)如果还是无法根据资源路径定位指定的资源，则委派getResourceByPath(String) 方法来定位， DefaultResourceLoader 的getResourceByPath(String)方法默认实现逻辑是，构造ClassPathResource类型的资源并返回。

在这个基础上，让我们来看一下DefaultResourceLoader的行为是如何反应到程序中的吧！代码清单5-2给出的代码片段演示了DefaultResourceLoader的具体行为。

代码清单5-2 DefaultResourceLoader使用演示

    ```java
    ResourceLoader resourceLoader = new DefaultResourceLoader(); 
    Resource fakeFileResource = resourceLoader.getResource("D:/spring21site/README"); 
    assertTrue(fakeFileResource instanceof ClassPathResource); 
    assertFalse(fakeFileResource.exists()); 
    
    Resource urlResource1 = resourceLoader.getResource("file:D:/spring21site/README"); 
    assertTrue(urlResource1 instanceof UrlResource); 
    
    Resource urlResource2 = resourceLoader.getResource("http://www.spring21.cn"); 
    assertTrue(urlResource2 instanceof UrlResource); 
    
    try{ 
        fakeFileResource.getFile(); 
        fail("no such file with path["+fakeFileResource.getFilename()+"] exists in classpath"); 
    } catch(FileNotFoundException e){ 
    // 
    } 

    try{ 
        urlResource1.getFile();
    } catch(FileNotFoundException e) { 
        fail(); 
    }
    ```

尤其注意fakeFileResource资源的类型，并不是我们所预期的FileSystemResource类型，而是ClassPathResource类型，这是由DefaultResourceLoader的资源查找逻辑所决定的。如果最终没有找到符合条件的相应资源，getResourceByPath(String)方法就会构造一个实际上并不存在的资源并返回。而指定有协议前缀的资源路径，则通过URL能够定位，所以，返回的都是UrlResource类型。

- FileSystemResourceLoader 

为了避免DefaultResourceLoader在最后getResourceByPath(String)方法上的不恰当处理，我们可以使用org.springframework.core.io.FileSystemResourceLoader，它继承自DefaultResourceLoader，但覆写了getResourceByPath(String)方法，使之从文件系统加载资源并以FileSystemResource类型返回。这样，我们就可以取得预想的资源类型。代码清单5-3中的代码将帮助我们验证这一点。

代码清单5-3 使用FileSystemResourceLoader

```java
public void testResourceTypesWithFileSystemResourceLoader() { 

    ResourceLoader resourceLoader = new FileSystemResourceLoader(); 
    Resource fileResource = resourceLoader.getResource("D:/spring21site/README"); 
    assertTrue(fileResource instanceof FileSystemResource); 
    assertTrue(fileResource.exists()); 
 
    Resource urlResource = resourceLoader.getResource("file:D:/spring21site/README"); 
    assertTrue(urlResource instanceof UrlResource); 
}
```

FileSystemResourceLoader在ResourceLoader家族中的兄弟FileSystemXmlApplicationContext，也是覆写了getResourceByPath(String)方法的逻辑，以改变DefaultResourceLoader的默认资源加载行为，最终从文件系统中加载并返回FileSystemResource类型的资源。

#### 2. ResourcePatternResolver ——批量查找的ResourceLoader

ResourcePatternResolver是ResourceLoader的扩展，ResourceLoader每次只能根据资源路径返回确定的单个Resource实例，而ResourcePatternResolver则可以根据指定的资源路径匹配模式，每次返回多个Resource实例。接口org.springframework.core.io.support.ResourcePatternResolver定义如下：

    ```java
    public interface ResourcePatternResolver extends ResourceLoader { 
        String CLASSPATH_ALL_URL_PREFIX = "classpath*:"; 
        Resource[] getResources(String locationPattern) throws IOException; 
    }
    ```

ResourcePatternResolver在继承ResourceLoader原有定义的基础上，又引入了Resource[]getResources(String)方法定义，以支持根据路径匹配模式返回多个Resources的功能。它同时还引入了一种新的协议前缀classpath*:，针对这一点的支持，将由相应的子类实现给出。

ResourcePatternResolver最常用的一个实现是org.springframework.core.io.support.PathMatchingResourcePatternResolver，该实现类支持ResourceLoader级别的资源加载，支持基于Ant风格的路径匹配模式（类似于**/*.suffix之类的路径形式），支持ResourcePatternResolver新增加的classpath*:前缀等，基本上集所有技能于一身。

在构造PathMatchingResourcePatternResolver实例的时候，可以指定一个ResourceLoader，如果不指定的话，则PathMatchingResourcePatternResolver内部会默认构造一个DefaultResourceLoader实例。athMatchingResourcePatternResolver内部会将匹配后确定的资源路径，委派给它的ResourceLoader来查找和定位资源。这样，如果不指定任何ResourceLoader的话，PathMatchingResourcePatternResolver在加载资源的行为上会与DefaultResourceLoader基本相同，只存在返回的Resource数量上的差异。如下代码表明了二者在资源加载行为上的一致性：

    ```java
    ResourcePatternResolver resourceResolver = new PathMatchingResourcePatternResolver(); 
    Resource fileResource = resourceResolver.getResource("D:/spring21site/README"); 
    assertTrue(fileResource instanceof ClassPathResource); 
    assertFalse(fileResource.exists()); 
    // ...
    ```

不过，可以通过传入其他类型的ResourceLoader来替换PathMatchingResourcePatternResolver内部默认使用的DefaultResourceLoader，从而改变其默认行为。比如，可以如代码清单5-4所示，使用FileSystemResourceLoader替换默认的DefaultResourceLoader，从而使得PathMatchingResourcePatternResolver的行为跟使用FileSystemResourceLoader一样。

代码清单5-4 替换DefaultResourceLoader后的PathMatchingResourcePatternResolver

    ```java
    public void testResourceTypesWithPathMatchingResourcePatternResolver() { 
        
        ResourcePatternResolver resourceResolver = new PathMatchingResourcePatternResolver(); 
        Resource fileResource = resourceResolver.getResource("D:/spring21site/README"); 
        assertTrue(fileResource instanceof ClassPathResource); 
        assertFalse(fileResource.exists()); 
    
        resourceResolver = new PathMatchingResourcePatternResolver(new FileSystemResourceLoader()); 
        fileResource = resourceResolver.getResource("D:/spring21site/README"); 
        assertTrue(fileResource instanceof FileSystemResource); 
        assertTrue(fileResource.exists()); 
    }
    ```

#### 3. 回顾与展望

现在我们应该对Spring的统一资源加载策略有了一个整体上的认识，就如图5-1所示。 

虽然现在看来比较“单薄”，不过，稍后，我们就会发现情况并非如此了。






### ApplicationContext与ResourceLoader

说是讲 ApplicationContext的统一资源加载策略，到目前为止却一直没有涉及任何ApplicationContext相关的内容，不知道你是否开始奇怪了呢？实际上，我是有意为之，就是不想让各位因为过多关注ApplicationContext，却忽略了事情的本质。

如果回头看一下图4-2，就会发现，ApplicationContext继承了ResourcePatternResolver，当然就间接实现了ResourceLoader接口。所以，任何的ApplicationContext实现都可以看作是一个ResourceLoader甚至ResourcePatternResolver。而这就是ApplicationContext支持Spring内统一资源加载策略的真相。

通常，所有的ApplicationContext实现类会直接或者间接地继承org.springframework.context.support.AbstractApplicationContext，从这个类上，我们就可以看到ApplicationContext与ResourceLoader之间的所有关系。AbstractApplicationContext继承了DefaultResourceLoader，那么，它的getResource(String)当然就直接用DefaultResourceLoader的了。剩下需要它“效劳”的，就是ResourcePatternResolver的Resource[]getResources (String)，当然，AbstractApplicationContext也不负众望，当即拿下。AbstractApplicationContext类的内部声明有一个resourcePatternResolver，类型是ResourcePatternResolver，对应的实例类型为PathMatchingResourcePatternResolver 。之前我们说过 PathMatchingResourcePatternResolver构造的时候会接受一个ResourceLoader，而AbstractApplicationContext本身又继承自DefaultResourceLoader，当然就直接把自身给“贡献”了。这样，整个ApplicationContext的实现类就完全可以支持ResourceLoader或者ResourcePatternResolver接口，你能说ApplicationContext不支持Spring的统一资源加载吗？说白了，ApplicationContext的实现类在作为ResourceLoader或者ResourcePatternResolver时候的行为，完全就是委派给了PathMatchingResourcePatternResolver和DefaultResourceLoader来做。图5-2给出了AbstractApplicationContext与ResourceLoader和ResourcePatternResolver之间的类层次关系。

有了这些做前提，让我们看看作为ResourceLoader或者ResourcePatternResolver的ApplicationContext，到底因此拥有了何等神通吧！

#### 1. 扮演ResourceLoader的角色

既然ApplicationContext可以作为ResourceLoader或者ResourcePatternResolver来使用，那么，很显然，我们可以通过ApplicationContext来加载任何Spring支持的Resource类型。与直接使用ResourceLoader来做这些事情相比，很明显，ApplicationContext的表现过于“谦虚”了。代码清单5-5演示的正是“大材小用”后的ApplicationContext。

代码清单5-5 以ResourceLoader身份登场的ApplicationContext

```java
ResourceLoader resourceLoader = new ClassPathXmlApplicationContext("配置文件路径"); 
// 或者
// ResourceLoader resourceLoader = new FileSystemXmlApplicationContext("配置文件路径"); 
Resource fileResource = resourceLoader.getResource("D:/spring21site/README"); 
assertTrue(fileResource instanceof ClassPathResource); 
assertFalse(fileResource.exists()); 
Resource urlResource2 = resourceLoader.getResource("http://www.spring21.cn"); 
assertTrue(urlResource2 instanceof UrlResource); 
```

我想这样的使用场景，你一定比我先猜到，不是吗？ 

#### 2. ResourceLoader类型的注入

在大部分情况下，如果某个bean需要依赖于ResourceLoader来查找定位资源，我们可以为其注入容器中声明的某个具体的ResourceLoader实现，该bean也无需实现任何接口，直接通过构造方法注入或者setter方法注入规则声明依赖即可，这样处理是比较合理的。不过，如果你不介意你的bean定义依赖于Spring的API，那不妨考虑用一下Spring提供的便利。

4.4.3节中曾经提到几个对ApplicationContext特定的Aware接口，这其中就包括ResourceLoaderAware和ApplicationContextAware接口。

假设我们有类定义如代码清单5-6所示。

代码清单5-6 依赖于ResourceLoader的实例类

```java
public class FooBar {

    private ResourceLoader resourceLoader;

    public void foo(String location) { 
        System.out.println(getResourceLoader().getResource(location).getClass()); 
    }

    public ResourceLoader getResourceLoader() { 
        return resourceLoader;  
    } 

    public void setResourceLoader(ResourceLoader resourceLoader) { 
        this.resourceLoader = resourceLoader; 
    } 
} 
```

该类出于什么目的要依赖于ResourceLoader，我们暂且不论，要为其注入什么样的Resource-Loader实例才是我们当下该操心的事情。姑且先给它注入DefaultResourceLoader。这样也就有了如下配置：

```xml
<bean id="resourceLoader" class="org.springframework.core.io.DefaultResourceLoader"> 
</bean> 
<bean id="fooBar" class="...FooBar"> 
  <property name="resourceLoader"> 
    <ref bean="resourceLoader"/> 
  </property>
</bean>
```

不过，ApplicationContext容器本身就是一个ResourceLoader，我们为了该类还需要单独提供一个resourceLoader实例就有些多于了，直接将当前的ApplicationContext容器作为ResourceLoader注入不就行了？而ResourceLoaderAware和ApplicationContextAware接口正好可以帮助我们做到这一点，只不过现在的FooBar需要依赖于Spring的API了。不过，在我看来，这没有什么大不了，因为我们从来也没有真正逃脱过依赖（这种依赖也好，那种依赖也罢）。

现在，修改我们的 FooBar 定义，让其实现 ResourceLoaderAware 或者 ApplicationContextAware接口，修改后的定义如代码清单5-7所示。

代码清单5-7 实现了ResourceLoaderAware或者ApplicationContextAware接口的实例类

```java
public class FooBar implements ResourceLoaderAware{ 
 private ResourceLoader resourceLoader; 

public void foo(String location) 
 { 
 System.out.println(getResourceLoader().getResource(location).getClass()); 
 } 
public ResourceLoader getResourceLoader() { 
 return resourceLoader; 
 } 
 public void setResourceLoader(ResourceLoader resourceLoader) { 
 this.resourceLoader = resourceLoader; 
 } 
} 
public class FooBar implements ApplicationContextAware{ 
 private ResourceLoader resourceLoader; 
 
 public void foo(String location) 
 { 
 System.out.println(getResourceLoader().getResource(location).getClass()); 
 } 
 public ResourceLoader getResourceLoader() { 
 return resourceLoader; 
 } 
 public void setApplicationContext(ApplicationContext ctx) throws BeansException { 
 this.resourceLoader = ctx; 
 } 
} 
```

剩下的就是直接将一个FooBar配置到bean定义文件即可，如下所示： 

```xml
<bean id="fooBar" class="...FooBar"> 
</bean>
```

哇，简洁多了不是嘛？现在，容器启动的时候，就会自动将当前ApplicationContext容器本身注入到FooBar中，因为ApplicationContext类型容器可以自动识别Aware接口。

当然，如果应用场景仅使用ResourceLoader类型即可满足需求，那么，还是使用ResourceLoaderAware比较合适，ApplicationContextAware相对来说过于宽泛了些（当然，使用也未尝不可）。

#### 3. Resource类型的注入

我们之前讲过，容器可以将bean定义文件中的字符串形式表达的信息，正确地转换成具体对象定义的依赖类型。对于那些Spring容器提供的默认的PropertyEditors无法识别的对象类型，我们可以提供自定义的PropertyEditor实现并注册到容器中，以供容器做类型转换的时候使用。默认情况下，BeanFactory容器不会为org.springframework.core.io.Resource类型提供相应的PropertyEditor，所以，如果我们想注入Resource类型的bean定义，就需要注册自定义的PropertyEditor到BeanFactory容器。不过，对于ApplicationContext来说，我们无需这么做，因为ApplicationContext容器可以正确识别Resource类型并转换后注入相关对象。

假设有一个XMailer类，它依赖于一个模板来提供邮件发送的内容，我们声明模板为Resource类型，那么，最终的XMailer定义也就如代码清单5-8所示。

代码清单5-8 依赖于Resource的XMailer类定义

```java
public class XMailer { 
 private Resource template; 
 public void sendMail(Map mailCtx) 
 { 
 // String mailContext = merge(getTemplate().getInputStream(),mailCtx); 
 //... 
 } 
 
 public Resource getTemplate() { 
 return template; 
 } 
 public void setTemplate(Resource template) { 
 this.template = template; 
 } 
}
```

该类定义与平常的bean定义没有什么差别，我们直接在配置文件中以String形式指定template所在位置，ApplicatonContext就可以正确地转换类型并注入依赖，配置内容如下： 

```xml
<bean id="mailer" class="...XMailer"> 
 <property name="template" value="..resources.default_template.vm"/> 
 ... 
</bean>
```

至于这里面的奥秘，估计你也猜个八九不离十了。

ApplicationContext启动伊始，会通过一个org.springframework.beans.support.ResourceEditorRegistrar来注册Spring提供的针对Resource类型的PropertyEditor实现到容器中，这个PropertyEditor叫 做 org.springframework.core.io.ResourceEditor。这样， ApplicationContext就可以正确地识别Resource类型的依赖了。至于ResourceEditor怎么实现我就不用说了吧？你想啊，把配置文件中的路径让ApplicationContext作为ResourceLoader给你定位一下不就得了。

> 注意 如果应用对象需要依赖一组Resource，与ApplicationContext注册了ResourceEditor类似， Spring 提供了 org.springframework.core.io.support.ResourceArrayPropertyEditor实现，我们只需要通过CustomEditorConfigurar告知容器即可。
{: .prompt-info }

#### 4. 在特定情况下，ApplicationContext的Resource加载行为

特定的ApplicationContext容器实现，在作为ResourceLoader加载资源时，会有其特定的行为。我们下面主要讨论两种类型的ApplicationContext容器，即ClassPathXmlApplicationContext和FileSystemXmlApplicationContext。其他类型的ApplicationContext容器，会在稍后章节中提到。

我们知道，对于URL所接受的资源路径来说，通常开始都会有一个协议前缀，比如file:、http:、ftp:等。既然Spring使用UrlResource对URL定位查找的资源进行了抽象，那么，同样也支持这样类型的资源路径，而且，在这个基础上，Spring还扩展了协议前缀的集合。ResourceLoader中增加了一种新的资源路径协议——classpath:，ResourcePatternResolver又增加了一种——classpath*:。这
样，我们就可以通过这些资源路径协议前缀，明确地告知Spring容器要从classpath中加载资源，如下所示：

```plaintext
// 代码中使用协议前缀
ResourceLoader resourceLoader = new FileSystemXmlApplicationContext("classpath:conf/container-conf.xml"); 
// 配置中使用协议前缀
<bean id="..." class="..."> 
 <property name="..."> 
 <value>classpath:resource/template.vm</value> 
 </property> 
</bean> 
```

classpath*:与classpath:的唯一区别就在于，如果能够在classpath中找到多个指定的资源，则返回多个。我们可以通过这两个前缀改变某些ApplicationContext实现类的默认资源加载行为。

ClassPathXmlApplicationContext和FileSystemXmlApplicationContext在处理资源加载的默认行为上有所不同。当ClassPathXmlApplicationContext在实例化的时候，即使没有指明classpath:或者classpath*:等前缀，它会默认从classpath中加载bean定义配置文件，以下代码中演示的两种实例化方式效果是相同的：

ApplicationContext ctx = new ClassPathXmlApplicationContext("conf/appContext.xml"); 

以及

ApplicationContext ctx = new ClassPathXmlApplicationContext("classpath:conf/appContext.xml"); 

而FileSystemXmlApplicationContext则有些不同，如果我们像如下代码那样指定conf/appContext.xml，它会尝试从文件系统中加载bean定义文件： 

ApplicationContext ctx = new FileSystemXmlApplicationContext("conf/appContext.xml"); 

不过，我们可以像如下代码所示，通过在资源路径之前增加classpath:前缀，明确指定FileSystemXmlApplicationContext从classpath中加载bean定义的配置文件： 

ApplicationContext ctx = new FileSystemXmlApplicationContext("classpath:conf/appContext.xml");

这时，FileSystemXmlApplicationContext就是从Classpath中加载配置，而不是从文件系统中加载。也就是说，它现在对应的是ClassPathResource类型的资源，而不是默认的FileSystemResource类型资源。FileSystemXmlApplicationContext之所以如此，是因为它与org.springframework.core.io.FileSystemResourceLoader一样，也覆写了DefaultResourceLoader的getResourceByPath(String)方法，逻辑跟 FileSystemResourceLoader一模一样。

当实例化相应的ApplicationContext时，各种实现会根据自身的特性，从不同的位置加载bean定义配置文件。当容器实例化并启动完毕，我们要用相应容器作为ResourceLoader来加载其他资源时，各种ApplicationContext容器的实现类依然会有不同的表现。

对于ClassPathXmlApplicationContext来说，如果我们不指定路径之前的前缀，它也不会像资源路径所表现的那样，从文件系统加载资源，而是像实例化时候的行为一样，从Classpath中加载这种没有路径前缀的资源。如类似如下指定的资源路径，ClassPathXmlApplicationContext依然尝试从Classpath加载：

```xml
<bean id="..." class="..."> 
 <property name="..." value="conf/appContext.xml"/> 
</bean> 
```

如果当前容器类型为FileSystemXmlApplicationContext，事情则会像预想的那样进行，FileSystemXmlApplicationContext将从文件系统中给我们加载该文件。但是，就跟实例化时可以通过classpath:前缀覆盖掉FileSystemXmlApplicationContext的默认加载行为一样，我们也可以在这个时候用classpath:前缀强制指定FileSystemXmlApplicationContext从Classpath中加载该文件，如以下代码所示：

```xml
<bean id="..." class="..."> 
 <property name="..." value="classpath:conf/appContext.xml"/> 
</bean> 
```

去掉配置中的classpath:前缀，FileSystemXmlApplicationContext默认从文件系统加载资源。

> 小心 即使在FileSystemXmlApplicationContext实例化启动时，通过classpath:前缀强制让它从Classpath中加载bean定义文件，但这也仅限于容器的实例化并加载bean定义文件这个特定阶段。容器实例化并启动后，作为ResourceLoader来加载资源，如果不是每个地方都使用classpath:前缀，强制 FileSystemXmlApplicationContext从 Classpath 中加载资源，FileSystemXmlApplicationContext还会默认从文件系统中加载资源。
{: .prompt-warning }

如果细化下去，这部分内容还有许多，如通配符加载的行为、FileSystemResource的特定行为等。这里不做赘述，更多相关特性，请参照Spring参考文档。