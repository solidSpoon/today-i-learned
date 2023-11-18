# Controller私有方法可能造成的问题

前言
--

前几日，有朋友分享了这样一个案例：

> 原来的项目一直都正常运行，突然有一天发现代码部分功能报错。经过排查，发现`Controller`里部分方法为`private`的，原来是同事为`Controller`添加了AOP日志功能，导致原来的方法报错。

当然了，解决方案就是把`private`修饰的方法改为`public`，一切就都正常了。

首先要说明的是，`Controller` 中的 private 方法上加上 `@RequestMapping` 注解是生效的，因为具体的机制是反射调用，具体的原因详见官方讨论

> https://github.com/spring-projects/spring-framework/issues/21417

不过前文的报错究竟是为什么呢？如果你也说不太清楚，就跟着笔者一起来探探究竟。

一、SpringBoot添加AOP
-----------------

我们先为SpringBoot项目添加一个切面功能。

在这里，笔者的SpringBoot的版本为`2.1.5.RELEASE`，对应的Spring版本为`5.1.7.RELEASE`。

我们必须要先添加AOP的依赖：

```xml
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-aop</artifactId>
</dependency>
复制代码
```

然后来定义一个切面，来拦截`Controller`中的所有方法：

```java
@Component
@Aspect
public class ControllerAspect {

    @Pointcut(value = "execution(* com.viewscenes.controller..*.*(..))")
    public void pointcut(){}

    @Before("pointcut()")
    public void before(JoinPoint joinPoint){
        System.out.println("前置通知");
    }
    @After("pointcut()")
    public void after(JoinPoint joinPoint){
        System.out.println("后置通知");
    }
    @AfterReturning(pointcut="pointcut()",returning = "result")
    public void result(JoinPoint joinPoint,Object result){
        System.out.println("返回通知:"+result);
    }
}
复制代码
```

然后写一个`Controller`:

```java
@RestController
public class UserController {

    @Autowired
    UserService userService;
    
    @RequestMapping("/list")
    public List<User> list() {
        return userService.list();
    }
}
复制代码
```

好了，现在访问`/list`方法，AOP就已经正常工作了。

```bash
前置通知
后置通知
返回通知:
[
User(id=59ffbdca-6b50-4466-936d-dddd693aa96b, name=0), 
User(id=ff600c29-2013-493a-aab1-e66329251666, name=1), 
User(id=85527844-bb3d-4cd3-98a1-786f0f754a98, name=2)
]
复制代码
```

二、CGLIB原理
---------

首先，我们要知道的是，在`SpringBoot`中，默认使用的就是`CGLIB`方式来创建代理。

在它的配置文件中，`spring.aop.proxy-target-class`默认是true。

```yaml
{
  "name": "spring.aop.proxy-target-class",
  "type": "java.lang.Boolean",
  "description": "Whether subclass-based (CGLIB) proxies are to be created (true), 
	as opposed to standard Java interface-based proxies (false).",
  "defaultValue": true
}
```

然后再回顾下CGLIB的原理:

> 动态生成一个要代理类的子类，子类重写要代理的类的所有不是final的方法。在子类中采用方法拦截的技术拦截所有父类方法的调用，顺势织入横切逻辑。它比使用java反射的JDK动态代理要快。

我们看到，CGLIB代理的重要条件是生成一个子类，然后重写要代理类的方法。

下面我们看看`CGLIB`最基础的应用。

假如我们有一个`Student`类，它有一个`eat()`方法。

```java
public class Student {

    public void eat(String name) {
        System.out.println(name+"正在吃饭...");
    }
}
```

然后，创建一个拦截器，在`CGLIB`中，它是一个回调函数。

```java
public class TargetInterceptor implements MethodInterceptor {
    @Override
    public Object intercept(Object obj, Method method, 
		Object[] params, MethodProxy proxy) throws Throwable {
        System.out.println("调用前");
        Object result = proxy.invokeSuper(obj, params);
        System.out.println("调用后");
        return result;
    }
}
```

然后我们测试它：

```java
public static void main(String[] args){

	//创建字节码增强器
	Enhancer enhancer =new Enhancer();
	//设置父类
	enhancer.setSuperclass(Student.class);
	//设置回调函数
	enhancer.setCallback(new TargetInterceptor());
	//创建代理类
	Student student=(Student)enhancer.create();
	student.eat("王二杆子");
}
```

这样就完成了通过`CGLIB对Student`类的代理。

上面代码中的`Student`就是通过`CGLIB`创建的代理类，它的Class对象如下：

`class com.viewscenes.test.Student?EnhancerByCGLIB?121a496f`

既然`CGLIB`是通过生成子类的方式来创建代理，那么它生成的子类就要继承父类咯。

关于Java中的继承，有一条很重要的特性就是：

*   子类拥有父类非 private 的属性、方法。

看到这里，也许你已经明白了一大半，不过咱们继续看。如果照这样说法，如果父类中有`private`方法，生成的代理类中是看不到的。

上面的`Student`类中，学生不仅要吃饭，也许还会偷偷睡觉，那我们给它加一个私有方法：

```java
public class Student {

    public void eat(String name) {
        System.out.println(name+"正在吃饭...");
    }
    private void sleep(String name){
        System.out.println(name+"正在偷偷睡觉...");
    }
}
```

不过，怎么测试呢？这私有方法在外面也调用不到呀。没关系，我们用反射来试验：

```java
//创建代理类
Student student=(Student)enhancer.create();
    
Method eat = student.getClass().getMethod("eat", String.class);
eat.invoke(student,"王二杆子");

Method sleep = student.getClass().getMethod("sleep", String.class);
sleep.invoke(student,"王二杆子");
```

输出结果如下：

```bash
调用前
王二杆子正在吃饭...
调用后
Exception in thread "main" java.lang.NoSuchMethodException: com.viewscenes.test.Student$$EnhancerByCGLIB$$121a496f.sleep(java.lang.String)
	at java.lang.Class.getMethod(Class.java:1786)
	at com.viewscenes.test.Test.main(Test.java:23)
```

很明显，在调用`sleep`方法的时候，抛出了`java.lang.NoSuchMethodException`异常。

至此，我们更加确定了一件事：

**由`CGLIB`创建的代理类，不会包含父类中的私有方法。** 

三、为啥其他属性无法注入
------------

我们看完了上面的测试，现在把`Controller`中的方法也改成`private`。

再访问的时候，会报出`java.lang.NullPointerException`异常，是因为`UserService为null`，没有成功注入。

这就不太对了呀？如果说因为私有方法的原因，导致代理类不会包含此方法的话，那么最多AOP不会生效，为什么`UserService`也没有注入进来呢？

带着这个问题，笔者又翻了翻`Spring aop`相关的源码，这才理解咋回事。

在这里，我们首先要记住一件事：不管方法是否为私有的，`UserController`这个Bean是已经确定被代理了的。

#### 1、SpringMVC处理请求

我们的一个HTTP请求，会先经过`SpringMVC中的DispatcherServlet`，然后找到与之对应的`HandlerMethod`来处理。在后面，会先通过Spring的参数解析器，把Request参数解析出来，最后通过`Method`来调用方法。

![](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/16b4fb035b20906b~tplv-t2oaga2asx-zoom-in-crop-mark:1304:0:0:0.awebp)

#### 2、反射调用

![](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/16b4fbe2140f2807~tplv-t2oaga2asx-zoom-in-crop-mark:1304:0:0:0.awebp)

上面代码就是通过反射来调用`Controller`中的方法。

上面我们说：

> 不管方法是否为私有的，`UserController`这个Bean是已经确定被代理了的。

在这里，`this.getBean()`拿到的就是被代理后的对象。它长这样：

![](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/16b4fc8c4f325093~tplv-t2oaga2asx-zoom-in-crop-mark:1304:0:0:0.awebp)

可以看到，在这个代理对象中，`userService`对象为NULL。那么，按理说，不管你方法是否为私有的，这样直接调用也都是要报空指针异常的呀。那么，为啥只有私有方法才会报错，而公共方法不会呢？

#### 3、有啥不一样

在这里，他们的`method`是一样的，都是`java.lang.reflect`包中的对象。

如果是私有方法，那么在代理类中，不会包含这个方法。此时通过`Method.invoke()`来调用目标方法，传入的实例对象是`userController`的代理类，而这个代理类中的`userService`为NULL，所以，执行的时候，才会看到`userService`没有注入，导致空指针异常。

如果是公共方法，在代理类中，就有它的子类实现，则会先调用到代理类的拦截器`MethodInterceptor`。拦截器负责链式调用AOP方法和目标方法。在拦截器执行过程中，又调用了方法。但不同的是，此时传入的实例对象并不是代理类，而是代理类的目标对象。

![](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/16b4fe070f27b080~tplv-t2oaga2asx-zoom-in-crop-mark:1304:0:0:0.awebp)

有朋友对这块不理解，其实就是JDK中`java.lang.reflect.Method`的内容，来借助测试再看一下。

还是拿上面的`Student`为例，我们通过`Method`来获取它的方法并调用。

```java
//创建代理类
Student student=(Student)enhancer.create();

Method eat = Student.class.getDeclaredMethod("eat", String.class);
eat.setAccessible(true);
eat.invoke(student,"王二杆子");

System.out.println("----------------------");
Method sleep = Student.class.getDeclaredMethod("sleep", String.class);
sleep.setAccessible(true);
sleep.invoke(student,"王二杆子");
```

上面的代码中，先通过反射拿到`Method`对象，其中eat是公共方法，sleep是私有方法。invoke传入的对象都是通过`CGLIB`生成的代理对象，结果就是eat执行了代理，而sleep并没有。

```bash
调用前
王二杆子正在吃饭...
调用后
----------------------
王二杆子正在偷偷睡觉...
复制代码
```

这也就解释了，为啥同样是调用`method.invoke()`，私有方法没有注入成功，而公共方法正常。

四、JDK代理
-------

既然说，`CGLIB`是通过继承的方式实现代理。那私有方法能不能通过`JDK动态代理`的方式来呢？

不瞒各位，笔者当时确实想到了这个，不过马上被右脑打脸。JDK动态代理是通过接口来的，接口里怎么可能有私有方法？

哈哈，看来此路不通。不过笔者却发现了另外一个有意思的现象。

至此，我们不再讨论公有私有方法的问题，仅仅看`Controller`是否可以改为`JDK动态代理`的方式。

#### 1、改为jdk动态代理

首先，我们需要在配置文件中，设置`spring.aop.proxy-target-class=false`

然后还需要搞一个接口，这个接口还必须包含一个方法。否则`Spring`在生成代理的时候，还会判断，如果不包含这些条件，还会是`CGLIB`的代理方式。

```java
public interface BaseController {
    default void print(){
        System.out.println("-------------");
    }
}
复制代码
```

然后让我们的`Controller`实现这个接口就行了。现在代理方式就变成了`JDK动态代理`。

ok，现在访问`/list`，你会得到一个友好的404提示：

```json
{
    "status": 404,
    "error": "Not Found",
    "message": "No message available",
    "path": "/list"
}
```

#### 2、为何404？

这是为啥捏？

在`SpringMVC`初始化的时候，会先遍历所有的`Bean`，过滤包含`Controller`注解和`RequestMapping`注解的类，然后查找类上的方法，获取方法上的URL。最后把URL和方法的映射注册到容器。

如果你对这一过程不理解，可以参阅笔者文章 - [Spring源码分析（四）SpringMVC初始化](https://juejin.cn/post/6844903783558823950 "https://juejin.cn/post/6844903783558823950")

在过滤的时候，大概有三个条件：

*   对象本身是否包含`Controller`相关注解
*   对象的父类是否包含`Controller`相关注解
*   对象的接口是否包含`Controller`相关注解

此时我们的`userController`是一个JDK的代理对象，这三条件都不满足呀，所以Spring认为它并不是一个`Controller`。

因此，我们需要在它接口`BaseController`上添加一个`@RestController`注解才行。

加完之后，过滤条件满足了。`SpringMVC`终于认识它是一个`Controller`了。不过，如果你现在去访问，还会得到一个404。

#### 3、为何还是404？

笔者当时也是崩溃的，为啥还是404呢？

```java
if (beanType != null && this.isHandler(beanType)) {
	this.detectHandlerMethods(beanName);
}
```

原来通过`isHandler`条件判断之后，还需要通过`detectHandlerMethods`检测bean上的方法，注册url和对象method的映射关系。

但是这里有个坑~

我们知道，不管是`JDK动态代理`还是`CGLIB动态代理`，此时的bean都是代理对象。检测bean上的方法，一定得检测真实的目标对象才有意义。

Spring也正是这样做的，它通过`ClassUtils.getUserClass(handlerType);`来获取真实对象。

然后看到这段代码的时候，才发现：

![](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/16b500a75708cc9d~tplv-t2oaga2asx-zoom-in-crop-mark:1304:0:0:0.awebp)

这里只处理了`CGLIB`代理的情况。。换言之，如果是JDK的代理对象，这里返回的还是代理对象。

那么在外层，拿着这个代理对象去`selectMethods`查找方法，当然一无所获。最后的结果就是，没有把这个url和对象method映射起来，当我们访问`/list`的时候，会报出404。

这里的SpringMVC版本为`5.1.7.RELEASE`，不知道其他版本是不是也是这样处理的。欢迎探讨~

总结
--

以前老听一些人说，在Controller里面不要用私有方法，也知道可能会产生问题。

但具体会产生哪些问题？产生问题的根源在哪里？却一直很朦胧，通过本文也许你对这个问题就有了更新的认识。

---
https://juejin.cn/post/6844903865163186189