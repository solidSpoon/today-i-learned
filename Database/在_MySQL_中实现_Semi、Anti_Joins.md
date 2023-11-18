# Implementing Semi, Anti Joins in MySQL
## Quick Word
SQL Joins are used to combine and retrieve data from multiple tables in an RDBMS. Most of the business objectives can be achieved using primitive Joins (Inner, Left, Right, Outer, Cross), however sometimes we come across scenarios where some complex operations are needed with joins, like combine the data from multiple tables but retrieve columns from just one table. In such scenarios, Semi and Anti joins come to rescue.

SQL 连接用于从 RDBMS 中的多个表中组合和检索数据。大多数业务目标都可以使用原始连接（Inner, Left, Right, Outer, Cross）来实现，但是有时我们会遇到需要使用连接进行一些复杂操作的场景，例如组合来自多个表的数据但只从多个表中检索列一张桌子。在这种情况下，Semi 和 Anti join 可以提供帮助。

**Left Semi Join** means a Half Join that returns records from the left table, when matching records are found in the right table. Even if more than one match is found in the right table for a given record, the result contains that record just once.

**Left Semi Join** 表示当在右表中找到匹配记录时，从左表返回记录的半连接。即使在给定记录的正确表中找到多个匹配项，结果也只包含该记录一次。

## Example

Let’s understand this concept with the help of an example.

There are two tables: _tblTeamA_ and _tblTeamB_ that contain records from a pool of players with their Name, Skill and Age. A player can be choosen for both the teams.

有两个表：_tblTeamA_ 和 _tblTeamB_，其中包含来自玩家池的记录以及他们的姓名、技能和年龄。可以为两支球队选择一名球员。

Creating tables：
![Creating tables](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/20220130101742.png)

Populating tblTeamA：
![Populating tblTeamA](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/20220130101851.png)

Populating tblTeamB：
![Populating tblTeamB](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/20220130101901.png)

Following are few use-cases:

1. Find the players who are selected for both the teams.
2. Find the players who are selected just for Team A.
3. Find the players who are selected just for Team B.

1. 找到为两支球队选择的球员。 
2. 找出只为 A 队选中的球员。 
3. 找出只为 B 队选中的球员。

In addition, the result shall contain a player just once, there is no point to list the same player twice (rows from both the tables).

此外，结果应仅包含一个玩家，没有必要将同一玩家列出两次（两个表中的行）。

### 1 - Find the players who are selected for both the teams.

![img](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/20220130101928.png)

The EXISTS clause in the above query, is used to implement the Left Semi Join. The query compares records from left table with records in right table. If a match is found, the rows from left table are returned.

上述查询中的 EXISTS 子句用于实现 Left Semi Join。该查询将左表中的记录与右表中的记录进行比较。如果找到匹配项，则返回左表中的行。

### 2 - Find the players who are selected just for Team A.

![img](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/20220130103020.png)

Using NOT with EXISTS clause excludes the common records in both the tables and hence return the unique records from left table that do not exists in right table.

将 NOT 与 EXISTS 子句一起使用会排除两个表中的公共记录，从而返回左表中不存在于右表中的唯一记录。

### 3 - Find the players who are selected just for Team B.

![img](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/20220130102013.png)

**Anti Join** is also used to find records in one table that are unavailable in other table. Here a RIGHT JOIN is combined with WHERE clause to implement the anti join.

**Anti Join** 也用于在一个表中查找其他表中不可用的记录。这里将 RIGHT JOIN 与 WHERE 子句结合来实现 anti join。

## Summary

Left Semi or Left Anti might sound fancy, however their implementation is not that complex. Unlike primitive joins, a semi or anti join does not have their own syntax but can be implemented by combination of basic join(s) and some clauses.

Left Semi 或 Left Anti 可能听起来很花哨，但它们的实现并不复杂。与原始连接不同，半连接或反连接没有自己的语法，但可以通过基本连接和一些子句的组合来实现。

---

原文链接：https://medium.com/analytics-vidhya/implementing-semi-anti-joins-in-mysql-342dd7f3da43
