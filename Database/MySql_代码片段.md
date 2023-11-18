MySql 递增序列填充某一列

```sql
SET @rnd := 1666666666666;  
UPDATE t_core_goods SET goods_code = (@rnd := @rnd + 1)  
WHERE goods_code = '' ORDER BY RAND();
```

指定长度随机数填充某一列

前面补 0

```sql
SELECT LPAD(FLOOR(1 + RAND() * 10000000000000), 13, 0);
```

后面补 0
```sql
SELECT RPAD(FLOOR(1 + RAND() * 10000000000000), 13, 0);
```

去重
```sql
# 去重  
UPDATE t_core_goods  
SET deleted = 1,  
    expire = 1 # 标记一下改了哪些数据  
WHERE id NOT IN  
 (SELECT hd.minid FROM (SELECT MIN(id) AS minid FROM t_core_goods WHERE deleted = 0 GROUP BY item_no) hd);
```

建表时 SQL 指定字符集与存储引擎

```sql
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
```

判断空字符串

An empty field can be either an empty string or a `NULL`.

To handle both, use:

```sql
select !IFNULL(emall > '', 0);
```

return 1 if email is empty