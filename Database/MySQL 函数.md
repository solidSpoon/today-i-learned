# MySQL 函数

## 算数函数

📝 `ABS()` 取绝对值

`SELECT ABS(-2)` 👉 2

📝 `MOD()` 取余

`SELECT(MOD101, 3)` 👉 2

📝 `ROUND()` 四舍五入为指定的小数位数

`ROUND(37.25, 1)` 👉 37.3

## 字符串函数

📝 `CONCAT()` 拼接字符串

`SELECT CONCAT('abc', 123)` 👉 abc123

📝 `LENGTH()` 计算字段长度，一个汉字算三个字符，一个数字或字母算一个字符

📝 `CHAR_LENGTH()` 计算字段的长度，汉字数字字母都算一个字符

📝 `LOWER()` 转小写

📝 `UPPER()` 转大写

📝 `REPLACE()` 替换函数

`SELECT REPLACE('fabcd', 'abc', 123)` 👉 f123d

📝 `SUBSTRING()` 截取字符串

`SELECT SUBSTRING('fabcd', 1,3)` 👉 fab

## 日期函数

📝 `CURRENT_DATE()` 系统当前日期 2021-10-24

📝 `CURRENT_TIME()` 系统当前时间 21:26:34

📝 `CURRENT_TIMESTAMP()` 系统当前日期时间 2021-10-24 21:26:34

📝 `EXTRACT()` 抽取年月日

`SELECT EXTRACT(YEAR FROM '2019-04-03')` 👉 2019

📝`DATE()` , `YEAR()` , `MONTH()` , `DAY()` , `HOUR()` , `MINUTE()` , `SECOND()`

`SELECT DATE('2019-04-01 12:00:05')` 👉 2019-04-01

## 转换函数

📝 `CAST()`

`SELECT CAST(123.456 AS UNSIGNED )` 👉 123

> 根据[文档](https://dev.mysql.com/doc/refman/8.0/en/cast-functions.html#function_cast)，CAST() 的结果类型为一下几种
> 
> -   `CHAR[(N)]`
> -   `DATE`
> -   `DATETIME`
> -   `DECIMAL[(M[,D])]`
> -   `SIGNED [INTEGER]`
> -   `TIME`
> -   `UNSIGNED [INTEGER]`

📝 `COALESCE()` 返回括号中第一个非空数值

`SELECT COALESCE(NULL, 1 , 3)` 👉 1