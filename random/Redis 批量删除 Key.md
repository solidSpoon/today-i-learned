## 普通删除

```bash
DEL key1 key2 key3
```

## 管道

可用`keys "str*"` 列出要删除的key，接linux管道删除（linux[命令行](https://so.csdn.net/so/search?q=%E5%91%BD%E4%BB%A4%E8%A1%8C&spm=1001.2101.3001.7020)执行）

**实例：**

根据通配符查看待删除的key

```bash
redis-cli KEYS "*_MALL_GOODS_KEY”
```

接linux管道删除之

```bash
redis-cli KEYS "*_MALL_GOODS_KEY*"|xargs redis-cli DEL
```

## lua 删除

`keys *` 命令在数据量很大的情况下，直接在 redis cli 中执行会严重影响服务器性能，更好的方式是在 lua 脚本中执行

`eval` 命令可以执行执行 lua 脚本

lua方式通配符查找

```bash
eval "return redis.call('keys',KEYS[1])" 1 *_MALL_GOODS_KEY*
```

```bash
eval "return redis.call('keys',KEYS[1])" 1 *
```

lua 方式通配符删除

```bash
eval "return redis.call('del',unpack(redis.call('keys',ARGV[1])))" 0 *_MALL_GOODS_KEY*
```

---
https://blog.csdn.net/weixin_44018338/article/details/99461057