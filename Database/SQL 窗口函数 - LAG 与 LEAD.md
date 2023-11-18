  
`LAG()` Returns the value of expr from the row that lags (precedes) the current row by N rows within its partition. If there is no such row, the return value is default. 

`LEAD()` is the opposite of `LAG()`.

`LAG()` 从在其分区内滞后（先于）当前行 N 行的行返回表达式的值。如果没有这样的行，则返回值为默认值。

`LEAD()` 与 `LAG()` 相反

For example: 

if N is 3, the return value is default for the first two rows. If N or default are missing, the defaults are 1 and NULL, respectively.  N must be a literal nonnegative integer. If N is 0, expr is evaluated for the current row.  

例如：

如果 N 为 3，则返回值为前两行的默认值。如果缺少 N 或默认值，则默认值分别为 1 和 NULL。 N 必须是文字非负整数。如果 N 为 0，则为当前行计算 expr。

`LAG()`  \ `LEAD()` function are often used to compute differences between rows. The following query shows a set of time-ordered observations and, for each one, the `LAG()` and `LEAD()` values from the adjoining rows, as well as the differences between the current and adjoining rows:

`LAG()` \ `LEAD()` 函数通常用于计算行之间的差异。以下查询显示了一组按时间排序的观察结果，以及相邻行的 `LAG()` 和 `LEAD()` 值，以及当前行和相邻行之间的差异：

```sql
SELECT t,  
       val,  
       LAG(val) OVER w        AS 'lag',  
       LEAD(val) OVER w       AS 'lead',  
       val - LAG(val) OVER w  AS 'lag diff',  
       val - LEAD(val) OVER w AS 'lead diff'  
FROM series  
    WINDOW w AS (ORDER BY t);
```

```
+----------+------+------+------+----------+-----------+
| t        | val  | lag  | lead | lag diff | lead diff |
+----------+------+------+------+----------+-----------+
| 12:00:00 |  100 | NULL |  125 |     NULL |       -25 |
| 13:00:00 |  125 |  100 |  132 |       25 |        -7 |
| 14:00:00 |  132 |  125 |  145 |        7 |       -13 |
| 15:00:00 |  145 |  132 |  140 |       13 |         5 |
| 16:00:00 |  140 |  145 |  150 |       -5 |       -10 |
| 17:00:00 |  150 |  140 |  200 |       10 |       -50 |
| 18:00:00 |  200 |  150 | NULL |       50 |      NULL |
+----------+------+------+------+----------+-----------+
```

In the example, the `LAG()` and `LEAD()` calls use the default N and default values of 1 and NULL, respectively. 

在示例中，`LAG()` 和 `LEAD()` 调用分别使用默认 `N = 1`  和默认 `values = NULL` 。

The first row shows what happens when there is no previous row for `LAG()`: The function returns the default value (in this case, NULL). The last row shows the same thing when there is no next row for `LEAD()`.  `LAG()` and `LEAD()` also serve to compute sums rather than differences. Consider this data set, which contains the first few numbers of the Fibonacci series:

第一行显示当 `LAG()` 没有前一行时会发生什么：该函数返回默认值（在本例中为 NULL）。当 `LEAD()` 没有下一行时，最后一行显示相同的内容。 `LAG()` 和 `LEAD()` 也用于计算总和而不是差异。考虑这个数据集，它包含斐波那契数列的前几个数字：


```sql
SELECT n FROM fib ORDER BY n;
```

```
+------+
| n    |
+------+
|    1 |
|    1 |
|    2 |
|    3 |
|    5 |
|    8 |
+------+
```
The following query shows the `LAG()` and `LEAD()` values for the rows adjacent to the current row. It also uses those functions to add to the current row value the values from the preceding and following rows. The effect is to generate the next number in the Fibonacci series, and the next number after that:

以下查询显示与当前行相邻的行的 `LAG()` 和 `LEAD()` 值。它还使用这些函数将来自前后行的值添加到当前行值。效果是生成斐波那契数列中的下一个数字，以及之后的下一个数字：

```sql
SELECT n,  
       LAG(n, 1, 0) OVER w      AS 'lag',  
       LEAD(n, 1, 0) OVER w     AS 'lead',  
       n + LAG(n, 1, 0) OVER w  AS 'next_n',  
       n + LEAD(n, 1, 0) OVER w AS 'next_next_n'  
FROM fib  
    WINDOW w AS (ORDER BY n);
```


```
+------+------+------+--------+-------------+
| n    | lag  | lead | next_n | next_next_n |
+------+------+------+--------+-------------+
|    1 |    0 |    1 |      1 |           2 |
|    1 |    1 |    2 |      2 |           3 |
|    2 |    1 |    3 |      3 |           5 |
|    3 |    2 |    5 |      5 |           8 |
|    5 |    3 |    8 |      8 |          13 |
|    8 |    5 |    0 |     13 |           8 |
+------+------+------+--------+-------------+
```