# Redis 使用场景 -1. 业务数据缓存 *

经典用法。
1、通用数据缓存，string，int，list，map 等。
2、实时热数据，最新 500 条数据。
3、会话缓存，token 缓存等。

# Redis 使用场景 -2. 业务数据处理

1、非严格一致性要求的数据：评论，点击等。
2、业务数据去重：订单处理的幂等校验等。
3、业务数据排序：排名，排行榜等。

# Redis 使用场景 -3. 全局一致计数 *

1、全局流控计数
2、秒杀的库存计算
3、抢红包
4、全局 ID 生成

# Redis 使用场景 -4. 高效统计计数

1、id 去重，记录访问 ip 等全局 bitmap 操作
2、UV、PV 等访问量 ==> 非严格一致性要求

# Redis 使用场景 -5. 发布订阅与 Stream

1、Pub-Sub 模拟队列
subscribe comments
publish comments java

2、Redis Stream 是 Redis 5.0 版本新增加的数据结构。
Redis Stream 主要用于消息队列（MQ，Message Queue）。
具体可以参考 [https://www.runoob.com/redis/redis-stream.html](https://www.runoob.com/redis/redis-stream.html)
![|300](https://cdn.nlark.com/yuque/0/2021/jpeg/1548042/1611075208352-7966b6ce-7a78-4191-b008-1188763eb3ff.jpeg)
![](https://cdn.nlark.com/yuque/0/2021/jpeg/1548042/1611075230999-0b88f1e2-deae-46b2-a09b-44ad21647bef.jpeg)

# Redis 使用场景 -6. 分布式锁 *

1、获取锁 -- 单个原子性操作

```bash
SET dlock my_random_value NX PX 30000
```

- EX second ：设置键的过期时间为 second 秒。 SET key value EX second 效果等同于 SETEX key second value 。
- PX millisecond ：设置键的过期时间为 millisecond 毫秒。 SET key value PX millisecond 效果等同于 PSETEX key millisecond value 。
- NX ：只在键不存在时，才对键进行设置操作。 SET key value NX 效果等同于 SETNX key value 。
- XX ：只在键已经存在时，才对键进行设置操作。

> [http://doc.redisfans.com/string/set.html](http://doc.redisfans.com/string/set.html)

2、释放锁 --lua 脚本 - 保证原子性 + 单线程，从而具有事务性

```lua
if redis.call("get",KEYS[1]) == ARGV[1] then
    return redis.call("del",KEYS[1])
else
    return 0
end
```

关键点：原子性、互斥、超时

