1、`left(name,4)` 截取左边的4个字符 

列：

```sql
SELECT LEFT(201809,4) 年
```

结果：2018

2、`right(name,2)` 截取右边的2个字符

```sql
SELECT RIGHT(201809,2) 月份
```

结果：09

3、`SUBSTRING(name,5,3)` 截取name这个字段 从第五个字符开始 只截取之后的3个字符

```sql
SELECT SUBSTRING('成都融资事业部',5,3)
```

结果：事业部

4、`SUBSTRING(name,3)` 截取name这个字段 从第三个字符开始，之后的所有个字符

```sql
SELECT SUBSTRING('成都融资事业部',3)
```

结果：融资事业部

5、`SUBSTRING(name, -4)` 截取name这个字段的第 4 个字符位置（倒数）开始取，直到结束

```sql
SELECT SUBSTRING('成都融资事业部',\-4)
```

结果：资事业部

6、`SUBSTRING(name, -4，2)` 截取name这个字段的第 4 个字符位置（倒数）开始取，只截取之后的2个字符

```sql
SELECT SUBSTRING('成都融资事业部',\-4,2)
```

结果：资事

注意：我们注意到在函数 `substring(str,pos, len)` 中， pos 可以是负值，但 len 不能取负值。

7、`substring\_index('www.baidu.com', '.', 2)` 截取第二个 '.' 之前的所有字符

```sql
SELECT substring\_index('www.baidu.com', '.', 2)
```

结果：www.baidu

8、`substring\_index('www.baidu.com', '.', -2)` 截取第二个 '.' （倒数）之后的所有字符

```sql
SELECT substring\_index('www.baidu.com', '.', \-2)
```

结果：baidu.com

9、`SUBSTR(name, 1, CHAR\_LENGTH(name)-3)` 截取name字段，取除name字段后三位的所有字符

```sql
SELECT SUBSTR('成都融资事业部', 1, CHAR\_LENGTH('成都融资事业部')\-3) 
```

结果：成都融资