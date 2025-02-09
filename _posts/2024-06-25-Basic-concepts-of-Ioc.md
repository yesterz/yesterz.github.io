
## 2.1 让别人为你服务 

IoC是随着近年来轻量级容器（Lightweight Container)的兴起而逐渐被很多人提起的一个名词，它的全称为Inversion of Control，中文通常翻译为“控制反转”，它还有一个别名叫做依赖注入（Dependency Injection）。好莱坞原则“Don’t call us, we will call you.”恰如其分地表达了“反转”的意味，是用来形容IoC最多的一句话。那么，为什么需要IoC？IoC的具体意义是什么？它到底有什么独到之处？让我们带着这些疑问开始我们的IoC之旅吧。

为了更好地阐述IoC模式的概念，我们引入以下简单场景。

在我经历的FX项目中，经常需要近乎实时地为客户提供外汇新闻。通常情况下，都是先从不同的新闻社订阅新闻来源，然后通过批处理程序定时地到指定的新闻服务器抓取最新的外汇新闻，接着将这些新闻存入本地数据库，最后在FX系统的前台界面显示。

假设我们有一个FXNewsProvider类来做以上工作，其代码如代码清单2-1所示。

代码清单2-1 FXNewsProvider类的实现

```java
public class FXNewsProvider {
    private IFXNewsListener newsListener;
    private IFXNewsPersister newPersistener;

    public void getAndPersistNews() {
        String[] newsIds = newsListener.getAvailableNewsIds();
        if (ArrayUtils.isEmpty(newsIds)) {
            return;
        }

        for (String newsId : newsIds) {
            FXNewsBean newsBean = newsListener.getNewsByPK(newsId);
            newPersistener.persistNews(newsBean);
            newsListener.postProcessIfNecessary(newsId);
        }
    }
}
```

其中，FXNewsProvider需要依赖IFXNewsListener来帮助抓取新闻内容，并依赖IFXNewsPersister存储抓取的新闻。

假设默认使用道琼斯（Dow Jones）新闻社的新闻，那么我们相应地提供了DowJonesNewsListener和DowJonesNewsPersister两个实现。通常情况下，需要在构造函数中构造IFXNewsProvider依赖的这两个类（以下将这种被其他类依赖的类或对象，简称为“依赖类”、“依赖对象”），如代码清单2-2所示。
代码清单2-2 构造IFXNewsProvider类的依赖类

```java
public FXNewsProvider() { 
    newsListener = new DowJonesNewsListener(); 
    newPersistener = new DowJonesNewsPersister(); 
}
```

看，这就是我们通常的做事方式！如果我们依赖于某个类或服务，最简单而有效的方式就是直接在类的构造函数中新建相应的依赖类。这就好比要装修新房，需要用家具，这个时候，根据通常解决对象依赖关系的做法，我们就会直接打造出需要的家具来。不过，通常都是分工明确的，所以，大多数情况下，我们可以去家具广场将家具买回来，然后根据需要装修布置即可。

不管是直接打造家具（通过new构造对象），还是去家具广场买家具（或许是通过Service-Locator解决直接的依赖耦合），有一个共同点需要我们关注，那就是，我们都是自己主动地去获取依赖的对象！

可是回头想想，我们自己每次用到什么依赖对象都要主动地去获取，这是否真的必要？我们最终所要做的，其实就是直接调用依赖对象所提供的某项服务而已。只要用到这个依赖对象的时候，它能够准备就绪，我们完全可以不管这个对象是自己找来的还是别人送过来的。对于FXNewsProvider来说，那就是在getAndPersistNews()方法调用newsListener的相应方法时，newsListener能够准备就绪就可以了。如果有人能够在我们需要时将某个依赖对象送过来，为什么还要大费周折地自己去折腾？

实际上，IoC就是为了帮助我们避免之前的“大费周折”，而提供了更加轻松简洁的方式。它的反转，就反转在让你从原来的事必躬亲，转变为现在的享受服务。你想啊，原来还得鞍马劳顿，什么东西都得自己去拿。现在是用什么，让别人直接送过来就成。所以，简单点儿说，IoC的理念就是，让别人为你服务！也就是让IoC Service Provider来为你服务！

通常情况下，被注入对象会直接依赖于被依赖对象。但是，在IoC的场景中，二者之间通过IoC Service Provider来打交道，所有的被注入对象和依赖对象现在由IoC Service Provider统一管理。被注入对象需要什么，直接跟IoC Service Provider招呼一声，后者就会把相应的被依赖对象注入到被注入对象中，从而达到IoC Service Provider为被注入对象服务的目的。IoC Service Provider在这里就是通常的IoC容器所充当的角色。从被注入对象的角度看，与之前直接寻求依赖对象相比，依赖对象的取得方式发生了反转，控制也从被注入对象转到了IoC Service Provider那里。

其实IoC就这么简单！原来是需要什么东西自己去拿，现在是需要什么东西就让别人送过来。

出门之前得先穿件外套吧？以前，你得自己跑到衣柜前面取出衣服这一依赖对象，然后自己穿上再出门。而现在，你只要跟你的“另一半”使个眼色或说一句“Honey，衣服拿来。”她就会心领神会地到衣柜那里为你取出衣服，然后再给你穿上。现在，你就可以出门了。（此时此刻，你心里肯定窃喜，“有人照顾的感觉真好！”）对你来说，到底哪种场景比较惬意，我想已经不言自明了吧？

## 2.2 三种依赖注入

“伙计，来杯啤酒！”当你来到酒吧，想要喝杯啤酒的时候，通常会直接招呼服务生，让他为你送来一杯清凉解渴的啤酒。同样地，作为被注入对象，要想让IoC Service Provider为其提供服务，并将所需要的被依赖对象送过来，也需要通过某种方式通知对方。

* 如果你是酒吧的常客，或许你刚坐好，服务生已经将你最常喝的啤酒放到了你面前；

* 如果你是初次或偶尔光顾，也许你坐下之后还要招呼服务生，“Waiter,Tsingdao, please.”；

* 还有一种可能，你根本就不知道哪个牌子是哪个牌子，这时，你只能打手势或干脆画出商标图来告诉服务生你到底想要什么了吧！

不管怎样，你终究会找到一种方式来向服务生表达你的需求，以便他为你提供适当的服务。那么，在IoC模式中，被注入对象又是通过哪些方式来通知IoC Service Provider为其提供适当服务的呢？

IoC模式最权威的总结和解释，应该是Martin Fowler的那篇文章“Inversion of Control Containers and the Dependency Injection pattern”，其中提到了三种依赖注入的方式，即构造方法注入（constructor injection）、setter方法注入（setter injection）以及接口注入（interface injection）。下面让我们详细看一下这三种方式的特点及其相互之间的差别。

### 2.2.1 构造方法注入

顾名思义，构造方法注入，就是被注入对象可以通过在其构造方法中声明依赖对象的参数列表，让外部（通常是IoC容器）知道它需要哪些依赖对象。对于前面例子中的FXNewsProvider来说，只要声明如下构造方法（见代码清单2-3）即可支持构造方法注入。

代码清单2-3 FXNewsProvider构造方法定义

```java
public FXNewsProvider(IFXNewsListener newsListener, IFXNewsPersister newsPersister) {
    this.newsListener = newsListener;
    this.newPersistener = newsPersister;
}
```

IoC Service Provider会检查被注入对象的构造方法，取得它所需要的依赖对象列表，进而为其注入相应的对象。同一个对象是不可能被构造两次的，因此，被注入对象的构造乃至其整个生命周期，应该是由IoC Service Provider来管理的。

构造方法注入方式比较直观，对象被构造完成后，即进入就绪状态，可以马上使用。这就好比你刚进酒吧的门，服务生已经将你喜欢的啤酒摆上了桌面一样。坐下就可马上享受一份清凉与惬意。

### 2.2.2 setter方法注入

对于JavaBean对象来说，通常会通过setXXX()和getXXX()方法来访问对应属性。这些setXXX()方法统称为setter方法，getXXX()当然就称为getter方法。通过setter方法，可以更改相应的对象属性，通过getter方法，可以获得相应属性的状态。所以，当前对象只要为其依赖对象所对应的属性添加setter方法，就可以通过setter方法将相应的依赖对象设置到被注入对象中。以FXNewsProvider为例，添加setter方法后如代码清单2-4所示。

代码清单2-4 添加了setter方法声明的FXNewsProvider

```java
public class FXNewsProvider {
    private IFXNewsListener newsListener;
    private IFXNewsPersister newPersistener;

    public IFXNewsListener getNewsListener() {
        return newsListener;
    }

    public void setNewsListener(IFXNewsListener newsListener) {
        this.newsListener = newsListener;
    }

    public IFXNewsPersister getNewPersistener() {
        return newPersistener;
    }

    public void setNewPersistener(IFXNewsPersister newPersistener) {
        this.newPersistener = newPersistener;
    }
}
```

这样，外界就可以通过调用setNewsListener和setNewPersistener方法为FXNewsProvider对象注入所依赖的对象了。

setter方法注入虽不像构造方法注入那样，让对象构造完成后即可使用，但相对来说更宽松一些，可以在对象构造完成后再注入。这就好比你可以到酒吧坐下后再决定要点什么啤酒，可以要百威，也可以要大雪，随意性比较强。如果你不急着喝，这种方式当然是最适合你的。

### 2.2.3 接口注入

相对于前两种注入方式来说，接口注入没有那么简单明了。被注入对象如果想要IoC Service Provider为其注入依赖对象，就必须实现某个接口。这个接口提供一个方法，用来为其注入依赖对象。IoC Service Provider最终通过这些接口来了解应该为被注入对象注入什么依赖对象。

FXNewsProvider为了让IoC Service Provider为其注入所依赖的IFXNewsListener，首先需要实现IFXNewsListenerCallable接口，这个接口会声明一个injectNewsListner方法（方法名随意），该方法的参数，就是所依赖对象的类型。这样，InjectionServiceContainer对象，即对应的IoC Service Provider就可以通过这个接口方法将依赖对象注入到被注入对象FXNewsProvider当中。

接口注入方式最早并且使用最多的是在一个叫做Avalon的项目中，相对于前两种依赖注入方式，接口注入比较死板和烦琐。如果需要注入依赖对象，被注入对象就必须声明和实现另外的接口。这就好像你同样在酒吧点啤酒，为了让服务生理解你的意思，你就必须戴上一顶啤酒杯式的帽子，看起来有点多此一举。

通常情况下，这有些让人不好接受。不过，好在这种方式也可以达到目的。

### 2.2.4 三种注入方式的比较

* 接口注入。从注入方式的使用上来说，接口注入是现在不甚提倡的一种方式，基本处于“退役状态”。因为它强制被注入对象实现不必要的接口，带有侵入性。而构造方法注入和setter方法注入则不需要如此。

* 构造方法注入。这种注入方式的优点就是，对象在构造完成之后，即已进入就绪状态，可以马上使用。缺点就是，当依赖对象比较多的时候，构造方法的参数列表会比较长。而通过反射构造对象的时候，对相同类型的参数的处理会比较困难，维护和使用上也比较麻烦。而且在Java中，构造方法无法被继承，无法设置默认值。对于非必须的依赖处理，可能需要引入多个构造方法，而参数数量的变动可能造成维护上的不便。

* setter方法注入。因为方法可以命名，所以setter方法注入在描述性上要比构造方法注入好一些。另外，setter方法可以被继承，允许设置默认值，而且有良好的IDE支持。缺点当然就是对象无法在构造完成后马上进入就绪状态。

综上所述，构造方法注入和setter方法注入因为其侵入性较弱，且易于理解和使用，所以是现在使用最多的注入方式；而接口注入因为侵入性较强，近年来已经不流行了。

## 2.3 IoC 的附加值

从主动获取依赖关系的方式转向IoC方式，不只是一个方向上的改变，简单的转变背后实际上蕴藏着更多的玄机。要说IoC模式能带给我们什么好处，可能各种资料或书籍中已经罗列很多了。比如不会对业务对象构成很强的侵入性，使用IoC后，对象具有更好的可测试性、可重用性和可扩展性，等等。不过，泛泛而谈可能无法真正地让你深刻理解IoC模式带来的诸多好处，所以，还是让我们从具体的示例入手，来一探究竟吧。

对于前面例子中的FXNewsProvider来说，在使用IoC重构之前，如果没有其他需求或变动，不光看起来，用起来也是没有问题的。但是，当系统中需要追加逻辑以处理另一家新闻社的新闻来源时，问题就来了。

突然有一天，客户告诉你，我们又搞定一家新闻社，现在可以使用他们的新闻服务了，这家新闻社叫MarketWin24。这个时候，你该如何处理呢？首先，毫无疑问地，应该先根据MarketWin24的服务接口提供一个MarketWin24NewsListener实现，用来接收新闻；其次，因为都是相同的数据访问逻辑，所以原来的DowJonesNewsPersister可以重用，我们先放在一边不管。最后，就主要是业务处理对象FXNewsProvider了。因为我们之前没有用IoC，所以，现在的对象跟DowJonesNewsListener是绑定的，我们无法重用这个类了，不是吗？为了解决问题，我们可能要重新实现一个继承自FXNewsProvider的MarketWin24NewsProvider，或者干脆重新写一个类似的功能。

而使用IoC后，面对同样的需求，我们却完全可以不做任何改动，就直接使用FXNewsProvider。因为不管是DowJones还是MarketWin24，对于我们的系统来说，处理逻辑实际上应该是一样的：根据各个公司的连接接口取得新闻，然后将取得的新闻存入数据库。因此，我们只要根据MarketWin24的新闻服务接口，为MarketWin24的FXNewsProvider提供相应的MarketWin24NewsListener注入就可以了，见代码清单2-5。

代码清单2-5 构建在IoC之上可重用的FXNewsProvider使用演示

```java
FXNewsProvider dowJonesNewsProvider = new FXNewsProvider(new DowJonesNewsListener(),new DowJonesNewsPersister());
// ... 
FXNewsPrivider marketWin24NewsProvider = new FXNewsProvider(new MarketWin24NewsListener(),new DowJonesNewsPersister());
// ... 
```

看！使用IoC之后，FXNewsProvider可以重用，而不必因为添加新闻来源去重新实现新的FXNewsProvider。实际上，只需要给出特定的IFXNewsListener实现即可。

随着开源项目的成功，TDD（Test Driven Developement ，测试驱动开发）已经成为越来越受重视的一种开发方式。因为保证业务对象拥有良好的可测试性，可以为最终交付高质量的软件奠定良好的基础，同时也拉起了产品质量的第一道安全网。所以对于软件开发来说，设计开发可测试性良好的业务对象是至关重要的。而IoC模式可以让我们更容易达到这个目的。比如，使用IoC模式后，为了测试FXNewsProvider，我们可以根据测试的需求，提供一个MockNewsListener给FXNewsProvider。在此之前，我们无法将对DowJonesNewsListener的依赖排除在外，从而导致难以开展单元测试。而现在，单元测试则可以毫无牵绊地进行，代码清单2-6演示了测试取得新闻失败的情形。

代码清单2-6 测试FXNewsProvider类的相关定义

```java
/**
 * Mock implementation of IFXNewsListener for testing news retrieval failure scenarios
 */
public class MockNewsListener implements IFXNewsListener {
    
    @Override
    public String[] getAvailableNewsIds() {
        throw new FXNewsRetrieveFailureException();
    }
    
    @Override
    public FXNewsBean getNewsByPK(String newsId) {
        // TODO: Implement mock behavior for getting news by primary key
        return null;
    }
    
    @Override
    public void postProcessIfNecessary(String newsId) {
        // TODO: Implement mock post-processing behavior
    }
}

/**
 * Test class for FXNewsProvider
 */
public class FXNewsProviderTest extends TestCase {
    
    private FXNewsProvider newsProvider;
    
    @Override 
    protected void setUp() throws Exception {
        super.setUp();
        newsProvider = new FXNewsProvider(
            new MockNewsListener(),
            new MockNewsPersister()
        );
    }
    
    @Override 
    protected void tearDown() throws Exception {
        super.tearDown();
        newsProvider = null;
    }
    
    /**
     * Test case to verify behavior when news resources are not available
     */
    public void testGetAndPersistNewsWithoutResourceAvailable() {
        try {
            newsProvider.getAndPersistNews();
            fail("Since MockNewsListener has no news support, we should fail to get above.");
        } catch (FXNewsRetrieveFailureException e) {
            // TODO: Add verification steps
        }
    }
}
```

由此可见，相关资料或书籍提到IoC总会赞不绝口，并不是没有原因的。如果你还心存疑虑，那么自己去验证一下吧！说不定你还可以收获更多。毕竟，实践出真知嘛。

如果要用一句话来概括IoC可以带给我们什么，那么我希望是，IoC是一种可以帮助我们解耦各业务对象间依赖关系的对象绑定方式！

## 2.4 小结

本章主要介绍了IoC或者说依赖注入的概念，讨论了几种基本的依赖注入方式。还与大家一起探索并验证了IoC所带给我们的部分“附加值”。所以，现在大家应该对IoC或者说依赖注入有了最基本认识。下一章，我们将一起去更深入地了解IoC场景中的重要角色，即IoC Service Provider。