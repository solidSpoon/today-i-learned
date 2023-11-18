Spring 的事务管理器一般继承自

```java
org.springframework.transaction.PlatformTransactionManager
```

通过自动注入找到事务管理器

```java
@Resource
private PlatformTransactionManager ptm;
```

打印日志或者 debug 即可找道对应的事务管理器

```java
log.info("tm:{}", ptm);
```

根据事务管理器在配置文件中添加配置

```yaml
logging:  
  level:  
    org:  
      springframework:  
        jdbc:  
          datasource:  
            DataSourceTransactionManager: DEBUG
```

之后在日志中会打印事务信息