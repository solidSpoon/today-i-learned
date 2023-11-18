# Java 接口嵌套

> 问题来自设计模式之美第八课评论区

Java 接口中可以定义

- 静态方法
- default方法
- 枚举类型
- 接口（嵌套）

有一个接口如下：

```java
public interface ILog {
    enum Type {
        LOW,
        MEDIUM,
        HIGH
    }

    void info(String content);

    interface InILog{
        void initInLog();
    }

    default void init() {
        Type t = Type.LOW;
        System.out.println(t.ordinal());
    }
}
```

实现该接口时不必实现内部接口

```java
public class LogImpl implements ILog{

    @Override
    public void info(String content) {
        //...
    }
}
```

指定实现内部接口

```java
public class LogImpl implements ILog.InILog{

    @Override
    public void initInLog() {
        //...
    }
}
```

```java
public class LogImpl implements ILog, ILog.InILog{

    @Override
    public void info(String content) {
        //...
    }

    @Override
    public void initInLog() {
        //...
    }
}
```